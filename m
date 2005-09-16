From: Jens Axboe <axboe@suse.de>
Subject: Re: cxscan-user.patch
Date: Fri, 16 Sep 2005 13:49:15 +0200
Message-ID: <20050916114914.GD2862@suse.de>
References: <200509160736.22007.T.Maguin@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:48664 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S964861AbVIPLtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 07:49:03 -0400
Content-Disposition: inline
In-Reply-To: <200509160736.22007.T.Maguin@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Maguin <T.Maguin@web.de>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org

On Fri, Sep 16 2005, Thomas Maguin wrote:
> please add this, which which allows normal users to make a c1-, c2- and 
> cu-scan (so called cxscan) with readcd on cxscan-capable cd/dvd-writers. 
> 
> 
> --- drivers/block/old-scsi_ioctl.c      2005-09-16 07:06:37.000000000 +0200
> +++ drivers/block/scsi_ioctl.c  2005-09-13 12:06:48.000000000 +0200
> @@ -167,6 +167,7 @@ static int verify_command(struct file *f
>                 safe_for_write(WRITE_VERIFY_12),
>                 safe_for_write(WRITE_16),
>                 safe_for_write(WRITE_LONG),
> +              safe_for_write(WRITE_LONG_2),
>                 safe_for_write(ERASE),
>                 safe_for_write(GPCMD_MODE_SELECT_10),
>                 safe_for_write(MODE_SELECT),

The patch is safe, however your mailer mangled the tabs. Can you resend
as an attachment, please?

-- 
Jens Axboe

