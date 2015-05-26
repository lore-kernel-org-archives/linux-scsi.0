From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH target] target: se_dev_check_wce() can be static
Date: Tue, 26 May 2015 11:02:08 +0200
Message-ID: <55643690.8040309@sandisk.com>
References: <201505261605.Y1XY0zLc%fengguang.wu@intel.com>
 <20150526081320.GA111779@lkp-sb04>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150526081320.GA111779@lkp-sb04>
Sender: target-devel-owner@vger.kernel.org
To: Wu Fengguang <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>
Cc: kbuild-all@01.org, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/26/15 10:13, kbuild test robot wrote:
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>   target_core_device.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 2321884..1d309ad 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -649,7 +649,7 @@ static u32 se_dev_align_max_sectors(u32 max_sectors, u32 block_size)
>   	return aligned_max_sectors;
>   }
>
> -bool se_dev_check_wce(struct se_device *dev)
> +static bool se_dev_check_wce(struct se_device *dev)
>   {
>   	bool wce = false;
>

Since patch "target: fix DPO and FUA bit checks" removed the last user 
of this function, please remove this function completely instead of 
declaring it static.

Thanks,

Bart.
