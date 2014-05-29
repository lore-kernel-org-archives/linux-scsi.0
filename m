From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 00/24] Resend of May 2014 patches for hpsa driver
Date: Thu, 29 May 2014 10:52:14 -0500
Message-ID: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:31363 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbaE2PxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:53:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

Not a lot of extensive changes in this set, some new PCI IDs,
some small bug fixes, quieting some noisy messages, allowing
more reply queues, setting irq affinity hints, and some minor
locking improvments.

Two patches are slightly changed since they were first sent due
to reviewer comments and some new or previously unnoticed
checkpatch complaints.

"hpsa: fix handling of hpsa_volume_offline return value"
was changed slightly to avoid some type casting, and 
"hpsa: use gcc aligned attribute instead of manually padding structs"
was changed to use "__align(x)" instead of "__attribute((aligned(x)))"

 drivers/scsi/hpsa.c     |  297 +++++++++++++++++++++++++++++------------------
 drivers/scsi/hpsa.h     |   43 ++++---
 drivers/scsi/hpsa_cmd.h |   49 +++-----
 3 files changed, 226 insertions(+), 163 deletions(-)

-- 
-- steve

