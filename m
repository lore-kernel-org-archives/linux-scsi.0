From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] scsi: sd: Contribute to randomness when running
 rotational device
Date: Thu, 6 Sep 2018 18:42:10 -0400
Message-ID: <20180906224210.GK5098@thunk.org>
References: <20180906203719.209399-1-xueweiz@google.com>
 <1536272873.26747.11.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536272873.26747.11.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Xuewei Zhang <xueweiz@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aditya Kali <adityakali@google.com>, Guenter Roeck <groeck@chromium.org>, maze@google.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 06, 2018 at 03:27:53PM -0700, Bart Van Assche wrote:
> 
> Although this patch looks fine to me, seeing this patch makes me wonder
> whether the default should be changed (QUEUE_FLAG_MQ_DEFAULT) instead of
> modifying the sd driver. Can anyone remind me why QUEUE_FLAG_MQ_DEFAULT does
> not include QUEUE_FLAG_ADD_RANDOM?

There was a discussion about a number of *years* ago; blk-mq has been
baking for a very long time.  In the early days of block_mq, the
overwhelming percentage of the users of blk-mq where those who were
using PCIe attached flash.  So when, I raised this question, the
argument was that SSD users have no entropy.  Which I agree with; but
now that blk-mq is the default, and hard drives are using blk-mq, it's
time for a patch like Xuewei's.

Cheers,

					- Ted
