From: Andrew Morton <akpm@osdl.org>
Subject: Re: Areca driver recap + status
Date: Mon, 26 Jun 2006 08:01:22 -0700
Message-ID: <20060626080122.894de905.akpm@osdl.org>
References: <09be01c695b3$2ed8c2c0$c100a8c0@robm>
	<20060621222826.ff080422.akpm@osdl.org>
	<1151333338.2673.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25220 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932355AbWFZPBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 11:01:41 -0400
In-Reply-To: <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: rdunlap@xenotime.net, hch@infradead.org, erich@areca.com.tw, brong@fastmail.fm, dax@gurulabs.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, robm@fastmail.fm

On Mon, 26 Jun 2006 09:48:58 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2006-06-21 at 22:28 -0700, Andrew Morton wrote: 
> > On Thu, 22 Jun 2006 14:18:23 +1000
> > "Robert Mueller" <robm@fastmail.fm> wrote:
> > 
> > > The driver went into 2.6.11-rc3-mm1 here:
> > > http://marc.theaimsgroup.com/?l=linux-kernel&m=110754432622498&w=2
> > 
> > One and a half years.
> > 
> > Would the world end if we just merged the dang thing?
> 
> Not the world perhaps, but I'm unwilling to concede that if a driver
> author is given a list of major issues and does nothing, then the driver
> should go in after everyone gets impatient.
> 
> The rules for inclusion are elastic and include broad leeway for good
> behaviour, but this would stretch the elasticity way beyond breaking
> point.
> 
> The list of issues is here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114556263632510

I'm under the impression that Erich is under the impression that they've all
been addressed.

> Most of the serious stuff is fixed with the exception of:
> 
> - sysfs has more than one value per file
> - BE platform support
> - PAE (cast of dma_addr_t to unsigned long) issues.
> - SYNCHRONIZE_CACHE is ignored.  This is wrong.  The sync cache in the
> shutdown notifier isn't sufficient.

So this is progress.

Erich, can you please fix these things up and then re-review the issues
list which I'm maintaining in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17/2.6.17-mm2/broken-out/areca-raid-linux-scsi-driver.patch,
make sure that everything has been addressed?

If there are some things in those lists which you cannot/will not address
then please identify them and give us the reasoning behind your decision.

