From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] scsi bug fixes for 2.6.12-rc3
Date: Fri, 06 May 2005 17:47:18 -0500
Message-ID: <1115419638.4989.57.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18659 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261305AbVEFWr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2005 18:47:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

This is the dump of the current crop of SCSI bugfixes.

The patch is available at

rsync://www.parisc-linux.org/~jejb/git/scsi-for-linus-2.6.git

The short changelog is:


Andreas Herrmann:
  o zfcp: fix compile error

Andrew Vasquez:
  o qla2xxx: remove a transport #include

Christoph Hellwig:
  o aic7xxx: remove inquiry sniffing leftovers

James Bottomley:
  o correct the sym2 period setting routines
  o fix command retries in spi_transport class

Mark Haverkamp:
  o aacraid: Fix adapter open error

Mike Christie:
  o call correct scsi_done function in scsi_dispatch_cmd

Nate Dailey:
  o drivers/scsi/sr_ioctl.c: check for failed allocation

And the diffstat is:

 drivers/s390/scsi/zfcp_aux.c        |    2 -
 drivers/s390/scsi/zfcp_def.h        |    1 
 drivers/scsi/aacraid/linit.c        |    2 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |    2 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h  |    6 ----
 drivers/scsi/qla2xxx/qla_attr.c     |    8 -----
 drivers/scsi/qla2xxx/qla_gbl.h      |    4 +-
 drivers/scsi/qla2xxx/qla_os.c       |    3 +-
 drivers/scsi/scsi.c                 |    2 -
 drivers/scsi/scsi_transport_spi.c   |   49 ++++++++++++++++++++++++------------
 drivers/scsi/sr_ioctl.c             |    3 ++
 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 ++-
 12 files changed, 48 insertions(+), 39 deletions(-)

James

