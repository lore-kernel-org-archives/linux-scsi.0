From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI final bug fixes for 2.6.20-rc7
Date: Sat, 03 Feb 2007 08:25:59 -0600
Message-ID: <1170512760.3345.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41136 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946457AbXBCO0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 09:26:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

There are four small bug fixes in this:  A set of qla4xxx driver bugs, a
fix for uninitialised variables in sd during initial hotplug, a tape fix
for BUG 7864 and an async scan fix for the "none" scanning type with
RAID devices.

The fix is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

David C Somayajulu (1):
       qla4xxx: bug fixes

Kai Makisara (1):
       st: A MTIOCTOP/MTWEOF within the early warning will cause the file number to be incorrect

Matthew Wilcox (1):
       Fix scsi_add_device() for async scanning

Nagendra Singh Tomar (1):
       sd: udev accessing an uninitialized scsi_disk field results in a crash

and the diffstat:

 qla4xxx/ql4_def.h     |    1 
 qla4xxx/ql4_glbl.h    |    1 
 qla4xxx/ql4_init.c    |   18 +++++++-------
 qla4xxx/ql4_isr.c     |    4 +--
 qla4xxx/ql4_mbx.c     |   35 ++++++++++++++++-----------
 qla4xxx/ql4_os.c      |   64 ++++++++++++++++++++++++++++++--------------------
 qla4xxx/ql4_version.h |    2 -
 scsi_scan.c           |    6 ++++
 sd.c                  |   20 +++++++--------
 st.c                  |   19 ++++++++------
 10 files changed, 100 insertions(+), 70 deletions(-)

James


