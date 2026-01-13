#!/usr/bin/env bash
# Script to publish artifacts to Sonatype Central Portal
# Usage: ./publish-to-central.sh <deployment-name>

set -e

DEPLOYMENT_NAME="${1:-jvm-functional-utils-$(date +%s)}"
USERNAME="${MAVEN_CENTRAL_USERNAME}"
TOKEN="${MAVEN_CENTRAL_TOKEN}"

if [ -z "$USERNAME" ] || [ -z "$TOKEN" ]; then
    echo "Error: MAVEN_CENTRAL_USERNAME and MAVEN_CENTRAL_TOKEN must be set"
    exit 1
fi

echo "Publishing to Sonatype Central Portal..."
echo "Deployment name: $DEPLOYMENT_NAME"

# Build and publish to staging directory
./gradlew publishToMavenLocal --no-daemon

# Find the local Maven repository
MAVEN_LOCAL=~/.m2/repository/com/brentzey/functional

# Create a bundle
BUNDLE_DIR="build/bundle"
mkdir -p "$BUNDLE_DIR"

echo "Creating bundle from local Maven repository..."
cp -r "$MAVEN_LOCAL"/* "$BUNDLE_DIR/"

# Create zip file
cd "$BUNDLE_DIR"
zip -r "../${DEPLOYMENT_NAME}.zip" .
cd ../..

echo "Bundle created: build/${DEPLOYMENT_NAME}.zip"

# Upload to Central Portal
echo "Uploading to Central Portal..."
curl -v -X POST \
  --fail-with-body \
  -H "Authorization: Bearer $(echo -n $USERNAME:$TOKEN | base64)" \
  -F "bundle=@build/${DEPLOYMENT_NAME}.zip" \
  -F "publishingType=AUTOMATIC" \
  "https://central.sonatype.com/api/v1/publisher/upload?name=${DEPLOYMENT_NAME}"

echo ""
echo "✅ Published successfully!"
echo "Check status at: https://central.sonatype.com/publishing"
