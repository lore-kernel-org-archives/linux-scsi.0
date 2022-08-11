Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C27C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 15:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiHKP1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 11:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiHKP1j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 11:27:39 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB37745041;
        Thu, 11 Aug 2022 08:27:36 -0700 (PDT)
X-QQ-mid: bizesmtp77t1660231645t1zkdabr
Received: from localhost.localdomain ( [110.188.55.240])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 23:27:12 +0800 (CST)
X-QQ-SSF: 0100000000200080H000B00A0000020
X-QQ-FEAT: znfcQSa1hKbye8002B+3ChSwQTxvPS91ZN0PEfAsmpK6WSzIO68Fa27pi10jw
        Ddhs+JMxlA/JzGGIuW3vFoZzIWA7kwpskSQmkYl7EMf2UAu6B+x9ttEBO4cUg9TyAAUAhYB
        Ur0CQoiFyo/jDIdCPLPAuDu2qlIfyA/6NHFJLR/iGioIfVmgLXl9czJOWATtoTaqKWtnDXC
        9IkcgZm/YvM/bw2frTd76Iqv6UUP3ih18avx1pX8auRtKIEItH/SHfk9hOBDWyD2vWm3vcX
        d+os03GDZNgkEKNgaspXyN4anLSCjRvsL1Wo7coMsjjpNL9bPsClMZysdUipWpL2W9rEARH
        Pd5Bk5+Cx/kicPlmPu02h05G/8S0Wbj4i8ILmGItqmd0ZLa5+IZzWUzP2I+oGtDfDhL+tv8
X-QQ-GoodBg: 0
From:   min tang <tangmin@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        min tang <tangmin@cdjrlc.com>
Subject: [PATCH] isci: Fix comment typo
Date:   Thu, 11 Aug 2022 23:27:00 +0800
Message-Id: <20220811152700.12979-1-tangmin@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The double 'the' is duplicated in line 201, remove one,The double `is' is duplicated in line 211, remove one,The double `for' is duplicated in line 214, remove one.

Signed-off-by: min tang <tangmin@cdjrlc.com>
---
 drivers/scsi/isci/remote_device.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 3ad681c4c20a..4e0e5ce9b592 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -198,7 +198,7 @@ enum sci_status sci_remote_device_reset_complete(
  * permitted.  This state is entered from the INITIAL state.  This state
  * is entered from the STOPPING state.
  *
- * @SCI_DEV_STARTING: This state indicates the the remote device is in
+ * @SCI_DEV_STARTING: This state indicates the remote device is in
  * the process of becoming ready (i.e. starting).  In this state no new
  * IO operations are permitted.  This state is entered from the STOPPED
  * state.
@@ -208,10 +208,10 @@ enum sci_status sci_remote_device_reset_complete(
  * This state is entered from the STARTING state.
  *
  * @SCI_STP_DEV_IDLE: This is the idle substate for the stp remote
- * device.  When there are no active IO for the device it is is in this
+ * device.  When there are no active IO for the device it is in this
  * state.
  *
- * @SCI_STP_DEV_CMD: This is the command state for for the STP remote
+ * @SCI_STP_DEV_CMD: This is the command state for the STP remote
  * device.  This state is entered when the device is processing a
  * non-NCQ command.  The device object will fail any new start IO
  * requests until this command is complete.
-- 
2.17.1

