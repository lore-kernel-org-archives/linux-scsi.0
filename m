From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_debug: virtual_gb ignores sector_size
Date: Sun, 02 May 2010 11:44:34 -0400
Message-ID: <1272815074.23834.40.camel@mulgrave.site>
References: <4BD419BF.4040109@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab0EBPoj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 May 2010 11:44:39 -0400
In-Reply-To: <4BD419BF.4040109@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Sun, 2010-04-25 at 12:30 +0200, Douglas Gilbert wrote:
> --- linux/drivers/scsi/scsi_debug.c     2010-03-24 20:13:03.000000000
> +0100
> +++ linux/drivers/scsi/scsi_debug.c2633mqnu2ss  2010-04-25
> 12:03:50.000000000 +0200
> @@ -58,7 +58,7 @@
>  #include "scsi_logging.h"
>  
>  #define SCSI_DEBUG_VERSION "1.82"
> -static const char * scsi_debug_version_date = "20100324";
> +static const char * scsi_debug_version_date = "20100425";

I got a rejection here ... presumably because there's a missing patch
somewhere along the way.

I've got to say, I don't think bumping the date with every patch is a
good idea ... apart from the patch ordering problems, it will give
rejections every time I try to send a patch to stable (which I'm doing
with this).

James


