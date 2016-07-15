From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/19] qla2xxx: Disable the adapter and skip error
 recovery in case of register disconnect.
Date: Fri, 15 Jul 2016 15:02:25 +0200
Message-ID: <563ee99f-6361-d35a-dacf-122dd54bc3e5@suse.de>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
 <1467818075-15246-17-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbcGONC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:02:27 -0400
In-Reply-To: <1467818075-15246-17-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 07/06/2016 05:14 PM, Himanshu Madhani wrote:
> From: Sawan Chandak <sawan.chandak@qlogic.com>
>=20
> If there is error recovery going on due to command timeout and
> there is register disconnect, then disable the adapter.
>=20
> Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |  3 +++
>  drivers/scsi/qla2xxx/qla_dbg.c  |  2 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 55 +++++++++++++++++++++++++++++++=
++++++++++
>  3 files changed, 59 insertions(+), 1 deletion(-)
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
