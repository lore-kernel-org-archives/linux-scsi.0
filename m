From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 16:05:32 -0700
Message-ID: <47E9853C.1030506@zytor.com>
References: <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <20080325123454.4eba7644.randy.dunlap@oracle.com> <47E96263.9000808@zytor.com> <20080325212032.GA24495@suse.de> <47E96E15.7020105@zytor.com> <20080325230009.GA25062@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080325230009.GA25062@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> How does this have anything to do with boot times?  Do you really have a
> foolish shell script that iteratorates over every single disk in the
> sysfs tree for every disk?  What does it do that for?

Any time you want to get the sysfs information for a filesystem which is 
already mounted, that's what you're forced to do.

> I thought we were talking about 2TB disks here, with a proposed new
> ioctl, not foolishness of boot scripts...

I pointed out that having a way to map device numbers to sysfs 
directories would have the same effect, *and* would be usable for other 
purposes.  I'd rather see that than a new ioctl, and another, and another...

ioctl()s are also nasty since they're generally root-only (or rather, 
device-owner only).  Since the information is already in sysfs, there is 
no benefit to this hiding.  Otherwise one could consider a ioctl() "give 
me the sysfs name of this device."

	-hpa
