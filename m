From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] small SCSI fixes for 2.6.2-rc1
Date: 24 Jan 2004 10:09:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074957001.2660.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8130 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266948AbUAXPKH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jan 2004 10:10:07 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

This is basically just an assortment of small warnings, doc changes and
API conformancy updates (it also includes the parallel build fix for
aic7xxx which has been annoying the OSDL builds).

The patch is here:

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

and the short changelog is:

Andrew Morton:
  o aha1542 warning fix

James Bottomley:
  o aic7xxx parallel build
  o drivers/scsi/Kconfig URL update: resource.cx

Mark Haverkamp:
  o Fix for aacraid and high memory on 2.6.1

The diffstat is

 Kconfig                 |    2 -
 aacraid/aacraid.h       |    8 ++++++
 aacraid/linit.c         |   56 +++++++++++++++++++++++++++++++-----------------
 aha1542.c               |    4 +--
 aic7xxx/Makefile        |   16 ++++++++++++-
 aic7xxx/aicasm/Makefile |    8 ++++++
 6 files changed, 71 insertions(+), 23 deletions(-)

James


