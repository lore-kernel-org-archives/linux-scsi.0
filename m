From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] cciss: add Smart Array 5i to the kdump blacklist
Date: Mon, 28 Nov 2011 15:35:31 +0100
Message-ID: <4ED39C33.5090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1K1OgS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2011 09:36:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>

The '5i' controller freezes when a kdump is attemted.
This patch admits it and adds the controller
to the unresetable list.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

---
 drivers/block/cciss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..b43ed87 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -576,12 +576,14 @@ static u32 unresettable_controller[] = {
 	0x3215103C, /* Smart Array E200i */
 	0x3237103C, /* Smart Array E500 */
 	0x323D103C, /* Smart Array P700m */
+	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
 };
 
 /* List of controllers which cannot even be soft reset */
 static u32 soft_unresettable_controller[] = {
+	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
 };
-- 
1.7.6.4



