From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 0/3] target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support
Date: Wed, 7 Jun 2017 05:02:51 +0000
Message-ID: <A01A1524-3760-4FFC-956F-2A82874B668D@cavium.com>
References: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Content-ID: <FADF105E35EAD6418F280297936E8D24@namprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Jun 3, 2017, at 3:10 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> w=
rote:
>=20
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Hi Himanshu + Quinn,
>=20
> Here is a small series to introduce proper percpu se_lun->lun_ref
> counting for TMR, and add common code in target_submit_tmr() to
> do tag lookup for unpacked_lun in order to drop the original
> driver specific lookup within __qlt_24xx_handle_abts().
>=20
> It's rather straight-forward, so review and test as a v4.13 item.
>=20
> Thanks!
>=20
> Nicholas Bellinger (3):
>  target: Add support for TMR percpu reference counting
>  target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support for ABORT_TASK
>  qla2xxx: Convert QLA_TGT_ABTS to TARGET_SCF_LOOKUP_LUN_FROM_TAG
>=20
> drivers/scsi/qla2xxx/qla_target.c      | 39 ++++++-----------------
> drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  4 ++-
> drivers/target/target_core_device.c    | 14 ++++++---
> drivers/target/target_core_transport.c | 56 ++++++++++++++++++++++++++++-=
-----
> include/target/target_core_base.h      |  3 +-
> 5 files changed, 71 insertions(+), 45 deletions(-)
>=20
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Series looks good.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
