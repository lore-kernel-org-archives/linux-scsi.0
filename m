From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 02/15] scsi: ufs: avoid spurious UFS host controller
 interrupts
Date: Tue, 1 Mar 2016 13:10:15 +0800
Message-ID: <56D52437.1050104@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcCAFKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 00:10:40 -0500
In-Reply-To: <1456666367-11418-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> When control reaches to Linux UFS driver during UFS boot mode, UFS ho=
st
> controller interrupt status/enable registers may have left over
> settings.
> In order to avoid any spurious interrupts due to these left overs,
> it's important to clear these interrupt status/enable registers befor=
e
> enabling UFS interrupt handling.
>=20
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
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
