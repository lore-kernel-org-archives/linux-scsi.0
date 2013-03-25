From: "Love, Robert W" <robert.w.love@intel.com>
Subject: fcoe pull-request 3.9-rc
Date: Mon, 25 Mar 2013 23:38:35 +0000
Message-ID: <5150DFFA.50006@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab3CYXii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Mar 2013 19:38:38 -0400
Content-Language: en-US
Content-ID: <EB04E0AEF4706F40A0C9106AFD7EEDFA@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

   Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/for-3.9-rc

for you to fetch changes up to 0db0e377ab5be5d507a2fca3d78215cd2e83b974:

   libfcoe: Fix fcoe_sysfs VN2VN mode (2013-03-25 16:04:22 -0700)

----------------------------------------------------------------
Critical patches to fix FCoE VN2VN mode with new interfaces targeting 3.9-rc

----------------------------------------------------------------
Robert Love (5):
       bnx2fc: Make the fcoe_cltr the SCSI host parent
       fcoe: Fix deadlock between create and destroy paths
       libfc, fcoe, bnx2fc: Always use fcoe_disc_init for discovery 
layer initialization
       libfc, fcoe, bnx2fc: Split fc_disc_init into fc_disc_{init, config}
       libfcoe: Fix fcoe_sysfs VN2VN mode

  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 ++--
  drivers/scsi/fcoe/fcoe.c          |   15 +++++++---
  drivers/scsi/fcoe/fcoe_ctlr.c     |   60 
++++++++++++++++++++++++++++---------
  drivers/scsi/libfc/fc_disc.c      |   26 +++++++++++-----
  include/scsi/libfc.h              |    3 +-
  5 files changed, 80 insertions(+), 30 deletions(-)

