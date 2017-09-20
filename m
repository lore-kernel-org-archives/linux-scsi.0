From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi_transport_fc: set scsi_target_id upon rescan
Date: Wed, 20 Sep 2017 09:12:52 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1709200911300.817@administrators-MacBook-Pro.local>
References: <1505890733-48870-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0074.outbound.protection.outlook.com ([104.47.42.74]:22848
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751009AbdITNNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Sep 2017 09:13:13 -0400
In-Reply-To: <1505890733-48870-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Smart <james.smart@broadcom.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On Wed, 20 Sep 2017, 2:58am, Hannes Reinecke wrote:

> From: Hannes Reinecke <hare@suse.com>
> 
> When an rport is found in the bindings array there is no guarantee that
> it had been a target port, so we need to call fc_remote_port_rolechg()
> here to ensure the scsi_target_id is set correctly.
> Otherwise the port will never be scanned.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_transport_fc.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 

Verified that port is scanned after applying this patch.

Tested-by: Chad Dupuis <chad.dupuis@cavium.com>
