From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] target: fix kernel-doc warnings in
 drivers/target/target_core_transport.c
Date: Fri, 22 Dec 2017 14:06:42 -0800
Message-ID: <b2fa87ef-6c41-57a1-0e64-ac7cf73c5e91@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51574 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755934AbdLVWGz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 17:06:55 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Randy Dunlap <rdunlap@infradead.org>

Correct a function parameter's name to eliminate kernel-doc warnings
in drivers/target/target_core_transport.c.

Fixes these kernel-doc warnings: (tested by adding these files to a new
target.rst documentation file: WIP)

../drivers/target/target_core_transport.c:1671: warning: No description found for parameter 'fabric_tmr_ptr'
../drivers/target/target_core_transport.c:1671: warning: Excess function parameter 'fabric_context' description in 'target_submit_tmr'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	"Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc:	linux-scsi@vger.kernel.org
Cc:	target-devel@vger.kernel.org
Cc:	Sagi Grimberg <sagi@grimberg.me>
Cc:	linux-rdma@vger.kernel.org
Cc:	"James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc:	"Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20171221.orig/drivers/target/target_core_transport.c
+++ linux-next-20171221/drivers/target/target_core_transport.c
@@ -1654,7 +1654,7 @@ static bool target_lookup_lun_from_tag(s
  * @se_sess: associated se_sess for endpoint
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @fabric_context: fabric context for TMR req
+ * @fabric_tmr_ptr: fabric context for TMR req
  * @tm_type: Type of TM request
  * @gfp: gfp type for caller
  * @tag: referenced task tag for TMR_ABORT_TASK
