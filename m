From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: add missing includes for qla_isr
Date: Wed, 30 Aug 2017 17:15:20 +0000
Message-ID: <D69ED925-8F12-40BB-9D5B-2B2C81432FDB@cavium.com>
References: <20170830131231.7934-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:46080
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752046AbdH3RPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 13:15:23 -0400
In-Reply-To: <20170830131231.7934-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <5025FFD3E9CF49408A63FFB4F582CEF9@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>


> On Aug 30, 2017, at 6:12 AM, Johannes Thumshirn <jthumshirn@suse.de> wrot=
e:
>=20
> Since commit 7401bc18d1ee ("scsi: qla2xxx: Add FC-NVMe command handling")
> we make use of 'struct nvmefc_fcp_req' in qla24xx_nvme_iocb_entry() witho=
ut
> including linux/nvme-fc-driver.h where it is defined.
>=20
> Add linux/nvme-fc-driver.h (and scsi/fc/fc_fs.h as nvme-fc-driver.h needs
> the definition of 'struct fc_ba_rjt' from scsi/fc/fc_fs.h) to the header
> files included by qla_isr.c.
>=20
> Fixes: 7401bc18d1ee ("scsi: qla2xxx: Add FC-NVMe command handling")
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 7b3b702ef622..b57cbe4ec32b 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -14,6 +14,8 @@
> #include <scsi/scsi_tcq.h>
> #include <scsi/scsi_bsg_fc.h>
> #include <scsi/scsi_eh.h>
> +#include <scsi/fc/fc_fs.h>
> +#include <linux/nvme-fc-driver.h>
>=20
> static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
> static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, voi=
d *);
> --=20
> 2.12.3
>=20
Good catch.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
