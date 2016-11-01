From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] scsi_dh: switch to scsi_execute_req_flags()
Date: Tue, 1 Nov 2016 18:00:07 +0100
Message-ID: <247b5304-90b3-034a-5b1a-3e8efedd3940@suse.de>
References: <1477936770-106687-1-git-send-email-hare@suse.de>
 <20161101144156.GA17827@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbcKARAL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 13:00:11 -0400
In-Reply-To: <20161101144156.GA17827@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On 11/01/2016 03:41 PM, Christoph Hellwig wrote:
> A little warning: scsi_execute_req_flags grew a new argument in the block
> tree to be able to specify the request-only flags.  So any of these
> patches would create a (mostly harmless) conflict in linux-next.
>
I don't mind creating the patches against the block tree.
Martin? Jens? What's the preferred way here?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
