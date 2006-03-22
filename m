From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [GIT PATCH] pending SCSI updates for post 2.6.16
Date: Wed, 22 Mar 2006 10:57:12 -0800
Message-ID: <20060322105712.a556008c.rdunlap@xenotime.net>
References: <1142956795.4377.19.camel@mulgrave.il.steeleye.com>
	<20060322083647.cc0ccdd4.rdunlap@xenotime.net>
	<Pine.LNX.4.64.0603221048210.26286@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:37817 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932331AbWCVSzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 13:55:04 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 10:55:01 -0800
In-Reply-To: <Pine.LNX.4.64.0603221048210.26286@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 22 Mar 2006 10:49:52 -0800 (PST) Linus Torvalds wrote:

> 
> 
> On Wed, 22 Mar 2006, Randy.Dunlap wrote:
> > 
> > Can we get a SCSI_DEBUG link order change (or force it to not
> > built-in)?
> 
> Just something like this? Or did you have something else in mind?
> 
> (Pls test and ack).

Yes, that's what I sent to Andrew and James.
Already tested.
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> 		Linus
> 
> ----
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 15dc2e0..4f907da 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -117,7 +117,6 @@ obj-$(CONFIG_SCSI_PPA)		+= ppa.o
>  obj-$(CONFIG_SCSI_IMM)		+= imm.o
>  obj-$(CONFIG_JAZZ_ESP)		+= NCR53C9x.o	jazz_esp.o
>  obj-$(CONFIG_SUN3X_ESP)		+= NCR53C9x.o	sun3x_esp.o
> -obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
>  obj-$(CONFIG_SCSI_FCAL)		+= fcal.o
>  obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
>  obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
> @@ -148,6 +147,8 @@ obj-$(CONFIG_BLK_DEV_SR)	+= sr_mod.o
>  obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
>  obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
>  
> +obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
> +
>  scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
>  				   scsicam.o scsi_error.o scsi_lib.o \
>  				   scsi_scan.o scsi_sysfs.o \
> -

---
~Randy
