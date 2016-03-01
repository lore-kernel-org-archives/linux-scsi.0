From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 11/15] scsi: ufs: handle non spec compliant bkops
 behaviour by device
Date: Tue, 1 Mar 2016 15:54:06 +0800
Message-ID: <56D54A9E.4020705@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-12-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-12-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> We are seeing that some devices are raising the urgent bkops exceptio=
n
> events even when BKOPS status doesn't indicate performace impacted or
> critical. Handle these device by determining their urgent bkops statu=
s
> at runtime.
>=20
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufshcd.c | 53 +++++++++++++++++++++++++++++++++++++=
+++-------
>  drivers/scsi/ufs/ufshcd.h |  6 ++++++
>  2 files changed, 52 insertions(+), 7 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
