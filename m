From: Hannes Reinecke <hare@suse.de>
Subject: Re: aic79xx: fix sense_buffer access bug
Date: Tue, 29 Jan 2008 10:43:08 +0100
Message-ID: <479EF52C.9000408@suse.de>
References: <20080127124023L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:47357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYA2JnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 04:43:12 -0500
In-Reply-To: <20080127124023L.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

=46UJITA Tomonori wrote:
> Ah, I overlooked more LLDs...
>=20
> =3D
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] aic79xx: fix sense_buffer access bug
>=20
> The commit de25deb18016f66dcdede165d07654559bb332bc changed
> scsi_cmnd.sense_buffer from a static array to a dynamically allocated
> buffer. We can't access to sense_buffer in '&cmd->sense_buffer' way.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
