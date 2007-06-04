From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.22-rc3
Date: Mon, 04 Jun 2007 11:32:27 -0500
Message-ID: <1180974747.3711.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41276 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755961AbXFDQc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2007 12:32:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is just a slew of assorted bug fixes for 2.6.22-rc3.  The patch is
available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Bill Nottingham (1):
      qla2xxx: fix timeout in qla2x00_down_timeout

David S. Miller (1):
      JAZZ ESP and SUN ESP need SPI_ATTRS

Hugh Dickins (1):
      fix CONFIG_SCSI_WAIT_SCAN=m

Michael Schmitz (1):
      atari_NCR5380: update_timeout removal

Salyzyn, Mark (1):
      aacraid: fix shutdown handler to also disable interrupts.


And the diffstat:

 Kconfig          |    2 ++
 aacraid/linit.c  |   22 ++++++++++++----------
 atari_NCR5380.c  |   44 ++------------------------------------------
 qla2xxx/qla_os.c |    2 +-
 scsi_scan.c      |    9 +++++++++
 5 files changed, 26 insertions(+), 53 deletions(-)

James


