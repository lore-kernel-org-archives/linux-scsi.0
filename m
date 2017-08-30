From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/3] Call scsi_initialize_rq() also for filesystem
        requests
Date: Wed, 30 Aug 2017 10:29:28 +0200
Message-ID: <20170830082928.GA17935@lst.de>
References: <20170830000742.29653-1-bart.vanassche@wdc.com> <20170830000742.29653-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48536 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbdH3I3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 04:29:30 -0400
Content-Disposition: inline
In-Reply-To: <20170830000742.29653-2-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Looks good except for the subject, which will need a little update:

Reviewed-by: Christoph Hellwig <hch@lst.de>
