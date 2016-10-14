From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 14/24] libfc: quarantine timed out xids
Date: Fri, 14 Oct 2016 14:33:07 -0700
Message-ID: <0d867cb8-707c-d56d-2695-eaae11a85c9f@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0073.outbound.protection.outlook.com ([104.47.41.73]:32404
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933172AbcJNVdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:33:11 -0400
In-Reply-To: <1476364260-12191-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> When a sequence times out we have no idea what happened to the
> frame. And we do not know if we will ever receive the frame.
> Hence we cannot re-use the xid as we would risk data corruption
> if the xid had been re-used and the timed out frame would be
> received after that.
> So we need to quarantine the xid until the lport is reset.
> Yes, I know this will (eventually) deplete the xid pool.
> But for now it's the safest method.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
