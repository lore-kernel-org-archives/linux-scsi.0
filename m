From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sat, 10 Jan 2004 19:01:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0c1f01c3d7a3$d0ac9c00$060ba8c0@AldiP4>
References: <Pine.LNX.4.44.0401101348010.9458-100000@poirot.grange> <0bb601c3d78a$f3394020$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0C1C_01C3D7AC.32603B20"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout02.sul.t-online.com ([194.25.134.17]:19137 "EHLO
	mailout02.sul.t-online.com") by vger.kernel.org with ESMTP
	id S265294AbUAJSCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 13:02:13 -0500
Received: from AldiP4 (aldi-p4 [192.168.11.6])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by fileserver.ruhnau (Postfix) with ESMTP id 129631DEC7
	for <linux-scsi@vger.kernel.org>; Sat, 10 Jan 2004 19:02:31 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0C1C_01C3D7AC.32603B20
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I retract having a working 2.4.10 in the following sense:

I have a precompiled kernel 2.4.10 from SuSE-Linux 7.3. It worked before,
but I decided to install Gentoo as my new Linux-distribution. Now 2.4.10 is
only left on a boot disk set.
I can load the module for aha152x from these bootdisks and it works.

But I just tried to use a self-compiled 2.4.10 from the kernel.org sources
and it fails.
After "scsi0 : Adaptec 152x SCSI driver; $Revision: 2.4 $" I get a timeout
and a NULL-pointer dereference.
I now wonder, what my fault was during the installation/configuration.
I'll be happy, if someone finds time to have a look at my configuration.

Greetings
Kai


----- Original Message ----- 
From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-scsi@vger.kernel.org>
Sent: Saturday, January 10, 2004 4:03 PM
Subject: Re: Driver for Adaptec AHA-1530P


> Hi,
>
> Thank you for the quick reply!
>
> > Can you send the relevant lines from 2.4.10 boot?
>
> The kernel 2.4.10 is from a SuSE-Linux 7.3 boot-disk with the aha152x as
> module.
>
> Here is the log after I loaded the module:
>
> <snip>
> [...]
> [isapnp]
> aha152x: BIOS test: passed, auto configuration: ok, detected 1
controller(s)
> aha152x: resetting bus...
> aha152x0: vital data: rev=1, io=0x340 (0x340/0x340), irq=11, scsiid=7,
> reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000,
extended
> translation=disabled
> aha152x0: trying software interrupt, ok.
> scsi0 : Adaptec 152x SCSI driver; $Revision: 2.4 $
> (scsi0:0:0) 01 03 01 32 08 00
>   Vendor: IBM       Model: DCAS-34330        Rev: S65A
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> [my cdrom @ scsi0:5:0]
> [...]
> </snip>
>
> HTH
> Greetings
> Kai
>
> ----- Original Message ----- 
> From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
> To: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
> Cc: <linux-scsi@vger.kernel.org>
> Sent: Saturday, January 10, 2004 1:48 PM
> Subject: Re: Driver for Adaptec AHA-1530P
>
>
> > Hi
> >
> > Can you send the relevant lines from 2.4.10 boot?
> >
> > Cheers
> > Guennadi
> >
> > On Sat, 10 Jan 2004, Kai Ruhnau wrote:
> >
> > > Hi,
> > >
> > > I have an old scsi-only P200. It has an Adaptec AHA-1530P ISA-board.
> > >
> > > I had and have a running Kernel 2.4.10. It uses the driver aha152x
> > > successfully. I tried to update to 2.4.16, 2.4.20 and now I try
2.4.24.
> All
> > > show the same behaviour:
> > >
> > > Kernel-parameter: 'aha152x=0x340'
> > >
> > > <snip>
> > > SCSI subsystem driver Revision: 1.00
> > > aha152x: processing commandline: <3>
> > > aha152x: 0x340
> > > aha152x: Invalid line
> > > ok
> > > aha152x: BIOS test: passed, detected 1 controller(s)
> > > aha152x: resetting bus...
> > > aha152x0: vital data: rev=7, io=0x340 (0x340/0x340), irq=11, scsiid=7,
> > > reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000,
> extended
> > > translation=disabled
> > > aha152x0: trying software interrupt, ok.
> > > scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
> > > (long pause)
> > > aha152x: ABORT timed out - removed from issue queue
> > > scsi: device set offline - not ready or command retry failed after bus
> > > reset: host 0 channel 0 id 0 lun 0
> > > scsi: unknown type 22
> > > Vendor: [crap] Model: [more crap] Rev:
> > > Type: Unknown
> > > (again long pause)
> > > </snip>
> > >
> > > And the last seven lines count up the lun and the id up to 'id 7 lun
7'.
> > > After that, I end up with a kernel-panic due to the missing
root-device.
> > > The [crap] and [more crap] are always the same characters.
> > >
> > > In kernel 2.6.0 the aha152x-driver does not find any appropiate
device.
> Here
> > > I also tried the aha1542, but I can't read any error, it scrolls up
too
> > > fast.
> > >
> > >
> > > I know from the Changelogs that there were a couple of changes since
> 2.4.10,
> > > but is it possible to convince the aha152x (or any other) driver to
work
> > > with my card?
> > >
> > > Of course I'm willing to help everybody as I can.
> > >
> > > Greetings
> > > Kai
> > >
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > >
> >
> > ---
> > Guennadi Liakhovetski
> >
> >
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------=_NextPart_000_0C1C_01C3D7AC.32603B20
Content-Type: application/octet-stream;
	name="config.kai"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="config.kai"

#=0A=
# Automatically generated by make menuconfig: don't edit=0A=
#=0A=
CONFIG_X86=3Dy=0A=
CONFIG_ISA=3Dy=0A=
# CONFIG_SBUS is not set=0A=
CONFIG_UID16=3Dy=0A=
=0A=
#=0A=
# Code maturity level options=0A=
#=0A=
CONFIG_EXPERIMENTAL=3Dy=0A=
=0A=
#=0A=
# Loadable module support=0A=
#=0A=
CONFIG_MODULES=3Dy=0A=
CONFIG_MODVERSIONS=3Dy=0A=
CONFIG_KMOD=3Dy=0A=
=0A=
#=0A=
# Processor type and features=0A=
#=0A=
# CONFIG_M386 is not set=0A=
# CONFIG_M486 is not set=0A=
# CONFIG_M586 is not set=0A=
# CONFIG_M586TSC is not set=0A=
CONFIG_M586MMX=3Dy=0A=
# CONFIG_M686 is not set=0A=
# CONFIG_MPENTIUMIII is not set=0A=
# CONFIG_MPENTIUM4 is not set=0A=
# CONFIG_MK6 is not set=0A=
# CONFIG_MK7 is not set=0A=
# CONFIG_MCRUSOE is not set=0A=
# CONFIG_MWINCHIPC6 is not set=0A=
# CONFIG_MWINCHIP2 is not set=0A=
# CONFIG_MWINCHIP3D is not set=0A=
# CONFIG_MCYRIXIII is not set=0A=
CONFIG_X86_WP_WORKS_OK=3Dy=0A=
CONFIG_X86_INVLPG=3Dy=0A=
CONFIG_X86_CMPXCHG=3Dy=0A=
CONFIG_X86_XADD=3Dy=0A=
CONFIG_X86_BSWAP=3Dy=0A=
CONFIG_X86_POPAD_OK=3Dy=0A=
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set=0A=
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy=0A=
CONFIG_X86_L1_CACHE_SHIFT=3D5=0A=
CONFIG_X86_USE_STRING_486=3Dy=0A=
CONFIG_X86_ALIGNMENT_16=3Dy=0A=
CONFIG_X86_TSC=3Dy=0A=
CONFIG_X86_GOOD_APIC=3Dy=0A=
# CONFIG_TOSHIBA is not set=0A=
# CONFIG_MICROCODE is not set=0A=
# CONFIG_X86_MSR is not set=0A=
# CONFIG_X86_CPUID is not set=0A=
CONFIG_NOHIGHMEM=3Dy=0A=
# CONFIG_HIGHMEM4G is not set=0A=
# CONFIG_HIGHMEM64G is not set=0A=
# CONFIG_MATH_EMULATION is not set=0A=
# CONFIG_MTRR is not set=0A=
# CONFIG_SMP is not set=0A=
# CONFIG_X86_UP_IOAPIC is not set=0A=
=0A=
#=0A=
# General setup=0A=
#=0A=
CONFIG_NET=3Dy=0A=
CONFIG_PCI=3Dy=0A=
# CONFIG_PCI_GOBIOS is not set=0A=
# CONFIG_PCI_GODIRECT is not set=0A=
CONFIG_PCI_GOANY=3Dy=0A=
CONFIG_PCI_BIOS=3Dy=0A=
CONFIG_PCI_DIRECT=3Dy=0A=
CONFIG_PCI_NAMES=3Dy=0A=
# CONFIG_EISA is not set=0A=
# CONFIG_MCA is not set=0A=
# CONFIG_HOTPLUG is not set=0A=
# CONFIG_PCMCIA is not set=0A=
CONFIG_SYSVIPC=3Dy=0A=
CONFIG_BSD_PROCESS_ACCT=3Dy=0A=
CONFIG_SYSCTL=3Dy=0A=
CONFIG_KCORE_ELF=3Dy=0A=
# CONFIG_KCORE_AOUT is not set=0A=
CONFIG_BINFMT_AOUT=3Dy=0A=
CONFIG_BINFMT_ELF=3Dy=0A=
CONFIG_BINFMT_MISC=3Dy=0A=
# CONFIG_PM is not set=0A=
# CONFIG_ACPI is not set=0A=
# CONFIG_APM is not set=0A=
=0A=
#=0A=
# Memory Technology Devices (MTD)=0A=
#=0A=
# CONFIG_MTD is not set=0A=
=0A=
#=0A=
# Parallel port support=0A=
#=0A=
CONFIG_PARPORT=3Dm=0A=
CONFIG_PARPORT_PC=3Dm=0A=
CONFIG_PARPORT_PC_FIFO=3Dy=0A=
CONFIG_PARPORT_PC_SUPERIO=3Dy=0A=
# CONFIG_PARPORT_AMIGA is not set=0A=
# CONFIG_PARPORT_MFC3 is not set=0A=
# CONFIG_PARPORT_ATARI is not set=0A=
# CONFIG_PARPORT_SUNBPP is not set=0A=
# CONFIG_PARPORT_OTHER is not set=0A=
# CONFIG_PARPORT_1284 is not set=0A=
=0A=
#=0A=
# Plug and Play configuration=0A=
#=0A=
CONFIG_PNP=3Dy=0A=
CONFIG_ISAPNP=3Dy=0A=
# CONFIG_PNPBIOS is not set=0A=
=0A=
#=0A=
# Block devices=0A=
#=0A=
CONFIG_BLK_DEV_FD=3Dy=0A=
# CONFIG_BLK_DEV_XD is not set=0A=
# CONFIG_PARIDE is not set=0A=
# CONFIG_BLK_CPQ_DA is not set=0A=
# CONFIG_BLK_CPQ_CISS_DA is not set=0A=
# CONFIG_BLK_DEV_DAC960 is not set=0A=
CONFIG_BLK_DEV_LOOP=3Dy=0A=
CONFIG_BLK_DEV_NBD=3Dy=0A=
CONFIG_BLK_DEV_RAM=3Dm=0A=
CONFIG_BLK_DEV_RAM_SIZE=3D8192=0A=
# CONFIG_BLK_DEV_INITRD is not set=0A=
=0A=
#=0A=
# Multi-device support (RAID and LVM)=0A=
#=0A=
# CONFIG_MD is not set=0A=
# CONFIG_BLK_DEV_MD is not set=0A=
# CONFIG_MD_LINEAR is not set=0A=
# CONFIG_MD_RAID0 is not set=0A=
# CONFIG_MD_RAID1 is not set=0A=
# CONFIG_MD_RAID5 is not set=0A=
# CONFIG_MD_MULTIPATH is not set=0A=
# CONFIG_BLK_DEV_LVM is not set=0A=
=0A=
#=0A=
# Networking options=0A=
#=0A=
CONFIG_PACKET=3Dy=0A=
# CONFIG_PACKET_MMAP is not set=0A=
CONFIG_NETLINK=3Dy=0A=
CONFIG_RTNETLINK=3Dy=0A=
# CONFIG_NETLINK_DEV is not set=0A=
CONFIG_NETFILTER=3Dy=0A=
# CONFIG_NETFILTER_DEBUG is not set=0A=
# CONFIG_FILTER is not set=0A=
CONFIG_UNIX=3Dy=0A=
CONFIG_INET=3Dy=0A=
CONFIG_IP_MULTICAST=3Dy=0A=
CONFIG_IP_ADVANCED_ROUTER=3Dy=0A=
CONFIG_RTNETLINK=3Dy=0A=
CONFIG_NETLINK=3Dy=0A=
# CONFIG_IP_MULTIPLE_TABLES is not set=0A=
# CONFIG_IP_ROUTE_MULTIPATH is not set=0A=
CONFIG_IP_ROUTE_TOS=3Dy=0A=
# CONFIG_IP_ROUTE_VERBOSE is not set=0A=
# CONFIG_IP_ROUTE_LARGE_TABLES is not set=0A=
# CONFIG_IP_PNP is not set=0A=
CONFIG_NET_IPIP=3Dm=0A=
# CONFIG_NET_IPGRE is not set=0A=
# CONFIG_IP_MROUTE is not set=0A=
# CONFIG_ARPD is not set=0A=
# CONFIG_INET_ECN is not set=0A=
# CONFIG_SYN_COOKIES is not set=0A=
=0A=
#=0A=
#   IP: Netfilter Configuration=0A=
#=0A=
# CONFIG_IP_NF_CONNTRACK is not set=0A=
# CONFIG_IP_NF_QUEUE is not set=0A=
# CONFIG_IP_NF_IPTABLES is not set=0A=
# CONFIG_IP_NF_COMPAT_IPCHAINS is not set=0A=
# CONFIG_IP_NF_COMPAT_IPFWADM is not set=0A=
# CONFIG_IPV6 is not set=0A=
# CONFIG_KHTTPD is not set=0A=
# CONFIG_ATM is not set=0A=
# CONFIG_IPX is not set=0A=
# CONFIG_ATALK is not set=0A=
# CONFIG_DECNET is not set=0A=
# CONFIG_BRIDGE is not set=0A=
# CONFIG_X25 is not set=0A=
# CONFIG_LAPB is not set=0A=
# CONFIG_LLC is not set=0A=
# CONFIG_NET_DIVERT is not set=0A=
# CONFIG_ECONET is not set=0A=
# CONFIG_WAN_ROUTER is not set=0A=
# CONFIG_NET_FASTROUTE is not set=0A=
# CONFIG_NET_HW_FLOWCONTROL is not set=0A=
=0A=
#=0A=
# QoS and/or fair queueing=0A=
#=0A=
# CONFIG_NET_SCHED is not set=0A=
=0A=
#=0A=
# Telephony Support=0A=
#=0A=
# CONFIG_PHONE is not set=0A=
# CONFIG_PHONE_IXJ is not set=0A=
# CONFIG_PHONE_IXJ_PCMCIA is not set=0A=
=0A=
#=0A=
# ATA/IDE/MFM/RLL support=0A=
#=0A=
# CONFIG_IDE is not set=0A=
# CONFIG_BLK_DEV_IDE_MODES is not set=0A=
# CONFIG_BLK_DEV_HD is not set=0A=
=0A=
#=0A=
# SCSI support=0A=
#=0A=
CONFIG_SCSI=3Dy=0A=
CONFIG_BLK_DEV_SD=3Dy=0A=
CONFIG_SD_EXTRA_DEVS=3D40=0A=
# CONFIG_CHR_DEV_ST is not set=0A=
# CONFIG_CHR_DEV_OSST is not set=0A=
CONFIG_BLK_DEV_SR=3Dy=0A=
# CONFIG_BLK_DEV_SR_VENDOR is not set=0A=
CONFIG_SR_EXTRA_DEVS=3D2=0A=
# CONFIG_CHR_DEV_SG is not set=0A=
CONFIG_SCSI_DEBUG_QUEUES=3Dy=0A=
CONFIG_SCSI_MULTI_LUN=3Dy=0A=
CONFIG_SCSI_CONSTANTS=3Dy=0A=
# CONFIG_SCSI_LOGGING is not set=0A=
=0A=
#=0A=
# SCSI low-level drivers=0A=
#=0A=
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set=0A=
# CONFIG_SCSI_7000FASST is not set=0A=
# CONFIG_SCSI_ACARD is not set=0A=
CONFIG_SCSI_AHA152X=3Dy=0A=
# CONFIG_SCSI_AHA1542 is not set=0A=
# CONFIG_SCSI_AHA1740 is not set=0A=
# CONFIG_SCSI_AIC7XXX is not set=0A=
# CONFIG_SCSI_AIC7XXX_OLD is not set=0A=
# CONFIG_SCSI_DPT_I2O is not set=0A=
# CONFIG_SCSI_ADVANSYS is not set=0A=
# CONFIG_SCSI_IN2000 is not set=0A=
# CONFIG_SCSI_AM53C974 is not set=0A=
# CONFIG_SCSI_MEGARAID is not set=0A=
# CONFIG_SCSI_BUSLOGIC is not set=0A=
# CONFIG_SCSI_CPQFCTS is not set=0A=
# CONFIG_SCSI_DMX3191D is not set=0A=
# CONFIG_SCSI_DTC3280 is not set=0A=
# CONFIG_SCSI_EATA is not set=0A=
# CONFIG_SCSI_EATA_DMA is not set=0A=
# CONFIG_SCSI_EATA_PIO is not set=0A=
# CONFIG_SCSI_FUTURE_DOMAIN is not set=0A=
# CONFIG_SCSI_GDTH is not set=0A=
# CONFIG_SCSI_GENERIC_NCR5380 is not set=0A=
# CONFIG_SCSI_IPS is not set=0A=
# CONFIG_SCSI_INITIO is not set=0A=
# CONFIG_SCSI_INIA100 is not set=0A=
# CONFIG_SCSI_PPA is not set=0A=
# CONFIG_SCSI_IMM is not set=0A=
# CONFIG_SCSI_NCR53C406A is not set=0A=
# CONFIG_SCSI_NCR_D700 is not set=0A=
# CONFIG_SCSI_NCR53C7xx is not set=0A=
# CONFIG_SCSI_NCR53C8XX is not set=0A=
CONFIG_SCSI_SYM53C8XX=3Dy=0A=
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=3D4=0A=
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=3D32=0A=
CONFIG_SCSI_NCR53C8XX_SYNC=3D20=0A=
# CONFIG_SCSI_NCR53C8XX_PROFILE is not set=0A=
# CONFIG_SCSI_NCR53C8XX_IOMAPPED is not set=0A=
# CONFIG_SCSI_NCR53C8XX_PQS_PDS is not set=0A=
# CONFIG_SCSI_NCR53C8XX_SYMBIOS_COMPAT is not set=0A=
# CONFIG_SCSI_PAS16 is not set=0A=
# CONFIG_SCSI_PCI2000 is not set=0A=
# CONFIG_SCSI_PCI2220I is not set=0A=
# CONFIG_SCSI_PSI240I is not set=0A=
# CONFIG_SCSI_QLOGIC_FAS is not set=0A=
# CONFIG_SCSI_QLOGIC_ISP is not set=0A=
# CONFIG_SCSI_QLOGIC_FC is not set=0A=
# CONFIG_SCSI_QLOGIC_1280 is not set=0A=
# CONFIG_SCSI_SEAGATE is not set=0A=
# CONFIG_SCSI_SIM710 is not set=0A=
# CONFIG_SCSI_SYM53C416 is not set=0A=
# CONFIG_SCSI_DC390T is not set=0A=
# CONFIG_SCSI_T128 is not set=0A=
# CONFIG_SCSI_U14_34F is not set=0A=
# CONFIG_SCSI_ULTRASTOR is not set=0A=
# CONFIG_SCSI_DEBUG is not set=0A=
=0A=
#=0A=
# Fusion MPT device support=0A=
#=0A=
# CONFIG_FUSION is not set=0A=
# CONFIG_FUSION_BOOT is not set=0A=
# CONFIG_FUSION_ISENSE is not set=0A=
# CONFIG_FUSION_CTL is not set=0A=
# CONFIG_FUSION_LAN is not set=0A=
=0A=
#=0A=
# IEEE 1394 (FireWire) support (EXPERIMENTAL)=0A=
#=0A=
# CONFIG_IEEE1394 is not set=0A=
=0A=
#=0A=
# I2O device support=0A=
#=0A=
# CONFIG_I2O is not set=0A=
# CONFIG_I2O_PCI is not set=0A=
# CONFIG_I2O_BLOCK is not set=0A=
# CONFIG_I2O_LAN is not set=0A=
# CONFIG_I2O_SCSI is not set=0A=
# CONFIG_I2O_PROC is not set=0A=
=0A=
#=0A=
# Network device support=0A=
#=0A=
CONFIG_NETDEVICES=3Dy=0A=
=0A=
#=0A=
# ARCnet devices=0A=
#=0A=
# CONFIG_ARCNET is not set=0A=
CONFIG_DUMMY=3Dm=0A=
# CONFIG_BONDING is not set=0A=
# CONFIG_EQUALIZER is not set=0A=
# CONFIG_TUN is not set=0A=
# CONFIG_ETHERTAP is not set=0A=
# CONFIG_NET_SB1000 is not set=0A=
=0A=
#=0A=
# Ethernet (10 or 100Mbit)=0A=
#=0A=
CONFIG_NET_ETHERNET=3Dy=0A=
# CONFIG_SUNLANCE is not set=0A=
# CONFIG_HAPPYMEAL is not set=0A=
# CONFIG_SUNBMAC is not set=0A=
# CONFIG_SUNQE is not set=0A=
# CONFIG_SUNLANCE is not set=0A=
# CONFIG_SUNGEM is not set=0A=
CONFIG_NET_VENDOR_3COM=3Dy=0A=
# CONFIG_EL1 is not set=0A=
# CONFIG_EL2 is not set=0A=
# CONFIG_ELPLUS is not set=0A=
# CONFIG_EL16 is not set=0A=
CONFIG_EL3=3Dy=0A=
# CONFIG_3C515 is not set=0A=
# CONFIG_ELMC is not set=0A=
# CONFIG_ELMC_II is not set=0A=
# CONFIG_VORTEX is not set=0A=
# CONFIG_LANCE is not set=0A=
# CONFIG_NET_VENDOR_SMC is not set=0A=
# CONFIG_NET_VENDOR_RACAL is not set=0A=
# CONFIG_AT1700 is not set=0A=
# CONFIG_DEPCA is not set=0A=
# CONFIG_HP100 is not set=0A=
# CONFIG_NET_ISA is not set=0A=
# CONFIG_NET_PCI is not set=0A=
# CONFIG_NET_POCKET is not set=0A=
=0A=
#=0A=
# Ethernet (1000 Mbit)=0A=
#=0A=
# CONFIG_ACENIC is not set=0A=
# CONFIG_DL2K is not set=0A=
# CONFIG_MYRI_SBUS is not set=0A=
# CONFIG_NS83820 is not set=0A=
# CONFIG_HAMACHI is not set=0A=
# CONFIG_YELLOWFIN is not set=0A=
# CONFIG_SK98LIN is not set=0A=
# CONFIG_FDDI is not set=0A=
# CONFIG_HIPPI is not set=0A=
# CONFIG_PLIP is not set=0A=
CONFIG_PPP=3Dm=0A=
# CONFIG_PPP_MULTILINK is not set=0A=
# CONFIG_PPP_FILTER is not set=0A=
# CONFIG_PPP_ASYNC is not set=0A=
# CONFIG_PPP_SYNC_TTY is not set=0A=
# CONFIG_PPP_DEFLATE is not set=0A=
# CONFIG_PPP_BSDCOMP is not set=0A=
CONFIG_PPPOE=3Dm=0A=
# CONFIG_SLIP is not set=0A=
=0A=
#=0A=
# Wireless LAN (non-hamradio)=0A=
#=0A=
# CONFIG_NET_RADIO is not set=0A=
=0A=
#=0A=
# Token Ring devices=0A=
#=0A=
# CONFIG_TR is not set=0A=
# CONFIG_NET_FC is not set=0A=
# CONFIG_RCPCI is not set=0A=
# CONFIG_SHAPER is not set=0A=
=0A=
#=0A=
# Wan interfaces=0A=
#=0A=
# CONFIG_WAN is not set=0A=
=0A=
#=0A=
# Amateur Radio support=0A=
#=0A=
# CONFIG_HAMRADIO is not set=0A=
=0A=
#=0A=
# IrDA (infrared) support=0A=
#=0A=
# CONFIG_IRDA is not set=0A=
=0A=
#=0A=
# ISDN subsystem=0A=
#=0A=
# CONFIG_ISDN is not set=0A=
=0A=
#=0A=
# Old CD-ROM drivers (not SCSI, not IDE)=0A=
#=0A=
# CONFIG_CD_NO_IDESCSI is not set=0A=
=0A=
#=0A=
# Input core support=0A=
#=0A=
# CONFIG_INPUT is not set=0A=
# CONFIG_INPUT_KEYBDEV is not set=0A=
# CONFIG_INPUT_MOUSEDEV is not set=0A=
# CONFIG_INPUT_JOYDEV is not set=0A=
# CONFIG_INPUT_EVDEV is not set=0A=
=0A=
#=0A=
# Character devices=0A=
#=0A=
CONFIG_VT=3Dy=0A=
CONFIG_VT_CONSOLE=3Dy=0A=
# CONFIG_SERIAL is not set=0A=
# CONFIG_SERIAL_EXTENDED is not set=0A=
# CONFIG_SERIAL_NONSTANDARD is not set=0A=
CONFIG_UNIX98_PTYS=3Dy=0A=
CONFIG_UNIX98_PTY_COUNT=3D256=0A=
CONFIG_PRINTER=3Dm=0A=
# CONFIG_LP_CONSOLE is not set=0A=
# CONFIG_PPDEV is not set=0A=
=0A=
#=0A=
# I2C support=0A=
#=0A=
# CONFIG_I2C is not set=0A=
=0A=
#=0A=
# Mice=0A=
#=0A=
# CONFIG_BUSMOUSE is not set=0A=
# CONFIG_MOUSE is not set=0A=
=0A=
#=0A=
# Joysticks=0A=
#=0A=
# CONFIG_INPUT_GAMEPORT is not set=0A=
# CONFIG_QIC02_TAPE is not set=0A=
=0A=
#=0A=
# Watchdog Cards=0A=
#=0A=
# CONFIG_WATCHDOG is not set=0A=
# CONFIG_INTEL_RNG is not set=0A=
# CONFIG_NVRAM is not set=0A=
# CONFIG_RTC is not set=0A=
# CONFIG_DTLK is not set=0A=
# CONFIG_R3964 is not set=0A=
# CONFIG_APPLICOM is not set=0A=
# CONFIG_SONYPI is not set=0A=
=0A=
#=0A=
# Ftape, the floppy tape device driver=0A=
#=0A=
# CONFIG_FTAPE is not set=0A=
# CONFIG_AGP is not set=0A=
# CONFIG_DRM is not set=0A=
=0A=
#=0A=
# Multimedia devices=0A=
#=0A=
# CONFIG_VIDEO_DEV is not set=0A=
=0A=
#=0A=
# File systems=0A=
#=0A=
# CONFIG_QUOTA is not set=0A=
# CONFIG_AUTOFS_FS is not set=0A=
CONFIG_AUTOFS4_FS=3Dy=0A=
# CONFIG_REISERFS_FS is not set=0A=
# CONFIG_REISERFS_CHECK is not set=0A=
# CONFIG_ADFS_FS is not set=0A=
# CONFIG_ADFS_FS_RW is not set=0A=
# CONFIG_AFFS_FS is not set=0A=
# CONFIG_HFS_FS is not set=0A=
# CONFIG_BFS_FS is not set=0A=
CONFIG_FAT_FS=3Dm=0A=
# CONFIG_MSDOS_FS is not set=0A=
# CONFIG_UMSDOS_FS is not set=0A=
CONFIG_VFAT_FS=3Dm=0A=
# CONFIG_EFS_FS is not set=0A=
# CONFIG_JFFS_FS is not set=0A=
# CONFIG_CRAMFS is not set=0A=
CONFIG_TMPFS=3Dy=0A=
# CONFIG_RAMFS is not set=0A=
CONFIG_ISO9660_FS=3Dy=0A=
# CONFIG_JOLIET is not set=0A=
# CONFIG_MINIX_FS is not set=0A=
# CONFIG_VXFS_FS is not set=0A=
# CONFIG_NTFS_FS is not set=0A=
# CONFIG_NTFS_RW is not set=0A=
# CONFIG_HPFS_FS is not set=0A=
CONFIG_PROC_FS=3Dy=0A=
CONFIG_DEVFS_FS=3Dy=0A=
# CONFIG_DEVFS_MOUNT is not set=0A=
# CONFIG_DEVFS_DEBUG is not set=0A=
CONFIG_DEVPTS_FS=3Dy=0A=
# CONFIG_QNX4FS_FS is not set=0A=
# CONFIG_QNX4FS_RW is not set=0A=
# CONFIG_ROMFS_FS is not set=0A=
CONFIG_EXT2_FS=3Dy=0A=
# CONFIG_SYSV_FS is not set=0A=
# CONFIG_UDF_FS is not set=0A=
# CONFIG_UDF_RW is not set=0A=
# CONFIG_UFS_FS is not set=0A=
# CONFIG_UFS_FS_WRITE is not set=0A=
=0A=
#=0A=
# Network File Systems=0A=
#=0A=
# CONFIG_CODA_FS is not set=0A=
CONFIG_NFS_FS=3Dy=0A=
# CONFIG_NFS_V3 is not set=0A=
# CONFIG_ROOT_NFS is not set=0A=
CONFIG_NFSD=3Dy=0A=
# CONFIG_NFSD_V3 is not set=0A=
CONFIG_SUNRPC=3Dy=0A=
CONFIG_LOCKD=3Dy=0A=
CONFIG_SMB_FS=3Dm=0A=
# CONFIG_SMB_NLS_DEFAULT is not set=0A=
# CONFIG_NCP_FS is not set=0A=
# CONFIG_NCPFS_PACKET_SIGNING is not set=0A=
# CONFIG_NCPFS_IOCTL_LOCKING is not set=0A=
# CONFIG_NCPFS_STRONG is not set=0A=
# CONFIG_NCPFS_NFS_NS is not set=0A=
# CONFIG_NCPFS_OS2_NS is not set=0A=
# CONFIG_NCPFS_SMALLDOS is not set=0A=
# CONFIG_NCPFS_NLS is not set=0A=
# CONFIG_NCPFS_EXTRAS is not set=0A=
=0A=
#=0A=
# Partition Types=0A=
#=0A=
# CONFIG_PARTITION_ADVANCED is not set=0A=
CONFIG_MSDOS_PARTITION=3Dy=0A=
CONFIG_SMB_NLS=3Dy=0A=
CONFIG_NLS=3Dy=0A=
=0A=
#=0A=
# Native Language Support=0A=
#=0A=
CONFIG_NLS_DEFAULT=3D"iso8859-1"=0A=
CONFIG_NLS_CODEPAGE_437=3Dm=0A=
CONFIG_NLS_CODEPAGE_737=3Dm=0A=
CONFIG_NLS_CODEPAGE_775=3Dm=0A=
CONFIG_NLS_CODEPAGE_850=3Dm=0A=
CONFIG_NLS_CODEPAGE_852=3Dm=0A=
CONFIG_NLS_CODEPAGE_855=3Dm=0A=
CONFIG_NLS_CODEPAGE_857=3Dm=0A=
CONFIG_NLS_CODEPAGE_860=3Dm=0A=
CONFIG_NLS_CODEPAGE_861=3Dm=0A=
CONFIG_NLS_CODEPAGE_862=3Dm=0A=
CONFIG_NLS_CODEPAGE_863=3Dm=0A=
CONFIG_NLS_CODEPAGE_864=3Dm=0A=
CONFIG_NLS_CODEPAGE_865=3Dm=0A=
CONFIG_NLS_CODEPAGE_866=3Dm=0A=
CONFIG_NLS_CODEPAGE_869=3Dm=0A=
CONFIG_NLS_CODEPAGE_936=3Dm=0A=
CONFIG_NLS_CODEPAGE_950=3Dm=0A=
CONFIG_NLS_CODEPAGE_932=3Dm=0A=
CONFIG_NLS_CODEPAGE_949=3Dm=0A=
CONFIG_NLS_CODEPAGE_874=3Dm=0A=
CONFIG_NLS_ISO8859_8=3Dm=0A=
CONFIG_NLS_CODEPAGE_1251=3Dm=0A=
CONFIG_NLS_ISO8859_1=3Dm=0A=
CONFIG_NLS_ISO8859_2=3Dm=0A=
CONFIG_NLS_ISO8859_3=3Dm=0A=
CONFIG_NLS_ISO8859_4=3Dm=0A=
CONFIG_NLS_ISO8859_5=3Dm=0A=
CONFIG_NLS_ISO8859_6=3Dm=0A=
CONFIG_NLS_ISO8859_7=3Dm=0A=
CONFIG_NLS_ISO8859_9=3Dm=0A=
CONFIG_NLS_ISO8859_13=3Dm=0A=
CONFIG_NLS_ISO8859_14=3Dm=0A=
CONFIG_NLS_ISO8859_15=3Dm=0A=
CONFIG_NLS_KOI8_R=3Dm=0A=
CONFIG_NLS_KOI8_U=3Dm=0A=
CONFIG_NLS_UTF8=3Dm=0A=
=0A=
#=0A=
# Console drivers=0A=
#=0A=
CONFIG_VGA_CONSOLE=3Dy=0A=
CONFIG_VIDEO_SELECT=3Dy=0A=
# CONFIG_MDA_CONSOLE is not set=0A=
=0A=
#=0A=
# Frame-buffer support=0A=
#=0A=
# CONFIG_FB is not set=0A=
=0A=
#=0A=
# Sound=0A=
#=0A=
# CONFIG_SOUND is not set=0A=
=0A=
#=0A=
# USB support=0A=
#=0A=
# CONFIG_USB is not set=0A=
=0A=
#=0A=
# Bluetooth support=0A=
#=0A=
# CONFIG_BLUEZ is not set=0A=
=0A=
#=0A=
# Kernel hacking=0A=
#=0A=
# CONFIG_DEBUG_KERNEL is not set=0A=

------=_NextPart_000_0C1C_01C3D7AC.32603B20--

