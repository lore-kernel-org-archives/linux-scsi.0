From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/5] nvme-fabrics: Add FC transport LLDD api definitions
Date: Mon, 25 Jul 2016 11:12:53 +0200
Message-ID: <20160725091253.cq6lpgultbzleyq5@c203.arch.suse.de>
References: <5792b91c.7HwdoM0qFRAjvQId%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbcGYJMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 05:12:55 -0400
Content-Disposition: inline
In-Reply-To: <5792b91c.7HwdoM0qFRAjvQId%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:23:56PM -0700, James Smart wrote:
>=20
> nvme-fabrics: Add FC transport LLDD api definitions:
>=20
> Host:
> -LLDD registration with the host transport
> -registering host ports (local ports) and target ports seen on
>    fabric (remote ports)
> -Data structures and call points for FC-4 LS's and FCP IO requests
>=20
> Target:
> -LLDD registration with the target transport
> -registering nvme subsystem ports (target ports)
> -Data structures and call points for reception of FC-4 LS's and
>    FCP IO requests, and callbacks to perform data and rsp transfers
>    for the io.
>=20
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
