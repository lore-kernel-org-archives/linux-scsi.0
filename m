From: Steffen Winterfeldt <snwint@suse.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
 (was: [BK PATCH] SCSI -rc1 fixes)
Date: Mon, 22 Nov 2004 12:33:33 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411221227190.22230@ligeti.suse.de>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
 <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org>
 <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org>
 <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> <20041122111722.GC10463@suse.de>
 <Pine.LNX.4.61.0411221220320.22230@ligeti.suse.de> <20041122112329.GE10463@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:22206 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261285AbUKVLde (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 06:33:34 -0500
In-Reply-To: <20041122112329.GE10463@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 22 Nov 2004, Jens Axboe wrote:
> On Mon, Nov 22 2004, Steffen Winterfeldt wrote:
> > On Mon, 22 Nov 2004, Jens Axboe wrote:
> > > On Mon, Nov 22 2004, Steffen Winterfeldt wrote:

> > > > If running just hwinfo breaks things for you, you might try running it
> > > > through strace and look at the files it accesses. Maybe that gives some hint
> > > > to narrow things down.
> > > 
> > > hwinfo needs to be updated to use SG_IO, there are too many things that
> > > can go wrong with SCSI_IOCTL_SEND_COMMAND (it's far too easy to confuse
> > > the device or adapter).
> > 
> > Well, it already has. But I don't think this is the problem here.
> 
> It has? Great! It could have been the problem if the data phases are
> interpreted incorrectly.

You got me wrong. It has in SL 9.2 but this is about SL 9.1, if I understand
correctly.

Anyway, to see whether this really matters, run

 hwprobe=+scsi.noserial hwinfo

and see if it makes a difference. Or try hwinfo from SL 9.2.


Steffen
