From: Greg KH <gregkh@suse.de>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Thu, 27 Mar 2008 08:15:28 -0700
Message-ID: <20080327151528.GB13661@suse.de>
References: <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it> <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org> <20080327035257.GB9566@suse.de> <47EBB322.6000402@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47EBB322.6000402@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 27, 2008 at 10:45:54AM -0400, Mark Lord wrote:
> Greg KH wrote:
>>
>> If sysfs is stupid, then use an ioctl, have I objected to that?
> ..
>
> Well, at this point it certainly seems a lot simpler
> than trying to get the sysfs "maintainers" to improve it.

I'm sorry, have I missed a patch that was submitted that adds this new
functionality?
