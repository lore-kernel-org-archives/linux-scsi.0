From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] feature-removal-schedule.txt: remove the NCR53C9x entry
Date: Tue, 5 Aug 2008 23:03:30 +0300
Message-ID: <20080805200330.GJ22895@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43328 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761585AbYHEUEx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2008 16:04:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Now that the driver is removed we should also remove the entry in 
Documentation/feature-removal-schedule.txt

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>

---

This patch has been sent on:
- 1 Mar 2008

6d7882f6e844eaf6551b3a3708e01d1784916435 foobar
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c1d1fd0..a4530f0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -19,15 +19,6 @@ Who:	Pavel Machek <pavel@suse.cz>
 
 ---------------------------
 
-What:	old NCR53C9x driver
-When:	October 2007
-Why:	Replaced by the much better esp_scsi driver.  Actual low-level
-	driver can be ported over almost trivially.
-Who:	David Miller <davem@davemloft.net>
-	Christoph Hellwig <hch@lst.de>
-
----------------------------
-
 What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
 When:	December 2008
 Files:	include/linux/video_decoder.h include/linux/videodev.h

