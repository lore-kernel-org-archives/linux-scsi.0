From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch] drivers/scsi/dpt_i2o.c: fix a NULL pointer dereference
Date: Mon, 28 Nov 2005 22:51:43 +0100
Message-ID: <20051128215143.GE31395@stusta.de>
References: <20051126233637.GC3988@stusta.de> <1133203032.3325.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932197AbVK1Vvp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1133203032.3325.46.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, markus.lidel@shadowconnect.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 12:37:11PM -0600, James Bottomley wrote:
> On Sun, 2005-11-27 at 00:36 +0100, Adrian Bunk wrote:
> > The Coverity checker spotted this obvious NULL pointer dereference.
> 
> It's a bit late for this one, since Linus already put it in, but for
> future reference, could you please try to use proper descriptions.  This
> isn't an "obvious NULL pointer dereference", it's actually a use after
> free of a data structure.

OK sorry, I'll look better at the descriptions for future patches.

> Thanks,
> 
> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
