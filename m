From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sun, 05 Sep 2010 18:34:04 -0700
Message-ID: <1283736844.556.184.camel@haakon2.linux-iscsi.org>
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
	 <20100905201802.GC18411@core.coreip.homeip.net>
	 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
	 <AANLkTimdHotxVS8ZJJhg0D08FUiw4scSMTb2dryqJ_vQ@mail.gmail.com>
	 <1283731939.556.159.camel@haakon2.linux-iscsi.org>
	 <AANLkTikOgc+YbkzmOpJv=s4Oxj9S9LYQ5qf5jDbT0ycg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikOgc+YbkzmOpJv=s4Oxj9S9LYQ5qf5jDbT0ycg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Deneen <mdeneen@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-09-05 at 20:58 -0400, Mark Deneen wrote:
> > Hi Mark,
> >
> > I will always be advocating using the best tool for the job in any given
> > situation.  So absoulutely, I would have picked bitkeeper over tarballs
> > any day of the week 7 years ago, or over SVN if it had existed back
> > then.
> 
> I can't say that I agree with this.  SVN existed, along with many
> other open source choices -- the choice of BitKeeper was a mistake.
> 

Bitkeeper taught Linus by his own admission that there was actually a
reason to using a SCM for the kernel to begin with, and helped drive
some early git design princables which he also briefly mentioned in the
google git talk.

So I hardly consider this a mistake looking at it from a historical
perspective.

> > But again, I think it's an important point that git is a tool that was
> > made explictly for the linux kernel workflow.  Why would a new subsystem
> > maintainer is participates in the kernel workflow ever use anything
> > besides git at this point..?
> 
> Look, I'm not saying that I dislike git.  I use it as my SCM here.
> However, git was in its infancy (or not even around) when SCST was
> started.  It's not like they had a proprietary vendor go cold turkey
> on them, forcing everyone to another solution.

I am really sorry to hear about SCST's bad timing wrt to the evolution
of git, but I hardly see this as an acceptable excuse for poor mainline
workflow.

> 
> > And sorry, but considering the obvious advantages in terms of workflow
> > speed and flexibility that git brings to the table for a subsystem
> > maintainer, calling the choise of SCM a nit-pick item demonstrates a
> > level certain level of inexperience wrt to mainline kernel workflow.
> > Which is perfectly OK, but if you really want to understand the issues
> > at hand in a distributed vs. centrailized SCM model, I strongly suggest
> > you watch Linus's talk as well.
> >
> > Best,
> >
> > --nab
> 
> I'm still calling it a nit-pick.  Vlad could switch to git in a short
> amount of time if he felt so compelled.  This is like saying that the
> quality of a car is based on the style of garage it is parked in.
> 

Well, if we are going to start talking about car analogies, then I have
one for you.. 8-)

Using a centralized SCM for kernel subsystem workflow in the year 2010
in akin to trying to make a modification to a 18,000 RPM capable engine
in a Ferrari F1 (eg: Linux Kernel), tuned to run at the *highest* levels
of international competition (eg: LKML).  But instead of using the tools
(git) that where explictely designed the F1 engine by it's creator (eg:
Linus aka Enzo Ferrari), you end trying to adjust your F1 engine's
killowatt per litre displacement output using a broken FM tuner knob and
rusty spare tire jack from a 79' Ford Pinto.

Best,

--nab
