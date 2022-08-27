Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657EAECAAD1
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Aug 2022 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiH0WRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiH0WRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Aug 2022 18:17:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D5A356D5;
        Sat, 27 Aug 2022 15:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CqsSrwv6LBX1DUM5FDDv2YEm34QXshsPFmPP7e6meP0=; b=InQQ6CQcR599FI6x9Z6EcYgrLk
        25lZTfeTXfWTkQ4tDzqN+hUJImiAp3bvFzXsir5AuiRVFRAaSQBRjqxWQTjhuP0WjLrxNfjnnp7hq
        VL1HodFIC99dQ4JxMd85kCgJ3aqHWOoOqTh3e670pKavQcre0zmVA0PWFMACx3SV83MWyEJS/h1Vo
        N1LQ8WCD5ZOLTmcBQIGMKIEmyvuJHi4f8ceABuHM52fYV0QePGiqaonlysqktzSC2OZ7eq4IN8bgZ
        wqICjItlHpH1a1lP39OM4fZFy1DzpQkmUWbuCv7eC48Ey9Te+4uCDzQ9BitG5oBePN86hZxPuuR9e
        gAYkcTfQ==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oS47J-001k4N-TS; Sat, 27 Aug 2022 22:17:26 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-doc@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] Documentation/SCSI: fix a few typos
Date:   Sat, 27 Aug 2022 15:17:19 -0700
Message-Id: <20220827221719.11006-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Correct some spelling typos in SCSI documentation.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/scsi/ChangeLog.lpfc |    2 +-
 Documentation/scsi/scsi_eh.rst    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -401,7 +401,7 @@ Changes from 20041213 to 20041220
 	  structure.
 	* Integrated patch from Christoph Hellwig <hch@lst.de> Kill
 	  compile warnings on 64 bit platforms: %variables for %llx format
-	  specifiers must be caste to long long because %(u)int64_t can
+	  specifiers must be cast to long long because %(u)int64_t can
 	  just be long on 64bit platforms.
 	* Integrated patch from Christoph Hellwig <hch@lst.de> Removes
 	  dead code.
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -206,7 +206,7 @@ again.
 To achieve these goals, EH performs recovery actions with increasing
 severity.  Some actions are performed by issuing SCSI commands and
 others are performed by invoking one of the following fine-grained
-hostt EH callbacks.  Callbacks may be omitted and omitted ones are
+host EH callbacks.  Callbacks may be omitted and omitted ones are
 considered to fail always.
 
 ::
