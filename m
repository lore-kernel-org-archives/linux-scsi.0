From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] scsi:aic7xxx_old: fix: add missing enum ahc_chip entries
Date: Fri, 13 Sep 2013 14:27:29 -0300
Message-ID: <1379093249-5493-1-git-send-email-antonio.alecrim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Due to this missing enum entries some switch cases have
unreached conditions:
drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_register=E2=80=
=99:
drivers/scsi/aic7xxx_old.c:7901:5: warning: case value =E2=80=98257=E2=80=
=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch]

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 drivers/scsi/aic7xxx_old.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 33ec9c6..643e214 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -728,6 +728,8 @@ typedef enum {
   AHC_VL               =3D 0x0100,
   AHC_EISA             =3D 0x0200,
   AHC_PCI              =3D 0x0400,
+  AHC_AIC7770_EISA     =3D AHC_AIC7770|AHC_EISA,
+  AHC_AIC7770_VL       =3D AHC_AIC7770|AHC_VL,
 } ahc_chip;
=20
 typedef enum {
--=20
1.8.3.1
