From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: SCSI-related dead CONFIGs?
Date: Fri, 2 Nov 2007 09:56:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0711020952380.2971@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:42576 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbXKBN5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2007 09:57:41 -0400
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1Inx1o-0003TT-Eb
	for linux-scsi@vger.kernel.org; Fri, 02 Nov 2007 09:57:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


  since things have stabilized after the merge window, any thoughts on
the following useless(?) SCSI-related CONFIG vars?

>>>>> ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:417:#ifdef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:495:#ifdef CONFIG_ACORNSCSI_CONSTANTS
>>>>> AIC7XXX_PROC_STATS
drivers/scsi/aic7xxx/aic7xxx_osm.c:152:#ifdef CONFIG_AIC7XXX_PROC_STATS
Documentation/filesystems/proc.txt:717:    AIC7XXX_PROC_STATS     : Disabled
drivers/scsi/aic7xxx/aic7xxx_osm.c:153:#define AIC7XXX_PROC_STATS
>>>>> LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.h:24:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc.h:352:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc.h:562:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.c:48:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.c:475:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.c:503:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.c:524:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.c:769:#ifdef CONFIG_LPFC_DEBUG_FS
drivers/scsi/lpfc/lpfc_debugfs.c:946:#ifdef CONFIG_LPFC_DEBUG_FS
>>>>> NCR53C8XX_PREFETCH
drivers/scsi/ncr53c8xx.c:1794:#ifdef CONFIG_NCR53C8XX_PREFETCH
>>>>> SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:1675:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:2849:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:2880:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
>>>>> SCSI_DC395x_TRMS1040_TRADMAP
drivers/scsi/dc395x.c:1163:#ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
>>>>> SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.h:66:#ifndef CONFIG_SCSI_G_NCR5380_MEM
drivers/scsi/g_NCR5380.h:94:/* therefore CONFIG_SCSI_G_NCR5380_MEM */
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
drivers/scsi/g_NCR5380_mmio.c:7:#define SCSI_G_NCR5380_MEM
>>>>> SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK
drivers/scsi/ncr53c8xx.h:175:#ifdef CONFIG_SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK
>>>>> SCSI_NCR53C8XX_DISABLE_PARITY_CHECK
drivers/scsi/ncr53c8xx.h:184:#ifdef CONFIG_SCSI_NCR53C8XX_DISABLE_PARITY_CHECK
>>>>> SCSI_NCR53C8XX_FORCE_SYNC_NEGO
Documentation/scsi/ncr53c8xx.txt:585:CONFIG_SCSI_NCR53C8XX_FORCE_SYNC_NEGO (default answer: n)
drivers/scsi/ncr53c8xx.h:166:#ifdef CONFIG_SCSI_NCR53C8XX_FORCE_SYNC_NEGO
>>>>> SCSI_NCR53C8XX_IARB
drivers/scsi/ncr53c8xx.h:125:#if defined(CONFIG_SCSI_NCR53C8XX_IARB)
>>>>> SCSI_NCR53C8XX_INTEGRITY_CHECK
drivers/scsi/ncr53c8xx.h:70:#ifdef      CONFIG_SCSI_NCR53C8XX_INTEGRITY_CHECK
>>>>> SCSI_NCR53C8XX_NO_WORD_TRANSFERS
drivers/scsi/ncr53c8xx.h:416:#ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
drivers/scsi/ncr53c8xx.h:424:#ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
>>>>> SCSI_NCR53C8XX_TAGGED_QUEUE
drivers/scsi/ncr53c8xx.h:116:#elif      defined CONFIG_SCSI_NCR53C8XX_TAGGED_QUEUE
>>>>> WD33C93_PIO
drivers/scsi/wd33c93.h:193:#ifdef CONFIG_WD33C93_PIO
drivers/scsi/wd33c93.c:174:#ifdef CONFIG_WD33C93_PIO
drivers/scsi/wd33c93.c:232:#else /* CONFIG_WD33C93_PIO */
drivers/scsi/wd33c93.c:299:#endif /* CONFIG_WD33C93_PIO */

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
