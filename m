From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 0/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by
 8k
Date: Tue, 24 Nov 2015 16:09:03 +0100
Message-ID: <56547D8F.5060701@suse.de>
References: <1448358147-23663-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448358147-23663-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/24/2015 10:42 AM, Rasmus Villemoes wrote:
> This reduces the impact of choosing CONFIG_SCSI_CONSTANTS by about 8K=
B.
>=20
> 2dd951ecd511 ("scsi: Conditionally compile in constants.c") updated
> the Kconfig help text from 12KB to 75KB. The 12K predated git so was
> certainly outdated. But I'm not sure where the 75K comes from; using
> size(1) on a defconfig (with/without this config option) vmlinux show=
s
> a difference of about 47K, and 39K after these patches are applied. I=
n
> any case, I've left the Kconfig text alone, since I'm not sure I'm
> counting the same way the 75K was computed (I'm fairly certain of the
> 8K delta, however).
>=20
> Tested with a trivial module calling scsi_extd_sense_format with a fe=
w
> random known codes and comparing the result to the expected value.
>=20
> v2: prepend patch to unsplit a few string literals for greppability,
> leave the NULL sentinel in the .c file in 2/3 (it's removed in 3/3
> either way).
>=20
> Rasmus Villemoes (3):
>   scsi: make some Additional Sense strings more grep'able
>   scsi: move Additional Sense Codes to separate file
>   scsi: reduce CONFIG_SCSI_CONSTANTS=3Dy impact by 8k
>=20
>  drivers/scsi/constants.c   | 859 ++---------------------------------=
----------
>  drivers/scsi/sense_codes.h | 826 +++++++++++++++++++++++++++++++++++=
++++++++
>  2 files changed, 847 insertions(+), 838 deletions(-)
>  create mode 100644 drivers/scsi/sense_codes.h
>=20
=46or the whole series:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
