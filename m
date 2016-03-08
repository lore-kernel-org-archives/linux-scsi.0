From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 17/17] scsi: ufs-qcom: add printouts of testbus debug
 registers
Date: Tue, 8 Mar 2016 14:04:12 +0100
Message-ID: <56DECDCC.1010606@suse.de>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
 <1457440568-13084-18-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbcCHNEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2016 08:04:15 -0500
In-Reply-To: <1457440568-13084-18-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 03/08/2016 01:36 PM, Yaniv Gardi wrote:
> This change adds printouts of testbus and debug registers.
>=20
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 77 +++++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/ufs/ufs-qcom.h |  9 ++++++
>  2 files changed, 86 insertions(+)
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
