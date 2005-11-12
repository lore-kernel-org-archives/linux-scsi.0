From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] removed useless SCSI_GENERIC_NCR5380_MMIO
Date: Sat, 12 Nov 2005 18:57:26 +0100
Message-ID: <20051112175726.GA21448@stusta.de>
References: <20051112043707.GX5376@stusta.de> <1131819625.18258.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56847 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932443AbVKLR52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 12:57:28 -0500
Content-Disposition: inline
In-Reply-To: <1131819625.18258.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>

On Sat, Nov 12, 2005 at 06:20:25PM +0000, Alan Cox wrote:
> On Sad, 2005-11-12 at 05:37 +0100, Adrian Bunk wrote:
> > This patch removes the useless SCSI_GENERIC_NCR5380_MMIO.
> > 
> > It's useless, since SCSI_G_NCR5380_MEM != CONFIG_SCSI_G_NCR5380_MEM.
> > 
> > This issue exists at least since kernel 2.6.0 and since it seems noone 
> > noticed it I'd say we can safely remove it.
> 
> 
> Its a one line bugfix so make the bugfix. There are often drivers that
> needed tiny fixes and it turned out that
> 
> - Vendors had it in their patch tree for years
> - The one person using it fixed it and didnt bother telling l/k cos they
> though l/k was full of arrogant assholes who would just laugh at them
> - The few users are still on 2.4 but will move to 2.6
> 
> Now when its a major rewrite to fix up some prehistoric piece of crap it
> makes sense to dump it if nobody uses it, when you have a one line fix
> required its a bit daft not to fix it.

The part that is not a one-line fix is to move the SCSI_G_NCR5380_MEM 
code away from the ISA legacy API, but if this is among the patches Al 
wants to send later today the rest is really only a one-line fix.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

