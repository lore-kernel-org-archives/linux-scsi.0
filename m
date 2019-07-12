From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 10/12] Documentation/sparc: repointer docs to Documentation/arch/
Date: Fri, 12 Jul 2019 10:20:16 +0800
Message-ID: <20190712022018.27989-10-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since we move Documentation/sparc docs to Documentation/arch/sparc
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/sbus/char/oradax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/sbus/char/oradax.c b/drivers/sbus/char/oradax.c
index 8af216287a84..c7db146a1dd5 100644
--- a/drivers/sbus/char/oradax.c
+++ b/drivers/sbus/char/oradax.c
@@ -18,7 +18,7 @@
  * the recommended way for applications to use the coprocessor, and
  * the driver interface is not intended for general use.
  *
- * See Documentation/sparc/oradax/oracle-dax.rst for more details.
+ * See Documentation/arch/sparc/oradax/oracle-dax.rst for more details.
  */
 
 #include <linux/uaccess.h>
-- 
2.19.1.856.g8858448bb
