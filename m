From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 09/22] qla2xxx: Fix NPIV host cleanup in target mode
Date: Thu, 30 Nov 2017 16:55:18 +0100
Message-ID: <5c5d50cf-628a-6f5d-f8b3-d6ff80b7a67b@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-10-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54743 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbdK3PzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 10:55:20 -0500
In-Reply-To: <20171130034047.15070-10-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Sawan Chandak <sawan.chandak@cavium.com>
> 
> Add check to make sure we are cleaning up global target host
> list only for NPIV hosts
> 
> Fixes: bdbe24de281e2 ("scsi: qla2xxx: Cleanup NPIV host in target mode during config teardown")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
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
