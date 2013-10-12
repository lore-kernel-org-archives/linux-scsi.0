From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: Pass through I/O topology for block backstores
Date: Sat, 12 Oct 2013 01:08:24 -0700
Message-ID: <20131012080824.GA12362@infradead.org>
References: <1381513206-8155-1-git-send-email-agrover@redhat.com>
 <20131011180348.GA21030@infradead.org>
 <52584905.4080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52584905.4080307@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 11, 2013 at 11:52:53AM -0700, Andy Grover wrote:
> It seemed better to me to keep the munging from queue_limits values
> to what the target core needed in the block backstore code, and not
> use a block-specific structure in the backstore<->core interface.
> 
> It looks like a few includes of blkdev.h slipped into target core,
> but these can be removed safely -- lio core doesn't depend on the
> block layer.
> 
> We could define a new struct to get the 4 values at once, but it
> didn't seem worth it, esp. since two are only needed by
> emulate_readcapacity16, and the other two only by emulate_evpd_b0.

I really don't like the influx of methods.  But given thsat you have
done the work I'd say merge your patch for now and then we can later see
if we can come up with something more elegant.
