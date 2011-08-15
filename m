From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] osd: Kconfig remove wrong FIXME
Date: Mon, 15 Aug 2011 12:01:41 -0700
Message-ID: <4E496D15.1010404@panasas.com>
References: <20110811142749.GA26109@maxin> <CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com> <4E4968F0.9050108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:32961 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1HOTBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2011 15:01:51 -0400
In-Reply-To: <4E4968F0.9050108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Maxin B John <maxin.john@gmail.com>
Cc: rdunlap@xenotime.net, osd-dev@open-osd.org, linux-scsi@vger.kernel.org


The OSD protocol calls for all kind of security levels that use
CRYPTO_HMAC and SH1, but the current code only supports NO_SEC,
which does not use any of these.

Remove a wrong FIXME that calls for them. Thanks Maxin for
reporting on this.

CC: "Maxin B. John" <maxin.john@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
index 861b5ce..a070351 100644
--- a/drivers/scsi/osd/Kconfig
+++ b/drivers/scsi/osd/Kconfig
@@ -11,10 +11,6 @@
 # it under the terms of the GNU General Public version 2 License as
 # published by the Free Software Foundation
 #
-# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
-#        How is it done properly?
-#
-
 config SCSI_OSD_INITIATOR
 	tristate "OSD-Initiator library"
 	depends on SCSI
-- 
1.7.6


