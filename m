From: Adrian Bunk <bunk@kernel.org>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
Date: Tue, 10 Jun 2008 16:24:36 +0300
Message-ID: <20080610132436.GB16149@cs181133002.pp.htv.fi>
References: <20080517141749.GD3284@cs181133002.pp.htv.fi> <1211453544.3956.33.camel@localhost.localdomain> <20080523105412.cc13647d.rdunlap@xenotime.net> <1211565551.11477.26.camel@localhost.localdomain> <20080523110457.de353625.rdunlap@xenotime.net> <1211574780.11477.44.camel@localhost.localdomain> <20080523144849.3773cac3.rdunlap@xenotime.net> <1211580030.11477.50.camel@localhost.localdomain> <20080523153924.af48e95e.rdunlap@xenotime.net> <1211583164.11477.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755894AbYFJNZx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1211583164.11477.52.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 23, 2008 at 05:52:44PM -0500, James Bottomley wrote:
> On Fri, 2008-05-23 at 15:39 -0700, Randy Dunlap wrote:
> > On Fri, 23 May 2008 17:00:30 -0500 James Bottomley wrote:
> > >      1. No stubs and simply select FW_LOADER for everything
> > >      2. Stubs that actually work in all situations.
> > > 
> > > My patch does 2.  I can see an argument for 1. but since we have the
> > > stubs, making them work in all cases seems like the smaller change to
> > > functionality.
> > 
> > Oh, I'm for the stubs approach.
> > 
> > So with SCSI_SAS_LIBSAS=y and FW_LOADER=m, you would want/expect
> > request_firmware() to return -EINVAL all of the time?
> 
> If you want stubs, yes
>...

I think I was the only one who had doubts about this patch.

And I've turned into a fan of your patch (plus my
"always enable FW_LOADER unless EMBEDDED=y" patch).

Can you (re)submit your patch so that it gets into 2.6.26?

> James

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
