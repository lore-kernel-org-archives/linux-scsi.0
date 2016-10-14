From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 20/24] fcoe: set default TC priority
Date: Fri, 14 Oct 2016 14:35:17 -0700
Message-ID: <64aaac25-060b-b9d5-542c-01b2d22d4bf6@sandisk.com>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:36896
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755409AbcJNVuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 17:50:05 -0400
In-Reply-To: <1476364260-12191-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/13/2016 06:10 AM, Hannes Reinecke wrote:
> If DCB is not enabled or compiled in we still should be setting
> a sane default priority. So put FCoE frames in priority class
> 'interactive' and FIP frames in priority class 'besteffort'.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
