From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [man-pages PATCH] cciss.4, hpsa.4: mention cciss removal in Linux
 4.13
Date: Mon, 11 Sep 2017 04:57:46 +0200
Message-ID: <20170911025746.GA23341@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Don Brace <don.brace-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

During the Linux 4.13 development cycle, cciss driver has been removed
in flavor to hpsa driver that has been amended with some legacy board
support.

* man4/cciss.4 (.SH DESCRIPTION): Mention driver removal.
* man4/hpsa.4 (.SH DESCRIPTION): Mention list of boards that recognised
since Linux 4.13.

Signed-off-by: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 man4/cciss.4 |  7 +++++++
 man4/hpsa.4  | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/man4/cciss.4 b/man4/cciss.4
index e6ba93d..ff4c248 100644
--- a/man4/cciss.4
+++ b/man4/cciss.4
@@ -15,6 +15,13 @@ cciss \- HP Smart Array block driver
 modprobe cciss [ cciss_allow_hpsa=1 ]
 .fi
 .SH DESCRIPTION
+.\" commit 253d2464df446456c0bba5ed4137a7be0b278aa8
+.BR Note :
+This obsolete driver was removed from the kernel in version 4.13,
+as it is superseded by
+.BR hpsa (4)
+driver in newer kernels.
+.PP
 .B cciss
 is a block driver for older HP Smart Array RAID controllers.
 .SS Options
diff --git a/man4/hpsa.4 b/man4/hpsa.4
index 63000bf..9b7fd82 100644
--- a/man4/hpsa.4
+++ b/man4/hpsa.4
@@ -52,6 +52,32 @@ driver supports the following Smart Array boards:
     Smart Array P711m
     StorageWorks P1210m
 .fi
+.PP
+.\" commit 135ae6edeb51979d0998daf1357f149a7d6ebb08
+Since Linux 4.13, the following Smart Array boards are also supported:
+.PP
+.nf
+    Smart Array 5300
+    Smart Array 5312
+    Smart Array 532
+    Smart Array 5i
+    Smart Array 6400
+    Smart Array 6400 EM
+    Smart Array 641
+    Smart Array 642
+    Smart Array 6i
+    Smart Array E200
+    Smart Array E200i
+    Smart Array E200i
+    Smart Array E200i
+    Smart Array E200i
+    Smart Array E500
+    Smart Array P400
+    Smart Array P400i
+    Smart Array P600
+    Smart Array P700m
+    Smart Array P800
+.fi
 .SS Configuration details
 To configure HP Smart Array controllers,
 use the HP Array Configuration Utility (either
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
