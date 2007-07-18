From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid 2.6.21+ partition table disappear
Date: Wed, 18 Jul 2007 08:10:00 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5F29@otce2k301.adaptec.com>
References: <469DE1B9.6030107@xit.com.hk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7C934.97254C29"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:44315 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbXGRMKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 08:10:14 -0400
Content-class: urn:content-classes:message
In-Reply-To: <469DE1B9.6030107@xit.com.hk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Ruehl <aacraidbug@xit.com.hk>, "Linux-scsi vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7C934.97254C29
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The problem description matches this patch (which showed up on
2007/04/13).

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Chris Ruehl
> Sent: Wednesday, July 18, 2007 5:48 AM
> To: Linux-scsi vger.kernel.org
> Subject: aacraid 2.6.21+ partition table disappear=20
>=20
>=20
> Hi all,
>=20
> I had been last 2 Day in China trying update a Linux (Debian Sarge)
> running a 2.6.14.3 to 2.6.21.6 or 2.6.22.1
>=20
> The boot stuck in a VFS Kernel Panic no root filesystem found.
>=20
> 1) aacraid compiled into kernel - failed
> 2) as module + initrd                  - failed
>=20
> the initrd show that the sda with 200GB was found - driver sd
> but no partition was found.
>=20
> Sorry I could not get a serial cable to cover the boot log - and it's=20
> impossible
> to get one if you can't speak Mandarin.
>=20
> Do you have any hint what I could do?
>=20
> Thank you
> Chris
>=20
> Controller is
> 0000:02:08.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
>         Subsystem: Adaptec 2120S (Crusader)
>=20
>=20
> kerneloutput   """  2.6.14.3  """
>=20
> Loading Adaptec I2O RAID: Version 2.4 Build 5go
> Detecting Adaptec I2O RAID controllers...
> Adaptec aacraid driver (1.1-4 Jan 28 2006 18:35:59)
> AAC0: kernel 4.2-0[8205]
> AAC0: monitor 4.2-0[8205]
> AAC0: bios 4.2-0[8205]
> AAC0: serial c49a76
> AAC0: Non-DASD support enabled.
> scsi0 : aacraid
>   Vendor: ADAPTEC   Model: XITArray1         Rev: V1.0
>   Type:   Direct-Access                      ANSI SCSI revision: 02
>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>   Type:   Direct-Access                      ANSI SCSI revision: 03
>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>   Type:   Direct-Access                      ANSI SCSI revision: 03
>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>   Type:   Direct-Access                      ANSI SCSI revision: 03
>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>   Type:   Direct-Access                      ANSI SCSI revision: 03
>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> 3ware 9000 Storage Controller device driver for Linux v2.26.02.004.
> SCSI device sda: 429920256 512-byte hdwr sectors (220119 MB)
> sda: Write Protect is off
> sda: Mode Sense: 03 00 00 00
> sda: got wrong page
> sda: assuming drive cache: write through
> SCSI device sda: 429920256 512-byte hdwr sectors (220119 MB)
> sda: Write Protect is off
> sda: Mode Sense: 03 00 00 00
> sda: got wrong page
> sda: assuming drive cache: write through
>  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
>=20
>=20
> --=20
> X-IT Management Ltd.
> Office A, 14/F, Wing Sing Commercial Bldg.
> 12 Wing Lok Street, Sheung Wan
> Hong Kong
>=20
> 3596 7575  PHONE
> 3585 5118  FAX
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

------_=_NextPart_001_01C7C934.97254C29
Content-Type: application/octet-stream;
	name="aacraid_logical_bugfix.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_logical_bugfix.patch
Content-Disposition: attachment;
	filename="aacraid_logical_bugfix.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDQtMTIgMTU6NTQ6MjUuMjQ0Mzk5MTAyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDQtMTIgMTU6NTc6MDMuODA2NDY4Mjk3IC0wNDAwCkBAIC01MDMsOCAr
NTAzLDcgQEAKIAlkcmVzcCA9IChzdHJ1Y3QgYWFjX21vdW50ICopIGZpYl9kYXRhKGZpYnB0cik7
CiAJZHJlc3AtPm1udFswXS5jYXBhY2l0eWhpZ2ggPSAwOwogCWlmICgobGUzMl90b19jcHUoZHJl
c3AtPnN0YXR1cykgIT0gU1RfT0spIHx8Ci0JICAgICgobGUzMl90b19jcHUoZHJlc3AtPm1udFsw
XS52b2wpICE9IENUX05PTkUpICYmCi0JICAgICAobGUzMl90b19jcHUoZHJlc3AtPm1udFswXS5z
dGF0ZSkgPT0gRlNDU19ISURERU4pKSkKKwkgICAgKGxlMzJfdG9fY3B1KGRyZXNwLT5tbnRbMF0u
dm9sKSAhPSBDVF9OT05FKSkKIAkJcmV0dXJuIF9hYWNfcHJvYmVfY29udGFpbmVyMihjb250ZXh0
LCBmaWJwdHIpOwogCXNjc2ljbWQgPSAoc3RydWN0IHNjc2lfY21uZCAqKSBjb250ZXh0OwogCXNj
c2ljbWQtPlNDcC5waGFzZSA9IEFBQ19PV05FUl9NSURMRVZFTDsK

------_=_NextPart_001_01C7C934.97254C29--
