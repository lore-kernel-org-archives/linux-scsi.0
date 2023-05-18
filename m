Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688BBC7EE2F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 21:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjERV2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 17:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjERV2B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 17:28:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB9BC0;
        Thu, 18 May 2023 14:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wCJLW2KFoW/rGtmtgLZGT7n2nX6Q3LE7uo8h2RlQ+Gg=; b=PPq02Yn+RHBfhLAbrxZC/HrRlw
        y2OT4IC41YQZ9cWLDC2vbnCu4sdR+x5YSMQ3UOZRlwZ4PoRDJFgrzhXND3otXp3mTxCPXQCmENas8
        w/IfdHwacEJWP8CaAkMEBaUrco4VOMpDi+JShUO/9xht3qzjpDkZeMGo0bT8my1ehk/+UbvDvxoER
        Zutp/GNGQoVW2/9oFGqn48GSGCMxUQeDCax0aVLm48k1BZ0js8vshgALUJGNugrPFFH3m0dMkXm3t
        xLK/CkliDRM/TwGV4BrQsnlW3P8WZBX8FK3Jz6YUm8J9LieNnHr0vsZtaEESlW0NyeLaj1TF5YJTG
        WFWd17xA==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzlAB-00EFRV-10;
        Thu, 18 May 2023 21:27:55 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>, dc395x@twibble.org
Subject: [PATCH 05/11] Docs/scsi: dc395x: shorten the chapter heading
Date:   Thu, 18 May 2023 14:27:43 -0700
Message-Id: <20230518212749.18266-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518212749.18266-1-rdunlap@infradead.org>
References: <20230518212749.18266-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the heading be concise yet still descriptive.
This makes the subsystem table of contents more readable (IMO).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: dc395x@twibble.org
---
 Documentation/scsi/dc395x.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -- a/Documentation/scsi/dc395x.rst b/Documentation/scsi/dc395x.rst
--- a/Documentation/scsi/dc395x.rst
+++ b/Documentation/scsi/dc395x.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-======================================
-README file for the dc395x SCSI driver
-======================================
+==================
+dc395x SCSI driver
+==================
 
 Status
 ------
