From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 16/17] scsi: ufs-qcom: enable/disable the device ref
 clock
Date: Tue, 8 Mar 2016 14:03:10 +0100
Message-ID: <56DECD8E.9030902@suse.de>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
 <1457440568-13084-17-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457440568-13084-17-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 03/08/2016 01:36 PM, Yaniv Gardi wrote:
> This change enables the device ref clock before changing to HS mode
> and disables it if entered to PWM mode.
>=20
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 12 ++++++++++++
>  drivers/scsi/ufs/ufshcd.h   |  9 +++++++++
>  2 files changed, 21 insertions(+)
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
