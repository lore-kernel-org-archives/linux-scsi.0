From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.6-rc2
Date: Sat, 02 Apr 2016 15:22:11 -0700
Message-ID: <1459635731.31390.113.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57073 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbcDBWWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2016 18:22:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hello Linus,

Here are outstanding target-pending fixes for v4.6-rc2.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes fixes from HCH for -rc1 configfs default_groups conversion
changes that ended up breaking some iscsi-target default_groups, along
with Sagi's ib_drain_qp() conversion for iser-target to use the common
caller now available to RDMA kernel consumers in v4.6+ code.

Thank you,

--nab

Christoph Hellwig (3):
  target: remove ->fabric_cleanup_nodeacl
  target: initialize the nacl base CIT begfore init_nodeacl
  target: add a new add_wwn_groups fabrics method

Sagi Grimberg (1):
  iser-target: Use ib_drain_qp

 drivers/infiniband/ulp/isert/ib_isert.c      | 39 +++-------------------------
 drivers/infiniband/ulp/isert/ib_isert.h      |  2 --
 drivers/target/iscsi/iscsi_target_configfs.c | 28 ++++++++------------
 drivers/target/target_core_fabric_configfs.c | 24 +++++++++--------
 include/target/target_core_fabric.h          |  2 +-
 5 files changed, 29 insertions(+), 66 deletions(-)

