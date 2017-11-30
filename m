From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 11/22] qla2xxx: Fix Relogin being triggered too fast
Date: Thu, 30 Nov 2017 17:00:27 +0100
Message-ID: <b3d61964-5353-09c6-942a-d13b29f645db@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-12-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55249 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752802AbdK3QAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:00:30 -0500
In-Reply-To: <20171130034047.15070-12-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Current driver design schedules relogin process via DPC thread
> every 1 second. In a large fabric, this DPC thread tries to
> schedule too many jobs and might get overloaded. As a result of
> this processing of DPC thread, it can schedule relogin earlier
> than 1 second.
> 
> Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  1 +
>  drivers/scsi/qla2xxx/qla_mid.c | 24 +++++++++++++++---------
>  drivers/scsi/qla2xxx/qla_os.c  | 22 ++++++++++++++--------
>  3 files changed, 30 insertions(+), 17 deletions(-)
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
