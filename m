From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 13:56:06 +0100
Message-ID: <43D623E6.7090507@ilsb.tuwien.ac.at>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig101E172435E571A56BD21C46"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:52452 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S1030466AbWAXM4P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 07:56:15 -0500
Received: from [128.130.71.3] (ilfb02.ilsb.tuwien.ac.at [128.130.71.3])
	by gh-gw1.ilsb.tuwien.ac.at (8.13.3/8.13.3/Debian-6) with ESMTP id k0OCuC73032400
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 13:56:12 +0100
In-Reply-To: <43D604AD.6050607@ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig101E172435E571A56BD21C46
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gerhard Schneider wrote:
> It's getting me mad..
> 

> 
> Another machine w/
> LSI1030 SCSI controller
> Megaraid ZCR controller
> Overland tape library
> HP LTO-3 tape drive
> Kernel 2.6.14rc1:
> 
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 45.953133 seconds (1108052 bytes/sec)
> 

After installing an old 53c875 controller on the machine w/ 2.6.14rc1:

dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
776+1 records in
776+1 records out
50918460 bytes transferred in 27.565659 seconds (1847170 bytes/sec)

Perhaps a 53c810 would be the fastest? What am I doing wrong?

                                   Gerhard Schneider

-- 
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/

--------------enig101E172435E571A56BD21C46
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD1iPqE6e53f4wQG4RAvitAJ4n0DT7yxLhm6QkrhN0cS+a40PUTwCguLsD
sGgDqYocJhqoyTK24H3HG50=
=0aJp
-----END PGP SIGNATURE-----

--------------enig101E172435E571A56BD21C46--
