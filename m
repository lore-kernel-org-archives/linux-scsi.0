From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx
 drivers
Date: Mon, 21 Jun 2004 17:44:08 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621174408.012aa366.vsu@altlinux.ru>
References: <20040621161441.20dfcee6.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1";
 boundary="Signature=_Mon__21_Jun_2004_17_44_08_+0400_HyPZKxiosPCE48xs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mivlgu.ru ([81.18.140.87]:44747 "EHLO mail.mivlgu.ru")
	by vger.kernel.org with ESMTP id S266228AbUFUNoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 09:44:14 -0400
In-Reply-To: <20040621161441.20dfcee6.ak@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org

--Signature=_Mon__21_Jun_2004_17_44_08_+0400_HyPZKxiosPCE48xs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, 21 Jun 2004 16:14:41 +0200 Andi Kleen wrote:

> This is needed for 2.6 hotplug where the driver is autoloaded. When you have
> multiple conflicting entries the hotplug module loader usually loads
> the first one listed, which may be correct or may be not.
> 
> With these changes the drivers announce the correct PCI IDs.

Unfortunately, the patch does not seem to be correct :(

struct pci_device_id does not have the mask field, therefore the
ID_9005_GENERIC_MASK restriction cannot be specified other than by
listing all 16 possible IDs as separate entries.  Your patch adds only
one entry, thus losing 15 other possible IDs.

--Signature=_Mon__21_Jun_2004_17_44_08_+0400_HyPZKxiosPCE48xs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1uYrW82GfkQfsqIRAkAzAJ4m0skYaMbnD5fwzvV5a/x26TGCswCdHqvx
+sHQT3nrBPf/5dihv/nsfQ0=
=j8K4
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jun_2004_17_44_08_+0400_HyPZKxiosPCE48xs--
