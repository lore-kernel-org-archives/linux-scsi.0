From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] nvme-fabrics: rework nvmf_get_address() for variable
 options
Date: Fri, 29 Jul 2016 10:53:44 +0200
Message-ID: <20160729085344.gn5znmczwyxqauum@c203.arch.suse.de>
References: <579a9c99.RE/wCYn5/6zl6dPY%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbcG2Ixq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 04:53:46 -0400
Content-Disposition: inline
In-Reply-To: <579a9c99.RE/wCYn5/6zl6dPY%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Jul 28, 2016 at 05:00:25PM -0700, James Smart wrote:
>=20
> Revise nvmf_get_address() string to account for not all options being
> present.
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
