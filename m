From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/3] be2iscsi: Fixing the /proc/interrupts problem V3
Date: Mon, 22 Aug 2011 19:24:53 +0200
Message-ID: <1396323.bvOCfZ5kpa@donald.sf-tec.de>
References: <f9809cab-6759-4b13-b095-d2d799fd7ca1@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2355958.mvt5XXGCp5"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:46481 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab1HVRZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 13:25:23 -0400
In-Reply-To: <f9809cab-6759-4b13-b095-d2d799fd7ca1@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu


--nextPart2355958.mvt5XXGCp5
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Jayamohan Kallickal wrote:
> Problem description, debugging and original patch from Prarit Bhargava:
> 
> Fix be2iscsi driver to use a separate pointer for each irq action->name
> field and avoid display corruption in /proc/interrupts. The be2iscsi driver
> was using a single static array in a function for the irq action->name
> field. This results in /proc/interrupts output like:
> 
> 156:  0          0          0          0          0          0
> 0
> 0          0          0          0          0          0          0
> 0
>         0          0          0          0          0          0
> 0
>      0          0       PCI-MSI-X

I think it's enough to tell in words here that the rest is random stack data 
or whatever. Including these 8bit mess will only screw up the commit message 
viewers for no benefit.

Greetings,

Eike
--nextPart2355958.mvt5XXGCp5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk5SkOUACgkQXKSJPmm5/E62HACeMcAljm3ve5RnoVegBCgWHRwf
AGwAoKK6ruwusjvFFyt/PKAHC2ujz3TD
=mRU6
-----END PGP SIGNATURE-----

--nextPart2355958.mvt5XXGCp5--

