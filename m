From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] megaraid_sas: insert missing space in kernel message
Date: Wed, 10 Jun 2015 11:59:42 +0530
Message-ID: <e7d8e98d9cc2276cd576a987d762e16b@mail.gmail.com>
References: <1433865223-15310-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:33198 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbbFJG3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2015 02:29:46 -0400
Received: by qcnj1 with SMTP id j1so14087785qcn.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2015 23:29:45 -0700 (PDT)
In-Reply-To: <1433865223-15310-1-git-send-email-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Colin King [mailto:colin.king@canonical.com]
>Sent: Tuesday, June 09, 2015 9:24 PM
>To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley;
>megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>Subject: [PATCH] megaraid_sas: insert missing space in kernel message
>
>From: Colin Ian King <colin.king@canonical.com>
>
>The printk format specifier string is missing a space between the %p
format
>specifier and the "on the defer" text. Minor fix, add the missing space.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 890637f..4889ef6 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -3148,7 +3148,7 @@ megasas_internal_reset_defer_cmds(struct
>megasas_instance *instance)
> 		cmd = instance->cmd_list[i];
> 		if (cmd->sync_cmd == 1 || cmd->scmd) {
> 			printk(KERN_NOTICE "megasas: moving
>cmd[%d]:%p:%d:%p"
>-					"on the defer queue as
internal\n",
>+					" on the defer queue as
internal\n",
> 				defer_index, cmd, cmd->sync_cmd, cmd-
>>scmd);
>
> 			if (!list_empty(&cmd->list)) {
Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>2.1.4
