From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] lpfc: Devices are not discovered during takeaway/giveback
 testing
Date: Mon, 25 May 2015 17:15:39 +0200
Message-ID: <55633C9B.7010000@suse.de>
References: <555f405d.19aP4Ju4SItrRE4D%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbbEYPPl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2015 11:15:41 -0400
In-Reply-To: <555f405d.19aP4Ju4SItrRE4D%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 05/22/2015 04:42 PM, James Smart wrote:
>=20
> Devices are not discovered during takeaway/giveback testing
>=20
> When a remote nport changes it's DID, a new ndlp is used.
> However, we left the old ndlp state unchanged and still in
> a discovery state. The may stall discovery resulting in some
> devices not being discovered.  Correct by swapping the state
> of the 2 ndlp's when a DID swap is detected.
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
