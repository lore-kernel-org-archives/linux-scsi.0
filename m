From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH] IB/srp: Fix typo in source code comment
Date: Fri, 4 Dec 2009 20:34:22 +0100
Message-ID: <e2e108260912041134r77c306a6mc6fc6a5440db6262@mail.gmail.com>
References: <200912042020.47763.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46037 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZLDTeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2009 14:34:18 -0500
Received: by bwz27 with SMTP id 27so2223554bwz.21
        for <linux-scsi@vger.kernel.org>; Fri, 04 Dec 2009 11:34:22 -0800 (PST)
In-Reply-To: <200912042020.47763.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Fri, Dec 4, 2009 at 8:20 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
>
> Fixes a typo in the source-code comments in libsrp.c.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index 9ad38e8..0fc0aaf 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -1,5 +1,5 @@
> =A0/*
> - * SCSI RDAM Protocol lib functions
> + * SCSI RDMA Protocol lib functions
> =A0*
> =A0* Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
> =A0*

Please ignore the above patch -- it wasn't complete. I will send a new =
patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
