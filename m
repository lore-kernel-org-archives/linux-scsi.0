Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F6AC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Jan 2021 18:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D2064E13
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Jan 2021 18:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhA3Sir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Jan 2021 13:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3Sir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2021 13:38:47 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD8C061574;
        Sat, 30 Jan 2021 10:38:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CD9B4128055B;
        Sat, 30 Jan 2021 10:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612031886;
        bh=q/xW+t84Ir4ayEKIr8IJSPCYvqV8LCPuXOXVWuclvpA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=rhckZhD+082BdcUYNSEB8Pza+p9I5YbrevEJ/fGQEzbjB5YZ1VIublxvWsvw8C4sO
         F6xWeWTelDQneNcwUkIDpXDfMCVYaPlhKKd08E7l9IH01uafoYqteEzF0215Rjxaor
         lLKpYU7GFHqnPEv3fE9jQlfPGDskYRyTnrF8xBXc=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SJun1Eem5FgW; Sat, 30 Jan 2021 10:38:06 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 7170E1280549;
        Sat, 30 Jan 2021 10:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612031886;
        bh=q/xW+t84Ir4ayEKIr8IJSPCYvqV8LCPuXOXVWuclvpA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=rhckZhD+082BdcUYNSEB8Pza+p9I5YbrevEJ/fGQEzbjB5YZ1VIublxvWsvw8C4sO
         F6xWeWTelDQneNcwUkIDpXDfMCVYaPlhKKd08E7l9IH01uafoYqteEzF0215Rjxaor
         lLKpYU7GFHqnPEv3fE9jQlfPGDskYRyTnrF8xBXc=
Message-ID: <563ef7e0fbd1a5ac6edf5957cc57aa4af17e4417.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 30 Jan 2021 10:38:05 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two minor fixes in drivers.  Both changing strings (one in a comment,
one in a module help text) with no code impact.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Enzo Matsumiya (1):
      scsi: qla2xxx: Fix description for parameter ql2xenforce_iocb_limit

Valdis Kletnieks (1):
      scsi: target: iscsi: Fix typo in comment

And the diffstat:

 drivers/scsi/qla2xxx/qla_os.c             | 2 +-
 drivers/target/iscsi/iscsi_target_login.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f80abe28f35a..0e0fe5b09496 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
 int ql2xenforce_iocb_limit = 1;
 module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xenforce_iocb_limit,
-		 "Enforce IOCB throttling, to avoid FW congestion. (default: 0)");
+		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
 
 /*
  * CT6 CTX allocation cache
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 893d1b406c29..1a9c50401bdb 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -896,7 +896,7 @@ int iscsit_setup_np(
 	else
 		len = sizeof(struct sockaddr_in);
 	/*
-	 * Set SO_REUSEADDR, and disable Nagel Algorithm with TCP_NODELAY.
+	 * Set SO_REUSEADDR, and disable Nagle Algorithm with TCP_NODELAY.
 	 */
 	if (np->np_network_transport == ISCSI_TCP)
 		tcp_sock_set_nodelay(sock->sk);

