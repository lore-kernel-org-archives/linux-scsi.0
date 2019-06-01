From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 3/3] drivers: hwmon: i5k_amb: remove unnecessary #ifdef
 MODULE
Date: Sat, 1 Jun 2019 15:49:46 -0700
Message-ID: <20190601224946.GA6483@roeck-us.net>
References: <1559397700-15585-1-git-send-email-info@metux.net>
 <1559397700-15585-4-git-send-email-info@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1559397700-15585-4-git-send-email-info@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 01, 2019 at 04:01:40PM +0200, Enrico Weigelt, metux IT consult wrote:
> The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
> so the extra check here is not necessary.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  drivers/hwmon/i5k_amb.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
> index b09c39a..b674c2f 100644
> --- a/drivers/hwmon/i5k_amb.c
> +++ b/drivers/hwmon/i5k_amb.c
> @@ -482,14 +482,12 @@ static int i5k_channel_probe(u16 *amb_present, unsigned long dev_id)
>  	{ 0, 0 }
>  };
>  
> -#ifdef MODULE
>  static const struct pci_device_id i5k_amb_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
> -#endif
>  

I'd rather know what this table is used for in the first place.

Guenter

>  static int i5k_amb_probe(struct platform_device *pdev)
>  {
> -- 
> 1.9.1
> 
