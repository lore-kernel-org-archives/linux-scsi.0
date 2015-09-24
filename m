From: Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH 1/3] ibmvsci: make parameters max_id and max_channel
 read-only
Date: Thu, 24 Sep 2015 18:15:51 +0200
Message-ID: <560421B7.9040207@redhat.com>
References: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, dgibson@redhat.com, thuth@redhat.com, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

Ping ?

On 10/09/2015 11:23, Laurent Vivier wrote:
> The value of the parameter is never re-read by the driver,
> so a new value is ignored. Let know the user he
> can't modify it by removing writable attribute.
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
> I resend this patch as James was not cc'ed.
> 
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 6a41c36..3e76490 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -105,9 +105,9 @@ MODULE_AUTHOR("Dave Boutcher");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(IBMVSCSI_VERSION);
>  
> -module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_id, max_id, int, S_IRUGO);
>  MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
> -module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_channel, max_channel, int, S_IRUGO);
>  MODULE_PARM_DESC(max_channel, "Largest channel value");
>  module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
> 
