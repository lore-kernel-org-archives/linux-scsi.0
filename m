From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI seagate.c: remove SEAGATE_USE_ASM
Date: Mon, 22 Jan 2007 16:38:13 +0100
Message-ID: <20070122153813.GT9093@stusta.de>
References: <20070121191300.GL9093@stusta.de> <20070122151841.6d0473e4@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:2738 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751045AbXAVPiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 10:38:08 -0500
Content-Disposition: inline
In-Reply-To: <20070122151841.6d0473e4@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 03:18:41PM +0000, Alan wrote:
> On Sun, 21 Jan 2007 20:13:00 +0100
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Using assembler code for performance in drivers might have been a good 
> > idea 15 years ago when this code was written, but with today's compilers 
> > that's unlikely to be an advantage.
> > 
> > Besides this, it also hurts the readability.
> > 
> > Simply use the C code that was already there as an alternative.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 					"stosb\n\t"
> 
> NAK
> 
> The C codepaths are essentially untested on this driver.

Has any part of this driver ever be tested with kernel 2.6?
Or compiled with gcc 4?

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

