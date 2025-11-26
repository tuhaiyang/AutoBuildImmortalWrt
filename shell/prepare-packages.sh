#!/bin/sh

BASE_DIR="extra-packages"
TEMP_DIR="$BASE_DIR/temp-unpack"
TARGET_DIR="packages"

# 清理旧的目录
rm -rf "$TEMP_DIR" "$TARGET_DIR"
mkdir -p "$TEMP_DIR" "$TARGET_DIR"
# 下载kms服务器ipk文件
curl -L -o "$TARGET_DIR"/luci-app-vlmcsd_1.0.4-1_all.ipk \
            https://github.com/siwind/luci-app-vlmcsd/releases/download/v1.0.4/luci-app-vlmcsd_1.0.4-1_all.ipk

curl -L -o "$TARGET_DIR"/vlmcsd_svn1113-1_aarch64_cortex-a53.ipk \
            https://github.com/cokebar/openwrt-vlmcsd/raw/refs/heads/gh-pages/vlmcsd_svn1113-1_aarch64_cortex-a53.ipk
# 解压 .run 文件
for run_file in "$BASE_DIR"/*.run; do
    [ -e "$run_file" ] || continue
    echo "🧩 解压 $run_file -> $TEMP_DIR"
    sh "$run_file" --target "$TEMP_DIR" --noexec
done

# 1. 收集 run 解压出的 .ipk 文件
find "$TEMP_DIR" -type f -name "*.ipk" -exec cp -v {} "$TARGET_DIR"/ \;

# 2. 收集 extra-packages/*/ 下的 .ipk 文件（只查一级子目录）

find "$BASE_DIR" -mindepth 2 -maxdepth 2 -type f -name "*.ipk" ! -path "$TEMP_DIR/*" \
  -exec echo "👉 Found:" {} \; \
  -exec cp -v {} "$TARGET_DIR"/ \;

echo "✅ 所有 .ipk 文件已整理至 $TARGET_DIR/"
