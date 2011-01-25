From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL for 38-rc3]  target updates for v4.0.0-rc7
Date: Mon, 24 Jan 2011 20:26:51 -0600
Message-ID: <1295922411.15425.126.camel@mulgrave.site>
References: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
	 <1295915790.15425.44.camel@mulgrave.site>
	 <1295918871.24778.161.camel@haakon2.linux-iscsi.org>
	 <1295919523.15425.104.camel@mulgrave.site>
	 <1295920509.24778.172.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295920509.24778.172.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-24 at 17:55 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2011-01-24 at 19:38 -0600, James Bottomley wrote:
[...]
> > Over the list, please, not in a git tree.  What I need is for others to
> > review them ... and appearing on the list best encourages that.
> > 
> 
> Yes, but to clarify one item.   All of these patches in for-38-rc3 and
> for-jejb branches have already been sent out to linux-scsi incrementally
> when they where committed into LIO upstream code.  Are you asking that
> the entire patch series be re-sent to linux-scsi against .38-rc2..?

What I want is for you to tidy them up, make changelogs intelligible,
sanity  check them (like merge patches for people who submit one patch
per file), run checkpatch, make sure series compiles and integration
test them before rolling them up in a batch and sending them on (at an
interval of about one or two batches per merge window) ... in essence,
what a maintainer does.

James

> > It's also better to use something more stable as the base, like linus
> > head or scsi-misc as the base.  The postmerge tree is my most volatile
> > tree (fairly constantly rebasing as I try to get the merge fixes
> > right) ... and it's currently defunct until another merge clash appears.
> > 
> > By way of demonstration, try pulling your current postmerge tree into
> > linus head and see what happens (the resulting conflicts are because of
> > the rebases).
> 
> Yes sorry, I should have been more specific here wrt to my
> scsi-post-merge-2.6.git branches:
> 
> *) for-38-rc3: rebased to linus .38-rc2 tag
> 
> *) for-jejb: based on jejb scsi-post-merge-2.6.git/master @ .37-FINAL
> from commit 7d2087a1820b (initial LIO target core v4.0.0-rc6 commit)
> 
> Both are now in sync with the upstream LIO tree v4.0.0-rc7 bugfixes, and
> I have been keeping 'for-jejb' as convience for you against your initial
> target merge.
> 
> --nab
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
