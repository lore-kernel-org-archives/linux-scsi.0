From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 00:33:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116233328.GB24093@devserv.devel.redhat.com>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:64467 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265837AbUAPXdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 18:33:47 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2004 at 12:02:50PM -0800, Andrew Vasquez wrote:
> I'll open up a request-for-response from the rest of the listers in
> asking if parceling out qlaAB00.ko modules based on firmware types is
> both practical and sensible from a user standpoint.  Especially
> considering that many users aren't really concerned with the ISP chip
> type on their QLAXXXX or OEM-BRANDED ABC host bus adapter.

that is what operating system installers are for (and udev/hotplug), modules
load automatically based on the PCI table nowadays ;)

Another approach could be separate modules which ONLY have firmware, one
module per firmware file (but that gets you really close to
request_firmare() api)



--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFACHTHxULwo51rQBIRAlNoAKCXUAS00aAOyj4PRLW9GinFWw5FIwCeJbIQ
QY1jAkMhGUGmbNasjrDMKUU=
=KQM7
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
