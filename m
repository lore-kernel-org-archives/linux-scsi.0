From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v11 4/4] [RESEND] arm64: defconfig: enable configs for Hisilicon ufs
Date: Tue, 17 Jul 2018 17:36:59 +0800
Message-ID: <20180717093659.103263-5-liwei213@huawei.com>
References: <20180717093659.103263-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717093659.103263-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, sunzhaosheng@hisilicon.com, ian.rickards@arm.com, guodong.xu@linaro.org, puck.chen@hisilicon.com, john.stultz@linaro.org, liwei213@huawei.com, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Li Wei <liwei213@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
Tested-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index f9a186f6af8a..2c07e233012b 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -193,6 +193,7 @@ CONFIG_SCSI_HISI_SAS=y
 CONFIG_SCSI_HISI_SAS_PCI=y
 CONFIG_SCSI_UFSHCD=m
 CONFIG_SCSI_UFSHCD_PLATFORM=m
+CONFIG_SCSI_UFS_HISI=y
 CONFIG_SCSI_UFS_QCOM=m
 CONFIG_ATA=y
 CONFIG_SATA_AHCI=y
-- 
2.15.0
