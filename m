From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 07/29] ncr5380: Cleanup TAG_NEXT and TAG_NONE macros
Date: Fri, 3 Oct 2014 20:12:17 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410032005540.12643@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065629.926686164@telegraphics.com.au> <CAMuHMdUKkyj-27iqrhSZS9GpaB1GHpztnScW+0X4Fi62AdwOvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUKkyj-27iqrhSZS9GpaB1GHpztnScW+0X4Fi62AdwOvw@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Fri, 3 Oct 2014, Geert Uytterhoeven wrote:

> On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> > --- linux.orig/drivers/scsi/NCR5380.h   2014-10-02 16:55:55.000000000 +1000
> > +++ linux/drivers/scsi/NCR5380.h        2014-10-02 16:55:57.000000000 +1000
> > @@ -224,14 +224,11 @@
> >  #define DISCONNECT_LONG                2
> >
> >  /*
> > - * These are "special" values for the tag parameter passed to NCR5380_select.
> > + * "Special" value for the (unsigned char) command tag, to indicate
> > + * I_T_L nexus instead of I_T_L_Q.
> >   */
> 
> I guess the above comment can just be removed instead of changed, as the 
> I_T_L nexus definitions below are removed?

When I wrote this patch I didn't realize that the tag member in struct 
scsi_cmnd was going to be removed in favour of cmd->request.tag. I will 
rewrite this patch to remove all of the cmd->tag stuff.

When I sent this patch I knew I'd have to revise it, but I wanted to get 
the entire series out there anyway to avoid further duplication of effort.

-- 
