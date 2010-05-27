From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] final (hopefully) SCSI updates for 2.6.35 merge window
Date: Thu, 27 May 2010 10:45:37 -0500
Message-ID: <1274975137.2869.123.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab0E0Ppn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 11:45:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

This is just the stragglers that were in process when the merge window
opened.  They got delayed to stabilise the scsi features tree through
linux-next before the first pull request.  it's mainly a set of
miscellaneous bug fixes (including the ultimate resolution of the iscsi
bug fix mismerge) plus an ipr and aacraid update.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Stern (1):
      fix race in scsi_target_reap

Dan Carpenter (1):
      be2iscsi: correct return value in mgmt_invalidate_icds()

Julia Lawall (1):
      aacraid: Eliminate use after free

Krishna Gudipati (1):
      bfa: fix system crash when reading sysfs fc_host statistics

Mike Christie (1):
      iscsi_tcp: remove sk_sleep check

Nick Cheng (1):
      arcmsr: Support HW reset for EH and polling scheme for scsi device

Wayne Boyer (5):
      ipr: improve interrupt service routine performance
      ipr: set the data list length in the request control block
      ipr: fix a register read to use the correct address for 64 bit adapters
      ipr: include the resource path in the IOA status area structure
      ipr: implement fixes for 64 bit adapter support

and the diffstat:

 drivers/scsi/aacraid/commctrl.c   |    4 
 drivers/scsi/arcmsr/arcmsr.h      |   29 +
 drivers/scsi/arcmsr/arcmsr_attr.c |    3 
 drivers/scsi/arcmsr/arcmsr_hba.c  |  684 +++++++++++++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_mgmt.c   |    5 
 drivers/scsi/bfa/bfa_core.c       |   22 +
 drivers/scsi/ipr.c                |  221 ++++++------
 drivers/scsi/ipr.h                |   31 +
 drivers/scsi/iscsi_tcp.c          |    6 
 drivers/scsi/scsi_scan.c          |    9 
 10 files changed, 708 insertions(+), 306 deletions(-)

James


