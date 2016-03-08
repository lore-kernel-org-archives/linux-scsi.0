From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 15/17] scsi: ufs-qcom: set PA_Local_TX_LCC_Enable
 before link startup
Date: Tue, 8 Mar 2016 14:02:24 +0100
Message-ID: <56DECD60.9080502@suse.de>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
 <1457440568-13084-16-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457440568-13084-16-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 03/08/2016 01:36 PM, Yaniv Gardi wrote:
> Some UFS devices (and may be host) have issues if LCC is
> enabled. So we are setting PA_Local_TX_LCC_Enable to 0
> before link startup which will make sure that both host
> and device TX LCC are disabled once link startup is
> completed.
>=20
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 27 ++++++++++++++++++++-------
>  drivers/scsi/ufs/unipro.h   |  1 +
>  2 files changed, 21 insertions(+), 7 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
