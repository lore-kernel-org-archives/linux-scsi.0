From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] linux-next: Tree for October 16 - softlockup detected at blk_invoke_request_fn
Date: Fri, 17 Oct 2008 15:37:50 +0200
Message-ID: <20081017133750.GL19428@kernel.dk>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au> <20081016204212.GC7534@linux.vnet.ibm.com> <20081017065558.GD19428@kernel.dk> <20081017102456.GA8115@linux.vnet.ibm.com> <20081017105753.GG19428@kernel.dk> <20081018001533.06ec0d1b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081018001533.06ec0d1b.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 18 2008, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Fri, 17 Oct 2008 12:57:55 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > OK, I'm guessing it's a merge mess in linux-next. I tried to look at the
> > diff, but it was pretty much impossible to read and even included lots
> > of things in -git already.
> 
> If you are looking at the linux-next patch on kernel.org, then it is
> relative to 2.6.27, so will contain a lot of stuff in Linus' tree.  Its
> purpose is to allow people to recreate the linux-next tree from a kernel
> tarball.
> 
> In the linux-next git tree, the point in Linus' tree that it is based on
> the the "stable" branch.  If necessary, people should be able to bisect
> between the "stabel" and "master" branches of a linux-next tree.  Or, I
> am told, between one linux-next tree and another (but that sounds painful
> to me).

OK, I'll try the -git tree next time I have to lookup changes in -next.
Thanks for the explanation!

-- 
Jens Axboe
