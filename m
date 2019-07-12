From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 07/12] Documentation/parisc: repointer docs to
 Documentation/arch/
Date: Fri, 12 Jul 2019 10:20:13 +0800
Message-ID: <20190712022018.27989-7-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: linux-s390@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org, linux-ia64@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linux-samsung-soc@vger.kernel.org, kvm@vger.kernel.org, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, linux-riscv@lists.infradead.org, Alex Shi <alex.shi@linux.alibaba.com>, linuxppc-dev@lists.ozlabs.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Since we move Documentation/parisc docs to Documentation/arch/parisc
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03a8c687f87f..e1aad1b8224c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12000,7 +12000,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git
 S:	Maintained
 F:	arch/parisc/
-F:	Documentation/parisc/
+F:	Documentation/arch/parisc/
 F:	drivers/parisc/
 F:	drivers/char/agp/parisc-agp.c
 F:	drivers/input/serio/gscps2.c
-- 
2.19.1.856.g8858448bb
