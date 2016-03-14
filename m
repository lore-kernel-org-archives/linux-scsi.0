From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/22] ncr5380: Disable the DMA errata workaround flag by
 default
Date: Mon, 14 Mar 2016 08:26:45 +0100
Message-ID: <56E667B5.3090708@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042701.956017683@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbcCNH0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 03:26:47 -0400
In-Reply-To: <20160314042701.956017683@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/14/2016 05:27 AM, Finn Thain wrote:
> The only chip that needs the workarounds enabled is an early NMOS
> device. That means that the common case is to disable them.
>=20
> Unfortunately the sense of the flag is such that it has to be set
> for the common case.
>=20
> Rename the flag so that zero can be used to mean "no errata workaroun=
ds
> needed". This simplifies the code.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c      |   14 +++++++-------
>  drivers/scsi/NCR5380.h      |    2 +-
>  drivers/scsi/arm/cumana_1.c |    2 +-
>  drivers/scsi/arm/oak.c      |    2 +-
>  drivers/scsi/dtc.c          |    2 +-
>  drivers/scsi/g_NCR5380.c    |    8 +-------
>  drivers/scsi/pas16.c        |    2 +-
>  drivers/scsi/t128.c         |    2 +-
>  8 files changed, 14 insertions(+), 20 deletions(-)
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
