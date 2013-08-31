From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next] target: remove unused including <linux/version.h>
Date: Fri, 30 Aug 2013 20:25:07 -0700
Message-ID: <1377919507.32763.313.camel@haakon3.risingtidesystems.com>
References: <CAPgLHd99FTjnSBbeRnVMxEYKPisJ5qdzm0=a8ZKeyF7m-=XkSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd99FTjnSBbeRnVMxEYKPisJ5qdzm0=a8ZKeyF7m-=XkSA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-08-29 at 08:00 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Applied to target-pending/for-next.

Thanks Wei!

--nab

>  drivers/target/target_core_xcopy.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index 7e12286..fb4b0c5 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -21,7 +21,6 @@
>   *
>   ******************************************************************************/
>  
> -#include <linux/version.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/list.h>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
