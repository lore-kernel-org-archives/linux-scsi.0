From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Mon, 29 Oct 2018 18:08:26 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1810291805540.5984@nanos.tec.linutronix.de>
References: <20181029163738.10172-1-axboe@kernel.dk> <20181029163738.10172-12-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-12-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens,

On Mon, 29 Oct 2018, Jens Axboe wrote:

> A driver may have a need to allocate multiple sets of MSI/MSI-X
> interrupts, and have them appropriately affinitized. Add support for
> defining a number of sets in the irq_affinity structure, of varying
> sizes, and get each set affinitized correctly across the machine.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

This looks good.

Vs. merge logistics: I'm expecting some other changes in that area as per
discussion with megasas (IIRC) folks. So I'd like to apply that myself
right after -rc1 and provide it to you as a single commit to pull from so
we can avoid collisions in next and the merge window.

Thanks,

	tglx
