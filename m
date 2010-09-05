From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sun, 5 Sep 2010 13:18:04 -0700
Message-ID: <20100905201802.GC18411@core.coreip.homeip.net>
References: <4C7421FB.2060007@vlnb.net>
 <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
 <4C76CA57.3050405@vlnb.net>
 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
 <4C79484B.3090607@vlnb.net>
 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
 <4C7C18CE.5020103@vlnb.net>
 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
 <4C7FFD1A.8090509@vlnb.net>
 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 02, 2010 at 01:25:58PM -0700, Nicholas A. Bellinger wrote:
> On Thu, 2010-09-02 at 23:38 +0400, Vladislav Bolkhovitin wrote:
> > Nicholas A. Bellinger, on 08/31/2010 01:46 AM wrote:
> > >>> It is obvious to even an casual observer from watching the TCM/LIO patch
> > >>> series that have been flying across the linux-scsi wire the last 24
> > >>> months that the major features (including PR and ALUA, and new fabric
> > >>> module drivers) have been developed individual feature bit by feature
> > >>> bit using a distributed git workflow in a bisectable manner.  Each
> > >>> series was produced in such a manner that each patch could be reviewed
> > >>> individually by those interested parties.
> > >>
> > >> That's a nice, but quite meaningless LIO advertisement. SCST is using
> > >> the same bisectable, distributed and reviewable workflow.
> > >
> > > Actually, that is incorrect.  Your project uses a centralized
> > > development model, which has it's obvious limitiations in terms of
> > > speed, flexability, and community scale.  But really, don't take my word
> > > for it, you can hear it for yourself directly from the horse's mouth
> > > here:
> > >
> > > http://www.youtube.com/watch?v=4XpnKHJAok8
> > >
> > > I also very strongly suggest you find a transcript of this talk so you
> > > can really understand what Linus means here wrt to a distributed
> > > development workflow.
> > 
> > Well, Nicholas, are you really understanding what you are writing? We in 
> > our projects have fully the same distributed (or centralized, if you 
> > like it) development model. Have you noticed how many developers SCST 
> > project has? We have our responsibility areas (target drivers, 
> > scstadmin, etc.) and commit in them. The way how we get updates for the 
> > rest of the kernel doesn't matter. Git is better for such huge projects 
> > as the kernel, but for our relatively small and centralized by nature 
> > due to small size (sub)projects it doesn't matter and won't bring any value.
> > 
> 
> I find it hard to beleive you are actually going to agrue against a git
> workflow for a target mode subsystem maintainer, well considering that
> git was made by a linux kernel maintainer (Linus) for distributed linux
> kernel development (everybody else)..?
>

This is complete BS. Are we going to judge value of a project based on
what kind SCM they chose to use? I guess we should ban Greg KH from
kernel development and rip out USB and driver core layers from the
kernel because he has the audacity to use quilt for his trees.

-- 
Dmitry
