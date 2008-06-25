From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make struct scsi_{host,target}_type static
Date: Wed, 25 Jun 2008 19:25:44 +0300
Message-ID: <20080625162544.GJ10285@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42954 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760275AbYFYQ1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This patch makes the needlessly global struct scsi_{host,target}_type 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 5 May 2008

 drivers/scsi/hosts.c     |    2 +-
 drivers/scsi/scsi_scan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

8d16370bca9037f8ab45eecb676adf8794438b21 diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3690360..497ca68 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -290,7 +290,7 @@ static void scsi_host_dev_release(struct device *dev)
 	kfree(shost);
 }
 
-struct device_type scsi_host_type = {
+static struct device_type scsi_host_type = {
 	.name =		"scsi_host",
 	.release =	scsi_host_dev_release,
 };
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a00eee6..196fe3a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -346,7 +346,7 @@ static void scsi_target_dev_release(struct device *dev)
 	put_device(parent);
 }
 
-struct device_type scsi_target_type = {
+static struct device_type scsi_target_type = {
 	.name =		"scsi_target",
 	.release =	scsi_target_dev_release,
 };

