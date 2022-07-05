Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7BFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 07:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiGEHrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 03:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiGEHrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 03:47:41 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90A3B13D4C;
        Tue,  5 Jul 2022 00:47:40 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 40C281E80D82;
        Tue,  5 Jul 2022 15:45:36 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jEs5Rsw-7Ret; Tue,  5 Jul 2022 15:45:33 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 239EC1E80D71;
        Tue,  5 Jul 2022 15:45:33 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] scsi: ch: Fix spelling mistake in comments
Date:   Tue,  5 Jul 2022 15:47:35 +0800
Message-Id: <20220705074735.22184-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix spelling of Hav'nt in comments.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/scsi/ch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 908854869864..0a3011595fbf 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -127,7 +127,7 @@ static const struct {
 	unsigned char  ascq;
 	int	       errno;
 } ch_err[] = {
-/* Just filled in what looks right. Hav'nt checked any standard paper for
+/* Just filled in what looks right. Haven't checked any standard paper for
    these errno assignments, so they may be wrong... */
 	{
 		.sense  = ILLEGAL_REQUEST,
-- 
2.34.1

