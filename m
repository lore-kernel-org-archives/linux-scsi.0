From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] MAINTAINERS: update OSD entries
Date: Tue,  2 May 2017 09:57:20 +0200
Message-ID: <20170502075720.23570-1-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: ooo@electrozaur.com, bhalevy@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The open-osd domain doesn't exist anymore, and mails to the list lead
to really annoying bounced that repeat every day.

Also the primarydata address for Benny bounces, and while I have a new
one for him he doesn't seem to be maintaining the OSD code any more.

Which beggs the question:  should we really leave the Supported status
in MAINTAINERS given that the code is barely maintained?

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 MAINTAINERS | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1bb06c5f7716..28dd83a1d9e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9418,10 +9418,6 @@ F:	drivers/net/wireless/intersil/orinoco/
 
 OSD LIBRARY and FILESYSTEM
 M:	Boaz Harrosh <ooo@electrozaur.com>
-M:	Benny Halevy <bhalevy@primarydata.com>
-L:	osd-dev@open-osd.org
-W:	http://open-osd.org
-T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
 F:	drivers/scsi/osd/
 F:	include/scsi/osd_*
-- 
2.11.0
