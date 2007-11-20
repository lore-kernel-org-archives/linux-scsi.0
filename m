From: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: [PATCH 44/59] drivers/scsi: Add missing "space"
Date: Tue, 20 Nov 2007 10:39:44 +0000
Message-ID: <200711201039.45321.alistair@devzero.co.uk>
References: <1195523627-15389-1-git-send-email-joe@perches.com> <1195523627-15389-2-git-send-email-joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758446AbXKTKkl@vger.kernel.org>
In-Reply-To: <1195523627-15389-2-git-send-email-joe@perches.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ali Akcaagac <aliakc@web.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Jamie Lenehan <lenehan@twibble.org>, Oliver Neukum <oliver@neukum.name>, dc395x@twibble.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 20 November 2007 01:53:31 Joe Perches wrote:
> diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
> index 9e64b21..99403a6 100644
> --- a/drivers/scsi/NCR_D700.c
> +++ b/drivers/scsi/NCR_D700.c
> @@ -182,7 +182,7 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int
> siop, int irq,
>
>  	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
>  	if (!hostdata) {
> -		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host"
> +		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host "
>  		       "data, detatching\n", siop);
>  		return -ENOMEM;
>  	}

If you're going to sneak in unrelated spelling/grammar changes, you might as 
well do it unilaterally.

"detached" please.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
