From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 78/71] ncr5380: Add support for HP 53C400A-based cards
 (C2502)
Date: Fri, 11 Dec 2015 10:38:02 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512111015380.30768@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1449561099-9981-1-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1512082137380.24631@nippy.intranet> <201512091233.36721.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201512091233.36721.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 9 Dec 2015, Ondrej Zary wrote:

> > > @@ -743,6 +786,7 @@ module_param(ncr_5380, int, 0);
> > >  module_param(ncr_53c400, int, 0);
> > >  module_param(ncr_53c400a, int, 0);
> > >  module_param(dtc_3181e, int, 0);
> > > +module_param(hp_53c400a, int, 0);
> > 
> > Any reason you did not add the corresponding __setup option?
> 
> I wonder if __setup is really required. I thought that it should go away 
> and module parameters used instead.

Yes, after re-reading the header files I see that you are right.

> 
> > Did you consider re-using the existing ncr_53c400a option (for port & 
> > irq settings) and adding a new setup option and module param for card 
> > magic?
> 
> Looks like a good idea.

What I had in mind was an 'ncr_magic' option, to go with 'ncr_irq' and 
'ncr_addr'. This is supposed to be a generic driver, after all.

But now that I've seen what that would involve (adding another member to 
struct override) I've changed my mind.

I think the new board type was the right approach. That is, a combination 
of your v2 and v3 patches. I'll send my version to you to test.

Thanks.

-- 
