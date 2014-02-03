From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 08:50:12 -0600
Message-ID: <52EFACA4.6060001@tributary.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:2893 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaBCOuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 09:50:25 -0500
In-Reply-To: <52EE2F2D.1010300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, =?windows-1252?Q?=22Kai_M=E4kisara_?= =?windows-1252?Q?=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/2/2014 5:42 AM, Hannes Reinecke wrote:
> This is due to the strictly sequential design udev has. Essentially udev
> spawns a worker for every device which gets created (= udev receives a
> uevent for).
	
	The part I fail to see in this explanation is why the nst/st/st*a/st*m/etc
handles are being treated as separate devices. They aren't. They are all the
same physical tape device, so why are the nst devices being handled separately
from the st ones?

	Maybe the problem is that you have to many "workers" for the tape device.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS76ykAAoJEL5i86xrzcy7MKMH/0upLuOBOJWzdOfKYq0WmIvZ
eIaaZG2vhckYeS2zZtim5uVFQDp5eTOirmjxfwSGzSTSAmNrQJwzZvBO/vA2/Kqk
wZSKXp/ZGZhw11+6Kg8f1EArQQwT/i3R6BKglLELFvZVvNOUg3KCnd6nE/4k7ysh
H3f6+6/Jb1wUA6h7a65BG7VBQlJ3HqVe01vYTrkb3eYW7IWfN0tX2FMdqYt2zon2
Yo6TRxhTE/dmqJhg8nLB+fA8rUwW7CYU/IX8nsKNn9lPaDdoJ6g22ozpJRrtEZZ+
lt/qL3VxfWu38z0GWhuKuOqY969bMlyaphY7bOgf7LY4osiC7OgarVoxSIgfP9E=
=pIPt
-----END PGP SIGNATURE-----
