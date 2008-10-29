From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: 2.6.28-rc2 - strange (redundant) sysfs paths for SCSI
Date: Wed, 29 Oct 2008 21:05:39 +0300
Message-ID: <200810292105.40220.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4526605.sHybU53WzQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754867AbYJ2SFz@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--nextPart4526605.sHybU53WzQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Running with PATA driver:

/sys/devices/pci0000:00/0000:00:04.0/host0/scsi_host/host0
/sys/devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0

well, in both cases at least one component is redundant? Also
the intermediate nodes (scsi_host and target0:0:0) do not seem
to contain any useful information at all?

I noticed this because kernel installer in Mandriva started to
complaint about host* and target* device nodes under /sys/bus/scsi/devices:

lrwxrwxrwx 1 root root 0 2008-10-29 19:58 0:0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 1:0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host1/target1:0:0/1:0:0:0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 host0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 host1 -> ../../../devices/pci0000:00/0000:00:04.0/host1/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 target0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/target0:0:0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 target1:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host1/target1:0:0/

It is really not quite clear what use they have.

TIA

-andrey

--nextPart4526605.sHybU53WzQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkIpfQACgkQR6LMutpd94xTNACguJK4lS/+Dtxab+UYXbrgTLYX
POgAnjFUVbw5ilSJ53+pi4ixgSD1stWH
=fuif
-----END PGP SIGNATURE-----

--nextPart4526605.sHybU53WzQ--
