From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 0/2] qla2xxx: Miscellaneous fixes
Date: Fri, 8 Aug 2014 07:38:07 -0400
Message-ID: <1407497889-4814-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:56749 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008AbaHHMKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 08:10:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de
Cc: giridhar.malavali@qlogic.com

Hi James, Christoph,

Pleas apply the following two patches at your earliest convenience.

Thanks,
Chad

Chad Dupuis (2):
  qla2xxx: Move mailbox failure messages to a default debug level.
  qla2xxx: Remove restriction on starting remote device discovery on
    port     update.

 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 10 ++++------
 drivers/scsi/qla2xxx/qla_mbx.c |  2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

-- 
1.8.5.2

