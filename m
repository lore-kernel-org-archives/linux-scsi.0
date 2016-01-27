From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/11] qla2xxx: Provide mbx info in BBCR data after mbx
 failure
Date: Wed, 27 Jan 2016 09:47:13 +0100
Message-ID: <56A88411.4020208@suse.de>
References: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453828246-28686-9-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbcA0IrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 03:47:14 -0500
In-Reply-To: <1453828246-28686-9-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 01/26/2016 06:10 PM, Himanshu Madhani wrote:
> From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
>=20
> Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c |    9 +++++++--
>  drivers/scsi/qla2xxx/qla_bsg.h |    4 +++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
