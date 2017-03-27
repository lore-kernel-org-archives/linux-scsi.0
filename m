From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv5 0/2] tcmu: For bugs fix only
Date: Mon, 27 Mar 2017 17:07:39 +0800
Message-ID: <1490605661-16127-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2541 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdC0JHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 05:07:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: agrover@redhat.com, mchristi@redhat.com, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, iliastsi@arrikto.com, Xiubo Li <lixiubo@cmss.chinamobile.com>

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Changed for V5:
- This only includes #1 and #2. And for old #3, #4 are still reviewing.
- #1, since the issue reported by Ilias is a separate new one, and will
  create a new patch later.
- #2, address the issue pointed out by Mike, thanks.
- #1 and #2 have been tested by Ilias in BIDI case, thanks.

Changed for V4:
- re-order the #3, #4 at the head.
- merge most of the #5 to others.

Xiubo Li (2):
  tcmu: Fix possible overwrite of t_data_sg's last iov[]
  tcmu: Fix wrongly calculating of the base_command_size

 drivers/target/target_core_user.c | 44 +++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 13 deletions(-)

-- 
1.8.3.1
