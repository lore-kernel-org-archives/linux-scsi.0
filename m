From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: ServeRAID Linux Driver ( ips )  7.00.15 Patch
Date: Mon, 29 Mar 2004 09:10:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0191D97D3@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C41597.8A1B4588"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:56770 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262191AbUC2OKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 09:10:11 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>, Hubert Mantel <mantel@suse.de>
Cc: Jens Axboe <axboe@suse.de>, "Marcelo Wormsbecker Tosatti (E-mail)" <marcelo@conectiva.com.br>, James.Bottomley@SteelEye.com, torvalds@transmeta.com, coughlan@redhat.com, dledford@redhat.com, bjohnson@redhat.com, bhlim@vmware.com, rofarrell@vmware.com, kerneldriver@suse.de, go@turbolinux.co.jp, rogerv@sco.com, schwab@suse.de, michael@turbolinux.com, vcat@caldera.com, sdenham@redhat.com, "Jeffery, David" <David_Jeffery@adaptec.com>, "Pasteur, Bob" <bob_pasteur@adaptec.com>, "Wendy Hung (E-mail)" <wendyh@us.ibm.com>, "Leah Cunningham (E-mail)" <leahc@us.ibm.com>, "Brad Thomas (E-mail)" <bwthomas@us.ibm.com>, "Felica Turner (E-mail)" <faturner@us.ibm.com>, "Marie Jazynka (E-mail)" <mjazynka@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>, "Williams, Bill" <Bill_Williams@adaptec.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C41597.8A1B4588
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Please apply the following patch to the ips driver source that I
released last week. If removes an offensive "#ifdef" that was
essentially a NOP anyway.

Jack



--- linux.orig/drivers/scsi/ips.c	2004-03-29 08:56:03.000000000
-0500
+++ linux/drivers/scsi/ips.c	2004-03-29 08:56:39.000000000 -0500
@@ -277,9 +277,6 @@
 	.use_clustering		=3D ENABLE_CLUSTERING,
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	.use_new_eh_code	=3D 1,
-#ifdef RHEL3
-    .vary_io            =3D 1,
-#endif
 #endif
 };
=20

------_=_NextPart_001_01C41597.8A1B4588
Content-Type: application/octet-stream;
	name="ips-7.00.15-patch"
Content-Transfer-Encoding: base64
Content-Description: ips-7.00.15-patch
Content-Disposition: attachment;
	filename="ips-7.00.15-patch"

LS0tIGxpbnV4Lm9yaWcvZHJpdmVycy9zY3NpL2lwcy5jCTIwMDQtMDMtMjkgMDg6NTY6MDMuMDAw
MDAwMDAwIC0wNTAwCisrKyBsaW51eC9kcml2ZXJzL3Njc2kvaXBzLmMJMjAwNC0wMy0yOSAwODo1
NjozOS4wMDAwMDAwMDAgLTA1MDAKQEAgLTI3Nyw5ICsyNzcsNiBAQAogCS51c2VfY2x1c3Rlcmlu
ZwkJPSBFTkFCTEVfQ0xVU1RFUklORywKICNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPCBLRVJORUxf
VkVSU0lPTigyLDUsMCkKIAkudXNlX25ld19laF9jb2RlCT0gMSwKLSNpZmRlZiBSSEVMMwotICAg
IC52YXJ5X2lvICAgICAgICAgICAgPSAxLAotI2VuZGlmCiAjZW5kaWYKIH07CiAK

------_=_NextPart_001_01C41597.8A1B4588--
