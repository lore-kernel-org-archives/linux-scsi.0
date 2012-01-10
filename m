From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Tue, 10 Jan 2012 13:04:03 -0800
Message-ID: <1326229443.20199.2.camel@haakon2.linux-iscsi.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
	 <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
	 <1326225067.3264.51.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1326225067.3264.51.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-01-10 at 13:51 -0600, James Bottomley wrote:
> On Tue, 2012-01-10 at 11:33 -0800, Nicholas A. Bellinger wrote:
> > On Tue, 2012-01-10 at 19:19 +0000, Bart Van Assche wrote:
> > > 2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>
> > > > *) Initial merge for the SRP target (ib_srpt) fabric module (bart)
> > > 
> > > As far as I know the last time that patch was posted for review is
> > > November 4 (http://permalink.gmane.org/gmane.linux.scsi.target.devel/420).
> > > The date of the ib_srpt commit is December 16
> > > (http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=a42d985bd5b234da8b61347a78dc3057bf7bb94d).
> > > The two patches aren't identical. That makes me wonder whether that
> > > patch should have been reposted for review ?
> > > 
> > 
> > Hi Bart,
> > 
> > The changes since the Nov 4 RFC are listed in the patch commit log:
> > 
> > ib_srpt: Make compilation with BUG=n proceed`
> > ib_srpt: Use new target_core_fabric.h include
> > ib_srpt: Check hex2bin() return code to silence build warning
> > 
> > These are all very minor and did not warrant another full RFC posting.
> 
> They might not warrant a full RFC reposting, but individually they
> should have been posted to the list, so Bart is right.
> 

Thanks for your input here, but the last two where reported to
linux-next / target-devel and fixed weeks ago.  The first one was from
Bart himself.

> As a maintainer, there shouldn't be a patch in your tree that hasn't
> been over the mailing list once.  This is for three reasons
> 
>      1. Git is a great source control tool, bit it doesn't hugely
>         facilitate review.  Even virtuoso git users find it easier to
>         read and reply to emailed patches for this purpose
>      2. Not everyone in our community is a wholesale git user.  For
>         them, email might be the only way they get to see a patch, so
>         using git alone lowers our pool of reviewers (and reviewers are
>         the species we most need to encourage)
>      3. Enforcing the rule that everything is emailed first can save you
>         from the maintainers curse:  the temptation to bung in that last
>         little "obvious" fix just before you send your tree to Linus
>         which later turns out to cause huge regressions and much
>         heartache.
> 
> You don't have to endlessly repost patch series, just make sure that
> small updates get posted for review and comment before they get applied.
> 

Yes, yes and yes.  :)

--nab
