From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC 1/3 v3]update web addresses in the kernel
Date: Sun, 26 Sep 2010 19:43:03 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1009251114270.10989@nippy.intranet>
References: <1285373337-10945-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285373337-10945-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>, Dimitry Torokhov <dmitry.torokhov@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Hi Justin,

Some comments on your latest patch follow.


On Fri, 24 Sep 2010, Justin P. Mattock wrote:

> --- a/drivers/ata/pata_it821x.c
> +++ b/drivers/ata/pata_it821x.c
> @@ -16,7 +16,7 @@
>   *  Based in part on the ITE vendor provided SCSI driver.
>   *
>   *  Documentation available from
> - * 	http://www.ite.com.tw/pc/IT8212F_V04.pdf
> + * 	http://www.ite.com.tw/EN/products_more.aspx?CategoryID=3&ID=5,91	

The existence of the pdf could be useful information when one needs to 
locate a copy. I think the filename needs to be retained.



>   *  Some other documents are NDA.
>   *
>   *  The ITE8212 isn't exactly a standard IDE controller. It has two

> diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
> index a2fa1fe..adb6574 100644
> --- a/drivers/edac/i82443bxgx_edac.c
> +++ b/drivers/edac/i82443bxgx_edac.c
> @@ -12,7 +12,7 @@
>   * 440GX fix by Jason Uhlenkott <juhlenko@akamai.com>.
>   *
>   * Written with reference to 82443BX Host Bridge Datasheet:
> - * http://www.intel.com/design/chipsets/440/documentation.htm
> + * http://ark.intel.com/Product.aspx?id=27151 

That's the wrong document. It refers to processor number 440 not the *440 
chipsets.

Google offers this link:
http://download.intel.com/design/chipsets/datashts/29063301.pdf


>   * references to this document given in [].
>   *
>   * This module doesn't support the 440LX, but it may be possible to
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 280c9b5..aec5691 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -74,7 +74,8 @@ config EFI_PCDP
>  
>  	  You must also enable the appropriate drivers (serial, VGA, etc.)
>  
> -	  See <http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
> +	  See DIG64_HCDPv20_042804.pdf available from
> +	  <http://www.dig64.org/specifications/> 

Can you do the same for IT8212F_V04.pdf above?


>  
>  config DELL_RBU
>  	tristate "BIOS update support for DELL systems via sysfs"

> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> index 949326d..f3e9d45 100644
> --- a/drivers/gpu/drm/drm_modes.c
> +++ b/drivers/gpu/drm/drm_modes.c
> @@ -76,7 +76,7 @@ EXPORT_SYMBOL(drm_mode_debug_printmodeline);
>   * according to the hdisplay, vdisplay, vrefresh.
>   * It is based from the VESA(TM) Coordinated Video Timing Generator by
>   * Graham Loveridge April 9, 2003 available at
> - * http://www.vesa.org/public/CVT/CVTd6r1.xls
> + * http://www.elo.utfsm.cl/~elo212/docs/CVTd6r1.xls
>   *
>   * And it is copied from xf86CVTmode in xserver/hw/xfree86/modes/xf86cvt.c.
>   * What I have done is to translate it by using integer calculation.

>  /*
>   * Keymap for ATCom AU-100
> - * http://www.atcom.cn/En_products_AU100.html
> + * http://www.atcom.cn/products.html 
>   * http://www.packetizer.com/products/au100/
>   * http://www.voip-info.org/wiki/view/AU-100
>   *
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index c714ca2..5e98430 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -27,10 +27,7 @@ config MOUSE_PS2
>  
>  	  Synaptics, ALPS or Elantech TouchPad users might be interested
>  	  in a specialized Xorg/XFree86 driver at:
> -		<http://w1.894.telia.com/~u89404340/touchpad/index.html>
> -	  and a new version of GPM at:
> -		<http://www.geocities.com/dt_or/gpm/gpm.html>


This one is in the web archive so it might be a good idea to keep the URL?


> -	  to take advantage of the advanced features of the touchpad.
> +		<http://xorg.freedesktop.org/archive/individual/driver/>
>  
>  	  If unsure, say Y.
>  

> diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
> index abd64e8..43eea3a 100644
> --- a/drivers/media/video/cx23885/cx23885-417.c
> +++ b/drivers/media/video/cx23885/cx23885-417.c
> @@ -7,7 +7,7 @@
>   *    (c) 2008 Steven Toth <stoth@linuxtv.org>
>   *      - CX23885/7/8 support
>   *
> - *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
> + *  Includes parts from the ivtv driver(http://sourceforge.net/projects/ivtv/),

How about,

+ *  Includes parts from the ivtv driver <http://sourceforge.net/projects/ivtv/>


>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
> index e46e1ce..821766e 100644
> --- a/drivers/media/video/cx88/cx88-blackbird.c
> +++ b/drivers/media/video/cx88/cx88-blackbird.c
> @@ -9,7 +9,7 @@
>   *    (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
>   *        - video_ioctl2 conversion
>   *
> - *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
> + *  Includes parts from the ivtv driver(http://sourceforge.net/projects/ivtv/),


Same here.


>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by

> diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
> index 4d6a64c..8e201b8 100644
> --- a/drivers/mtd/ftl.c
> +++ b/drivers/mtd/ftl.c
> @@ -51,7 +51,7 @@
>  
>      Use of the FTL format for non-PCMCIA applications may be an
>      infringement of these patents.  For additional information,
> -    contact M-Systems (http://www.m-sys.com) directly.
> +    contact M-Systems directly. [M-Systems since acquired by Sandisk.].


An entire sentence within parentheses is usually written like this:

+    contact M-Systems directly. [M-Systems since acquired by Sandisk.]


>  
>  ======================================================================*/
>  #include <linux/mtd/blktrans.h>

> diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
> index db1dfc5..48894dc 100644
> --- a/drivers/mtd/nand/cafe_nand.c
> +++ b/drivers/mtd/nand/cafe_nand.c
> @@ -2,7 +2,7 @@
>   * Driver for One Laptop Per Child ?CAF?? controller, aka Marvell 88ALP01
>   *
>   * The data sheet for this device can be found at:
> - *    http://www.marvell.com/products/pcconn/88ALP01.jsp
> + *    http://www.marvell.com/products/pc_connectivity/88alp01/ 

No, it isn't there any longer. It is here though:

http://wiki.laptop.org/go/Datasheets


>   *
>   * Copyright ? 2006 Red Hat, Inc.
>   * Copyright ? 2006 David Woodhouse <dwmw2@infradead.org>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 2cc81a5..99fb1f6 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig

> @@ -1541,7 +1541,7 @@ config FEALNX
>  	help
>  	  Say Y here to support the Mysom MTD-800 family of PCI-based Ethernet
>  	  cards. Specifications and data at
> -	  <http://www.myson.com.hk/mtd/datasheet/>.
> +	  <http://www.datasheetarchive.com/datasheet-pdf/022/DSA00384882.html>.

Links to the datasheetarchive are probably redundant. We have search 
engines for that. Also, there are three devices supported by this driver 
and your link is only good for one of them, so searching is likely to be 
needed anyway.

The site is actually http://www.myson.com.tw/ but there's no product 
information there any longer. I'd suggest this (also correcting the typo):

-        Say Y here to support the Mysom MTD-800 family of PCI-based Ethernet
-        cards. Specifications and data at
-        <http://www.myson.com.hk/mtd/datasheet/>.
+        Say Y here to support the Myson MTD-800 family of PCI-based Ethernet
+        cards. <http://www.myson.com.tw/>



>  
>  config NATSEMI
>  	tristate "National Semiconductor DP8381x series PCI Ethernet support"

>  http://www.national.com/pf/DP/DP83840A.html
>  

> index c683f77..230158b 100644
> --- a/drivers/net/pcmcia/3c574_cs.c
> +++ b/drivers/net/pcmcia/3c574_cs.c
> @@ -62,7 +62,7 @@ invalid ramWidth is Very Bad.
>  V. References
>  
>  http://www.scyld.com/expert/NWay.html
> -http://www.national.com/pf/DP/DP83840.html
> +http://www.national.com/opf/DP/DP83840A.html#Overview

No need for the "#Overview" anchor.


>  
>  Thanks to Terry Murphy of 3Com for providing development information for
>  earlier 3Com products.

> diff --git a/drivers/net/sis900.h b/drivers/net/sis900.h
> index 150511a..45f5323 100644
> --- a/drivers/net/sis900.h
> +++ b/drivers/net/sis900.h
> @@ -7,7 +7,7 @@
>   *	preliminary Rev. 1.0 Nov. 10, 1998
>   *   SiS 7014 Single Chip 100BASE-TX/10BASE-T Physical Layer Solution,
>   *	preliminary Rev. 1.0 Jan. 18, 1998
> - *   http://www.sis.com.tw/support/databook.htm
> + *   http://www.sis.com/elibrary/elibrary_index00.htm 

The old URL is in the web archive, complete with the relevant datasheets.
But if I follow your URL, I get nothing useful.


>   */
>  
>  /*

> index b0342a5..024fccc 100644
> --- a/drivers/net/wireless/p54/Kconfig
> +++ b/drivers/net/wireless/p54/Kconfig
> @@ -8,7 +8,7 @@ config P54_COMMON
>  	  also need to be enabled in order to support any devices.
>  
>  	  These devices require softmac firmware which can be found at
> -	  http://prism54.org/
> +	  http://wireless.kernel.org/en/users/Drivers/p54 


The convention seems to be angle brackets around URLS in Kconfig.


>  
>  	  If you choose to build a module, it'll be called p54common.
>  
> @@ -20,7 +20,7 @@ config P54_USB
>  	  This driver is for USB isl38xx based wireless cards.
>  
>  	  These devices require softmac firmware which can be found at
> -	  http://prism54.org/
> +	  http://wireless.kernel.org/en/users/Drivers/p54 


Same.

>  
>  	  If you choose to build a module, it'll be called p54usb.
>  
> @@ -34,7 +34,7 @@ config P54_PCI
>  	  supported by the fullmac driver/firmware.
>  
>  	  This driver requires softmac firmware which can be found at
> -	  http://prism54.org/
> +	  http://wireless.kernel.org/en/users/Drivers/p54
>  
>  	  If you choose to build a module, it'll be called p54pci.
>  

Same.


> @@ -205,7 +205,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 	PCI_DEVICE_ID_INTEL_82439TX, 	quir
>  /*
>   *	VIA Apollo KT133 needs PCI latency patch
>   *	Made according to a windows driver based patch by George E. Breese
> - *	see PCI Latency Adjust on http://www.viahardware.com/download/viatweak.shtm
> + *	see PCI Latency Adjust on http://www.georgebreese.com/net/software/#PCI 


The old link is in the web archive, but yours is also useful.
Can't we have both?


>   *      Also see http://www.au-ja.org/review-kt133a-1-en.phtml for
>   *      the info on which Mr Breese based his work.
>   *

> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -949,7 +949,7 @@ config SCSI_IPS
>  	depends on PCI && SCSI
>  	---help---
>  	  This is support for the IBM ServeRAID hardware RAID controllers.
> -	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
> +	  See <http://www-947.ibm.com/support/entry/portal/docdisplay?brand=5000008&lndocid=SERV-RAID>

The old URL is in the web archive, complete with downloads. Please keep
it around as there may be no other way to find that material.


>  	  for more information.  If this driver does not work correctly
>  	  without modification please contact the author by email at
>  	  <ipslinux@adaptec.com>.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b02bdc6..705f541 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -555,8 +555,8 @@ static int inquiry_evpd_84(unsigned char * arr)
>  static int inquiry_evpd_85(unsigned char * arr)
>  {
>  	int num = 0;
> -	const char * na1 = "https://www.kernel.org/config";
> -	const char * na2 = "http://www.kernel.org/log";
> +	const char * na1 = "https://www.kernel.org";
> +	const char * na2 = "http://www.kernel.org";


Why? These are deliberately fake, and deliberately different.

BTW, a URL like http://www.kernel.org/ is supposed to have the slash at 
the end.


>  	int plen, olen;
>  
>  	arr[num++] = 0x1;	/* lu, storage config */
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 24110f6..41a3ed8 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -924,7 +924,7 @@ static int broken_efr(struct uart_8250_port *up)
>  	/*
>  	 * Exar ST16C2550 "A2" devices incorrectly detect as
>  	 * having an EFR, and report an ID of 0x0201.  See
> -	 * http://www.exar.com/info.php?pdf=dan180_oct2004.pdf
> +	 * http://linux.derkeiler.com/pdf/Mailing-Lists/Kernel/2004-11/4812.pdf 


This link is better since it has the entire thread:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-11/4812.html


>  	 */
>  	if (autoconfig_read_divisor_id(up) == 0x0201 && size_fifo(up) == 16)
>  		return 1;

> diff --git a/drivers/staging/asus_oled/README b/drivers/staging/asus_oled/README
> index 96b9717..b6f77c5 100644
> --- a/drivers/staging/asus_oled/README
> +++ b/drivers/staging/asus_oled/README
> @@ -2,7 +2,7 @@
>      Driver for Asus OLED display present in some Asus laptops.
>  
>      The code of this driver is based on 'asusoled' program taken from
> -    https://launchpad.net/asusoled/. I just wanted to have a simple
> +    http://lapsus.berlios.de/asus_oled.html. I just wanted to have a simple


The trailing "." isn't helping. Put it inside angle brackets.


>      kernel driver for controlling this device, but I didn't know how
>      to do that. Now I know ;) Also, that program can not be used
>      with usbhid loaded, which means no USB mouse/keyboard while
> diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
> index 5b279fb..1cb2116 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -24,7 +24,7 @@
>   *
>   *
>   *  Asus OLED support is based on asusoled program taken from
> - *  https://launchpad.net/asusoled/.
> + *  http://lapsus.berlios.de/asus_oled.html.

Same here.


>   *
>   *
>   */
> diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
> index ced346a..e4cf861 100644
> --- a/drivers/staging/comedi/drivers/cb_pcimdas.c
> +++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
> @@ -37,7 +37,7 @@ Configuration Options:
>  Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
>  Only supports DIO, AO and simple AI in it's present form.
>  No interrupts, multi channel or FIFO AI, although the card looks like it could support this.
> -See http://www.measurementcomputing.com/PDFManuals/pcim-das1602_16.pdf for more details.
> +See http://www.mccdaq.com/specs.aspx for more details.

This loses information. Your patch removes the filename. For example, 
Googling that filename gives this:

http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf


>  */
>  
>  #include "../comedidev.h"
> diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
> index 6af6c83..ba5a980 100644
> --- a/drivers/staging/comedi/drivers/daqboard2000.c
> +++ b/drivers/staging/comedi/drivers/daqboard2000.c
> @@ -51,7 +51,7 @@ Configuration options:
>     for the card, and here are the findings so far.
>  
>     1. A good document that describes the PCI interface chip is found at:
> -      http://plx.plxtech.com/download/9080/databook/9080db-106.pdf
> +      http://www.plxtech.com/products/io/pci9080 


Again, googling "9080db-106.pdf" locates the pdf, but it isn't available 
without registration using the link you provided. I suggest that you at 
least keep the filename (see above).

>  
>     2. The initialization done so far is:
>          a. program the FPGA (windows code sans a lot of error messages)
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index bd16f91..a2691db 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -34,7 +34,7 @@
>  	   340747b.pdf  AT-MIO E series Register Level Programmer Manual
>  	   341079b.pdf  PCI E Series RLPM
>  	   340934b.pdf  DAQ-STC reference manual
> -	67xx and 611x registers (from http://www.ni.com/pdf/daq/us)
> +	67xx and 611x registers (from http://www.ni.com/pdf/manuals/340934b.pdf)
>  	release_ni611x.pdf
>  	release_ni67xx.pdf

This is wrong. The URL you provided doesn't offer release_ni611x.pdf or 
release_ni67xx.pdf. Those two documents are here: 
ftp://ftp.ni.com/support/daq/mhddk/documentation/


>  	Other possibly relevant info:
> diff --git a/drivers/staging/comedi/drivers/plx9080.h b/drivers/staging/comedi/drivers/plx9080.h
> index 485d63f..6c14b6b 100644
> --- a/drivers/staging/comedi/drivers/plx9080.h
> +++ b/drivers/staging/comedi/drivers/plx9080.h
> @@ -13,7 +13,7 @@
>   *
>   ********************************************************************
>   *
> - * Copyright (C) 1999 RG Studio s.c., http://www.rgstudio.com.pl/
> + * Copyright (C) 1999 RG Studio s.c., 


You could lose the trailing comma.


>   * Written by Krzysztof Halasa <khc@rgstudio.com.pl>
>   *
>   * Portions (C) SBE Inc., used by permission.

> diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
> index 6612247..31b0a13 100644
> --- a/drivers/staging/quickstart/quickstart.c
> +++ b/drivers/staging/quickstart/quickstart.c
> @@ -5,8 +5,7 @@
>   *  Copyright (C) 2007-2010 Angelo Arrifano <miknix@gmail.com>
>   *
>   *  Information gathered from disassebled dsdt and from here:
> - *  "http://download.microsoft.com/download/9/c/5/
> - *  9c5b2167-8017-4bae-9fde-d599bac8184a/DirAppLaunch_Vista.doc"
> + *  "http://www.microsoft.com/whdc/system/platform/firmware/DirAppLaunch.mspx"


Angle brackets would be better than quote marks.


>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> diff --git a/drivers/telephony/Kconfig b/drivers/telephony/Kconfig
> index b5f78b6..fda68f7 100644
> --- a/drivers/telephony/Kconfig
> +++ b/drivers/telephony/Kconfig
> @@ -31,7 +31,7 @@ config PHONE_IXJ
>  	  isapnp support.  Please read <file:Documentation/telephony/ixj.txt>.
>  
>  	  For more information on these cards, see Quicknet's web site at:
> -	  <http://www.quicknet.net/>.
> +	  <http://www.qn.net/>.


No, Quicknet Technologies (www.quicknet.net in the web archive) is not the 
same as Quicknet, Inc. The URL is in the web archive.


>  
>  	  If you do not have any Quicknet telephony cards, you can safely
>  	  say N here.
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index b53deee..872ee40 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -26,7 +26,7 @@
>   *                  Daniele Bellucci, <bellucda@tiscali.it>
>   *
>   * More information about the hardware related to this driver can be found  
> - * at our website:    http://www.quicknet.net
> + * at our website:    http://www.qn.net/ 


Same.


>   *
>   * IN NO EVENT SHALL QUICKNET TECHNOLOGIES, INC. BE LIABLE TO ANY PARTY FOR
>   * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
> diff --git a/drivers/telephony/ixj.h b/drivers/telephony/ixj.h
> index 4c32a43..c012193 100644
> --- a/drivers/telephony/ixj.h
> +++ b/drivers/telephony/ixj.h
> @@ -22,7 +22,7 @@
>   *                  Mike Preston, <mpreston@quicknet.net>
>   *
>   * More information about the hardware related to this driver can be found
> - * at our website:    http://www.quicknet.net
> + * at our website:    http://www.qn.net/ 


Same.


>   *
>   * Fixes:
>   *
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 1da73ec..8d3ba1d 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -19,7 +19,7 @@ config UIO_CIF
>  	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
>  	  driver requires a userspace component that handles all of the
>  	  heavy lifting and can be found at:
> -	  	http://www.osadl.org/projects/downloads/UIO/user/cif-*
> +	        http://www.osadl.org/projects/downloads/UIO/user/	


The old link is correct. But it can be improved. For example --

-  	  driver requires a userspace component that handles all of the
-	  heavy lifting and can be found at:
-	  	http://www.osadl.org/projects/downloads/UIO/user/cif-*
+  	  driver requires a userspace component called cif that handles
+	  all of the heavy lifting and can be found at:
+	        http://www.osadl.org/projects/downloads/UIO/user/	



>  
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called uio_cif.
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index 916b2b6..fc20f80 100644
> --- a/drivers/usb/serial/Kconfig
> +++ b/drivers/usb/serial/Kconfig
> @@ -264,7 +264,7 @@ config USB_SERIAL_IUU
>  	help
>  	  Say Y here if you want to use a IUU in phoenix mode and get
>  	  an extra ttyUSBx device. More information available on
> -	  http://eczema.ecze.com/iuu_phoenix.html
> +	  http://www.opensc-project.org/openct/wiki/wbeiuu 


The old URL is in the web archive. You don't have to use this IUU driver 
with OpenSC...


>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called iuu_phoenix.o
> @@ -289,7 +289,8 @@ config USB_SERIAL_KEYSPAN
>  	  and was developed with their support.  You must also include
>  	  firmware to support your particular device(s).
>  
> -	  See <http://misc.nu/hugh/keyspan.html> for more information.
> +	  See <http://www.carnationsoftware.com/carnation/Keyspan.html>


I dunno what Carnation Software has to do with it. Hugh's page moved
here:

http://blemings.org/hugh/keyspan.html



> +	  for more information.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called keyspan.
> diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> index 15a4583..2438ae0 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -335,7 +335,7 @@
>  #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
>  
>  /* ACT Solutions HomePro ZWave interface
> -   (http://www.act-solutions.com/HomePro.htm) */
> +   (http://www.act-solutions.com/index.php) */


A better link is,
http://www.act-solutions.com/HomePro-Product-Matrix.html


>  #define FTDI_ACTZWAVE_PID	0xF2D0
>  
>  /*
> @@ -434,7 +434,7 @@
>  
>  /*
>   * PCDJ use ftdi based dj-controllers. The following PID is
> - * for their DAC-2 device http://www.pcdjhardware.com/DAC2.asp
> + * for their DAC-2 device http://pcdj.com/index.php/support/dex_dac_2/ 


That's not the same page. The old one is in the web archive, so no patch 
needed.


>   * (the VID is the standard ftdi vid (FTDI_VID), PID sent by Wouter Paesen)
>   */
>  #define FTDI_PCDJ_DAC2_PID 0xFA88

> @@ -723,7 +723,7 @@
>  
>  /*
>   * Bayer Ascensia Contour blood glucose meter USB-converter cable.
> - * http://winglucofacts.com/cables/
> + * http://www.simplewins.com/Default.aspx 



The old link is valid. Your URL has this:
http://www.simplewins.com/site/Adults/Monitor/Pages/Bayer-Products/Contour-USB
but who's to say whether it has the same PID/VID? I don't know...

>   */
>  #define BAYER_VID                      0x1A79
>  #define BAYER_CONTOUR_CABLE_PID        0x6001


> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index 297163c..9240914 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -9,7 +9,7 @@
>    the Free Software Foundation; either version 2 of the License, or
>    (at your option) any later version.
>  
> -  See http://misc.nu/hugh/keyspan.html for more information.
> +  See http://www.carnationsoftware.com/carnation/Keyspan.html for more information.


As above,
http://blemings.org/hugh/keyspan.html


>  
>    Code in this driver inspired by and in a number of places taken
>    from Brian Warner's original Keyspan-PDA driver.
> diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
> index bf3297d..f8b6a41 100644
> --- a/drivers/usb/serial/keyspan.h
> +++ b/drivers/usb/serial/keyspan.h
> @@ -9,7 +9,7 @@
>    the Free Software Foundation; either version 2 of the License, or
>    (at your option) any later version.
>  
> -  See http://misc.nu/hugh/keyspan.html for more information.
> +  See http://www.carnationsoftware.com/carnation/Keyspan.html for more information.


http://blemings.org/hugh/keyspan.html


>    
>    Code in this driver inspired by and in a number of places taken
>    from Brian Warner's original Keyspan-PDA driver.
> diff --git a/drivers/usb/serial/mct_u232.h b/drivers/usb/serial/mct_u232.h
> index 3a3f5e6..6f773c4 100644
> --- a/drivers/usb/serial/mct_u232.h
> +++ b/drivers/usb/serial/mct_u232.h
> @@ -10,10 +10,10 @@
>   *
>   * This driver is for the device MCT USB-RS232 Converter (25 pin, Model No.
>   * U232-P25) from Magic Control Technology Corp. (there is also a 9 pin
> - * Model No. U232-P9). See http://www.mct.com.tw/p_u232.html for further
> - * information. The properties of this device are listed at the end of this
> - * file. This device is available from various distributors. I know Hana,
> - * http://www.hana.de and D-Link, http://www.dlink.com/products/usb/dsbs25.
> + * Model No. U232-P9). See http://www.mct.com.tw/products/product_us232.html 
> + * for further information. The properties of this device are listed at the end 
> + * of this file. This device is available from various distributors. 
> + * D-Link, http://www.dlink.com/products/usb/dsbs25.


The trailing "." should go. How about this --

+ * Model No. U232-P9). See http://www.mct.com.tw/products/product_us232.html 
+ * for further information. The properties of this device are listed at the end 
+ * of this file. This device was used in the Dlink DSB-S25.


>   *
>   * All of the information about the device was acquired by using SniffUSB
>   * on Windows98. The technical details of the reverse engineering are

> diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
> index 8a372ba..b356e15 100644
> --- a/drivers/usb/storage/Kconfig
> +++ b/drivers/usb/storage/Kconfig
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 8b31fdf..a07fc57 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -1323,7 +1323,7 @@ config FB_RADEON
>  	  don't need to choose this to run the Radeon in plain VGA mode.
>  
>  	  There is a product page at
> -	  http://apps.ati.com/ATIcompare/
> +	  http://www.amd.com/us/products/technologies/ati-catalyst/Pages/catalyst.aspx 


There's no hardware product information at the URL you gave. It is a 
brouchure for AMD's Catalyst software. Here is the URL for the product 
specs:

http://products.amd.com/en-us/GraphicCardResult.aspx



>  
>  config FB_RADEON_I2C
>  	bool "DDC/I2C for ATI Radeon support"
> @@ -1395,7 +1395,7 @@ config FB_ATY_CT
>  	  Say Y here to support use of ATI's 64-bit Rage boards (or other
>  	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
>  	  framebuffer device.  The ATI product support page for these boards
> -	  is at <http://support.ati.com/products/pc/mach64/>.
> +	  is at <http://www.amd.com/us/products/technologies/ati-catalyst/Pages/catalyst.aspx>.

Why? Catalyst is not related to Mach64. Here's the URL you want:

http://support.ati.com/products/pc/mach64/mach64.html

You won't find any info at amd.com but at least it works in the web
archive, which is a huge improvement.



>  
>  config FB_ATY_GENERIC_LCD
>  	bool "Mach64 generic LCD support (EXPERIMENTAL)"

> diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
> index 7424929..d7d5526 100644
> --- a/fs/nls/nls_euc-jp.c
> +++ b/fs/nls/nls_euc-jp.c
> @@ -3,7 +3,7 @@
>   *
>   * Added `OSF/JVC Recommended Code Set Conversion Specification
>   * between Japanese EUC and Shift-JIS' support: <hirofumi@mail.parknet.co.jp>
> - * (http://www.opengroup.or.jp/jvc/cde/sjis-euc-e.html)
> + * (http://www.opengroup.or.jp/)


The document is in the web archive, and not at your URL, so this is 
damage.


>   */
>  
>  #include <linux/module.h>

> diff --git a/include/crypto/b128ops.h b/include/crypto/b128ops.h
> index 0b8e6bc..499741c 100644
> --- a/include/crypto/b128ops.h
> +++ b/include/crypto/b128ops.h
> @@ -4,7 +4,7 @@
>   * Copyright (c) 2006, Rik Snel <rsnel@cube.dyndns.org>
>   *
>   * Based on Dr Brian Gladman's (GPL'd) work published at
> - * http://fp.gladman.plus.com/cryptography_technology/index.htm
> + * http://www.gladman.me.uk/ 


Well, it doesn't say "Based on Dr Brian Gladman's latest work". The 
original is in the web archive so no patch is needed I think...


>   * See the original copyright notice below.
>   *
>   * This program is free software; you can redistribute it and/or modify it
> diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
> index 4086b8e..7021c6c 100644
> --- a/include/crypto/gf128mul.h
> +++ b/include/crypto/gf128mul.h
> @@ -4,7 +4,7 @@
>   * Copyright (c) 2006 Rik Snel <rsnel@cube.dyndns.org>
>   *
>   * Based on Dr Brian Gladman's (GPL'd) work published at
> - * http://fp.gladman.plus.com/cryptography_technology/index.htm
> + * http://www.gladman.me.uk/ 

Same here.


>   * See the original copyright notice below.
>   *
>   * This program is free software; you can redistribute it and/or modify it
> @@ -54,8 +54,8 @@
>  
>  /* Comment by Rik:
>   *
> - * For some background on GF(2^128) see for example: http://-
> - * csrc.nist.gov/CryptoToolkit/modes/proposedmodes/gcm/gcm-revised-spec.pdf
> + * For some background on GF(2^128) see for example: 
> + * http://www.cryptobarn.com/papers/gcm-spec.pdf 


This is the correct URL:
http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-revised-spec.pdf


>   *
>   * The elements of GF(2^128) := GF(2)[X]/(X^128-X^7-X^2-X^1-1) can
>   * be mapped to computer memory in a variety of ways. Let's examine

> diff --git a/include/linux/ixjuser.h b/include/linux/ixjuser.h
> index 88b4589..594d871 100644
> --- a/include/linux/ixjuser.h
> +++ b/include/linux/ixjuser.h
> @@ -25,7 +25,7 @@
>   *                  Mike Preston, <mpreston@quicknet.net>
>   *
>   * More information about the hardware related to this driver can be found
> - * at our website:    http://www.quicknet.net
> + * at our website:   http://www.qn.net/ 

See above.


>   *
>   * Fixes:
>   *
> diff --git a/include/linux/n_r3964.h b/include/linux/n_r3964.h
> index de24af7..60d73a6 100644
> --- a/include/linux/n_r3964.h
> +++ b/include/linux/n_r3964.h
> @@ -4,7 +4,7 @@
>   * Copyright by
>   * Philips Automation Projects
>   * Kassel (Germany)
> - * http://www.pap-philips.de
> + * http://www.pronto.philips.com/index.cfm?id=1292 


This URL you have provided is certainly pap but otherwise it doesn't 
relate. The URL you removed looks like advertising for a division that 
doesn't exist any longer, apparently spun off as KH-Automaton Projects 
GmbH. I'd remove it too.


>   * -----------------------------------------------------------
>   * This software may be used and distributed according to the terms of
>   * the GNU General Public License, incorporated herein by reference.

> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 571f895..a90050d 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -84,7 +84,7 @@ config IP_FIB_TRIE
>  
>  	  An experimental study of compression methods for dynamic tries
>  	  Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
> -	  http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
> +	  http://www.csc.kth.se/~snilsson/software/dyntrie2/ 
>  
>  endchoice
>  
> @@ -555,7 +555,7 @@ config TCP_CONG_VENO
>  	distinguishing to circumvent the difficult judgment of the packet loss
>  	type. TCP Veno cuts down less congestion window in response to random
>  	loss packets.
> -	See http://www.ntu.edu.sg/home5/ZHOU0022/papers/CPFu03a.pdf
> +	See http://www.ie.cuhk.edu.hk/fileadmin/staff_upload/soung/Journal/J3.pdf 

You wouldn't guess from looking at either of these links, but the
citation is actually this paper:

C.P. Fu and S.C. Liew. "TCP Veno: TCP Enhancement for Transmission
Over wireless Access Networks," IEEE Journal on Selected Areas in
Communication, February 2003.


>  
>  config TCP_CONG_YEAH
>  	tristate "YeAH TCP"

> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 1833bdb..d6a784c 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -147,7 +147,7 @@ config IP_NF_TARGET_ULOG
>  	  which can only be viewed through syslog.
>  
>  	  The appropriate userspace logging daemon (ulogd) may be obtained from
> -	  <http://www.gnumonks.org/projects/ulogd/>
> +	  <http://www.gnumonks.org/projects/>


Well I tried to obtain ulogd there but I couldn't find it.
It is available here though:
http://www.netfilter.org/projects/ulogd/index.html


>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  

> diff --git a/net/ipv4/tcp_westwood.c b/net/ipv4/tcp_westwood.c
> index 20151d6..bbf0e99 100644
> --- a/net/ipv4/tcp_westwood.c
> +++ b/net/ipv4/tcp_westwood.c
> @@ -3,7 +3,7 @@
>   *
>   *      Angelo Dell'Aera: author of the first version of TCP Westwood+ in Linux 2.4
>   *
> - * Support at http://c3lab.poliba.it/index.php/Westwood
> + * Support at http://www.cs.ucla.edu/NRL/hpi/tcpw/ 

I wouldn't think that you'd get support there. It claims to be the 
homepage for a BSD based implementation of TCP Westwood. In anycase, 
google cached the poliba.it link on 19 Sep 2010, so I don't think this 
needs to be patched. Besides, it is also in the web archive.


>   * Main references in literature:
>   *
>   * - Mascolo S, Casetti, M. Gerla et al.

>  
>     The boundaries and the conditions are changed according to RFC793:
>     the packet must intersect the window (i.e. segments may be
> diff --git a/sound/oss/ac97_codec.c b/sound/oss/ac97_codec.c
> index 456a1b4..e2c5fe9 100644
> --- a/sound/oss/ac97_codec.c
> +++ b/sound/oss/ac97_codec.c
> @@ -22,10 +22,7 @@
>   **************************************************************************
>   *
>   * The Intel Audio Codec '97 specification is available at the Intel

"is available at:"


> - * audio homepage: http://developer.intel.com/ial/scalableplatforms/audio/
> - *
> - * The specification itself is currently available at:
> - * ftp://download.intel.com/ial/scalableplatforms/ac97r22.pdf
> + * http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pdf
>   *
>   **************************************************************************
>   *
> diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
> index c7fba53..deffcc8 100644
> --- a/sound/pci/ens1370.c
> +++ b/sound/pci/ens1370.c
> @@ -22,7 +22,7 @@
>  /* Power-Management-Code ( CONFIG_PM )
>   * for ens1371 only ( FIXME )
>   * derived from cs4281.c, atiixp.c and via82xx.c
> - * using http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c1540.htm
> + * using http://www.kernel.org/pub/linux/kernel/people/tiwai/docs/writing-an-alsa-driver/index.html 


I think this is a better choice:
http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/


>   * by Kurt J. Bosch
>   */
>  

Thanks.

Finn
