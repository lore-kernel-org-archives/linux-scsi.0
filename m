From: Mark Lord <lkml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Thu, 27 Mar 2008 10:45:54 -0400
Message-ID: <47EBB322.6000402@rtr.ca>
References: <ablib-2zv-65@gated-at.bofh.it> <abn0B-735-35@gated-at.bofh.it> <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it> <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org> <20080327035257.GB9566@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:3699 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbYC0Op6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 10:45:58 -0400
In-Reply-To: <20080327035257.GB9566@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greg KH wrote:
>
> If sysfs is stupid, then use an ioctl, have I objected to that?
..

Well, at this point it certainly seems a lot simpler
than trying to get the sysfs "maintainers" to improve it.

Cheers
