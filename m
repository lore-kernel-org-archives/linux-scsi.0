From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sd: Micro-optimize READ / WRITE CDB encoding
Date: Wed, 18 Oct 2017 08:20:17 +0200
Message-ID: <20171018062017.GA10605@lst.de>
References: <20171017210352.19580-1-bart.vanassche@wdc.com> <yq1vajdtakt.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35614 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759066AbdJRGUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Oct 2017 02:20:18 -0400
Content-Disposition: inline
In-Reply-To: <yq1vajdtakt.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Tue, Oct 17, 2017 at 11:10:42PM -0400, Martin K. Petersen wrote:
> Please take a look at this. It missed 4.15 because I've been fighting a
> hardware bug the last several weeks. However, I'd still like to get it
> in shape for 4.16:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=scsi-work
> 
> Feel free to beat me to it.

It would be great to get it into 4.15, we stil have some time for that.
