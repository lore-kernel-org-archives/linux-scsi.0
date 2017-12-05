From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Tue, 5 Dec 2017 12:00:16 +0800
Message-ID: <20171205040015.GA9885@ming.t460p>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
 <20171205003809.1705-2-bart.vanassche@wdc.com>
 <20171205011536.GC8365@ming.t460p>
 <yq1zi6x3knv.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1zi6x3knv.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 04, 2017 at 10:42:28PM -0500, Martin K. Petersen wrote:
> 
> Hi Ming,
> 
> > Please cook a patch for fixing the crash issue only, since we need
> > to backport the fix to stable kernel.
> 
> I thought you were going to submit a V5 that addressed James' concerns?
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

Hi Martin,

I replied in the following link for James's concerns:

	https://marc.info/?l=linux-block&m=151074751321108&w=2

The fact is that use-after-free can't avoided at all, no matter if
we set the cmnd to NULL before calling free, that means we have to
handle use-after-free well in scsi_show_rq(), so we don't need to
touch the free code.

So V4 is well enough for merge, IMO.


Thanks,
Ming
