From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET #upstream] block/libata: update and use block layer  padding and draining
Date: Fri, 8 Feb 2008 22:04:22 +0100
Message-ID: <20080208210422.GG23197@kernel.dk>
References: <12021979851743-git-send-email-htejun@gmail.com> <47AA4C53.5050503@garzik.org> <47ACC1E2.5040905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47ACC1E2.5040905@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 08 2008, Jeff Garzik wrote:
> Jeff Garzik wrote:
> >Tejun Heo wrote:
> >>This patchset updates block layer padding and draining support and
> >>make libata use it.  It's based on James Bottomley's initial work and,
> >>of the five, the last two patches are from James with some
> >>modifications.
> >>
> >>Please read the following thread for more info.
> >>
> >>  http://thread.gmane.org/gmane.linux.scsi/37185
> >>
> >>This patchset is on top of
> >>
> >>  upstream (a6af42fc9a12165136d82206ad52f18c5955ce87)
> >>+ kill-n_iter-and-fix-fsl patch [1]
> >
> >ACK patchset...  lets definitely get these fixes upstream.
> >
> >Once Jens is happy, I would prefer the merge the lot upstream, if that 
> >is OK with everyone involved?
> 
> Jens, ping?
> 
> It's a bug fix, so it would be nice to get this in soonish.  As noted, 
> if all looks good, I would prefer to merge via libata-dev...

I'm ok with it, but lets please merge the block bits through the block
repo, since they are not trivial. Wont be until the week after next,
though.

-- 
Jens Axboe

