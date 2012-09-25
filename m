From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] MAINTAINERS: update Intel C600 SAS driver maintainers
Date: Tue, 25 Sep 2012 15:24:56 -0700
Message-ID: <20120925222456.26307.21809.stgit@djiang5-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: lukasz.dorau@intel.com, maciej.patelczyk@intel.com, jeffrey.d.skirvin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 MAINTAINERS |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b17587d..162f602 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3552,11 +3552,12 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
+M:	Lukasz Dorau <lukasz.dorau@intel.com>
+M:	Maciej Patelczyk <maciej.patelczyk@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
-M:	Ed Nadolski <edmund.nadolski@intel.com>
 L:	linux-scsi@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
-S:	Maintained
+T:	git git://git.code.sf.net/p/intel-sas/isci
+S:	Supported
 F:	drivers/scsi/isci/
 F:	firmware/isci/
 
