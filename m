From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 5/7 alloc a request_queue on each scsi_alloc_sdev call
Date: Tue, 25 Mar 2003 07:12:24 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325071224.A30790@infradead.org>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030324180325.D15047@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Mar 24, 2003 at 06:03:25PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 24, 2003 at 06:03:25PM -0800, Patrick Mansfield wrote:
> Call scsi_alloc_queue each time we call scsi_alloc_sdev; call
> scsi_free_queue each time we do not find backing LUN.
> 
> This code is less optimal, but leads to cleaner code, and the lock
> split-up patch needs this change.

I think this needs to be deferred until akpm (or someone else) implemented
the lazy request allocation.

