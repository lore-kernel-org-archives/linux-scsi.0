Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE43368D76
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757917; cv=none; b=Qus3gA3aWiQDorYTbZE/fDehmPCgMMcpUXPaGurJAnsmqZQ6mAP+20O4GB46432e6cZTWXkFPgO5lREN+44ZIJNcvnU38ugBAaq6v58FewteVdM4SBqTXSfVa2LFg9HG8B4nOu9jO+REILXgq5cnLFmmur66htNS3sgJQPN+ZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757917; c=relaxed/simple;
	bh=1JCs9tKGT0i8mTaNahwUwBKBYtGD3evUbWzw6OQfZh4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZnuL/SdBDGYEk84LDJDCq4m0jtUyK3PwRxi7Te/cPruufYy1G80N/uFMaKf7ncLMWCmIqUrSqGOQY3je904IOd1iinnIzdfJfZlEpQuIBgbUm7iGFyrOtA1QBuHAuhJfJ/VFi3LFHdN5lgENCIjiETAtmY08LgitTLjhNKYxkkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=2Qt/q3Gw; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="2Qt/q3Gw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784757916; x=1816293916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1JCs9tKGT0i8mTaNahwUwBKBYtGD3evUbWzw6OQfZh4=;
  b=2Qt/q3GwLuV3gwDsunT8L0QaYrvsK+pwvd/ZZDNK/KWry8jccF+7xqzl
   zn2pUeEhXVV4+gcU5ZYEW76rM99OElZNHiQbwirljFNsQJQsYe9n6QBtc
   Mjl9gSkEwY962yH+92co5Z1QHdi5o9cw6G6ojNyA/t3eKrLRRnJ82rqM9
   h5x6B60EqdLXPrUi+CqWjdhqus2ZkQENimkpZGH6+7RgupcXI/+oZ/BHs
   1F8fHHQGn+tPRp75otjymUIPUBwiWLlruQ5PIRBF4pleVlDIPHWDOSyUq
   21hpIfYnuOBSOuv5NtZNhvDUw/FXf5ju0EdJKIpVnMOq7LV2x6AnJuLBG
   Q==;
X-CSE-ConnectionGUID: JG26RqvtRoKHQtwzbKUu2Q==
X-CSE-MsgGUID: W2R2xu5FSaC2w0UtmbOKpQ==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="61343501"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 15:05:16 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 15:05:14 -0700
From: David Strahan <david.strahan@microchip.com>
To: <linux-scsi@vger.kernel.org>
CC: David Strahan <David.Strahan@microchip.com>, David Strahan
	<david.strahan@microchip.com>, Don Brace <don.brace@microchip.com>
Subject: [PATCH v1 3/4] smartpqi: add new pci device-ids
Date: Wed, 22 Jul 2026 17:04:00 -0500
Message-ID: <20260722220401.6357-4-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722220401.6357-1-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex03.mchp-main.com (10.10.85.151) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

From: David Strahan <David.Strahan@microchip.com>

smartpqi: Add new controller PCI IDs

All PCI ID entries in Hex.

Add PCI IDs for Hurray Data controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 207d / 4246
                                            9005 / 028f / 207d / 4256
                                            9005 / 028f / 207d / 4356
                                            9005 / 028f / 207d / 4940
                                            9005 / 028f / 207d / 4a46

Add PCI IDs for ZTE controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1cf2 / 5451
                                            9005 / 028f / 1cf2 / 5452
                                            9005 / 028f / 1cf2 / 5453

Add PCI ID for Ramaxel controller:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1f3f / 0670

Signed-off-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 36 +++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 473f1c9..8c2fc0d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10314,10 +10314,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4246)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4256)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4356)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4840)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4940)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4a46)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -10502,6 +10522,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x544f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5451)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5452)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5453)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x54da)
@@ -10542,6 +10574,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f3f, 0x0610)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3f, 0x0670)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0220)
-- 
2.52.0

