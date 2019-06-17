From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Mon, 17 Jun 2019 14:11:06 -0700
Message-ID: <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 6/12/19 6:59 AM, Marc Gonzalez wrote:
> According to the option's help message, SCSI_PROC_FS has been
> superseded for ~15 years. Don't select it by default anymore.
> 
> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
> ---
>   drivers/scsi/Kconfig | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 73bce9b6d037..8c95e9ad6470 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -54,14 +54,11 @@ config SCSI_NETLINK
>   config SCSI_PROC_FS
>   	bool "legacy /proc/scsi/ support"
>   	depends on SCSI && PROC_FS
> -	default y
>   	---help---
>   	  This option enables support for the various files in
>   	  /proc/scsi.  In Linux 2.6 this has been superseded by
>   	  files in sysfs but many legacy applications rely on this.
>   
> -	  If unsure say Y.
> -
>   comment "SCSI support type (disk, tape, CD-ROM)"
>   	depends on SCSI

Hi Doug,

If I run grep "/proc/scsi" over the sg3_utils source code then grep 
reports 38 matches for that string. Does sg3_utils break with 
SCSI_PROC_FS=n?

Thanks,

Bart.
