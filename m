From: <Mahesh.Rajashekhara@microchip.com>
Subject: RE: [PATCH] scsi: aacraid: clean up some indentation and formatting
 issues
Date: Mon, 4 Feb 2019 10:37:02 +0000
Message-ID: <BL0PR11MB289749AD4D35250355C72423FE6D0@BL0PR11MB2897.namprd11.prod.outlook.com>
References: <20190202104052.16552-1-colin.king@canonical.com>
 <7293537e-5619-4e08-846d-d5016001d891@email.android.com>
 <BYAPR11MB322448EB89EA76E8727A92B3E26C0@BYAPR11MB3224.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BYAPR11MB322448EB89EA76E8727A92B3E26C0@BYAPR11MB3224.namprd11.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

---------- Forwarded message ----------
From: Colin King <mailto:colin.king@canonical.com>
Date: Feb 2, 2019 2:41 AM
Subject: [PATCH] scsi: aacraid: clean up some indentation and formatting is=
sues
To: Adaptec OEM Raid Solutions <mailto:aacraid@microsemi.com>,"James E . J =
. Bottomley" <mailto:jejb@linux.ibm.com>,"Martin K . Petersen" <mailto:mart=
in.petersen@oracle.com>,linux-scsi@vger.kernel.org
Cc: mailto:kernel-janitors@vger.kernel.org,linux-kernel@vger.kernel.org
EXTERNAL EMAIL


From: Colin Ian King <mailto:colin.king@canonical.com>

There are several issues with badly indented statements. Fix these
and clean up the formatting.

Signed-off-by: Colin Ian King <mailto:colin.king@canonical.com>
---
=A0drivers/scsi/aacraid/commsup.c | 25 +++++++++++++------------
=A0drivers/scsi/aacraid/linit.c=A0=A0 |=A0 3 +--
=A0drivers/scsi/aacraid/src.c=A0=A0=A0=A0 |=A0 2 +-
=A03 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c
index d5a6aa9676c8..0bdc6b0f725f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1376,18 +1376,19 @@ static void aac_handle_aif(struct aac_dev * dev, st=
ruct fib * fibptr)

=A0=A0=A0=A0=A0=A0=A0 container =3D 0;
=A0retry_next:
-=A0=A0=A0=A0=A0=A0 if (device_config_needed =3D=3D NOTHING)
-=A0=A0=A0=A0=A0=A0 for (; container < dev->maximum_num_containers; ++conta=
iner) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((dev->fsa_dev[container].co=
nfig_waiting_on =3D=3D 0) &&
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (dev->f=
sa_dev[container].config_needed !=3D NOTHING) &&
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 time_be=
fore(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIME=
OUT)) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 device_=
config_needed =3D
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 dev->fsa_dev[container].config_needed;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev->fs=
a_dev[container].config_needed =3D NOTHING;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 channel=
 =3D CONTAINER_TO_CHANNEL(container);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 id =3D =
CONTAINER_TO_ID(container);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 lun =3D=
 CONTAINER_TO_LUN(container);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0 if (device_config_needed =3D=3D NOTHING) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (; container < dev->maximum=
_num_containers; ++container) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((de=
v->fsa_dev[container].config_waiting_on =3D=3D 0) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 (dev->fsa_dev[container].config_needed !=3D NOTHING) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + =
AIF_SNIFF_TIMEOUT)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 device_config_needed =3D
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev->fsa_dev[container].config_n=
eeded;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 dev->fsa_dev[container].config_needed =3D NOTHING;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 channel =3D CONTAINER_TO_CHANNEL(container);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 id =3D CONTAINER_TO_ID(container);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 lun =3D CONTAINER_TO_LUN(container);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 if (device_config_needed =3D=3D NOTHING)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7e56a11836c1..e977b459f823 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -852,8 +852,7 @@ static u8 aac_eh_tmf_hard_reset_fib(struct aac_hba_map_=
info *info,

=A0=A0=A0=A0=A0=A0=A0 address =3D (u64)fib->hw_error_pa;
=A0=A0=A0=A0=A0=A0=A0 rst->error_ptr_hi =3D cpu_to_le32((u32)(address >> 32=
));
-=A0=A0=A0=A0=A0=A0 rst->error_ptr_lo =3D cpu_to_le32
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ((u32)(address & 0xffffffff));
+=A0=A0=A0=A0=A0=A0 rst->error_ptr_lo =3D cpu_to_le32((u32)(address & 0xfff=
fffff));
=A0=A0=A0=A0=A0=A0=A0 rst->error_length =3D cpu_to_le32(FW_ERROR_BUFFER_SIZ=
E);
=A0=A0=A0=A0=A0=A0=A0 fib->hbacmd_size =3D sizeof(*rst);

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 8377aec0649d..97bb9e9d201c 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -1157,7 +1157,7 @@ static int aac_src_soft_reset(struct aac_dev *dev)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&dev->pdev->dev, "%s:=
 %s status =3D %d", __func__,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state=
_str[state], rc);

-return rc;
+=A0=A0=A0=A0=A0=A0 return rc;
=A0}
=A0/**
=A0 *=A0 aac_srcv_init=A0=A0=A0=A0=A0 -=A0=A0=A0=A0=A0=A0 initialize an SRC=
v card
--
2.20.1
