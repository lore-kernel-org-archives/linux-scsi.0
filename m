From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] scsi: megaraid_sas: add in missing white space in error
 message text
Date: Tue, 13 Sep 2016 17:21:44 +0530
Message-ID: <00f54f55ea53b9b06742c4a9db1d6ee1@mail.gmail.com>
References: <20160912124212.32132-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160912124212.32132-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Colin King [mailto:colin.king@canonical.com]
>Sent: Monday, September 12, 2016 6:12 PM
>To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E . J . Bottomley;
>Martin K
>. Petersen; megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>Subject: [PATCH] scsi: megaraid_sas: add in missing white space in error
>message
>text
>
>From: Colin Ian King <colin.king@canonical.com>
>
>A dev_printk message spans two lines and the literal string is missing a
>white
>space between words. Add the white space.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 2d62d71..c236c4d 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -5782,7 +5782,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
> 					     &instance->consumer_h);
>
> 		if (!instance->producer || !instance->consumer) {
>-			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to
>allocate"
>+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to
>allocate "
> 			       "memory for producer, consumer\n");
> 			goto fail_alloc_dma_buf;
> 		}
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
>--
>2.9.3
