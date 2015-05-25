From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] lpfc: Fix to drop PLOGIs from fabric node till LOGO
 processing completes
Date: Mon, 25 May 2015 17:21:02 +0200
Message-ID: <55633DDE.40302@suse.de>
References: <555f4063.eNa6hhtd/lAYXugc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbEYPVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2015 11:21:03 -0400
In-Reply-To: <555f4063.eNa6hhtd/lAYXugc%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 05/22/2015 04:42 PM, James Smart wrote:
>=20
> Fix to drop PLOGIs from fabric node till LOGO processing completes
>=20
> The domain controller PLOGI's concurrent with prior LOGO's/unreg_rpi'=
s
> completing created a race condition where driver rpi ref count can
> inadvertantly hit 0 and the rpi attempted to be freed. This error
> sometimes resulted in Warning messages indicating kref.h via
> lfpc_nlp_get+0x128.
>=20
> Correct by dropping any new PLOGI until the prior nport state has set=
tled.
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
