From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [2.4 patch] Fix IRQ_NONE clash in SCSI drivers
Date: Wed, 3 Sep 2003 15:24:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030903132452.GX23729@fs.tum.de>
References: <Pine.LNX.4.55L.0308271449170.23236@freak.distro.conectiva> <20030902184436.GO23729@fs.tum.de> <200309031048.53818.m.c.p@wolk-project.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200309031048.53818.m.c.p@wolk-project.de>
To: Marc-Christian Petersen <m.c.p@wolk-project.de>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Arnaldo Carvalho de Melo <acme@conectiva.com.br>, lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 03, 2003 at 10:48:53AM +0200, Marc-Christian Petersen wrote:
> On Tuesday 02 September 2003 20:44, Adrian Bunk wrote:
> 
> Hi Adrian,
> 
> > This change added an (empty) IRQ_NONE #define to interrupt.h.
> > Several scsi drivers are already using an IRQ_NONE.  Rename that to
> > SCSI_IRQ_NONE (a similar change was done in 2.5 by Andrew Morton several
> > months ago).
> 
> right, but you forgot one header :-) ... Attached is a patch.

Uups, I fixed it but forgot to include it in the patch.

Thanks for noticing it!

> Marcelo, please apply this too.
> 
> ciao, Marc

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
