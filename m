From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] move blk_iopoll to limit and make it generally
	available
Date: Wed, 18 Nov 2015 14:58:39 +0100
Message-ID: <20151118135839.GB18820@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-2-git-send-email-hch@lst.de> <564637BC.7080604@sandisk.com> <20151114070248.GB27738@lst.de> <564B60EC.3050106@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564B60EC.3050106@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2015 at 09:16:28AM -0800, Bart Van Assche wrote:
> How about renaming blk_iopoll into blk_poll ? That way the name still 
> refers to the block layer. And although the current implementation performs 
> polling from IRQ context future implementations maybe will allow polling 
> from thread context.

Well, the point is that there is no block layer specific code in there,
and the RDMA stack isn't really part of the block layer either.
