From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI, ISCSI: Just #include "host.h" once in host.c
Date: Sun, 5 Feb 2012 01:37:56 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202050136330.30244@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Ed Nadolski <edmund.nadolski@intel.com>, Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Intel SCU Linux support <intel-linux-scu@intel.com>
List-Id: linux-scsi@vger.kernel.org

There's no need to include the header twice.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/isci/host.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1a65d65..0061cfd 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -58,7 +58,6 @@
 #include "host.h"
 #include "isci.h"
 #include "port.h"
-#include "host.h"
 #include "probe_roms.h"
 #include "remote_device.h"
 #include "request.h"
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
