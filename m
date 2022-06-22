Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E2EC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 04:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356656AbiFVE2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 00:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347603AbiFVE2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 00:28:15 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5EC1164;
        Tue, 21 Jun 2022 21:28:10 -0700 (PDT)
X-QQ-mid: bizesmtp76t1655872072t0sbflxy
Received: from ubuntu.localdomain ( [106.117.99.132])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 12:27:45 +0800 (CST)
X-QQ-SSF: 01000000000000B0B000000A0000000
X-QQ-FEAT: YBQGNezXUixhClSyTQNJLLHSXzXoGnbJGm2Jfa8f1VUS6aQmoRoOKkjcurn5p
        nnRDex2ee5BIuWGL2PmTSpbIOc6htrnTgzJrbWEDHCICXFv6JiH7ZS70+UPfUaQz/snD32Z
        J6iuT0ortyNuYXa2Yh6M1QAYKLQ8bG+fY2iA2J95IxKmVTSGNeEbN0/Q/C+Duk7zz9BvKMR
        f5JkusQNlpPEZfOCJJAXwQGZmTl+7ThEOvd1eK1RhGJYh6L8NBQtniY8ZAm9sEfNGnoYB3p
        DV7lWktGQlYF//udvBo7CEH4R4BkZ5AIK+dSMIH/ot41ktQ7geZyc4kNrDNfQwJ9QIcmKPj
        I/zDCF7rCaKpSVnCEz7MwEVSpv74HRbVZbR6f+f
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     artur.paszkiewicz@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] scsi: isci: task: Remove duplicate 'the'
Date:   Wed, 22 Jun 2022 12:27:42 +0800
Message-Id: <20220622042742.11828-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix an obvious typing error, found by spellcheck(1).

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/scsi/isci/task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index c514b20293b2..9a311a58c37c 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,7 +67,7 @@
 /**
 * isci_task_refuse() - complete the request to the upper layer driver in
 *     the case where an I/O needs to be completed back in the submit path.
-* @ihost: host on which the the request was queued
+* @ihost: host on which the request was queued
 * @task: request to complete
 * @response: response code for the completed task.
 * @status: status code for the completed task.
-- 
2.17.1

