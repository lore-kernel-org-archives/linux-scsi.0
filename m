From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/5] qla2xxx: Only allow operational MBX to proceed
 during RESET.
Date: Thu, 1 Dec 2016 08:56:07 +0100
Message-ID: <5a780b15-20d7-2294-baee-e59bbf93b885@suse.de>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
 <1480537497-16429-2-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750775AbcLAIOd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 03:14:33 -0500
In-Reply-To: <1480537497-16429-2-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2016 09:24 PM, Himanshu Madhani wrote:
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 52 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
