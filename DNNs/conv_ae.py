import torch
import torch.nn as nn
import torch.optim as optim
import torchvision.transforms as transforms
from torch.utils.data import Dataset, DataLoader
from torch.utils.tensorboard import SummaryWriter
import matplotlib.pyplot as plt
from PIL import Image
import os
import time  # Import the time module

# Hyperparameters
LEARNING_RATE = 0.0005
BATCH_SIZE = 50
NUM_EPOCHS = 30
LOG_DIR = "runs/autoencoder_experiment"  # Directory for TensorBoard logs

# Define the custom dataset
class FlatImageDataset(Dataset):
    def __init__(self, root_dir, transform=None):
        self.root_dir = root_dir
        self.transform = transform
        self.image_paths = [os.path.join(root_dir, file) for file in os.listdir(root_dir) if file.endswith('.png')]

    def __len__(self):
        return len(self.image_paths)

    def __getitem__(self, idx):
        image_path = self.image_paths[idx]
        image = Image.open(image_path).convert('L')  # Convert to grayscale
        if self.transform:
            image = self.transform(image) # Apply a separate transform
        patches = self.extract_patches(image)
        return patches

    def extract_patches(self, image):
        patches = []
        for i in range(8, image.size(1) - 8):
            for j in range(8, image.size(2) - 8):
                patch = image[:, i-8:i+9, j-8:j+9]  # Extract 17x17 patch
                patches.append(patch)
        return torch.stack(patches)

# Define the autoencoder architecture
class Autoencoder(nn.Module):
    def __init__(self):
        super(Autoencoder, self).__init__()
        self.encoder = nn.Sequential(
            nn.Conv2d(1, 16, kernel_size=3, stride=1, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(16, 8, kernel_size=3, stride=1, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Flatten(),
            nn.Linear(8*4*4, 10)  # Adjusted for 17x17 input patches
        )
        self.decoder = nn.Sequential(
            nn.Linear(10, 8*4*4),
            nn.Unflatten(1, (8, 4, 4)),
            nn.ConvTranspose2d(8, 16, kernel_size=3, stride=2, padding=1, output_padding=1),
            nn.ReLU(),
            nn.ConvTranspose2d(16, 1, kernel_size=3, stride=2, padding=1, output_padding=1),
            nn.Sigmoid()
        )
         
    def forward(self, x):
        encoded = self.encoder(x)
        decoded = self.decoder(encoded)
        return encoded, decoded

# Define the transform
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5,), (0.5,))
])

# Load the datasets
train_data = FlatImageDataset('Data/trainingData', transform=transform)
train_loader = DataLoader(train_data, batch_size=BATCH_SIZE, shuffle=True)

# Print the total number of patches for training...
total_patches = len(train_loader) * BATCH_SIZE
print(f'Total number of patches: {total_patches}')

val_data = FlatImageDataset('Data/validationData', transform=transform)
val_loader = DataLoader(val_data, batch_size=BATCH_SIZE, shuffle=False)

test_data = FlatImageDataset('Data/testingData', transform=transform)
test_loader = DataLoader(test_data, batch_size=BATCH_SIZE, shuffle=False)

# Check the device
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f'Running on the {"GPU" if device.type == "cuda" else "CPU"}')
model = Autoencoder().to(device)

# Initialize the loss function and optimizer
criterion = nn.MSELoss()
optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)
writer = SummaryWriter(log_dir=LOG_DIR)

# Path to save model
model_save_path = "model.pt"

# Minimum validation loss
min_val_loss = float('inf')

# Training and validation loop
for epoch in range(NUM_EPOCHS):
    start_time = time.time()  # Record the start time for the epoch
    # Training
    model.train()
    train_loss = 0.0
    for data in train_loader:
        images = data.view(-1, 1, 17, 17).to(device)  # Reshape patches to [N, 1, 17, 17]
        encoded, outputs = model(images)
        loss = criterion(outputs, images)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        train_loss += loss.item() * images.size(0)
    train_loss = train_loss / len(train_loader.dataset)
    writer.add_scalar('Training Loss', train_loss, epoch)

    # Validation
    model.eval()
    val_loss = 0.0
    with torch.no_grad():
        for data in val_loader:
            images = data.view(-1, 1, 17, 17).to(device)
            encoded, outputs = model(images)
            loss = criterion(outputs, images)
            val_loss += loss.item() * images.size(0)
    val_loss = val_loss / len(val_loader.dataset)
    writer.add_scalar('Validation Loss', val_loss, epoch)

    print('Epoch: {} \tRuntime: {:.2f} s \tTraining Loss: {:.6f} \tValidation Loss: {:.6f}'.format(epoch+1, time.time() - start_time, train_loss, val_loss))

    # Save the model if validation loss has decreased
    if val_loss < min_val_loss:
        print('Validation loss decreased ({:.6f} --> {:.6f}).  Saving model ...'.format(min_val_loss, val_loss))
        torch.save(model.state_dict(), model_save_path)
        min_val_loss = val_loss

# Close the TensorBoard writer
writer.close()

# Testing and reconstruction visualization
with torch.no_grad():
    test_loss = 0.0
    encoded_features = []
    for data in test_loader:
        images = data.view(-1, 1, 17, 17).to(device)
        encoded, outputs = model(images)
        encoded_features.append(encoded)
        loss = criterion(outputs, images)
        test_loss += loss.item() * images.size(0)
    test_loss = test_loss / len(test_loader.dataset)
    print(f'Test loss: {test_loss:.6f}')

# Visualize the encoded features for the first batch
encoded_features = torch.cat(encoded_features, dim=0).cpu().numpy()
print("First batch encoded features (10D vectors):")
print(encoded_features[:10])

# Reconstruction visualization
with torch.no_grad():
    for data in test_loader:
        images
