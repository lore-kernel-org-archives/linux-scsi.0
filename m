From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for November 23
Date: Tue, 23 Nov 2010 09:15:51 -0800
Message-ID: <20101123091551.f3ed937f.randy.dunlap@oracle.com>
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
	<AANLkTi===xonvuovLS5Ch=coMDjzLQ4XSsPRDowDJ4L2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi===xonvuovLS5Ch=coMDjzLQ4XSsPRDowDJ4L2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 23 Nov 2010 16:43:22 +0100 Zimny Lech wrote:

> Ave
> 
> 2010/11/23 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101122:
> >
> 
> 
> Random config generator has failed :)

Hi,
What do you mean by this?  I'm not seeing any randconfig generator problems.
Are you using any options or inputs to kconfig?


> USB Gadget Support (USB_GADGET) [Y/n/?] y
>   Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [Y/n/?] y
>   Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [N/y/?] n
>   Debugging information files in debugfs (DEVELOPMENT)
> (USB_GADGET_DEBUG_FS) [Y/n/?] y
>   Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
>   USB Peripheral Controller
>   > 1. Renesas R8A66597 USB Peripheral Controller (USB_GADGET_R8A66597)
>     2. Renesas M66592 USB Peripheral Controller (USB_GADGET_M66592)
>   choice[1-2?]: 1
>   USB Gadget Drivers
>     1. Gadget Zero (DEVELOPMENT) (USB_ZERO)
>     2. Audio Gadget (EXPERIMENTAL) (USB_AUDIO)
>   > 3. Ethernet Gadget (with CDC Ethernet support) (USB_ETH)
>     4. Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_SERIAL)
>     5. Printer Gadget (USB_G_PRINTER)
>     6. CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSITE)
>     7. HID Gadget (USB_G_HID)
>     8. EHCI Debug Device Gadget (USB_G_DBGP)
>   choice[1-8?]: 3
>     RNDIS support (USB_ETH_RNDIS) [Y/n/?] (NEW) aborted!
> 
> Console input/output is redirected. Run 'make oldconfig' to update
> configuration.
> 
> make[3]: *** [silentoldconfig] Error 1
> make[2]: *** [silentoldconfig] Error 2
> make[1]: *** No rule to make target `include/config/auto.conf', needed
> by `include/config/kernel.release'.  Stop.
> make: *** [sub-make] Error 2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
