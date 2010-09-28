From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC v4]update broken web addresses in the kernel.
Date: Tue, 28 Sep 2010 12:59:17 +1000 (EST)
Message-ID: <alpine.OSX.2.00.1009271114330.275@localhost>
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.telegraphics.com.au ([204.15.192.19]:62054 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab0I1C7X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 22:59:23 -0400
In-Reply-To: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>
Content-ID: <alpine.OSX.2.00.1009271218431.396@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>, Dimitry Torokhov <dmitry.torokhov@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>


On Sun, 26 Sep 2010, Justin P. Mattock wrote:

> diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
> index 033e150..d7d9a78 100644
> --- a/drivers/char/apm-emulation.c
> +++ b/drivers/char/apm-emulation.c
> @@ -8,7 +8,7 @@
>   *   (APM) BIOS Interface Specification, Revision 1.2, February 1996.
>   *
>   * [This document is available from Microsoft at:
> - *    http://www.microsoft.com/hwdev/busbios/amp_12.htm]
> + *    http://www.microsoft.com/whdc/archive/amp_12.mspx]
>   */


Can we lose the brackets?


>  #include <linux/module.h>
>  #include <linux/poll.h>

> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 280c9b5..b2bd5fb 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -73,8 +73,8 @@ config EFI_PCDP
>  	  on how the driver discovers devices.
>  
>  	  You must also enable the appropriate drivers (serial, VGA, etc.)
> -
> -	  See <http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
> +	  See [DIG64_HCDPv20_042804.pdf] available from


What are the square brackets for?


> +	  <http://www.dig64.org/specifications/>
>  
>  config DELL_RBU
>  	tristate "BIOS update support for DELL systems via sysfs"

> diff --git a/drivers/firmware/pcdp.h b/drivers/firmware/pcdp.h
> index ce910d6..777d928 100644
> --- a/drivers/firmware/pcdp.h
> +++ b/drivers/firmware/pcdp.h
> @@ -1,8 +1,8 @@
>  /*
>   * Definitions for PCDP-defined console devices
>   *
> - * v1.0a: http://www.dig64.org/specifications/DIG64_HCDPv10a_01.pdf
> - * v2.0:  http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
> + * For [v1.0a: DIG64_HCDPv10a_01.pdf] [v2.0: DIG64_PCDPv20.pdf] 


For DIG64_HCDPv10a_01.pdf and DIG64_PCDPv20.pdf (v10.a and v2.0 resp.), 


> + * Please see <http://www.dig64.org/specifications/>


please see <http://www.dig64.org/specifications/>


>   *
>   * (c) Copyright 2002, 2004 Hewlett-Packard Development Company, L.P.
>   *	Khalid Aziz <khalid.aziz@hp.com>
> diff --git a/drivers/gpu/drm/README.drm b/drivers/gpu/drm/README.drm
> index b5b3327..bf29068 100644
> --- a/drivers/gpu/drm/README.drm
> +++ b/drivers/gpu/drm/README.drm
> @@ -28,7 +28,7 @@ ways:
>  Documentation on the DRI is available from:
>      http://dri.freedesktop.org/wiki/Documentation
>      http://sourceforge.net/project/showfiles.php?group_id=387
> -    http://dri.sourceforge.net/doc/
> +    http://dri.sourceforge.net/doc/DRIuserguide.html 


http://dri.freedesktop.org/wiki/Documentation


>  
>  For specific information about kernel-level support, see:
>  

> diff --git a/drivers/input/mouse/touchkit_ps2.c b/drivers/input/mouse/touchkit_ps2.c
> index 88121c5..e74753e 100644
> --- a/drivers/input/mouse/touchkit_ps2.c
> +++ b/drivers/input/mouse/touchkit_ps2.c
> @@ -22,7 +22,7 @@
>   * Based upon touchkitusb.c
>   *
>   * Vendor documentation is available in support section of:
> - * http://www.egalax.com.tw/
> + * http://home.eeti.com.tw/web20/drivers/Software%20Programming%20Guide_v2.0.pdf 


The comment text needs to be fixed also.


>   */
>  
>  #include <linux/kernel.h>

> diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
> index 472907d..08023f1 100644
> --- a/drivers/media/dvb/frontends/mt312.c
> +++ b/drivers/media/dvb/frontends/mt312.c
> @@ -20,8 +20,9 @@
>      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  
>      References:
> -    http://products.zarlink.com/product_profiles/MT312.htm
> -    http://products.zarlink.com/product_profiles/SL1935.htm
> +    http://www.zarlink.com/zarlink/hs/71.htm
> +    http://www.chipcatalog.com/Zarlink/MT312.htm
> +    http://www.chipcatalog.com/Zarlink/SL1935.htm


There's no need for links to chipcatalog.com. As I said in the previous 
review, we have search engines for finding datasheets. Besides, the old 
links are in the web archive (complete with PDFs) so there's no need to 
remove them.


>  */
>  
>  #include <linux/delay.h>
> diff --git a/drivers/media/dvb/frontends/mt312.h b/drivers/media/dvb/frontends/mt312.h
> index 29e3bb5..6d32e3f 100644
> --- a/drivers/media/dvb/frontends/mt312.h
> +++ b/drivers/media/dvb/frontends/mt312.h
> @@ -19,8 +19,9 @@
>      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  
>      References:
> -    http://products.zarlink.com/product_profiles/MT312.htm
> -    http://products.zarlink.com/product_profiles/SL1935.htm
> +    http://www.zarlink.com/zarlink/hs/71.htm
> +    http://www.chipcatalog.com/Zarlink/MT312.htm
> +    http://www.chipcatalog.com/Zarlink/SL1935.htm


Same here.


>  */
>  
>  #ifndef MT312_H

> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -2338,7 +2338,7 @@ EXPORT_SYMBOL(gspca_resume);
>  
>  /* auto gain and exposure algorithm based on the knee algorithm described here:
>     http://ytse.tricolour.net/docs/LowLightOptimization.html
> -
> +   http://81.209.78.62:8080/docs/LowLightOptimization.html


This is in the web archive.


>     Returns 0 if no changes were made, 1 if the gain and or exposure settings
>     where changed. */
>  int gspca_auto_gain_n_exposure(struct gspca_dev *gspca_dev, int avg_lum,

> index 701d942..142efd2 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -256,8 +256,7 @@ config MTD_DILNETPC
>  	depends on X86 && MTD_CONCAT && MTD_PARTITIONS && MTD_CFI_INTELEXT && BROKEN
>  	help
>  	  MTD map driver for SSV DIL/Net PC Boards "DNP" and "ADNP".
> -	  For details, see <http://www.ssv-embedded.de/ssv/pc104/p169.htm>
> - 	  and <http://www.ssv-embedded.de/ssv/pc104/p170.htm>
> +	  For details, see <http://www.dilnetpc.com/>


This is in the web archive. This removes information.


>  
>  config MTD_DILNETPC_BOOTSIZE
>  	hex "Size of DIL/Net PC flash boot partition"

> diff --git a/drivers/mtd/maps/dilnetpc.c b/drivers/mtd/maps/dilnetpc.c
> index 0713e3a..114899b 100644
> --- a/drivers/mtd/maps/dilnetpc.c
> +++ b/drivers/mtd/maps/dilnetpc.c
> @@ -19,8 +19,7 @@
>   * board: DNP/1486 and ADNP/1486. The DNP version has 2 megs of flash
>   * ROM (Intel 28F016S3) and 8 megs of DRAM, the ADNP version has 4 megs
>   * flash and 16 megs of RAM.
> - * For details, see http://www.ssv-embedded.de/ssv/pc104/p169.htm
> - * and http://www.ssv-embedded.de/ssv/pc104/p170.htm
> + * For details, see http://www.dilnetpc.com/ 


Same.


>   */
>  
>  #include <linux/module.h>

> index 49aac70..f4523cd 100644
> --- a/drivers/net/hamachi.c
> +++ b/drivers/net/hamachi.c
> @@ -20,9 +20,6 @@
>  
>  	Support and updates available at
>  	http://www.scyld.com/network/hamachi.html
> -	[link no longer provides useful info -jgarzik]
> -	or
> -	http://www.parl.clemson.edu/~keithu/hamachi.html


Why?


>  
>  */
>  

> index 6af6c83..0723c9f 100644
> --- a/drivers/staging/comedi/drivers/daqboard2000.c
> +++ b/drivers/staging/comedi/drivers/daqboard2000.c
> @@ -51,7 +51,7 @@ Configuration options:
>     for the card, and here are the findings so far.
>  
>     1. A good document that describes the PCI interface chip is found at:
> -      http://plx.plxtech.com/download/9080/databook/9080db-106.pdf
> +      [9080db-106.pdf] http://www.plxtech.com/products/io/pci9080 


Comments are supposed to be human readable text. Square brackets don't 
quote filenames by any convention I'm aware of (?)
I'd suggest:

      A good document that describes the PCI interface chip is 9080db-106.pdf
      available from http://www.plxtech.com/products/io/pci9080


>  
>     2. The initialization done so far is:
>          a. program the FPGA (windows code sans a lot of error messages)

> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 28ccab4..fc853a5 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -2,7 +2,7 @@
>   * linux/drivers/video/vga16.c -- VGA 16-color framebuffer driver
>   * 
>   * Copyright 1999 Ben Pfaff <pfaffben@debian.org> and Petr Vandrovec <VANDROVE@vc.cvut.cz>
> - * Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
> + * Based on VGA info at http://www.osdever.net/FreeVGA/home.htm 


The old link is in the web archive, you needn't remove it. Add the new one 
if you wish.


>   * Based on VESA framebuffer (c) 1998 Gerd Knorr <kraxel@goldbach.in-berlin.de>
>   *
>   * This file is subject to the terms and conditions of the GNU General
> diff --git a/drivers/video/vgastate.c b/drivers/video/vgastate.c
> index b91c466..f4043f8 100644
> --- a/drivers/video/vgastate.c
> +++ b/drivers/video/vgastate.c
> @@ -5,7 +5,7 @@
>   * 
>   * Copyright history from vga16fb.c:
>   *	Copyright 1999 Ben Pfaff and Petr Vandrovec
> - *	Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
> + *	Based on VGA info at http://www.osdever.net/FreeVGA/home.htm 


Same.


>   *	Based on VESA framebuffer (c) 1998 Gerd Knorr
>   *
>   * This file is subject to the terms and conditions of the GNU General
> diff --git a/include/linux/ixjuser.h b/include/linux/ixjuser.h
> index 88b4589..39ef699 100644
> --- a/include/linux/ixjuser.h
> +++ b/include/linux/ixjuser.h
> @@ -25,7 +25,7 @@
>   *                  Mike Preston, <mpreston@quicknet.net>
>   *
>   * More information about the hardware related to this driver can be found
> - * at our website:    http://www.quicknet.net
> + * at our website:   http://blemings.org/hugh/keyspan.html 


This appears to have been fat-fingered. No patch needed.


>   *
>   * Fixes:
>   *

> diff --git a/include/video/vga.h b/include/video/vga.h
> index b49a512..2b8691f 100644
> --- a/include/video/vga.h
> +++ b/include/video/vga.h
> @@ -5,7 +5,7 @@
>   * 
>   * Copyright history from vga16fb.c:
>   *	Copyright 1999 Ben Pfaff and Petr Vandrovec
> - *	Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
> + *	Based on VGA info at http://www.osdever.net/FreeVGA/home.htm 


See above.

Thanks.

Finn
