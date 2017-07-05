From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] target: make device_mutex and device_list static
Date: Wed, 5 Jul 2017 13:15:32 -0500
Message-ID: <595D2CC4.3090303@redhat.com>
References: <20170704084419.10800-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170704084419.10800-1-colin.king@canonical.com>
Sender: target-devel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/04/2017 03:44 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables device_mutex and device_list static are local to the source,
> so make them static.
> 
> Cleans up sparse warnings:
> "symbol 'device_list' was not declared. Should it be static?"
> "symbol 'device_mutex' was not declared. Should it be static?"
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/target/target_core_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 3ae8fbf01bdf..bbcef3bc66c8 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -49,8 +49,8 @@
>  #include "target_core_pr.h"
>  #include "target_core_ua.h"
>  
> -DEFINE_MUTEX(device_mutex);
> -LIST_HEAD(device_list);
> +static DEFINE_MUTEX(device_mutex);
> +static LIST_HEAD(device_list);
>  static DEFINE_IDR(devices_idr);
>  
>  static struct se_hba *lun0_hba;
> 

My fault. Thanks.

Reviewed-by: Mike Christie <mchristi@redhat.com>
