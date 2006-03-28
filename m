From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: [PATCH 3/5] AIC7xxx : Remove dead code
Date: Tue, 28 Mar 2006 17:48:53 +0200
Message-ID: <IWUH9H$C8ADC8B229C4E0558EA013F0381F72E5@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1143560933.2A.589775.42.28889.52.42.007.15970"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:4455 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932075AbWC1Pun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:50:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1143560933.2A.589775.42.28889.52.42.007.15970
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

[PATCH 3/5] AIC7xxx : Remove dead code

Signed-off-by: Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>
---
=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net =
; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)=0A=
=0A

--_=__=_XaM3_.1143560933.2A.589775.42.28889.52.42.007.15970
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?NEW-aic7xxx-deadcode.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?NEW-aic7xxx-deadcode.patch?="

diff -upN linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_core.c l=
inux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_core.c=0A--- linux-source=
-2.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_core.c	2006-03-28 10:40:31.000=
000000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_core.=
c	2006-03-28 10:41:42.000000000 +0200=0A@@ -5062,7 +5062,6 @@ ahc_pause_a=
nd_flushwork(struct ahc_softc=0A 		printf("Infinite interrupt loop, INTST=
AT =3D %x",=0A 		       ahc_inb(ahc, INTSTAT));=0A 	}=0A-	ahc_platform_fl=
ushwork(ahc);=0A 	ahc->flags &=3D ~AHC_ALL_INTERRUPTS;=0A }=0A =0Adiff -u=
pN linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_osm.c linux-sou=
rce-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c=0A--- linux-source-2.6.16-o=
rig2/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-03-28 10:40:31.000000000 +02=
00=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-03-2=
8 10:46:53.000000000 +0200=0A@@ -1616,12 +1616,6 @@ ahc_linux_isr(int irq=
, void *dev_id, str=0A }=0A =0A void=0A-ahc_platform_flushwork(struct ahc=
_softc *ahc)=0A-{=0A-=0A-}=0A-=0A-void=0A ahc_send_async(struct ahc_softc=
 *ahc, char channel,=0A 	       u_int target, u_int lun, ac_code code, vo=
id *arg)=0A {=0Adiff -upN linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/=
aic7xxx_osm.h linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.h=0A--=
- linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-03-28=
 10:40:31.000000000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/=
aic7xxx_osm.h	2006-03-28 10:47:35.000000000 +0200=0A@@ -831,7 +831,6 @@ i=
nt	ahc_platform_abort_scbs(struct ahc_s=0A 				role_t role, uint32_t stat=
us);=0A irqreturn_t=0A 	ahc_linux_isr(int irq, void *dev_id, struct pt_re=
gs * regs);=0A-void	ahc_platform_flushwork(struct ahc_softc *ahc);=0A voi=
d	ahc_done(struct ahc_softc*, struct scb*);=0A void	ahc_send_async(struct=
 ahc_softc *, char channel,=0A 		       u_int target, u_int lun, ac_code,=
 void *);=0ACommon subdirectories: linux-source-2.6.16-orig2/drivers/scsi=
/aic7xxx/aicasm and linux-source-2.6.16/drivers/scsi/aic7xxx/aicasm=0A

--_=__=_XaM3_.1143560933.2A.589775.42.28889.52.42.007.15970--

