Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0076A47;
	Thu, 12 Jun 2025 00:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749689195; cv=none; b=HHQxhj6ouO/FpK1O+YInj2IdGq31qVdtKEVWyxoq9DI81BGKVWUX8u2n2qxcfz+VMw1tMcKoPk1XYc+n6VxWes7zLssf5pcWY8ovKwyQf9oJQ3sYG3o0MSaFILHVHZsLsk4TUjZoAqdLq6x7iLHDHwGsPBFZM2UoZC78/VnJFzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749689195; c=relaxed/simple;
	bh=W9TMtmNAQox4GJzmyGBKfQRvar8R3C9E12Rn9hMqO80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJEdj9KQJoB6NXvLUfbHGaT17C7KIqFEVWnwMl3etukgS3OJjI4tfFTbvcy2c35hnLCDi0+3jCvcQ27N2V5amE0RcFg9RhhktppvCBRXi2h0qfD96O9ZwiU3GiI9/C03JMSI8ONAG6R9D6b95b0GZHWSH1ddal6w50c6X+f2Ifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=FZ3h8AT1; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="FZ3h8AT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=785; q=dns/txt;
  s=iport01; t=1749689193; x=1750898793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vebaEpidSVTCWaBHFi0jPYyqh1hFt65CsSfk9PGHd6Y=;
  b=FZ3h8AT1F1idhjv7D9Q8Tszibs64w5GILl9w8rwguUsTgtKeG3GP1a7k
   eXXoKLhprX23wJ51q2apcjydjQNZUlN77SgRwpdckQt53lcRSnSTXa0Bq
   mBqgS3FuE6NQppinuwwetZC3Efn+AE8TUSRiI93v+2f+fllLqp+l/RloN
   EksTnuTJobc8zEGVkQUs0Glogt3uHix5fNSsRnYCVbvS6Z/wznUtm8EPP
   b2h7orYobLxgFbzk/AFa43PmtgN5p6RKAs8hfs8wClGSNs7PWdKOxL9Uy
   ncm4MMILzVqarqxB3UYGQnBlLOawjx+G4eu1Y+E0BfX/HAjbYgUj/RH8z
   w==;
X-CSE-ConnectionGUID: MTug3sQUQCmN2pFaUhv3Ug==
X-CSE-MsgGUID: nbdUsdZLThqC09GsSYsm8Q==
X-IPAS-Result: =?us-ascii?q?A0AEAACCIkpo/5IQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB?=
 =?us-ascii?q?wKLZgImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGC?=
 =?us-ascii?q?IZbAgEDMgFGEFFWGYMCgm8DsAiCLIEB3jeBboFJAY1McIR3JxUGgUlEhH2BU?=
 =?us-ascii?q?oI4gQaFdwSCJIECFKEeSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCE?=
 =?us-ascii?q?osHhEkrT4UhhQUkcg8HSkADCxgNSBEsNxQbBj5uB5gLg3CBDoExgQ+mAKELh?=
 =?us-ascii?q?CWhUxozqmGZBKk4gWg8gVkzGggbFYMiUhkPyhgmMjwCBwsBAQMJkBeBfQEB?=
IronPort-Data: A9a23:r3+4DapgwYtyvpYyXFms1+hIycJeBmLIZBIvgKrLsJaIsI4StFCzt
 garIBnSbKyOZjanfoxybN6+oEoEvcfdytNgG1BlrnpkECxEpePIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9z8ljPvgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQHNNwJcaDpOtvrd8Uo355wehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0sNLHG4V7
 sUlERsISEqbqeuLwKzgd+Y506zPLOGzVG8eknhkyTecCbMtRorOBv2bo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtJYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofaFZsKxRbI9
 woq+Uz/CB0nL9Ct7QaF61n018DUphLgXdIrQejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBBzlitrCaSXO17LqYrTqufyMSKAcqfyIaQBEey8PurIE6klTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRLt1VXGIu
 HwC3szb5+cUANTVxWqGQf4GG/ei4PPt3CDgvGOD1qIJr1yFk0NPt6gLiN2iDC+F6vo5RAI=
IronPort-HdrOrdr: A9a23:qqQv6qzkwWT535gYpnTYKrPwA71zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0uEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: =?us-ascii?q?9a23=3AaeMeiWpD2cIogDg0LpeBNqPmUeUZb3KG107tGmS?=
 =?us-ascii?q?9LzxxZrSoSUHLxawxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AN9lAFA6y71U3IOgr8EItdfb2xoxu6aiTE0w/tak?=
 =?us-ascii?q?GouLcZANrAAaGiWSOF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="388673889"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:46:32 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 3749B1800023E;
	Thu, 12 Jun 2025 00:46:31 +0000 (GMT)
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
Subject: [PATCH v3 5/5] scsi: fnic: Increment driver version number
Date: Wed, 11 Jun 2025 17:44:26 -0700
Message-ID: <20250612004426.4661-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612004426.4661-1-kartilak@cisco.com>
References: <20250612004426.4661-1-kartilak@cisco.com>
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

