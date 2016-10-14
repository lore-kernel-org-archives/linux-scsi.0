From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 19/24] libfc: Check xid when looking up REC exchanges
Date: Fri, 14 Oct 2016 14:34:48 -0700
Message-ID: <527bd0dc-3534-9c20-03eb-adf083fc8e09@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0085.outbound.protection.outlook.com ([104.47.42.85]:57825
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756969AbcJNVey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:34:54 -0400
In-Reply-To: <1476364260-12191-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> We currently can only lookup the local xid, so we need
> to reject REC with empty rxid.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
