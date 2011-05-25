From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] MAINTAINERS: Remove Joe Eykholt from Cisco fnic maintainers
Date: Wed, 25 May 2011 12:41:19 -0700
Message-ID: <1306352479-15409-1-git-send-email-roland@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Abhijeet Joglekar <abjoglek@cisco.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Joe is no longer working at Cisco and his @cisco.com email bounces.
Presumably he is no longer maintaining fnic either.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8df8d2d..4eb44b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1763,7 +1763,6 @@ F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER
 M:	Abhijeet Joglekar <abjoglek@cisco.com>
-M:	Joe Eykholt <jeykholt@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
