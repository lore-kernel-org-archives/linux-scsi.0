From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 5/7 alloc a request_queue on each scsi_alloc_sdev call
Date: Tue, 25 Mar 2003 08:18:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325071851.GL2371@suse.de>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030325071224.A30790@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030325071224.A30790@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Mar 25 2003, Christoph Hellwig wrote:
> On Mon, Mar 24, 2003 at 06:03:25PM -0800, Patrick Mansfield wrote:
> > Call scsi_alloc_queue each time we call scsi_alloc_sdev; call
> > scsi_free_queue each time we do not find backing LUN.
> > 
> > This code is less optimal, but leads to cleaner code, and the lock
> > split-up patch needs this change.
> 
> I think this needs to be deferred until akpm (or someone else) implemented
> the lazy request allocation.

lazy request allocation is coming shortly, hopefully today.

-- 
Jens Axboe

