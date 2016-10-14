From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 22/24] fcoe: FIP debugging
Date: Fri, 14 Oct 2016 14:37:01 -0700
Message-ID: <4bffff70-3145-19f4-0446-5abc9b705dc8@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0085.outbound.protection.outlook.com ([104.47.41.85]:26904
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756247AbcJNVhF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:37:05 -0400
In-Reply-To: <1476364260-12191-23-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> Add additional statements for debugging FIP frames.
 > [ ... ]
> @@ -2442,15 +2446,21 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
>  		 */
>  		if (fip->lp->wwpn > rdata->ids.port_name &&
>  		    !(frport->flags & FIP_FL_REC_OR_P2P)) {
> +			LIBFCOE_FIP_DBG(fip, "vn_probe_req: "
> +					"port_id collision\n");
>  			fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
>  					  frport->enode_mac, 0);

Hmm ... checkpatch should have complained about this and should have 
recommended to keep the format string on a single line. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

