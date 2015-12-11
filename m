From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 0/15] copy offload patches
Date: Fri, 11 Dec 2015 11:55:09 -0800
Message-ID: <20151211195509.GA2217@infradead.org>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
 <yq1r3iuylwd.fsf@sermon.lab.mkp.net>
 <566A59BC.9060305@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566A59BC.9060305@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 11:06:04PM -0600, Mike Christie wrote:
> 
> 2. Start REQ_OP_READ off at non-zero to try and shake out code that was
> not converted.
> 
> There are a several places where we assume reads are zero and writes are
> 1 for things like indexing in arrays (like blktrace's ddir_act or dm
> starts), passing into block functions (like nvme_alloc_request's call of
> blk_mq_alloc_request), and if/else's. I am not done fixing all of them
> and testing.

If this turns out to be too painful we should just skip it.  I though it
would be a nie debugging aid, but we don't need to do it at any cost.
