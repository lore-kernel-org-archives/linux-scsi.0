From: "Love, Robert W" <robert.w.love@intel.com>
Subject: fcoe pull-request - fixes for 3.11 merge window or RC
Date: Tue, 9 Jul 2013 19:48:27 +0000
Message-ID: <51DC690A.8050303@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47997 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3GITs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 15:48:29 -0400
Content-Language: en-US
Content-ID: <E12128E01E574E4A876C31530342F438@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

   Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/fixes_for_3.10

for you to fetch changes up to 7a5ed75a782a1f2de7fc773981ecd88bfa7595b1:

   fcoe: Reduce number of sparse warnings (2013-07-09 11:19:00 -0700)

----------------------------------------------------------------
A short series of fixes to libfc, libfcoe and fcoe.
Most patches fix formatting problems, one changes
the behavior of which discovered ports can/will be
logged into and another fixes a memory leak.

----------------------------------------------------------------
Bart Van Assche (1):
       fcoe: Reduce number of sparse warnings

Mark Rustad (2):
       libfc: Reject PLOGI from nodes with incompatible role
       fcoe: Stop fc_rport_priv structure leak

Neerav Parikh (1):
       fcoe: Fix smatch warning in fcoe_fdmi_info function

Robert Love (3):
       libfc: Remove extra space in fc_exch_timer_cancel definition
       libfc: Differentiate echange timer cancellation debug statements
       libfcoe: Fix meaningless log statement

Yi Zou (1):
       fcoe: fix the link error status block sparse warnings

  drivers/scsi/fcoe/fcoe.c           |   26 +++++++++++++++-----------
  drivers/scsi/fcoe/fcoe_ctlr.c      |    4 ++++
  drivers/scsi/fcoe/fcoe_sysfs.c     |   24 ++++++++++++------------
  drivers/scsi/fcoe/fcoe_transport.c |   28 ++++++----------------------
  drivers/scsi/libfc/fc_exch.c       |    4 ++--
  drivers/scsi/libfc/fc_rport.c      |   27 +++++++++++++++++++++++++++
  6 files changed, 66 insertions(+), 47 deletions(-)
