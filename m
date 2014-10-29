From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/36] ncr5380: Remove useless prototypes
Date: Wed, 29 Oct 2014 15:41:41 +0100
Message-ID: <5450FCA5.6000909@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052608.355775484@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052608.355775484@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Add missing static qualifiers and remove the now pointless prototypes=
=2E The
> NCR5380_* prototypes are all declared in NCR5380.h and renamed using =
macros.
> Further declarations are redundant (some are completely unused). Remo=
ve
> them.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
