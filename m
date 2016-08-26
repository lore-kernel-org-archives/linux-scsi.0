From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/30] libfc: Revisit kref handling
Date: Fri, 26 Aug 2016 15:37:55 +0200
Message-ID: <20160826133755.dlje4jgk3cv7k475@c203.arch.suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
 <1472212913-39810-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751119AbcHZNiM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 09:38:12 -0400
Content-Disposition: inline
In-Reply-To: <1472212913-39810-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.com>

On Fri, Aug 26, 2016 at 02:01:24PM +0200, Hannes Reinecke wrote:
> The kref handling in fc_rport is a mess. This patch updates
> the kref handling according to the following rules:
> 
> - Take a reference whenever scheduling a workqueue
> - Take a reference whenever an ELS command is send
> - Drop the reference at the end of the workqueue function
> - Drop the reference at the end of handling ELS replies
> - Take a reference when allocating an rport
> - Drop the reference when removing an rport
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
