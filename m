From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 1/4] Call scsi_initialize_rq() also for filesystem
 requests
Date: Thu, 31 Aug 2017 09:13:24 +0200
Message-ID: <20170831071324.cgjoqpv4cbngbvpz@linux-x5ow.site>
References: <20170830235842.29725-1-bart.vanassche@wdc.com>
 <20170830235842.29725-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750968AbdHaHNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 03:13:32 -0400
Content-Disposition: inline
In-Reply-To: <20170830235842.29725-2-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Brian King <brking@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
