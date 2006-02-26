From: Konstantin Khomoutov <flatworm@users.sourceforge.net>
Subject: What happened to ncr53c8xx module in 2.6? (troubles with sym53c8xx in its place)
Date: Sun, 26 Feb 2006 20:14:14 +0300
Message-ID: <20060226171414.GB300@proxysrv.domain007.com>
References: <20060226170411.GA300@proxysrv.domain007.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.007spb.ru ([212.113.108.55]:10945 "EHLO
	mailhub.007spb.ru") by vger.kernel.org with ESMTP id S1750917AbWBZROR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 12:14:17 -0500
Received: from proxysrv.domain007.com (programmer.domain007.com [192.168.2.100])
	by mailhub.007spb.ru (8.13.4/8.13.4/Debian-3) with SMTP id k1QHEELD012370
	for <linux-scsi@vger.kernel.org>; Sun, 26 Feb 2006 20:14:15 +0300
Content-Disposition: inline
In-Reply-To: <20060226170411.GA300@proxysrv.domain007.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Feb 26, 2006 at 08:04:11PM +0300, Konstantin Khomoutov wrote:

Sorry, I've forgot to append my system info:

Kernel: 2.6.15.4 (last stable).

SCSI config (enabled options):

CONFIG_BLK_DEV_IDESCSI=y
CONFIG_SCSI=y
CONFIG_SCSI_PROC_FS=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_SATA=y
CONFIG_SCSI_ATA_PIIX=y
CONFIG_SCSI_SATA_INTEL_COMBINED=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_OMIT_FLASHPOINT=y
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_QLA2XXX=y

SCSI card (as reported by lspci -vvv):

0000:02:09.0 Non-VGA unclassified device: LSI Logic / Symbios Logic 53c810 (rev 01)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 9
        Region 0: I/O ports at b800 [size=256]
        Region 1: Memory at e6800000 (32-bit, non-prefetchable) [size=256]


This card is plugged into MB with i845 chipset.

