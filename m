From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] [SCSI] fdomain: fix compiler warning on fdomain_pci_tbl
Date: Wed,  8 Dec 2010 00:31:35 +0900
Message-ID: <1291735896-14541-2-git-send-email-namhyung@gmail.com>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rik Faith <faith@cs.unc.edu>
List-Id: linux-scsi@vger.kernel.org

Annotate fdomain_pci_tbl as '__used' to fix following warning:

  CC      drivers/scsi/fdomain.o
drivers/scsi/fdomain.c:1775: warning: =E2=80=98fdomain_pci_tbl=E2=80=99=
 defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Rik Faith <faith@cs.unc.edu>
---
 drivers/scsi/fdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 69b7aa5..974c0d9 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1772,7 +1772,7 @@ struct scsi_host_template fdomain_driver_template=
 =3D {
 #ifndef PCMCIA
 #ifdef CONFIG_PCI
=20
-static struct pci_device_id fdomain_pci_tbl[] __devinitdata =3D {
+static struct pci_device_id fdomain_pci_tbl[] __devinitdata __used =3D=
 {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ }
--=20
1.7.0.4
