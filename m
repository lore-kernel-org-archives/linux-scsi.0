From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 21/23] scsi_dh_alua: use common definitions for ALUA
 state
Date: Thu, 18 Feb 2016 14:08:57 -0800
Message-ID: <56C640F9.4060402@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:28448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1426709AbcBRWJC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 17:09:02 -0500
In-Reply-To: <1455524690-121073-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> @@ -180,7 +172,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
>
>   	/* Prepare the data buffer */
>   	memset(stpg_data, 0, stpg_len);
> -	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> +	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL & 0x0f;
>   	put_unaligned_be16(group_id, &stpg_data[6]);
>

In the previous patch a symbolic name for the ALUA state mask has been 
introduced (SCSI_ACCESS_STATE_MASK). Hence please either leave out "& 
0x0f" from the above code or use that constant.

Bart.
