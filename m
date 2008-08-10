From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch make struct scsi_dh_devlist's static
Date: Mon, 11 Aug 2008 00:31:31 +0300
Message-ID: <20080810213131.GC5480@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53442 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbYHJVdM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 17:33:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes several needlessly global struct scsi_dh_devlist's 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/device_handler/scsi_dh_alua.c  |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

ae6ee914615e415cc4b22ee1c0545bb088889b6a 
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fcdd73f..994da56 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -680,7 +680,7 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 
 }
 
-const struct scsi_dh_devlist alua_dev_list[] = {
+static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"HP", "MSA VOLUME" },
 	{"HP", "HSV101" },
 	{"HP", "HSV111" },
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index aa46b13..b9d23e9 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -562,7 +562,7 @@ done:
 	return result;
 }
 
-const struct scsi_dh_devlist clariion_dev_list[] = {
+static const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
 	{"DGC", "VRAID"},
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9c7a1f8..a6a4ef3 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -282,7 +282,7 @@ static int hp_sw_activate(struct scsi_device *sdev)
 	return ret;
 }
 
-const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
+static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
 	{"COMPAQ", "MSA1000 VOLUME"},
 	{"COMPAQ", "HSV110"},
 	{"HP", "HSV100"},
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..e7c7b4e 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -574,7 +574,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-const struct scsi_dh_devlist rdac_dev_list[] = {
+static const struct scsi_dh_devlist rdac_dev_list[] = {
 	{"IBM", "1722"},
 	{"IBM", "1724"},
 	{"IBM", "1726"},

