From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] scsi/lpfc/lpfc_init.c: remove unused variable
Date: Sat, 28 Apr 2007 21:20:34 +0200
Message-ID: <20070428192034.GW3468@stusta.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161029AbXD1TVx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Smart <James.Smart@emulex.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch removes a no longer used variable:

<--  snip  -->

=2E..
  CC      drivers/scsi/lpfc/lpfc_init.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc=
_init.c: In function =E2=80=98lpfc_pci_probe_one=E2=80=99:
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc=
_init.c:1419: warning: unused variable =E2=80=98retval=E2=80=99
=2E..

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc_init.c.old	2007-04-28 1=
5:20:42.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc_init.c	2007-04-28 15:20=
:57.000000000 +0200
@@ -1416,7 +1416,7 @@
 	struct lpfc_sli  *psli;
 	struct lpfc_iocbq *iocbq_entry =3D NULL, *iocbq_next =3D NULL;
 	unsigned long bar0map_len, bar2map_len;
-	int error =3D -ENODEV, retval;
+	int error =3D -ENODEV;
 	int i;
 	uint16_t iotag;
=20
