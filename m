From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: remove return at end of void function
Date: Thu, 13 Apr 2017 23:28:54 +0000
Message-ID: <DM5PR03MB249034710FBFFF705EEA480CA0020@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <20170316065957.13405-1-miguel.bernal.marin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170316065957.13405-1-miguel.bernal.marin@linux.intel.com>
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
To: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James
 E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Miguel Bernal Marin [mailto:miguel.bernal.marin@linux.intel.com]
> Sent: Thursday, March 16, 2017 12:00 AM
> To: KY Srinivasan <kys@microsoft.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
> devel@linuxdriverproject.org; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>
> Subject: [PATCH] scsi: storvsc: remove return at end of void function
> 
> storvsc_on_channel_callback is a void function and the return
> statement at the end is not useful.
> 
> Found with checkpatch.
> 
> Signed-off-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>

Reviewed-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/scsi/storvsc_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 3d70d1cf49a3..538f3e131275 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1191,8 +1191,6 @@ static void storvsc_on_channel_callback(void
> *context)
>  			break;
>  		}
>  	} while (1);
> -
> -	return;
>  }
> 
>  static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
> --
> 2.12.0
