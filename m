Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57978C04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 06:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJVGdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 02:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJVGdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 02:33:31 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C75D2B733A;
        Fri, 21 Oct 2022 23:33:29 -0700 (PDT)
X-QQ-mid: bizesmtp90t1666420395t156loke
Received: from localhost.localdomain ( [182.148.15.254])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Oct 2022 14:33:13 +0800 (CST)
X-QQ-SSF: 01000000000000C0E000000A0000000
X-QQ-FEAT: hWIfutFPnzgDM/Y+7bTvF1MD1+GypHU/zCINYgLo+j6aWxU42xFhZM5bL3s2n
        ipQ/s2874Q4Ylf1W4iVc5INYH0YBgZ7yy5t5ptWR4wlloLOkB5Ben+oKGwWh4n7mVoE/wXk
        dH6oa28cUq11nm+IW6UEPiwvLI3VXdPRYaOVIVfwfr9WezKcocU+4wTZdKoyfzWjltgQtzB
        Zi0JtIKoYGogVEToMDvK5y3wxbQS0f99TWB/DZSATMOssy/GH5dGLcb30Ks/2TrqMAgIr9D
        eFzHW79NGW5gXnXDHm9mvSngizfjQeStEFcF2EehOWe9eI9LuYel7TZoFaTwbrc37EFz1q+
        eo5jkh82tYUoOy8GK0wN0bt0quB1e6pTj9Is6Z8lFPcdnwjfg8=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     artur.paszkiewicz@intel.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] scsi/isci: fix repeated words in comments
Date:   Sat, 22 Oct 2022 14:33:07 +0800
Message-Id: <20221022063307.22150-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/scsi/isci/remote_node_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index c7ee81d01125..f22950b12b8b 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -154,7 +154,7 @@ enum sci_remote_node_context_destination_state {
 /**
  * struct sci_remote_node_context - This structure contains the data
  *    associated with the remote node context object.  The remote node context
- *    (RNC) object models the the remote device information necessary to manage
+ *    (RNC) object models the remote device information necessary to manage
  *    the silicon RNC.
  */
 struct sci_remote_node_context {
-- 
2.36.1

