From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 15/24] MAINTAINERS: remove firmware/isci/
Date: Fri, 23 Nov 2012 22:26:39 -0200
Message-ID: <1353716808-16375-16-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, Ben Hutchings <ben@decadent.org.uk>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>, Intel SCU Linux support <intel-linux-scu@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This directory was removed by commit 7d99b3a (isci, firmware: Remove
isci fallback parameter blob and generator).

Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd3049f..3a09993 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3876,7 +3876,6 @@ L:	linux-scsi@vger.kernel.org
 T:	git git://git.code.sf.net/p/intel-sas/isci
 S:	Supported
 F:	drivers/scsi/isci/
-F:	firmware/isci/
 
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
-- 
1.7.11.7
