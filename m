From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/1] arcmsr: Notify has sense data report
Date: Fri, 28 Nov 2014 12:17:52 +0300
Message-ID: <20141128091752.GH4911@mwanda>
References: <1417148444.16588.56.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417148444.16588.56.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 28, 2014 at 12:20:44PM +0800, Ching Huang wrote:
> This patch is relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr
> 

Put this information after the --- cut off line so that it is not
saved in the permanent git log.

> Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' if we have sense data.
> 
> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---

<--- Here.  Put it here.

> 
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2014-09-19 11:04:41.845100000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-11-28 10:54:30.000000000 +0800
> @@ -52,7 +52,7 @@ struct device_attribute;
>  	#define ARCMSR_MAX_FREECCB_NUM	320
>  #define ARCMSR_MAX_OUTSTANDING_CMD	255

regards,
dan carpenter
