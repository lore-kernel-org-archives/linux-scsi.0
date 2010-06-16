From: Hannes Reinecke <hare@suse.de>
Subject: Re: Configuring 2.6.33 Kernel for PERC/4
Date: Wed, 16 Jun 2010 08:29:01 +0200
Message-ID: <4C186F2D.5000505@suse.de>
References: <B1F6E31A031C3D41B1DDB4503295ADFF02DBB81E@naeaphilez08v.nadsusea.nads.navy.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457Ab0FPG3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 02:29:03 -0400
In-Reply-To: <B1F6E31A031C3D41B1DDB4503295ADFF02DBB81E@naeaphilez08v.nadsusea.nads.navy.mil>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Huntress, Gary B CIV NUWC NWPT" <gary.huntress@navy.mil>
Cc: linux-scsi@vger.kernel.org

Huntress, Gary B CIV NUWC NWPT wrote:
>=20
> Hi,
>=20
> I'm trying to help someone who is having difficulty upgrading from a =
2.6.9 kernel to 2.6.33.  The box is a Dell Poweredge 2650 and has a
> PERC4/DC "standard" (351X firmware).  When I run make menuconfig I se=
e two good choices for drivers:
>=20
> LSI Logic New Generation RAID Device Driver
> LSI Logic Legacy MegaRAID=20
>=20
> I've tried each seperately, as modules and in the kernel but when I b=
oot it panics with an error about "/bin/lvm exited abnormally"
>=20
> I can't find any clues in /var/log/messages.   I'd appreciate it if s=
omeone could point me in the right direction to configure this
> kernel properly for MegaRAID support!
>=20
Please attach the kernel message log. We would need to know the message=
s from the driver to figure that out.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
