From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH resend] include/linux: Add bsg.h to the Kernel exported headers
Date: Sun, 18 Jan 2009 10:23:25 +0200
Message-ID: <4972E6FD.8070405@panasas.com>
References: <496EFA69.3050007@panasas.com> <20090115202155G.fujita.tomonori@lab.ntt.co.jp> <496F26DF.9050303@panasas.com> <20090115212942R.fujita.tomonori@lab.ntt.co.jp> <20090115164824.e637b8c6.akpm@linux-foundation.org> <20090116065003.GU30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:22970 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756867AbZARIXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2009 03:23:32 -0500
In-Reply-To: <20090116065003.GU30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dougg@torque.net, stable@kernel.org


bsg.h in current form is perfectly suitable for user-mode
consumption. It is needed together with scsi/sg.h for applications
that want to interface with the bsg driver.

Currently the few projects that use it would copy it over into
the projects. But that is not acceptable for projects that need
to provide source and devel packages for distros.

This should also be submitted to stable 2.6.28 and 2.6.27 since bsg had
a stable API since these Kernels and distro users will need the header
for these kernels a swell

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Ack-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: stable@kernel.org
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 12e9a29..2124c06 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += bsg.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h
-- 
1.6.0.1


