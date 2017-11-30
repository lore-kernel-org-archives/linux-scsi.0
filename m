From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 08/22] qla2xxx: Fix login state machine stuck at GPDB
Date: Thu, 30 Nov 2017 16:54:43 +0100
Message-ID: <2b84c723-6c71-c371-00b6-77c3b3e0b69a@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-9-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752293AbdK3Pyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 10:54:45 -0500
In-Reply-To: <20171130034047.15070-9-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> This patch returns discovery state machine back to
> Login Complete.
> 
> Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
