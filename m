From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 14/23] scsi_dh_alua: Allow workqueue to run
 synchronously
Date: Thu, 18 Feb 2016 13:13:10 -0800
Message-ID: <56C633E6.3080401@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:40925
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964793AbcBRVNQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:13:16 -0500
In-Reply-To: <1455524690-121073-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Some arrays may only capable of handling one STPG at a time,
> so this patch adds a singlethreaded workqueue for STPGs to be
> submitted synchronously.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
