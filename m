From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: LUN resizing
Date: Tue, 25 Nov 2003 10:34:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069708054.26088.127.camel@lt-sv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4YGGR2ne5wneYCSELaIY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ping.topalis.com ([195.243.109.4]:23823 "EHLO ping.topalis.com")
	by vger.kernel.org with ESMTP id S262176AbTKYJej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 04:34:39 -0500
Received: from ping.topalis.com (localhost.localdomain [127.0.0.1])
	by localhost.ping.topalis.com (Postfix) with ESMTP id 7E97DB2F2D
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 10:34:38 +0100 (CET)
Received: from to.com (fw-dmz.topalis.com [195.243.109.1])
	by ping.topalis.com (Postfix) with ESMTP id 5F7FA1224A5
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 10:34:38 +0100 (CET)
Received: from localhost (elwood.think [192.168.10.15])
	by to.com (Postfix) with ESMTP id A6229C063D
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 10:34:37 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-4YGGR2ne5wneYCSELaIY
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

a hypothetical question:

I have a Linux box connected to a Fibre SAN. Now I'd like to resize one
LUN and tell my Linux box what happened. In other words can I _live_
resize a SCSI disk?

        [ let's not talk about which filesystems are capable of live
        resizing :) ]
       =20
      * Is this possible at all, eg does the SCSI Standard include
        something to enable a device to tell the host about the changed
        geometry (SENSE DATA, ...) ?
      * Is it possible with Linux, eg does the block layer/scsi layer
        support it? any problems with the partition code?
      * If there are problems, are they solveable, any plans on working
        on them or is already someone working on this?

Two options come to my mind:
      * LVM, just define a new LUN, add it to the group, and resize
      * echo remove-single-device ... > /proc/scsi/scsi (would not be
        life)


regards
	Stefan
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-4YGGR2ne5wneYCSELaIY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/wnMWtWF28C4HGsQRAkj9AJ9gU5oEPw35ZCKOvC+Q5TG6lkh5zgCgq1mG
o1KBt18Z0vFJhHoalWilg6A=
=Tlp8
-----END PGP SIGNATURE-----

--=-4YGGR2ne5wneYCSELaIY--

