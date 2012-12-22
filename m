From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/8] bnx2fc version 1.0.13
Date: Fri, 21 Dec 2012 19:40:26 -0800
Message-ID: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2856 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2LVDki (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Hi James,

Please consider including the following patches in 3.8+ merge window.

Thanks,
Bhanu

Bhanu Prakash Gollapudi (6):
  bnx2fc: support software fcoe target
  bnx2fc: Move offload/upload wait logic into a function
  bnx2fc: Map the doorbell register between offload and enable requests
  bnx2fc: Tx/Rx byte counts reset to 0 when exceeding 32 bit values
  bnx2fc: Support max IO size to 512KB
  bnx2fc: Bumped version to 1.0.13

Cyril Roelandt (1):
  bnx2fc: remove useless calls to memset().

Julia Lawall (1):
  bnx2fc: Remove potential NULL dereference

 drivers/scsi/bnx2fc/bnx2fc.h      |   27 ++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   21 +++++---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   29 ++---------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    6 ++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |   95 +++++++++++++++++++-----------------
 5 files changed, 100 insertions(+), 78 deletions(-)


