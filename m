From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/22] sun3_scsi: Adopt NCR5380.c core driver
Date: Mon, 14 Mar 2016 08:40:58 +0100
Message-ID: <56E66B0A.3050702@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042703.755991758@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbcCNHlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 03:41:00 -0400
In-Reply-To: <20160314042703.755991758@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Add support for the custom Sun 3 DMA logic to the NCR5380.c core driv=
er.
> This code is copied from atari_NCR5380.c.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>=20
> The Sun 3 DMA code is still configured by macros. I have simplified t=
hings
> slightly but I have avoided more ambitious refactoring. It's not clea=
r to
> me what that should look like and I can't test sun3_scsi anyway. At l=
east
> this permits the removal of atari_NCR5380.c.
>=20
> ---
>  drivers/scsi/NCR5380.c   |  131 ++++++++++++++++++++++++++++++++++++=
+++++++----
>  drivers/scsi/sun3_scsi.c |    8 +-
>  2 files changed, 124 insertions(+), 15 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
