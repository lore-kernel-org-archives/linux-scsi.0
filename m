From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 10/22] qla2xxx: Relogin to target port on a cable swap
Date: Thu, 30 Nov 2017 16:58:08 +0100
Message-ID: <f304d493-9be9-6153-ea79-eda499878415@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-11-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55071 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753067AbdK3P6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 10:58:10 -0500
In-Reply-To: <20171130034047.15070-11-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> If user swaps one target port for another target port for same
> switch port, the new target port is not being recognized by the
> driver. Current code assumes that old Target port has recovered
> from link down. The fix will ask switch what is the WWPN of a
> specific NportID (GPNID) rather than assuming it's the same Target
> port which has came back.
> 
> Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_gs.c     | 164 ++++++++++++++++++++++++++++++--------
>  drivers/scsi/qla2xxx/qla_init.c   |   6 +-
>  drivers/scsi/qla2xxx/qla_os.c     |  35 +++++++-
>  drivers/scsi/qla2xxx/qla_target.c |  35 ++++++--
>  4 files changed, 194 insertions(+), 46 deletions(-)
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
