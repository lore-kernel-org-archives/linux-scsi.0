From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 21:05:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040714190542.GJ7308@fs.tum.de>
References: <200407141751.i6EHprhf009045@harpo.it.uu.se> <40F57D14.9030005@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:54263 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S265207AbUGNTFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 15:05:53 -0400
Content-Disposition: inline
In-Reply-To: <40F57D14.9030005@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Arjan van de Ven <arjanv@redhat.com>
Cc: Mikael Pettersson <mikpe@csd.uu.se>, B.Zolnierkiewicz@elka.pw.edu.pl, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 14, 2004 at 02:36:04PM -0400, Jeff Garzik wrote:
> Mikael Pettersson wrote:
> >It's needed, and no it's not a compiler bug.
> 
> In fact, it is.  gcc isn't properly inlining functions where uses occur 
> before implementation of the inlined function.
> 
> Or you could just call it "gcc is dumb" rather than a compiler bug.

gcc 3.4 seems to be the first gcc version that could actually handle 
such cases.

But since the kernel uses -fno-unit-at-a-time, it doesn't work.

The problem with unit-at-a-time is that it might increase the stack 
usage. Arjan explained this in the "GCC 3.4 and broken inlining." thread 
that started Thursday.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

