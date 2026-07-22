Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF8343E9FD
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757921; cv=none; b=PwUn5o4v8iOmvrNkrS3SqemXNWCByobgBCgmlja+ipgNUPh8Z5QhI/UpaTqVZ5M7oDSZQ8Q7PZIjyf5LP/t5/xB1KwxTp8L4rIki369YPn7u02JibPSxKrTr8LFjPmzbtNh7bWfKTquOnPDOLO72cUVtARhik7a5rS0sSS0jGNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757921; c=relaxed/simple;
	bh=voZBNVOSe+CVfpKQhcQPSXyjcSryU6pu4K6Pn5tSw1w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6wJGPU37zQNn97Nc0kJb5EgGJYKLIPKCaWyOni/mrrmW5StbRTk4YGfnIvfmCyjy0NVqUV3A2lR4l+Oaz20HoUheBJEuRRkgYGmzcZmUiaM1IOGJGxd1sLgW6S0rjIqsNH6uUeQgKlHVCKA0vrEhGFOsMElnqUswZpOwig8vl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=luG/UtM7; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="luG/UtM7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784757920; x=1816293920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=voZBNVOSe+CVfpKQhcQPSXyjcSryU6pu4K6Pn5tSw1w=;
  b=luG/UtM7t8cPi/+wjV1LtdTkAx5E0jkSrY//3YmZfltMYdy6X9IjYwQu
   eXh2SCYNGydumYr/C7DvVPRhnbohkXwGJ71CtiuIBWj/d5lBMnQqKFfR9
   Ts8Fj9Mcbmo9+VEoPj0cLFaSl0p9p20Ut+71r1Xj1jsQxwh7wb3YrPBWH
   d/RRw1h1rAfksiRPHDbUBNDG2H97oqn6ShhHmg4XfOY+/rDSbaXO9J0+j
   AIZVrvW7y63AB9mFJ8kRgCQ+B8sFjzPQ0v39Ht/2598IsVa0IHgjlbUGJ
   qkRVQZrNrT2tsRY8ltrItslnxAKUWkBr1CeiNcBlPUIN88XIxwobjSG89
   g==;
X-CSE-ConnectionGUID: ZE7LZYR/QkWnXBKCHL444Q==
X-CSE-MsgGUID: 1WYTxQGXRCCmkChN/b+Fyw==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="61343502"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 15:05:20 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 15:05:19 -0700
From: David Strahan <david.strahan@microchip.com>
To: <linux-scsi@vger.kernel.org>
CC: David Strahan <David.Strahan@microchip.com>, David Strahan
	<david.strahan@microchip.com>, Don Brace <don.brace@microchip.com>
Subject: [PATCH v1 4/4] smartpqi: update version to 2.1.42-011
Date: Wed, 22 Jul 2026 17:04:01 -0500
Message-ID: <20260722220401.6357-5-david.strahan@microchip.com>
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

Update driver version to 2.1.42-011

Signed-off-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8c2fc0d..140e8a6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -34,11 +34,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.36-026"
+#define DRIVER_VERSION		"2.1.42-011"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		36
-#define DRIVER_REVISION		26
+#define DRIVER_RELEASE		42
+#define DRIVER_REVISION		11
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.52.0

