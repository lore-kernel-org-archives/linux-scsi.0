From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH v2 1/3] Call scsi_initialize_rq() also for filesystem
        requests
Date: Thu, 31 Aug 2017 11:50:19 +0200
Message-ID: <20170831095019.GA21004@lst.de>
References: <20170830000742.29653-1-bart.vanassche@wdc.com> <20170830000742.29653-2-bart.vanassche@wdc.com> <20170830082928.GA17935@lst.de> <1504127579.2526.58.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54295 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbdHaJuU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 05:50:20 -0400
Content-Disposition: inline
In-Reply-To: <1504127579.2526.58.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Wed, Aug 30, 2017 at 09:13:00PM +0000, Bart Van Assche wrote:
> On Wed, 2017-08-30 at 10:29 +0200, Christoph Hellwig wrote:
> > Looks good except for the subject, which will need a little update:
> 
> Hello Christoph,
> 
> Thanks for the review. Sorry but I don't see what's wrong with the subject.
> Can you clarify your comment?

Hi Bart,

I'll take that comment back - I misread scsi_initialize_rq as
.initialize_rq.
