From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 19/33] scsi_debug: support sg chaining
Date: Tue, 17 Jul 2007 16:40:56 +0300
Message-ID: <469CC6E8.7060702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15113 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbXGQNlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 09:41:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, dgilbert@interlog.com

Jens Axboe wrote ...
> Cc: dgilbert@interlog.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/scsi_debug.c |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4cd9c58..46a3e07 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

(Majordumo has unsubscribed me from list since yesterday)
(Don't know why. So this will appear out of order       )

Jens Hi!

I have queued for submission a: 
"convert to use the data buffer accessors and !use_sg cleanup"
for this driver Just the other day. Should we not push the 
cleanups first before this. That is what we did with other
drivers.

I have also sent patches for ide-scsi

I Have in my Q cleanup patches for:
drivers/scsi/qla1280.c
drivers/scsi/qlogicpti.c
drivers/scsi/aha1542.c
drivers/scsi/advansys.c
And more ...

And also for this one
drivers/scsi/gdth.c
But that one has a patch in Q and I should rebase.

If you want I can rebase all your driver patches above
to my patches. Than send cleanup patches to the list and
rebasing of sg-chaining if needed to you. I can send all
cleanup patches tonight, and your rebases tomorrow.

Boaz

