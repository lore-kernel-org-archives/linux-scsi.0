From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 26/36] sun3_scsi: Move macro definitions
Date: Thu, 30 Oct 2014 09:20:37 +0100
Message-ID: <5451F4D5.9080701@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052613.395688590@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaJ3IUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 04:20:39 -0400
In-Reply-To: <20141027052613.395688590@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> The #defines in sun3_scsi.h are intended to influence subsequent #inc=
ludes
> in sun3_scsi.c. IMHO, that's too convoluted.
>=20
> Move sun3_scsi.h macro definitions to sun3_scsi.c, consistent with ot=
her
> NCR5380 drivers.
>=20
> Omit the unused NCR5380_local_declare() and NCR5380_setup() macros.
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
