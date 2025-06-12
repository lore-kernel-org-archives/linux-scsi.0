Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA5D2DECB2;
	Thu, 12 Jun 2025 22:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749766905; cv=none; b=sh/cCVCmLQeNtKgtvgtuo7K60VpKFASOF3MbcA9vRwIChcKFKTPmkj4pZqrj0HInKtYCEDZeSOGVbCymnJuaZXLEtMoO6DG7cCNqM1N+4qY3kdeq6Bd4YgDApQ1gQcj9ybBWe/NUaPO8ndvmYVoguTmyLLfL8xyUTm164MlmFXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749766905; c=relaxed/simple;
	bh=W9TMtmNAQox4GJzmyGBKfQRvar8R3C9E12Rn9hMqO80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoqO2wiwOpjZs+t3q5Ff9lPPkymaAckSAJnRMfh7Gty1ykeAgLGdZoosRhAuKKxa3ez74VVJnQ9k9Ch5ofQvBNmTH1KwGp0m9KZ/8BTsMmKy4BZpI4jWL+sXG00JzVRK4qe63cogaediAow+lz9SzHMPUZ/sv9UoiO3Ut2ttzhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=fBOasexu; arc=none smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="fBOasexu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=785; q=dns/txt;
  s=iport01; t=1749766903; x=1750976503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vebaEpidSVTCWaBHFi0jPYyqh1hFt65CsSfk9PGHd6Y=;
  b=fBOasexuGsyfDQonBCAIqKmDo1Ubyw+K1Bjo5h8Vv33z7TvG6iUtW/Gu
   BVx0QeQnmLeEI3nvpB0q2/tox3DL6PPVEXESxx3QSF7iZ12Mqd1r4mzWi
   PvLoYoCoIYqbGwrXoOLClJwPNayTkh0MWKXitE6gayqpRM5bRhTo3cRVX
   GAjTQZ48d2+12qW0G8hk6t3iFOm2DmyhPQ9KmYs0hg1ML7SITRpT7mPgF
   PMkB+yQywMj21lWx2AU33F2ANXzCOzrcFHv7d4sfvUyShDgfm6QV3Urr9
   wlpXaLmkKdkweXGhTXSuHgFEDvkkUVM60zr2BI+1+sF4ncZAoZM0CvO5O
   g==;
X-CSE-ConnectionGUID: 0xONz7/rSxma0bmfYB2Qwg==
X-CSE-MsgGUID: KhsYbUo1T7WH8xOgNwH/Zg==
X-IPAS-Result: =?us-ascii?q?A0AUAAAgUkto/5MQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYIABQEBAQsBgkqBUkMZMJQkoDqBJQNXDwEBAQ9RBAEBhQcCi2YCJjUID?=
 =?us-ascii?q?gECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGWwIBAzIBR?=
 =?us-ascii?q?hBRVhmDAoJvA7AJgiyBAd43gW6BSQGNTHCEdycVBoFJRIR9gVKCOIEGhXcEg?=
 =?us-ascii?q?iSBAhShHkiBHgNZLAFVEw0KCwcFgWMDNQwLLhVuMh2CDYUZghKLCIRJK0+FI?=
 =?us-ascii?q?YUHJHIPBkdAAwsYDUgRLDcUGwY+bgeYCYNwgQ6BMYEPpgChC4QloVMaM6phm?=
 =?us-ascii?q?QSpOIFpATqBWTMaCBsVgyJSGQ/KGCYyPAIHCwEBAwmPdYF9AQE?=
IronPort-Data: A9a23:rOoPvart4Q6uE0NUxIZMIq4mxzxeBmLIZBIvgKrLsJaIsI4StFCzt
 garIBmEbveLMGL2L9hwboy0/R5X6MXXzYIwQVQ/ry89ESIQo+PIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9z8ljPvgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQHNNwJcaDpOtvrd8Uk35pwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0r5nJkdcq
 rsCEyAIZ0iJguyH6uiCVeY506zPLOGzVG8eknhkyTecCbMtRorOBvySo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtIYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDVFZsEwRjI/
 Qoq+UzaAgorPuGYkAbazVL8lsjAuzzbH7AdQejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBBzlitrCaSXO17LqYrTqufyMSKAcqfyIaQBEey8PurIE6klTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRLt1VXGIu
 HwC3szb5+cUANTUzGqGQf4GG/ei4PPt3CDgvGOD1qIJr1yFk0NPt6gLiN2iDC+F6vo5RAI=
IronPort-HdrOrdr: A9a23:ip+y3aATjBEgQUblHemD55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuQ8bpE0dND2DrMpbnmFENjo=
X-Talos-CUID: =?us-ascii?q?9a23=3AoMVXNWteowZO+uCMXNwoLU0U6It9Ylr73iiXOXS?=
 =?us-ascii?q?oDG8xQribeHXKwbxrxp8=3D?=
X-Talos-MUID: 9a23:rfldzQjEIn+sQmHGufut/sMpF8dz0q6TDxkxzqom69mjOgpvG3Cvg2Hi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,231,1744070400"; 
   d="scan'208";a="478697683"
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 22:20:21 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPSA id 7F1CF1800015F;
	Thu, 12 Jun 2025 22:20:19 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v4 5/5] scsi: fnic: Increment driver version number
Date: Thu, 12 Jun 2025 15:18:05 -0700
Message-ID: <20250612221805.4066-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612221805.4066-1-kartilak@cisco.com>
References: <20250612221805.4066-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-10.cisco.com

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

