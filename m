From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: aic7xxx: aic7xxx_core:  Remove some unused functions
Date: Sat, 10 Jan 2015 14:30:39 +0100
Message-ID: <54B1297F.5090901@suse.de>
References: <1420302957-12653-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420302957-12653-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/03/2015 05:35 PM, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> ahc_outq() ahc_inq()
>=20
> This was partially found by using a static code analysis program call=
ed cppcheck.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigit=
al.se>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
