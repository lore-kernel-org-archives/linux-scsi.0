From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 06/15] scsi: ufs: separate device and host quirks
Date: Tue, 1 Mar 2016 15:38:07 +0800
Message-ID: <56D546DF.3060802@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> Currently we use the host quirks mechanism in order to
> handle both device and host controller quirks.
> In order to support various of UFS devices we should separate
> handling the device quirks from the host controller's.
>=20
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/Makefile     |   2 +-
>  drivers/scsi/ufs/ufs.h        |  31 +++++++++++
>  drivers/scsi/ufs/ufs_quirks.c | 100 ++++++++++++++++++++++++++++++++=
++
>  drivers/scsi/ufs/ufs_quirks.h | 124 ++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/ufs/ufshcd.c     |   2 +
>  drivers/scsi/ufs/ufshcd.h     |   3 +
>  6 files changed, 261 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/scsi/ufs/ufs_quirks.c
>  create mode 100644 drivers/scsi/ufs/ufs_quirks.h
>=20
Sigh. _Of course_ there will be device quirks.
Probably too much to hope to have a new implementation where everyone
agrees on the details.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
