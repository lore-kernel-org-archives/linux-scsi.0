From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 13/24] libfc: safeguard against invalid exchange index
Date: Fri, 14 Oct 2016 14:27:05 -0700
Message-ID: <c300e01e-7924-b3bd-321a-24c5064bc281@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0061.outbound.protection.outlook.com ([104.47.37.61]:33376
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754525AbcJNV1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:27:13 -0400
In-Reply-To: <1476364260-12191-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> The cached exchange index might be invalid, in which case
> we should drop down to allocate a new one.
> And we should not try to access an invalid exchange when
> responding to a BA_ABTS.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
