From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 01/12] block: Fix declaration of blk-mq debugfs
 functions
Date: Fri, 8 Sep 2017 10:05:03 +0200
Message-ID: <20170908080503.caywdsvmpxsvmhwa@linux-x5ow.site>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35153 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754178AbdIHIFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Sep 2017 04:05:08 -0400
Content-Disposition: inline
In-Reply-To: <20170907161640.30465-2-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

On Fri, Sep 08, 2017 at 01:16:29AM +0900, Damien Le Moal wrote:
> __blk_mq_debugfs_rq_show() and blk_mq_debugfs_rq_show() are exported
> symbols but ar eonly declared in the block internal file
             are only

Otherwise this looks good to me,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
