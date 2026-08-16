# Generated asset helper

# Requires ImageMagick (convert) and cwebp (libwebp) and curl

mkdir -p public/assets

# If original.png is missing but scripts/original_url.txt exists, attempt to download it
if [ ! -f public/assets/original.png ]; then
  if [ -f scripts/original_url.txt ]; then
    echo "public/assets/original.png not found — attempting to download from URL in scripts/original_url.txt"
    URL=$(cat scripts/original_url.txt | tr -d '\n' )
    if [ -n "$URL" ]; then
      echo "Downloading $URL ..."
      curl -L "$URL" -o public/assets/original.png || true
    fi
  fi
fi

if [ ! -f public/assets/original.png ]; then
  echo "Please put your original logo as public/assets/original.png or add a URL to scripts/original_url.txt and re-run this script"
  exit 1
fi

# hero (square)
convert public/assets/original.png -resize 1080x1080 -background none -gravity center -extent 1080x1080 public/assets/logo-hero.png
# OG
convert public/assets/original.png -resize 1200x630 -background white -gravity center -extent 1200x630 public/assets/logo-1200x630.png
# favicons / small
convert public/assets/original.png -resize 64x64 -background none -gravity center -extent 64x64 public/assets/logo-64.png
convert public/assets/original.png -resize 32x32 -background none -gravity center -extent 32x32 public/assets/logo-32.png
convert public/assets/original.png -resize 16x16 -background none -gravity center -extent 16x16 public/assets/logo-16.png
convert public/assets/original.png -resize 180x180 -background none -gravity center -extent 180x180 public/assets/logo-180.png

# webp versions
cwebp -q 80 public/assets/logo-hero.png -o public/assets/logo-hero.webp || true
cwebp -q 80 public/assets/logo-1200x630.png -o public/assets/logo-1200x630.webp || true

# favicon.ico (requires ImageMagick to support -colors)
convert public/assets/logo-16.png public/assets/logo-32.png public/assets/logo-64.png public/favicon.ico || true

echo "Generated assets in public/assets/. Please check files and commit them."
