From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 0/2] qla2xxx: Patches for scsi "misc" branch.
Date: Tue, 23 Apr 2013 14:10:10 -0400
Message-ID: <1366740612-3561-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:56667
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758459Ab3DXWOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 18:14:07 -0400
Received: from mail215-ch1 (localhost [127.0.0.1])	by
 mail215-ch1-R.bigfish.com (Postfix) with ESMTP id 5806A2A00A7	for
 <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2013 22:14:05 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

This patchset fixes the sparse warnings. Please apply the following patches
to the scsi tree at your earliest convenience for inclusion in the next
mainline merge window.

Thanks,
~Saurav
 
Armen Baloyan (1):
  qla2xxx: fix sparse warning "large integer implicitly truncated to
    unsigned type"

Fengguang Wu (1):
  qla2xxx: qla2x00_sp_compl can be static.

 drivers/scsi/qla2xxx/qla_mr.c |    6 ++----
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

-- 
1.7.7


