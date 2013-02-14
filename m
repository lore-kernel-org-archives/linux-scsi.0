From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 16:44:26 -0600
Message-ID: <511D68CA.6050203@tributary.com>
References: <1360767971-947-1-git-send-email-hare@suse.de>  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike> <511D26B4.6070302@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:54081 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030238Ab3BNWo2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 17:44:28 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/14/2013 4:04 PM, Elliott, Robert (Server Storage) wrote:
> Like James notes, LUNs should generally be treated as opaque values.

	Maybe another issue to consider is how they are being displayed in userland.
A device with two luns using one of the alternative lun addressing methods is
going to get some pretty strange looking lun numbers showing up in userspace
if they aren't decoded properly.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRHWjKAAoJEL5i86xrzcy7UuQH/RG5zp3/H5GoVDH+81M/dtHq
RiHjCXuaHpESI6JGem8m7IrhFIRdEEuFL8OoJawMKLsxu6FD9Iwu0A9v99BNqLcc
1Jb+u/AVAhr4W5xB5Oua17IFwIVjxHipYvGDhbzfE/Fvy2lRJy5UDN1GXQMkVtI2
FSYVk3GI51LF2GKbtWtMYb0fTx1jvhlE3WMgeUOyjtNCK7wVOKOPCD8PJkMKC07f
v50APFDLp2zCiVel1w3+QQLT96pcMFcfPalwMcfHjSHRxHyXgHlv5kZIk0pqiDxd
GNvCc4Kalvc5BzDYw0j3s4+tzRUjtPEniJYO/jDC9MF507XlANVZgAILwu5PJbk=
=35DZ
-----END PGP SIGNATURE-----
