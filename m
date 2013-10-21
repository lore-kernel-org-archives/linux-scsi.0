From: Robert Love <robert.w.love@intel.com>
Subject: fcoe request pull 3.13
Date: Mon, 21 Oct 2013 11:11:32 -0700
Message-ID: <52656E54.7060004@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab3JUSMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:12:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following changes since commit c0866286f10964e61ec10c8c605ef86e65fbbd38:

   fcoe: ensure that skb placed on the fip_recv_list are unshared 
(2013-09-04 11:48:19 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/for-3.13

for you to fetch changes up to 6942df7f775107b504f10de42c81971f514d718d:

   scsi: Convert uses of compare_ether_addr to ether_addr_equal 
(2013-10-14 08:25:40 -0700)

----------------------------------------------------------------
Pull Request for 3.13

----------------------------------------------------------------
Bart Van Assche (13):
       libfc: Source code comment spelling fixes
       libfc: Debug code fixes
       libfc: Micro-optimize fc_setup_exch_mgr()
       libfc: Clarify fc_exch_find()
       libfc: Fix a race in fc_exch_timer_set_locked()
       libfc: Protect ep->esb_stat changes via ex_lock
       libfc: Avoid that sending after an abort triggers a kernel warning
       libfc: Reduce exchange lock contention in fc_exch_recv_abts()
       libfc: Do not invoke the response handler after fc_exch_done()
       fcp: Do not interpret check condition as underrun
       fcoe: Declare fcoe_ctlr_mode_set() static
       fcoe: Add missing newlines in debug messages
       fcoe: Reduce fcoe_sysfs_fcf_add() stack usage

Joe Perches (1):
       scsi: Convert uses of compare_ether_addr to ether_addr_equal

Neil Horman (3):
       fcoe: make sure fcoe frames are unshared prior to manipulating them
       fcoe: cleanup return codes from fcoe_rcv
       fcoe: Fix missing mutex_unlock in fcoe_sysfs_fcf_add error path

Robert Love (1):
       libfcoe: Make fcoe_sysfs optional / fix fnic NULL exception

  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 +-
  drivers/scsi/fcoe/fcoe.c          |   25 ++--
  drivers/scsi/fcoe/fcoe_ctlr.c     |  145 +++++++++++++--------
  drivers/scsi/fcoe/fcoe_sysfs.c    |   14 +--
  drivers/scsi/fnic/fnic_fcs.c      |    6 +-
  drivers/scsi/libfc/fc_exch.c      |  251 
++++++++++++++++++++++++-------------
  drivers/scsi/libfc/fc_fcp.c       |   10 +-
  drivers/scsi/libfc/fc_lport.c     |    4 +-
  drivers/scsi/libfc/fc_rport.c     |    6 +-
  include/scsi/fc/fc_fc2.h          |    2 +-
  include/scsi/libfc.h              |    9 ++
  include/scsi/libfcoe.h            |    7 +-
  12 files changed, 307 insertions(+), 176 deletions(-)
