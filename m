From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] SCSI bug fixes for 2.6.1
Date: 19 Jan 2004 19:46:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074539066.1647.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:27019 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265352AbUATAqu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 19:46:50 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

The attached is specifically bugfixes only for 2.6.1 that I'd like to
get in before we begin release candidates for 2.6.2.  Some of them are
bug fix only pieces from driver updates that I'll begin pushing after
2.6.2 is out.

The update is available at:

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

The short changelog is

<andrew.vasquez:qlogic.com>:
  o No LUNs detected with qla2xxx / qla2300

<emoore:lsil.com>:
  o MPT Fusion x86-64 boot fix

<mort:bork.org>:
  o Fix error path when adding sysfs attributes

Andrew Morton:
  o fix qla2xxx build for older gcc's

James Bottomley:
  o aha152x PCMCIA fix

Jes Sorensen:
  o qla1280 update

Mike Anderson:
  o scsi_eh_flush_done_q return status

The diffstats are

 message/fusion/mptbase.h  |    4 -
 message/fusion/mptscsih.c |    4 +
 scsi/aha152x.c            |    2 
 scsi/qla1280.c            |  133 ++++++++++++++++++++++++++++++----------------
 scsi/qla1280.h            |   23 ++++---
 scsi/qla2xxx/qla_def.h    |    6 +-
 scsi/qla2xxx/qla_init.c   |    2 
 scsi/scsi_error.c         |   28 ++++-----
 scsi/scsi_sysfs.c         |   11 ++-
 9 files changed, 134 insertions(+), 79 deletions(-)

James


