From: joe@perches.com
Subject: [PATCH] [115/2many] MAINTAINERS - BSG (block layer generic sg v4
 driver)
Date: Sun, 12 Aug 2007 23:25:00 -0700
Message-ID: <46bff93c.xBAv4jj6C/2mJu6C%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3978 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938552AbXHMGZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ee8069..4ad8cd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1118,6 +1118,8 @@ P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	block/bsg.c
+F:	include/linux/bsg.h
 
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
