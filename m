From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] de-uglify scsi.c
Date: Sat, 26 Apr 2003 18:34:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426183407.A18575@beaverton.ibm.com>
References: <20030426190303.A20780@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:36340 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263195AbTD0BZp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 21:25:45 -0400
Content-Disposition: inline
In-Reply-To: <20030426190303.A20780@lst.de>; from hch@lst.de on Sat, Apr 26, 2003 at 07:03:03PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph -

Thanks for cleaning up these and the prior ones.

I still needed interrupt.h to compile (with CONFIG_NOHIGHMEM=y) for
softirq code.

--- 1.105/drivers/scsi/scsi.c	Sat Apr 26 11:36:16 2003
+++ edited/drivers/scsi/scsi.c	Sat Apr 26 18:31:12 2003
@@ -46,6 +46,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/completion.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/unistd.h>

-- Patrick Mansfield
