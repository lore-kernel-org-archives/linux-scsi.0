From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH 1/1] scsi/megaraid: minor cut and paste error fixed.
Date: Fri, 28 Jun 2013 11:22:26 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF4139FF3C4BC@inbmail01.lsi.com>
References: <1372269799-9835-1-git-send-email-soulpa7ch@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1372269799-9835-1-git-send-email-soulpa7ch@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Georgas <soulpa7ch@gmail.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks James for pointing this out, there is no harm with this change.

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Sumit

>-----Original Message-----
>From: James Georgas [mailto:soulpa7ch@gmail.com]
>Sent: Wednesday, June 26, 2013 11:33 PM
>To: DL-MegaRAID Linux; JBottomley@parallels.com
>Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; James
>Georgas
>Subject: [PATCH 1/1] scsi/megaraid: minor cut and paste error fixed.
>
>This looks like a cut and paste typo to me. Both of the
>megasas_read_fw_status_reg_* functions involved are identical though, so
>there was no bad behaviour. I changed it for consistency and clarity.
>
>Signed-off-by: James Georgas <soulpa7ch@gmail.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 3a9ddae..87591cd 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -583,7 +583,7 @@ megasas_clear_intr_skinny(struct
>megasas_register_set __iomem *regs)
> 	/*
> 	 * Check if it is our interrupt
> 	 */
>-	if ((megasas_read_fw_status_reg_gen2(regs) & MFI_STATE_MASK) ==
>+	if ((megasas_read_fw_status_reg_skinny(regs) & MFI_STATE_MASK) ==
> 	    MFI_STATE_FAULT) {
> 		mfiStatus = MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
> 	} else
>--
>1.8.1.5
>
