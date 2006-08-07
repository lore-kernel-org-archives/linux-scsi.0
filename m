From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix up short inquiry printing
Date: Mon, 07 Aug 2006 12:03:14 -0500
Message-ID: <1154970194.3683.305.camel@mulgrave.il.steeleye.com>
References: <1154906122.3683.244.camel@mulgrave.il.steeleye.com>
	 <20060807024612.GJ4379@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:51938 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932226AbWHGRDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 13:03:24 -0400
In-Reply-To: <20060807024612.GJ4379@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2006-08-06 at 20:46 -0600, Matthew Wilcox wrote:
> I think we should probably switch sdev_printk() to its own custom
> implementation rather than just calling dev_printk().  Greg didn't seem
> to be interested in fixing the problem that we have with dev_printk();
> presumably he has some other users in mind for which the current
> dev_printk behaviour is useful.
> 
> How does something like the following look (compile tested):

What issues with dev_printk?  It does make a lot of sense to have a
single tap for errors, just in case someone decides to resurrect the
enterprise logging patches, which would use something like dev_printk as
the discriminator.

James


