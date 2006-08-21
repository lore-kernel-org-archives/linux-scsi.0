From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/scsi/wd33c93.c: cleanups
Date: Mon, 21 Aug 2006 21:22:15 +0200
Message-ID: <20060821192215.GL11651@stusta.de>
References: <20060821104357.GH11651@stusta.de> <20060821105344.GA28759@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750863AbWHUTWS@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060821105344.GA28759@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 21, 2006 at 11:53:44AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 21, 2006 at 12:43:57PM +0200, Adrian Bunk wrote:
> > This patch contains the following cleanups:
> > - #include <linux/irq.h> for getting the prototypes of
> >   {dis,en}able_irq()
> 
> nothing outside of arch code must ever include <linux/irq.h>

Why?
It sounds rather strange that non-arch code should use asm headers.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
