From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/6] qla2xxx: Send FC4 type NVMe to the management
 server
Date: Thu, 22 Jun 2017 08:33:01 +0200
Message-ID: <3599219e-0062-0ee1-5513-5eaf49efd583@suse.de>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50615 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751064AbdFVGdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 02:33:03 -0400
In-Reply-To: <20170621204846.21663-5-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: darren.trapp@cavium.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, giridhar.malavali@cavium.com

On 06/21/2017 10:48 PM, Madhani, Himanshu wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> This patch adds switch command support for FC-4 type of FC-NVMe (0x28)
> for resgistering HBA port to the management server. RFT_ID command is
> used to register FC-4 type of 0x28 and RFF_ID is used to register
> FC-4 features bits for FC-NVMe port.
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Reviewed-By: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  |   1 +
>  drivers/scsi/qla2xxx/qla_gbl.h  |   6 +-
>  drivers/scsi/qla2xxx/qla_gs.c   | 118 +++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/qla2xxx/qla_init.c |  11 +++-
>  4 files changed, 131 insertions(+), 5 deletions(-)
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
