From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4.X Avoid excessive recursion when setting device
	offline
Date: 29 Mar 2004 12:47:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080582471.2142.13.camel@mulgrave>
References: <387680000.1080580020@aslan.btc.adaptec.com>
	<1080581208.3570.10.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:65415 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263057AbUC2RsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 12:48:05 -0500
In-Reply-To: <1080581208.3570.10.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-03-29 at 12:26, Arjan van de Ven wrote:
> won't this achieve the same ?
> 
> diff -urN Linux/drivers/scsi/scsi_lib.c linux/drivers/scsi/scsi_lib.c
> --- Linux/drivers/scsi/scsi_lib.c       2002-10-03 16:50:07.000000000
> +0200
> +++ linux/drivers/scsi/scsi_lib.c       2002-10-03 17:33:20.000000000
> -       scsi_release_command(SCpnt);
> +       __scsi_release_command(SCpnt);

Yes, this patch is in 2.4.25 already.  I seem to recall that's why it
was applied several years ago (to prevent recursion), but it's too long
ago for me to remember (or even bitkeeper, since it's also in scsi_lib.c
version 1.1).

Exactly which version of 2.4 is exhibiting this problem?

James


