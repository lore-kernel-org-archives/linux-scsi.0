From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill highmem_io leftover
Date: Sat, 20 Sep 2003 10:33:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920083351.GC20301@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:42477 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261671AbTITIdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 04:33:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Jens' missed this in his cleanup.


diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sat Sep 20 09:35:40 2003
+++ b/include/scsi/scsi_host.h	Sat Sep 20 09:35:40 2003
@@ -430,7 +430,6 @@
 
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
-	unsigned highmem_io:1;
 	unsigned use_blk_tcq:1;
 
 	/*
