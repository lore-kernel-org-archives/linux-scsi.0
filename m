From: Rik van Riel <riel@conectiva.com.br>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Fri, 27 Sep 2002 11:56:49 -0300 (BRT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L.0209271155510.22735-100000@imladris.surriel.com>
References: <389902704.1033133455@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <389902704.1033133455@aslan.scsiguy.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 27 Sep 2002, Justin T. Gibbs wrote:

> writes *unless* you are creating an ISO image on your disk.  In my opinion
> it is much more important to optimize for the more common, concurrent
> read case, than it is for the sequential write case with intermittent
> reads.

You're missing the point.  The only reason the reads are
intermittent is that the application can't proceed until
the read is done and the read is being starved by writes.

If the read was serviced immediately, the next read could
get scheduled quickly and they wouldn't be intermittant.

Rik
-- 
Bravely reimplemented by the knights who say "NIH".

http://www.surriel.com/		http://distro.conectiva.com/

Spamtraps of the month:  september@surriel.com trac@trac.org
