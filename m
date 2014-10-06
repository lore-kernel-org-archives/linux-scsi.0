From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 28/29] atari_NCR5380: Refactor Falcon special cases
Date: Mon, 06 Oct 2014 11:28:11 +0200
Message-ID: <543260AB.3020307@suse.de>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065634.956141656@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065634.956141656@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/02/2014 08:56 AM, Finn Thain wrote:
> Make the atari_NCR5380.c core driver usable by sun3_scsi, mac_scsi an=
d others
> by moving some of the Falcon-specific code out of the core driver: !I=
S_A_TT,
> atari_read_overruns and falcon_dont_release. Replace these with hostd=
ata=20
> variables and flags. FLAG_CHECK_LAST_BYTE_SENT is unused in atari_NCR=
5380.c
> so don't set it.
>=20
Hmm. Shouldn't there be some more patches for sun3_scsi and mac_scsi
to actually make use of this?

I'd _love_ to get rid of all of this NCR5380 code duplication ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
