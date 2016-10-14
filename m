From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 18/24] libfc: wait for E_D_TOV when out-of-order sequence
 is received
Date: Fri, 14 Oct 2016 14:34:16 -0700
Message-ID: <872d7258-c5c9-80e8-7661-d75db863dec5@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0046.outbound.protection.outlook.com ([104.47.37.46]:63651
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756967AbcJNVe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:34:26 -0400
In-Reply-To: <1476364260-12191-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> When detecting an out-of-order sequence we should be waiting for
> E_D_TOV before trying to abort the sequence.
> The response might still be stuck in the queue somewhere.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
