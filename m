From: Adrian Bunk <bunk@stusta.de>
Subject: Re: Fusion-MPT much faster as module
Date: Tue, 22 Mar 2005 13:28:01 +0100
Message-ID: <20050322122801.GI3982@stusta.de>
References: <200503221029.j2MATNg12775@unix-os.sc.intel.com> <1111488742.7096.61.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:31236 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261167AbVCVM2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 07:28:04 -0500
Content-Disposition: inline
In-Reply-To: <1111488742.7096.61.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, 'Holger Kiehl' <Holger.Kiehl@dwd.de>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Moore, Eric  Dean" <emoore@lsil.com>

On Tue, Mar 22, 2005 at 11:52:22AM +0100, Arjan van de Ven wrote:
> On Tue, 2005-03-22 at 02:29 -0800, Chen, Kenneth W wrote:
> 
> > Before:
> > /dev/sdc:
> >  Timing buffered disk reads:   92 MB in  3.03 seconds =  30.32 MB/sec
> > 
> > After:
> > /dev/sdc:
> >  Timing buffered disk reads:  174 MB in  3.02 seconds =  57.61 MB/sec
> 
> 
> nice!
> 
> More proof that #ifdef MODULE is considered harmful... how much of it is
> actually left in the kernel? Maybe we could kill it entirely from
> drivers/*  (of course it has a limited place in include/*)

Too many...

And there are places where it's actually useful:

  #if defined(CONFIG_FOO) || (defined(MODULE) && defined(CONFIG_FOO_MODULE))

is a good way to express that driver bar can use functionality of driver 
foo if it's available.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

