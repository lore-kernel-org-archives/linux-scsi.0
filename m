From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Sat, 29 Mar 2008 23:28:11 -0500
Message-ID: <20080330042811.GB27330@auslistsprd01.us.dell.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <1206458278.3273.5.camel@localhost.localdomain> <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2008 at 01:45:35PM -0400, Greg Freemyer wrote:
> I believe GUID Partition Tables (GPTs) are the answer.
> 
> I believe one of the features of GPT is the elimination of the 32-bit
> sector restrictions.
> 
> http://en.wikipedia.org/wiki/GUID_Partition_Table
> 
> Windows VISTA 64-bit supports GPTs on data disks and new Mac OS based
> systems have been using it on internal drives for a couple years at
> least.
> 
> GPTs are part of the Extensible Firmware Interface (EFI), so they
> should be usable for PC bootable disks at some point.  (Maybe now in
> some cases?)
> 
> I'm not sure what the Linux Kernel support is for GPTs.

It has been supported since the first Itanium systems shipped.  It's
the first code I wrote 7+ years before it was really needed. :-)  Most
distributions have it enabled, as do userspace tools like GNU Parted.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
