From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/4] cciss 2.4: adds 2 ioctls for ia64 based systems
Date: Mon, 15 Aug 2005 16:32:53 -0500
Message-ID: <1124141573.5089.55.camel@mulgrave>
References: <20050815212224.GD12760@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14032 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964983AbVHOVeJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:34:09 -0400
In-Reply-To: <20050815212224.GD12760@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: marcelo.tosatti@cyclades.com, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-15 at 16:22 -0500, mikem wrote:
> +#ifdef CONFIG_IA64
> +        case BLKGETLASTSECT:
> +        case BLKSETLASTSECT:
> +#endif
>  		return blk_ioctl(inode->i_rdev, cmd, arg);

What makes these two ioctls IA64 specific?  I think they're completely
general in 2.4, so there's no need for the #ifdef.

James


