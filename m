From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 23/24] fcoe: correct sending FIP VLAN packets on VLAN 0
Date: Fri, 14 Oct 2016 14:37:46 -0700
Message-ID: <47c50419-496a-97fa-9818-35f10401a1ab@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-24-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0065.outbound.protection.outlook.com ([104.47.40.65]:59648
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753832AbcJNVik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:38:40 -0400
In-Reply-To: <1476364260-12191-24-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> The FIP VLAN frame consists of an ethernet header followed
> by the FIP VLAN frame, so we need to skip the ethernet header
> if we want to check the FIP opcode.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
