From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
Date: Thu, 31 Jan 2008 19:14:36 +0200
Message-ID: <20080131171436.GG19700@cs181133002.pp.htv.fi>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist> <20080131074436.GA31966@uranus.ravnborg.org> <1201795051.3131.13.camel@localhost.localdomain> <20080131081120.27505dc0@laptopd505.fenrus.org> <20080131162141.GC19700@cs181133002.pp.htv.fi> <20080131090749.72781689@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53424 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbYAaROA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 12:14:00 -0500
Content-Disposition: inline
In-Reply-To: <20080131090749.72781689@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

On Thu, Jan 31, 2008 at 09:07:49AM -0800, Arjan van de Ven wrote:
> On Thu, 31 Jan 2008 18:21:42 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, Jan 31, 2008 at 08:11:20AM -0800, Arjan van de Ven wrote:
> > > On Thu, 31 Jan 2008 09:57:31 -0600
> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > > No-one seems to see much value in these, and they cause about 90%
> > > > of our problems with __init/__exit markers, so simply eliminate
> > > > them. Rather than run over the whole tree removing them, this
> > > > patch #defines them to be nops.
> > > > 
> > > > Signed-off-by: James Bottomley
> > > > <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > ---
> > > > 
> > > > I'll probably be going after __exit after this one, but it makes
> > > > sense to split them up, since the hotplug annotation removal looks
> > > > uncontroversial, whereas __exit and discard section removal might
> > > > produce more robust debate.  I also think doing the hotplug
> > > > removal gives us 90% of the benefits and removes 90% of the
> > > > section mismatch problems.
> > > 
> > > 
> > > Since hotplug is so fundamental nowadays the value no longer
> > > outweighs the pain/cost to me, so 
> > 
> > Granted for normal hotplug.
> > 
> > But my computer has neither CPU hotplug 
> 
> cpuhotplug is required for suspend/resume.

Not on UP computers.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

