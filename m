From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -tip] libfc: add crc32 dependency
Date: Sun, 22 Feb 2009 08:55:05 -0600
Message-ID: <1235314505.4531.11.camel@localhost.localdomain>
References: <20090222015606.629487d8.erik@kryo.se>
	 <20090222020239.59ee6b23.erik@kryo.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57730 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbZBVOzI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 09:55:08 -0500
In-Reply-To: <20090222020239.59ee6b23.erik@kryo.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erik Ekman <erik@kryo.se>
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-02-22 at 02:02 +0100, Erik Ekman wrote:
> drivers/scsi/libfc/fc_fcp.c needs CRC32 to build.
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>
> ---
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 256c7be..bdfa6f2 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
>  config LIBFC
>  	tristate "LibFC module"
>  	select SCSI_FC_ATTRS
> +	select CRC32
>  	---help---

Already got this, here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=bd21ed64ec1950f32706a54ecdbe93901fbc03a9

However, I think scis-misc is coming up on a point where it needs
rebasing, so I'll move it across to rc-fixes, since it's a minor fix but
it keeps coming up in the randconfig testing.

James


