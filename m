From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi_lib: Add #include <scsi/scsi_transport.h>
Date: Mon, 8 May 2017 09:35:32 +0200
Message-ID: <20170508073532.GD3982@linux-x5ow.site>
References: <20170502174503.13277-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36339 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751982AbdEHHff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 May 2017 03:35:35 -0400
Content-Disposition: inline
In-Reply-To: <20170502174503.13277-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

On Tue, May 02, 2017 at 10:45:03AM -0700, Bart Van Assche wrote:
> This patch avoids that when building with W=1 the compiler
> complains that __scsi_init_queue() has not been declared.
> See also commit d48777a633d6 ("scsi: remove __scsi_alloc_queue").
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
