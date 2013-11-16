From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sat, 16 Nov 2013 09:52:02 -0500
Message-ID: <52878692.5060300@ubuntu.com>
References: <527AF287.7020700@ubuntu.com> <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com> <527BDA11.6060603@interlog.com> <52870134.6060707@start.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61248 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3KPOwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Nov 2013 09:52:06 -0500
In-Reply-To: <52870134.6060707@start.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@start.ca>, dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/16/2013 12:23 AM, Mark Lord wrote:
> Ditto for many SATA disks with "power up in standby" enabled.

Ditto for my previous response; the kernel ( in this case the libata
layer ) notices this and takes care of starting it.  The third patch I
posted suppresses this startup at resume time so that it will be done
on access instead.

I currently have two disks with PuiS enabled that no longer have to
spin up and down again every time I resume from suspend, but wake up
nicely when I mount them.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSh4aPAAoJEJrBOlT6nu75bV0IAImEyIJlIF6O69mqLS3A6z/r
xtUQlxg5gfE91PteNdtNYd9v54uwCw2uldSAGOEm4DR7LOErVu54J+6rVZKFRF0L
ocmE2VEKhzNTA21pt5rCPDsQ9BHJ7ljWXbGTUC7zFN4VCYTEkPVuO5Owedjd9sb8
+BUHCD9+au7CRf5SLU4qSoqT8DNUPREv70WL1Ze8LhQt9R+APBclyeXHBYc+Hgpd
Idzp/EFt+SPRGrJL+XyC6/F0Mz3kLRD/2Ij0kRSux1E5DNG1SQTq+FdqUIa2sTDf
volJRiUS3/rtNr/2c4F9awQNbsCZRceTIq71PA3dvgxM21sjpXpLUe2A65u9gNQ=
=jhXC
-----END PGP SIGNATURE-----
