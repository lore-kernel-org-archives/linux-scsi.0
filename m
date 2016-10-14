From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 24/24] fcoe: filter out frames from invalid vlans
Date: Fri, 14 Oct 2016 14:38:10 -0700
Message-ID: <d7a5551b-859d-2f14-9130-a759c89be5f0@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-25-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0081.outbound.protection.outlook.com ([104.47.41.81]:44704
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756694AbcJNVik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:38:40 -0400
In-Reply-To: <1476364260-12191-25-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 10/13/2016 06:11 AM, Hannes Reinecke wrote:
> Any multicase address is set on all interfaces, the base interface
> and any VLAN interfaces on top of this. So we might receive frames
> which are not destined for us.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
