from PIL import Image

# Open the icon
img = Image.open("Icon-1024.png")

# Convert to RGB (removes alpha channel)
rgb_img = img.convert("RGB")

# Save without transparency
rgb_img.save("Icon-1024-fixed.png")
print("✅ Fixed icon saved!")
