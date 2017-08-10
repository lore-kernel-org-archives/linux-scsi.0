From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC PATCH 4/6] bsg: refactor ioctl to use regular BSG-command
 infrastructure for SG_IO
Date: Thu, 10 Aug 2017 10:24:56 +0200
Message-ID: <20170810082456.GI4841@linux-x5ow.site>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <ce1d611619cb54c6ff033beab8337ecee29d12d7.1502120928.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ce1d611619cb54c6ff033beab8337ecee29d12d7.1502120928.git.bblock@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 09, 2017 at 04:11:18PM +0200, Benjamin Block wrote:
> +	return 0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL);

return !(bc->hdr.flags & BSG_FLAG_Q_AT_TAIL); and make the function return
bool? I have to admit, this is the 1st time I have seen the above construct.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
