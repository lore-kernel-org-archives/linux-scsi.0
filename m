Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6430639AC6
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="bg6TmaqP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1703014640; x=1734550640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cY50o/DzKIuyhnoxw6dKpXb8fMQqcOv9o5wkA+tQkOw=;
  b=bg6TmaqPUfMOw/NrDnZeWwijsY9IYhP9AXGFeW4k5dwYoME06miAOFoU
   W4VNa3Fy/3/bZ0tj3wEgWZPmDLbwrtX57bvGPXLkKiHNxXaafIBRA+IsC
   RCxRy0poYLUB5yeXcKSVnNKe97SARrFngwGvMBjNgx2CDr/pvzTCoN+vU
   ZYIb4tXcDpeidZKRrgQXtfF5EL4U7BHEim0fKh28WRzTChRbzEiaf+rnI
   SGkY88A8N35oHjHyAK6zzKDmD4/EC4S4MyWv5u1KcjzTHehJlm9T8LUXM
   GgiEqMIaHVRnTKWnMiZNu2zOAWUjPi3JrbVzes/LCuo00hJH5IQvdNv4D
   A==;
X-CSE-ConnectionGUID: 3TEoP0jQSK+qJI3H8IMdLg==
X-CSE-MsgGUID: aWVuBPqmSnCaI87pZbK49Q==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,289,1695711600"; 
   d="scan'208";a="244283762"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 12:37:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 12:36:54 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 19 Dec 2023 12:36:54 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/3] smartpqi: Add new controller PCI IDs
Date: Tue, 19 Dec 2023 13:36:50 -0600
Message-ID: <20231219193653.277553-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.43.0.76.g1a87c842ec
In-Reply-To: <20231219193653.277553-1-don.brace@microchip.com>
References: <20231219193653.277553-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: David Strahan <david.strahan@microchip.com>

All PCI ID entries in Hex.

    Add PCI IDs for Cisco controllers:
                                                VID  / DID  / SVID / SDID
                                                ----   ----   ----   ----
        Cisco 24G TriMode M1 RAID 4GB FBWC 32D  9005 / 028f / 1137 / 02f8
        Cisco 24G TriMode M1 RAID 4GB FBWC 16D  9005 / 028f / 1137 / 02f9
        Cisco 24G TriMode M1 HBA 16D            9005 / 028f / 1137 / 02fa

    Add PCI IDs for CloudNine controllers:
                                                VID  / DID  / SVID / SDID
                                                ----   ----   ----   ----
        SmartRAID P7604N-16i                    9005 / 028f / 1f51 / 100e
        SmartRAID P7604N-8i                     9005 / 028f / 1f51 / 100f
        SmartRAID P7504N-16i                    9005 / 028f / 1f51 / 1010
        SmartRAID P7504N-8i                     9005 / 028f / 1f51 / 1011
        SmartRAID P7504N-8i                     9005 / 028f / 1f51 / 1043
        SmartHBA  P6500-8i                      9005 / 028f / 1f51 / 1044
        SmartRAID P7504-8i                      9005 / 028f / 1f51 / 1045

Reviewed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 40 +++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9a58df9312fa..d56201120087 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10142,6 +10142,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1014, 0x0718)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02f8)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02f9)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02fa)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1000)
@@ -10198,6 +10210,34 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1f51, 0x100a)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x100e)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x100f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1010)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1011)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1043)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1044)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1045)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.43.0.76.g1a87c842ec

