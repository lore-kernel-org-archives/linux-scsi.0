From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing
 file transfers
Date: Fri, 27 Sep 2002 11:20:30 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2484506224.1033147230@aslan.btc.adaptec.com>
References: <389902704.1033133455@aslan.scsiguy.com>
 <Pine.BSF.4.21.0209270833450.21876-100000@beppo>
 <20020927153751.GH23468@suse.de>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020927153751.GH23468@suse.de>
Content-Disposition: inline
To: Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>
Cc: "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> I'm now saying for the 3rd time, that there's zero problem in having a
> huge dirty cache backlog. This is not the problem, please disregard any
> reference to that. Count only the time spent for servicing a read
> request, _from when it enters the drive_ and until it completes. IO
> scheduler is _not_ involved.

On the drive?  That's all I've been saying.

--
Justin
