From: Michael Christie <mchristi@redhat.com>
Subject: Re: [PATCH] tcmu: Fix trailing semicolon
Date: Tue, 16 Jan 2018 10:25:16 -0600
Message-ID: <f188423f-8d53-ffe8-7d85-48424e15411b@redhat.com>
References: <20180116153432.17927-1-luisbg@kernel.org>
Reply-To: mchristi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20180116153432.17927-1-luisbg@kernel.org>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@kernel.org>, linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/16/2018 09:34 AM, Luis de Bethencourt wrote:
> The trailing semicolon is an empty statement that does no operation.
> It is completely stripped out by the compiler. Removing it since it doesn't do
> anything.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
> ---
> 
> Hi,
> 
> After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
> suggested I fix it treewide [0].
> 
> Best regards 
> Luis
> 
> 
> [0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
> [1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html
> 
>  drivers/target/target_core_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 60c8a87b7a88..f6164d294fb3 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1564,7 +1564,7 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
>  
>  	wake_up_all(&udev->nl_cmd_wq);
>  
> -	return ret;;
> +	return ret;
>  }
>  
>  static int tcmu_netlink_event(struct tcmu_dev *udev, enum tcmu_genl_cmd cmd,
> 


Acked-by: Mike Christie <mchristi@redhat.com>
