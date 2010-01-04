From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH] SCSI/libsrp: fix typo -- replace RDAM by RDMA
Date: Mon, 4 Jan 2010 12:37:47 +0100
Message-ID: <e2e108261001040337i3cf5bf3cp69cb6b8abfc4fa43@mail.gmail.com>
References: <200912042038.49266.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47010 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0ADLht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 06:37:49 -0500
Received: by ewy19 with SMTP id 19so7158335ewy.21
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2010 03:37:47 -0800 (PST)
In-Reply-To: <200912042038.49266.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Fri, Dec 4, 2009 at 8:38 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
>
> Fixed a typo in libsrp.c: replaced two occurrences of 'RDAM' by 'RDMA=
'.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index 9ad38e8..f5bfbc5 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -1,5 +1,5 @@
> =A0/*
> - * SCSI RDAM Protocol lib functions
> + * SCSI RDMA Protocol lib functions
> =A0*
> =A0* Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
> =A0*
> @@ -439,6 +439,6 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct=
 srp_cmd *cmd, void *info,
> =A0}
> =A0EXPORT_SYMBOL_GPL(srp_cmd_queue);
>
> -MODULE_DESCRIPTION("SCSI RDAM Protocol lib functions");
> +MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
> =A0MODULE_AUTHOR("FUJITA Tomonori");
> =A0MODULE_LICENSE("GPL");

Hello Fujita,

Did you perhaps miss the above e-mail ? It's now one month ago that I
posted this patch, and I still did not receive an ACK or NAK.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
