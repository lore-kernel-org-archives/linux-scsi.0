From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [2.6 patch] ide-scsi.c: make 2 functions static (fwd) (fwd)
Date: Sat, 8 Jan 2005 23:09:26 +0100
Message-ID: <58cb370e05010814097c8ae8d9@mail.gmail.com>
References: <20050108214008.GT14108@stusta.de>
Reply-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.205]:57623 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261977AbVAHWJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jan 2005 17:09:34 -0500
Received: by wproxy.gmail.com with SMTP id 67so393185wri
        for <linux-scsi@vger.kernel.org>; Sat, 08 Jan 2005 14:09:27 -0800 (PST)
In-Reply-To: <20050108214008.GT14108@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 8 Jan 2005 22:40:08 +0100, Adrian Bunk <bunk@stusta.de> wrote:
> The patch forwarded below still applies and compiles against 2.6.10-mm2.

hmm, latest IDE update (in -bk) also makes these functions static

> --- linux-2.6.10-rc1-mm5-full/drivers/scsi/ide-scsi.c.old       2004-11-13 21:51:26.000000000 +0100
> +++ linux-2.6.10-rc1-mm5-full/drivers/scsi/ide-scsi.c   2004-11-13 21:51:41.000000000 +0100
> @@ -301,7 +301,7 @@
>         return ide_do_drive_cmd(drive, rq, ide_preempt);
>  }
> 
> -ide_startstop_t idescsi_atapi_error (ide_drive_t *drive, const char *msg, byte stat)
> +static ide_startstop_t idescsi_atapi_error (ide_drive_t *drive, const char *msg, byte stat)
>  {
>         struct request *rq;
>         byte err;
> @@ -327,7 +327,7 @@
>         return ide_stopped;
>  }
> 
> -ide_startstop_t idescsi_atapi_abort (ide_drive_t *drive, const char *msg)
> +static ide_startstop_t idescsi_atapi_abort (ide_drive_t *drive, const char *msg)
>  {
>         struct request *rq;
>
