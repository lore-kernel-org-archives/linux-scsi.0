From: "Richard F. Rebel" <rrebel@whenu.com>
Subject: kernel 2.6.3 mpt fusion 3.00.03:  WWN part of target assignment?
Date: Tue, 14 Dec 2004 15:40:23 -0500
Message-ID: <1103056823.18363.330.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NKpyG/82zW6BAMsh/CFc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garibaldi.swishmail.com ([209.10.110.70]:45584 "HELO
	garibaldi.swishmail.com") by vger.kernel.org with SMTP
	id S261662AbULNUrR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 15:47:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-NKpyG/82zW6BAMsh/CFc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hello,

I have a LSI logic quad port fibre channel board in two computers on a
small SAN.  The SAN consists of a dual controllered nStor raid, as well
as a dual controller SSD, each port of each device is connected to one
of two QLogic sanbox 5200's.

One of my devices, the 6GB SSD, reports the following WWN by port:

Port 0: 20:00:00:02:34:00:00:9a

Port 2: 20:02:00:02:34:00:00:9a

As you can see, the number are nearly identical except for the 2nd
number which according the the manufacturer equates to the devices
internal port number.

Port 0, is attached to our first switch, port 2, is connected to the
2nd.

The kernel, upon probing the bus, reports that the SSD's target ID is 0
on the first switch, and on the second, it reports target 2.  Why is the
device not being assigned the same target like my other SAN devices.

This is the only device we have that elicits this behavior and it's
bunging up my mappings when I have it connected.  When I disconnect the
device and reboot everything, all of the fiber channel interfaces report
the other SAN devices identically across all paths (desired and
expected).  When I re-connect the SSD to the fabric, in reverse (port 0
on switch 2, port 2 on switch 1) the target's are reversed, but the SSD
still shows up as target 2.

Please forgive my ignorance, but what is responsible for assigning the
target id?  The SSD vendor claims the switch or the host, and most
likely the host is responsible for this.  Is there something I can do to
control this?

Thanks!

--=20
Richard F. Rebel

cat /dev/null > `tty`

--=-NKpyG/82zW6BAMsh/CFc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBv0+3x1ZaISfnBu0RAgSqAJ0fxq85AacZNMVYEBKcNUDY8JslpACeJLtZ
Ozub/EfvzRBBb6AP5ZjFmTM=
=rccJ
-----END PGP SIGNATURE-----

--=-NKpyG/82zW6BAMsh/CFc--

