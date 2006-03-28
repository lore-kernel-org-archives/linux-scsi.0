From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: [PATCH 2/5] AIC7xxx :  set queuedepth to '1'
Date: Tue, 28 Mar 2006 17:45:34 +0200
Message-ID: <IWUH3Y$BE7DC6E24688544F53832DD2055BCAB3@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1143560734.2A.123511.42.10283.52.42.007.9627"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:18992 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1750741AbWC1Pq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:46:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1143560734.2A.123511.42.10283.52.42.007.9627
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

[PATCH 2/5] AIC7xxx :  set queuedepth to '1'

This patch set the queuedepth to '1' if tcq is disabled.
the aic79xx driver gets confused otherwise so do the same
to aic7xxx to be safe. To be revisited later.

Signed-off-by: Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>
---

=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net =
; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)=0A=
=0A

--_=__=_XaM3_.1143560734.2A.123511.42.10283.52.42.007.9627
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?NEW-aic7xxx-tcq.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?NEW-aic7xxx-tcq.patch?="

diff -upN linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_osm.c li=
nux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c=0A--- linux-source-2=
.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-03-28 10:11:26.000000=
000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c	20=
06-03-28 10:12:53.000000000 +0200=0A@@ -1330,7 +1330,7 @@ ahc_platform_se=
t_tags(struct ahc_softc *=0A 		 * serially on the controller/device.  Thi=
s should=0A 		 * remove some latency.=0A 		 */=0A-		scsi_deactivate_tcq(s=
dev, 2);=0A+		scsi_deactivate_tcq(sdev, 1);=0A 		break;=0A 	}=0A }=0AComm=
on subdirectories: linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/aicasm =
and linux-source-2.6.16/drivers/scsi/aic7xxx/aicasm=0A

--_=__=_XaM3_.1143560734.2A.123511.42.10283.52.42.007.9627--

