From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH RESEND] scsi_debug: fix prevent_allow+verify regressions
Date: Tue, 24 Nov 2015 16:04:24 +0100
Message-ID: <56547C78.3010306@suse.de>
References: <5651F740.3010707@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5651F740.3010707-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, "Martin K. Petersen" <martin.petersen-MouhYhfBpPxXrIkS9f7CXA@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: sweet_f_a-Mmb7MZpHnFY@public.gmane.org, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/22/2015 06:11 PM, Douglas Gilbert wrote:
> Ruediger Meier observed a regression with the PREVENT ALLOW
> MEDIUM REMOVAL command in lk 3.19:
>   http://www.spinics.net/lists/util-linux-ng/msg11448.html
>=20
> Inspection indicated the same regression with VERIFY(10).
>=20
> The patch is against lk 3.19.3 and also works with lk 4.3.0 .
> With this patch both commands are accepted and do nothing.
>=20
> ChangeLog:
>   - fix the lk 3.19 regression so that the PREVENT ALLOW
>     MEDIUM REMOVAL command is supported once again
>   - same fix for VERIFY(10)
>=20
> Signed-off-by: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe util-linux" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
