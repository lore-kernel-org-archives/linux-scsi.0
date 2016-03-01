From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 12/15] scsi: ufs: tune UniPro parameters to optimize
 hibern8 exit time
Date: Tue, 1 Mar 2016 15:55:49 +0800
Message-ID: <56D54B05.5010103@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-13-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-13-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> Optimal values of local UniPro parameters like PA_Hibern8Time &
> PA_TActivate can help reduce the hibern8 exit latency. If both host a=
nd
> device supports UniPro ver1.6 or later, these parameters will be
> automatically tuned during link startup itself. But if either host or
> device doesn't support UniPro ver 1.6 or later, we have to manually
> tune them. But to keep manual tuning logic simple, we will only do
> manual tuning if local unipro version doesn't support ver1.6 or later=
=2E
>=20
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufshcd.c | 118 ++++++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/ufs/ufshcd.h |   1 +
>  drivers/scsi/ufs/ufshci.h |   2 +
>  drivers/scsi/ufs/unipro.h |  21 +++++++++
>  4 files changed, 142 insertions(+)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
