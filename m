Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618B12080E8;
	Wed, 11 Jun 2025 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666720; cv=none; b=hBIMjSt+zAGaJH/nXNFyKhkymlB6srIXBh1ZOaBu7ike2SFBsn1mnBpLPfG761zBYToWqNqkWcin1SRr5HlSUHHAdTkYACryhI6WjsSWtMljSXgAQN6evK3hWgEDDID296ZLkOyWAA3Hq/3S9onzU44pJ2h5jT0qzeC13mUR9ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666720; c=relaxed/simple;
	bh=PEHxbqrzoyHUUQaL74yw6VE98mZC7ycMm7/xjP3p4p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdrAM0c7xLJlGgPgsEuynELcSxNWqhZAM2+yWQ/Ebd5o11OEhEQGKo36fMwWPBkaZProgh5qLWKQcEPqYHARrz6XNY8lVvHxu52kuz7DIrIl90VfVq+kt2Jj/NVB+PX38YDMY0iHdgCVSUPbHrBB7JQKmWgHdgRXa7b3eBsHTDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=GWEpT4up; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="GWEpT4up"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1295; q=dns/txt;
  s=iport01; t=1749666718; x=1750876318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qsaTwL+LjrLgKgBXAN54YULYxG1NzNjYmC+a2ZMLgX8=;
  b=GWEpT4upPHJcwPWzaBkbQXhCeimm3FCBNK29unEyaBMvML9ePZu+oJpE
   FLHZZ3DcV78PN1600/X5k4l/9hm0tWEQrp23xdjENdabo11Og0pRZBMLx
   mxZ+JmLKBDYsLgJMn27qkazcLwA0mf8NxjpljuNnyn/uEkf86bXDUDCqZ
   3aybiBU2TVrSc7x6LZnM+OgP/AWYp3F5Iaob2cskUSiR4sr2GJQw7O9WF
   V/foISjYwZfHfgGwiQMhlqX0W+RbzQyyxGAwX5mDgnoau+khd2cZxk7Be
   vAePrvO7xLo83E+xibX457xCPLbTeNgwc5s+3vPx6PModma4MkJWTACbP
   g==;
X-CSE-ConnectionGUID: Yf7IMcxAStm0sj2mWBBcUw==
X-CSE-MsgGUID: BkWeika/Rq2xdxwemeqJLg==
X-IPAS-Result: =?us-ascii?q?A0ANAABcyklo/4sQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFBwKLZgImN?=
 =?us-ascii?q?AkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZbAgEDJ?=
 =?us-ascii?q?wsBRhBRVhmDAoJvA69xgXkzgQHeN4FugUkBjUxwhHcnFQaBSUSBFYJ5b4FSg?=
 =?us-ascii?q?z6FdwSDOqEUSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEosHhEkrT?=
 =?us-ascii?q?4UhhQUkcg8HPUADCxgNSBEsNxQbBj5uB5gEg3CBDnyBRKYAoQuEJaFTGjOqY?=
 =?us-ascii?q?ZkEqTiBaDyBWTMaCBsVgyJSGQ+OLRa7VSYyPAIHCwEBAwmSFAEB?=
IronPort-Data: A9a23:ugzsgqqjKJvuzfyURUKDCC5y9vNeBmLIZBIvgKrLsJaIsI4StFCzt
 garIBmDa6yMZ2anLt1xPNy08x8B6seDzNMxHFdkrS40RSsUo+PIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9z8ljPvgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQHNNwJcaDpOtvrd8Uo35pwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0td5XkBr/
 uwxEywINguB3eeJ6piwd/Y506zPLOGzVG8eknhkyTecCbMtRorOBv2Qo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwxGYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofVGZoMwBvE+
 Aoq+UzTAS4XNd+WjgCcqGKglvDCmC7ieqYdQejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBBzlitrCaSXO17LqYrTqufyMSKAcqfyIaQBEey8PurIE6klTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRLt1VXGIu
 HwC3szb5+cUANTVzmqGQf4GG/ei4PPt3CDgvGOD1qIJr1yFk0NPt6gKiN2iDC+F6vo5RAI=
IronPort-HdrOrdr: A9a23:jYQ7NawgslN8kCv8EAvyKrPwA71zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0uEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: 9a23:QlTR4G4WVQpoKDI3E9ssxUBLO+UuYlTm0HKIOE3iDFlDYraoVgrF
X-Talos-MUID: 9a23:hbPnsAhEE7Wm1sqn8GqmpcMpHsRX7qWtAQc3iM8Wt9mbOCl9IhW5g2Hi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,228,1744070400"; 
   d="scan'208";a="374716546"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 11 Jun 2025 18:31:55 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPSA id 2E92C18000151;
	Wed, 11 Jun 2025 18:31:54 +0000 (GMT)
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
Subject: [PATCH 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Wed, 11 Jun 2025 11:30:32 -0700
Message-ID: <20250611183033.4205-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250611183033.4205-1-kartilak@cisco.com>
References: <20250611183033.4205-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-02.cisco.com

When the link goes down and comes up, FDMI requests are not sent out
anymore.
Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 9e9939d41fa8..14691db4d5f9 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -5078,9 +5078,12 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 		fdls_delete_tport(iport, tport);
 	}
 
-	if ((fnic_fdmi_support == 1) && (iport->fabric.fdmi_pending > 0)) {
-		timer_delete_sync(&iport->fabric.fdmi_timer);
-		iport->fabric.fdmi_pending = 0;
+	if (fnic_fdmi_support == 1) {
+		if (iport->fabric.fdmi_pending > 0) {
+			timer_delete_sync(&iport->fabric.fdmi_timer);
+			iport->fabric.fdmi_pending = 0;
+		}
+		iport->flags &= ~FNIC_FDMI_ACTIVE;
 	}
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-- 
2.47.1

