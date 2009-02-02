From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] block bits
Date: Mon, 2 Feb 2009 19:53:45 +0100
Message-ID: <20090202185345.GM30821@kernel.dk>
References: <20090202131502.GH30821@kernel.dk> <49872DF3.3060401@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757363AbZBBSzx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49872DF3.3060401@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 02 2009, Boaz Harrosh wrote:
> Jens Axboe wrote:
> > Hi Linus,
> > 
> > One critical bit in here, which fixes a reported oops from the iostat
> > patch. The others are either trivial/minor or documentation. Please
> > pull.
> > 
> >   git://git.kernel.dk/linux-2.6-block.git for-linus
> > 
> > Alberto Bertogli (2):
> >       Fix misleading comment in bio.h
> >       bio.h: If they MUST be inlined, then use __always_inline
> > 
> > Jens Axboe (3):
> >       block: fix oops in blk_queue_io_stat()
> >       block: fix inconsistent parenthesisation of QUEUE_FLAG_DEFAULT
> >       block: add text file detailing queue/ sysfs files
> > 
> 
> Hi Jens.
> 
> The bsg sense handling bug fix, is I think, a security breach in that
> Kernel copies dangling Kernel stack back to user-mode. It might even
> need a stable release.
> 
> At the time I was thinking that since bsg is marked EXPERIMENTAL in
> Kconfig then it must not be included in distro's Kernels by default,
> but Benny noted that it is included in Fedora since FC8 or FC9.
> 
> The patch I sent still applies I think?

I'm sure it does, I didn't know if Tomo had swoopt it up himself. I'll
add it to this branch.

-- 
Jens Axboe
