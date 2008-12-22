From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Firmware patches for SCSI
Date: Mon, 22 Dec 2008 09:01:03 -0600
Message-ID: <1229958063.3345.3.camel@localhost.localdomain>
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
	 <1229718543.18778.4.camel@localhost.localdomain>
	 <3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>
	 <1229720031.18778.8.camel@localhost.localdomain>
	 <20081222171904.b588da94.sfr@canb.auug.org.au>
	 <494F4656.6010109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <494F4656.6010109@panasas.com>
Sender: linux-next-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jaswinder Singh <jaswinderlinux@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-12-22 at 09:48 +0200, Boaz Harrosh wrote:
> Stephen Rothwell wrote:
> > Hi James,
> > 
> > On Fri, 19 Dec 2008 15:53:51 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >> OK, then whatever tree contains them needs to eject them or be dropped
> >> from linux-next.
> > 
> > That is a problem for me and David.  Do not let it concern you ... :-)
> > 
> >>> So I am curious that should I resend these patches based on which git tree.
> >> Yes please.  For me it would be against scsi-misc ... for the other
> >> drivers it would be their development tree.  The simplest thing to do is
> >> probably to rebase them all on top of linux-next (which contains all of
> >> our trees) and then send them to the individual subsystem maintainer
> >> lists.
> > 
> > Please don't do that, please base each one on either Linus' tree or the
> > appropriate maintainer's subsystem tree as linux-next is a moving
> > target (for instance, if you had based the scsi ones on next-20081219,
> > then the scsi tree was not included ...).  Basing on Linus' tree should
> > work in most cases as there are not to many conflicts caused by these
> > patches (the tg3 one is the worst so basing that off the net tree is
> > probably worth while).
> > 
> 
> I think what James meant is to rebase over linux-next when cutting the
> patches in order to send them to the different maintainers over email.
> In that case linux-next is perfect because you are sure none of the
> patches will conflict with any maintainer and you do that all in one
> place. Since you are not merging then linux-next volatility does not
> matter.

Yes, that's precisely what I meant, thanks!

The point is that it's hard to work out where all the maintainer trees
are, and git makes rebasing an easy exercise, so you just prepare your
patch set against one version of linux-next ... you can rebase it to
future versions as much as you like until you're ready with
git-send-email to send off the patch sets.  Linux-next is only useless
as a base for an upstream git tree; it makes a good work ground for a
volatile one that's essentially only holding patches for onward
transmission (as patches not as a git tree).

I suppose the caveat is that you have to be intimately familiar with how
git rebase works, so this course of action isn't for the faint of heart.

James
