From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/8] Added bug fixes and several features for BNX2I
Date: Wed, 05 Jan 2011 14:52:04 -0600
Message-ID: <1294260724.16957.29.camel@mulgrave.site>
References: <Eddie Wai <eddie.wai@broadcom.com>
	 <1294260267-17413-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47871 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1AEUwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:52:13 -0500
In-Reply-To: <1294260267-17413-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On Wed, 2011-01-05 at 12:44 -0800, Eddie Wai wrote:
> Hello,
>     
> This patch set contains two fixes and added various features as titled.
> The two fixes are:
> 1 - connection cleanup fix which fixes a chip panic issue
> 2 - nopout LUN field fix which fixes nopout timeouts

So the immediate question is do these need backporting to earlier
kernels via the stable tree (in which case a cc: stable@kernel.org tag
would be needed)?

James


> The features added includes TCP timestamp, jumbo MTU, text pdu support
> for discovery offload, and 57712(E) support.
> 
> Please review.  Thanks.
> Eddie
> 
> Eddie Wai (8):
>   BNX2I: Allow ep CONNECT_FAILED condition to go through proper cleanup
>   BNX2I: Fixed the 32-bit swapping of the LUN field for nopouts for
>     5771X
>   BNX2I: Added handling for unsupported iSCSI offload hba
>   BNX2I: Added support for the 57712(E) devices
>   BNX2I: Added TCP timestamps option support
>   BNX2I: Added jumbo MTU support for the no shost case
>   BNX2I: Added iSCSI text pdu support for iSCSI offload
>   BNX2I: Updated to version 2.6.2.3
> 
>  drivers/net/bnx2x/bnx2x_main.c   |    7 --
>  drivers/scsi/bnx2i/bnx2i.h       |    5 +-
>  drivers/scsi/bnx2i/bnx2i_hwi.c   |  122 +++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/bnx2i/bnx2i_init.c  |   33 ++++++++--
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |   10 +++-
>  include/linux/pci_ids.h          |    2 +
>  6 files changed, 160 insertions(+), 19 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


