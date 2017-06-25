From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][V2][target-devel-next] tcmu: make array
 tcmu_attrib_attrs static const
Date: Sun, 25 Jun 2017 13:55:49 -0700
Message-ID: <1498424149.26123.36.camel@haakon3.risingtidesystems.com>
References: <20170613132909.28674-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170613132909.28674-1-colin.king@canonical.com>
Sender: target-devel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-06-13 at 14:29 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The array tcmu_attrib_attrs does not need to be in global scope, so make
> it static.
> 
> Cleans up sparse warning:
> "symbol 'tcmu_attrib_attrs' was not declared. Should it be static?"
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/target/target_core_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index afc1fd6bacaf..04fb3f720895 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1672,7 +1672,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
>  }
>  CONFIGFS_ATTR(tcmu_, emulate_write_cache);
>  
> -struct configfs_attribute *tcmu_attrib_attrs[] = {
> +static struct configfs_attribute *tcmu_attrib_attrs[] = {
>  	&tcmu_attr_cmd_time_out,
>  	&tcmu_attr_dev_path,
>  	&tcmu_attr_dev_size,

Applied.

Thanks Colin.
