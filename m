From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 11:29:12 -0500
Message-ID: <1149956952.3335.22.camel@mulgrave.il.steeleye.com>
References: <20060610160852.GA15316@havoc.gtf.org>
	 <20060610161036.GA21454@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:8365 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751600AbWFJQbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:31:18 -0400
In-Reply-To: <20060610161036.GA21454@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

On Sat, 2006-06-10 at 17:10 +0100, Christoph Hellwig wrote:
> The driver is not for scsi hardware.  Please implement it as block
> driver.

Actually, I'm afraid it is ... look at the mailbox path ... it's one of
these increasingly prevalent raid HBAs that speaks SCSI at the firmware
level.  Most commands are direct passthroughs, only INQUIRY and
MODE_SENSE are actually emulated in the driver.

James


