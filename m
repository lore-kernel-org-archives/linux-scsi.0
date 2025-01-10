Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0082D209F48;
	Fri, 10 Jan 2025 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500782; cv=none; b=IuehUXy+TPe4ikDZ5qbrttANxNw7UundsNCqhiSzWDNb0t88/pEuaW1R8UpAPpkv+/YS5Y1YoXN0QJaKNif7hSVYgMRtfjNTXzOtUtvz24AJIQf8LssyLpij5901yHjgukIWv1KXdlIE3G0Az9334dYCO8LlW4/8fii6XCpauk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500782; c=relaxed/simple;
	bh=zK1wbPthrxRBtge/imUB/uIGBwno/LjzANJsIOrDhho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X4Vsj9Pba3L5BU1QGjv8j1MzenTMWtmitQKKxR+1gfV8vwnZl8Do6SRCkVu/ZpoSd8b8pkvZrXupOTKSJSyYtFl6nW6lJNK8U/zd4DMJytFNYpbTzd/yf61A8cLVqA7PAUmWQt9ZsPyzTH7MCSUewDpEO90XVqfMvi0piCsaMng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=cvCRa9kc; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="cvCRa9kc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2060; q=dns/txt; s=iport;
  t=1736500781; x=1737710381;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MTt/NZAv4QralzNLguErQr/djUGRSZ4yzeri6m1mzbQ=;
  b=cvCRa9kcX701M9tLNXq1DFu9w/hwoHxK9YLnXvu1n70SFjeNQwkAGYG9
   3uE5Xmb2tI9tR8p350ETZBmzlWsLEKtXgd4kLmCdieaqIUZknOG2PxDQ5
   YxFtgbfPGCy/3AhcoxPuXnCixji0YVCXv20Te9he7BvYozNBxjhHmiqPS
   A=;
X-CSE-ConnectionGUID: 3fLd2IoEQRCLcDTaqXkilw==
X-CSE-MsgGUID: eeyoKav7ToWPwto6+fVhUg==
X-IPAS-Result: =?us-ascii?q?A0AUAAA35YBnj5X/Ja1aHAECAgEHARQBBAQBggAHAQwBg?=
 =?us-ascii?q?0BZQxkvBIxuhzCCIZ4bgSUDVg8BAQEPOQsEAQGFB4p2AiY0CQ4BAgQBAQEBA?=
 =?us-ascii?q?wIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBRQBAQEBAQE5BUmFew2GXSsLAUaBU?=
 =?us-ascii?q?IMBAYJkAxGzJYF5M4EB3jOBZwaBSAGNSYVnJxUGgUlEglCBPm+BD0ODPoV3B?=
 =?us-ascii?q?IdonkpIgSEDWSwBVRMNCgsHBYFzAzgMCzAVNYEae4JGaUk3Ag0CNYIefIIrh?=
 =?us-ascii?q?FyER4RWhWWCF4V4QAMLGA1IESw3FBsGPm4HmxoBPINwMUoJChQYghSlcKEDh?=
 =?us-ascii?q?CWMGJUuGjOqUgGYfI4ElgyFHYFnOoFbMxoIGxWDIhM/GQ+OLQ0JiGyzKiUyA?=
 =?us-ascii?q?gE5AgcLAQEDCZEeAQE?=
IronPort-Data: A9a23:wervhanT2HOQBNV1I0aePLPo5gxwJkRdPkR7XQ2eYbSJt1+Wr1Gzt
 xJMWmzXaP+NZDejeYskPN+3808GvsKBydM1Sws6/C9kH1tH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/rav658CEUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+pe31GONgWYubzpNsvrb8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FdYW3uotIGZjz
 MYzDDshUhmat+G3xK3uH4GAhux7RCXqFJkUtnclyXTSCuwrBMmZBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQTaz/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKJI4TUFJUMxx/wS
 mTu8mnoBTITKoOjzgW97W6r2KzBoyPGV9dHfFG/3qU32ALInDN75ActfVmmpfiwzEq3RNtbL
 2QV/DAvpO487iSDStrldxy+vHOA+BUbXrJ4EeA44imJy6zJ80CYDG1CRTlEAPQjvdUqRDpsz
 lKVksnyCDpHt6ecQnaQsLyTqFuaPSkTMH9HZiIeSwYBy8fsrZt1jR/VSNtnVqmvgbXdHTD23
 iDPtyMlhp0NgsMRkaa251bKh3SrvJehc+Iuzh/cUmTg6kZyY5SoItXyr1Pa9v1Hao2eSzFto
 UToheDF4sQCV7CKuRW3a8EGMI2g/saGMTnD1AsH84Yayxyh/HuqfIZ16T54JVt0PstsRdMPS
 BGI0e+2zMEIVEZGfZNKj5SN59PGJJUM9OgJtNiJNbKigbAoKGdrGR2Cg2bLgggBd2B3zskC1
 W+zK5rEMJrjIf0PIMCKb+kcy6Q34Ss12HneQ5v2pzz+juHAOCLKFOtZbAXeBgzc0E9iiFiKm
 zq4H5bboyizrMWkOEE7DKZKdwlTcyRrbXwIg5MHLrTYSuaZJI3RI6SMmex6IdMNc1V9nebT9
 Xb1QV5D1Ff6njXGLw7MAk2Pm5uxNauTWUkTZHR2VX7xgiBLSd/2vM83KcBtFZF5r7ML8BKBZ
 6VeEyl2KqgUEmyfk9ncBLGhxLFfmOOD3lvRZnL9PGdhJPaNhWXho7fZQ+cmzwFWZgLfiCf0i
 +TIOt/zKXbbezlfMQ==
IronPort-HdrOrdr: A9a23:ITV986hjxlvVuBKus0iT+L7p8HBQXukji2hC6mlwRA09TyVXra
 yTdZMgpH3JYVkqNk3I9errBEDiewK+yXcW2+gs1N6ZNWGMhILCFu5fBOXZrgHIKmnX6vNd2a
 B8c6J3FdH8SWRhgd2S2njcLz9Z+rm6GGTCv5a485+rJjsaD51d0w==
X-Talos-CUID: =?us-ascii?q?9a23=3AzNZnlWgLbveq8h6rcA977bJhtTJuKXP5wC3xJGK?=
 =?us-ascii?q?BM01NQ5GpQEag+6JgjJ87?=
X-Talos-MUID: 9a23:UhU6pgtv6xw1pVtZ0M2niTxzM+Rh/fuSD381jokB5YqKCyxNNGLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,303,1728950400"; 
   d="scan'208";a="410698111"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:19:34 +0000
Received: from fedora.cisco.com (unknown [10.188.32.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id C42E6180001D5;
	Fri, 10 Jan 2025 09:19:32 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] scsi: fnic: Test for memory allocation failure and return error code
Date: Fri, 10 Jan 2025 01:19:24 -0800
Message-ID: <20250110091924.17729-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.32.212, [10.188.32.212]
X-Outbound-Node: rcdn-l-core-12.cisco.com

Fix kernel test robot warning.
Test for memory allocation failure, and free memory for
queues allocated in a multiqueue and non-multiqueue scenario.
Return appropriate error code.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202412312347.FE4ZgEoM-lkp@intel.com/
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202412312347.FE4ZgEoM-lkp@intel.com/
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 6eb551112170..6880b40507aa 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -582,6 +582,14 @@ static void fnic_scsi_init(struct fnic *fnic)
 	host->transportt = fnic_fc_transport;
 }
 
+static void fnic_free_ioreq_tables_mq(struct fnic *fnic)
+{
+	int hwq;
+
+	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++)
+		kfree(fnic->sw_copy_wq[hwq].io_req_table);
+}
+
 static int fnic_scsi_drv_init(struct fnic *fnic)
 {
 	struct Scsi_Host *host = fnic->host;
@@ -614,6 +622,11 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
 		fnic->sw_copy_wq[hwq].io_req_table =
 			kzalloc((fnic->sw_copy_wq[hwq].ioreq_table_size + 1) *
 					sizeof(struct fnic_io_req *), GFP_KERNEL);
+
+		if (!fnic->sw_copy_wq[hwq].io_req_table) {
+			fnic_free_ioreq_tables_mq(fnic);
+			return -ENOMEM;
+		}
 	}
 
 	dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size: %d\n",
@@ -1060,6 +1073,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_free_stats_debugfs:
 	fnic_stats_debugfs_remove(fnic);
+	fnic_free_ioreq_tables_mq(fnic);
 	scsi_remove_host(fnic->host);
 err_out_scsi_drv_init:
 	fnic_free_intr(fnic);
-- 
2.47.1

