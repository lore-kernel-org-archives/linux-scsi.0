Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55E5C7EE2F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 21:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjERV16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 17:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjERV14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 17:27:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D785CC0;
        Thu, 18 May 2023 14:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yDH+ArLaMd1MpNSWYh/A1MRf2Rgus6BaFTXxBSJze68=; b=Jh/frAeYv5ETQfMQFtPJebX1Kx
        kNzQ7diUtmMNOL9WJg9cJM72ZF1vNC9llzk0HbgHGbauguhuPHThfbpOYAxVXO1g8NWNFPfguRWd2
        FNep8Fr0OaLrSpco61L1jMSRBFyIEiQY2djdQZB6OacK/auuTbGQ2UBU9rWvYUnlORy5nKfs5q4wD
        aSm92iQyvURHUAKhxHxkhYSUafnGki7b3gJujL0tf2QVSNyZ8jAuCiwdlT4cbI/uerp4pJLb9XRu6
        XqMeU05r/hu/Onos6tq6hXkrJdn5Z7dx4G/H2TzaurtGjTtiU+sgFHgBT3fSF6Lx6h/9QEBSFQqKK
        wUfLwuYA==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzlAB-00EFRV-2E;
        Thu, 18 May 2023 21:27:55 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, James Smart <james.smart@broadcom.com>
Subject: [PATCH 06/11] Docs/scsi: scsi_fc_transport: fix typo in heading
Date:   Thu, 18 May 2023 14:27:44 -0700
Message-Id: <20230518212749.18266-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518212749.18266-1-rdunlap@infradead.org>
References: <20230518212749.18266-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the typo "Tansport" to be "Transport".
Update email address for James Smart.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: James Smart <james.smart@broadcom.com>
---
 Documentation/scsi/scsi_fc_transport.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -- a/Documentation/scsi/scsi_fc_transport.rst b/Documentation/scsi/scsi_fc_transport.rst
--- a/Documentation/scsi/scsi_fc_transport.rst
+++ b/Documentation/scsi/scsi_fc_transport.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-================
-SCSI FC Tansport
-================
+=================
+SCSI FC Transport
+=================
 
 Date:  11/18/2008
 
@@ -556,5 +556,5 @@ The following people have contributed to
 
 
 James Smart
-james.smart@emulex.com
+james.smart@broadcom.com
 
