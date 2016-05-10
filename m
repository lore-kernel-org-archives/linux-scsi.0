From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv2] scsi_lib: Decode T-10 vendor IDs
Date: Tue, 10 May 2016 13:08:44 -0700
Message-ID: <57323FCC.8050108@sandisk.com>
References: <1462778069-103558-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:56864
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410AbcEJUIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2016 16:08:49 -0400
In-Reply-To: <1462778069-103558-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 05/09/2016 12:14 AM, Hannes Reinecke wrote:
> Some arrays / HBAs will only present T-10 vendor IDs, so we
> should be decoding them, too.
>
> Suggested-by: Paul Mackerras <paulus@ozlabs.org>
> Tested-by: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
