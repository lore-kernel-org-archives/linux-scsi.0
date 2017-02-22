From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 0/3] cciss: Fix coccinelle/checkpatch warnings.
Date: Wed, 22 Feb 2017 17:12:35 +1100
Message-ID: <1487743958-4208-1-git-send-email-me@tobin.cc>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50746 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751349AbdBVGMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 01:12:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "Tobin C. Harding" <me@tobin.cc>

Re-send after spell checking. :(

Coccinelle warns about unnecessary cast on call to kmalloc(). Checkpatch
emits various warnings when parsing file.

Clean up two checkpatch warnings. Remove trailing whitespace and
clean up opening brace position. Remove unnecessary cast on kmalloc().

Tobin C. Harding (3):
  cciss: Fix checkpatch TRAILING_WHITESPACE
  cciss: Fix checkpatch OPEN_BRACE
  cciss: Remove kmalloc cast

 drivers/block/cciss_scsi.c | 182 ++++++++++++++++++++++-----------------------
 1 file changed, 88 insertions(+), 94 deletions(-)

-- 
2.7.4
