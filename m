From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sun, 05 Nov 2006 08:12:29 +0900
Message-ID: <1162681950.3630.9.camel@mulgrave.il.steeleye.com>
References: <335122.2750.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:12759 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965739AbWKDXMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 18:12:36 -0500
In-Reply-To: <335122.2750.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2006-11-04 at 11:54 -0800, Luben Tuikov wrote:
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/sd.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> This patch is 8 months old.

Um:

patching file drivers/scsi/sd.c
Hunk #1 FAILED at 1354.
Hunk #2 FAILED at 1382.
2 out of 2 hunks FAILED -- saving rejects to file drivers/scsi/sd.c.rej

I think the code you're trying to change has altered a bit in the latest
kernels.

James


