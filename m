From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] scsi bug fixes for 2.6.17-rc5
Date: Sat, 27 May 2006 13:07:11 -0700
Message-ID: <1148760432.3890.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30437 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964932AbWE0UHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 May 2006 16:07:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This is my current slew of small bug fixes which either fix serious
bugs, or are completely safe for this -rc5 stage of the kernel.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Eric Moore:
  o scsi_transport_sas: make write attrs writeable

James Bottomley:
  o scsi_transport_sas; fix user_scan
  o mptspi: reset handler shouldn't be called for other bus protocols

Randy.Dunlap:
  o ppa: fix for machines with highmem

Thomas Bogendoerfer:
  o Blacklist entry for HP dat changer

And the diffstat:

 message/fusion/mptbase.c  |   27 +++++++++++++++++++++------
 scsi/ppa.c                |    7 +++++++
 scsi/scsi_devinfo.c       |    1 +
 scsi/scsi_transport_sas.c |    4 ++--
 4 files changed, 31 insertions(+), 8 deletions(-)

James


