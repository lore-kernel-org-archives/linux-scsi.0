From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] lpfc: Check for active portpeerbeacon.
Date: Mon, 25 May 2015 17:13:51 +0200
Message-ID: <55633C2F.6060702@suse.de>
References: <555f405b.edV1AAZPf7ciBGhe%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbbEYPNy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2015 11:13:54 -0400
In-Reply-To: <555f405b.edV1AAZPf7ciBGhe%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 05/22/2015 04:42 PM, James Smart wrote:
>=20
> Check for active portpeerbeacon.
>=20
> LCB requests to set Beacon would fail if the beacon was already enabl=
ed
> internally as the mailbox command used to query the state failes with
> an already-set status.
>=20
> Correct by enhancing the check so we don't fail if if the already set
> status comes back.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
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
