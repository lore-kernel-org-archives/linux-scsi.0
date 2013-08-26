From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 0/5] Patches to clean up SCSI code
Date: Mon, 26 Aug 2013 11:03:35 -0400
Message-ID: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3HZPDl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 11:03:41 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3fI7025119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:41 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3eJW014378
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This is a set of 5 patches to clean up the SCSI code.
They consist of various things found during development
and review of some changes for Unit Attention handling
(which was submitted as a separate patch).

Ewan D. Milne (5):
  scsi: Fix incorrect function name in comment
  scsi: Correct size of envp[]
  scsi: Add missing newline to scsi_sysfs.c
  scsi: Change to use list_for_each_entry_safe
  scsi: Rename scsi_evt_thread() to scsi_evt_work()

 drivers/scsi/scsi_lib.c   |  8 ++++----
 drivers/scsi/scsi_priv.h  |  1 +
 drivers/scsi/scsi_scan.c  |  3 +--
 drivers/scsi/scsi_sysfs.c | 10 ++++------
 4 files changed, 10 insertions(+), 12 deletions(-)

-- 
1.7.11.7

