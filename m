From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 31/36] sun3_scsi: Adopt atari_NCR5380 core driver and
 remove sun3_NCR5380.c
Date: Thu, 30 Oct 2014 09:35:28 +0100
Message-ID: <5451F850.3020503@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052614.615460253@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJ3If3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 04:35:29 -0400
In-Reply-To: <20141027052614.615460253@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Given the preceding changes to atari_NCR5380.c, this patch should not=
 change
> behaviour of the sun3_scsi and sun3_scsi_vme modules.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

One down. Good work.

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
