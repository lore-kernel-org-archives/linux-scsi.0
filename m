From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 10/20] libfc: Replace ->rport_logoff callback with function
 call
Date: Wed, 19 Oct 2016 08:54:44 -0400
Message-ID: <alpine.OSX.2.00.1610190851460.354@administrators-macbook-pro.local>
References: <1476777714-3543-1-git-send-email-hare@suse.de> <1476777714-3543-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:28539
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935738AbcJSQaH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 12:30:07 -0400
In-Reply-To: <1476777714-3543-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>



On Tue, 18 Oct 2016, 8:01am -0000, Hannes Reinecke wrote:

> The ->rport_logoff callback only ever had one implementation,
> so we can as well call it directly and drop the callback.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_tgt.c |  3 +--
>  drivers/scsi/fcoe/fcoe_ctlr.c    |  8 ++++----
>  drivers/scsi/libfc/fc_disc.c     |  8 ++++----
>  drivers/scsi/libfc/fc_lport.c    | 10 +++++-----
>  drivers/scsi/libfc/fc_rport.c    |  8 +++-----
>  include/scsi/libfc.h             |  9 +--------
>  6 files changed, 18 insertions(+), 28 deletions(-)
> 

Straightforward conversion.

Reviewed-by: Chad Dupuis <chad.dupuis@cavium.com>
