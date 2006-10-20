From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] replace u8 and u32 with __u8 and __u32 in scsi.h for user
 space
Date: Fri, 20 Oct 2006 09:08:18 +0900
Message-ID: <20061020090818H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:35563 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1946730AbWJTAIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 20:08:24 -0400
Received: from vcs3.rdh.ecl.ntt.co.jp (vcs3.rdh.ecl.ntt.co.jp [129.60.39.110])
	by tama5.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id k9K08LbR011057
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 09:08:21 +0900 (JST)
Received: from mfs3.rdh.ecl.ntt.co.jp (mfs3.rdh.ecl.ntt.co.jp [129.60.39.112])
	by vcs3.rdh.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id k9K08KXT021976
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 09:08:20 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp ([129.60.39.100])
	by mfs3.rdh.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id k9K08JdX012585
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 09:08:19 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id k9K08INY003334
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 09:08:18 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

What's the current policy on the usage of scsi/scsi.h by user-space
programs (userspace should use the glibc kernel headers or trying to
be compatible with userspace)?


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 include/scsi/scsi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 84a6d5f..f53f9b7 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -430,7 +430,7 @@ #define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
 #define SCSI_IOCTL_GET_PCI		0x5387
 
 /* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline u32 scsi_to_u32(u8 *ptr)
+static inline __u32 scsi_to_u32(__u8 *ptr)
 {
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
-- 
1.4.1.1

