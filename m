From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] aic7xxx: deinline large or slow functions
Date: Fri, 25 Apr 2008 08:28:50 +0200
Message-ID: <48117A22.5040708@suse.de>
References: <200804250432.16943.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbYDYG2w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 02:28:52 -0400
In-Reply-To: <200804250432.16943.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Hi Denys,

Denys Vlasenko wrote:
> Hi Hannes,
>=20
> I reworked my patches as you requested.
>=20
> The first one (in this mail) was ACKed by you, so it's just a resend.
>=20
> Following pathes were not ACKed and are modified.
> Please take a look.
>=20
>=20
>=20
> Deinlines and moves big functions from .h to .c files.
> Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
>=20
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
