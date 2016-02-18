From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 16/23] scsi_dh_alua: Recheck state on unit attention
Date: Thu, 18 Feb 2016 13:16:44 -0800
Message-ID: <56C634BC.4030301@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0090.outbound.protection.outlook.com ([157.56.111.90]:5725
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947811AbcBRVQr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:16:47 -0500
In-Reply-To: <1455524690-121073-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> When we receive a unit attention code of 'ALUA state changed'
> we should recheck the state, as it might be due to an implicit
> ALUA state transition. This allows us to return NEEDS_RETRY
> instead of ADD_TO_MLQUEUE, allowing to terminate the retries
> after a certain time.
> At the same time a workqueue item might already be queued, which
> should be started immediately to avoid any delays.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
