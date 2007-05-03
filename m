From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: dead CONFIG_ variables:  drivers/scsi/
Date: Thu, 3 May 2007 06:10:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:49235 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXECKK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 06:10:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org


$ ../dead_config.sh drivers/scsi
========== 53C700_BE_BUS ==========
drivers/scsi/53c700.h:266:#ifdef CONFIG_53C700_BE_BUS
========== ACORNSCSI_CONSTANTS ==========
drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:417:#ifdef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:495:#ifdef CONFIG_ACORNSCSI_CONSTANTS
========== AIC7XXX_PROC_STATS ==========
drivers/scsi/aic7xxx/aic7xxx_osm.c:152:#ifdef CONFIG_AIC7XXX_PROC_STATS
Documentation/filesystems/proc.txt:636:    AIC7XXX_PROC_STATS     : Disabled
drivers/scsi/aic7xxx/aic7xxx_osm.c:153:#define AIC7XXX_PROC_STATS
========== HIGHIO ==========
drivers/scsi/ips.h:61:   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined CONFIG_HIGHIO
========== NCR53C8XX_PREFETCH ==========
drivers/scsi/ncr53c8xx.c:1818:#ifdef CONFIG_NCR53C8XX_PREFETCH
========== SCSI_ACORNSCSI_LINK ==========
drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:1675:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:2849:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:2880:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
========== SCSI_DC395x_TRMS1040_TRADMAP ==========
drivers/scsi/dc395x.c:1176:#ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
========== SCSI_G_NCR5380_MEM ==========
drivers/scsi/g_NCR5380.c:299:#ifdef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:377:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:439:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:449:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:519:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:592:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:599:           /* implies CONFIG_SCSI_G_NCR5380_MEM */
drivers/scsi/g_NCR5380.c:612:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:619:           /* implies CONFIG_SCSI_G_NCR5380_MEM */
drivers/scsi/g_NCR5380.c:678:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:684:           /* implies CONFIG_SCSI_G_NCR5380_MEM */
drivers/scsi/g_NCR5380.c:694:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.c:700:           /* implies CONFIG_SCSI_G_NCR5380_MEM */
drivers/scsi/g_NCR5380.h:66:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.h:94:/* therefore CONFIG_SCSI_G_NCR5380_MEM */
drivers/scsi/g_NCR5380_mmio.c:7:#define SCSI_G_NCR5380_MEM
========== SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK ==========
drivers/scsi/ncr53c8xx.h:175:#ifdef CONFIG_SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK
========== SCSI_NCR53C8XX_DISABLE_PARITY_CHECK ==========
drivers/scsi/ncr53c8xx.h:184:#ifdef CONFIG_SCSI_NCR53C8XX_DISABLE_PARITY_CHECK
========== SCSI_NCR53C8XX_FORCE_SYNC_NEGO ==========
drivers/scsi/ncr53c8xx.h:166:#ifdef CONFIG_SCSI_NCR53C8XX_FORCE_SYNC_NEGO
========== SCSI_NCR53C8XX_IARB ==========
drivers/scsi/ncr53c8xx.h:125:#if defined(CONFIG_SCSI_NCR53C8XX_IARB)
========== SCSI_NCR53C8XX_INTEGRITY_CHECK ==========
drivers/scsi/ncr53c8xx.h:70:#ifdef      CONFIG_SCSI_NCR53C8XX_INTEGRITY_CHECK
========== SCSI_NCR53C8XX_NO_WORD_TRANSFERS ==========
drivers/scsi/ncr53c8xx.h:416:#ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
drivers/scsi/ncr53c8xx.h:424:#ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
========== SCSI_NCR53C8XX_TAGGED_QUEUE ==========
drivers/scsi/ncr53c8xx.h:116:#elif      defined CONFIG_SCSI_NCR53C8XX_TAGGED_QUEUE
========== WD33C93_PIO ==========
drivers/scsi/wd33c93.c:172:#ifdef CONFIG_WD33C93_PIO
drivers/scsi/wd33c93.c:230:#else /* CONFIG_WD33C93_PIO */
drivers/scsi/wd33c93.c:297:#endif /* CONFIG_WD33C93_PIO */
drivers/scsi/wd33c93.h:193:#ifdef CONFIG_WD33C93_PIO

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
