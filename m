From: Phil Dibowitz <phil@ipom.com>
Subject: Re: 2.6.0-test8: scsi_sysfs.c still not detaching properly
Date: Sun, 19 Oct 2003 17:49:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F933127.1030204@ipom.com>
References: <3F92E2F0.2090003@ipom.com>
 <20031019171535.A16583@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=------------enig4D702B8ABC4DA3BDCB06A65E;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postal.usc.edu ([128.125.253.6]:34204 "EHLO postal.usc.edu")
	by vger.kernel.org with ESMTP id S262372AbTJTAtt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2003 20:49:49 -0400
Received: from ipom.com (dsl81-phil3.usc.edu [128.125.81.146])
 by postal.usc.edu
 (iPlanet Messaging Server 5.2 HotFix 1.21 (built Sep  8 2003))
 with ESMTPS id <0HN100HJ96AZU3@postal.usc.edu> for linux-scsi@vger.kernel.org;
 Sun, 19 Oct 2003 17:49:48 -0700 (PDT)
In-reply-to: <20031019171535.A16583@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4D702B8ABC4DA3BDCB06A65E
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick Mansfield wrote:
> Can you delete it prior to physical removal via the sysfs attribute (echo
> foo > /sysfs/bus/scsi/devices/1:0:0:0/delete)? If that doesn't work, you
> might be running an older kernel.
> 
> Is the device umounted (not open) when you disconnect it? If not, try
> Mike's recent patch (or try his patch anyway). But I would expect to see
> an oops or other odd behaviour in that case.

Well, this is embarassing, but it appears I didn't properly test this 
after my -test8 upgrade, because it actually works quite well.

Sorry about that.
-- 
Phil Dibowitz                             phil@ipom.com
Freeware and Technical Pages              Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"They that can give up essential liberty to obtain a little temporary
safety deserve neither liberty nor safety."
  - Benjamin Franklin, 1759


--------------enig4D702B8ABC4DA3BDCB06A65E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQE/kzEnN5XoxaHnMrsRAqNsAJ4r2kWpdXNx43dWCKvBXawBRSY8vACfawIF
wfzlUvtGG0YHVcEPsuRVS3o=
=ux5w
-----END PGP SIGNATURE-----

--------------enig4D702B8ABC4DA3BDCB06A65E--

