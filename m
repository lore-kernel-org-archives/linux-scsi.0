From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Thu, 5 Jan 2012 10:38:42 -0800
Message-ID: <20120105183842.GF18486@google.com>
References: <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
 <20111228211918.GA3516@google.com>
 <20120103173500.GB31746@google.com>
 <20120103175922.GC31746@google.com>
 <20120103200906.GG31746@google.com>
 <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
 <20120105012445.GP31746@google.com>
 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
Sender: linux-ide-owner@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Hugh.

On Thu, Jan 05, 2012 at 10:36:21AM -0800, Hugh Dickins wrote:
> I can vouch that it makes the list_debug.c:53 warnings go away: they
> used to come in half an hour, but I've run on two machines for 10
> hours so far without seeing any.

Yeah, my overnight test is pretty conclusive too.  I can usually hit
the bug under 30mins without the patch.

> And I've not yet seen a cfq-iosched.c:2585 with that patch in; but
> those were more elusive - we'll have to run until tomorrow night
> before concluding that it makes those go away too.
> 
> Or if you understand the connection between these, and would prefer
> to assume that it fixes them both, and want me to try another patch
> instead (I assume the one I'm running with is a workaround to narrow
> down the issue, rather than an intended fix?), let me know and I'll
> switch over.

Yeap, I can see the connections now and think I know where the bug is
too.  I'll, hopefully, be able to post fix soon.

Thanks.

-- 
tejun
