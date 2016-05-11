From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 4/6] mpt3sas: Updating mpt3sas driver version to
 13.100.00.00
Date: Wed, 11 May 2016 16:02:36 +0200
Message-ID: <57333B7C.6080908@redhat.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
 <1462525171-6877-5-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-5-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6.5.2016 10:59, Chaitra P B wrote:
> Bump mpt3sas driver version from 12.100.00.00 to 13.100.00.00
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 32580b5..aa918aa 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -73,8 +73,8 @@
>  #define MPT3SAS_DRIVER_NAME		"mpt3sas"
>  #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
>  #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
> -#define MPT3SAS_DRIVER_VERSION		"12.100.00.00"
> -#define MPT3SAS_MAJOR_VERSION		12
> +#define MPT3SAS_DRIVER_VERSION		"13.100.00.00"
> +#define MPT3SAS_MAJOR_VERSION		13
>  #define MPT3SAS_MINOR_VERSION		100
>  #define MPT3SAS_BUILD_VERSION		0
>  #define MPT3SAS_RELEASE_VERSION	00

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
