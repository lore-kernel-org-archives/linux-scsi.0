From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Wed,  8 Dec 2010 00:31:34 +0900
Message-ID: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

Annotate dptids as '__used' to fix following warning:

  CC      drivers/scsi/dpt_i2o.o
drivers/scsi/dpt_i2o.c:183: warning: =E2=80=98dptids=E2=80=99 defined b=
ut not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
---
 drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index cffcb10..b276077 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -180,7 +180,7 @@ static u8 adpt_read_blink_led(adpt_hba* host)
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
  */
=20
-static struct pci_device_id dptids[] =3D {
+static struct pci_device_id dptids[] __used =3D {
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID=
,},
 	{ 0, }
--=20
1.7.0.4
