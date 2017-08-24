From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/19] scsi_setup_fs_cmnd(): Call scsi_req_init()
        instead of open-coding it
Date: Thu, 24 Aug 2017 11:05:14 +0200
Message-ID: <20170824090514.GE19886@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-6-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48608 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751707AbdHXJFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 05:05:15 -0400
Content-Disposition: inline
In-Reply-To: <20170823214009.15015-6-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

I don't really see the point of doing more work in exactly the same
amount of code here, especially given that this is the fast path.

Do you need this for any future patches?
