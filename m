From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] random: export add_disk_randomness
Date: Mon, 28 Apr 2014 04:29:08 -0700
Message-ID: <20140428112908.GB2808@infradead.org>
References: <20140425073610.GA2143@infradead.org>
 <20140425073637.GB2143@infradead.org>
 <20140425134951.GF11124@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140425134951.GF11124@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 25, 2014 at 09:49:51AM -0400, Theodore Ts'o wrote:
> On Fri, Apr 25, 2014 at 12:36:37AM -0700, Christoph Hellwig wrote:
> > This will be needed for pending changes to the scsi midlayer that now calls
> > lower level block APIs, as well as any blk-mq driver that wants to contribute
> > to the random pool.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Jens, can you pull this into the block tree for me?
