From: <viral.mehta@lntinfotech.com>
Subject: [PATCH] remove unnecessary code
Date: Mon, 17 May 2010 15:20:54 +0530
Message-ID: <1274089854-2704-1-git-send-email-viral.mehta@lntinfotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail142.messagelabs.com ([216.82.249.99]:7460 "EHLO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab0EQJt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2010 05:49:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Viral Mehta <viral.mehta@lntinfotech.com>

From: Viral Mehta <viral.mehta@lntinfotech.com>

cd->disk cannot change in between, remove the first assignement

Signed-off-by: Viral Mehta <viral.mehta@lntinfotech.com>
---
 drivers/scsi/sr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0a90abc..951d554 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -609,7 +609,6 @@ static int sr_probe(struct device *dev)
        blk_queue_rq_timeout(sdev->request_queue, SR_TIMEOUT);

        cd->device = sdev;
-       cd->disk = disk;
        cd->driver = &sr_template;
        cd->disk = disk;
        cd->capacity = 0x1fffff;
--
1.6.6


This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
