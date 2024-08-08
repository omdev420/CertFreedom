#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pem_file=$(find . -maxdepth 1 -type f -name "*.pem" -print -quit)

if [[ -z $pem_file ]]; then
  echo -e "${RED}❌ No .pem file found in the current directory.${NC}"
  exit 1
fi

hashed_name=$(openssl x509 -inform PEM -subject_hash_old -in "$pem_file" | head -1)
cp "$pem_file" "$hashed_name.0"

echo -e "${GREEN}✅ Generated $hashed_name.0 file.${NC}"