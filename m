From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI: misc possible cleanups
Date: Mon, 15 Nov 2004 06:02:32 +0100
Message-ID: <20041115050232.GB2235@stusta.de>
References: <20041115020432.GK2249@stusta.de> <1100494253.24811.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261443AbUKOFLt@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1100494253.24811.9.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 14, 2004 at 10:50:46PM -0600, James Bottomley wrote:
> On Sun, 2004-11-14 at 20:04, Adrian Bunk wrote:
> > This patch below does:
> > - remove unused code
> 
> Erm, some of the code you're trying to remove was recently added as
> enablers for fibre channel drivers, like this:
> 
> [...]
> 
> >  drivers/scsi/scsi_transport_fc.c  |  202 ------------------------------
> 
> It's really not safe to remove code without understanding why it's there
> in the first place.

That's exactly why I wrote:

<--  snip  -->

It is meant for review and not for being applied immediately.
It should simply demonstrate with users are possible with the current 
in-kernel users today.

<--  snip  -->

OK, the last wasn't a correct sentence.

I wanted to say:
It should simply demonstrate with changes are possible with the current 
in-kernel users.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
