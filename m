From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 06/19] Document which queue type a function is intended
        for
Date: Thu, 24 Aug 2017 18:58:06 +0200
Message-ID: <20170824165806.GA28998@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-7-bart.vanassche@wdc.com> <20170824090535.GF19886@lst.de> <1503593822.2702.18.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50736 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753497AbdHXQ6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 12:58:07 -0400
Content-Disposition: inline
In-Reply-To: <1503593822.2702.18.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

On Thu, Aug 24, 2017 at 04:57:03PM +0000, Bart Van Assche wrote:
> Is something like the patch below perhaps what you had in mind?

Yes.  Except that I really don't like the sq naming - blk-mq can
also be used for single queues, so it's a rather confusing name
Something like legacy or old seems to be more suitable.
