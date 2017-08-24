From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/1] bsg-lib: fix kernel panic resulting from
        missing allocation of reply-buffer
Date: Thu, 24 Aug 2017 10:45:56 +0200
Message-ID: <20170824084556.GA19418@lst.de>
References: <cover.1503528302.git.bblock@linux.vnet.ibm.com> <4cf376032b459b7a14cdad22987177b86cc669c0.1503528302.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4cf376032b459b7a14cdad22987177b86cc669c0.1503528302.git.bblock@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

>  /**
> - * bsg_destroy_job - routine to teardown/delete a bsg job
> + * bsg_teardown_job - routine to teardown a bsg job
>   * @job: bsg_job that is to be torn down
>   */
> -static void bsg_destroy_job(struct kref *kref)
> +static void bsg_teardown_job(struct kref *kref)

Why this rename?  The destroy name seems to be one of the most
common patterns for the kref_put callbacks.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
