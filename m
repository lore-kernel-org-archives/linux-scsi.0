From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 03/22] fcoe: FIP debugging
Date: Wed, 3 Aug 2016 10:36:26 -0700
Message-ID: <cbf099ce-5b8d-7426-52c2-a7882105eb80@sandisk.com>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0068.outbound.protection.outlook.com ([104.47.41.68]:28928
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758086AbcHCTOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 15:14:25 -0400
In-Reply-To: <1470230002-37737-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On 08/03/2016 06:13 AM, Hannes Reinecke wrote:
> @@ -2407,15 +2411,21 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
>  		 */
>  		if (fip->lp->wwpn > rdata->ids.port_name &&
>  		    !(frport->flags & FIP_FL_REC_OR_P2P)) {
> +			LIBFCOE_FIP_DBG(fip, "vn_probe_req: "
> +					"port_id collision\n");
>  			fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
>  					  frport->enode_mac, 0);

Some users search through the kernel source tree for error and debug 
messages. For these users it is easier if the entire message occurs on a 
single line. Otherwise this patch looks fine to me.

Bart.
