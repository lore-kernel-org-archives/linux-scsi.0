From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] [SCSI] initio: fix compiler warning on i91u_pci_devices
Date: Wed,  8 Dec 2010 00:31:36 +0900
Message-ID: <1291735896-14541-3-git-send-email-namhyung@gmail.com>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Annotate i91u_pci_devices as '__used' to fix following warning:

  CC      drivers/scsi/initio.o
drivers/scsi/initio.c:131: warning: =E2=80=98i91u_pci_devices=E2=80=99 =
defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/initio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9627d06..01c54cf 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -128,7 +128,7 @@ static int setup_debug =3D 0;
 static void i91uSCBPost(u8 * pHcb, u8 * pScb);
=20
 /* PCI Devices supported by this driver */
-static struct pci_device_id i91u_pci_devices[] =3D {
+static struct pci_device_id i91u_pci_devices[] __used =3D {
 	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, =
0},
 	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, =
0},
 	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, =
0},
--=20
1.7.0.4
