From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi-mq V2
Date: Mon, 30 Jun 2014 08:25:24 -0700
Message-ID: <20140630152524.GA3709@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <53ABA6A4.8090400@kernel.dk>
 <53B18053.2030805@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53B18053.2030805@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 30, 2014 at 09:20:51AM -0600, Jens Axboe wrote:
> Ran stress testing from Friday to now, 65h of beating up on it and no
> problems observed. 47TB read and 20TB written for a total of 17.7
> billion of IOs issued and completed. Latencies look good. I officially
> declare this code for bug free.
> 
> Bug-free-by: Jens Axboe <axboe@fb.com>
> 
> Now lets get this queued up for inclusion, pretty please.

I'm still looking for one (or better two) persons familar with the
SCSI and/or block code to go over it and do a real detailed review.
