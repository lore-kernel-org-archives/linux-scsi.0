From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 4/6] bsg: refactor ioctl to use regular BSG-command
        infrastructure for SG_IO
Date: Thu, 10 Aug 2017 11:34:05 +0200
Message-ID: <20170810093405.GO24539@lst.de>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com> <ce1d611619cb54c6ff033beab8337ecee29d12d7.1502120928.git.bblock@linux.vnet.ibm.com> <20170810082456.GI4841@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170810082456.GI4841@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2017 at 10:24:56AM +0200, Johannes Thumshirn wrote:
> On Wed, Aug 09, 2017 at 04:11:18PM +0200, Benjamin Block wrote:
> > +	return 0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL);
> 
> return !(bc->hdr.flags & BSG_FLAG_Q_AT_TAIL); and make the function return
> bool? I have to admit, this is the 1st time I have seen the above construct.

It's a somewhat odd style.  I agree with your comment, but otherwise
the patch looks ok to me.
