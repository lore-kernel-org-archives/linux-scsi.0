From: John Garry <john.garry@huawei.com>
Subject: [RESEND PATCH v2 06/23] hisi_sas: rename some fields in hisi_sas_itct
Date: Tue, 26 Jan 2016 02:47:06 +0800
Message-ID: <1453747643-61875-7-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Since hisi_sas_itct format is different between v1
and v2 hw, give more general names for some fields.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index e5a58c5..b2e4b26 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -248,18 +248,7 @@ struct hisi_sas_itct {
 	__le64 sas_addr;
 	__le64 qw2;
 	__le64 qw3;
-	__le64 qw4;
-	__le64 qw_sata_ncq0_3;
-	__le64 qw_sata_ncq7_4;
-	__le64 qw_sata_ncq11_8;
-	__le64 qw_sata_ncq15_12;
-	__le64 qw_sata_ncq19_16;
-	__le64 qw_sata_ncq23_20;
-	__le64 qw_sata_ncq27_24;
-	__le64 qw_sata_ncq31_28;
-	__le64 qw_non_ncq_iptt;
-	__le64 qw_rsvd0;
-	__le64 qw_rsvd1;
+	__le64 qw4_15[12];
 };
 
 struct hisi_sas_iost {
-- 
1.9.1
