From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O
	to device being removed"
Date: Tue, 07 Nov 2006 07:16:14 +0900
Message-ID: <1162851375.4551.6.camel@mulgrave.il.steeleye.com>
References: <20061105113628.GU13555@kernel.dk>
	 <267953.40180.qm@web31808.mail.mud.yahoo.com>
	 <20061106210023.GJ19471@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:11159 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1753865AbWKFWQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 17:16:44 -0500
In-Reply-To: <20061106210023.GJ19471@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-11-06 at 22:00 +0100, Jens Axboe wrote:
> So, again, I'll ask James' (this time cc'ed) opinion on what he thinks.
> Perhaps he agrees that we should go the ratelimit route, or perhaps he
> likes your version.  If the former, I'll be happy to code that up
> (should be a 1 minute job).

I agree we should be using the standard tools rather than inventing our
own, so printk_ratelimit() would be the correct way to do this.

James


