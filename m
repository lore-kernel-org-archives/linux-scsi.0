From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/24] osst: add a SPDX tag to osst.c
Date: Wed,  1 May 2019 12:14:17 -0400
Message-ID: <20190501161417.32592-25-hch@lst.de>
References: <20190501161417.32592-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501161417.32592-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, Chriosstoph Hellwig <hch@losst.de>
List-Id: linux-scsi@vger.kernel.org

osst.c is the only osst file missing licensing information.  Add a
GPLv2 tag for the default kernel license.

Signed-off-by: Chriosstoph Hellwig <hch@losst.de>
---
 drivers/scsi/osst.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index be3c73ebbfde..fe4f0e7d6359 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
   SCSI Tape Driver for Linux version 1.1 and newer. See the accompanying
   file Documentation/scsi/st.txt for more information.
-- 
2.20.1
