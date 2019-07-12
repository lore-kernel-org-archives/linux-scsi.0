From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 04/12] Documentation/m68k: repointer docs to Documentation/arch/
Date: Fri, 12 Jul 2019 10:20:10 +0800
Message-ID: <20190712022018.27989-4-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, Will Deacon <will@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Since we move Documentation/m68k docs to Documentation/arch/m68k
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/admin-guide/kernel-parameters.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 5d29ba5ad88c..dc283dcffae8 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -118,7 +118,7 @@ parameter is applicable::
 	LOOP	Loopback device support is enabled.
 	M68k	M68k architecture is enabled.
 			These options have more detailed description inside of
-			Documentation/m68k/kernel-options.txt.
+			Documentation/arch/m68k/kernel-options.txt.
 	MDA	MDA console support is enabled.
 	MIPS	MIPS architecture is enabled.
 	MOUSE	Appropriate mouse support is enabled.
-- 
2.19.1.856.g8858448bb
