From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH] scsi: esas2r: Fix format string type mistakes
Date: Sat, 17 Dec 2016 09:34:57 +0100
Message-ID: <92483e45-c522-f7d5-e10d-9693d2675697@acm.org>
References: <20161216215030.GA96735@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161216215030.GA96735@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Bradley Grove <linuxdrivers@attotech.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Emese Revfy <re.emese@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/16/2016 10:50 PM, Kees Cook wrote:
> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> index 3e8483410f61..34976f9a1a10 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> @@ -1301,7 +1301,7 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
>  	ioctl = kzalloc(sizeof(struct atto_express_ioctl), GFP_KERNEL);
>  	if (ioctl == NULL) {
>  		esas2r_log(ESAS2R_LOG_WARN,
> -			   "ioctl_handler kzalloc failed for %d bytes",
> +			   "ioctl_handler kzalloc failed for %lu bytes",
>  			   sizeof(struct atto_express_ioctl));
>  		return -ENOMEM;
>  	}

Please use %zu to format size_t.

Bart.
