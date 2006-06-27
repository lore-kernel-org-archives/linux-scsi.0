From: Dax Kelson <dax@gurulabs.com>
Subject: Re: Areca driver recap + status
Date: Mon, 26 Jun 2006 18:23:08 -0600
Message-ID: <1151367789.2935.23.camel@mentorng.gurulabs.com>
References: <09be01c695b3$2ed8c2c0$c100a8c0@robm>
	 <20060621222826.ff080422.akpm@osdl.org>
	 <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gurulabs.com ([67.137.148.7]:50663 "EHLO mail.gurulabs.com")
	by vger.kernel.org with ESMTP id S1030252AbWF0AX1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 20:23:27 -0400
In-Reply-To: <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, rdunlap@xenotime.net, hch@infradead.org, erich@areca.com.tw, brong@fastmail.fm, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Robert Mueller <robm@fastmail.fm>

On Mon, 2006-06-26 at 09:48 -0500, James Bottomley wrote:

> Not the world perhaps, but I'm unwilling to concede that if a driver
> author is given a list of major issues and does nothing, then the driver
> should go in after everyone gets impatient.

That isn't accurate or fair. Erich has submitted large patches to
address issues. That hardly qualifies as "does nothing".

> The list of issues is here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114556263632510
> 
> Most of the serious stuff is fixed with the exception of:
> 
> - sysfs has more than one value per file
> - BE platform support
> - PAE (cast of dma_addr_t to unsigned long) issues.
> - SYNCHRONIZE_CACHE is ignored.  This is wrong.  The sync cache in the
> shutdown notifier isn't sufficient.
> 
> At least the sysfs files have to be fixed before it goes in ... unless
> you want to be lynched by Greg?

Thanks for the new list. Erich has been eager to get work on any
remaining blockers.

It would have been nice to have gotten it back on May 19th, they might
have been resolved by now.

http://marc.theaimsgroup.com/?l=linux-kernel&m=114801926400287&w=2



