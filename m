From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/6] qla2xxx: Add FC-NVMe F/W initialization and
 transport registration
Date: Thu, 22 Jun 2017 08:32:02 +0200
Message-ID: <7b83922d-7f2b-0938-08ae-52943381ce85@suse.de>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-4-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751064AbdFVGcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 02:32:04 -0400
In-Reply-To: <20170621204846.21663-4-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: darren.trapp@cavium.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, giridhar.malavali@cavium.com

On 06/21/2017 10:48 PM, Madhani, Himanshu wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> This code provides the interfaces to register remote and local ports
> of FC4 type 0x28 with the FC-NVMe transport and transports the
> requests (FC-NVMe FC link services and FC-NVMe commands IUs) to the
> fabric. It also provides the support for allocating h/w queues and
> aborting FC-NVMe FC requests.
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/Makefile   |   2 +-
>  drivers/scsi/qla2xxx/qla_dbg.c  |   2 +-
>  drivers/scsi/qla2xxx/qla_def.h  |   6 +
>  drivers/scsi/qla2xxx/qla_gbl.h  |  11 +
>  drivers/scsi/qla2xxx/qla_init.c |   8 +
>  drivers/scsi/qla2xxx/qla_iocb.c |  36 ++
>  drivers/scsi/qla2xxx/qla_isr.c  |  19 +
>  drivers/scsi/qla2xxx/qla_mbx.c  |  21 ++
>  drivers/scsi/qla2xxx/qla_nvme.c | 756 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_nvme.h | 132 +++++++
>  drivers/scsi/qla2xxx/qla_os.c   |  40 ++-
>  11 files changed, 1024 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/scsi/qla2xxx/qla_nvme.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_nvme.h
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
