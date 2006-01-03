From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: Possible performance regression?
Date: Tue, 03 Jan 2006 11:35:48 +0100
Message-ID: <43BA5384.5070504@ilsb.tuwien.ac.at>
References: <43B94DB9.5040505@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1DA1BB44C85D80DB118548FC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:55688 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S1751332AbWACKgI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 05:36:08 -0500
In-Reply-To: <43B94DB9.5040505@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1DA1BB44C85D80DB118548FC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alan D. Brunelle wrote:
>
> 
> (0,1)         1      2      4      8     16     32     64    128    256
> RHEL4U2    23.8   46.8   87.8   89.6   89.5   89.6   89.5   89.5   89.5
> 2.6.14      3.9    7.8   15.6   31.2   62.5   89.6   89.5   89.5   89.6
> Differ    -83.6% -83.3% -82.2% -65.2% -30.2%   0.0%   0.0%   0.0%   0.0%
> 
> (0,1) means target 1 on bus 0, and then the columns represent different
> transfer sizes (1K up to 256K).  I also see some that show little if any
> difference:
> 
> (6,4)         1      2      4      8     16     32     64    128    256
> RHEL4U2    23.9   46.9   88.5   90.0   89.9   89.9   89.9   90.0   89.9
> 2.6.14.2   24.1   47.0   88.5   90.0   89.9   90.0   89.9   89.9   89.9
> Differ      0.8%   0.2%   0.0%   0.0%   0.0%   0.1%   0.0%  -0.1%   0.0%
> 

Did you apply [PATCH] mptfusion : dv performance fix by
Eric Dean Moore? (Dec. 1st, 2005) W/o that patch the first four disks of
an 1030 are performing 3.5 MB/s instead of 70 :-)
It was funny how slow a RAID 5-0 can be when four of fourteen disks
are slow...

                                          GS

-- 
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/

--------------enig1DA1BB44C85D80DB118548FC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDulOIE6e53f4wQG4RAowFAKDbbVKjLiLqHIYNXC1dt6x5n3jjcgCfUN5L
JI12iuih3fotdshJKg7QdKE=
=Nwhv
-----END PGP SIGNATURE-----

--------------enig1DA1BB44C85D80DB118548FC--
