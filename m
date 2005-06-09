From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] use spi_transport_class for aic79xx
Date: Thu, 09 Jun 2005 15:27:00 +0200
Message-ID: <42A843A4.2080702@suse.de>
References: <42A7EAEA.3060302@suse.de> <42A7F5A7.5080401@pobox.com>	 <42A7FD7A.1050105@suse.de> <1118322702.5041.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:7078 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262374AbVFIN1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2005 09:27:03 -0400
In-Reply-To: <1118322702.5041.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-06-09 at 10:27 +0200, Hannes Reinecke wrote:
>>Next step is to connect an U320 drive to check it works properly.
>=20
> That's definitely a requirement.  The sole function of aic79xx over
> aic7xxx is u320.  That being said, I have been covertly converting th=
e
> transport classes to cope with u320 DV.  I believe now it all works.
> However, you need to plug in more transport parameters than you
> currently have (even if a lot of them are read only).  You also need =
to
> update the couplings for the period =3D=3D 8 case (which is u32).
A-ha.
Can't say I understood all of it, but nevertheless.

>=20
> Let me post the patches I used to fusion as an RFC and you can examin=
e
> the variable setting routines to see how it's done=20
>=20
That would be helpful. Is it in your recent scsi-misc patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=C3=9Fe 5				+49 911 74053 688
90409 N=C3=BCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
