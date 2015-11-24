From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RESEND] scsi_debug: fix prevent_allow+verify regressions
Date: Tue, 24 Nov 2015 10:25:41 -0500
Message-ID: <1448378741.4067.74.camel@localhost.localdomain>
References: <5651F740.3010707@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbbKXPZm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 10:25:42 -0500
In-Reply-To: <5651F740.3010707@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>, "James E.J. Bottomley" <jbottomley@odin.com>, SCSI development list <linux-scsi@vger.kernel.org>, sweet_f_a@gmx.de, util-linux@vger.kernel.org

On Sun, 2015-11-22 at 12:11 -0500, Douglas Gilbert wrote:
> Ruediger Meier observed a regression with the PREVENT ALLOW
> MEDIUM REMOVAL command in lk 3.19:
>    http://www.spinics.net/lists/util-linux-ng/msg11448.html
> 
> Inspection indicated the same regression with VERIFY(10).
> 
> The patch is against lk 3.19.3 and also works with lk 4.3.0 .
> With this patch both commands are accepted and do nothing.
> 
> ChangeLog:
>    - fix the lk 3.19 regression so that the PREVENT ALLOW
>      MEDIUM REMOVAL command is supported once again
>    - same fix for VERIFY(10)
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


