From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 17/19] scsi_transport_srp: Suppress a W=1 compiler
        warning
Date: Fri, 25 Aug 2017 17:56:20 +0200
Message-ID: <20170825155620.GA19091@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-18-bart.vanassche@wdc.com> <20170824091157.GP19886@lst.de> <1503592026.2702.12.camel@wdc.com> <20170825152932.GA18440@lst.de> <1503675647.2680.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55806 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933864AbdHYP4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:56:21 -0400
Content-Disposition: inline
In-Reply-To: <1503675647.2680.3.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

This looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
