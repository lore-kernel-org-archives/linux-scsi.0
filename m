From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 0/2] qla2xxx: Patches for 3.10-rc.
Date: Fri, 12 Jul 2013 14:47:49 -0400
Message-ID: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:56427
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757320Ab3GLTOt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 15:14:49 -0400
Received: from mail5-ch1 (localhost [127.0.0.1])	by mail5-ch1-R.bigfish.com
 (Postfix) with ESMTP id A4E8A403E1	for <linux-scsi@vger.kernel.org>; Fri, 12
 Jul 2013 19:14:48 +0000 (UTC)
Received: from CH1EHSMHS036.bigfish.com (snatpool2.int.messaging.microsoft.com
 [10.43.68.236])	by mail5-ch1.bigfish.com (Postfix) with ESMTP id 9B62540004C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2013 19:14:45 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.10-rc.

Thanks,
~Saurav
 
Saurav Kashyap (2):
  qla2xxx: Fix sparse warnings in qlafx00_fxdisc_iocb function.
  qla2xxx: Properly set the tagging for commands.

 drivers/scsi/qla2xxx/qla_iocb.c |   11 +++++++++--
 drivers/scsi/qla2xxx/qla_mr.h   |    6 ++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.7.7


