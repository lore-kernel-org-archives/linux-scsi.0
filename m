From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 7/7] fcoe: Harden CVL handling when we have not logged
 into the fabric.
Date: Fri, 30 Sep 2016 09:27:40 +0200
Message-ID: <20160930072740.plxlhxjuyqdjtwtg@linux-x5ow.site>
References: <1475219054-31241-1-git-send-email-hare@suse.de>
 <1475219054-31241-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932110AbcI3H1m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 03:27:42 -0400
Content-Disposition: inline
In-Reply-To: <1475219054-31241-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org

On Fri, Sep 30, 2016 at 09:04:14AM +0200, Hannes Reinecke wrote:
> From: Chad Dupuis <chad.dupuis@cavium.com>
> 
> If we haven't logged into the fabric yet we want to be a little more nuanced
> with our CVL handling than what we've been:
> 
> - If the FCF has been selected, check the source MAC to make sure the frame is
> from the FCF we've selected.
> - If a FCF is selected and the CVL is from the FCF but we have not logged in
> yet, then reset everything and go back to solicitation.
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fcoe/fcoe_ctlr.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
