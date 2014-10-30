From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 15/36] ncr5380: Remove *_RELEASE macros
Date: Thu, 30 Oct 2014 08:36:10 +0100
Message-ID: <5451EA6A.7090708@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052610.755444813@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052610.755444813@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> The *_RELEASE macros don't tell me anything. In some cases the versio=
n in
> the macro contradicts the version in the comments. Anyway, the Linux =
kernel
> version is sufficient information. Remove these macros to improve rea=
dability.
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
