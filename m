From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Fri, 31 Jan 2014 10:36:17 -0600
Message-ID: <52EBD101.3080908@tributary.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:5053 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaAaQga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2014 11:36:30 -0500
In-Reply-To: <1391157974-17512-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Kay Sievers <kay@vrfy.org>, Kai Makisara <kai.makisara@kolumbus.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/31/2014 2:46 AM, Hannes Reinecke wrote:

> This patch make the tape always non-rewinding when SG_IO is used, thus
> allowing udev to get a proper device id for tapes.

	This is wholly bad. Just because someone fires a SG ioctl at the device
(usually to perform an operation that cannot be done with the st_ops) doesn't
mean they don't want the tape rewound on close.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS69EBAAoJEL5i86xrzcy7Ke0IAJbFISKHpJXuuWkK5EveElgG
8+Oy/ndRTSilqg5Ghn4Givr6LnVgs2hZVu6RUz3Y4WADwehxMof3iq6VhqN8bwkr
Zun40DxZAwrxAQQJ8jn+0grKbiL/GdkTr6CwVJ7AUC1odFUOXd9tCqKa8YEzsRwQ
dfoHBqU3cgGFir/l9wlvz0n+9kR4O3Y81IzCTJNAaLNRDelss6eqKEXuRI/53/5y
K5WcYSxHNvqpBLWlRRF2fouyrxiVdsYr4WGoJZf9ReMK5UV8Ztr3YFG7HsRAAyTA
b9PzWQF160U73sh6UFIjxG1UNmkBMxilLdQTJWfVHrQTeWakXRIV9gYB/0Z2l2Q=
=teWU
-----END PGP SIGNATURE-----
