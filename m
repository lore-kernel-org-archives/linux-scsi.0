From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/20] qla2xxx: Add FW resource count in DebugFS.
Date: Tue, 8 Dec 2015 16:53:14 +0100
Message-ID: <5666FCEA.6030009@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-5-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbbLHPxP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 10:53:15 -0500
In-Reply-To: <1449535747-2850-5-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
>=20
> DebugFS now will show fw_resource_count node.
>=20
> FW Resource count
>=20
> Original TGT exchg count[0]
> current TGT exchg count[0]
> original Initiator Exchange count[2048]
> Current Initiator Exchange count[2048]
> Original IOCB count[2078]
> Current IOCB count[2067]
> MAX VP count[254]
> MAX FCF count[0]
>=20
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
