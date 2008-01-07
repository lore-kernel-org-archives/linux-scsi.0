From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Mon, 7 Jan 2008 16:28:10 +1100
Message-ID: <200801071628.11381.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071538.58875.rusty@rustcorp.com.au> <4781B234.7070805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4781B234.7070805@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 07 January 2008 16:01:40 Tejun Heo wrote:
> > But we hit the same problems:
> >
> > 1) sg_chain loses information.  The clever chain packaging makes reading
> > easy, but manipulation is severely limited.  You can append to your own
> > chains by padding, but not someone elses.  This works for SCSI, but what
> > about the rest of us?  And don't even think of joining mapped chains: it
> > will almost work.
>
> You can append by allocating one more element on the chain to be
> appended and moving the last element of the first chain to it while
> using the last element for chaining.

Hi Tejun,

   Nice try!  Even ignoring the ugliness of undoing such an operation if the 
caller doesn't expect you to mangle their chains, consider a one-element sg 
array. :(

Cheers,
Rusty.
