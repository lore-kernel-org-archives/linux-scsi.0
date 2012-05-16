From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] target: Handle ATA_PASS_THROUGH_16 passthrough
Date: Wed, 16 May 2012 08:38:09 +0100
Message-ID: <1337153889.2985.5.camel@dabdike.int.hansenpartnership.com>
References: <1337146409.18429.11.camel@mengcong>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1337146409.18429.11.camel@mengcong>
Sender: target-devel-owner@vger.kernel.org
To: mc@linux.vnet.ibm.com
Cc: target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-16 at 13:33 +0800, mengcong wrote:
> The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
> with a SATA CD-ROM. This patch adds support to it so that PSCSI 
> CD-ROM passthrough works with the cdrecord.
> 
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
[...]
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index f34a5a8..f6dcd25 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -116,6 +116,7 @@ struct scsi_cmnd;
>  #define PERSISTENT_RESERVE_IN 0x5e
>  #define PERSISTENT_RESERVE_OUT 0x5f
>  #define VARIABLE_LENGTH_CMD   0x7f
> +#define ATA_PASS_THROUGH_16   0x85
>  #define REPORT_LUNS           0xa0
>  #define SECURITY_PROTOCOL_IN  0xa2
>  #define MAINTENANCE_IN        0xa3

We already have this: they're called ATA_16 (and ATA_12) in this very
file.

James
