From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 4
Date: Tue, 10 Jul 2007 09:55:06 +0200
Message-ID: <20070710075506.GS13902@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707100944470.22782@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:20643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbXGJHyw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2007 03:54:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707100944470.22782@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 10 2007, Geert Uytterhoeven wrote:
> On Wed, 4 Jul 2007, Geert Uytterhoeven wrote:
> > This is the fourth submission of the new PS3 storage drivers:
> >   [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
> >   [2] ps3: Storage Driver Core
> >   [3] ps3: Storage device registration routines.
> >   [4] ps3: Disk Storage Driver
> >   [5] ps3: BD/DVD/CD-ROM Storage Driver
> >   [6] ps3: FLASH ROM Storage Driver
> > 
> > They are based on:
> >   - the current Linux kernel source tree,
> >   - plus the PS3 patches already submitted by Geoff Levand on linuxppc-dev,
> >   - plus the shost_priv() patch in scsi-misc (commit
> >     bcd92c9fbcc679ee95003083056f0441a1f474fa).
> > 
> > All issues raised during the previous review rounds should be fixed.
> > There were no more comments after the third submission.
> > 
> > Paul already integrated Geoff Levand's PS3 patches and the first 3 patches
> > in this series in the for-2.6.23 branch in powerpc.git.
> > 
> > Maintainers of block/SCSI/misc, can you please ack the last 3 patches so Paul
> > can take them, too?
> 
> Ping block/SCSI/misc maintainers?

I have no objections to the block bits, however I feel uneasy merging
the full patchset unless patch #1 has been acked by the platform person.

-- 
Jens Axboe

