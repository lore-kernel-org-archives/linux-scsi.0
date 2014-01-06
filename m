From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: arcmsr - device going offline under 3.10.x (regression?)
Date: Mon, 6 Jan 2014 12:21:57 +0100
Message-ID: <20140106112157.GX16278@pcnci.linuxbox.cz>
References: <20140106063600.GU16278@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FhxWStFQ84VXWhXs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:33627 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaAFLWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jan 2014 06:22:01 -0500
Content-Disposition: inline
In-Reply-To: <20140106063600.GU16278@pcnci.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nick.cheng@areca.com.tw, Nikola Ciprich <nikola.ciprich@linuxbox.cz>


--FhxWStFQ84VXWhXs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

CC Nick Cheng

one more (a bit) related question, Nick, I can see Your last commit
in git on Jan 6 2011, since then mostly only miscelanous changes to keep
arcmsr in sync with rest of kernel.
But on areca webpages, I can see linux driver 1.30.0X.16-131015,
ie only few months old. There is neither changelog, nor older releases
to be found, only mention of ARC-12x4 cards supported.

Is there really no development in this driver, no bugfixes, anything?

We've got quite a lot of areca boards in production, and it's making
me a bit nervous...

If You could also look at this issue, I'd be grateful and happy to provide
whatever debug info could help to track this down..

BR

nik


On Mon, Jan 06, 2014 at 07:36:00AM +0100, Nikola Ciprich wrote:
> Hi,
>=20
> we're experiencing strange trouble with new box using areca based
> RAID and 3.10.x kernel.
>=20
> When I load disk subsystem (ie with fio benchmark), system seems to be
> working fine, but after some time (usually next day), device seems to die:
>=20
>=20
> <3>[43567.763088] EXT4-fs (dm-4): previous I/O error to superblock detect=
ed
> <3>[43567.763091] sd 0:0:1:0: rejecting I/O to offline device
> <2>[43567.763093] EXT4-fs error (device dm-4): __ext4_get_inode_loc:4039:=
 inode #135868: block 524619: comm syslog-ng: unable to read itable block
> <2>[43567.763094] EXT4-fs error (device dm-4) in ext4_reserve_inode_write=
:4962: IO failure
> <3>[43567.763095] EXT4-fs (dm-4): previous I/O error to superblock detect=
ed
> <3>[43567.763097] sd 0:0:1:0: rejecting I/O to offline device
> <4>[43567.763099] EXT4-fs warning (device dm-4): ext4_evict_inode:258: co=
uldn't mark inode dirty (err -5)
> <3>[43567.763143] sd 0:0:1:0: rejecting I/O to offline device
> <3>[43567.763150] sd 0:0:1:0: rejecting I/O to offline device
>=20
>=20
> Hardware is Supermicro X9DRW/X9DRW with 6 core E5-2620, 64GB RAM, running=
 centos6 + vanilla
> 3.10.x kernel. I tried with two different adapters (1223 and 1882). Since=
 box uses redundant
> powersupplies, I don't think it could be power issue as I found in some a=
reca FAQ. I'm using
> westerdn digital raid edition SATA drives.
>=20
> we've experienced this problem with 3.10.22 and 3.10.25. I wasn't able to=
 reproduce this
> with 3.0.101 (yet, I'm torturing the box for ~2 days now, so I can't be s=
ure).
>=20
> Since the problem takes quite long to reproduce (and I'm not sure after h=
ow long I can tell
> the system works fine), I'd like to ask about your opinions before trying=
 to bisect this..
>=20
> any ideas?
>=20
> thanks a lot in advance!
>=20
> BR
>=20
> nik
> --=20
> -------------------------------------
> Ing. Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28.rijna 168, 709 00 Ostrava
>=20
> tel.:   +420 591 166 214
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
> www.linuxbox.cz
>=20
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------



--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--FhxWStFQ84VXWhXs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlLKkdUACgkQ3xdJJrLygV7vHACfeyJy6SKsoNR+jF2SNXeX6Lwa
tegAniqEgGy3ecZzO2GoJ2opH1fm22RX
=bn4s
-----END PGP SIGNATURE-----

--FhxWStFQ84VXWhXs--
