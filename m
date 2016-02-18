From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 05/23] scsi_dh_alua: switch to scsi_execute_req_flags()
Date: Thu, 18 Feb 2016 11:31:29 -0800
Message-ID: <56C61C11.2020701@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:30528
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947073AbcBRTce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 14:32:34 -0500
In-Reply-To: <1455524690-121073-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> All commands are issued synchronously, so no need to open-code
> scsi_execute_req_flags() anymore. And we can get rid of the
> static sense code structure element. scsi_execute_req_flags()
> will be setting REQ_QUIET and REQ_PREEMPT, but that is
> perfectly fine as we're evaluating and logging any errors
> ourselves and we really need to send the command even if
> the device is quiesced.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
