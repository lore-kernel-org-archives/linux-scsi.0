From: Tony Spinillo <tspinillo@yahoo.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 08:23:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021228162343.90846.qmail@web14004.mail.yahoo.com>
References: <20021228134058.GC13814@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021228134058.GC13814@louise.pinerecords.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been using 6.2.23 on my two home machines, 29160 and 39160
cards. So far things seem okay.  When I get some down time I will
get the new driver on a few servers at work and see what shakes loose.

TS
Kernel 2.4.21pre1
Intel 845PESVL Motherboards


--- Tomas Szepe <szepe@pinerecords.com> wrote:
> [riel@conectiva.com.br]
> > 
> > On Sat, 28 Dec 2002, Tomas Szepe wrote:
> > 
> > > Marcelo, you've been overlooking these updates for a bit too long
> now
> > > for your "let's throw them at -ac" to sound fair.  IMHO of
> course.  Also
> > > remember those are both production drivers tested thoroughly in
> FreeBSD,
> > 
> > Are we talking about the old or the new aic7xxx driver ?
> 
> The new one.
> 
> > If it's the new driver, it's breaking on WAY too many
> > machines and I have no idea why it got ever merged...
> > 
> > I have yet to see a machine where the new aic7xxx driver
> > works. I'm sure they exist, but it doesn't work on any
> > of the machines I have access to.
> 
> Oh?  I'm surprised to hear that, because the Gibbs driver
> 	1) works well for all the Adaptecs I've got. :)
> 	2) can drive certain chips the original driver can't
> 		(2940U's for instance).
> 
> -- 
> Tomas Szepe <szepe@pinerecords.com>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

