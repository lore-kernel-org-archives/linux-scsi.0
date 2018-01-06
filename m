From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v7 5/5] arm64: defconfig: enable f2fs and squashfs
Date: Sat, 6 Jan 2018 17:51:17 +0800
Message-ID: <20180106095117.67907-6-liwei213@huawei.com>
References: <20180106095117.67907-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180106095117.67907-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, guodong.xu@linaro.org, zhangfei.gao@linaro.org, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

Partitions in HiKey960 are formatted as f2fs and squashfs.
f2fs is for userdata; squashfs is for system. Both partitions are required
by Android.

Signed-off-by: Li Wei <liwei213@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 arch/arm64/configs/defconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index fa6f921eed86..7be4ee2ac680 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -572,6 +572,7 @@ CONFIG_ACPI_APEI_GHES=y
 CONFIG_ACPI_APEI_PCIEAER=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
+CONFIG_F2FS_FS=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_BTRFS_FS=m
 CONFIG_BTRFS_FS_POSIX_ACL=y
@@ -587,6 +588,13 @@ CONFIG_HUGETLBFS=y
 CONFIG_CONFIGFS_FS=y
 CONFIG_EFIVAR_FS=y
 CONFIG_SQUASHFS=y
+CONFIG_SQUASHFS_FILE_DIRECT=y
+CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
+CONFIG_SQUASHFS_XATTR=y
+CONFIG_SQUASHFS_LZ4=y
+CONFIG_SQUASHFS_LZO=y
+CONFIG_SQUASHFS_XZ=y
+CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_NFS_V4_1=y
-- 
2.15.0
