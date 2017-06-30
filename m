From: Colin Ian King <colin.king@canonical.com>
Subject: NAK: [PATCH] scsi: snic: fix a couple of spelling mistakes/typos
Date: Fri, 30 Jun 2017 14:55:56 +0100
Message-ID: <f7725ec7-ab5d-b475-5407-9f2fac4af006@canonical.com>
References: <20170630135429.14251-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170630135429.14251-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Incorrect commit message, I'll resend.

On 30/06/17 14:54, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistakes/typos:
> 
> "Allodating" -> "Allocating"
> "incative" -> "inactive"
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/snic/snic_isr.c  | 4 ++--
>  drivers/scsi/snic/snic_scsi.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/snic/snic_isr.c b/drivers/scsi/snic/snic_isr.c
> index d859501e4ccd..c4da3673f2ae 100644
> --- a/drivers/scsi/snic/snic_isr.c
> +++ b/drivers/scsi/snic/snic_isr.c
> @@ -141,7 +141,7 @@ snic_request_intr(struct snic *snic)
>  				  snic->msix[i].devid);
>  		if (ret) {
>  			SNIC_HOST_ERR(snic->shost,
> -				      "MSI-X: requrest_irq(%d) failed %d\n",
> +				      "MSI-X: request_irq(%d) failed %d\n",
>  				      i,
>  				      ret);
>  			snic_free_intr(snic);
> @@ -151,7 +151,7 @@ snic_request_intr(struct snic *snic)
>  	}
>  
>  	return ret;
> -} /* end of snic_requrest_intr */
> +} /* end of snic_request_intr */
>  
>  int
>  snic_set_intr_mode(struct snic *snic)
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index 05c3a7282d4a..d8a376b7882d 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -1260,7 +1260,7 @@ snic_io_cmpl_handler(struct vnic_dev *vdev,
>  	default:
>  		SNIC_BUG_ON(1);
>  		SNIC_SCSI_DBG(snic->shost,
> -			      "Unknown Firmwqre completion request type %d\n",
> +			      "Unknown Firmware completion request type %d\n",
>  			      fwreq->hdr.type);
>  		break;
>  	}
> 
