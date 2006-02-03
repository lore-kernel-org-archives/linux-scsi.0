From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re: Overlapped command error handling
Date: Fri,  3 Feb 2006 12:13:05 +0100
Message-ID: <IU3Z5T$A708C9AF59D904CF9F1204FDB97620E4@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1138965185.2A.893476.42.6422.52.42.007.29317"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:46183 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932323AbWBCLNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2006 06:13:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: hare <hare@suse.de>, "James.Bottomley" <James.Bottomley@SteelEye.com>, "emmanuel.fuste" <emmanuel.fuste@laposte.net>


--_=__=_XaM3_.1138965185.2A.893476.42.6422.52.42.007.29317
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

> Hello,
> 
> Now compiling, results this evening.
> The patch for aic7xxx :
> 
New try as an attachment...

Emmanuel.
---=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.n=
et ; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/m=
n)=0A=0A

--_=__=_XaM3_.1138965185.2A.893476.42.6422.52.42.007.29317
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?tcq7xxx.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?tcq7xxx.patch?="

--- linux-source-2.6.15-orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-02-0=
3 10:56:04.000000000 +0100=0A+++ linux-source-2.6.15/drivers/scsi/aic7xxx=
/aic7xxx_osm.c	2006-02-03 11:00:41.000000000 +0100=0A@@ -1327,13 +1327,7 =
@@ ahc_platform_set_tags(struct ahc_softc *=0A 		scsi_activate_tcq(sdev, =
dev->openings + dev->active);=0A 		break;=0A 	default:=0A-		/*=0A-		 * We=
 allow the OS to queue 2 untagged transactions to=0A-		 * us at any time =
even though we can only execute them=0A-		 * serially on the controller/d=
evice.  This should=0A-		 * remove some latency.=0A-		 */=0A-		scsi_deact=
ivate_tcq(sdev, 2);=0A+		scsi_deactivate_tcq(sdev, 1);=0A 		break;=0A 	}=0A=
 }=0A

--_=__=_XaM3_.1138965185.2A.893476.42.6422.52.42.007.29317--

