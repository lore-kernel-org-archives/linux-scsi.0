From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] kill drivers/scsi/hosts.h
Date: Wed, 9 Feb 2005 02:54:43 +0100
Message-ID: <20050209015443.GB2978@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52228 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261739AbVBIByp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2005 20:54:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Since more than half a year ago, drivers/scsi/hosts.h gives a warning, 
so it seems to be time to remove it.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.11-rc3-mm1-full/drivers/scsi/hosts.h	2004-12-24 22:34:30.000000000 +0100
+++ /dev/null	2004-11-25 03:16:25.000000000 +0100
@@ -1,2 +0,0 @@
-#warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
-#include <scsi/scsi_host.h>
