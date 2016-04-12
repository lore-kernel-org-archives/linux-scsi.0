From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 02/14] libsas: enable FPDMA SEND/RECEIVE
Date: Tue, 12 Apr 2016 09:25:27 +0200
Message-ID: <570CA2E6.9020204@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1460443678-57934-3-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 04/12/2016 08:47 AM, Hannes Reinecke wrote:
> Update libsas and dependent drivers to handle FPDMA
> SEND/RECEIVE correctly.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 ++
>  drivers/scsi/isci/request.c            | 4 +++-
>  drivers/scsi/libsas/sas_ata.c          | 6 ++++--
>  drivers/scsi/mvsas/mv_sas.c            | 4 +++-
>  drivers/scsi/pm8001/pm8001_sas.c       | 4 +++-
>  5 files changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hi=
si_sas/hisi_sas_v2_hw.c
> index b733747..fc2e767 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -1573,6 +1573,8 @@ static u8 get_ata_protocol(u8 cmd, int directio=
n)
>  	switch (cmd) {
>  	case ATA_CMD_FPDMA_WRITE:
>  	case ATA_CMD_FPDMA_READ:
> +	case ATA_CMD_FPMDA_RECV:
> +	case ATA_CMD_FPDMA_SEND:
>  	return SATA_PROTOCOL_FPDMA;
> =20
>  	case ATA_CMD_ID_ATA:
Bah. Blasted typo; had it fixed up at one point, but now it crept in
again. Tejun, can you fix it up or should I resubmit this patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
