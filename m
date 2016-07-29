From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] nvme-fabrics: Add host_traddr options field to host
 infrastructure
Date: Fri, 29 Jul 2016 10:55:10 +0200
Message-ID: <20160729085510.2jlunyo42jvhysju@c203.arch.suse.de>
References: <579a9c9b.pfetMBhIGNhCI9uD%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbcG2IzP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 04:55:15 -0400
Content-Disposition: inline
In-Reply-To: <579a9c9b.pfetMBhIGNhCI9uD%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Jul 28, 2016 at 05:00:27PM -0700, James Smart wrote:
>=20
> Add the host_traddr field to allow specification of the host-port
> connection info for the transport. Will be used by FC transport.
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
