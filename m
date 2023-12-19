Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC739846
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="n/rN7SAJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1703014636; x=1734550636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ssurozzZnrCm1bOvmYuDcINJ4/Rd7ndlH4Tvhn7pDEo=;
  b=n/rN7SAJHAh29rEC7+NC4WMi/nz/3CGFZ1PHB+3msqemi2KUv0+rHy9o
   Savs/LvgBDtQTMpI6YB0XsropOIlkr73Qzc9jWr1Zt6bTDM+27a1beeNi
   TE0gVbERduwkNcdYfFuK4hRnPTkd3hgz/9PiPEvvMrftZ+TljyVdO10o/
   43vby+G8djEeOhAqmAo5cCPiK4x72lo9D0J8YQok2uLMP2gxBKEiQ7743
   ZP3nolt2eoxsDJvdtdH246Ijl+At8mdK8C518MNMtieW6GW7wfNfW49t8
   UFuvmuyyxCbjDsVns3rnK9N4l2lt61FjHLeUYhz29c9PamrR/89BZkW/P
   g==;
X-CSE-ConnectionGUID: b5Ujl0cmS06iDrQGtusm8A==
X-CSE-MsgGUID: 2dCfzCrETf2zrzx1oUMmtw==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,289,1695711600"; 
   d="scan'208";a="13563410"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 12:37:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 12:36:56 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 19 Dec 2023 12:36:55 -0700
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
Subject: [PATCH 3/3] smartpqi: bump driver version to 2.1.26-030
Date: Tue, 19 Dec 2023 13:36:52 -0600
Message-ID: <20231219193653.277553-4-don.brace@microchip.com>
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

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 081bb2c09806..ceff1ec13f9e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.24-046"
+#define DRIVER_VERSION		"2.1.26-030"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		24
-#define DRIVER_REVISION		46
+#define DRIVER_RELEASE		26
+#define DRIVER_REVISION		30
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.43.0.76.g1a87c842ec

