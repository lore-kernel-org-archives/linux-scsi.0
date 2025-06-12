Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C2018E1A;
	Thu, 12 Jun 2025 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687921; cv=none; b=hXXgPPMb1exetkU1BuxbOr2/v/YPo7bEnkRZ3MHguxOTA2x9TqbYdR12o6ILEXXJ90+XpzUQLOdts1v9+X4GHDYGeVEJrzStCM1DCU53JSGFkqt8Q9KXbK1CEL0M0pXfv4y6o0KInYvOaPPJuQoe4FKArsq4WdMlBxtkuf6SLbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687921; c=relaxed/simple;
	bh=W9TMtmNAQox4GJzmyGBKfQRvar8R3C9E12Rn9hMqO80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIgy+cSokyaRd0g7aDF+gHWpXuNnQVUhN5e2s9teE4brq8A7KyymlHvKNm5Hm94TEcWW6jW/NDLBmmVL5GmnPvXF4Dt35hXsx677B0Yso2i43+CzL1/pwBYBREzY/la6zYCRahhYZJiEaLQH3Np5LkVRT/jA5mgjRv284SCTU2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jwiTFQI4; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jwiTFQI4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=785; q=dns/txt;
  s=iport01; t=1749687919; x=1750897519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vebaEpidSVTCWaBHFi0jPYyqh1hFt65CsSfk9PGHd6Y=;
  b=jwiTFQI4JkiBumDv9v8unymFIIavnj+jv6OGfmQ9KJsWY1PjbhcITErl
   ozPdtY07HbC6VR8++cwCbvj/p7Ewf/jvS7ipMS/Xa9NcT0y06SpUdh3hY
   LyETTAyQu3wfcyPSjpwwMHBGc7NLNf/r+XNruM9Thq9Oz/iydoUB44D4N
   YcwUmBUJyTUCIVN9xyXXfJos44MqMKna58+3DOp1RvhxS1831r/uA0TiW
   79V3qStf7jG2n1Gu+hJHm7Rt8NXvfoCJ8UsZEHI3lsZgnknAdJD4AXeGc
   Jg2c2m9CCiLGyoOWo1pADApZWieq+UFbJEgfQ7o6085e7lRj9a94merY7
   g==;
X-CSE-ConnectionGUID: jDzKktMTT+yJMcV6g9cq4Q==
X-CSE-MsgGUID: XGf01TfwRqm6gTmJxvh5Tw==
X-IPAS-Result: =?us-ascii?q?A0AEAAAZHUpo/5IQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB?=
 =?us-ascii?q?wKLZgImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGC?=
 =?us-ascii?q?IZbAgEDMgFGEFFWGYMCgm8DsBKCLIEB3jeBboFJAY1McIR3JxUGgUlEhH2BU?=
 =?us-ascii?q?oI4gQaFdwSCJIECFKEeSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCE?=
 =?us-ascii?q?osHhEkrT4UhhQUkcg8HSkADCxgNSBEsNxQbBj5uB5gLg3CBDoExgQ+mAKELh?=
 =?us-ascii?q?CWhUxozqmGZBKk4gWg8gVkzGggbFYMiUhkPyhgmMjwCBwsBAQMJkBeBfQEB?=
IronPort-Data: A9a23:BDWgKauy3ECElnd8wylHoBnwbOfnVL5fMUV32f8akzHdYApBsoF/q
 tZmKTzSO6zcY2ukeNtxbY7n8xtS75HczYJmQQVtqSk0RikXgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav676yAlj8lkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGZjdJ5xYuajhJs/za8Us01BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw+MplImJS0
 MAkayEvSxu92e3ny6vnc7w57igjBJGD0II3s3Vky3TdSP0hW52GG/SM7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgl/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9IYzbGJ4JwhzFz
 o7A11TWDElDCNKA8yOArH2Qg83fgyOmZJ1HQdVU8dYv2jV/3Fc7BBQQE1Cyu+G0jFKzQfpbK
 kod4C1oqrI9nGSpQ9v3dxm5pmOU+B8WXpxbFOhSwASE0LbV5UCBC3QJVCVMbvQhrsY9QTFs3
 ViM9/vrADFpvbKVSFqH+7uUpC/0Mi8QRUcYaDEJVxAt+dTvoIgvyBnIS75LFK+zk82wGjzqx
 T2OhDYxiq9VjsMR0ai/u1fdjFqEopnPUx5w/Q7MX0q74Q5jIo2ofYql7R7c9/koBJ2FR1OFs
 VAalMWEquMDF5eAkGqKWuplIV2yz/+BNDuZhRtkGIMssmz8vXWiZotXpjp5IS+FL/o5RNMgW
 2eL0Ss52XOZFCDCgXNfC25pN/kX8A==
IronPort-HdrOrdr: A9a23:xJ0HvKjQJFqZWjIbyY5MqI18Q3BQXvUji2hC6mlwRA09TyVXra
 yTdZMgpHvJYVkqNk3I9errBEDEewK+yXcX2/h1AV7BZmjbUQKTRekI0WKh+UyDJ8SUzIFgPM
 lbHpRWOZnZEUV6gcHm4AOxDtoshOWc/LvAv5a4854Ud2FXg2UK1XYBNu5deXcGIjV7OQ==
X-Talos-CUID: 9a23:3aKgVm1doCfakXSwt8JhIrxfGOw3UX7B6UvsYF6aLG1XFrLEQkbMwfYx
X-Talos-MUID: 9a23:sfMrpAr379wFmBAhw80ezwFNOp8x36qxMlkIz5o6vuuUKywtByjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="389534425"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:24:12 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 6B1A518000448;
	Thu, 12 Jun 2025 00:24:10 +0000 (GMT)
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
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	stable@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 5/5] scsi: fnic: Increment driver version number
Date: Wed, 11 Jun 2025 17:22:12 -0700
Message-ID: <20250612002212.4144-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612002212.4144-1-kartilak@cisco.com>
References: <20250612002212.4144-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-09.cisco.com

Increment driver version number.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 6c5f6046b1f5..86e293ce530d 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.0"
+#define DRV_VERSION		"1.8.0.1"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.1

