From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] BNX2I: Optimized the iSCSI offload performance
Date: Mon, 16 May 2011 14:13:37 -0500
Message-ID: <4DD17761.5060606@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1305569600-1523-4-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38233 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1EPTNs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 15:13:48 -0400
In-Reply-To: <1305569600-1523-4-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 05/16/2011 01:13 PM, Eddie Wai wrote:
> 5. Changed the cmd_per_lun from 32 to 24.
>

What was the reason for this?

> @@ -2159,7 +2165,7 @@ static struct scsi_host_template bnx2i_host_template = {
>   	.change_queue_depth	= iscsi_change_queue_depth,
>   	.can_queue		= 1024,
>   	.max_sectors		= 127,
> -	.cmd_per_lun		= 32,
> +	.cmd_per_lun		= 24,
>   	.this_id		= -1,
>   	.use_clustering		= ENABLE_CLUSTERING,
>   	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,

