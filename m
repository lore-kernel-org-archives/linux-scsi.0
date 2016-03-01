From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 14/15] scsi: ufs: add device quirk delay before putting
 UFS rails in LPM
Date: Tue, 1 Mar 2016 15:57:19 +0800
Message-ID: <56D54B5F.9070204@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-15-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-15-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> We put the UFS device in sleep state & UFS link in hibern8 state duri=
ng
> runtime suspaned. After this we put all the UFS rails in low power
> modes immediately but it seems some devices may still draw more than
> sleep current from UFS rails (especially from VCCQ rail) atleast for
> 500us.
> To avoid this situation, this change adds 2ms delay before putting
> these UFS rails in LPM mode.
>=20
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufs_quirks.c |  4 ++++
>  drivers/scsi/ufs/ufs_quirks.h | 11 ++++++++++-
>  drivers/scsi/ufs/ufshcd.c     | 10 ++++++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
