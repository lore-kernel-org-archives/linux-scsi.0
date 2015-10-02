From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 16/36] scsi_dh_alua: call alua_rtpg() if stpg fails
Date: Fri, 2 Oct 2015 10:14:04 -0700
Message-ID: <560EBB5C.10602@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0087.outbound.protection.outlook.com ([157.56.110.87]:14830
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751803AbbJBROL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 13:14:11 -0400
In-Reply-To: <1443523658-87622-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> If the call to SET TARGET PORT GROUPS fails we have no idea what
> state the array is left in, so we need to issue a call to
> REPORT TARGET PORT GROUPS in these cases.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
