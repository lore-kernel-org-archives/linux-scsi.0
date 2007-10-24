From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: stex driver panic in kernel 2.6.23
Date: Wed, 24 Oct 2007 15:15:55 -0400
Message-ID: <1193253355.3441.4.camel@localhost.localdomain>
References: <NONAMEWzsLqIfQdmEB40000023f@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49931 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753433AbXJXTQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 15:16:07 -0400
In-Reply-To: <NONAMEWzsLqIfQdmEB40000023f@nonamew.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: "jens.axboe" <jens.axboe@oracle.com>, akpm <akpm@linux-foundation.org>, jeff <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-10-24 at 11:59 -0700, Ed Lin wrote:
> The shared tag issue was not fixed yet. Kernel panic
> happened while running I/O test in kernel 2.6.23
> (information attached). After applying the patch I posted
> (or the version James modified), panic disappeared.
> Switch back to standard kernel, panic again.

Just so we're on the same page, do you have a pointer to the patch?

I thought the issue was fixed by this patch

http://marc.info/?l=linux-scsi&m=118968649513338

Which Linus said he modified and then committed here:

http://marc.info/?l=linux-kernel&m=118969824104600

However, I have to confess I can't find this patch in the current
kernel.

James


