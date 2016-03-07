From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of failure
Date: Mon, 7 Mar 2016 07:56:57 +0530
Message-ID: <9b78cf6ac9416565ea777819b608a0c8@mail.gmail.com>
References: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:32787 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbcCGC1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2016 21:27:00 -0500
Received: by mail-vk0-f41.google.com with SMTP id k1so87144340vkb.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2016 18:27:00 -0800 (PST)
In-Reply-To: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, jayamohan.kallickal@avagotech.com
Cc: ketan.mukadam@avagotech.com, sony.john@avagotech.com, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Maurizio Lombardi
>Sent: Friday, March 04, 2016 3:12 PM
>To: jayamohan.kallickal@avagotech.com
>Cc: ketan.mukadam@avagotech.com; sony.john@avagotech.com; linux-
>scsi@vger.kernel.org
>Subject: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of
failure
>
>In beiscsi_setup_boot_info(), the boot_kset pointer should be set to NULL
in case
>of failure otherwise an invalid pointer dereference may occur later.
>
>Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>---
> drivers/scsi/be2iscsi/be_main.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/scsi/be2iscsi/be_main.c
b/drivers/scsi/be2iscsi/be_main.c
>index cb9072a..069e5c5 100644
>--- a/drivers/scsi/be2iscsi/be_main.c
>+++ b/drivers/scsi/be2iscsi/be_main.c
>@@ -4468,6 +4468,7 @@ put_shost:
> 	scsi_host_put(phba->shost);
> free_kset:
> 	iscsi_boot_destroy_kset(phba->boot_kset);
>+	phba->boot_kset = NULL;
> 	return -ENOMEM;
> }
>
>--
>Maurizio Lombardi
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of
>a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html

Reviewed-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Thanks,

JB
