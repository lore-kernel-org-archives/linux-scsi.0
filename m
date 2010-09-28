From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC v5]update broken web addresses in the kernel.
Date: Tue, 28 Sep 2010 16:22:32 +1000 (EST)
Message-ID: <alpine.OSX.2.00.1009281613260.276@localhost>
References: <1285647599-14719-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1719167625-1285654952=:276"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1285647599-14719-1-git-send-email-justinmattock@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>, Dimitry Torokhov <dmitry.torokhov@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1719167625-1285654952=:276
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


Looks good to me.

Finn


On Mon, 27 Sep 2010, Justin P. Mattock wrote:

> Below is an updated patch to fix broken web addresses in the kernel.=20
> Please let me know if I missed anything, and I'll go back and fix it.
> and lastly Thanks for all the help with this...=20
>=20
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Cc: Maciej W. Rozycki <macro@linux-mips.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: Dimitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> Acked-by: Ben Pfaff <blp@cs.stanford.edu>
> Acked-by: Hans J. Koch <hjk@linutronix.de>
>=20
> ---
>  drivers/ata/pata_it821x.c                       |    4 ++--
>  drivers/atm/Kconfig                             |    2 +-
>  drivers/char/agp/Kconfig                        |    2 +-
>  drivers/char/agp/i460-agp.c                     |    2 +-
>  drivers/char/apm-emulation.c                    |    4 ++--
>  drivers/char/ipmi/ipmi_bt_sm.c                  |    2 +-
>  drivers/char/ipmi/ipmi_si_intf.c                |    3 +--
>  drivers/char/n_r3964.c                          |    1 -
>  drivers/char/pcmcia/Kconfig                     |    4 ++--
>  drivers/char/tpm/Kconfig                        |    2 +-
>  drivers/char/tpm/tpm_infineon.c                 |    2 +-
>  drivers/edac/edac_device_sysfs.c                |    2 +-
>  drivers/edac/i82443bxgx_edac.c                  |    2 +-
>  drivers/firmware/Kconfig                        |    4 ++--
>  drivers/firmware/edd.c                          |    2 +-
>  drivers/firmware/pcdp.h                         |    4 ++--
>  drivers/gpu/drm/drm_modes.c                     |    2 +-
>  drivers/hwmon/adm1025.c                         |    2 +-
>  drivers/hwmon/adm1026.c                         |    2 +-
>  drivers/hwmon/f75375s.c                         |    4 ++--
>  drivers/hwmon/g760a.c                           |    2 +-
>  drivers/hwmon/hwmon-vid.c                       |    2 +-
>  drivers/ide/hpt366.c                            |    2 +-
>  drivers/ide/ht6560b.c                           |    1 -
>  drivers/infiniband/Kconfig                      |    4 ++--
>  drivers/infiniband/hw/cxgb3/Kconfig             |    2 +-
>  drivers/infiniband/hw/cxgb4/Kconfig             |    2 +-
>  drivers/infiniband/ulp/iser/Kconfig             |    2 +-
>  drivers/input/joystick/gamecon.c                |    3 +--
>  drivers/input/misc/cm109.c                      |    2 +-
>  drivers/input/mouse/Kconfig                     |    1 +
>  drivers/input/mouse/touchkit_ps2.c              |    4 ++--
>  drivers/input/touchscreen/mk712.c               |    2 +-
>  drivers/isdn/i4l/isdn_audio.c                   |    2 +-
>  drivers/macintosh/therm_adt746x.c               |    6 +++---
>  drivers/media/IR/keymaps/rc-manli.c             |    1 -
>  drivers/media/dvb/ttpci/av7110.c                |   10 ++--------
>  drivers/media/dvb/ttpci/av7110_av.c             |    2 +-
>  drivers/media/dvb/ttpci/av7110_ca.c             |    2 +-
>  drivers/media/dvb/ttpci/av7110_hw.c             |    2 +-
>  drivers/media/dvb/ttpci/av7110_v4l.c            |    2 +-
>  drivers/media/dvb/ttpci/budget-av.c             |    2 +-
>  drivers/media/dvb/ttpci/budget-ci.c             |    2 +-
>  drivers/media/dvb/ttpci/budget-core.c           |    2 +-
>  drivers/media/dvb/ttpci/budget-patch.c          |    2 +-
>  drivers/media/dvb/ttpci/budget.c                |    2 +-
>  drivers/media/radio/radio-maxiradio.c           |    2 +-
>  drivers/media/radio/radio-typhoon.c             |    2 --
>  drivers/media/video/Kconfig                     |    2 +-
>  drivers/media/video/cafe_ccic.c                 |    2 +-
>  drivers/media/video/cx18/cx18-cards.c           |    2 +-
>  drivers/media/video/cx23885/cx23885-417.c       |    2 +-
>  drivers/media/video/cx88/cx88-blackbird.c       |    2 +-
>  drivers/media/video/ivtv/ivtv-cards.c           |    2 +-
>  drivers/media/video/mxb.c                       |    2 +-
>  drivers/media/video/sn9c102/sn9c102_pas202bcb.c |    1 -
>  drivers/misc/Kconfig                            |    4 ++--
>  drivers/mtd/chips/cfi_cmdset_0002.c             |    4 ++--
>  drivers/mtd/devices/lart.c                      |    2 +-
>  drivers/mtd/ftl.c                               |    2 +-
>  drivers/mtd/maps/Kconfig                        |    4 ++--
>  drivers/mtd/nand/cafe_nand.c                    |    2 +-
>  drivers/net/Kconfig                             |   21 ++++++++++-------=
----
>  drivers/net/appletalk/Kconfig                   |    2 +-
>  drivers/net/atp.c                               |    2 +-
>  drivers/net/epic100.c                           |    4 ++--
>  drivers/net/hamradio/Kconfig                    |    2 +-
>  drivers/net/ibmlana.c                           |    2 +-
>  drivers/net/irda/donauboe.h                     |    2 +-
>  drivers/net/pci-skeleton.c                      |    2 +-
>  drivers/net/pcmcia/3c574_cs.c                   |    2 +-
>  drivers/net/sc92031.c                           |    2 +-
>  drivers/net/tlan.c                              |    2 +-
>  drivers/net/tokenring/tms380tr.c                |    2 +-
>  drivers/net/tulip/Kconfig                       |    2 +-
>  drivers/net/usb/plusb.c                         |    2 +-
>  drivers/net/wan/Kconfig                         |    2 +-
>  drivers/net/wireless/ath/ath5k/ath5k.h          |    2 +-
>  drivers/net/wireless/ath/ath5k/reg.h            |    1 -
>  drivers/net/wireless/p54/Kconfig                |    6 +++---
>  drivers/net/wireless/prism54/islpci_hotplug.c   |    2 +-
>  drivers/parisc/README.dino                      |    3 +--
>  drivers/pci/quirks.c                            |    3 ++-
>  drivers/pcmcia/yenta_socket.c                   |    2 +-
>  drivers/pnp/pnpbios/proc.c                      |    1 -
>  drivers/scsi/Kconfig                            |    9 +++++----
>  drivers/serial/8250.c                           |    2 +-
>  drivers/serial/bfin_sport_uart.c                |    2 +-
>  drivers/serial/bfin_sport_uart.h                |    2 +-
>  drivers/serial/uartlite.c                       |    2 +-
>  drivers/staging/asus_oled/README                |    2 +-
>  drivers/staging/asus_oled/asus_oled.c           |    2 +-
>  drivers/staging/comedi/drivers/cb_pcimdas.c     |    2 +-
>  drivers/staging/comedi/drivers/daqboard2000.c   |    4 ++--
>  drivers/staging/comedi/drivers/ni_labpc.c       |    2 +-
>  drivers/staging/comedi/drivers/ni_mio_common.c  |    2 +-
>  drivers/staging/comedi/drivers/plx9080.h        |    2 +-
>  drivers/staging/comedi/drivers/rtd520.c         |    2 +-
>  drivers/staging/quickstart/quickstart.c         |    3 +--
>  drivers/uio/Kconfig                             |    6 +++---
>  drivers/usb/serial/Kconfig                      |    4 ++--
>  drivers/usb/serial/ftdi_sio_ids.h               |   12 ++++++------
>  drivers/usb/serial/keyspan.c                    |    2 +-
>  drivers/usb/serial/keyspan.h                    |    2 +-
>  drivers/usb/serial/mct_u232.h                   |    9 ++++-----
>  drivers/usb/storage/Kconfig                     |    2 +-
>  drivers/video/Kconfig                           |   10 +++++-----
>  drivers/video/arcfb.c                           |    1 -
>  drivers/video/epson1355fb.c                     |    2 +-
>  drivers/video/fbcvt.c                           |    2 +-
>  drivers/video/hecubafb.c                        |    2 +-
>  drivers/video/metronomefb.c                     |    2 +-
>  firmware/keyspan_pda/keyspan_pda.S              |    2 +-
>  firmware/keyspan_pda/xircom_pgs.S               |    2 +-
>  fs/hostfs/hostfs.h                              |    7 +------
>  fs/partitions/ldm.c                             |    2 +-
>  fs/partitions/ldm.h                             |    2 +-
>  fs/reiserfs/Kconfig                             |    6 ++++--
>  fs/reiserfs/README                              |    2 +-
>  include/crypto/gf128mul.h                       |    4 ++--
>  include/linux/fdreg.h                           |    2 +-
>  include/linux/if_infiniband.h                   |    2 +-
>  include/linux/n_r3964.h                         |    1 -
>  net/ax25/Kconfig                                |    8 ++++----
>  net/ipv4/Kconfig                                |    4 ++--
>  net/ipv4/cipso_ipv4.c                           |    2 +-
>  net/ipv4/fib_trie.c                             |    2 +-
>  net/ipv4/netfilter/Kconfig                      |    2 +-
>  net/ipv4/tcp_illinois.c                         |    2 +-
>  net/ipv4/tcp_input.c                            |    4 ++--
>  net/ipv4/tcp_veno.c                             |    2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c          |    4 ++--
>  sound/oss/ac97_codec.c                          |    7 ++-----
>  sound/pci/ens1370.c                             |    2 +-
>  sound/pci/intel8x0.c                            |    2 +-
>  135 files changed, 184 insertions(+), 209 deletions(-)
>=20
> diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
> index bf88f71..aa0e0c5 100644
> --- a/drivers/ata/pata_it821x.c
> +++ b/drivers/ata/pata_it821x.c
> @@ -15,8 +15,8 @@
>   *  May be copied or modified under the terms of the GNU General Public =
License
>   *  Based in part on the ITE vendor provided SCSI driver.
>   *
> - *  Documentation available from
> - * =09http://www.ite.com.tw/pc/IT8212F_V04.pdf
> + *  Documentation available from IT8212F_V04.pdf
> + * =09http://www.ite.com.tw/EN/products_more.aspx?CategoryID=3D3&ID=3D5,=
91
>   *  Some other documents are NDA.
>   *
>   *  The ITE8212 isn't exactly a standard IDE controller. It has two
> diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
> index be7461c..31c6010 100644
> --- a/drivers/atm/Kconfig
> +++ b/drivers/atm/Kconfig
> @@ -301,7 +301,7 @@ config ATM_IA
>  =09  control memory (128K-1KVC, 512K-4KVC), the size of the packet
>  =09  memory (128K, 512K, 1M), and the PHY type (Single/Multi mode OC3,
>  =09  UTP155, UTP25, DS3 and E3). Go to:
> -=09  =09<http://www.iphase.com/products/ClassSheet.cfm?ClassID=3DATM>
> +=09  =09<http://www.iphase.com/>
>  =09  for more info about the cards. Say Y (or M to compile as a module
>  =09  named iphase) here if you have one of these cards.
> =20
> diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
> index 4b66c69..c8ad619 100644
> --- a/drivers/char/agp/Kconfig
> +++ b/drivers/char/agp/Kconfig
> @@ -34,7 +34,7 @@ config AGP_ALI
>  =09  X on the following ALi chipsets.  The supported chipsets
>  =09  include M1541, M1621, M1631, M1632, M1641,M1647,and M1651.
>  =09  For the ALi-chipset question, ALi suggests you refer to
> -=09  <http://www.ali.com.tw/eng/support/index.shtml>.
> +=09  <http://www.ali.com.tw/>.
> =20
>  =09  The M1541 chipset can do AGP 1x and 2x, but note that there is an
>  =09  acknowledged incompatibility with Matrox G200 cards. Due to
> diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
> index e763d33..75b763c 100644
> --- a/drivers/char/agp/i460-agp.c
> +++ b/drivers/char/agp/i460-agp.c
> @@ -1,7 +1,7 @@
>  /*
>   * For documentation on the i460 AGP interface, see Chapter 7 (AGP Subsy=
stem) of
>   * the "Intel 460GTX Chipset Software Developer's Manual":
> - * http://developer.intel.com/design/itanium/downloads/24870401s.htm
> + * http://www.intel.com/design/archives/itanium/downloads/248704.htm=20
>   */
>  /*
>   * 460GX support by Chris Ahna <christopher.j.ahna@intel.com>
> diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
> index 033e150..0848ca9 100644
> --- a/drivers/char/apm-emulation.c
> +++ b/drivers/char/apm-emulation.c
> @@ -7,8 +7,8 @@
>   *   Intel Corporation, Microsoft Corporation. Advanced Power Management
>   *   (APM) BIOS Interface Specification, Revision 1.2, February 1996.
>   *
> - * [This document is available from Microsoft at:
> - *    http://www.microsoft.com/hwdev/busbios/amp_12.htm]
> + * This document is available from Microsoft at:
> + *    http://www.microsoft.com/whdc/archive/amp_12.mspx
>   */
>  #include <linux/module.h>
>  #include <linux/poll.h>
> diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_s=
m.c
> index 7b98c06..3ed20e8 100644
> --- a/drivers/char/ipmi/ipmi_bt_sm.c
> +++ b/drivers/char/ipmi/ipmi_bt_sm.c
> @@ -2,7 +2,7 @@
>   *  ipmi_bt_sm.c
>   *
>   *  The state machine for an Open IPMI BT sub-driver under ipmi_si.c, pa=
rt
> - *  of the driver architecture at http://sourceforge.net/project/openipm=
i
> + *  of the driver architecture at http://sourceforge.net/projects/openip=
mi=20
>   *
>   *  Author:=09Rocky Craig <first.last@hp.com>
>   *
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si=
_intf.c
> index 7bd7c45..3e94c37 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1974,8 +1974,7 @@ static int acpi_gpe_irq_setup(struct smi_info *info=
)
> =20
>  /*
>   * Defined at
> - * http://h21007.www2.hp.com/portal/download/files
> - * /unprot/hpspmi.pdf
> + * http://h21007.www2.hp.com/portal/download/files/unprot/hpspmi.pdf=20
>   */
>  struct SPMITable {
>  =09s8=09Signature[4];
> diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
> index a98290d..88dda0c 100644
> --- a/drivers/char/n_r3964.c
> +++ b/drivers/char/n_r3964.c
> @@ -4,7 +4,6 @@
>   * Copyright by=20
>   * Philips Automation Projects
>   * Kassel (Germany)
> - * http://www.pap-philips.de
>   * -----------------------------------------------------------
>   * This software may be used and distributed according to the terms of
>   * the GNU General Public License, incorporated herein by reference.
> diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
> index ffa0efc..6614416 100644
> --- a/drivers/char/pcmcia/Kconfig
> +++ b/drivers/char/pcmcia/Kconfig
> @@ -28,7 +28,7 @@ config CARDMAN_4000
> =20
>  =09  This kernel driver requires additional userspace support, either
>  =09  by the vendor-provided PC/SC ifd_handler (http://www.omnikey.com/),
> -=09  or via the cm4000 backend of OpenCT (http://www.opensc.com/).
> +=09  or via the cm4000 backend of OpenCT (http://www.opensc-project.org/=
opensc).
> =20
>  config CARDMAN_4040
>  =09tristate "Omnikey CardMan 4040 support"
> @@ -41,7 +41,7 @@ config CARDMAN_4040
>  =09  in I/O space.  To use the kernel driver, you will need either the
>  =09  PC/SC ifdhandler provided from the Omnikey homepage
>  =09  (http://www.omnikey.com/), or a current development version of Open=
CT
> -=09  (http://www.opensc.org/).
> +=09  (http://www.opensc-project.org/opensc).
> =20
>  config IPWIRELESS
>  =09tristate "IPWireless 3G UMTS PCMCIA card support"
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 4dc338f..f6595ab 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -58,6 +58,6 @@ config TCG_INFINEON
>  =09  To compile this driver as a module, choose M here; the module
>  =09  will be called tpm_infineon.
>  =09  Further information on this driver and the supported hardware
> -=09  can be found at http://www.prosec.rub.de/tpm
> +=09  can be found at http://www.trust.rub.de/projects/linux-device-drive=
r-infineon-tpm/=20
> =20
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infin=
eon.c
> index f584407..76da32e 100644
> --- a/drivers/char/tpm/tpm_infineon.c
> +++ b/drivers/char/tpm/tpm_infineon.c
> @@ -7,7 +7,7 @@
>   * Copyright (C) 2005, Marcel Selhorst <m.selhorst@sirrix.com>
>   * Sirrix AG - security technologies, http://www.sirrix.com and
>   * Applied Data Security Group, Ruhr-University Bochum, Germany
> - * Project-Homepage: http://www.prosec.rub.de/tpm
> + * Project-Homepage: http://www.trust.rub.de/projects/linux-device-drive=
r-infineon-tpm/=20
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License as
> diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_=
sysfs.c
> index 0709681..413f0df 100644
> --- a/drivers/edac/edac_device_sysfs.c
> +++ b/drivers/edac/edac_device_sysfs.c
> @@ -1,7 +1,7 @@
>  /*
>   * file for managing the edac_device class of devices for EDAC
>   *
> - * (C) 2007 SoftwareBitMaker (http://www.softwarebitmaker.com)
> + * (C) 2007 SoftwareBitMaker=20
>   *
>   * This file may be distributed under the terms of the
>   * GNU General Public License.
> diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_eda=
c.c
> index a2fa1fe..678405a 100644
> --- a/drivers/edac/i82443bxgx_edac.c
> +++ b/drivers/edac/i82443bxgx_edac.c
> @@ -12,7 +12,7 @@
>   * 440GX fix by Jason Uhlenkott <juhlenko@akamai.com>.
>   *
>   * Written with reference to 82443BX Host Bridge Datasheet:
> - * http://www.intel.com/design/chipsets/440/documentation.htm
> + * http://download.intel.com/design/chipsets/datashts/29063301.pdf=20
>   * references to this document given in [].
>   *
>   * This module doesn't support the 440LX, but it may be possible to
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 280c9b5..32e67a1 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -73,8 +73,8 @@ config EFI_PCDP
>  =09  on how the driver discovers devices.
> =20
>  =09  You must also enable the appropriate drivers (serial, VGA, etc.)
> -
> -=09  See <http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
> +=09  See DIG64_HCDPv20_042804.pdf available from
> +=09  <http://www.dig64.org/specifications/>
> =20
>  config DELL_RBU
>  =09tristate "BIOS update support for DELL systems via sysfs"
> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> index f287fe7..96c25d9 100644
> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -15,7 +15,7 @@
>   * made in setup.S, copied to safe structures in setup.c,
>   * and presents it in sysfs.
>   *
> - * Please see http://linux.dell.com/edd30/results.html for
> + * Please see http://linux.dell.com/edd/results.html for
>   * the list of BIOSs which have been reported to implement EDD.
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/firmware/pcdp.h b/drivers/firmware/pcdp.h
> index ce910d6..e098c6e 100644
> --- a/drivers/firmware/pcdp.h
> +++ b/drivers/firmware/pcdp.h
> @@ -1,8 +1,8 @@
>  /*
>   * Definitions for PCDP-defined console devices
>   *
> - * v1.0a: http://www.dig64.org/specifications/DIG64_HCDPv10a_01.pdf
> - * v2.0:  http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
> + * For DIG64_HCDPv10a_01.pdf and DIG64_PCDPv20.pdf (v10.a and v2.0 resp.=
),
> + * please see <http://www.dig64.org/specifications/>
>   *
>   * (c) Copyright 2002, 2004 Hewlett-Packard Development Company, L.P.
>   *=09Khalid Aziz <khalid.aziz@hp.com>
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> index 949326d..58e65f9 100644
> --- a/drivers/gpu/drm/drm_modes.c
> +++ b/drivers/gpu/drm/drm_modes.c
> @@ -76,7 +76,7 @@ EXPORT_SYMBOL(drm_mode_debug_printmodeline);
>   * according to the hdisplay, vdisplay, vrefresh.
>   * It is based from the VESA(TM) Coordinated Video Timing Generator by
>   * Graham Loveridge April 9, 2003 available at
> - * http://www.vesa.org/public/CVT/CVTd6r1.xls
> + * http://www.elo.utfsm.cl/~elo212/docs/CVTd6r1.xls=20
>   *
>   * And it is copied from xf86CVTmode in xserver/hw/xfree86/modes/xf86cvt=
=2Ec.
>   * What I have done is to translate it by using integer calculation.
> diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
> index 251b631..60befc0 100644
> --- a/drivers/hwmon/adm1025.c
> +++ b/drivers/hwmon/adm1025.c
> @@ -12,7 +12,7 @@
>   * resolution of about 0.5% of the nominal value). Temperature values ar=
e
>   * reported with a 1 deg resolution and a 3 deg accuracy. Complete
>   * datasheet can be obtained from Analog's website at:
> - *   http://www.analog.com/Analog_Root/productPage/productHome/0,2121,AD=
M1025,00.html
> + *   http://www.onsemi.com/PowerSolutions/product.do?id=3DADM1025=20
>   *
>   * This driver also supports the ADM1025A, which differs from the ADM102=
5
>   * only in that it has "open-drain VID inputs while the ADM1025 has
> diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
> index 65335b2..4bf969c 100644
> --- a/drivers/hwmon/adm1026.c
> +++ b/drivers/hwmon/adm1026.c
> @@ -6,7 +6,7 @@
> =20
>      Chip details at:
> =20
> -    <http://www.analog.com/UploadedFiles/Data_Sheets/779263102ADM1026_a.=
pdf>
> +    <http://www.onsemi.com/PowerSolutions/product.do?id=3DADM1026>
> =20
>      This program is free software; you can redistribute it and/or modify
>      it under the terms of the GNU General Public License as published by
> diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
> index 9638d58..95cbfb3 100644
> --- a/drivers/hwmon/f75375s.c
> +++ b/drivers/hwmon/f75375s.c
> @@ -6,10 +6,10 @@
>   * Datasheets available at:
>   *
>   * f75375:
> - * http://www.fintek.com.tw/files/productfiles/2005111152950.pdf
> + * http://www.fintek.com.tw/files/productfiles/F75375_V026P.pdf=20
>   *
>   * f75373:
> - * http://www.fintek.com.tw/files/productfiles/2005111153128.pdf
> + * http://www.fintek.com.tw/files/productfiles/F75373_V025P.pdf
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
> index 1f63d1a..1d6a6fa 100644
> --- a/drivers/hwmon/g760a.c
> +++ b/drivers/hwmon/g760a.c
> @@ -5,7 +5,7 @@
>      Copyright (C) 2007  Herbert Valerio Riedel <hvr@gnu.org>
> =20
>      Complete datasheet is available at GMT's website:
> -      http://www.gmt.com.tw/datasheet/g760a.pdf
> +      http://www.gmt.com.tw/product/datasheet/EDS-760A.pdf=20
> =20
>      This program is free software; you can redistribute it and/or modify
>      it under the terms of the GNU General Public License as published by
> diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
> index bf0862a..897702d 100644
> --- a/drivers/hwmon/hwmon-vid.c
> +++ b/drivers/hwmon/hwmon-vid.c
> @@ -38,7 +38,7 @@
>   * available at http://developer.intel.com/.
>   *
>   * AMD Athlon 64 and AMD Opteron Processors, AMD Publication 26094,
> - * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_do=
cs/26094.PDF
> + * http://developer.amd.com/documentation/articles/pages/1212200690_2.as=
px=20
>   * Table 74. VID Code Voltages
>   * This corresponds to an arbitrary VRM code of 24 in the functions belo=
w.
>   * These CPU models (K8 revision <=3D E) have 5 VID pins. See also:
> diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
> index 4516369..97d98fb 100644
> --- a/drivers/ide/hpt366.c
> +++ b/drivers/ide/hpt366.c
> @@ -12,7 +12,7 @@
>   *
>   *
>   * HighPoint has its own drivers (open source except for the RAID part)
> - * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.
> + * available from http://www.highpoint-tech.com/USA_new/service_support.=
htm=20
>   * This may be useful to anyone wanting to work on this driver, however =
 do not
>   * trust  them too much since the code tends to become less and less mea=
ningful
>   * as the time passes... :-/
> diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
> index d81e496..808bcdc 100644
> --- a/drivers/ide/ht6560b.c
> +++ b/drivers/ide/ht6560b.c
> @@ -10,7 +10,6 @@
>   *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
>   *             Jan Evert van Grootheest   <j.e.van.grootheest@caiway.nl>
>   *
> - *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
>   */
> =20
>  #define DRV_NAME=09"ht6560b"
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 89d70de..6e35ecc 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -16,7 +16,7 @@ config INFINIBAND_USER_MAD
>  =09  Userspace InfiniBand Management Datagram (MAD) support.  This
>  =09  is the kernel side of the userspace MAD support, which allows
>  =09  userspace processes to send and receive MADs. You will also
> -=09  need libibumad from <http://www.openib.org>.
> +=09  need libibumad from <http://www.openfabrics.org/downloads/managemen=
t/>.
> =20
>  config INFINIBAND_USER_ACCESS
>  =09tristate "InfiniBand userspace access (verbs and CM)"
> @@ -28,7 +28,7 @@ config INFINIBAND_USER_ACCESS
>  =09  to set up connections and directly access InfiniBand
>  =09  hardware for fast-path operations.  You will also need
>  =09  libibverbs, libibcm and a hardware driver library from
> -=09  <http://www.openib.org>.
> +=09  <http://www.openfabrics.org/git/>.
> =20
>  config INFINIBAND_USER_MEM
>  =09bool
> diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/=
cxgb3/Kconfig
> index 2acec3f..2b6352b 100644
> --- a/drivers/infiniband/hw/cxgb3/Kconfig
> +++ b/drivers/infiniband/hw/cxgb3/Kconfig
> @@ -10,7 +10,7 @@ config INFINIBAND_CXGB3
>  =09  our website at <http://www.chelsio.com>.
> =20
>  =09  For customer support, please visit our customer support page at
> -=09  <http://www.chelsio.com/support.htm>.
> +=09  <http://www.chelsio.com/support.html>.
> =20
>  =09  Please send feedback to <linux-bugs@chelsio.com>.
> =20
> diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/=
cxgb4/Kconfig
> index ccb85ea..6b7e6c5 100644
> --- a/drivers/infiniband/hw/cxgb4/Kconfig
> +++ b/drivers/infiniband/hw/cxgb4/Kconfig
> @@ -10,7 +10,7 @@ config INFINIBAND_CXGB4
>  =09  our website at <http://www.chelsio.com>.
> =20
>  =09  For customer support, please visit our customer support page at
> -=09  <http://www.chelsio.com/support.htm>.
> +=09  <http://www.chelsio.com/support.html>.
> =20
>  =09  Please send feedback to <linux-bugs@chelsio.com>.
> =20
> diff --git a/drivers/infiniband/ulp/iser/Kconfig b/drivers/infiniband/ulp=
/iser/Kconfig
> index b411c51..d00af71 100644
> --- a/drivers/infiniband/ulp/iser/Kconfig
> +++ b/drivers/infiniband/ulp/iser/Kconfig
> @@ -9,4 +9,4 @@ config INFINIBAND_ISER
> =20
>  =09  The iSER protocol is defined by IETF.
>  =09  See <http://www.ietf.org/rfc/rfc5046.txt>
> -=09  and <http://www.infinibandta.org/members/spec/Annex_iSER.PDF>
> +=09  and <http://members.infinibandta.org/kwspub/spec/Annex_iSER.PDF>
> diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/ga=
mecon.c
> index 0ffaf2c..e68e497 100644
> --- a/drivers/input/joystick/gamecon.c
> +++ b/drivers/input/joystick/gamecon.c
> @@ -521,9 +521,8 @@ static void gc_multi_process_packet(struct gc *gc)
>   * PSX support
>   *
>   * See documentation at:
> - *=09http://www.dim.com/~mackys/psxmemcard/ps-eng2.txt
> + *=09http://www.geocities.co.jp/Playtown/2004/psx/ps_eng.txt=09
>   *=09http://www.gamesx.com/controldata/psxcont/psxcont.htm
> - *=09ftp://milano.usal.es/pablo/
>   *
>   */
> =20
> diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
> index 2b0eba6..b09c7d1 100644
> --- a/drivers/input/misc/cm109.c
> +++ b/drivers/input/misc/cm109.c
> @@ -259,7 +259,7 @@ static unsigned short keymap_usbph01(int scancode)
> =20
>  /*
>   * Keymap for ATCom AU-100
> - * http://www.atcom.cn/En_products_AU100.html
> + * http://www.atcom.cn/products.html=20
>   * http://www.packetizer.com/products/au100/
>   * http://www.voip-info.org/wiki/view/AU-100
>   *
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index c714ca2..bf5fd7f 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -30,6 +30,7 @@ config MOUSE_PS2
>  =09=09<http://w1.894.telia.com/~u89404340/touchpad/index.html>
>  =09  and a new version of GPM at:
>  =09=09<http://www.geocities.com/dt_or/gpm/gpm.html>
> +=09=09<http://xorg.freedesktop.org/archive/individual/driver/>
>  =09  to take advantage of the advanced features of the touchpad.
> =20
>  =09  If unsure, say Y.
> diff --git a/drivers/input/mouse/touchkit_ps2.c b/drivers/input/mouse/tou=
chkit_ps2.c
> index 88121c5..1fd8f5e 100644
> --- a/drivers/input/mouse/touchkit_ps2.c
> +++ b/drivers/input/mouse/touchkit_ps2.c
> @@ -21,8 +21,8 @@
>   *
>   * Based upon touchkitusb.c
>   *
> - * Vendor documentation is available in support section of:
> - * http://www.egalax.com.tw/
> + * Vendor documentation is available at:
> + * http://home.eeti.com.tw/web20/drivers/Software%20Programming%20Guide_=
v2.0.pdf=20
>   */
> =20
>  #include <linux/kernel.h>
> diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscree=
n/mk712.c
> index efd3aeb..36e57de 100644
> --- a/drivers/input/touchscreen/mk712.c
> +++ b/drivers/input/touchscreen/mk712.c
> @@ -17,7 +17,7 @@
>   * found in Gateway AOL Connected Touchpad computers.
>   *
>   * Documentation for ICS MK712 can be found at:
> - *=09http://www.icst.com/pdf/mk712.pdf
> + *=09http://www.idt.com/products/getDoc.cfm?docID=3D18713923
>   */
> =20
>  /*
> diff --git a/drivers/isdn/i4l/isdn_audio.c b/drivers/isdn/i4l/isdn_audio.=
c
> index 861bdf3..d501393 100644
> --- a/drivers/isdn/i4l/isdn_audio.c
> +++ b/drivers/isdn/i4l/isdn_audio.c
> @@ -439,7 +439,7 @@ isdn_audio_xlaw2adpcm(adpcm_state * s, int fmt, unsig=
ned char *in,
> =20
>  /*
>   * Goertzel algorithm.
> - * See http://ptolemy.eecs.berkeley.edu/~pino/Ptolemy/papers/96/dtmf_ict=
/
> + * See http://ptolemy.eecs.berkeley.edu/papers/96/dtmf_ict/=20
>   * for more info.
>   * Result is stored into an sk_buff and queued up for later
>   * evaluation.
> diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_=
adt746x.c
> index d0d2213..9e3e2c5 100644
> --- a/drivers/macintosh/therm_adt746x.c
> +++ b/drivers/macintosh/therm_adt746x.c
> @@ -3,9 +3,9 @@
>   *
>   * Copyright (C) 2003, 2004 Colin Leroy, Rasmus Rohde, Benjamin Herrensc=
hmidt
>   *
> - * Documentation from
> - * http://www.analog.com/UploadedFiles/Data_Sheets/115254175ADT7467_pra.=
pdf
> - * http://www.analog.com/UploadedFiles/Data_Sheets/3686221171167ADT7460_=
b.pdf
> + * Documentation from 115254175ADT7467_pra.pdf and 3686221171167ADT7460_=
b.pdf
> + * http://www.onsemi.com/PowerSolutions/product.do?id=3DADT7467
> + * http://www.onsemi.com/PowerSolutions/product.do?id=3DADT7460
>   *
>   */
> =20
> diff --git a/drivers/media/IR/keymaps/rc-manli.c b/drivers/media/IR/keyma=
ps/rc-manli.c
> index 1e9fbfa..0f590b3 100644
> --- a/drivers/media/IR/keymaps/rc-manli.c
> +++ b/drivers/media/IR/keymaps/rc-manli.c
> @@ -13,7 +13,6 @@
>  #include <media/rc-map.h>
> =20
>  /* Michael Tokarev <mjt@tls.msk.ru>
> -   http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
>     keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
>     least, and probably other cards too.
>     The "ascii-art picture" below (in comments, first row
> diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/a=
v7110.c
> index a6be529..87279d9 100644
> --- a/drivers/media/dvb/ttpci/av7110.c
> +++ b/drivers/media/dvb/ttpci/av7110.c
> @@ -26,7 +26,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
> =20
> @@ -2290,13 +2290,7 @@ static int frontend_init(struct av7110 *av7110)
>  /* Budgetpatch note:
>   * Original hardware design by Roberto Deza:
>   * There is a DVB_Wiki at
> - * http://212.227.36.83/linuxtv/wiki/index.php/Main_Page
> - * where is described this 'DVB TT Budget Patch', on Card Modding:
> - * http://212.227.36.83/linuxtv/wiki/index.php/DVB_TT_Budget_Patch
> - * On the short description there is also a link to a external file,
> - * with more details:
> - * http://perso.wanadoo.es/jesussolano/Ttf_tsc1.zip
> - *
> + * http://www.linuxtv.org/
>   * New software triggering design by Emard that works on
>   * original Roberto Deza's hardware:
>   *
> diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpc=
i/av7110_av.c
> index 13efba9..878da6a 100644
> --- a/drivers/media/dvb/ttpci/av7110_av.c
> +++ b/drivers/media/dvb/ttpci/av7110_av.c
> @@ -25,7 +25,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include <linux/types.h>
> diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpc=
i/av7110_ca.c
> index 4eba35a..7564c26 100644
> --- a/drivers/media/dvb/ttpci/av7110_ca.c
> +++ b/drivers/media/dvb/ttpci/av7110_ca.c
> @@ -25,7 +25,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include <linux/kernel.h>
> diff --git a/drivers/media/dvb/ttpci/av7110_hw.c b/drivers/media/dvb/ttpc=
i/av7110_hw.c
> index e162691..f1cbfe5 100644
> --- a/drivers/media/dvb/ttpci/av7110_hw.c
> +++ b/drivers/media/dvb/ttpci/av7110_hw.c
> @@ -22,7 +22,7 @@
>   * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,=
 USA.
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  /* for debugging ARM communication: */
> diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttp=
ci/av7110_v4l.c
> index 8986d96..ac20c5b 100644
> --- a/drivers/media/dvb/ttpci/av7110_v4l.c
> +++ b/drivers/media/dvb/ttpci/av7110_v4l.c
> @@ -22,7 +22,7 @@
>   * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,=
 USA.
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include <linux/kernel.h>
> diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpc=
i/budget-av.c
> index 983672a..97afc01 100644
> --- a/drivers/media/dvb/ttpci/budget-av.c
> +++ b/drivers/media/dvb/ttpci/budget-av.c
> @@ -30,7 +30,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include "budget.h"
> diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpc=
i/budget-ci.c
> index 13ac9e3..a9c2c32 100644
> --- a/drivers/media/dvb/ttpci/budget-ci.c
> +++ b/drivers/media/dvb/ttpci/budget-ci.c
> @@ -26,7 +26,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include <linux/module.h>
> diff --git a/drivers/media/dvb/ttpci/budget-core.c b/drivers/media/dvb/tt=
pci/budget-core.c
> index ba18e56..0546613 100644
> --- a/drivers/media/dvb/ttpci/budget-core.c
> +++ b/drivers/media/dvb/ttpci/budget-core.c
> @@ -31,7 +31,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
> =20
> diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/t=
tpci/budget-patch.c
> index 9c92f9d..5798355 100644
> --- a/drivers/media/dvb/ttpci/budget-patch.c
> +++ b/drivers/media/dvb/ttpci/budget-patch.c
> @@ -27,7 +27,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include "av7110.h"
> diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/b=
udget.c
> index 874a10a..d238fb9 100644
> --- a/drivers/media/dvb/ttpci/budget.c
> +++ b/drivers/media/dvb/ttpci/budget.c
> @@ -31,7 +31,7 @@
>   * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
>   *
>   *
> - * the project's page is at http://www.linuxtv.org/dvb/
> + * the project's page is at http://www.linuxtv.org/=20
>   */
> =20
>  #include "budget.h"
> diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/=
radio-maxiradio.c
> index 4349213..255d40d 100644
> --- a/drivers/media/radio/radio-maxiradio.c
> +++ b/drivers/media/radio/radio-maxiradio.c
> @@ -13,7 +13,7 @@
>   * anybody does please mail me.
>   *
>   * For the pdf file see:
> - * http://www.semiconductors.philips.com/pip/TEA5757H/V1
> + * http://www.nxp.com/acrobat_download2/expired_datasheets/TEA5757_5759_=
3.pdf=20
>   *
>   *
>   * CHANGES:
> diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/ra=
dio-typhoon.c
> index 0343928..a5363ed 100644
> --- a/drivers/media/radio/radio-typhoon.c
> +++ b/drivers/media/radio/radio-typhoon.c
> @@ -1,8 +1,6 @@
>  /* Typhoon Radio Card driver for radio support
>   * (c) 1999 Dr. Henrik Seidel <Henrik.Seidel@gmx.de>
>   *
> - * Card manufacturer:
> - * http://194.18.155.92/idc/prod2.idc?nr=3D50753&lang=3De
>   *
>   * Notes on the hardware
>   *
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index f6e4d04..d000522 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -978,7 +978,7 @@ config USB_STKWEBCAM
>  =09  Supported devices are typically found in some Asus laptops,
>  =09  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
>  =09  may be supported by the stk11xx driver, from which this is
> -=09  derived, see http://stk11xx.sourceforge.net
> +=09  derived, see <http://sourceforge.net/projects/syntekdriver/>=20
> =20
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called stkwebcam.
> diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_c=
cic.c
> index be35e69..9536f1a 100644
> --- a/drivers/media/video/cafe_ccic.c
> +++ b/drivers/media/video/cafe_ccic.c
> @@ -4,7 +4,7 @@
>   * sensor.
>   *
>   * The data sheet for this device can be found at:
> - *    http://www.marvell.com/products/pcconn/88ALP01.jsp
> + *    http://www.marvell.com/products/pc_connectivity/88alp01/=20
>   *
>   * Copyright 2006 One Laptop Per Child Association, Inc.
>   * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> diff --git a/drivers/media/video/cx18/cx18-cards.c b/drivers/media/video/=
cx18/cx18-cards.c
> index 6b805af..fe10909 100644
> --- a/drivers/media/video/cx18/cx18-cards.c
> +++ b/drivers/media/video/cx18/cx18-cards.c
> @@ -39,7 +39,7 @@ static struct cx18_card_tuner_i2c cx18_i2c_std =3D {
>  =09.tv    =3D { 0x61, 0x60, I2C_CLIENT_END },
>  };
> =20
> -/* Please add new PCI IDs to: http://pci-ids.ucw.cz/iii
> +/* Please add new PCI IDs to: http://pci-ids.ucw.cz/=20
>     This keeps the PCI ID database up to date. Note that the entries
>     must be added under vendor 0x4444 (Conexant) as subsystem IDs.
>     New vendor IDs should still be added to the vendor ID list. */
> diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/vi=
deo/cx23885/cx23885-417.c
> index abd64e8..53a6782 100644
> --- a/drivers/media/video/cx23885/cx23885-417.c
> +++ b/drivers/media/video/cx23885/cx23885-417.c
> @@ -7,7 +7,7 @@
>   *    (c) 2008 Steven Toth <stoth@linuxtv.org>
>   *      - CX23885/7/8 support
>   *
> - *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
> + *  Includes parts from the ivtv driver <http://sourceforge.net/projects=
/ivtv/>
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/vi=
deo/cx88/cx88-blackbird.c
> index e46e1ce..660b2a9 100644
> --- a/drivers/media/video/cx88/cx88-blackbird.c
> +++ b/drivers/media/video/cx88/cx88-blackbird.c
> @@ -9,7 +9,7 @@
>   *    (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
>   *        - video_ioctl2 conversion
>   *
> - *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
> + *  Includes parts from the ivtv driver <http://sourceforge.net/projects=
/ivtv/>
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> diff --git a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/video/=
ivtv/ivtv-cards.c
> index ca1fd32..87afbbe 100644
> --- a/drivers/media/video/ivtv/ivtv-cards.c
> +++ b/drivers/media/video/ivtv/ivtv-cards.c
> @@ -65,7 +65,7 @@ static struct ivtv_card_tuner_i2c ivtv_i2c_tda8290 =3D =
{
> =20
>  /********************** card configuration *****************************=
**/
> =20
> -/* Please add new PCI IDs to: http://pci-ids.ucw.cz/iii
> +/* Please add new PCI IDs to: http://pci-ids.ucw.cz/=20
>     This keeps the PCI ID database up to date. Note that the entries
>     must be added under vendor 0x4444 (Conexant) as subsystem IDs.
>     New vendor IDs should still be added to the vendor ID list. */
> diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
> index ef0c817..b1dbcf1 100644
> --- a/drivers/media/video/mxb.c
> +++ b/drivers/media/video/mxb.c
> @@ -3,7 +3,7 @@
> =20
>      Copyright (C) 1998-2006 Michael Hunold <michael@mihu.de>
> =20
> -    Visit http://www.mihu.de/linux/saa7146/mxb/
> +    Visit http://www.themm.net/~mihu/linux/saa7146/mxb.html=20
>      for further details about this card.
> =20
>      This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/sn9c102/sn9c102_pas202bcb.c b/drivers/me=
dia/video/sn9c102/sn9c102_pas202bcb.c
> index 2782f94..2e86fdc 100644
> --- a/drivers/media/video/sn9c102/sn9c102_pas202bcb.c
> +++ b/drivers/media/video/sn9c102/sn9c102_pas202bcb.c
> @@ -4,7 +4,6 @@
>   *                                                                      =
   *
>   * Copyright (C) 2004 by Carlos Eduardo Medaglia Dyonisio               =
   *
>   *                       <medaglia@undl.org.br>                         =
   *
> - *                       http://cadu.homelinux.com:8080/                =
   *
>   *                                                                      =
   *
>   * Support for SN9C103, DAC Magnitude, exposure and green gain controls =
   *
>   * added by Luca Risolia <luca.risolia@studio.unibo.it>                 =
   *
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b743312..3b28933 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -112,8 +112,8 @@ config IBM_ASM
> =20
>  =09  WARNING: This software may not be supported or function
>  =09  correctly on your IBM server. Please consult the IBM ServerProven
> -=09  website <http://www.pc.ibm.com/ww/eserver/xseries/serverproven> for
> -=09  information on the specific driver level and support statement
> +=09  website <http://www-03.ibm.com/systems/info/x86servers/serverproven=
/compat/us/>
> +=09  for information on the specific driver level and support statement
>  =09  for your IBM server.
> =20
>  config PHANTOM
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_=
cmdset_0002.c
> index 3e6c47b..ba29d2f 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -418,8 +418,8 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map=
, int primary)
> =20
>  =09=09=09/*
>  =09=09=09 * Valid primary extension versions are: 1.0, 1.1, 1.2, 1.3, 1.=
4
> -=09=09=09 * see: http://www.amd.com/us-en/assets/content_type/Downloadab=
leAssets/cfi_r20.pdf, page 19
> -=09=09=09 *      http://www.amd.com/us-en/assets/content_type/Downloadab=
leAssets/cfi_100_20011201.pdf
> +=09=09=09 * see: http://cs.ozerki.net/zap/pub/axim-x5/docs/cfi_r20.pdf, =
page 19=20
> +=09=09=09 *      http://www.spansion.com/Support/AppNotes/cfi_100_200112=
01.pdf
>  =09=09=09 *      http://www.spansion.com/Support/Datasheets/s29ws-p_00_a=
12_e.pdf
>  =09=09=09 */
>  =09=09=09if (extp->MajorVersion !=3D '1' ||
> diff --git a/drivers/mtd/devices/lart.c b/drivers/mtd/devices/lart.c
> index f4359fe..caf6041 100644
> --- a/drivers/mtd/devices/lart.c
> +++ b/drivers/mtd/devices/lart.c
> @@ -17,7 +17,7 @@
>   *           - January 2000
>   *
>   *    [2] MTD internal API documentation
> - *           - http://www.linux-mtd.infradead.org/tech/
> + *           - http://www.linux-mtd.infradead.org/=20
>   *
>   * Limitations:
>   *
> diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
> index 4d6a64c..037b399 100644
> --- a/drivers/mtd/ftl.c
> +++ b/drivers/mtd/ftl.c
> @@ -51,7 +51,7 @@
> =20
>      Use of the FTL format for non-PCMCIA applications may be an
>      infringement of these patents.  For additional information,
> -    contact M-Systems (http://www.m-sys.com) directly.
> +    contact M-Systems directly. M-Systems since acquired by Sandisk.=20
> =20
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
>  #include <linux/mtd/blktrans.h>
> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> index 701d942..9622126 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -172,7 +172,7 @@ config MTD_OCTAGON
>  =09  This provides a 'mapping' driver which supports the way in which
>  =09  the flash chips are connected in the Octagon-5066 Single Board
>  =09  Computer. More information on the board is available at
> -=09  <http://www.octagonsystems.com/CPUpages/5066.html>.
> +=09  <http://www.octagonsystems.com/products/5066.aspx>.
> =20
>  config MTD_VMAX
>  =09tristate "JEDEC Flash device mapped on Tempustech VMAX SBC301"
> @@ -284,7 +284,7 @@ config MTD_TQM8XXL
>  =09  chips, currently uses AMD one. This 'mapping' driver supports
>  =09  that arrangement, allowing the CFI probe and command set driver
>  =09  code to communicate with the chips on the TQM8xxL board. More at
> -=09  <http://www.denx.de/embedded-ppc-en.html>.
> +=09  <http://www.denx.de/wiki/PPCEmbedded/>.
> =20
>  config MTD_RPXLITE
>  =09tristate "CFI Flash device mapped on RPX Lite or CLLF"
> diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
> index db1dfc5..e06c898 100644
> --- a/drivers/mtd/nand/cafe_nand.c
> +++ b/drivers/mtd/nand/cafe_nand.c
> @@ -2,7 +2,7 @@
>   * Driver for One Laptop Per Child =E2=80=98CAF=C3=89=E2=80=99 controlle=
r, aka Marvell 88ALP01
>   *
>   * The data sheet for this device can be found at:
> - *    http://www.marvell.com/products/pcconn/88ALP01.jsp
> + *    http://wiki.laptop.org/go/Datasheets=20
>   *
>   * Copyright =C2=A9 2006 Red Hat, Inc.
>   * Copyright =C2=A9 2006 David Woodhouse <dwmw2@infradead.org>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 2cc81a5..5b66842 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -921,7 +921,7 @@ config SMC91X
>  =09  including the SMC91C94 and the SMC91C111. Say Y if you want it
>  =09  compiled into the kernel, and read the file
>  =09  <file:Documentation/networking/smc9.txt>  and the Ethernet-HOWTO,
> -=09  available from  <http://www.linuxdoc.org/docs.html#howto>.
> +=09  available from  <http://www.tldp.org/docs.html#howto>.
> =20
>  =09  This driver is also available as a module ( =3D code which can be
>  =09  inserted in and removed from the running kernel whenever you want).
> @@ -1031,7 +1031,7 @@ config SMC911X
>  =09  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
>  =09  Say Y if you want it compiled into the kernel,=20
>  =09  and read the Ethernet-HOWTO, available from
> -=09  <http://www.linuxdoc.org/docs.html#howto>.
> +=09  <http://www.tldp.org/docs.html#howto>.
> =20
>  =09  This driver is also available as a module. The module will be=20
>  =09  called smc911x.  If you want to compile it as a module, say M=20
> @@ -1513,7 +1513,7 @@ config E100
> =20
>  =09  For the latest Intel PRO/100 network driver for Linux, see:
> =20
> -=09  <http://appsr.intel.com/scripts-df/support_intel.asp>
> +=09  <http://www.intel.com/p/en_US/support/highlights/network/pro100plus=
>
> =20
>  =09  More specific information on configuring the driver is in=20
>  =09  <file:Documentation/networking/e100.txt>.
> @@ -1539,9 +1539,8 @@ config FEALNX
>  =09select CRC32
>  =09select MII
>  =09help
> -=09  Say Y here to support the Mysom MTD-800 family of PCI-based Etherne=
t
> -=09  cards. Specifications and data at
> -=09  <http://www.myson.com.hk/mtd/datasheet/>.
> +=09  Say Y here to support the Myson MTD-800 family of PCI-based Etherne=
t=20
> +=09  cards. <http://www.myson.com.tw/>
> =20
>  config NATSEMI
>  =09tristate "National Semiconductor DP8381x series PCI Ethernet support"
> @@ -1715,7 +1714,7 @@ config SMSC9420
>  =09  This is a driver for SMSC's LAN9420 PCI ethernet adapter.
>  =09  Say Y if you want it compiled into the kernel,
>  =09  and read the Ethernet-HOWTO, available from
> -=09  <http://www.linuxdoc.org/docs.html#howto>.
> +=09  <http://www.tldp.org/docs.html#howto>.
> =20
>  =09  This driver is also available as a module. The module will be
>  =09  called smsc9420.  If you want to compile it as a module, say M
> @@ -2550,7 +2549,7 @@ config CHELSIO_T1
>            our website at <http://www.chelsio.com>.
> =20
>            For customer support, please visit our customer support page a=
t
> -          <http://www.chelsio.com/support.htm>.
> +          <http://www.chelsio.com/support.html>.
> =20
>            Please send feedback to <linux-bugs@chelsio.com>.
> =20
> @@ -2582,7 +2581,7 @@ config CHELSIO_T3
>  =09  our website at <http://www.chelsio.com>.
> =20
>  =09  For customer support, please visit our customer support page at
> -=09  <http://www.chelsio.com/support.htm>.
> +=09  <http://www.chelsio.com/support.html>.
> =20
>  =09  Please send feedback to <linux-bugs@chelsio.com>.
> =20
> @@ -2607,7 +2606,7 @@ config CHELSIO_T4
>  =09  our website at <http://www.chelsio.com>.
> =20
>  =09  For customer support, please visit our customer support page at
> -=09  <http://www.chelsio.com/support.htm>.
> +=09  <http://www.chelsio.com/support.html>.
> =20
>  =09  Please send feedback to <linux-bugs@chelsio.com>.
> =20
> @@ -2630,7 +2629,7 @@ config CHELSIO_T4VF
>  =09  our website at <http://www.chelsio.com>.
> =20
>  =09  For customer support, please visit our customer support page at
> -=09  <http://www.chelsio.com/support.htm>.
> +=09  <http://www.chelsio.com/support.html>.
> =20
>  =09  Please send feedback to <linux-bugs@chelsio.com>.
> =20
> diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfi=
g
> index 0a0e0cd..f5a8916 100644
> --- a/drivers/net/appletalk/Kconfig
> +++ b/drivers/net/appletalk/Kconfig
> @@ -18,7 +18,7 @@ config ATALK
> =20
>  =09  General information about how to connect Linux, Windows machines an=
d
>  =09  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.  Th=
e
> -=09  NET-3-HOWTO, available from
> +=09  NET3-4-HOWTO, available from
>  =09  <http://www.tldp.org/docs.html#howto>, contains valuable
>  =09  information as well.
> =20
> diff --git a/drivers/net/atp.c b/drivers/net/atp.c
> index bd2f9d3..0eee044 100644
> --- a/drivers/net/atp.c
> +++ b/drivers/net/atp.c
> @@ -68,7 +68,7 @@ static int xcvr[NUM_UNITS]; =09=09=09/* The data transf=
er mode. */
> =20
>  =09In 1997 Realtek made available the documentation for the second gener=
ation
>  =09RTL8012 chip, which has lead to several driver improvements.
> -=09  http://www.realtek.com.tw/cn/cn.html
> +=09  http://www.realtek.com.tw/
> =20
>  =09=09=09=09=09Theory of Operation
> =20
> diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
> index 57c8ac0..c6e2571 100644
> --- a/drivers/net/epic100.c
> +++ b/drivers/net/epic100.c
> @@ -131,8 +131,8 @@ IIIa. Ring buffers
> =20
>  IVb. References
> =20
> -http://www.smsc.com/main/tools/discontinued/83c171.pdf
> -http://www.smsc.com/main/tools/discontinued/83c175.pdf
> +http://www.smsc.com/media/Downloads_Public/discontinued/83c171.pdf
> +http://www.smsc.com/media/Downloads_Public/discontinued/83c175.pdf
>  http://scyld.com/expert/NWay.html
>  http://www.national.com/pf/DP/DP83840A.html
> =20
> diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
> index 62d5d5c..95dbcfd 100644
> --- a/drivers/net/hamradio/Kconfig
> +++ b/drivers/net/hamradio/Kconfig
> @@ -73,7 +73,7 @@ config DMASCC
>  =09  certain parameters, such as channel access timing, clock mode, and
>  =09  DMA channel. This is accomplished with a small utility program,
>  =09  dmascc_cfg, available at
> -=09  <http://cacofonix.nt.tuwien.ac.at/~oe1kib/Linux/>. Please be sure t=
o
> +=09  <http://www.linux-ax25.org/wiki/Ax25-tools>. Please be sure to
>  =09  get at least version 1.27 of dmascc_cfg, as older versions will not
>  =09  work with the current driver.
> =20
> diff --git a/drivers/net/ibmlana.c b/drivers/net/ibmlana.c
> index 294ccfb..8de3273 100644
> --- a/drivers/net/ibmlana.c
> +++ b/drivers/net/ibmlana.c
> @@ -23,7 +23,7 @@ paper sources:
>    'LAN Technical Reference Ethernet Adapter Interface Version 1 Release =
1.0
>     Document Number SC30-3661-00' by IBM for info on the adapter itself
> =20
> -  Also see http://www.natsemi.com/
> +  Also see http://www.national.com/analog=20
> =20
>  special acknowledgements to:
>    - Bob Eager for helping me out with documentation from IBM
> diff --git a/drivers/net/irda/donauboe.h b/drivers/net/irda/donauboe.h
> index 36c3060..4dc39e5 100644
> --- a/drivers/net/irda/donauboe.h
> +++ b/drivers/net/irda/donauboe.h
> @@ -54,7 +54,7 @@
>  /* anyone who has. HOWEVER the chip bears a striking resemblence */
>  /* to the IrDA controller in the Toshiba RISC TMPR3922 chip      */
>  /* the documentation for this is freely available at             */
> -/* http://www.toshiba.com/taec/components/Generic/TMPR3922.shtml */
> +/* http://www.madingley.org/james/resources/toshoboe/TMPR3922.pdf */
>  /* The mapping between the registers in that document and the    */
>  /* Registers in the 701 oboe chip are as follows    */
> =20
> diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
> index 56f3fc4..627b619 100644
> --- a/drivers/net/pci-skeleton.c
> +++ b/drivers/net/pci-skeleton.c
> @@ -78,7 +78,7 @@ that almost all frames will need to be copied to an ali=
gnment buffer.
> =20
>  IVb. References
> =20
> -http://www.realtek.com.tw/cn/cn.html
> +http://www.realtek.com.tw/
>  http://www.scyld.com/expert/NWay.html
> =20
>  IVc. Errata
> diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.=
c
> index c683f77..e092679 100644
> --- a/drivers/net/pcmcia/3c574_cs.c
> +++ b/drivers/net/pcmcia/3c574_cs.c
> @@ -62,7 +62,7 @@ invalid ramWidth is Very Bad.
>  V. References
> =20
>  http://www.scyld.com/expert/NWay.html
> -http://www.national.com/pf/DP/DP83840.html
> +http://www.national.com/opf/DP/DP83840A.html
> =20
>  Thanks to Terry Murphy of 3Com for providing development information for
>  earlier 3Com products.
> diff --git a/drivers/net/sc92031.c b/drivers/net/sc92031.c
> index 8c4067a..12fb560 100644
> --- a/drivers/net/sc92031.c
> +++ b/drivers/net/sc92031.c
> @@ -15,7 +15,7 @@
>   *  Rewritten for 2.6 by Cesar Eduardo Barros
>   *
>   *  A datasheet for this chip can be found at
> - *  http://www.silan.com.cn/english/products/pdf/SC92031AY.pdf
> + *  http://www.silan.com.cn/english/product/pdf/SC92031AY.pdf=20
>   */
> =20
>  /* Note about set_mac_address: I don't know how to change the hardware
> diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
> index ccee3ed..ef000b2 100644
> --- a/drivers/net/tlan.c
> +++ b/drivers/net/tlan.c
> @@ -78,7 +78,7 @@
>   * =09=09=09     - Updated tlan.txt accordingly.
>   * =09=09=09     - Adjusted minimum/maximum frame length.
>   * =09=09=09     - There is now a TLAN website up at
> - * =09=09=09       http://tlan.kernel.dk
> + * =09=09=09       http://hp.sourceforge.net/=20
>   *
>   * =09v1.7 April 07, 2000  - Started to implement custom ioctls. Driver =
now
>   * =09=09=09       reports PHY information when used with Donald
> diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms=
380tr.c
> index 435ef7d..ccc16d6 100644
> --- a/drivers/net/tokenring/tms380tr.c
> +++ b/drivers/net/tokenring/tms380tr.c
> @@ -5,7 +5,7 @@
>   *  Originally sktr.c: Written 1997 by Christoph Goos
>   *
>   *  A fine result of the Linux Systems Network Architecture Project.
> - *  http://www.linux-sna.org
> + *  http://www.vanheusden.com/sna/=20
>   *
>   *  This software may be used and distributed according to the terms
>   *  of the GNU General Public License, incorporated herein by reference.
> diff --git a/drivers/net/tulip/Kconfig b/drivers/net/tulip/Kconfig
> index 516713f..14c02e1 100644
> --- a/drivers/net/tulip/Kconfig
> +++ b/drivers/net/tulip/Kconfig
> @@ -151,7 +151,7 @@ config ULI526X
>  =09select CRC32
>  =09---help---
>  =09  This driver is for ULi M5261/M5263 10/100M Ethernet Controller
> -=09  (<http://www.uli.com.tw/>).
> +=09  (<http://www.nvidia.com/page/uli_drivers.html>).
> =20
>  =09  To compile this driver as a module, choose M here. The module will
>  =09  be called uli526x.
> diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
> index 08555f8..08ad269 100644
> --- a/drivers/net/usb/plusb.c
> +++ b/drivers/net/usb/plusb.c
> @@ -32,7 +32,7 @@
> =20
> =20
>  /*
> - * Prolific PL-2301/PL-2302 driver ... http://www.prolifictech.com
> + * Prolific PL-2301/PL-2302 driver ... http://www.prolific.com.tw/=20
>   *
>   * The protocol and handshaking used here should be bug-compatible
>   * with the Linux 2.2 "plusb" driver, by Deti Fliegl.
> diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
> index d08ce6a..423eb26 100644
> --- a/drivers/net/wan/Kconfig
> +++ b/drivers/net/wan/Kconfig
> @@ -409,7 +409,7 @@ config CYCLADES_SYNC
>  =09tristate "Cyclom 2X(tm) cards (EXPERIMENTAL)"
>  =09depends on WAN_ROUTER_DRIVERS && (PCI || ISA)
>  =09---help---
> -=09  Cyclom 2X from Cyclades Corporation <http://www.cyclades.com/> is a=
n
> +=09  Cyclom 2X from Cyclades Corporation <http://www.avocent.com/> is an
>  =09  intelligent multiprotocol WAN adapter with data transfer rates up t=
o
>  =09  512 Kbps. These cards support the X.25 and SNA related protocols.
> =20
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireles=
s/ath/ath5k/ath5k.h
> index ea6362a..97659a0 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -351,7 +351,7 @@ struct ath5k_srev_name {
>  /*
>   * Some of this information is based on Documentation from:
>   *
> - * http://madwifi.org/wiki/ChipsetFeatures/SuperAG
> + * http://madwifi-project.org/wiki/ChipsetFeatures/SuperAG=20
>   *
>   * Modulation for Atheros' eXtended Range - range enhancing extension th=
at is
>   * supposed to double the distance an Atheros client device can keep a
> diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/=
ath/ath5k/reg.h
> index 55b4ac6..69a9b34 100644
> --- a/drivers/net/wireless/ath/ath5k/reg.h
> +++ b/drivers/net/wireless/ath/ath5k/reg.h
> @@ -26,7 +26,6 @@
>   * Atheros presentations and papers like these:
>   *
>   * 5210 - http://nova.stanford.edu/~bbaas/ps/isscc2002_slides.pdf
> - *        http://www.it.iitb.ac.in/~janak/wifire/01222734.pdf
>   *
>   * 5211 - http://www.hotchips.org/archives/hc14/3_Tue/16_mcfarland.pdf
>   *
> diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/=
Kconfig
> index b0342a5..8e82379 100644
> --- a/drivers/net/wireless/p54/Kconfig
> +++ b/drivers/net/wireless/p54/Kconfig
> @@ -8,7 +8,7 @@ config P54_COMMON
>  =09  also need to be enabled in order to support any devices.
> =20
>  =09  These devices require softmac firmware which can be found at
> -=09  http://prism54.org/
> +=09  <http://wireless.kernel.org/en/users/Drivers/p54>
> =20
>  =09  If you choose to build a module, it'll be called p54common.
> =20
> @@ -20,7 +20,7 @@ config P54_USB
>  =09  This driver is for USB isl38xx based wireless cards.
> =20
>  =09  These devices require softmac firmware which can be found at
> -=09  http://prism54.org/
> +=09  <http://wireless.kernel.org/en/users/Drivers/p54>
> =20
>  =09  If you choose to build a module, it'll be called p54usb.
> =20
> @@ -34,7 +34,7 @@ config P54_PCI
>  =09  supported by the fullmac driver/firmware.
> =20
>  =09  This driver requires softmac firmware which can be found at
> -=09  http://prism54.org/
> +=09  <http://wireless.kernel.org/en/users/Drivers/p54>
> =20
>  =09  If you choose to build a module, it'll be called p54pci.
> =20
> diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/=
wireless/prism54/islpci_hotplug.c
> index dc14420..b5e64d7 100644
> --- a/drivers/net/wireless/prism54/islpci_hotplug.c
> +++ b/drivers/net/wireless/prism54/islpci_hotplug.c
> @@ -38,7 +38,7 @@ module_param(init_pcitm, int, 0);
>  /* In this order: vendor, device, subvendor, subdevice, class, class_mas=
k,
>   * driver_data
>   * If you have an update for this please contact prism54-devel@prism54.o=
rg
> - * The latest list can be found at http://prism54.org/supported_cards.ph=
p */
> + * The latest list can be found at http://wireless.kernel.org/en/users/D=
rivers/p54 */
>  static DEFINE_PCI_DEVICE_TABLE(prism54_id_tbl) =3D {
>  =09/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
>  =09{
> diff --git a/drivers/parisc/README.dino b/drivers/parisc/README.dino
> index 097324f..1627426 100644
> --- a/drivers/parisc/README.dino
> +++ b/drivers/parisc/README.dino
> @@ -10,8 +10,7 @@
>  ** PCI bus. HP-supplied graphics cards that utilize the PCI bus are
>  ** not affected."
>  **
> -** REVISIT: "go/pci_defect" link below is stale.
> -**=09HP Internal can use <http://hpfcdma.fc.hp.com:80/Dino/>
> +** http://h20000.www2.hp.com/bizsupport/TechSupport/Home.jsp?locale=3Den=
_US&prodTypeId=3D12454&prodSeriesId=3D44443
>  **
>  **=09Product=09=09First Good Serial Number
>  **  C200/C240 (US)=09US67350000
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 89ed181..dcc333f 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -206,6 +206,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, =09PCI_D=
EVICE_ID_INTEL_82439TX, =09quir
>   *=09VIA Apollo KT133 needs PCI latency patch
>   *=09Made according to a windows driver based patch by George E. Breese
>   *=09see PCI Latency Adjust on http://www.viahardware.com/download/viatw=
eak.shtm
> + *=09and http://www.georgebreese.com/net/software/#PCI
>   *      Also see http://www.au-ja.org/review-kt133a-1-en.phtml for
>   *      the info on which Mr Breese based his work.
>   *
> @@ -996,7 +997,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,=090x6=
05,=09quirk_transparent_bridge)
>  /*
>   * Common misconfiguration of the MediaGX/Geode PCI master that will
>   * reduce PCI bandwidth from 70MB/s to 25MB/s.  See the GXM/GXLV/GX1
> - * datasheets found at http://www.national.com/ds/GX for info on what
> + * datasheets found at http://www.national.com/analog for info on what
>   * these bits do.  <christer@weinigel.se>
>   */
>  static void quirk_mediagx_master(struct pci_dev *dev)
> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.=
c
> index 414d9a6..91a7225 100644
> --- a/drivers/pcmcia/yenta_socket.c
> +++ b/drivers/pcmcia/yenta_socket.c
> @@ -1073,7 +1073,7 @@ static void yenta_config_init(struct yenta_socket *=
socket)
>   * invisible during PCI scans because of a misconfigured subordinate num=
ber
>   * of the parent brige - some BIOSes seem to be too lazy to set it right=
=2E
>   * Does the fixup carefully by checking how far it can go without confli=
cts.
> - * See http\://bugzilla.kernel.org/show_bug.cgi?id=3D2944 for more infor=
mation.
> + * See http://bugzilla.kernel.org/show_bug.cgi?id=3D2944 for more inform=
ation.
>   */
>  static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
>  {
> diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
> index 2d8ac43..bc89f39 100644
> --- a/drivers/pnp/pnpbios/proc.c
> +++ b/drivers/pnp/pnpbios/proc.c
> @@ -11,7 +11,6 @@
>   *
>   * The .../escd file is utilized by the lsescd utility written by
>   * Gunther Mayer.
> - *     http://home.t-online.de/home/gunther.mayer/lsescd
>   *
>   * The .../legacy_device_resources file is not used yet.
>   *
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index bbf91ae..03453d4 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -116,7 +116,7 @@ config CHR_DEV_OSST
>  =09  <http://www.tldp.org/docs.html#howto>  and
>  =09  <file:Documentation/scsi/osst.txt>  in the kernel source.
>  =09  More info on the OnStream driver may be found on
> -=09  <http://linux1.onstream.nl/test/>
> +=09  <http://sourceforge.net/projects/osst/>
>  =09  Please also have a look at the standard st docu, as most of it
>  =09  applies to osst as well.
> =20
> @@ -156,9 +156,9 @@ config CHR_DEV_SG
>  =09  directly, so you need some additional software which knows how to
>  =09  talk to these devices using the SCSI protocol:
> =20
> -=09  For scanners, look at SANE (<http://www.mostang.com/sane/>). For CD
> +=09  For scanners, look at SANE (<http://www.sane-project.org/>). For CD
>  =09  writer software look at Cdrtools
> -=09  (<http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilli=
ng/private/cdrecord.html>)
> +=09  (<http://cdrecord.berlios.de/private/cdrecord.html>)
>  =09  and for burning a "disk at once": CDRDAO
>  =09  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
>  =09  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/=
>).
> @@ -950,6 +950,7 @@ config SCSI_IPS
>  =09---help---
>  =09  This is support for the IBM ServeRAID hardware RAID controllers.
>  =09  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
> +=09  and <http://www-947.ibm.com/support/entry/portal/docdisplay?brand=
=3D5000008&lndocid=3DSERV-RAID>
>  =09  for more information.  If this driver does not work correctly
>  =09  without modification please contact the author by email at
>  =09  <ipslinux@adaptec.com>.
> @@ -1609,7 +1610,7 @@ config SCSI_DEBUG
>  =09  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
>  =09  RAM as storage (i.e. it is a ramdisk). To save space when multiple
>  =09  dummy disks are simulated, they share the same kernel RAM for=20
> -=09  their storage. See <http://www.torque.net/sg/sdebug.html> for more
> +=09  their storage. See <http://sg.danny.cz/sg/sdebug26.html> for more
>  =09  information. This driver is primarily of use to those testing the
>  =09  SCSI and block subsystems. If unsure, say N.
> =20
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 24110f6..131c95f 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -924,7 +924,7 @@ static int broken_efr(struct uart_8250_port *up)
>  =09/*
>  =09 * Exar ST16C2550 "A2" devices incorrectly detect as
>  =09 * having an EFR, and report an ID of 0x0201.  See
> -=09 * http://www.exar.com/info.php?pdf=3Ddan180_oct2004.pdf
> +=09 * http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-11/4812.html=
=20
>  =09 */
>  =09if (autoconfig_read_divisor_id(up) =3D=3D 0x0201 && size_fifo(up) =3D=
=3D 16)
>  =09=09return 1;
> diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport=
_uart.c
> index 5318dd3..feb62a8 100644
> --- a/drivers/serial/bfin_sport_uart.c
> +++ b/drivers/serial/bfin_sport_uart.c
> @@ -10,7 +10,7 @@
> =20
>  /*
>   * This driver and the hardware supported are in term of EE-191 of ADI.
> - * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.=
pdf
> + * http://www.analog.com/static/imported-files/application_notes/EE191.p=
df=20
>   * This application note describe how to implement a UART on a Sharc DSP=
,
>   * but this driver is implemented on Blackfin Processor.
>   * Transmit Frame Sync is not used by this driver to transfer data out.
> diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport=
_uart.h
> index 9ce253e..6d06ce1 100644
> --- a/drivers/serial/bfin_sport_uart.h
> +++ b/drivers/serial/bfin_sport_uart.h
> @@ -10,7 +10,7 @@
> =20
>  /*
>   * This driver and the hardware supported are in term of EE-191 of ADI.
> - * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.=
pdf
> + * http://www.analog.com/static/imported-files/application_notes/EE191.p=
df=20
>   * This application note describe how to implement a UART on a Sharc DSP=
,
>   * but this driver is implemented on Blackfin Processor.
>   * Transmit Frame Sync is not used by this driver to transfer data out.
> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
> index 9b03d7b..3fa2e16 100644
> --- a/drivers/serial/uartlite.c
> +++ b/drivers/serial/uartlite.c
> @@ -44,7 +44,7 @@ MODULE_DEVICE_TABLE(of, ulite_of_match);
>   * Register definitions
>   *
>   * For register details see datasheet:
> - * http://www.xilinx.com/bvdocs/ipcenter/data_sheet/opb_uartlite.pdf
> + * http://www.xilinx.com/support/documentation/ip_documentation/opb_uart=
lite.pdf=20
>   */
> =20
>  #define ULITE_RX=09=090x00
> diff --git a/drivers/staging/asus_oled/README b/drivers/staging/asus_oled=
/README
> index 96b9717..0d82a6d 100644
> --- a/drivers/staging/asus_oled/README
> +++ b/drivers/staging/asus_oled/README
> @@ -2,7 +2,7 @@
>      Driver for Asus OLED display present in some Asus laptops.
> =20
>      The code of this driver is based on 'asusoled' program taken from
> -    https://launchpad.net/asusoled/. I just wanted to have a simple
> +    <http://lapsus.berlios.de/asus_oled.html>. I just wanted to have a s=
imple
>      kernel driver for controlling this device, but I didn't know how
>      to do that. Now I know ;) Also, that program can not be used
>      with usbhid loaded, which means no USB mouse/keyboard while
> diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus=
_oled/asus_oled.c
> index 5b279fb..8c95d8c 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -24,7 +24,7 @@
>   *
>   *
>   *  Asus OLED support is based on asusoled program taken from
> - *  https://launchpad.net/asusoled/.
> + *  <http://lapsus.berlios.de/asus_oled.html>.
>   *
>   *
>   */
> diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/stagin=
g/comedi/drivers/cb_pcimdas.c
> index ced346a..78b1410 100644
> --- a/drivers/staging/comedi/drivers/cb_pcimdas.c
> +++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
> @@ -37,7 +37,7 @@ Configuration Options:
>  Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org)=
=2E
>  Only supports DIO, AO and simple AI in it's present form.
>  No interrupts, multi channel or FIFO AI, although the card looks like it=
 could support this.
> -See http://www.measurementcomputing.com/PDFManuals/pcim-das1602_16.pdf f=
or more details.
> +See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more deta=
ils.
>  */
> =20
>  #include "../comedidev.h"
> diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/stag=
ing/comedi/drivers/daqboard2000.c
> index 6af6c83..82be77d 100644
> --- a/drivers/staging/comedi/drivers/daqboard2000.c
> +++ b/drivers/staging/comedi/drivers/daqboard2000.c
> @@ -50,8 +50,8 @@ Configuration options:
>     With some help from our swedish distributor, we got the Windows sourc=
ecode
>     for the card, and here are the findings so far.
> =20
> -   1. A good document that describes the PCI interface chip is found at:
> -      http://plx.plxtech.com/download/9080/databook/9080db-106.pdf
> +   1. A good document that describes the PCI interface chip is 9080db-10=
6.pdf
> +      available from http://www.plxtech.com/products/io/pci9080=20
> =20
>     2. The initialization done so far is:
>          a. program the FPGA (windows code sans a lot of error messages)
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/=
comedi/drivers/ni_labpc.c
> index 3acf7e6..1411dd8 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -37,7 +37,7 @@ boards has not
>  yet been added to the driver, mainly due to the fact that
>  I don't know the device id numbers.  If you have one
>  of these boards,
> -please file a bug report at https://bugs.comedi.org/
> +please file a bug report at http://comedi.org/=20
>  so I can get the necessary information from you.
> =20
>  The 1200 series boards have onboard calibration dacs for correcting
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/sta=
ging/comedi/drivers/ni_mio_common.c
> index bd16f91..986ef67 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -34,7 +34,7 @@
>  =09   340747b.pdf  AT-MIO E series Register Level Programmer Manual
>  =09   341079b.pdf  PCI E Series RLPM
>  =09   340934b.pdf  DAQ-STC reference manual
> -=0967xx and 611x registers (from http://www.ni.com/pdf/daq/us)
> +=0967xx and 611x registers (from ftp://ftp.ni.com/support/daq/mhddk/docu=
mentation/)
>  =09release_ni611x.pdf
>  =09release_ni67xx.pdf
>  =09Other possibly relevant info:
> diff --git a/drivers/staging/comedi/drivers/plx9080.h b/drivers/staging/c=
omedi/drivers/plx9080.h
> index 485d63f..0d254a1 100644
> --- a/drivers/staging/comedi/drivers/plx9080.h
> +++ b/drivers/staging/comedi/drivers/plx9080.h
> @@ -13,7 +13,7 @@
>   *
>   ********************************************************************
>   *
> - * Copyright (C) 1999 RG Studio s.c., http://www.rgstudio.com.pl/
> + * Copyright (C) 1999 RG Studio s.c.
>   * Written by Krzysztof Halasa <khc@rgstudio.com.pl>
>   *
>   * Portions (C) SBE Inc., used by permission.
> diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/co=
medi/drivers/rtd520.c
> index 0367d2b..a49a7c5 100644
> --- a/drivers/staging/comedi/drivers/rtd520.c
> +++ b/drivers/staging/comedi/drivers/rtd520.c
> @@ -59,7 +59,7 @@ Configuration options:
>      Data sheet: http://www.rtdusa.com/pdf/dm7520.pdf
>      Example source: http://www.rtdusa.com/examples/dm/dm7520.zip
>      Call them and ask for the register level manual.
> -    PCI chip: http://www.plxtech.com/products/toolbox/9080.htm
> +    PCI chip: http://www.plxtech.com/products/io/pci9080=20
> =20
>      Notes:
>      This board is memory mapped.  There is some IO stuff, but it isn't n=
eeded.
> diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/qu=
ickstart/quickstart.c
> index 6612247..ba8f670 100644
> --- a/drivers/staging/quickstart/quickstart.c
> +++ b/drivers/staging/quickstart/quickstart.c
> @@ -5,8 +5,7 @@
>   *  Copyright (C) 2007-2010 Angelo Arrifano <miknix@gmail.com>
>   *
>   *  Information gathered from disassebled dsdt and from here:
> - *  "http://download.microsoft.com/download/9/c/5/
> - *  9c5b2167-8017-4bae-9fde-d599bac8184a/DirAppLaunch_Vista.doc"
> + *  <http://www.microsoft.com/whdc/system/platform/firmware/DirAppLaunch=
=2Emspx>=20
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 1da73ec..bb44079 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -17,9 +17,9 @@ config UIO_CIF
>  =09depends on PCI
>  =09help
>  =09  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
> -=09  driver requires a userspace component that handles all of the
> -=09  heavy lifting and can be found at:
> -=09  =09http://www.osadl.org/projects/downloads/UIO/user/cif-*
> +  =09  driver requires a userspace component called cif that handles
> +=09  all of the heavy lifting and can be found at:
> +=09        <http://www.osadl.org/projects/downloads/UIO/user/>
> =20
>  =09  To compile this driver as a module, choose M here: the module
>  =09  will be called uio_cif.
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index 916b2b6..b71e309 100644
> --- a/drivers/usb/serial/Kconfig
> +++ b/drivers/usb/serial/Kconfig
> @@ -176,7 +176,7 @@ config USB_SERIAL_VISOR
>  =09help
>  =09  Say Y here if you want to connect to your HandSpring Visor, Palm
>  =09  m500 or m505 through its USB docking station. See
> -=09  <http://usbvisor.sourceforge.net/> for more information on using th=
is
> +=09  <http://usbvisor.sourceforge.net/index.php3> for more information o=
n using this
>  =09  driver.
> =20
>  =09  To compile this driver as a module, choose M here: the
> @@ -289,7 +289,7 @@ config USB_SERIAL_KEYSPAN
>  =09  and was developed with their support.  You must also include
>  =09  firmware to support your particular device(s).
> =20
> -=09  See <http://misc.nu/hugh/keyspan.html> for more information.
> +=09  See <http://blemings.org/hugh/keyspan.html> for more information.
> =20
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called keyspan.
> diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_=
sio_ids.h
> index 15a4583..28c640d 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -46,7 +46,7 @@
>  #define FTDI_USINT_RS232_PID=090xb812=09/* Navigator RS232 and CONFIG li=
nes */
> =20
>  /* OOCDlink by Joern Kaipf <joernk@web.de>
> - * (http://www.joernonline.de/dw/doku.php?id=3Dstart&idx=3Dprojects:oocd=
link) */
> + * (http://www.joernonline.de/) */
>  #define FTDI_OOCDLINK_PID=090xbaf8=09/* Amontec JTAGkey */
> =20
>  /* Luminary Micro Stellaris Boards, VID =3D FTDI_VID */
> @@ -335,7 +335,7 @@
>  #define FTDI_PIEGROUP_PID=090xF208=09/* Product Id */
> =20
>  /* ACT Solutions HomePro ZWave interface
> -   (http://www.act-solutions.com/HomePro.htm) */
> +   (http://www.act-solutions.com/HomePro-Product-Matrix.html) */
>  #define FTDI_ACTZWAVE_PID=090xF2D0
> =20
>  /*
> @@ -366,7 +366,7 @@
>  #define FTDI_SUUNTO_SPORTS_PID=090xF680=09/* Suunto Sports instrument */
> =20
>  /* USB-UIRT - An infrared receiver and transmitter using the 8U232AM chi=
p */
> -/* http://home.earthlink.net/~jrhees/USBUIRT/index.htm */
> +/* http://www.usbuirt.com/ */
>  #define FTDI_USB_UIRT_PID=090xF850=09/* Product Id */
> =20
>  /* CCS Inc. ICDU/ICDU40 product ID -
> @@ -395,7 +395,7 @@
>   */
>  #define FTDI_HE_TIRA1_PID=090xFA78=09/* Tira-1 IR transceiver */
> =20
> -/* Inside Accesso contactless reader (http://www.insidefr.com) */
> +/* Inside Accesso contactless reader (http://www.insidecontactless.com/)=
 */
>  #define INSIDE_ACCESSO=09=090xFAD0
> =20
>  /*
> @@ -634,14 +634,14 @@
> =20
>  /*
>   * JETI SPECTROMETER SPECBOS 1201
> - * http://www.jeti.com/products/sys/scb/scb1201.php
> + * http://www.jeti.com/cms/index.php/instruments/other-instruments/specb=
os-2101
>   */
>  #define JETI_VID=09=090x0c6c
>  #define JETI_SPC1201_PID=090x04b2
> =20
>  /*
>   * FTDI USB UART chips used in construction projects from the
> - * Elektor Electronics magazine (http://elektor-electronics.co.uk)
> + * Elektor Electronics magazine (http://www.elektor.com/)
>   */
>  #define ELEKTOR_VID=09=090x0C7D
>  #define ELEKTOR_FT323R_PID=090x0005=09/* RFID-Reader, issue 09-2006 */
> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index 297163c..0791778 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -9,7 +9,7 @@
>    the Free Software Foundation; either version 2 of the License, or
>    (at your option) any later version.
> =20
> -  See http://misc.nu/hugh/keyspan.html for more information.
> +  See http://blemings.org/hugh/keyspan.html for more information.
> =20
>    Code in this driver inspired by and in a number of places taken
>    from Brian Warner's original Keyspan-PDA driver.
> diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
> index bf3297d..2d8baf6 100644
> --- a/drivers/usb/serial/keyspan.h
> +++ b/drivers/usb/serial/keyspan.h
> @@ -9,7 +9,7 @@
>    the Free Software Foundation; either version 2 of the License, or
>    (at your option) any later version.
> =20
> -  See http://misc.nu/hugh/keyspan.html for more information.
> +  See http://blemings.org/hugh/keyspan.html for more information.
>   =20
>    Code in this driver inspired by and in a number of places taken
>    from Brian Warner's original Keyspan-PDA driver.
> diff --git a/drivers/usb/serial/mct_u232.h b/drivers/usb/serial/mct_u232.=
h
> index 3a3f5e6..d325bb8 100644
> --- a/drivers/usb/serial/mct_u232.h
> +++ b/drivers/usb/serial/mct_u232.h
> @@ -10,10 +10,9 @@
>   *
>   * This driver is for the device MCT USB-RS232 Converter (25 pin, Model =
No.
>   * U232-P25) from Magic Control Technology Corp. (there is also a 9 pin
> - * Model No. U232-P9). See http://www.mct.com.tw/p_u232.html for further
> - * information. The properties of this device are listed at the end of t=
his
> - * file. This device is available from various distributors. I know Hana=
,
> - * http://www.hana.de and D-Link, http://www.dlink.com/products/usb/dsbs=
25.
> + * Model No. U232-P9). See http://www.mct.com.tw/products/product_us232.=
html=20
> + * for further information. The properties of this device are listed at =
the end=20
> + * of this file. This device was used in the Dlink DSB-S25.
>   *
>   * All of the information about the device was acquired by using SniffUS=
B
>   * on Windows98. The technical details of the reverse engineering are
> @@ -458,7 +457,7 @@ static int mct_u232_calculate_baud_rate(struct usb_se=
rial *serial,
>   * embedded UART.  Exhaustive documentation for these is available at:
>   *
>   *   http://www.semiconductors.philips.com/pip/p87c52ubaa
> - *   http://www.semiconductors.philips.com/pip/pdiusbd12
> + *   http://www.nxp.com/acrobat_download/various/PDIUSBD12_PROGRAMMING_G=
UIDE.pdf
>   *
>   * Thanks to Julian Highfield for the pointer to the Philips database.
>   *
> diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
> index 8a372ba..b356e15 100644
> --- a/drivers/usb/storage/Kconfig
> +++ b/drivers/usb/storage/Kconfig
> @@ -36,7 +36,7 @@ config USB_STORAGE_DATAFAB
>  =09depends on USB_STORAGE
>  =09help
>  =09  Support for certain Datafab CompactFlash readers.
> -=09  Datafab has a web page at <http://www.datafabusa.com/>.
> +=09  Datafab has a web page at <http://www.datafab.com/>.
> =20
>  =09  If this driver is compiled as a module, it will be named ums-datafa=
b.
> =20
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 8b31fdf..dc06ff1 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -49,7 +49,7 @@ menuconfig FB
>  =09  You need an utility program called fbset to make full use of frame
>  =09  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
>  =09  and the Framebuffer-HOWTO at
> -=09  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html> f=
or more
> +=09  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html> f=
or more
>  =09  information.
> =20
>  =09  Say Y here and to the driver for your graphics board below if you
> @@ -955,7 +955,7 @@ config FB_EPSON1355
>  =09  Build in support for the SED1355 Epson Research Embedded RAMDAC
>  =09  LCD/CRT Controller (since redesignated as the S1D13505) as a
>  =09  framebuffer.  Product specs at
> -=09  <http://www.erd.epson.com/vdc/html/products.htm>.
> +=09  <http://vdc.epson.com/>.
> =20
>  config FB_S1D13XXX
>  =09tristate "Epson S1D13XXX framebuffer support"
> @@ -966,7 +966,7 @@ config FB_S1D13XXX
>  =09help
>  =09  Support for S1D13XXX framebuffer device family (currently only
>  =09  working with S1D13806). Product specs at
> -=09  <http://www.erd.epson.com/vdc/html/legacy_13xxx.htm>
> +=09  <http://vdc.epson.com/>
> =20
>  config FB_ATMEL
>  =09tristate "AT91/AT32 LCD Controller support"
> @@ -1323,7 +1323,7 @@ config FB_RADEON
>  =09  don't need to choose this to run the Radeon in plain VGA mode.
> =20
>  =09  There is a product page at
> -=09  http://apps.ati.com/ATIcompare/
> +=09  http://products.amd.com/en-us/GraphicCardResult.aspx
> =20
>  config FB_RADEON_I2C
>  =09bool "DDC/I2C for ATI Radeon support"
> @@ -1395,7 +1395,7 @@ config FB_ATY_CT
>  =09  Say Y here to support use of ATI's 64-bit Rage boards (or other
>  =09  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
>  =09  framebuffer device.  The ATI product support page for these boards
> -=09  is at <http://support.ati.com/products/pc/mach64/>.
> +=09  is at <http://support.ati.com/products/pc/mach64/mach64.html>.
> =20
>  config FB_ATY_GENERIC_LCD
>  =09bool "Mach64 generic LCD support (EXPERIMENTAL)"
> diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
> index f3d7440..3ec4923 100644
> --- a/drivers/video/arcfb.c
> +++ b/drivers/video/arcfb.c
> @@ -2,7 +2,6 @@
>   * linux/drivers/video/arcfb.c -- FB driver for Arc monochrome LCD board
>   *
>   * Copyright (C) 2005, Jaya Kumar <jayalk@intworks.biz>
> - * http://www.intworks.biz/arclcd
>   *
>   * This file is subject to the terms and conditions of the GNU General P=
ublic
>   * License. See the file COPYING in the main directory of this archive f=
or
> diff --git a/drivers/video/epson1355fb.c b/drivers/video/epson1355fb.c
> index db9713b..a268cbf 100644
> --- a/drivers/video/epson1355fb.c
> +++ b/drivers/video/epson1355fb.c
> @@ -4,7 +4,7 @@
>   * Epson Research S1D13505 Embedded RAMDAC LCD/CRT Controller
>   *   (previously known as SED1355)
>   *
> - * Cf. http://www.erd.epson.com/vdc/html/S1D13505.html
> + * Cf. http://vdc.epson.com/
>   *
>   *
>   * Copyright (C) Hewlett-Packard Company.  All rights reserved.
> diff --git a/drivers/video/fbcvt.c b/drivers/video/fbcvt.c
> index 7293eac..7cb715d 100644
> --- a/drivers/video/fbcvt.c
> +++ b/drivers/video/fbcvt.c
> @@ -5,7 +5,7 @@
>   *
>   *      Based from the VESA(TM) Coordinated Video Timing Generator by
>   *      Graham Loveridge April 9, 2003 available at
> - *      http://www.vesa.org/public/CVT/CVTd6r1.xls
> + *      http://www.elo.utfsm.cl/~elo212/docs/CVTd6r1.xls
>   *
>   * This file is subject to the terms and conditions of the GNU General P=
ublic
>   * License.  See the file COPYING in the main directory of this archive
> diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
> index c77bcc6..e225c00 100644
> --- a/drivers/video/hecubafb.c
> +++ b/drivers/video/hecubafb.c
> @@ -10,7 +10,7 @@
>   *
>   * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoev=
en.
>   * This work was possible because of apollo display code from E-Ink's we=
bsite
> - * http://support.eink.com/community
> + * http://eink.com/
>   * All information used to write this code is from public material made
>   * available by E-Ink on its support site. Some commands such as 0xA4
>   * were found by looping through cmd=3D0x00 thru 0xFF and supplying rand=
om
> diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
> index 9b3d6e4..63ed3b7 100644
> --- a/drivers/video/metronomefb.c
> +++ b/drivers/video/metronomefb.c
> @@ -10,7 +10,7 @@
>   * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoev=
en.
>   *
>   * This work was made possible by help and equipment support from E-Ink
> - * Corporation. http://support.eink.com/community
> + * Corporation. http://www.eink.com/
>   *
>   * This driver is written to be used with the Metronome display controll=
er.
>   * It is intended to be architecture independent. A board specific drive=
r
> diff --git a/firmware/keyspan_pda/keyspan_pda.S b/firmware/keyspan_pda/ke=
yspan_pda.S
> index 418fe69..f3acc19 100644
> --- a/firmware/keyspan_pda/keyspan_pda.S
> +++ b/firmware/keyspan_pda/keyspan_pda.S
> @@ -74,7 +74,7 @@
>   *  recognizes the new device ID and glues it to the real serial driver =
code.
>   *
>   * USEFUL DOCS:
> - *  EzUSB Technical Reference Manual: <http://www.anchorchips.com>
> + *  EzUSB Technical Reference Manual: <http://www.cypress.com/>
>   *  8051 manuals: everywhere, but try www.dalsemi.com because the EzUSB =
is
>   *   basically the Dallas enhanced 8051 code. Remember that the EzUSB IO=
 ports
>   *   use totally different registers!
> diff --git a/firmware/keyspan_pda/xircom_pgs.S b/firmware/keyspan_pda/xir=
com_pgs.S
> index 05d99dd..0b79bbf 100644
> --- a/firmware/keyspan_pda/xircom_pgs.S
> +++ b/firmware/keyspan_pda/xircom_pgs.S
> @@ -74,7 +74,7 @@
>   *  recognizes the new device ID and glues it to the real serial driver =
code.
>   *
>   * USEFUL DOCS:
> - *  EzUSB Technical Reference Manual: <http://www.anchorchips.com>
> + *  EzUSB Technical Reference Manual: <http://www.cypress.com/>
>   *  8051 manuals: everywhere, but try www.dalsemi.com because the EzUSB =
is
>   *   basically the Dallas enhanced 8051 code. Remember that the EzUSB IO=
 ports
>   *   use totally different registers!
> diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
> index 6bbd75c..7c232c1 100644
> --- a/fs/hostfs/hostfs.h
> +++ b/fs/hostfs/hostfs.h
> @@ -28,12 +28,7 @@
>   * #define ATTR_KILL_SUID=092048
>   * #define ATTR_KILL_SGID=094096
>   *
> - * and this is because they were added in 2.5 development in this patch:
> - *
> - * http://linux.bkbits.net:8080/linux-2.5/
> - * cset@3caf4a12k4XgDzK7wyK-TGpSZ9u2Ww?nav=3Dindex.html
> - * |src/.|src/include|src/include/linux|related/include/linux/fs.h
> - *
> + * and this is because they were added in 2.5 development.
>   * Actually, they are not needed by most ->setattr() methods - they are =
set by
>   * callers of notify_change() to notify that the setuid/setgid bits must=
 be
>   * dropped.
> diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
> index 5bf8a04..789c625 100644
> --- a/fs/partitions/ldm.c
> +++ b/fs/partitions/ldm.c
> @@ -5,7 +5,7 @@
>   * Copyright (c) 2001-2007 Anton Altaparmakov
>   * Copyright (C) 2001,2002 Jakob Kemi <jakob.kemi@telia.com>
>   *
> - * Documentation is available at http://www.linux-ntfs.org/content/view/=
19/37/
> + * Documentation is available at http://www.linux-ntfs.org/doku.php?id=
=3Ddownloads=20
>   *
>   * This program is free software; you can redistribute it and/or modify =
it under
>   * the terms of the GNU General Public License as published by the Free =
Software
> diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
> index d1fb50b..374242c 100644
> --- a/fs/partitions/ldm.h
> +++ b/fs/partitions/ldm.h
> @@ -5,7 +5,7 @@
>   * Copyright (c) 2001-2007 Anton Altaparmakov
>   * Copyright (C) 2001,2002 Jakob Kemi <jakob.kemi@telia.com>
>   *
> - * Documentation is available at http://www.linux-ntfs.org/content/view/=
19/37/
> + * Documentation is available at http://www.linux-ntfs.org/doku.php?id=
=3Ddownloads=20
>   *
>   * This program is free software; you can redistribute it and/or modify =
it
>   * under the terms of the GNU General Public License as published by the=
 Free
> diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
> index 513f431..7cd4666 100644
> --- a/fs/reiserfs/Kconfig
> +++ b/fs/reiserfs/Kconfig
> @@ -10,7 +10,8 @@ config REISERFS_FS
> =20
>  =09  In general, ReiserFS is as fast as ext2, but is very efficient with
>  =09  large directories and small files.  Additional patches are needed
> -=09  for NFS and quotas, please see <http://www.namesys.com/> for links.
> +=09  for NFS and quotas, please see=20
> +=09  <https://reiser4.wiki.kernel.org/index.php/Main_Page> for links.
> =20
>  =09  It is more easily extended to have features currently found in
>  =09  database and keyword search systems than block allocation based fil=
e
> @@ -18,7 +19,8 @@ config REISERFS_FS
>  =09  plugins consistent with our motto ``It takes more than a license to
>  =09  make source code open.''
> =20
> -=09  Read <http://www.namesys.com/> to learn more about reiserfs.
> +=09  Read <https://reiser4.wiki.kernel.org/index.php/Main_Page>=20
> +=09  to learn more about reiserfs.
> =20
>  =09  Sponsored by Threshold Networks, Emusic.com, and Bigstorage.com.
> =20
> diff --git a/fs/reiserfs/README b/fs/reiserfs/README
> index 14e8c9d..e2f7a26 100644
> --- a/fs/reiserfs/README
> +++ b/fs/reiserfs/README
> @@ -43,7 +43,7 @@ to address the fair crediting issue in the next GPL ver=
sion.)
>  [END LICENSING]
> =20
>  Reiserfs is a file system based on balanced tree algorithms, which is
> -described at http://devlinux.com/namesys.
> +described at https://reiser4.wiki.kernel.org/index.php/Main_Page=20
> =20
>  Stop reading here.  Go there, then return.
> =20
> diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
> index 4086b8e..da2530e 100644
> --- a/include/crypto/gf128mul.h
> +++ b/include/crypto/gf128mul.h
> @@ -54,8 +54,8 @@
> =20
>  /* Comment by Rik:
>   *
> - * For some background on GF(2^128) see for example: http://-
> - * csrc.nist.gov/CryptoToolkit/modes/proposedmodes/gcm/gcm-revised-spec.=
pdf
> + * For some background on GF(2^128) see for example:=20
> + * http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/gc=
m/gcm-revised-spec.pdf=20
>   *
>   * The elements of GF(2^128) :=3D GF(2)[X]/(X^128-X^7-X^2-X^1-1) can
>   * be mapped to computer memory in a variety of ways. Let's examine
> diff --git a/include/linux/fdreg.h b/include/linux/fdreg.h
> index c2eeb63..61ce641 100644
> --- a/include/linux/fdreg.h
> +++ b/include/linux/fdreg.h
> @@ -89,7 +89,7 @@
>  /* the following commands are new in the 82078. They are not used in the
>   * floppy driver, except the first three. These commands may be useful f=
or apps
>   * which use the FDRAWCMD interface. For doc, get the 82078 spec sheets =
at
> - * http://www-techdoc.intel.com/docs/periph/fd_contr/datasheets/ */
> + * http://www.intel.com/design/archives/periphrl/docs/29046803.htm */
> =20
>  #define FD_PARTID=09=090x18=09/* part id ("extended" version cmd) */
>  #define FD_SAVE=09=09=090x2e=09/* save fdc regs for later restore */
> diff --git a/include/linux/if_infiniband.h b/include/linux/if_infiniband.=
h
> index 3e659ec..7d95847 100644
> --- a/include/linux/if_infiniband.h
> +++ b/include/linux/if_infiniband.h
> @@ -5,7 +5,7 @@
>   * <http://www.fsf.org/copyleft/gpl.html>, or the OpenIB.org BSD
>   * license, available in the LICENSE.TXT file accompanying this
>   * software.  These details are also available at
> - * <http://openib.org/license.html>.
> + * <http://www.openfabrics.org/software_license.htm>.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/include/linux/n_r3964.h b/include/linux/n_r3964.h
> index de24af7..54b8e0d 100644
> --- a/include/linux/n_r3964.h
> +++ b/include/linux/n_r3964.h
> @@ -4,7 +4,6 @@
>   * Copyright by
>   * Philips Automation Projects
>   * Kassel (Germany)
> - * http://www.pap-philips.de
>   * -----------------------------------------------------------
>   * This software may be used and distributed according to the terms of
>   * the GNU General Public License, incorporated herein by reference.
> diff --git a/net/ax25/Kconfig b/net/ax25/Kconfig
> index 2a72aa9..705e53e 100644
> --- a/net/ax25/Kconfig
> +++ b/net/ax25/Kconfig
> @@ -7,7 +7,7 @@ menuconfig HAMRADIO
>  =09bool "Amateur Radio support"
>  =09help
>  =09  If you want to connect your Linux box to an amateur radio, answer Y
> -=09  here. You want to read <http://www.tapr.org/tapr/html/pkthome.html>
> +=09  here. You want to read <http://www.tapr.org/>
>  =09  and more specifically about AX.25 on Linux
>  =09  <http://www.linux-ax25.org/>.
> =20
> @@ -42,7 +42,7 @@ config AX25
>  =09  check out the file <file:Documentation/networking/ax25.txt> in the
>  =09  kernel source. More information about digital amateur radio in
>  =09  general is on the WWW at
> -=09  <http://www.tapr.org/tapr/html/pkthome.html>.
> +=09  <http://www.tapr.org/>.
> =20
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called ax25.
> @@ -89,7 +89,7 @@ config NETROM
>  =09  <http://www.linux-ax25.org>. You also might want to check out the
>  =09  file <file:Documentation/networking/ax25.txt>. More information abo=
ut
>  =09  digital amateur radio in general is on the WWW at
> -=09  <http://www.tapr.org/tapr/html/pkthome.html>.
> +=09  <http://www.tapr.org/>.
> =20
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called netrom.
> @@ -108,7 +108,7 @@ config ROSE
>  =09  <http://www.linux-ax25.org>.  You also might want to check out the
>  =09  file <file:Documentation/networking/ax25.txt>. More information abo=
ut
>  =09  digital amateur radio in general is on the WWW at
> -=09  <http://www.tapr.org/tapr/html/pkthome.html>.
> +=09  <http://www.tapr.org/>.
> =20
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called rose.
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 571f895..4123d5b 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -84,7 +84,7 @@ config IP_FIB_TRIE
> =20
>  =09  An experimental study of compression methods for dynamic tries
>  =09  Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
> -=09  http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
> +=09  <http://www.csc.kth.se/~snilsson/software/dyntrie2/>
> =20
>  endchoice
> =20
> @@ -555,7 +555,7 @@ config TCP_CONG_VENO
>  =09distinguishing to circumvent the difficult judgment of the packet los=
s
>  =09type. TCP Veno cuts down less congestion window in response to random
>  =09loss packets.
> -=09See http://www.ntu.edu.sg/home5/ZHOU0022/papers/CPFu03a.pdf
> +=09See <http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=3D117718=
6>=20
> =20
>  config TCP_CONG_YEAH
>  =09tristate "YeAH TCP"
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 3a92a76..094e150 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -9,7 +9,7 @@
>   *
>   * The CIPSO draft specification can be found in the kernel's Documentat=
ion
>   * directory as well as the following URL:
> - *   http://netlabel.sourceforge.net/files/draft-ietf-cipso-ipsecurity-0=
1.txt
> + *   http://tools.ietf.org/id/draft-ietf-cipso-ipsecurity-01.txt
>   * The FIPS-188 specification can be found at the following URL:
>   *   http://www.itl.nist.gov/fipspubs/fip188.htm
>   *
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 4a8e370..d9818c5 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -16,7 +16,7 @@
>   *
>   * An experimental study of compression methods for dynamic tries
>   * Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
> - * http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
> + * http://www.csc.kth.se/~snilsson/software/dyntrie2/
>   *
>   *
>   * IP-address lookup using LC-tries. Stefan Nilsson and Gunnar Karlsson
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 1833bdb..d048275 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -147,7 +147,7 @@ config IP_NF_TARGET_ULOG
>  =09  which can only be viewed through syslog.
> =20
>  =09  The appropriate userspace logging daemon (ulogd) may be obtained fr=
om
> -=09  <http://www.gnumonks.org/projects/ulogd/>
> +=09  <http://www.netfilter.org/projects/ulogd/index.html>
> =20
>  =09  To compile it as a module, choose M here.  If unsure, say N.
> =20
> diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
> index 1eba160..00ca688 100644
> --- a/net/ipv4/tcp_illinois.c
> +++ b/net/ipv4/tcp_illinois.c
> @@ -6,7 +6,7 @@
>   * The algorithm is described in:
>   * "TCP-Illinois: A Loss and Delay-Based Congestion Control Algorithm
>   *  for High-Speed Networks"
> - * http://www.ews.uiuc.edu/~shaoliu/papersandslides/liubassri06perf.pdf
> + * http://www.ifp.illinois.edu/~srikant/Papers/liubassri06perf.pdf
>   *
>   * Implemented from description in paper and ns-2 simulation.
>   * Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org=
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index e663b78..bccce34 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -428,10 +428,10 @@ EXPORT_SYMBOL(tcp_initialize_rcv_mss);
>   *
>   * The algorithm for RTT estimation w/o timestamps is based on
>   * Dynamic Right-Sizing (DRS) by Wu Feng and Mike Fisk of LANL.
> - * <http://www.lanl.gov/radiant/website/pubs/drs/lacsi2001.ps>
> + * <http://public.lanl.gov/radiant/pubs.html#DRS>
>   *
>   * More detail on this code can be found at
> - * <http://www.psc.edu/~jheffner/senior_thesis.ps>,
> + * <http://staff.psc.edu/jheffner/>,
>   * though this reference is out of date.  A new paper
>   * is pending.
>   */
> diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
> index b612acf..38bc0b5 100644
> --- a/net/ipv4/tcp_veno.c
> +++ b/net/ipv4/tcp_veno.c
> @@ -6,7 +6,7 @@
>   *    "TCP Veno: TCP Enhancement for Transmission over Wireless Access N=
etworks."
>   *    IEEE Journal on Selected Areas in Communication,
>   *    Feb. 2003.
> - * =09See http://www.ntu.edu.sg/home5/ZHOU0022/papers/CPFu03a.pdf
> + * =09See http://www.ie.cuhk.edu.hk/fileadmin/staff_upload/soung/Journal=
/J3.pdf
>   */
> =20
>  #include <linux/mm.h>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_co=
nntrack_proto_tcp.c
> index c4c885d..3fb2b73 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -329,8 +329,8 @@ static unsigned int get_conntrack_index(const struct =
tcphdr *tcph)
>  /* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
>     in IP Filter' by Guido van Rooij.
> =20
> -   http://www.nluug.nl/events/sane2000/papers.html
> -   http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
> +   http://www.sane.nl/events/sane2000/papers.html
> +   http://www.darkart.com/mirrors/www.obfuscation.org/ipf/
> =20
>     The boundaries and the conditions are changed according to RFC793:
>     the packet must intersect the window (i.e. segments may be
> diff --git a/sound/oss/ac97_codec.c b/sound/oss/ac97_codec.c
> index 456a1b4..854c303 100644
> --- a/sound/oss/ac97_codec.c
> +++ b/sound/oss/ac97_codec.c
> @@ -21,11 +21,8 @@
>   *
>   ***********************************************************************=
***
>   *
> - * The Intel Audio Codec '97 specification is available at the Intel
> - * audio homepage: http://developer.intel.com/ial/scalableplatforms/audi=
o/
> - *
> - * The specification itself is currently available at:
> - * ftp://download.intel.com/ial/scalableplatforms/ac97r22.pdf
> + * The Intel Audio Codec '97 specification is available at:
> + * http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pd=
f
>   *
>   ***********************************************************************=
***
>   *
> diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
> index c7fba53..537cfba 100644
> --- a/sound/pci/ens1370.c
> +++ b/sound/pci/ens1370.c
> @@ -22,7 +22,7 @@
>  /* Power-Management-Code ( CONFIG_PM )
>   * for ens1371 only ( FIXME )
>   * derived from cs4281.c, atiixp.c and via82xx.c
> - * using http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c1540.=
htm
> + * using http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/=20
>   * by Kurt J. Bosch
>   */
> =20
> diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
> index 4677492..400f9eb 100644
> --- a/sound/pci/intel8x0.c
> +++ b/sound/pci/intel8x0.c
> @@ -716,7 +716,7 @@ static void snd_intel8x0_setup_periods(struct intel8x=
0 *chip, struct ichdev *ich
>   * Intel 82443MX running a 100MHz processor system bus has a hardware bu=
g,
>   * which aborts PCI busmaster for audio transfer.  A workaround is to se=
t
>   * the pages as non-cached.  For details, see the errata in
> - *=09http://www.intel.com/design/chipsets/specupdt/245051.htm
> + *=09http://download.intel.com/design/chipsets/specupdt/24505108.pdf
>   */
>  static void fill_nocache(void *buf, int size, int nocache)
>  {
>=20
--0-1719167625-1285654952=:276--
