From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 10/24] libfc: Rework PRLI handling
Date: Thu, 13 Oct 2016 16:02:01 +0200
Message-ID: <20161013140201.4inzplhywgz4kipa@linux-x5ow.site>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751510AbcJMOD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 10:03:57 -0400
Content-Disposition: inline
In-Reply-To: <1476364260-12191-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Oct 13, 2016 at 03:10:46PM +0200, Hannes Reinecke wrote:
> PRLI is only required if the port is acting as an initiator; ports
> which support target functionality only do not need to send PRLI.
> At the same time the PRLI state is only used if the port initiated
> a PRLI transfer; if we received a PRLI request we should _not_
> change the state as this would cause our PRLI response to be dropped.
> And when we receive a PRLI response we need to check if an image
> pair has been established; if not the remote port cannot act as a
> target for us and we need to disable target functionality.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Acked-by: Johannes Thumshirn <jth@kernel.org>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
