From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 4/4] scsi-mq: Always unprepare before requeuing a
        request
Date: Thu, 31 Aug 2017 12:05:00 +0200
Message-ID: <20170831100500.GH21443@lst.de>
References: <20170830235842.29725-1-bart.vanassche@wdc.com> <20170830235842.29725-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54406 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751354AbdHaKFB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 06:05:01 -0400
Content-Disposition: inline
In-Reply-To: <20170830235842.29725-5-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
