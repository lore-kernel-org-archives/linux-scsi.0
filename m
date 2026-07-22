Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBFE36B908
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 20:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784751821; cv=none; b=QGl1Rm52hEZ3d5evKkhyfjPiU7IC4MW981+/5JDz836ng3nafyWC+6i35ym5hjmbuCpNq+EXJb9C8FHiQGG3ZO5kE6F4f9pFkFu45bwbFeqnnu/HqOnPEMkcjkcsT96CkBGRDmcsFtVqHAoo/4ksrlilUIvX9qEBiMgeNttpgMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784751821; c=relaxed/simple;
	bh=aBNw2SCUD1/zzNByb1uYGlROUzOCmej95cn8m15KDdo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kka6soI2UAa0FubRxDPG+w3CdBKLtudj8VBrPdArqXaKrq761R3RMG1VSK0haVTtcxsHnHvwcwMYjE/3JVIB7mhnfeG0Sb0U9k6+36WKQPtOcPP08p7DW5CMg2XO7q6ikS/Gq9Dz6iVypBh2ONz7j5TgAr2ZjruUxVYv4MoJSEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=RKtVEpZu; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="RKtVEpZu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784751822; x=1816287822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aBNw2SCUD1/zzNByb1uYGlROUzOCmej95cn8m15KDdo=;
  b=RKtVEpZuQz0/raLNXNqFtPd6MvdG9G5Tu9zNDf1rakpOYSz5vnhiBTeq
   xAo1QSNVkhhprNoLoi9BQLBicINOntAQE0T/5Kb3yDQiZRreoG89jJuQc
   NTfs9yEA8JHPOuYl+LNkxd4F8HGo4Gtv+QjLzl5/uIJqEiuPEBwXqy+Xr
   dtodQkxjKZ7JO2qCGlo7vMm8F8pO7lchp6GrOz1sk4j+oirlhTjnauIJj
   O0k4aygXLmDmpvOMsueiLlFxm7YdjvZaK0gf9aCBbIrs/S13DuhomTG4P
   XeAD/nOCavNyjenAGAIZTFZLAdn8iNLzRakllfWWH+K9z9FgJgVJOOZQv
   w==;
X-CSE-ConnectionGUID: PQvOc0aNR1OoWl8edHEtoQ==
X-CSE-MsgGUID: EZKf+4EDQfeNF57opnk8gg==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="228170834"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 13:23:42 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 13:23:38 -0700
From: David Strahan <david.strahan@microchip.com>
To: <david.strahan@microchip.com>, <linux-scsi@vger.kernel.org>
CC: <don.brace@microchip.com>
Subject: [PATCH] scsi: smartpqi: update version to 2.1.42-011
Date: Wed, 22 Jul 2026 15:23:27 -0500
Message-ID: <20260722202327.5242-4-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722202327.5242-1-david.strahan@microchip.com>
References: <20260722202327.5242-1-david.strahan@microchip.com>
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
2.47.3

