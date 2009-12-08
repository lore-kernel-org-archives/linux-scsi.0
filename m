From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/5] hpsa: fix a few more small things
Date: Tue, 08 Dec 2009 15:38:06 -0600
Message-ID: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28966 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbZLHViu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 16:38:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

Use msleep instead of schedlue_timeout, rename a few too-generic
variable names, return SCSI_MLQUEUE_HOST_BUSY on command allocation
failure, fix (again) incorrect SCSI status reporting, suppress
noisy messages about unsupported SCSI REPORT LUNS.

---
These patches apply on top of the big hpsa patch already in Andrew Morton's tree.

Stephen M. Cameron (5):
      Use msleep() instead of schedule_timeout
      hpsa: rename too generic variable names
      hpsa:  Return SCSI_MLQUEUE_HOST_BUSY on command allocation failure.
      hpsa: Fix incorrect SCSI status reporting
      hpsa: suppress messages due to unsupport SCSI REPORT_LUNS


 drivers/scsi/hpsa.c |   93 +++++++++++++++++++++++++++------------------------
 drivers/scsi/hpsa.h |    4 +-
 2 files changed, 52 insertions(+), 45 deletions(-)

--
-- steve 
