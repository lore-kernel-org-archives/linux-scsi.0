From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/22] ncr5380: Update usage documentation
Date: Mon, 14 Mar 2016 08:47:47 +0100
Message-ID: <56E66CA3.5080002@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042705.596042088@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042705.596042088@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Update kernel parameter documentation for atari_scsi, mac_scsi and
> g_NCR5380 drivers. Remove duplication.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  Documentation/scsi/g_NCR5380.txt       |   17 ++++++---------
>  Documentation/scsi/scsi-parameters.txt |   11 +++++++---
>  drivers/scsi/g_NCR5380.c               |   36 ----------------------=
-----------
>  3 files changed, 16 insertions(+), 48 deletions(-)
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
