From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Patch for linux 2.5.32
Date: Tue, 10 Sep 2002 19:18:53 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020910092648.4A4AB2C2A2@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Josef <josef.moellers@fujitsu-siemens.com>

[ This patch had no attached comment: is it sane? --RR ]
=46rom:  Josef <josef.moellers@fujitsu-siemens.com>

  --=20
  Josef M=F6llers (Pinguinpfleger bei FSC)
  	If failure had no penalty success would not be a prize
  						-- T.  Pratchett--- linux-2.5.32/drivers/scsi/scsi_scan.c	Thu A=
ug 29 10:37:55 2002

--- trivial-2.5.34/drivers/scsi/scsi_scan.c.orig	2002-09-10 19:10:54.00=
0000000 +1000
+++ trivial-2.5.34/drivers/scsi/scsi_scan.c	2002-09-10 19:10:54.0000000=
00 +1000
@@ -162,8 +162,8 @@
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
-	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on L=
UN 0 */
-	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage o=
n LUN 0 */
+        {"DGC", "DISK", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST=
_FORCELUN },
+        {"DGC", "RAID ", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIS=
T_FORCELUN },
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
 	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
 	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F *=
/
@@ -183,6 +183,10 @@
 	{"COMPAQ", "MSA1000", NULL, BLIST_FORCELUN},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
+        {"EUROLOGC", "FC2502", NULL, BLIST_SPARSELUN | BLIST_LARGELUN =
| BLIST_FORCELUN },
+        {"FSC FC47", "DISK", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | =
BLIST_FORCELUN },
+        {"FSC FC47", "RAID ", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |=
 BLIST_FORCELUN },
+        {"MYLEX", "DACARMRB", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |=
 BLIST_FORCELUN },
 };
=20
 #define ALLOC_FAILURE_MSG	KERN_ERR "%s: Allocation failure during" \
--=20
  Don't blame me: the Monkey is driving
  File: Josef =3D?iso-8859-1?Q?M=3DF6llers?=3D <josef.moellers@fujitsu-=
siemens.com>: Patch for linux 2.5.32
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
