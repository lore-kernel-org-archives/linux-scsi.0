From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into bsg_setup_queue
Date: Wed, 11 Jan 2017 09:42:44 +0100
Message-ID: <20170111084218.GB6286@linux-x5ow.site>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-15-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752468AbdAKImv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 03:42:51 -0500
Content-Disposition: inline
In-Reply-To: <1484060780-15592-15-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Tue, Jan 10, 2017 at 04:06:19PM +0100, Christoph Hellwig wrote:
> Simply the boilerplate code needed for bsg nodes a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

that reminds me of posting my SAS bsg-lib patch...

Anyways looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
