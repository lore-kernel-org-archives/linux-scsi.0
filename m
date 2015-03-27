From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/3] scsi: ufs: fix several issues caused by driver reloading
Date: Sat, 28 Mar 2015 08:51:44 +0900
Message-ID: <1427500307-5649-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35786 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbC0XwC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 19:52:02 -0400
Received: by pdbop1 with SMTP id op1so110774011pdb.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 16:52:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>

This patch set addresses several issues caused by driver reloading in
ufs driver, although the first patch also fixes error path in driver
probe.

Akinobu Mita (3):
  scsi: ufs: avoid using hostdata after scsi_host_put()
  scsi: ufs: fix unbalanced power.usage_count after reloading driver
  scsi: ufs: fix unbalanced power.disable_depth after reloading driver

 drivers/scsi/ufs/ufshcd-pltfrm.c | 5 +++++
 drivers/scsi/ufs/ufshcd.c        | 6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
1.9.1

