From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] scsi bug fixes for 2.6.17-rc5
Date: Wed, 31 May 2006 11:26:58 -0500
Message-ID: <1149092818.22134.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:31131 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750957AbWEaQ1I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 12:27:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is my current slew of small bug fixes which either fix serious
bugs, or are completely safe for this -rc5 stage of the kernel.  I've
added one more since I last sent you this pull request (the fix memory
building non-aligned sg lists)

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Bryan Holty:
  o fix memory building non-aligned sg lists

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
 scsi/scsi_lib.c           |    2 +-
 scsi/scsi_transport_sas.c |    4 ++--
 5 files changed, 32 insertions(+), 9 deletions(-)

James


