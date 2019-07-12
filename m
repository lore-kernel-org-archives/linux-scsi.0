From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 06/12] Documentation/mips: repointer docs to Documentation/arch/
Date: Fri, 12 Jul 2019 10:20:12 +0800
Message-ID: <20190712022018.27989-6-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

Since we move Documentation/mips docs to Documentation/arch/mips
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c1e65c236db..03a8c687f87f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10554,7 +10554,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git
 Q:	http://patchwork.linux-mips.org/project/linux-mips/list/
 S:	Supported
 F:	Documentation/devicetree/bindings/mips/
-F:	Documentation/mips/
+F:	Documentation/arch/mips/
 F:	arch/mips/
 F:	drivers/platform/mips/
 
-- 
2.19.1.856.g8858448bb
