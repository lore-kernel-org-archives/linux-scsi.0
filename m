From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/6] qla2xxx: Add FC-NVMe port discovery and PRLI
 handling
Date: Thu, 22 Jun 2017 08:28:08 +0200
Message-ID: <346a274f-ca3a-90d3-a29e-5b244f983ba9@suse.de>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50375 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751064AbdFVG2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 02:28:10 -0400
In-Reply-To: <20170621204846.21663-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: darren.trapp@cavium.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, giridhar.malavali@cavium.com

On 06/21/2017 10:48 PM, Madhani, Himanshu wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> Added logic to change the login process into an optional PRIL
> step for FC-NVMe ports as a separate operation, such that we can
> change type to 0x28 (NVMe).
> 
> Currently, the driver performs the PLOGI/PRLI together as one
> operation, but if the discovered port is an NVMe port then we
> first issue the PLOGI and then we issue the PRLI. Also, the
> fabric discovery logic was changed to mark each discovered FC
> NVMe port, so that we can register them with the FC-NVMe transport
> later.
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c    |   9 +-
>  drivers/scsi/qla2xxx/qla_def.h    |  30 ++++++-
>  drivers/scsi/qla2xxx/qla_fw.h     |  13 ++-
>  drivers/scsi/qla2xxx/qla_gbl.h    |   1 +
>  drivers/scsi/qla2xxx/qla_init.c   | 168 ++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/qla2xxx/qla_iocb.c   |  21 +++++
>  drivers/scsi/qla2xxx/qla_mbx.c    |  33 +++++---
>  drivers/scsi/qla2xxx/qla_os.c     |   4 +
>  drivers/scsi/qla2xxx/qla_target.c |   4 +-
>  9 files changed, 256 insertions(+), 27 deletions(-)
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
