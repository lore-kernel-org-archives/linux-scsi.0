From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/3] hisi_sas: add device tree support for hip07
Date: Tue, 4 Oct 2016 19:11:10 +0800
Message-ID: <1475579471-11308-3-git-send-email-john.garry@huawei.com>
References: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475579471-11308-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Chipset hip07 incorporates v2 hw.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9825a3f..758e06f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2319,6 +2319,7 @@ static int hisi_sas_v2_remove(struct platform_device *pdev)
 
 static const struct of_device_id sas_v2_of_match[] = {
 	{ .compatible = "hisilicon,hip06-sas-v2",},
+	{ .compatible = "hisilicon,hip07-sas-v2",},
 	{},
 };
 MODULE_DEVICE_TABLE(of, sas_v2_of_match);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
