From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Wed, 11 Jan 2012 05:49:40 -0500
Message-ID: <20120111104940.GA5394@infradead.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
 <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
 <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
 <1326225067.3264.51.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1326225067.3264.51.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bvanassche@acm.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, J?rn Engel <joern@purestorage.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 10, 2012 at 01:51:07PM -0600, James Bottomley wrote:
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

At least 2 and 3 list, just not as global patches against the
target tree, not ib_srpt specificly:

2 is from: [PATCH] target: header reshuffle, part2
3 is from: [PATCH 5/5] target: check hex2bin result

Not sure about 1.

I'm really getting tired of this bickering. It's a brand new driver and
doesn't have to be perfect.  While Bart generally has technically good
points there's really no reason to put his remaining fixups in after
the driver has been merged and available to a wieder audience.
