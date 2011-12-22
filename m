From: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for Dec 21
Date: Thu, 22 Dec 2011 15:38:43 -0800
Message-ID: <20111222233843.GR17084@google.com>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
 <20111221151503.4d78f94f.akpm@linux-foundation.org>
 <20111222150836.af172886.akpm@linux-foundation.org>
 <20111222232036.GP17084@google.com>
 <20111222152427.c944c747.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111222152427.c944c747.akpm@linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 22, 2011 at 03:24:27PM -0800, Andrew Morton wrote:
> > Hmmm... probably cic allocation failure?
> 
> Dunno, it's an 8Gb 8 CPU x86_64 box.
> 
> >  It's just that those cases happened infrequently
> > enough that nobody really noticed (or at least tracked it down).  How
> > can you reproduce the problem?
> 
> Easily.  One time it got to a login prompt and hung quickly during a
> make.  Every other time (ten times, maybe) it hung during initscripts.

Weird, I can't reproduce the problem on block/for-3.3/core.  Trying
linux-next... hmmm, it works there too.  Can you please share .config?

Thanks.

-- 
tejun
