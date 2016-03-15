From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 16/22] ncr5380: Fix register decoding for debugging
Date: Tue, 15 Mar 2016 14:21:28 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603151358460.9662@nippy.intranet>
References: <20160314042700.596192247@telegraphics.com.au> <20160314042704.806019139@telegraphics.com.au> <56E66C43.4030208@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <56E66C43.4030208@suse.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org


On Mon, 14 Mar 2016, Hannes Reinecke wrote:

> Well ... using individual printk() like here might end up in each
> call to be broken up into individual lines.
> You might want to consider using a line buffer here or, better
> still, move to seq_file or debugfs output.

This routine is meant to be called with the lock held in irq mode. I made 
it the caller's responsibility to do the locking. It is the only way to 
get a point-in-time snapshot of all of the device registers.

-- 

> 
> But as the original code did that, too:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> 
> Cheers,
> 
> Hannes
> 
