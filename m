From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.16-rc6
Date: Tue, 14 Mar 2006 12:34:46 -0600
Message-ID: <1142361287.3241.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27822 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751248AbWCNSe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 13:34:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This is just a minor selection of bug fixes (two in zfcp which no-one
other than s390 will see).  The others are a build failure in the
aha152x pcmcia driver and blacklisting a brownie array which fails
rather badly when given a report luns command and a fc transport
parameter miscount that could result in a BUG_ON().

The fix is here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andreas Herrmann:
  o zfcp: fix device registration issues
  o scsi_transport_fc: fix FC_HOST_NUM_ATTRS
  o zfcp: correctly set this_id for hosts

Dominik Brodowski:
  o scsi: aha152x pcmcia driver needs spi transport

Matthew Wilcox:
  o Add Brownie to blacklist

And the diffstat:

 s390/scsi/zfcp_def.h     |    1 +
 s390/scsi/zfcp_erp.c     |   11 +++++++----
 s390/scsi/zfcp_scsi.c    |    8 +++++---
 scsi/pcmcia/Kconfig      |    1 +
 scsi/scsi_devinfo.c      |    1 +
 scsi/scsi_transport_fc.c |    2 +-
 6 files changed, 16 insertions(+), 8 deletions(-)

James




