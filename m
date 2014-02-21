From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/6] hpsa: supplemental February 2014 driver updates
Date: Fri, 21 Feb 2014 16:24:47 -0600
Message-ID: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:48933 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaBUWZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 17:25:51 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 08E2B6127B
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 22:25:51 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

The following series applies on top of the 35 patches I sent on Feb 18
(see http://thread.gmane.org/gmane.linux.scsi/88433 )

The two main changes are to bring temporarily offline devices
(e.g. logical drives undergoing "rapid parity initialization")
online automatically when they become ready, and adding support
for "hba mode" for controllers which support this feature,
to expose physical disks to the OS.

---

Stephen M. Cameron (5):
      hpsa: remove unused kthread.h header
      hpsa: bring format-in-progress drives online when ready
      hpsa: remove unused struct request from CommandList
      hpsa: Add hba mode to the hpsa driver
      hpsa: Do not zero fields of ioaccel2 command structure twice

Tomas Henzl (1):
      hpsa: increase the probability of a reported success after a device reset


 drivers/scsi/hpsa.c     |  410 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/hpsa.h     |   50 ++++++
 drivers/scsi/hpsa_cmd.h |   21 ++
 3 files changed, 446 insertions(+), 35 deletions(-)

-- 
-- steve

