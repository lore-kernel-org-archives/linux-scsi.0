From: James Bottomley <James.Bottomley@steeleye.com>
Subject: bkbits.net problems and work arounds
Date: 02 May 2003 14:34:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051904100.1819.70.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:23813 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263126AbTEBTWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2003 15:22:40 -0400
Received: from mulgrave-w.il.steeleye.com (il-ppp.sc.steeleye.com [172.17.6.240])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h42JZ0I19917
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2003 15:35:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


For those of you tracking the scsi-misc-2.5 repository, there seems to
be a bkbits.net problem that prevents me from updating it.

Temporarily, I've pushed the latest tree up to

http://linux-scsi.bkbits.net/scsi-misc1-2.5

Please use this for the time being to get the current tree.  I'm hoping
scsi-misc-2.5 will be back online shortly.

The changes in this are:


<heiko.carstens:de.ibm.com>:
  o set data direction in sd_synchronize_cache in sd.c

Anton Blanchard:
  o Re: Make sym2 driver use pci_enable_device

Christoph Hellwig:
  o remove scsi_device proc printing from drivers
  o update NCR_D700 for new-style probing
  o nuke some superflous externs
  o Re: unchecked_isa_dma on sparcv9
  o move max_sectors intitalization fully to scsi_register
  o scsi_requeuest_fn
  o remove dead scsi_cmnd members
  o remove dead struct scsi_device members
  o fix scsi_debug compile warning
  o use scsi_report_bus_reset() in scsi_erroc.c
  o kill pcmcia driver bind_info horror
  o kill scsi_dump_status
  o split private and public scsi headers

Douglas Gilbert:
  o blk SCSI_IOCTL_SEND_COMMAND

James Bottomley:
  o Fix NCR_D700 driver

Justin T. Gibbs:
  o fix aci7xxx locking problem
  o Aic7xxx Driver Update (6.2.33)
  o Update Aic79xx and Aic7xxx Documenation
  o Aic79xx Driver Update (version 1.3.8)
  o Aic7xxx and Aic79xx Driver Updates
  o Aic79xx and Aic7xxx driver Update
  o aic7xxx_osm.h, aic7xxx_osm.c, aic79xx_osm.h, aic79xx_osm.c
  o Aic79xx Driver Upate
  o Aic79xx Driver Update
  o Aic79xx Driver Update
  o Aic79xx Driver Update
  o Aic7xxx Driver Update
  o Aic7xxx and Aic79xx Driver Updates
  o Aic7xxx and Aic79xx driver Update
  o Aic7xxx and Aic79xx driver updates
  o Aic7xxx and Aic79xx driver updates
  o Aic7xxx and Aic79xx Driver Update
  o Aic7xxx and Aic79xx driver Update
  o Aic79xx Driver Update
  o Aic7xxx Driver Update (version 6.2.32)
  o Aic79xx Driver Update (version 1.3.6)
  o Change the callback argument for aic brace option parsing to u_long
to avoid casting problems with different architectures.

Patrick Mansfield:
  o Compile fix for scsi_syms.c

Paul Mackerras:
  o Update mesh.c and mac53c94.c drivers



