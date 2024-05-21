#!/bin/bash

script_dir="$( cd "$( dirname "${0}" )" && pwd )"
project_dir="$(dirname "$script_dir")"

workspace="$project_dir/TokenEx.xcworkspace"
scheme="TokenExMobileAPI"
framework="$scheme.framework"

# Cleaning the workspace cache
xcodebuild \
    clean \
    -workspace "$workspace" \
    -scheme "$scheme"

# Create an archive for iOS devices
rm -rf "$project_dir/build/$scheme-iOS.xcarchive/"
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace "$workspace" \
        -scheme "$scheme" \
        -configuration Release \
        -destination "generic/platform=iOS" \
        -archivePath "build/$scheme-iOS.xcarchive"

# Create an archive for iOS simulators
rm -rf "$project_dir/build/$scheme-iOS_Simulator.xcarchive/"
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace "$workspace" \
        -scheme "$scheme" \
        -configuration Release \
        -destination "generic/platform=iOS Simulator" \
        -archivePath "build/$scheme-iOS_Simulator.xcarchive"

# Convert the archives to .framework
# and package them both into one xcframework
rm -rf "$project_dir/build/$scheme.xcframework/"
xcodebuild \
    -create-xcframework \
    -archive "build/$scheme-iOS.xcarchive" -framework "$framework" \
    -archive "build/$scheme-iOS_Simulator.xcarchive" -framework "$framework" \
    -output "build/$scheme.xcframework"
