From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sun, 5 Sep 2010 16:41:35 -0700
Message-ID: <20100905234134.GA17212@core.coreip.homeip.net>
References: <4C76CA57.3050405@vlnb.net>
 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
 <4C79484B.3090607@vlnb.net>
 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
 <4C7C18CE.5020103@vlnb.net>
 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
 <4C7FFD1A.8090509@vlnb.net>
 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
 <20100905201802.GC18411@core.coreip.homeip.net>
 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283723447.556.133.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 05, 2010 at 02:50:47PM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2010-09-05 at 13:18 -0700, Dmitry Torokhov wrote:
> > On Thu, Sep 02, 2010 at 01:25:58PM -0700, Nicholas A. Bellinger wrote:
> > > On Thu, 2010-09-02 at 23:38 +0400, Vladislav Bolkhovitin wrote:
> > > > Nicholas A. Bellinger, on 08/31/2010 01:46 AM wrote:
> > > > >>> It is obvious to even an casual observer from watching the TCM/LIO patch
> > > > >>> series that have been flying across the linux-scsi wire the last 24
> > > > >>> months that the major features (including PR and ALUA, and new fabric
> > > > >>> module drivers) have been developed individual feature bit by feature
> > > > >>> bit using a distributed git workflow in a bisectable manner.  Each
> > > > >>> series was produced in such a manner that each patch could be reviewed
> > > > >>> individually by those interested parties.
> > > > >>
> > > > >> That's a nice, but quite meaningless LIO advertisement. SCST is using
> > > > >> the same bisectable, distributed and reviewable workflow.
> > > > >
> > > > > Actually, that is incorrect.  Your project uses a centralized
> > > > > development model, which has it's obvious limitiations in terms of
> > > > > speed, flexability, and community scale.  But really, don't take my word
> > > > > for it, you can hear it for yourself directly from the horse's mouth
> > > > > here:
> > > > >
> > > > > http://www.youtube.com/watch?v=4XpnKHJAok8
> > > > >
> > > > > I also very strongly suggest you find a transcript of this talk so you
> > > > > can really understand what Linus means here wrt to a distributed
> > > > > development workflow.
> > > > 
> > > > Well, Nicholas, are you really understanding what you are writing? We in 
> > > > our projects have fully the same distributed (or centralized, if you 
> > > > like it) development model. Have you noticed how many developers SCST 
> > > > project has? We have our responsibility areas (target drivers, 
> > > > scstadmin, etc.) and commit in them. The way how we get updates for the 
> > > > rest of the kernel doesn't matter. Git is better for such huge projects 
> > > > as the kernel, but for our relatively small and centralized by nature 
> > > > due to small size (sub)projects it doesn't matter and won't bring any value.
> > > > 
> > > 
> > > I find it hard to beleive you are actually going to agrue against a git
> > > workflow for a target mode subsystem maintainer, well considering that
> > > git was made by a linux kernel maintainer (Linus) for distributed linux
> > > kernel development (everybody else)..?
> > >
> > 
> > This is complete BS. Are we going to judge value of a project based on
> > what kind SCM they chose to use? I guess we should ban Greg KH from
> > kernel development and rip out USB and driver core layers from the
> > kernel because he has the audacity to use quilt for his trees.
> > 
> 
> I think the difference between what Linus says and what he actually
> means in the above video could be easily misinterpreted, well especially
> for some non-english speaking folks.  But I am certainly glad to see
> that a russian translation is also available for this google git talk
> for those who really want try to understand his reasons (and technical
> requirements) for what he is saying.

Will you please piss off with your insinuations that we do not
Understand English? While it may not be our first language it does not
mean we are having trouble with it.

> 
> So as to the specifics about why git is really the only right SCM choice
> for mainline target mode maintainership, it really all comes down to
> workflow.  Does your SCM allow other people to easily and without-pain
> track your upstream subsystem tree changes and 'rebase' as necessary for
> their patch series you make improvements..?   If we are talking about
> say, a single standalone driver being developed against mainline, then
> sure using a SCM like CVS or SVN is perfectly acceptable when you push
> to someone upstream like gregkh or akpm via email patch attachments.
> 
> However, if we are talking about a subsystem maintainer workflow that
> requires many different people to track your subsystem tree for their
> own drivers and new feature bits, not being able to keep local branches
> for these level developers makes their life excruciatingly painful and
> unpleasent as they attempt to pull new upstream changes, especially when
> the speed of new upstream development is moving quickly.

Haven't you noticed yet that not every maintainer uses git? USB, driver
core, tty, staging and i2c subsystems are based on quilt queues.
Media/DVB main tree is in mercurial. AOE is quilt. And I am pretty sure
there are others, I just don't care about them. And if you prefer to use
git - there are SVN and other importers - please use them.

>  This rule
> applys even more when said subsystem has a greater scope within the
> source tree in question.
> 

I do not think that LIO is any bigger in scope than USB, I2C and others.


> Anyways, if we are going to compare SCM distributed vs. centralized
> workflow in terms of kernel projects, lets please at least compare
> apples to apples here.
> 

No, we should not be comparing SCMs at all here but rather 2 competing
implementations based on quality of the code. You tried to bring SMC
angle in and I am saying that it is BS.

-- 
Dmitry
