From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/3] bfa: more cleanups
Date: Sun, 26 Dec 2010 21:36:31 -0800
Message-ID: <1293428191-6520-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:45357 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850Ab0L0Flf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2010 00:41:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch set continues to clean up bfa driver. It replaces bfa_assert with
linux native WARN_ON. It also removes bfa_trc_fp and some other inactive
functions and macros that are disabled in default build. The last patch  purges
remaing unused functions, data strucutres, and definitions etc, and it also
includes misc comment and formatting cleanups.

Jing Huang (3):
  bfa: replace bfa_assert with WARN_ON
  bfa: remove inactive functions
  bfa: remove unused defintions and misc cleanups

 drivers/scsi/bfa/Makefile        |    2 -
 drivers/scsi/bfa/bfa.h           |    6 +-
 drivers/scsi/bfa/bfa_core.c      |   32 +--
 drivers/scsi/bfa/bfa_cs.h        |   45 ---
 drivers/scsi/bfa/bfa_fc.h        |  582 +++++++++-----------------------------
 drivers/scsi/bfa/bfa_fcpim.c     |   67 ++---
 drivers/scsi/bfa/bfa_fcs.c       |    6 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   10 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |   20 +-
 drivers/scsi/bfa/bfa_fcs_rport.c |    4 +-
 drivers/scsi/bfa/bfa_hw_cb.c     |    2 +-
 drivers/scsi/bfa/bfa_hw_ct.c     |    4 +-
 drivers/scsi/bfa/bfa_ioc.c       |   58 ++---
 drivers/scsi/bfa/bfa_ioc.h       |    9 -
 drivers/scsi/bfa/bfa_ioc_cb.c    |    9 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |   10 +-
 drivers/scsi/bfa/bfa_port.c      |    4 +-
 drivers/scsi/bfa/bfa_svc.c       |  120 ++++----
 drivers/scsi/bfa/bfad.c          |    3 +-
 drivers/scsi/bfa/bfad_im.c       |    7 +-
 20 files changed, 280 insertions(+), 720 deletions(-)

