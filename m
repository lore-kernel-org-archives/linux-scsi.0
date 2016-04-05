From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/5] scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
Date: Tue, 5 Apr 2016 10:55:55 -0400
Message-ID: <20160405145555.GE7822@mtj.duckdns.org>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
 <1459806491-16428-5-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459806491-16428-5-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 04, 2016 at 02:48:10PM -0700, Ming Lin wrote:
> From: Ming Lin <ming.l@ssi.samsung.com>
> 
> Rename SCSI_MAX_SG_SEGMENTS to SG_CHUNK_SIZE, which means the amount
> we fit into a single scatterlist chunk.
> 
> Rename SCSI_MAX_SG_CHAIN_SEGMENTS to SG_MAX_SEGMENTS.
> 
> Will move these 2 generic definitions to scatterlist.h later.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Bart Van Assche <bart.vanassche@sandisk.com> (for ib_srp changes)
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>

For libata,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
