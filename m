From: Bill Nottingham <notting@redhat.com>
Subject: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
Date: Wed, 25 Mar 2009 15:00:47 -0400
Message-ID: <1238007647-25752-2-git-send-email-notting@redhat.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44995 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZCYTAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 15:00:52 -0400
In-Reply-To: <1238007647-25752-1-git-send-email-notting@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bill Nottingham <notting@redhat.com>

Otherwise, these don't work when called from 32-bit userspace on 64-bit kernels.
---
 fs/compat_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..9ee71a0 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1937,6 +1937,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)
+COMPATIBLE_IOCTL(PIO_CMAP)
+COMPATIBLE_IOCTL(GIO_CMAP)
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
-- 
1.6.1.2

