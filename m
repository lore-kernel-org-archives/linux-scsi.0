From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2][RESEND] scsi_dh_alua: ALUA check sense should retry
 device internal reset unit attention
Date: Wed, 16 Oct 2013 07:47:35 +0200
Message-ID: <525E2877.1050003@suse.de>
References: <1381852359.1593.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab3JPFrh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 01:47:37 -0400
In-Reply-To: <1381852359.1593.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 10/15/2013 05:52 PM, Stewart, Sean wrote:
> When the scsi_dh_alua handler issues an RTPG during initialization, i=
f it gets 0x06/0x29/0x04 as the sense,
> it will fail to attach the handler.  NetApp E-Series returns 0x29/0x0=
0 for power on, and 0x29/0x04 for
> conditions that cause the controller to reboot again.  These conditio=
ns should be treated identically within
> the handler.
>=20
> Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
