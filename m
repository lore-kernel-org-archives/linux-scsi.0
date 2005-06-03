From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GITPATCH] two bug fixes for SCSI in 2.6.12-rc5
Date: Fri, 03 Jun 2005 10:27:44 -0500
Message-ID: <1117812465.5030.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49839 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261330AbVFCP14 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2005 11:27:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

These are fixes for a fatal locking problem in qla2xxx and slab
corruption in the ipr driver which need to go in before 2.6.12 final.

The fixes are available here:

rsync://www.parisc-linux.org/~jejb/git/scsi-for-linus-2.6.git

The short log is

Andrew Vasquez:
  o qla2xxx: fix bad locking during eh_abort

Nathan T. Lynch:
  o fix slab corruption during ipr probe


And the diffstats:

 qla2xxx/qla_os.c |   24 +++++++++++++-----------
 scsi_scan.c      |    1 +
 2 files changed, 14 insertions(+), 11 deletions(-)

James


