From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Fri, 15 Feb 2013 09:17:20 -0600
Message-ID: <511E5180.6000400@tributary.com>
References: <511A87CA.5010901@tributary.com> <511B8FBF.9000705@suse.de> <511BB545.7060600@tributary.com> <12DB2383-B7CE-4DD4-BBAA-D6701271A6E6@cs.wisc.edu> <511D4FB5.708@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950D58F40@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:34508 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3BOPR1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 10:17:27 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950D58F40@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Michael Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Linux Scsi <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/14/2013 5:42 PM, Elliott, Robert (Server Storage) wrote:
> Each logical unit is independent and is allowed to be different.

	I was actually just thinking about the target reset and IT reset flags. Two
flags which affect the I_T not the I_T_L.

	For the target reset its probably a small proportion of devices anyway, The
patch already disables target reset if the device is known to support lun reset.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRHlGAAAoJEL5i86xrzcy7Yz8IAKn3w6DnUkPxmasQXi0WljNB
eqBZHIZRx8gjpa6AOP0nBt+FDSmyrhE4vLOUFIiwpcql1jmJ6iwcT+Y4YHwi+GzC
sE/ZtB5UDad4RleXcZIBHJwVVFtW0oCya2jYxr2GQFIEz3EefrfwwXEqdeI85uTv
aLiKakEP6EDQur280T08R9UEpFHirUnhMKoCFsXjtB5T6u2XDRLLWXQ8hE5ILBnX
Mf5HmCF8g1EjOnCJOzcUlhRlDuQe17FcDHyaxPkl2f34Qr+gdPo9WW5Cz38V0RLX
UYqmZI/B1GX7rUaU+Xhc4aAkxq6547cWZUwRLdZ6M4osFZT6GBuw3iRBevzNXDs=
=/1pc
-----END PGP SIGNATURE-----
