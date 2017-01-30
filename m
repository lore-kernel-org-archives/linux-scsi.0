From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 0/6] ncr5380: Miscellaneous minor patches
Date: Mon, 30 Jan 2017 15:06:57 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1701301503360.10411@nippy.intranet>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <4104f2d6-d964-474b-5d78-16c5384c145b@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4104f2d6-d964-474b-5d78-16c5384c145b@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 30 Jan 2017, Michael Schmitz wrote:

> > Michael, Ondrej, can I get you to review/test please?
> 
> No regressions during testing on my Falcon both using default settings, 
> i.e. can_queue=1 or internal queueing (can_queue=4, cmd_per_lun=2), and 
> the legacy IDE driver.
> 
> I've seen a bus reset executed when reloading the module (bus jammed for 
> some reason apparently), so that code path has been tested as well.
> 
> No change in the weird behaviour of my SCSI-SATA adapter, but perhaps 
> that wasn't unexpected.
> 

Well, I guess we eliminated one possibility. Could be a bus termination 
issue perhaps?

> Targets: Disks Seagate ST34520W and IBM DORS-32160W, CD-ROM Plextor 
> PX-40TS.
> 
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>

Thanks, Michael.

-- 
