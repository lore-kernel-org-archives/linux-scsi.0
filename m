From: Alice Ferrazzi <alicef@gentoo.org>
Subject: Linux kernel 4.9.25: signed integer overflow in
 drivers/scsi/scsicam.c:173:29
Date: Thu, 1 Jun 2017 10:44:35 +0900
Message-ID: <20170601014435.GA9708@alitoo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33619 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdFABou (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 21:44:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, segmentation-fault@outlook.com, security@gentoo.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello scsi maintainer,

I would like to report a signed integer overflow in drivers/scsi/scsicam.c:=
173:29=20
reported on the Gentoo bug reporting system.=20
https://bugs.gentoo.org/show_bug.cgi?id=3D617820

The problem looks present ,at least , in the Linux kernel 4.9.25
regards,

Alice Ferrazzi
Gentoo kernel project leader

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEELk4IVkYcBYUTNvSWViGmsoY4eBoFAlkvcWoACgkQViGmsoY4
eBo83A/9GTaMcehY4FBwhze25xdviVC9vOPUSVDLZagKBsC+DD6JKL1Ujw+csMnf
69gp5k4aao9s5EJ02bIbbj1RbfCgO7w9poUBFy4SyAdFHzLj8WY3MNPMQ4v/fJFb
AYHjfK20ejRC/Z4voVdbvMXnyfuYxsDZMpBysJ4Nk6JuJzTIrCDbs+mHG9uomShj
ZqKLgFp484dg7KErowOOOtt0VGSxEGCqMVgvdbKWOiCnlZ77gLW3fKHhyT4/yR3E
kU4kOTTNc5d5Ghx63tvh8f6ohs5qAFXz/6Ku2iSl4j9LYi9oxBNTo7hSTGppXbcD
NXJIu/MsxO+twAtDoQlTYQeoi7DGGS5nEGQLd2I2iKVefyZTLLteXvTu//el5Vgb
TFivs0LYeiVI3OczzlaJZa7QDoFB3aRIWfHD2nSYrMXdQYHMMvmsBGp67BeismJd
rN0Pa8M9O64FwHB8nIIiq1vuOKIiEbfJHGs75RtnXLUKvudSO5owPdj/KwWfZrk5
/WyJ83Meszd3my8h+R/FjYiBcEbgATr21DUZcRyUi9L8vJLB5Fw/wbniD7Aq4oLj
akr3DmH0cN4TGoJF12AOu2ydsjEXHmi26HNFboFj1BTiI3779e1SUTiW6zXWhPwj
XEz49XDeVl78SU7FdvkTatrlSQYeBsaV5FR2iVrZMA2O9qXEV+I=
=egDG
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
