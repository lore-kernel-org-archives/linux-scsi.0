From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/7] libfc: Do not drop down to FLOGI for fc_rport_login()
Date: Fri, 30 Sep 2016 09:26:50 +0200
Message-ID: <20160930072650.f3wvcbktfkq2knkn@linux-x5ow.site>
References: <1475219054-31241-1-git-send-email-hare@suse.de>
 <1475219054-31241-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932496AbcI3H05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 03:26:57 -0400
Content-Disposition: inline
In-Reply-To: <1475219054-31241-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Sep 30, 2016 at 09:04:11AM +0200, Hannes Reinecke wrote:
> When fc_rport_login() is called while the rport is not
> in RPORT_ST_INIT, RPORT_ST_READY, or RPORT_ST_DELETE
> login is already in progress and there's no need to
> drop down to FLOGI; doing so will only confuse the
> other side.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/libfc/fc_rport.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
