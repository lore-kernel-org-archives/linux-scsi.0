From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] nvme-fabrics: patch target code in prep for FC transport
 support
Date: Mon, 25 Jul 2016 10:46:07 +0200
Message-ID: <20160725084607.zwpnwgedysivtzva@c203.arch.suse.de>
References: <5792b917.3oKKdzw3zzjpaClb%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbcGYIqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 04:46:09 -0400
Content-Disposition: inline
In-Reply-To: <5792b917.3oKKdzw3zzjpaClb%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:23:51PM -0700, James Smart wrote:
>=20
> Patch nvme-fabrics target code in prep for FC transport support:
> - Add FC transport type decoding
> - Add FC address family decoding
>=20
> Patch is cut against the linux-nvme for-4.8/drivers branch
>=20
> Note: this patch had been posted to the prior nvme fabrics repository=
 but
> not merged before being brought over to linux-nvme.
>=20
> Signed-off-by: James Smart <james.smart@broadcom.com>

Acked-by: Johannes Thumshirn <jth@kernel.org>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
