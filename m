From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
 requeues
Date: Wed, 4 Oct 2017 10:52:36 +0200
Message-ID: <20171004085236.bz7x4gb5g3b3sbpt@linux-x5ow.site>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-10-hch@lst.de>
 <mqd7ewbidos.fsf@linux-x5ow.site>
 <20171004072059.GA21411@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171004072059.GA21411@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 04, 2017 at 09:20:59AM +0200, Christoph Hellwig wrote:
> It's a different level of callback - ops are the type of request
> passed through (scsi vs transport) and ->release is s whacky
> implementation detail of the SAS passthrough.  If at all ->release
> should go away eventually by cleaning that mess up.

OK then,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
