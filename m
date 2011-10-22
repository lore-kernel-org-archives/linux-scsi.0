From: Michael Robbert <mrobbert@mines.edu>
Subject: SCSI HA problems
Date: Fri, 21 Oct 2011 18:08:37 -0600
Message-ID: <3915A3F8-ECF9-469B-869F-EA4C8421476E@mines.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Apple-Mail=_02F7B8A8-DAC9-4168-80EA-7A34908AE866";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exch-cas2.Mines.EDU ([138.67.132.205]:32629 "EHLO
	exch-cas2.adit.mines.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1JVANt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2011 20:13:49 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--Apple-Mail=_02F7B8A8-DAC9-4168-80EA-7A34908AE866
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

I want some technical advice from the SCSI/SAS/SATA experts. We are =
trying to setup a low cost HA storage system with multiple servers that =
have SAS HBAs, SAS JBOD, and desktop SATA disks. When we first set it up =
everything appeared to work. I created RAID6 on one host and put it into =
a corosync/pacemaker config. I was then able to migrate the RAID from =
one host to another. A short while later a failover failed and I noticed =
that some of the drives became inaccessible on one of the hosts. The =
kernel was showing timeouts to the device.=20

Oct 21 17:55:34 haraid-12-1 kernel: sd 1:0:3:0: timing out command, =
waited 10s

So, my question is this, is this setup technically possible or are the 2 =
HBAs going to conflict with each other when talking over the same SAS =
bus to the SATA drives?

Thanks,
Mike


--Apple-Mail=_02F7B8A8-DAC9-4168-80EA-7A34908AE866
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJOogmMAAoJEFmgPOBxQDtBWXMIAJjtTajFAuPmZJUjJxMdGmoK
LOK2yh2R0MF+55Qx78MpGpV5Kt21h8YMkUOTYmjRYSPNSl/yhpuSRfzt0HrzfBId
YBpFzUEwxu4CRtYD5wK6Ghlak3SLzQ+q8tWgeLLsjo9CTRz3plHVfqWOQwtZE1c5
iLacMgsFAABW0R8Zi/03zKsDTSw+p924W7fbFC85s/QeepQ8CVUOhLYbUcx8wxpu
yXkfiwjVfxzy+zQ/XRZU0szG1pCHYkhrUuipqoFrpO5p5UBXjzidng2kLEFGj9qM
am35y9xAlVC1Sb9NMeq8WebReHTJP3St5yePaVu6QosBWNIRSkfy17vi3NFSiYI=
=9uw9
-----END PGP SIGNATURE-----

--Apple-Mail=_02F7B8A8-DAC9-4168-80EA-7A34908AE866--
