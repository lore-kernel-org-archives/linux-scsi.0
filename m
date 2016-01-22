From: Wei Liu <wei.liu2@citrix.com>
Subject: [PATCH v2 3/3] xen-scsiback: fix license ident used in MODULE_LICENSE
Date: Fri, 22 Jan 2016 14:04:17 +0000
Message-ID: <1453471457-10908-4-git-send-email-wei.liu2@citrix.com>
References: <1453471457-10908-1-git-send-email-wei.liu2@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453471457-10908-1-git-send-email-wei.liu2@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xen-devel <xen-devel@lists.xenproject.org>
Cc: David Vrabel <david.vrabel@citrix.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Wei Liu <wei.liu2@citrix.com>, Juergen Gross <jgross@suse.com>, "open list:XEN PVSCSI DRIVERS" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The comment at the beginning of the file is the canonical source of
licenses for this module. The license used to distribute outside of
Linux kernel is not BSD license but X11 license. Instead of trying to
determine whether X11 license can be mapped into Linux's "MIT" license
ident, simply make the code to use "GPL" only.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
---
 drivers/xen/xen-scsiback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index ad4eb10..250d70f 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1915,6 +1915,6 @@ module_init(scsiback_init);
 module_exit(scsiback_exit);
 
 MODULE_DESCRIPTION("Xen SCSI backend driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL");
 MODULE_ALIAS("xen-backend:vscsi");
 MODULE_AUTHOR("Juergen Gross <jgross@suse.com>");
-- 
2.1.4
