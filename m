From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Performance degradation in IO writes vs. reads (was scsi-mq V2)
Date: Thu, 21 Aug 2014 06:03:15 -0700
Message-ID: <20140821130315.GB1567@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org>
 <53C39F36.9010003@dev.mellanox.co.il>
 <53F5E6C9.1020207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53F5E6C9.1020207@dev.mellanox.co.il>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-fsdevel@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 21, 2014 at 03:32:09PM +0300, Sagi Grimberg wrote:
> So I just got back to checking this issue of *extremely low* IO write
> performance I got in 3.16-rc2.

Please test with 3.16 final.  There once issue each in aio and dio
that caused bad I/O performance regression that were only fixed last
minute in the 3.16 cycle.

