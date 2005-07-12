From: Tom Duffy <tduffy@sun.com>
Subject: RE: [PATCH 22/82] remove linux/version.h from
	drivers/message/fus		ion
Date: Tue, 12 Jul 2005 13:56:33 -0700
Message-ID: <1121201793.14638.10.camel@duffman>
References: <91888D455306F94EBD4D168954A9457C03157047@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kHYV7kTTU/6ZjhVLm4Gi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nwkea-mail-1.sun.com ([192.18.42.13]:19888 "EHLO
	nwkea-mail-1.sun.com") by vger.kernel.org with ESMTP
	id S262419AbVGLU5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 16:57:50 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C03157047@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Olaf Hering <olh@suse.de>


--=-kHYV7kTTU/6ZjhVLm4Gi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2005-07-12 at 14:50 -0600, Moore, Eric Dean wrote:
> The 3.02.18 driver and the driver in kernel tree are totally different
> drivers.
> One thing is 3.02.18 has SAS support, and the kernel tree doesn't.    Id
> wish
> kernel folks would take our SAS drivers.

Is there a patch that applies cleanly to 2.6.13-rc2?  I would like that
as a starting point, at least.

I noticed that the 3.02.18 drivers have a bunch of compile warnings on
the latest kernel.  It won't even link against mm.

make -C /build1/tduffy/openib-work/build/mm/x86_64/ M=3D/build1/tduffy/open=
ib-work/mptlinux-3.02.18/fusion modules
make[1]: Entering directory `/build1/tduffy/openib-work/build/mm/x86_64'
make -C /build1/tduffy/openib-work/linux-2.6.13-rc-mm O=3D/build1/tduffy/op=
enib-work/build/mm/x86_64 modules
  CC [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptbase.o
  CC [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.o
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.c: In function =
=E2=80=98mptscsih_probe=E2=80=99:
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.c:1195: warning=
: implicit declaration of function =E2=80=98scsi_set_device=E2=80=99
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.c: At top level=
:
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.c:3815: warning=
: initialization from incompatible pointer type
  CC [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptlan.o
  CC [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.o
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.c: In function =
=E2=80=98mptctl_init=E2=80=99:
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.c:3735: warning: =
implicit declaration of function =E2=80=98register_ioctl32_conversion=E2=80=
=99
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.c:3856: warning: =
implicit declaration of function =E2=80=98unregister_ioctl32_conversion=E2=
=80=99
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.c: In function =
=E2=80=98mptctl_do_mpt_command=E2=80=99:
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.c:2007: warning: =
=E2=80=98bufIn.len=E2=80=99 may be used uninitialized in this function
/build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.c:2008: warning: =
=E2=80=98bufOut.len=E2=80=99 may be used uninitialized in this function
  Building modules, stage 2.
  MODPOST
*** Warning: "scsi_set_device" [/build1/tduffy/openib-work/mptlinux-3.02.18=
/fusion/mptscsih.ko] undefined!
*** Warning: "unregister_ioctl32_conversion" [/build1/tduffy/openib-work/mp=
tlinux-3.02.18/fusion/mptctl.ko] undefined!
*** Warning: "register_ioctl32_conversion" [/build1/tduffy/openib-work/mptl=
inux-3.02.18/fusion/mptctl.ko] undefined!
  CC      /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptbase.mod.o
  LD [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptbase.ko
  CC      /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.mod.o
  LD [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptctl.ko
  CC      /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptlan.mod.o
  LD [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptlan.ko
  CC      /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.mod.o
  LD [M]  /build1/tduffy/openib-work/mptlinux-3.02.18/fusion/mptscsih.ko
make[1]: Leaving directory `/build1/tduffy/openib-work/build/mm/x86_64'


--=-kHYV7kTTU/6ZjhVLm4Gi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC1C6BdY502zjzwbwRAkZXAJoCrAuWYnSJgx6SPq/rHJeZM/+7NQCfVrmz
gTonHQqmRP5nQG4H3rlyCtw=
=2/hx
-----END PGP SIGNATURE-----

--=-kHYV7kTTU/6ZjhVLm4Gi--
