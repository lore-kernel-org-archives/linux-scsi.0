From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [2.6 patch make struct scsi_dh_devlist's static
Date: Mon, 11 Aug 2008 10:50:13 -0700
Message-ID: <1218477013.16794.7.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35199 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYHKRul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 13:50:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes several needlessly global struct scsi_dh_devlist's 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

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


