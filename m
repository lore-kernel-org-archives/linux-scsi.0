From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/6] qla2xxx: Add FC-NVMe command handling
Date: Thu, 22 Jun 2017 08:28:51 +0200
Message-ID: <a37ad92e-4a26-9221-973b-b62793a210ee@suse.de>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50397 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751064AbdFVG2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 02:28:53 -0400
In-Reply-To: <20170621204846.21663-3-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: darren.trapp@cavium.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, giridhar.malavali@cavium.com

On 06/21/2017 10:48 PM, Madhani, Himanshu wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> This patch adds logic to  handle the completion of
> FC-NVMe commands and creates a sub-command in the SRB
> command structure to manage NVMe commands.
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_def.h | 17 +++++++++
>  drivers/scsi/qla2xxx/qla_fw.h  | 22 ++++++++++--
>  drivers/scsi/qla2xxx/qla_isr.c | 79 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_os.c  | 18 ++++++++--
>  4 files changed, 131 insertions(+), 5 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
