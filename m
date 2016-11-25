From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch] scsi: libfc: Remove an unneeded condition
Date: Fri, 25 Nov 2016 09:59:23 +0100
Message-ID: <20161125085923.6otsquagucobujhj@linux-x5ow.site>
References: <20161124105238.GB17225@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753802AbcKYJAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 04:00:08 -0500
Content-Disposition: inline
In-Reply-To: <20161124105238.GB17225@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, Nov 24, 2016 at 01:52:38PM +0300, Dan Carpenter wrote:
> We verified that resp_code is FC_SPP_RESP_ACK earlier so we don't need
> to check again here.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Looks good,
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
