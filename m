From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 03/23] scsi_dh_alua: Make stpg synchronous
Date: Thu, 18 Feb 2016 11:25:45 -0800
Message-ID: <56C61AB9.7010006@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:22880
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947019AbcBRT0u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 14:26:50 -0500
In-Reply-To: <1455524690-121073-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
>   	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: stpg failed, unhandled TPGS state %d",
> +			    ALUA_DH_NAME, h->state);
> +		return SCSI_DH_NOSYS;
>   		break;
>   	}

The "break" above should have been removed. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
