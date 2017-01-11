From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into
        bsg_setup_queue
Date: Wed, 11 Jan 2017 09:59:34 +0100
Message-ID: <20170111085934.GA7200@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de> <1484060780-15592-15-git-send-email-hch@lst.de> <20170111084218.GB6286@linux-x5ow.site> <20170111084512.GA6937@lst.de> <20170111085601.GC6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111085601.GC6286@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 09:56:01AM +0100, Johannes Thumshirn wrote:
> I'll dig it up and RFC post it. It's currently untested though as I
> currently don't have a SMP capable SAS HBA here.
> 
> Do you have an mptXsas available? 

Unfortunately not.  But I think Hannes has, he has recently played
around with the interrupt handling for the driver.
