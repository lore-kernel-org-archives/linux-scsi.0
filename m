From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI t128.c: remove an unused function
Date: Mon, 15 Nov 2004 18:03:22 +0100
Message-ID: <20041115170322.GB19860@stusta.de>
References: <20041115023859.GE2249@stusta.de> <1100529621.27202.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261642AbUKORGm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1100529621.27202.9.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 15, 2004 at 02:40:39PM +0000, Alan Cox wrote:
> On Llu, 2004-11-15 at 02:38, Adrian Bunk wrote:
> > The patch below removes the unused function t128_setup.
> > 
> > Please review whether it's correct.
> 
> Its wrong. The fix is to make the setup function get called, IFF you can
> find anyone with a t128 any more

Ah, it seems your t128 fix which did this in 2.4.17-pre7 is (like your 
dtc cleanup in the same patch) among the fixes not yet forward-ported 
from 2.4 to 2.6 ...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
