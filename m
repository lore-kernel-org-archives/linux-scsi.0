From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL for 38-rc3]  target updates for v4.0.0-rc7
Date: Mon, 24 Jan 2011 18:48:06 -0800
Message-ID: <1295923686.24778.200.camel@haakon2.linux-iscsi.org>
References: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
	 <1295915790.15425.44.camel@mulgrave.site>
	 <1295918871.24778.161.camel@haakon2.linux-iscsi.org>
	 <1295919523.15425.104.camel@mulgrave.site>
	 <1295920509.24778.172.camel@haakon2.linux-iscsi.org>
	 <1295922411.15425.126.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295922411.15425.126.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-24 at 20:26 -0600, James Bottomley wrote:
> On Mon, 2011-01-24 at 17:55 -0800, Nicholas A. Bellinger wrote:
> > On Mon, 2011-01-24 at 19:38 -0600, James Bottomley wrote:
> [...]
> > > Over the list, please, not in a git tree.  What I need is for others to
> > > review them ... and appearing on the list best encourages that.
> > > 
> > 
> > Yes, but to clarify one item.   All of these patches in for-38-rc3 and
> > for-jejb branches have already been sent out to linux-scsi incrementally
> > when they where committed into LIO upstream code.  Are you asking that
> > the entire patch series be re-sent to linux-scsi against .38-rc2..?
> 
> What I want is for you to tidy them up, make changelogs intelligible,
> sanity  check them (like merge patches for people who submit one patch
> per file), run checkpatch, make sure series compiles and integration
> test them before rolling them up in a batch and sending them on (at an
> interval of about one or two batches per merge window) ... in essence,
> what a maintainer does.
> 

Yes, this is more-or-less exactly I have been doing for the .38 round. 

This particular series could stand to have a few more minor commit's
squashed together, and a quick run through checkpatch as well.  But
other that these small items, the commits have been made tidy, with
intelligible changelogs + proper authorship with target v4.0.0-rc7
running in .38-rc2 x86_64 VM, and the bugfixes ready to be included for
mainline.

Squashing will probably save only 2-3 commits in this particular series,
but I will get these minor items condensed and produce a followup GIT
PULL v2 request from scsi-post-merge-2.6.git/for-38-rc3 against
linus .38-rc2.

Again just to verify, these will be sent out in their entirety to
linux-scsi.

--nab
