From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.15-rc4
Date: Fri, 02 Dec 2005 10:40:54 -0600
Message-ID: <1133541656.3497.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37068 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750818AbVLBQlQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2005 11:41:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Unless anything else nasty turns up, these should be the final bug fixes
for 2.6.15.

They're available here

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andreas Herrmann:
  o zfcp: fix return code of zfcp_scsi_slave_alloc
  o zfcp: fix adapter initialization

Eric Moore:
  o mptfusion: Add maintainers
  o mptfusion : dv performance fix

Heiko Carstens:
  o zfcp: fix spinlock initialization

Hugh Dickins:
  o sg: fix a bug in st_map_user_pages failure path
  o sg and st unmap_user_pages allow PageReserved
  o st: fix a bug in sgl_map_user_pages failure path

James Bottomley:
  o SPI DV: be more conservative about echo buffer usage

Mark Haverkamp:
  o aacraid: Check scsi_bios_ptabe return code

Matthew Wilcox:
  o sym2: Disable IU and QAS negotiation

Maxim Shchetynin:
  o zfcp: fix link down handling during firmware update

Vasily Averin:
  o aic7xxx: reset handler selects a wrong command


And the diffstat:

 MAINTAINERS                         |    9 ++
 drivers/message/fusion/mptbase.c    |   64 ++++++++++++++++++++
 drivers/message/fusion/mptbase.h    |    3 
 drivers/message/fusion/mptscsih.c   |   10 +++
 drivers/s390/scsi/zfcp_aux.c        |   14 ++++
 drivers/s390/scsi/zfcp_dbf.c        |    4 -
 drivers/s390/scsi/zfcp_erp.c        |   94 ++++++++++--------------------
 drivers/s390/scsi/zfcp_fsf.c        |  110 ++++++++++++++++++++----------------
 drivers/s390/scsi/zfcp_scsi.c       |    2 
 drivers/scsi/aacraid/linit.c        |    2 
 drivers/scsi/aic7xxx/aic79xx_osm.c  |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |    2 
 drivers/scsi/scsi_transport_spi.c   |   28 ++++++---
 drivers/scsi/sg.c                   |    6 -
 drivers/scsi/st.c                   |    3 
 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 +
 16 files changed, 225 insertions(+), 133 deletions(-)

James


