From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 11/24] libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
Date: Fri, 14 Oct 2016 14:25:56 -0700
Message-ID: <9ee92a82-1996-cfb3-25ee-7a3b4b2be1e5@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0042.outbound.protection.outlook.com ([104.47.37.42]:15014
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752516AbcJNV0G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:26:06 -0400
In-Reply-To: <1476364260-12191-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> Occasionally it might happen that we receive a PRLI while we're still
> waiting for our PLOGI response. In that case we should return
> 'busy' LS status instead of 'plogi required' LS status.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
