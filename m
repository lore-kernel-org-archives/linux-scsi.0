From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sun, 5 Sep 2010 22:04:52 -0700
Message-ID: <20100906050452.GC17212@core.coreip.homeip.net>
References: <4C79484B.3090607@vlnb.net>
 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
 <4C7C18CE.5020103@vlnb.net>
 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
 <4C7FFD1A.8090509@vlnb.net>
 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
 <20100905201802.GC18411@core.coreip.homeip.net>
 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
 <AANLkTimdHotxVS8ZJJhg0D08FUiw4scSMTb2dryqJ_vQ@mail.gmail.com>
 <1283731939.556.159.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283731939.556.159.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mark Deneen <mdeneen@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 05, 2010 at 05:12:19PM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2010-09-05 at 19:13 -0400, Mark Deneen wrote:
> > On Sun, Sep 5, 2010 at 5:50 PM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > >
> > > I think the difference between what Linus says and what he actually
> > > means in the above video could be easily misinterpreted, well especially
> > > for some non-english speaking folks.  But I am certainly glad to see
> > > that a russian translation is also available for this google git talk
> > > for those who really want try to understand his reasons (and technical
> > > requirements) for what he is saying.
> > >
> > > So as to the specifics about why git is really the only right SCM choice
> > > for mainline target mode maintainership, it really all comes down to
> > > workflow.  Does your SCM allow other people to easily and without-pain
> > > track your upstream subsystem tree changes and 'rebase' as necessary for
> > > their patch series you make improvements..?   If we are talking about
> > > say, a single standalone driver being developed against mainline, then
> > > sure using a SCM like CVS or SVN is perfectly acceptable when you push
> > > to someone upstream like gregkh or akpm via email patch attachments.
> > >
> > > However, if we are talking about a subsystem maintainer workflow that
> > > requires many different people to track your subsystem tree for their
> > > own drivers and new feature bits, not being able to keep local branches
> > > for these level developers makes their life excruciatingly painful and
> > > unpleasent as they attempt to pull new upstream changes, especially when
> > > the speed of new upstream development is moving quickly.  This rule
> > > applys even more when said subsystem has a greater scope within the
> > > source tree in question.
> > >
> > > Anyways, if we are going to compare SCM distributed vs. centralized
> > > workflow in terms of kernel projects, lets please at least compare
> > > apples to apples here.
> > >
> > > Best,
> > >
> > > --nab
> > 
> > I've been trying to keep my 2 cents out of this, as I am merely an
> > SCST user.  Both of you have valid criticisms; the choice of SCM is
> > not one of them.  It is nit-picking at best, especially when SCST
> > could switch to git easily if they so desired.
> > 
> > Seven years ago, would you be pushing BitKeeper?
> > 
> 
> Hi Mark,
> 
> I will always be advocating using the best tool for the job in any given
> situation.  So absoulutely, I would have picked bitkeeper over tarballs
> any day of the week 7 years ago, or over SVN if it had existed back
> then.
> 
> But again, I think it's an important point that git is a tool that was
> made explictly for the linux kernel workflow.  Why would a new subsystem
> maintainer is participates in the kernel workflow ever use anything
> besides git at this point..?
> 
> And sorry, but considering the obvious advantages in terms of workflow
> speed and flexibility that git brings to the table for a subsystem
> maintainer, calling the choise of SCM a nit-pick item demonstrates a
> level certain level of inexperience wrt to mainline kernel workflow.

Will you please stop being condescending? Yes, it is nit-picking. Many
subsystems and features are being developed using patch series stored
not in git but somewhere else. Have you noticed that akpm uses his own
patch utils because git is not the best tool _for him_. Git is perfect
for Linus's and DaveM workflows (as they in turn do pulls), whereas
maintainers that prefer patch-based submissions may or may not use git,
depending on their preferences.

The choice between 2 implementations should be based purely on design and
code quality (with maintainer being reasonable and flexible enough for
additional points).

-- 
Dmitry
