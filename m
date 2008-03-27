From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Wed, 26 Mar 2008 21:57:55 -0700
Message-ID: <47EB2953.4070301@zytor.com>
References: <ablib-2zv-65@gated-at.bofh.it> <abn0B-735-35@gated-at.bofh.it> <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it> <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org> <20080327035257.GB9566@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080327035257.GB9566@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Bodo Eggert <7eggert@gmx.de>, Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Greg KH wrote:
>> So e.g. lilo should depend on sysfs and *a*special*configuration* of udev,
>> while the admin MUST NOT use mknod'ed device files nor manually create
>> symlinks pointing to them, and not use relative path names?
>> That's plain stupid.
> 
> If sysfs is stupid, then use an ioctl, have I objected to that?

I think he's objecting to the dependency on udev configuration, not to 
sysfs.

	-hpa
