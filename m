From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: linux-2.6.19-rc2-gc7a3bd17 build #90 failed
Date: Mon, 23 Oct 2006 16:20:13 +0200
Message-ID: <200610231620.15778.toralf.foerster@gmx.de>
References: <200610231526.48474.toralf.foerster@gmx.de> <20061023134657.GG25210@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10021419.ql56Fryi0x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:25763 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964876AbWJWOUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 10:20:18 -0400
In-Reply-To: <20061023134657.GG25210@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

--nextPart10021419.ql56Fryi0x
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Monday 23 October 2006 15:46 schrieben Sie:
> On Mon, Oct 23, 2006 at 03:26:46PM +0200, Toralf F=F6rster wrote:
> > the build with the attached .config failed, make ends with:
>=20
> What tree are you building?  In Linus' tree, advansys_pci_tbl is
> declared as:
>=20
> static struct pci_device_id advansys_pci_tbl[] __devinitdata =3D {
>=20
> Seems like your tree has it defined as:
>=20
> static struct pci_device_id advansys_pci_tbl[5] __devinitdata =3D {

I used the same config for the tree:

tfoerste@n22 ~/devel/linux-2.6 $ cg-status
Heads:
    >master     5cfc35cf79d46af998346e3d5cc66fa344d1af0e
     origin     5cfc35cf79d46af998346e3d5cc66fa344d1af0e

having this:

tfoerste@n22 ~/devel/linux-2.6 $ grep advansys_pci_tbl  drivers/scsi/advans=
ys.c
static struct pci_device_id advansys_pci_tbl[] __devinitdata =3D {
MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);


and got the same error:
=2E..
  CC      drivers/scsi/libiscsi.o
  CC      drivers/scsi/iscsi_tcp.o
  CC      drivers/scsi/advansys.o
drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not p=
roperly converted to the DMA API
drivers/scsi/advansys.c: In function `advansys_detect':
drivers/scsi/advansys.c:4406: warning: `check_region' is deprecated (declar=
ed at include/linux/ioport.h:133)
drivers/scsi/advansys.c: In function `AscSearchIOPortAddr11':
=2E..
drivers/scsi/advansys.c:18231: warning: excess elements in struct initializ=
er
drivers/scsi/advansys.c:18231: warning: (near initialization for `advansys_=
pci_tbl[5]')
drivers/scsi/advansys.c:18231: warning: excess elements in struct initializ=
er
drivers/scsi/advansys.c:18231: warning: (near initialization for `advansys_=
pci_tbl[5]')
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

=2D-=20
MfG/Sincerely
Toralf F=F6rster

--nextPart10021419.ql56Fryi0x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFPM+fhyrlCH22naMRArZEAJ9D9jNmRfna+2Miz9U2QRSr9I5xLACgiRIm
VarqeB7pZ8ap39o0GJ1jiP8=
=/lZp
-----END PGP SIGNATURE-----

--nextPart10021419.ql56Fryi0x--
