From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Fri, 31 Jan 2014 10:43:39 -0600
Message-ID: <52EBD2BB.8020705@tributary.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:5667 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaAaQnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2014 11:43:41 -0500
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

	Maybe instead of silently changing the behavior, if you just _HAVE_ to open
the st device, add an ioctl or st/mt_op that disables the rewind on close.
That way applications have to explicitly disable the rewind on close.







-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS69K7AAoJEL5i86xrzcy7aC8IAJWoag7UaFselARB6eZ4Zfvm
qi0Fho04TkqnNUJ5VEU81p05XwPJrmonrmqK55kR0PVkMT3o4Wp/KpkeN7gwrQjx
ecR1Ckpoo4Q6n3W/HY06amN6qxLHgwi8RuU9vF7gjRZP4xqW57WRZz1GcuerD94n
tF/i2Ajev6ZsdmRSCUN9DDFDR5RNKZ+XmiX3ihx4L1v27I/zMEteO66pDEIRdCoM
laJnzsEfh/VNZdLeB3wck5xnW6HVq9YgqtH/oV+2LHeHg/Ji626g5/qsjhaA3YJQ
asol8MJsbBGIcaRKEa9EJYy76GVFyCkMLywVFEyN7F9xcFD75P5p2a4siMlYzBc=
=7Viv
-----END PGP SIGNATURE-----
