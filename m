Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F7AC3F2D8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5AD5246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137084;
	bh=TVvdyl0GJrye7f1v4SAQ+y//NYsgAc5Ka71XcuuBSjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YapWOUQ/wz2hFwBV7QctPusrWlzM7+u3Gwoqp+/6sJQHwL31+KRBAthMjYoF4vtRC
	 K3yndxtPshbu6z0RngX9Eoa/GyuH7kBnCgKe5M3XNb0wmQMXz+kH8+wLnekBbC0kJe
	 BFO0tBDTu/M3YcajUwkneAJPU7J/EYSmm/SOE2O8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgCBISE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgCBIQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:21 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95302246F0;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=TVvdyl0GJrye7f1v4SAQ+y//NYsgAc5Ka71XcuuBSjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FghARQu1AiuwpGh4txG0QLaWAK30FBrduH4LFbhKtNrDXG2ZnpNP4+KiCBS4UckSd
         GT/xGHVLUk0AdFiy+q6261/ZbmwtC1eR/SAmkn59XNFexgw8/pNDEWd5T03kh7KsZG
         8GmY4j6g8ytDa7VOtQF5JeVG/cwgFJp2kx0MVpds=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003ya-Lu; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 25/42] docs: scsi: convert ppa.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:58 +0100
Message-Id: <3db8cd51d77fef6b66632249412969caa29dec40.1583136624.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/scsi/index.rst            |  1 +
 Documentation/scsi/{ppa.txt => ppa.rst} | 12 ++++++++----
 drivers/scsi/Kconfig                    |  4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)
 rename Documentation/scsi/{ppa.txt => ppa.rst} (32%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index eb2df0e0dcb7..17327f67af68 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -29,5 +29,6 @@ Linux SCSI Subsystem
    megaraid
    ncr53c8xx
    NinjaSCSI
+   ppa
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/ppa.txt b/Documentation/scsi/ppa.rst
similarity index 32%
rename from Documentation/scsi/ppa.txt
rename to Documentation/scsi/ppa.rst
index 05ff47dbe8d1..5fe3859a6892 100644
--- a/Documentation/scsi/ppa.txt
+++ b/Documentation/scsi/ppa.rst
@@ -1,13 +1,17 @@
--------- Terse where to get ZIP Drive help info --------
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
+Terse where to get ZIP Drive help info
+======================================
 
 General Iomega ZIP drive page for Linux:
-http://web.archive.org/web/*/http://www.torque.net/~campbell/
+http://web.archive.org/web/%2E/http://www.torque.net/~campbell/
 
 Driver archive for old drivers:
-http://web.archive.org/web/*/http://www.torque.net/~campbell/ppa
+http://web.archive.org/web/%2E/http://www.torque.net/~campbell/ppa
 
 Linux Parport page (parallel port)
-http://web.archive.org/web/*/http://www.torque.net/parport/
+http://web.archive.org/web/%2E/http://www.torque.net/parport/
 
 Email list for Linux Parport
 linux-parport@torque.net
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e47498f7627e..82462d6a4ce5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -804,7 +804,7 @@ config SCSI_PPA
 	  newer drives)", below.
 
 	  For more information about this driver and how to use it you should
-	  read the file <file:Documentation/scsi/ppa.txt>.  You should also read
+	  read the file <file:Documentation/scsi/ppa.rst>.  You should also read
 	  the SCSI-HOWTO, which is available from
 	  <http://www.tldp.org/docs.html#howto>.  If you use this driver,
 	  you will still be able to use the parallel port for other tasks,
@@ -831,7 +831,7 @@ config SCSI_IMM
 	  here and Y to "IOMEGA Parallel Port (ppa - older drives)", above.
 
 	  For more information about this driver and how to use it you should
-	  read the file <file:Documentation/scsi/ppa.txt>.  You should also read
+	  read the file <file:Documentation/scsi/ppa.rst>.  You should also read
 	  the SCSI-HOWTO, which is available from
 	  <http://www.tldp.org/docs.html#howto>.  If you use this driver,
 	  you will still be able to use the parallel port for other tasks,
-- 
2.21.1

