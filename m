From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/19] qla2xxx: Add bsg interface to support D_Port
 Diagnostics.
Date: Fri, 15 Jul 2016 14:55:33 +0200
Message-ID: <fd6c7bb7-56f6-451f-0085-191a91a2c674@suse.de>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
 <1467818075-15246-11-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbcGOMzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 08:55:35 -0400
In-Reply-To: <1467818075-15246-11-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 07/06/2016 05:14 PM, Himanshu Madhani wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>=20
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 44 ++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_bsg.h | 12 +++++++++
>  drivers/scsi/qla2xxx/qla_dbg.c |  3 +--
>  drivers/scsi/qla2xxx/qla_gbl.h |  3 +++
>  drivers/scsi/qla2xxx/qla_isr.c |  7 +++--
>  drivers/scsi/qla2xxx/qla_mbx.c | 58 ++++++++++++++++++++++++++++++++=
+++++++++-
>  6 files changed, 122 insertions(+), 5 deletions(-)
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
