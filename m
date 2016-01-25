From: j00310691 <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 06/23] hisi_sas: rename some fields in hisi_sas_itct
Date: Tue, 26 Jan 2016 01:21:55 +0800
Message-ID: <1453742532-53092-7-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Since hisi_sas_itct format is different between v1
and v2 hw, give more general names for some fields.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
