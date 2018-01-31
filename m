From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Increase cmd_per_lun for higher speed
 devices
Date: Wed, 31 Jan 2018 18:34:23 +0000
Message-ID: <DM5PR2101MB088845B6127BBC3BC0B36F4CA0FB0@DM5PR2101MB0888.namprd21.prod.outlook.com>
References: <1516834132-26273-1-git-send-email-mikelley@ntdev.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1516834132-26273-1-git-send-email-mikelley@ntdev.microsoft.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, Stephen
 Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (EOSG)
> Sent: Wednesday, January 24, 2018 2:50 PM
> To: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; martin.petersen@oracle.com; Long Li
> <longli@microsoft.com>; jejb@linux.vnet.ibm.com;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Cc: Michael Kelley (EOSG) <Michael.H.Kelley@microsoft.com>
> Subject: [PATCH 1/1] scsi: storvsc: Increase cmd_per_lun for higher speed
> devices
> 
> Increase cmd_per_lun to allow more I/Os in progress per device,
> particularly for NVMe's.  The Hyper-V host side can handle the
> higher count with no issues.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>

Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>

Thanks,

K. Y
> ---
>  drivers/scsi/storvsc_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index f3264c4..6205107 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1657,7 +1657,7 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  	.eh_timed_out =		storvsc_eh_timed_out,
>  	.slave_alloc =		storvsc_device_alloc,
>  	.slave_configure =	storvsc_device_configure,
> -	.cmd_per_lun =		255,
> +	.cmd_per_lun =		2048,
>  	.this_id =		-1,
>  	.use_clustering =	ENABLE_CLUSTERING,
>  	/* Make sure we dont get a sg segment crosses a page boundary */
> --
> 1.8.3.1
