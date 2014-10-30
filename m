From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 28/36] atari_NCR5380: Refactor Falcon special cases
Date: Thu, 30 Oct 2014 09:23:29 +0100
Message-ID: <5451F581.1010209@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052613.865438061@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJ3IXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 04:23:30 -0400
In-Reply-To: <20141027052613.865438061@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Make the atari_NCR5380.c core driver usable by sun3_scsi, mac_scsi an=
d
> others by moving some of the Falcon-specific code out of the core dri=
ver:
> !IS_A_TT, atari_read_overruns and falcon_dont_release. Replace these =
with
> hostdata variables and flags. FLAG_CHECK_LAST_BYTE_SENT is unused in
> atari_NCR5380.c so don't set it.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
