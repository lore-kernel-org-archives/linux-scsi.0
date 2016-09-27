From: Yijing Wang <wangyijing@huawei.com>
Subject: [RFC][PATCH v2 0/2] Improve libsas hotplug
Date: Tue, 27 Sep 2016 11:15:45 +0800
Message-ID: <1474946145-29755-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:3919 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933729AbcI0DO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 23:14:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, tj@kernel.org, chenqilin2@huawei.com, wangyijing@huawei.com, fangwei1@huawei.com, heyousong@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

v1-v2: Fix memory allocation issue in interrupt context.

Yijing Wang (2):
  libsas: Alloc dynamic work to avoid missing sas events
  libsas: Fix hotplug issue in libsas

 drivers/scsi/libsas/sas_ata.c       |  34 ++---
 drivers/scsi/libsas/sas_discover.c  | 245 ++++++++++++++++++++++++++----------
 drivers/scsi/libsas/sas_event.c     |  61 +++++----
 drivers/scsi/libsas/sas_expander.c  |  54 ++++++--
 drivers/scsi/libsas/sas_init.c      |  31 ++++-
 drivers/scsi/libsas/sas_internal.h  |  45 ++++++-
 drivers/scsi/libsas/sas_phy.c       |  50 +++-----
 drivers/scsi/libsas/sas_port.c      |  35 ++++--
 drivers/scsi/libsas/sas_scsi_host.c |  23 ++++
 include/scsi/libsas.h               |  13 +-
 include/scsi/sas_ata.h              |   4 +-
 11 files changed, 404 insertions(+), 191 deletions(-)

-- 
2.5.0

