From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 18:42:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040714164253.GE7308@fs.tum.de>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <40F556CE.9000707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S265030AbUGNQoV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40F556CE.9000707@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2004 at 11:52:46AM -0400, Jeff Garzik wrote:
>...
> If gcc is insisting that prototypes for inlines no longer work, we have 
> a lot of code churn on our hands ;-(  Grumble.

I've counted at about 30 files with such problems in a full i386 
2.6.7-mm7 compile.

I've already sent patches for some of them (e.g. the dmascc.c one), and 
they are usually pretty straightforward.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
