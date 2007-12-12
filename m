From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] REQ-flags to/from BIO-flags bugfix
Date: Wed, 12 Dec 2007 09:33:38 -0700
Message-ID: <20071212163337.GL26334@parisc-linux.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <47462F3C.3040700@googlemail.com> <20071122201250.f957e280.akpm@linux-foundation.org> <47466B5D.90607@googlemail.com> <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain> <475FB316.6040804@panasas.com> <475FBFEE.9010009@panasas.com> <20071212151813.GJ26334@parisc-linux.org> <47600715.9000303@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759246AbXLLQdy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47600715.9000303@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 12, 2007 at 06:06:45PM +0200, Boaz Harrosh wrote:
> Thats not enough You still need to fix code in ll_rw_blk(), I would
> define a rq_flags_bio_match_mask = 0xf for that. 
> (and also add what Jens called "needed" with the
> BIO_RW_AHEAD selects REQ_FAILFAST.)

Yes, I appreciate it's not enough; that's why I didn't sign-off on it.

Nobody currently sets BIO_RW_AHEAD, so I don't understand why we need to
do anything ;-)

> And I still don't understand why, for example, "Domain Validation" fails
> with the original patch. What sets BIO_RW_FAILFAST and than panics
> on Errors?
> (All I see is this flag set in dm/multipath.c & dm-mpath.c)

No idea ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
