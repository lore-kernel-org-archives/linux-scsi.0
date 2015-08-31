From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 00/14] lpfc: Update to revision 11.0.0.0
Date: Mon, 31 Aug 2015 16:48:07 -0400
Message-ID: <55e4bd87.eie8hCFdLGKHWB6x%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34262 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbHaUsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:23 -0400
Received: by qkct7 with SMTP id t7so16737981qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:22 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id 144sm9447391qhu.11.2015.08.31.13.48.21
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.0.0.0

The patches were cut against scsi-misc

-- james s


James Smart (14):
  Pull in patches posted to linux-scsi prior:
    lpfc: fix model description
    lpfc: Remove unnessary cast
    lpfc: in sli3 use configured sg_seg_cnt for sg_tablesize
    lpfc: Destroy lpfc_hba_index IDR on module exit
    Fix kmalloc overflow in LPFC driver at large core count
    lpfc:Make the function lpfc_sli4_mbox_completions_pending static in
      order to comply with function prototype
    lpfc: remove set but not used variables
    lpfc: Fix possible use-after-free and double free in
      lpfc_mbx_cmpl_rdp_page_a2()
    fix: lpfc_send_rscn_event sends bigger buffer size
  Add support for Lancer G6 and 32G FC links
  Fix for discovery failure in PT2PT when FLOGI's ELS ACC response gets
    aborted
  The linux driver does not reinitiate discovery after a failed FLOGI
  Fix default RA_TOV and ED_TOV in the FC/FCoE driver for all
    topologies
  Update version to 11.0.0.0 for upstream patch set

 drivers/scsi/lpfc/lpfc.h           |   8 +--
 drivers/scsi/lpfc/lpfc_attr.c      |  23 +++++----
 drivers/scsi/lpfc/lpfc_bsg.c       |  20 --------
 drivers/scsi/lpfc/lpfc_ct.c        |  11 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 100 +++++++++++--------------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  27 +++++++---
 drivers/scsi/lpfc/lpfc_hw.h        |   6 ++-
 drivers/scsi/lpfc/lpfc_init.c      |  36 ++++++++-----
 drivers/scsi/lpfc/lpfc_mbox.c      |  26 ++++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 -
 drivers/scsi/lpfc/lpfc_scsi.c      |  14 +-----
 drivers/scsi/lpfc/lpfc_sli.c       |  10 +---
 drivers/scsi/lpfc/lpfc_sli4.h      |   1 -
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 14 files changed, 117 insertions(+), 169 deletions(-)

-- 
1.7.11.7

