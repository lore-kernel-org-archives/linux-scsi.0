From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/36] ncr5380: Cleanup TAG_NEXT and TAG_NONE macros
Date: Wed, 29 Oct 2014 15:45:21 +0100
Message-ID: <5450FD81.7050307@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052608.825920884@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960AbaJ2OpX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 10:45:23 -0400
In-Reply-To: <20141027052608.825920884@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Both atari_NCR5380.c and sun3_NCR5380.c core drivers #undef TAG_NONE =
and
> then redefine it. But the original definition is unused because NCR53=
80.c
> lacks support for tagged queueing. So just define it once.
>=20
> The TAG_NEXT macro only appears in the arguments to NCR5380_select() =
calls.
> But that routine doesn't use its tag argument as the tag was already
> assigned in NCR5380_main(). So remove the unused argument and the mac=
ro.
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
