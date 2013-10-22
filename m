From: Joe Perches <joe@perches.com>
Subject: [PATCH 10/24] scsi: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:53 -0700
Message-ID: <aad2d1ffb85a1c88d84bc0ac70dae48e4d720f5b.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/scsi_sysctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 2b6b93f..546f162 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -12,7 +12,7 @@
 #include "scsi_priv.h"
 
 
-static ctl_table scsi_table[] = {
+static struct ctl_table scsi_table[] = {
 	{ .procname	= "logging_level",
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
@@ -21,14 +21,14 @@ static ctl_table scsi_table[] = {
 	{ }
 };
 
-static ctl_table scsi_dir_table[] = {
+static struct ctl_table scsi_dir_table[] = {
 	{ .procname	= "scsi",
 	  .mode		= 0555,
 	  .child	= scsi_table },
 	{ }
 };
 
-static ctl_table scsi_root_table[] = {
+static struct ctl_table scsi_root_table[] = {
 	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= scsi_dir_table },
-- 
1.8.1.2.459.gbcd45b4.dirty
