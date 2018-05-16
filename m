From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 42/42] proc: update SIZEOF_PDE_INLINE_NAME for the new pde
 fields
Date: Wed, 16 May 2018 11:43:46 +0200
Message-ID: <20180516094346.20506-43-hch@lst.de>
References: <20180516094346.20506-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

This makes Alexey happy and Al groan.  Based on a patch from
Alexey Dobriyan.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/proc/internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 84c68508a256..a318ae5b36b4 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -62,9 +62,9 @@ struct proc_dir_entry {
 	umode_t mode;
 	u8 namelen;
 #ifdef CONFIG_64BIT
-#define SIZEOF_PDE_INLINE_NAME	(192-139)
+#define SIZEOF_PDE_INLINE_NAME	(192-155)
 #else
-#define SIZEOF_PDE_INLINE_NAME	(128-87)
+#define SIZEOF_PDE_INLINE_NAME	(128-95)
 #endif
 	char inline_name[SIZEOF_PDE_INLINE_NAME];
 } __randomize_layout;
-- 
2.17.0
