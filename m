From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scsi: 3w-xxxx: Drop duplicated function name
Date: Fri,  6 Feb 2015 15:41:44 +0100
Message-ID: <1423233704-27449-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mentioning the enclosing function twice doesn't add value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c75f2048319f..67539e73fdad 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -860,7 +860,7 @@ static int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 			tw_dev->alignment_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
 			break;
 		default:
-			printk(KERN_WARNING "3w-xxxx: tw_allocate_memory(): case slip in tw_allocate_memory()\n");
+			printk(KERN_WARNING "3w-xxxx: tw_allocate_memory(): case slip\n");
 			return 1;
 		}
 	}
-- 
2.1.3
