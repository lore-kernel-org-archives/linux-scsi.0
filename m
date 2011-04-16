From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/5] lpfc 8.3.23: Update lpfc to revision 8.3.23
Date: Sat, 16 Apr 2011 11:02:27 -0400
Message-ID: <1302966161.6245.25.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15969 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751811Ab1DPPDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2011 11:03:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.23

The patches for 8.3.23. contain:

- Debugfs enhancements
  - Added iDiag support for new adapters.
  - Added queue entry access methods.
  - Fix host/port index in decimal
  - Added Doorbell register access methods.

- Miscellaneous fixes
  - Do not limit RPI Count to a minimum of 64
  - Fix FCFI incorrect on received unsolicited frames.
  - Save the FCFI returned in the REG_FCFI mailbox command if it was successful.
  - Fixed Vports not sending FDISC after lips.
  - Align based on the SLI4_PAGE_SIZE.
  - Fixed double byte swap on received RRQ.
  - Fixed mask size for the wq_id mask from 0x7F to 0x7FFF.
  - Clear FC_FABRIC flag when NPIV LOGO completes (and add a log message).
  - Modified driver to skip round robin only when ulpStatus==LOCAL_REJECT
    and word4=SEQUENCE_TIMEOUT to prevent FLOGI to disconnected FCF.
  - Don't add rport if driver unloading

- Fixes related to new hardware.
  - Restrict driver to look at BAR2 or BAR4 only for if_type 0.
  - Allow SLI4 with FCOE_MODE not set for new SLI4 FC adapters.
  - Add Temporary RPI field to the ELS request WQE.
  - Do not override CT field in issue_els_flogi for SLI4 IF type 2
  - For RQ_CREATE_V2 mbx cmd: fill in the rqe_size and page_size for RQ_CREATE.

- BSG additions and fixes
  - Fixed the mixed declarations and codes which violate ISO C90
     (declarations in subsections that assign at declaration)
  - Add BSG data transfer size protection in mailbox command pass-through path
  - Invoke BSG job_done while holding spinlock to fix deadlock
  - Added support for checking SLI_CONFIG subcommands
  - Fixed bug in BSG mailbox size check to non-embedded external buffer

- Update driver version to 8.3.23


The bugfixes were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




