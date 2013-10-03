From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 0/2] qla2xxx: Patches for 3.12-rc.
Date: Thu, 3 Oct 2013 03:21:12 -0400
Message-ID: <1380784874-15457-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38413 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab3JCHwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2013 03:52:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.12-rc.

Thanks,
~Saurav

Chad Dupuis (2):
  qla2xxx: Fix request queue null dereference.
  qla2xxx: Remove entry in outstanding_cmds array if we fail to abort a
    request.

 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |    9 +++++++++
 drivers/scsi/qla2xxx/qla_os.c  |    8 ++++++++
 3 files changed, 18 insertions(+), 1 deletions(-)

-- 
1.7.7

