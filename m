From: akpm@linux-foundation.org
Subject: [patch 15/16] scsi: make struct scsi_{host,target}_type static
Date: Thu, 03 Jul 2008 23:47:33 -0700
Message-ID: <200807040647.m646lX05017511@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbYGDGrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 02:47:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org

From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global struct scsi_{host,target}_type static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c     |    2 +-
 drivers/scsi/scsi_scan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hosts.c~scsi-make-struct-scsi_hosttarget_type-static drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-make-struct-scsi_hosttarget_type-static
+++ a/drivers/scsi/hosts.c
@@ -290,7 +290,7 @@ static void scsi_host_dev_release(struct
 	kfree(shost);
 }
 
-struct device_type scsi_host_type = {
+static struct device_type scsi_host_type = {
 	.name =		"scsi_host",
 	.release =	scsi_host_dev_release,
 };
diff -puN drivers/scsi/scsi_scan.c~scsi-make-struct-scsi_hosttarget_type-static drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-make-struct-scsi_hosttarget_type-static
+++ a/drivers/scsi/scsi_scan.c
@@ -346,7 +346,7 @@ static void scsi_target_dev_release(stru
 	put_device(parent);
 }
 
-struct device_type scsi_target_type = {
+static struct device_type scsi_target_type = {
 	.name =		"scsi_target",
 	.release =	scsi_target_dev_release,
 };
_
