From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Tue, 7 Aug 2018 08:54:00 +0200
Message-ID: <20180807065400.nxpndw4kf6jdd55i@linux-x5ow.site>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
 <20180806132234.GA23827@kwaak.net>
 <20180806132725.ihbi5rxvkuuppajr@linux-x5ow.site>
 <20180806142414.GB23827@kwaak.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806142414.GB23827@kwaak.net>
Sender: linux-kernel-owner@vger.kernel.org
To: ard <ard@kwaak.net>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 06, 2018 at 04:24:14PM +0200, ard wrote:
> I've updated the ticket:
> https://github.com/hardkernel/linux/issues/360#issuecomment-410721997
> dmesg (with full debugging):
> https://github.com/hardkernel/linux/files/2262858/dmesg-2018-08-06.txt
> and kmemleak:
> https://github.com/hardkernel/linux/files/2262861/kmemleak-2018-08-06.txt
> 
> I'll have to take a good look at the what and why.
> I'm gonna git clean -x -d and rebuild the kernel, because this is
> weird.
> 
> This is the tree I build:
> https://github.com/ardje/linux/tree/gb-4.14-fcoe-patch
> So vanilla linux-4.14 with the patch set:
> https://github.com/ardje/linux/commit/747bf04057a99be5b01f768654cfd61bc9f4fc6c
> Meh, I should try to use git for patching.
> 
> I will spam some printk's later on, just to check which flows are
> followed (if the git clean doesn't reveal some problem, although
> I can't imagine).

OK, now this is wired. Are you seeing this on the initiator or on the
target side? Also on x86_64 or just the odroid? I could reproduce your
reports in my Virtualized Environment [1][2] by issuing deletes from the
initiator side..

[1] https://github.com/rapido-linux/rapido
[2] https://github.com/rapido-linux/rapido/blob/master/fcoe_local_autorun.sh

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
