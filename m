From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/9] lpfc: Add support for using block multi-queue
Date: Mon, 25 May 2015 17:18:18 +0200
Message-ID: <55633D3A.2060001@suse.de>
References: <555f405e.2o5/YwCIJ/19LVTb%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbbEYPSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2015 11:18:20 -0400
In-Reply-To: <555f405e.2o5/YwCIJ/19LVTb%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 05/22/2015 04:42 PM, James Smart wrote:
>=20
> Add support for using block multi-queue
>=20
> With blk-mq support in the mid-layer, lpfc can do IO steering based
> on the information in the request tag.  This patch allows lpfc to use
> blk-mq if enabled. If not enabled, we fall back into the emulex-inter=
nal
> affinity mappings.
>=20
> This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
> scsi_mod.use_blk_mq=3DY as a parameter to the kernel.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---

Sweet.

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
