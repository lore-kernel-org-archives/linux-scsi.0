From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 0/7] bfa: cleanups and fixes
Date: Thu, 9 Dec 2010 19:06:28 -0800
Message-ID: <1291950388-9127-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55294 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab0LJDRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:17:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>

Description:

This patch set includes the following cleanups and fixes:

1) Remove unused/empty functions.
2) Clean up one line functions and remove a file of small size.
3) Modify scatter gather processing to use the kernel provided scsi_for_each_sg macro.
4) Remove SCSI IO callback wrapper functions, and as a result remove bfa_cb_ioim.h.
5) Remove OS wrapper functions, and as a result remove bfa_os_inc.h.
6) Fix checkpatch errors and misc cleanups in comment and formatting.


Maggie Zhang (7):
  bfa: remove unused and empty functions
  bfa: clean up one line functions
  bfa: remove a file with small size
  bfa: scatter gather processing change
  bfa: remove all SCSI IO callbacks
  bfa: remove all OS wrappers
  bfa: remove unused functions and misc cleanups

 drivers/scsi/bfa/Makefile        |    2 +-
 drivers/scsi/bfa/bfa.h           |   30 +--
 drivers/scsi/bfa/bfa_cb_ioim.h   |  169 ----------
 drivers/scsi/bfa/bfa_core.c      |  341 ++++++---------------
 drivers/scsi/bfa/bfa_cs.h        |   51 +++-
 drivers/scsi/bfa/bfa_defs.h      |    6 +-
 drivers/scsi/bfa/bfa_drv.c       |  107 -------
 drivers/scsi/bfa/bfa_fc.h        |   31 +-
 drivers/scsi/bfa/bfa_fcbuild.c   |   65 ++---
 drivers/scsi/bfa/bfa_fcbuild.h   |    2 +-
 drivers/scsi/bfa/bfa_fcpim.c     |  627 ++++++++-----------------------------
 drivers/scsi/bfa/bfa_fcpim.h     |  166 ++++-------
 drivers/scsi/bfa/bfa_fcs.c       |  200 ++----------
 drivers/scsi/bfa/bfa_fcs.h       |  109 +++++---
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   20 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |  127 +++------
 drivers/scsi/bfa/bfa_fcs_rport.c |  216 +------------
 drivers/scsi/bfa/bfa_hw_cb.c     |    1 +
 drivers/scsi/bfa/bfa_hw_ct.c     |    1 +
 drivers/scsi/bfa/bfa_ioc.c       |  325 ++++----------------
 drivers/scsi/bfa/bfa_ioc.h       |   28 +--
 drivers/scsi/bfa/bfa_ioc_cb.c    |    3 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |   13 +-
 drivers/scsi/bfa/bfa_modules.h   |    3 -
 drivers/scsi/bfa/bfa_os_inc.h    |  143 ---------
 drivers/scsi/bfa/bfa_plog.h      |    4 -
 drivers/scsi/bfa/bfa_port.c      |   31 +--
 drivers/scsi/bfa/bfa_port.h      |    1 -
 drivers/scsi/bfa/bfa_svc.c       |  518 ++-----------------------------
 drivers/scsi/bfa/bfa_svc.h       |   61 +---
 drivers/scsi/bfa/bfad.c          |   31 +-
 drivers/scsi/bfa/bfad_attr.c     |   10 +-
 drivers/scsi/bfa/bfad_debugfs.c  |   12 +-
 drivers/scsi/bfa/bfad_drv.h      |   37 ++-
 drivers/scsi/bfa/bfad_im.c       |   50 ++--
 drivers/scsi/bfa/bfad_im.h       |   16 +-
 drivers/scsi/bfa/bfi.h           |    4 +-
 drivers/scsi/bfa/bfi_ms.h        |    2 +-
 38 files changed, 772 insertions(+), 2791 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfa_cb_ioim.h
 delete mode 100644 drivers/scsi/bfa/bfa_drv.c
 delete mode 100644 drivers/scsi/bfa/bfa_os_inc.h

-- 
1.7.2.1

