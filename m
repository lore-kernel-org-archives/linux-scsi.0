From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: sd: don't crash the host on invalid commands
Date: Fri, 21 Sep 2018 08:29:47 +0200
Message-ID: <20180921062947.GA4913@linux-x5ow.site>
References: <20180920071907.10102-1-jthumshirn@suse.de>
 <1537467499.224533.21.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537467499.224533.21.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 20, 2018 at 11:18:19AM -0700, Bart Van Assche wrote:
> On Thu, 2018-09-20 at 09:19 +0200, Johannes Thumshirn wrote:
> 
> Have you considered to use WARN_ON_ONCE() instead of WARN_ON(1)? Otherwise
> this patch looks good to me.

Indeed I did and then forgot to 'git commit --amend' it befroe sending it out.
I'll do so now.

	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
