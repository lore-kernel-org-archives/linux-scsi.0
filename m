From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v3 4/5] arm64: defconfig: enable configs for Hisilicon ufs
Date: Tue, 29 Aug 2017 16:41:15 +0800
Message-ID: <20170829084116.106695-5-liwei213@huawei.com>
References: <20170829084116.106695-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5030 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdH2Iln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 04:41:43 -0400
In-Reply-To: <20170829084116.106695-1-liwei213@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: guodong.xu@linaro.org, fengbaopeng@hisilicon.com

This enable configs for Hisilicon Hixxxx UFS driver.

Signed-off-by: Li Wei <liwei213@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 arch/arm64/configs/defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index b4ca115b3be1..7514ecf08f2a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -164,6 +164,9 @@ CONFIG_EEPROM_AT25=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_SAS_ATA=y
 CONFIG_SCSI_HISI_SAS=y
+CONFIG_SCSI_UFSHCD=y
+CONFIG_SCSI_UFSHCD_PLATFORM=y
+CONFIG_SCSI_UFS_HISI=y
 CONFIG_ATA=y
 CONFIG_SATA_AHCI=y
 CONFIG_SATA_AHCI_PLATFORM=y
-- 
2.11.0
