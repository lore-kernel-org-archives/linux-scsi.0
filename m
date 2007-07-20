From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 19:13:23 +0200
Message-ID: <20070720171323.GB3801@stusta.de>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <1184950138.3455.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39632 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761355AbXGTROA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 13:14:00 -0400
Content-Disposition: inline
In-Reply-To: <1184950138.3455.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org

On Fri, Jul 20, 2007 at 11:48:57AM -0500, James Bottomley wrote:
> On Fri, 2007-07-20 at 18:40 +0200, Geert Uytterhoeven wrote:
> > plain text document attachment (m68k-wd33c93-needs-asm-irq.diff)
> > wd33c93 SCSI needs <asm/irq.h> on m68k
> > 
> > drivers/scsi/wd33c93.c: In function 'wd33c93_host_reset':
> > drivers/scsi/wd33c93.c:1582: error: implicit declaration of function 'disable_irq'
> > drivers/scsi/wd33c93.c:1603: error: implicit declaration of function 'enable_irq'
> > 
> > The driver still compiles on MIPS (CONFIG_SGIWD93_SCSI=y)
> 
> That's fixed here, isn't it:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=078dda95c521b1c78d1b5da69ac90d581abc9951
> 
> (sorry about the lack of descriptive subject line)

It wasn't a compile error when I sent this patch to you for the first 
time 11 months ago...

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

