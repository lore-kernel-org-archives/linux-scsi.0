From: Tuukka Toivonen <tuukkat@ee.oulu.fi>
Subject: 2.6.0-test3: scsi: Saw underflow (231 of 255 bytes). Treated as
 error
Date: Wed, 20 Aug 2003 13:58:57 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.55.0308201346170.6320@stekt37>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ee.oulu.fi ([130.231.61.23]:57309 "EHLO ee.oulu.fi")
	by vger.kernel.org with ESMTP id S261885AbTHTK66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2003 06:58:58 -0400
Received: from stekt37 (stekt37 [130.231.60.77])
	by ee.oulu.fi (8.12.9/8.12.9) with ESMTP id h7KAwvkN009563
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2003 13:58:57 +0300 (EEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm running 2.6.0-test3 and get these messages during bootup:

(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0

However, then it proceeds normally and the SCSI disk works fine.
I also occasionally get similar error messages while using the disk
heavily, however, everything seems to work fine.

I don't get the messages with 2.4.x.
The problem seems to be very similar to this:
http://lists.insecure.org/lists/linux-kernel/2003/Feb/6671.html
I have dual PentiumIII 933 MHz, 1 GB memory, AIC-7899.
config file below, but playing with the values (e.g. cmds per device)
doesn't seem to change anything.

----

 /dev/ide/host0/bus0/target0/lun0: p1 p2
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=1, 32/253 SCBs

(scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
  Vendor: SEAGATE   Model: ST318406LW        Rev: 8A03
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

SCSI device sda: 35566478 512-byte hdwr sectors (18210 MB)
SCSI device sda: drive cache: write back
 /dev/scsi/host0/bus0/target0/lun0: p1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
...
bttv0: registered device video0
videodev: "bt848/878 vbi" has no release callback. Please fix your driver
for proper sysfs support, see http://lwn.net/Articles/36850/
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
scsi2 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: Lite-On   Model: LTN486  48x Max   Rev: YD01
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi3 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: MITSUMI   Model: CR-2801TE         Rev: 1.07
  Type:   CD-ROM                             ANSI SCSI revision: 02
[drm] Initialized mga 3.1.0 20021029 on minor 0
inserting floppy driver for 2.6.0-test3
Floppy drive(s): fd0 is 1.44M, fd1 is 1.2M
FDC 0 is a National Semiconductor PC87306
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.12
Attached scsi CD-ROM sr0 at scsi2, channel 0, id 0, lun 0
sr1: scsi-1 drive
Attached scsi CD-ROM sr1 at scsi3, channel 0, id 0, lun 0
found reiserfs format "3.6" with standard journal
Reiserfs journal params: device hda2, size 8192, journal first block 18,
max trans len 1024, max batch 900, max commit age 30, max trans ag
e 30
reiserfs: checking transaction log (hda2) for (hda2)
Using r5 hash to sort names
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
(scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x40 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1009 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x40 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1009 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x40 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1009 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x40 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1009 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x40 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1009 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x6f 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1012 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x6f 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1012 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x6f 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1012 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x6f 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1012 of 1024 bytes). Treated as error
(scsi0:A:0:0): CDB: 0x4d 0x0 0x6f 0x0 0x0 0x0 0x0 0x4 0x0 0x0
(scsi0:A:0:0): Saw underflow (1012 of 1024 bytes). Treated as error

----

CONFIG_X86=y
CONFIG_MMU=y
CONFIG_UID16=y
CONFIG_GENERIC_ISA_DMA=y

CONFIG_EXPERIMENTAL=y

CONFIG_SYSVIPC=y
CONFIG_SYSCTL=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_KALLSYMS=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y

CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_OBSOLETE_MODPARM=y
CONFIG_KMOD=y

CONFIG_X86_PC=y
CONFIG_MPENTIUMIII=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_XADD=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_SMP=y
CONFIG_NR_CPUS=2
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_TSC=y
CONFIG_X86_MCE=y
CONFIG_MICROCODE=m
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_HIGHMEM4G=y
CONFIG_HIGHMEM=y
CONFIG_MTRR=y
CONFIG_HAVE_DEC_LOCK=y

CONFIG_PM=y

CONFIG_APM=y
CONFIG_APM_DO_ENABLE=y
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_RTC_IS_GMT=y

CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_LEGACY_PROC=y
CONFIG_PCI_NAMES=y

CONFIG_KCORE_ELF=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_PC_CML1=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_1284=y

CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_SIZE=4096

CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

CONFIG_BLK_DEV_IDEDISK=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDESCSI=m
CONFIG_IDE_TASKFILE_IO=y

CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_IDEDMA_PCI_AUTO=y
CONFIG_IDEDMA_ONLYDISK=y
CONFIG_BLK_DEV_ADMA=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDEDMA_AUTO=y

CONFIG_SCSI=y

CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m

CONFIG_SCSI_REPORT_LUNS=y
CONFIG_SCSI_CONSTANTS=y

CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=253
CONFIG_AIC7XXX_RESET_DELAY_MS=1500
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y

CONFIG_NET=y

CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_NETLINK_DEV=m
CONFIG_UNIX=m
CONFIG_INET=y

CONFIG_NETFILTER=y

CONFIG_IP_NF_CONNTRACK=m
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_NAT_NEEDED=y
CONFIG_IP_NF_COMPAT_IPCHAINS=m

CONFIG_IPV6_SCTP__=y

CONFIG_NETDEVICES=y

CONFIG_DUMMY=m

CONFIG_NET_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m

CONFIG_NET_PCI=y
CONFIG_NE2K_PCI=m
CONFIG_8139TOO=m

CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m

CONFIG_INPUT=y

CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=m

CONFIG_SOUND_GAMEPORT=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m

CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_SERIAL=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_UINPUT=m

CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y

CONFIG_SERIAL_8250=m

CONFIG_SERIAL_CORE=m
CONFIG_UNIX98_PTYS=y
CONFIG_UNIX98_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_PPDEV=m

CONFIG_I2C=m
CONFIG_I2C_ALGOBIT=m
CONFIG_SCx200_ACB=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_CHARDEV=m

CONFIG_I2C_PIIX4=m

CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_W83781D=m
CONFIG_I2C_SENSOR=m

CONFIG_BUSMOUSE=m

CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_KCS=m
CONFIG_IPMI_WATCHDOG=m

CONFIG_NVRAM=m
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y

CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_DRM=y
CONFIG_DRM_MGA=m
CONFIG_RAW_DRIVER=m
CONFIG_HANGCHECK_TIMER=m

CONFIG_VIDEO_DEV=m

CONFIG_VIDEO_PROC_FS=y

CONFIG_VIDEO_BT848=m

CONFIG_VIDEO_VIDEOBUF=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_BUF=m
CONFIG_VIDEO_BTCX=m

CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=m
CONFIG_JBD=m
CONFIG_REISERFS_FS=y
CONFIG_JFS_FS=m
CONFIG_XFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_ROMFS_FS=m
CONFIG_AUTOFS4_FS=m

CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_UDF_FS=m

CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_NTFS_FS=m
CONFIG_NTFS_RW=y

CONFIG_PROC_FS=y
CONFIG_DEVFS_FS=y
CONFIG_DEVFS_MOUNT=y
CONFIG_DEVPTS_FS=y
CONFIG_TMPFS=y
CONFIG_RAMFS=y

CONFIG_AFFS_FS=m
CONFIG_CRAMFS=m

CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_SUNRPC=m
CONFIG_SMB_FS=m
CONFIG_CODA_FS=m
CONFIG_INTERMEZZO_FS=m

CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_SMB_NLS=y
CONFIG_NLS=y

CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_UTF8=m

CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y

CONFIG_SOUND=m

CONFIG_SND=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_VERBOSE_PRINTK=y

CONFIG_SND_DUMMY=m

CONFIG_SND_CS46XX=m

CONFIG_SND_USB_AUDIO=m

CONFIG_USB=m
CONFIG_USB_DEBUG=y

CONFIG_USB_DEVICEFS=y

CONFIG_USB_UHCI_HCD=m

CONFIG_USB_AUDIO=m

CONFIG_USB_PWC=m

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_IOVIRT=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_X86_EXTRA_IRQS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y

CONFIG_CRYPTO=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_DEFLATE=m

CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
