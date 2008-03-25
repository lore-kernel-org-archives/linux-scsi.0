From: Greg KH <gregkh@suse.de>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 16:22:52 -0700
Message-ID: <20080325232252.GA25338@suse.de>
References: <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <20080325123454.4eba7644.randy.dunlap@oracle.com> <47E96263.9000808@zytor.com> <20080325212032.GA24495@suse.de> <47E96E15.7020105@zytor.com> <20080325230009.GA25062@suse.de> <47E9853C.1030506@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E9853C.1030506@zytor.com>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2008 at 04:05:32PM -0700, H. Peter Anvin wrote:
>> How does this have anything to do with boot times?  Do you really have a
>> foolish shell script that iteratorates over every single disk in the
>> sysfs tree for every disk?  What does it do that for?
>
> Any time you want to get the sysfs information for a filesystem which is 
> already mounted, that's what you're forced to do.
>
>> I thought we were talking about 2TB disks here, with a proposed new
>> ioctl, not foolishness of boot scripts...
>
> I pointed out that having a way to map device numbers to sysfs directories 
> would have the same effect, *and* would be usable for other purposes.  I'd 
> rather see that than a new ioctl, and another, and another...

Again, a simple udev rule will give you that today if you really want
it...

And I think 'udevinfo' can be used to retrieve this information as well.

thanks,

greg k-h
