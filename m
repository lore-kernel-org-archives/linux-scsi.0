From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: Patches for 3.4-rc.
Date: Wed, 25 Apr 2012 07:26:12 -0700
Message-ID: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:49302
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab2DYOly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 10:41:54 -0400
Received: from mail33-db3 (localhost [127.0.0.1])	by mail33-db3-R.bigfish.com
 (Postfix) with ESMTP id 7EEF92A0238	for <linux-scsi@vger.kernel.org>; Wed, 25
 Apr 2012 14:41:52 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.4-rc.

Thanks,
Chad

Chad Dupuis (1):
  qla2xxx: Update version number to 8.04.00.03-k.

Giridhar Malavali (2):
  qla2xxx: Block flash access from application when device is
    initialized for ISP82xx.
  qla2xxx: Proper completion to scsi-ml for scsi status task_set_full
    and busy.

Saurav Kashyap (1):
  qla2xxx: Properly check for current state after the fabric-login
    request.

Vikas Chaudhary (1):
  qla2xxx: Fix reset time out as qla2xxx not ack to reset request.

 drivers/scsi/qla2xxx/qla_bsg.c     |    3 +++
 drivers/scsi/qla2xxx/qla_dbg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   15 +++++++++++++--
 drivers/scsi/qla2xxx/qla_nx.c      |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |   18 +++++++++++++++++-
 drivers/scsi/qla2xxx/qla_sup.c     |    3 +++
 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 7 files changed, 41 insertions(+), 7 deletions(-)


