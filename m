From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: fix build warning
Date: Fri, 11 Dec 2015 09:37:27 +0100
Message-ID: <566A8B47.8090805@suse.de>
References: <1449822963-9054-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449822963-9054-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/11/2015 09:36 AM, Sudip Mukherjee wrote:
> We were getting build warning about unused variables "vpd_pg83" and "=
d"
>
> Fixes: 83ea0e5e3501 ("scsi_dh_alua: use scsi_vpd_tpg_id()")
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> build warning with next-20151211 and build log is at:
> https://travis-ci.org/sudipm-mukherjee/parport/jobs/96209206
> ---
>
>   drivers/scsi/device_handler/scsi_dh_alua.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index f100cbb..5a328bf 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -320,8 +320,6 @@ static int alua_check_tpgs(struct scsi_device *sd=
ev)
>    */
>   static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_=
data *h)
>   {
> -	unsigned char *d;
> -	unsigned char __rcu *vpd_pg83;
>   	int rel_port =3D -1, group_id;
>
>   	group_id =3D scsi_vpd_tpg_id(sdev, &rel_port);
>
A fix for this is already queued in Martin Petersens tree.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
