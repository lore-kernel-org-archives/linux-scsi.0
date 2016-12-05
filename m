From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 5/6] qla2xxx: Add Block Multi Queue functionality.
Date: Mon, 5 Dec 2016 08:39:19 +0100
Message-ID: <6a2b275e-fdf9-ab9f-8403-c05f52d8f5ac@suse.de>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-6-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751569AbcLEHjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Dec 2016 02:39:48 -0500
In-Reply-To: <1480715097-13611-6-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 12/02/2016 10:44 PM, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Tell the SCSI layer how many hardware queues we have based on the number
> of max queue pairs created. The number of max queue pairs created will
> depend on number of MSI-X vector count.
> 
> This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
> scsi_mod.use_blk_mq=Y as a parameter to the kernel
> 
> Queue pair creation depend on module parameter "ql2xmqsupport", which
> need to be enabled to create queue pair.
> 
> Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
> Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 37 ++++++++++++++++++++++++++++++++-----
>  1 file changed, 32 insertions(+), 5 deletions(-)
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
