From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 15/15] scsi: ufs-qcom: set PA_Local_TX_LCC_Enable
 before link startup
Date: Tue, 1 Mar 2016 15:58:58 +0800
Message-ID: <56D54BC2.70902@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-16-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbcCAH7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 02:59:16 -0500
In-Reply-To: <1456666367-11418-16-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> Some UFS devices (and may be host) have issues if LCC is
> enabled. So we are setting PA_Local_TX_LCC_Enable to 0
> before link startup which will make sure that both host
> and device TX LCC are disabled once link startup is
> completed.
>=20
> This change also:
> - enables the device ref clock before changing to HS mode
>   and disables it if entered to PWM mode
> - adds printouts of testbus debug registers
>=20
Please make that in two patches; these issues are unrelated and will
just confuse users if one ever need to dig through the git log.

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
