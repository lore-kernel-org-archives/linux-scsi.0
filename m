Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2136C4279EE
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 20:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784751820; cv=none; b=NAJUMNl7yCaiWuEM1WyN58S4DP9pYjkQLjB/4dbXgiFS7h79lhdWdIAClnidcfK4Jg1LyIQrB4MFiU+ODtVOFm4VDhgVQGmTITuOlb/G+S7Kj/6HwFlkpoPANGsYlq+0ndh3hshCzwPkWHZdoEnrJC9fMmxoFZW+TZyhLMU2OI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784751820; c=relaxed/simple;
	bh=2ziTiNG2ZePwl+pEMaVE5nUCOKTYlbkur8PRUn+XIUk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qronSKVK/FFuUO7elJsWbS7yKVKGXLeInGFcHQhN9VFBtBtuJsWwrD7V9Uz3aQbLiTTYg/HBzAlgZm5LDoRlqEueeew3PaVbvvTpKy7Lt8znmjFXOB2nFuLom2MBbd/86MQKg6zjZ3FJAPjFF34h0zVCOftEtLAazLYfaECR1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=LzAg1F9m; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="LzAg1F9m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784751819; x=1816287819;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2ziTiNG2ZePwl+pEMaVE5nUCOKTYlbkur8PRUn+XIUk=;
  b=LzAg1F9mVQ78t37i6tPHyoojrPY0ck8bVTq9Ty6QAp9fYZhsCcEFPwwv
   fweNAKyeXakJlaLXt8+R9KD25mQHEKV4cQMb+MnqB6oqVxW+keLUqYq4j
   ucIN4sUyR1mBTxHvfYPLgIzhdiWPwCVCKf/C9wf9sksTc5aRwH0PPuDDV
   4Mcc7oLY7oJ80kZBPXMfw8OXTcRUQ8IuOhSPUH5cOI7xTLddjd2qocCsm
   /GT4HL9cSO8cgCeV5WhUoRQSJtyLzDIKywVfqizn5BFEwKjYWU3Cd29/e
   PdGNN0/U2rwmbKxo+S38FsumQJTHrQf/8I67UO4eP/5Gfd2XLUey8NKTd
   Q==;
X-CSE-ConnectionGUID: J4FCE4OXRyOUkXaYnGua/A==
X-CSE-MsgGUID: nkBiVtGtReW94l6csvsnBQ==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="60160550"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 13:23:38 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 13:23:37 -0700
From: David Strahan <david.strahan@microchip.com>
To: <david.strahan@microchip.com>, <linux-scsi@vger.kernel.org>
CC: <don.brace@microchip.com>
Subject: [PATCH] scsi: smartpqi: add new pci device-ids
Date: Wed, 22 Jul 2026 15:23:24 -0500
Message-ID: <20260722202327.5242-1-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex01.mchp-main.com (10.10.85.143) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

From: David Strahan <David.Strahan@microchip.com>

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
2.47.3

