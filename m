From: Jens Axboe <axboe@suse.de>
Subject: Re: Warning - running *really* short on DMA buffers while doing file transfers
Date: Fri, 27 Sep 2002 17:37:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020927153751.GH23468@suse.de>
References: <389902704.1033133455@aslan.scsiguy.com> <Pine.BSF.4.21.0209270833450.21876-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0209270833450.21876-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 27 2002, Matthew Jacob wrote:
> 
> > If you don't like this behavior, which actually maximizes the
> > throughput of the device, have the I/O scheduler hold back a single
> > processes from creating such a large backlog.
> 
> 
> Justin and I are (for once) in 100% agreement.

Well Justin and you are both, it seems, missing the point.

I'm now saying for the 3rd time, that there's zero problem in having a
huge dirty cache backlog. This is not the problem, please disregard any
reference to that. Count only the time spent for servicing a read
request, _from when it enters the drive_ and until it completes. IO
scheduler is _not_ involved.

-- 
Jens Axboe

