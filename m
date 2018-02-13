From: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v8 5/5] arm64: defconfig: enable f2fs and squashfs
Date: Tue, 13 Feb 2018 18:14:12 +0800
Message-ID: <20180213101412.5717-6-liwei213@huawei.com>
References: <20180213101412.5717-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101412.5717-1-liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org, riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zangleigang-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, gengjianfeng-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, guodong.xu-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fengbaopeng-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Partitions in HiKey960 are formatted as f2fs and squashfs.
f2fs is for userdata; squashfs is for system. Both partitions are required
by Android.

Signed-off-by: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhangfei Gao <zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Guodong Xu <guodong.xu-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
