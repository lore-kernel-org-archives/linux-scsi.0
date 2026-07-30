Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A5A385D75;
	Thu, 30 Jul 2026 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437442; cv=pass; b=o3KID5+oFT/ADWQO1/HC/a9AaPMPsxujd5+uVMPPHLo0ZlKl0ZStrKo79q4dLXoL2o7LFfInsdoulsQ6cFnLr2nTIBXVlFhYqxklOZPWaCj+yLstYkR62VQrepl8yR0DctB2Iv4C7xEffNPcMLrMnkFk7xWZjyWltWOvnnHVCvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437442; c=relaxed/simple;
	bh=fwta8MAyz+zfnpYSC8//tYCCEMtQqSpjF6qbxoRLRiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=djV1ALJcvKvn2KEZPIlq2aYJ3uNw6x0WFcy3su7wz90GhW/YRrDOVB65jkACuRi9TPcOsc5gGXQ+MP0Jdw0I0rqF+Ay27gYZX1DaLPBA/nUNT6ZUlB51ElgxRTH7mZs7OifsF0o1y7IircSGenrfa8HBLDz0iA0iBKxWHBjMd4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b=Rz9ppKdG; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b="Rz9ppKdG"
ARC-Seal: i=1; a=rsa-sha256; t=1785437357; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iwKZIrmwPp6m9NBdk8JPWK5657xFBs5BuHm94OVhaNfKOUHzKEOUznIWax8F7FJF8xd55cXX6lHXBt459oBVCyfefk1JlPDsbU+zhgZt8yYI2NeCNiTgWdlwvh9mJqQIXwmJsOQalJ+yl7hujGUeQdiS615iInJsoSasrlUZ2Ek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1785437357; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id; 
	bh=v9Wusaeluvyyae9mee9lOOTkP/1x06+GCyc2XpXRkYY=; 
	b=e5OInndoXtUDBu9eEPVPtAV+c7OfpmmVFLMJGhVL0rgPi3ip66jBHI+7Ju9yVQDiSHq+FzlCBMG6/MpJ01j6djYHgUs2Bc1YRt/wZ5W5jFsjNSFP/9fmZHuS+Vwxtl9AVVCHAOlrh3JbtDuO/zhqdfw8RiCwSyqZ1zoe0hmnxYY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=mhklkml@zohomail.com;
	dmarc=pass header.from=<mhklkml@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1785437357;
	s=zm2022; d=zohomail.com; i=mhklkml@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:Reply-To:Reply-To:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=v9Wusaeluvyyae9mee9lOOTkP/1x06+GCyc2XpXRkYY=;
	b=Rz9ppKdGjqTx1rZU0LKloKk9jVfFXCJkXrjxIInk4lthyQnyeqpxOEXE8Ie7x9Qg
	Dg0UnnMZ9D7VNcjcABS3IKq73/tfQz9L1jNOXSyklNHwZ85EUozNv9U64y8G68PiZ6C
	LZOynqS2vsIwY50itt21rHe5MEsXZ+4C/gpvPbDk=
Received: by mx.zohomail.com with SMTPS id 1785437355043421.4640026118569;
	Thu, 30 Jul 2026 11:49:15 -0700 (PDT)
From: Michael Kelley <mhklkml@zohomail.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 1/6] Drivers: hv: Remove support for WS2012/2012R2 & Win8/8.1 version of Hyper-V
Date: Thu, 30 Jul 2026 11:48:41 -0700
Message-Id: <20260730184846.3165-2-mhklkml@zohomail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730184846.3165-1-mhklkml@zohomail.com>
References: <20260730184846.3165-1-mhklkml@zohomail.com>
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: zu080112272968551c28bde5f0a0065ae9000066bf37ea4c51ef19124c9ecfa3c80a6b450a45956012bb9e5e:ZohoMail
X-Zoho-CM-AccountID: 0c88436b239415d28725328898ceccb9ce2ba3b61598c1c37bcb2109e0248174
X-ZohoMailClient: External

From: Michael Kelley <mhklinux@outlook.com>

Linux code for running as a Hyper-V guest includes special cases for
running on Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions
were initially released 14 years ago, and official support ended in 2023
(unless a customer has contracted for extended security updates). Given
the release of subsequent versions with improved functionality, there's
no need to continue to support the latest Linux kernels on these versions
of Hyper-V. If someone is running Linux on one of these older Hyper-V
versions and doesn't want to upgrade, they can continue to do so as
presumably they don't want upgrade the Linux version either.

Simplify Linux code by removing special cases for running on these
old versions of Hyper-V. Remove the negotiation of the VMBus protocol
versions for WS2012/Win8, and remove special case code based on those
VMBus protocol versions. Also update the balloon and snapshot drivers
to no longer negotiate driver-specific protocol versions for these
older Hyper-V versions, and remove any related special cases.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 drivers/hv/channel_mgmt.c |  4 ----
 drivers/hv/connection.c   |  8 ++++----
 drivers/hv/hv_balloon.c   | 36 +++++++++++++++---------------------
 drivers/hv/hv_snapshot.c  |  5 -----
 include/linux/hyperv.h    |  5 ++---
 5 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 89d214dda360..84dc56a06c78 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -933,10 +933,6 @@ void vmbus_initiate_unload(bool crash)
 	if (xchg(&vmbus_connection.conn_state, DISCONNECTED) == DISCONNECTED)
 		return;
 
-	/* Pre-Win2012R2 hosts don't support reconnect */
-	if (vmbus_proto_version < VERSION_WIN8_1)
-		return;
-
 	reinit_completion(&vmbus_connection.unload_event);
 	memset(&hdr, 0, sizeof(struct vmbus_channel_message_header));
 	hdr.msgtype = CHANNELMSG_UNLOAD;
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 0fd50d4cb573..a9e87cf3f51c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -47,7 +47,9 @@ EXPORT_SYMBOL_GPL(vmbus_proto_version);
 
 /*
  * Table of VMBus versions listed from newest to oldest.
- * VERSION_WIN7 and VERSION_WS2008 are no longer supported in
+ * VERSION_WIN7,VERSION_WS2008, VERSION_WIN8 (which is
+ * Windows Server 2012) and VERSION_WIN8_1 (which is
+ * Windows Server 2012 R2) are no longer supported in
  * Linux guests and are not listed.
  */
 static __u32 vmbus_versions[] = {
@@ -57,9 +59,7 @@ static __u32 vmbus_versions[] = {
 	VERSION_WIN10_V5_1,
 	VERSION_WIN10_V5,
 	VERSION_WIN10_V4_1,
-	VERSION_WIN10,
-	VERSION_WIN8_1,
-	VERSION_WIN8
+	VERSION_WIN10
 };
 
 /*
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 42ce27be344d..9cba97e81111 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -58,6 +58,10 @@
 #define DYNMEM_MAJOR_VERSION(Version) ((__u32)(Version) >> 16)
 #define DYNMEM_MINOR_VERSION(Version) ((__u32)(Version) & 0xff)
 
+/*
+ * VERSION_1 and VERSION_2 are retained for the historical record,
+ * but are no longer supported in Linux guests.
+ */
 enum {
 	DYNMEM_PROTOCOL_VERSION_1 = DYNMEM_MAKE_VERSION(0, 3),
 	DYNMEM_PROTOCOL_VERSION_2 = DYNMEM_MAKE_VERSION(1, 0),
@@ -65,9 +69,7 @@ enum {
 
 	DYNMEM_PROTOCOL_VERSION_WIN7 = DYNMEM_PROTOCOL_VERSION_1,
 	DYNMEM_PROTOCOL_VERSION_WIN8 = DYNMEM_PROTOCOL_VERSION_2,
-	DYNMEM_PROTOCOL_VERSION_WIN10 = DYNMEM_PROTOCOL_VERSION_3,
-
-	DYNMEM_PROTOCOL_VERSION_CURRENT = DYNMEM_PROTOCOL_VERSION_WIN10
+	DYNMEM_PROTOCOL_VERSION_WIN10 = DYNMEM_PROTOCOL_VERSION_3
 };
 
 /*
@@ -1434,19 +1436,9 @@ static void version_resp(struct hv_dynmem_device *dm,
 	version_req.version.version = dm->next_version;
 	dm->version = version_req.version.version;
 
-	/*
-	 * Set the next version to try in case current version fails.
-	 * Win7 protocol ought to be the last one to try.
-	 */
-	switch (version_req.version.version) {
-	case DYNMEM_PROTOCOL_VERSION_WIN8:
-		dm->next_version = DYNMEM_PROTOCOL_VERSION_WIN7;
-		version_req.is_last_attempt = 0;
-		break;
-	default:
-		dm->next_version = 0;
-		version_req.is_last_attempt = 1;
-	}
+	/* Set the next version to try in case current version fails. */
+	dm->next_version = 0;
+	version_req.is_last_attempt = 1;
 
 	ret = vmbus_sendpacket(dm->dev->channel, &version_req,
 				sizeof(struct dm_version_request),
@@ -1735,16 +1727,18 @@ static int balloon_connect_vsp(struct hv_device *dev)
 
 	/*
 	 * Initiate the hand shake with the host and negotiate
-	 * a version that the host can support. We start with the
-	 * highest version number and go down if the host cannot
-	 * support it.
+	 * a version that the host can support. The mechanism is in place
+	 * to start with the highest version number and go down if the host
+	 * cannot support it. But currently we only try the WIN10 version
+	 * since support for older Hyper-V versions has been removed from
+	 * Linux.
 	 */
 	memset(&version_req, 0, sizeof(struct dm_version_request));
 	version_req.hdr.type = DM_VERSION_REQUEST;
 	version_req.hdr.size = sizeof(struct dm_version_request);
 	version_req.hdr.trans_id = atomic_inc_return(&trans_id);
 	version_req.version.version = DYNMEM_PROTOCOL_VERSION_WIN10;
-	version_req.is_last_attempt = 0;
+	version_req.is_last_attempt = 1;
 	dm_device.version = version_req.version.version;
 
 	ret = vmbus_sendpacket(dev->channel, &version_req,
@@ -1964,7 +1958,7 @@ static int balloon_probe(struct hv_device *dev,
 #endif
 	dm_device.dev = dev;
 	dm_device.state = DM_INITIALIZING;
-	dm_device.next_version = DYNMEM_PROTOCOL_VERSION_WIN8;
+	dm_device.next_version = 0;
 	init_completion(&dm_device.host_event);
 	init_completion(&dm_device.config_event);
 	INIT_LIST_HEAD(&dm_device.ha_region_list);
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 506871aeacf0..847dc69e8250 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -372,11 +372,6 @@ static void vss_on_reset(void)
 int
 hv_vss_init(struct hv_util_service *srv)
 {
-	if (vmbus_proto_version < VERSION_WIN8_1) {
-		pr_warn("Integration service 'Backup (volume snapshot)'"
-			" not supported on this host version.\n");
-		return -ENOTSUPP;
-	}
 	recv_buffer = srv->recv_buffer;
 	vss_transaction.recv_channel = srv->channel;
 	vss_transaction.recv_channel->max_pkt_size = VSS_MAX_PKT_SIZE;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index a2b484679eb4..9652083b6798 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -260,9 +260,8 @@ static inline u32 hv_get_avail_to_write_percent(
  * 5 . 2  (Windows Server 2019, RS5)
  * 5 . 3  (Windows Server 2022)
  *
- * The WS2008 and WIN7 versions are listed here for
- * completeness but are no longer supported in the
- * Linux kernel.
+ * The WS2008, WIN7, WIN8, and WIN8_1 versions are listed here for
+ * completeness but are no longer supported in the Linux kernel.
  */
 
 #define VMBUS_MAKE_VERSION(MAJ, MIN)	((((u32)MAJ) << 16) | (MIN))
-- 
2.25.1

