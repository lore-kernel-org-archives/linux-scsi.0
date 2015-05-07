From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 07/17] scsi_dh_alua: Pass buffer as function argument
Date: Thu, 7 May 2015 13:57:48 +0200
Message-ID: <554B533C.9040505@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0072.outbound.protection.outlook.com ([207.46.100.72]:15184
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbbEGL5y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:57:54 -0400
In-Reply-To: <1430743343-47174-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> -	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
> -	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
> -	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> -	rq->cmd[9] = h->bufflen & 0xff;
> +	rq->cmd[6] = (bufflen >> 24) & 0xff;
> +	rq->cmd[7] = (bufflen >> 16) & 0xff;
> +	rq->cmd[8] = (bufflen >>  8) & 0xff;
> +	rq->cmd[9] = bufflen & 0xff;

This would have been a good opportunity to introduce 
get_unaligned_be32(). But even without that change:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
