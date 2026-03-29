from PIL import Image, ImageDraw
import math
import os

os.makedirs("icons", exist_ok=True)

def draw_icon(size):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    s = size / 400  # scale factor
    
    # Background
    radius = int(90 * s)
    draw.rounded_rectangle([0, 0, size, size], radius=radius, fill="#2E7D32")
    
    # Child head
    cx, cy, r = int(160*s), int(135*s), int(45*s)
    draw.ellipse([cx-r, cy-r, cx+r, cy+r], fill="white")
    
    # Body
    draw.rounded_rectangle([int(128*s), int(178*s), int(192*s), int(258*s)],
                           radius=int(20*s), fill="white")
    
    # Left arm
    draw.rounded_rectangle([int(88*s), int(182*s), int(132*s), int(202*s)],
                           radius=int(10*s), fill="white")
    
    # Left leg
    draw.rounded_rectangle([int(132*s), int(252*s), int(154*s), int(307*s)],
                           radius=int(11*s), fill="white")
    
    # Right leg
    draw.rounded_rectangle([int(166*s), int(252*s), int(188*s), int(307*s)],
                           radius=int(11*s), fill="white")
    
    # Speech bubble
    draw.rounded_rectangle([int(185*s), int(75*s), int(325*s), int(165*s)],
                           radius=int(20*s), fill="white")
    
    # Bubble tail
    draw.polygon([
        (int(200*s), int(155*s)),
        (int(185*s), int(180*s)),
        (int(230*s), int(155*s))
    ], fill="white")
    
    # Symbol grid inside bubble
    draw.rounded_rectangle([int(200*s), int(90*s), int(230*s), int(112*s)],
                           radius=int(4*s), fill="#2E7D32")
    draw.rounded_rectangle([int(240*s), int(90*s), int(270*s), int(112*s)],
                           radius=int(4*s), fill="#66BB6A")
    draw.rounded_rectangle([int(200*s), int(120*s), int(230*s), int(142*s)],
                           radius=int(4*s), fill="#66BB6A")
    draw.rounded_rectangle([int(240*s), int(120*s), int(270*s), int(142*s)],
                           radius=int(4*s), fill="#2E7D32")
    
    return img

# All required iOS sizes
sizes = {
    "Icon-20": 20, "Icon-20@2x": 40, "Icon-20@3x": 60,
    "Icon-29": 29, "Icon-29@2x": 58, "Icon-29@3x": 87,
    "Icon-40": 40, "Icon-40@2x": 80, "Icon-40@3x": 120,
    "Icon-60@2x": 120, "Icon-60@3x": 180,
    "Icon-76": 76, "Icon-76@2x": 152,
    "Icon-83.5@2x": 167,
    "Icon-1024": 1024
}

for name, size in sizes.items():
    img = draw_icon(size)
    img.save(f"icons/{name}.png")
    print(f"✅ {name}.png ({size}x{size})")

print("\nAll icons generated in icons/ folder!")
