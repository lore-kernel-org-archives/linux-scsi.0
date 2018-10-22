From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [GIT PULL] pcmcia odd fixes for v4.20-rc1
Date: Mon, 22 Oct 2018 16:39:15 +0200
Message-ID: <20181022143915.GA387@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

please pull the following changes since commit
17b57b1883c1285f3d0dc2266e8f79286a7bef38:

  Linux 4.19-rc6 (2018-09-30 07:15:35 -0700)

which are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/brodo/linux.git pcmcia-next

up to 95691e3eddc41da2d1cd3cca51fecdfb46bd85bc:

  pcmcia: Implement CLKRUN protocol disabling for Ricoh bridges (2018-10-01 12:17:03 +0200)

These are just a few odd fixes and improvements to the PCMCIA core
and to a few PCMCIA device drivers.

Thanks,
	Dominik

----------------------------------------------------------------
Colin Ian King (1):
      pcmcia: remove KERN_INFO level from debug message

Jia-Ju Bai (2):
      char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol
      pcmcia: pcmcia_resource: Replace mdelay() with msleep()

Maciej S. Szmigiero (1):
      pcmcia: Implement CLKRUN protocol disabling for Ricoh bridges

Vaishali Thakkar (1):
      pcmcia: Use module_pcmcia_driver for scsi drivers

Zhouyang Jia (1):
      pcmcia: add error handling for pcmcia_enable_device in qlogic_stub

 drivers/char/pcmcia/cm4000_cs.c    |  4 ++--
 drivers/char/pcmcia/cm4040_cs.c    |  2 +-
 drivers/pcmcia/pcmcia_resource.c   |  4 ++--
 drivers/pcmcia/ricoh.h             | 35 +++++++++++++++++++++++++++++++++++
 drivers/pcmcia/yenta_socket.c      |  3 ++-
 drivers/scsi/pcmcia/aha152x_stub.c | 14 +-------------
 drivers/scsi/pcmcia/nsp_cs.c       | 15 +--------------
 drivers/scsi/pcmcia/nsp_cs.h       |  4 ----
 drivers/scsi/pcmcia/qlogic_stub.c  | 19 ++++++-------------
 drivers/scsi/pcmcia/sym53c500_cs.c | 16 +---------------
 10 files changed, 51 insertions(+), 65 deletions(-)

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEmgXaWKgmjrvkPhLCmpdgiUyNow0FAlvN4RAACgkQmpdgiUyN
ow1t+RAApMvwnU7uwIFlYDrCiBXZECN5RsBgR0QQPkG7Qc812hE7/oxHWt2VZceJ
JMkrYv/flk9ntXrIvdbOxHuc/iOyEweMXP445J8QUOQXr79Fi6Ju3fMOkYxQ1cK8
e71lKB/m1v4Uf1qKsVoNZ9Kd6QHlcy6iBt3csyRjb8QE8+uGZA0AmKr9bqDT6zDB
0Wg3Pj3l+EQnn58c0zaHtgBwGNrC9wfcSid1WIqV4Wv3wHEjKLtNpin6JcUy1Pdy
Sz6APA828ErpN6lxJ3LP2jo5lJBAqRLP12s3ZHoliYPr/r6TqTP39jF9hOu8cNWW
OWawMEALCo21JFl0S0EZVw+VyNVaB0sFZpDmzTNHP3fWfPien/ovUoTdWVy2fl4R
z/HiMBDI4hpt5HV44kGj6oFHjdcHY0eyEhCpL54bjJWbuttBKhrALgnft2k9jtDs
Cq+eF422VAUwAp2CVFQBWVT39ERxsgFea1naRLdzp/pnirrCHnzTZZk5alMzRu/2
wHNPTGM5sN+07kretSLVDdlqJFIC/IchXppv3lib65SpqLvz64ot3sNuVOrChpY0
bp4VVfP+qAdO//Fnf6d7+FevFgS5xDbDNNjxmB/W+xoQIKYY/R6oM/hj0+s0KJ77
jVvtWpv2r/okshMSck3kil+ggkxnjmLdri67EKaOi6dPF1lvot0=
=Q7jH
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
