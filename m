From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 34/36] atari_NCR5380: Move static TagAlloc array to
 host data
Date: Thu, 30 Oct 2014 09:41:19 +0100
Message-ID: <5451F9AF.9030706@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052615.345443933@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052615.345443933@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> The atari_NCR5380.c core driver keeps some per-host data in a static
> variable which limits the driver to a single instance. Fix this by mo=
ving
> TagAlloc to the hostdata struct.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
Hmm. This really cries to be converted to the generic blk-tag code.
But it'll do for now.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
