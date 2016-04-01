From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] scsi: Do not attach VPD to devices that don't support
 it
Date: Fri, 01 Apr 2016 09:44:41 +0200
Message-ID: <942d42b307ff882c51e468104035f6e5@suse.de>
References: <1459493857-4724-1-git-send-email-hare@suse.de>
 <1459493857-4724-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503AbcDAHom (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 03:44:42 -0400
In-Reply-To: <1459493857-4724-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, linux-scsi-owner@vger.kernel.org

On 2016-04-01 08:57, Hannes Reinecke wrote:
> The patch "scsi: rescan VPD attributes" introduced a regression in 
> which
> devices that don't support VPD were being scanned for VPD attributes
> anyway.  This could cause issues for this parts and should be avoided 
> so
> the check for scsi_level has been moved out of scsi_add_lun and into
> scsi_attach_vpd so that all callers will not scan VPD for devices that
> don't support it.
> 
> Fixes: 09e2b0b14690 ("scsi: rescan VPD attributes")
> 
> Suggested-by: Alexander Duyck <aduyck@mirantis.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
