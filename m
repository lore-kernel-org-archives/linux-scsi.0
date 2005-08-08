From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH C&C] gdth: remove GDTIOCTL_OSVERS
Date: Mon, 8 Aug 2005 03:40:27 +0200
Message-ID: <20050808014027.GI4006@stusta.de>
References: <20050807222829.GA20558@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:27656 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1753224AbVHHBk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2005 21:40:29 -0400
Content-Disposition: inline
In-Reply-To: <20050807222829.GA20558@mipter.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Achim Leubner <achim_leubner@adaptec.com>

On Mon, Aug 08, 2005 at 02:28:29AM +0400, Alexey Dobriyan wrote:

>...
> --- linux-vanilla/drivers/scsi/gdth.c	2005-08-08 02:16:47.000000000 +0400
> +++ linux-gdth/drivers/scsi/gdth.c	2005-08-08 02:19:59.000000000 +0400
> @@ -5411,18 +5411,6 @@ static int gdth_ioctl(struct inode *inod
>                  return -EFAULT;
>          break;
>        }
> -      
> -      case GDTIOCTL_OSVERS:
> -      { 
> -        gdth_ioctl_osvers osv; 
> -
> -        osv.version = (unchar)(LINUX_VERSION_CODE >> 16);
> -        osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
> -        osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
> -        if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
> -                return -EFAULT;
> -        break;
> -      }
>...

Not that I'd like this, but you know that this is a userspace-visible 
change?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

