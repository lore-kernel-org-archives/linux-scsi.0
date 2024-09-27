Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C51C1ABE;
	Fri, 27 Sep 2024 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727463364; cv=none; b=RFS4/fRDBS2Ll73E9HIE3ayU6N2r0dt3SHb/GCkrUyBmHRjwFaA5sFzLTi13EUcgRZrlPrXUi9sjp/eOAIs65yqwhPz3iUUdoQk06Nj6zMUTbaMPoHtada4EBwtr838Ei1ikUtnaK2NRfv5EEWWCF4FyzDSACD9owyIWCz5ozOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727463364; c=relaxed/simple;
	bh=5qfWodULDLVsekB+OCOLWzJk/ZdiqaiLkSFAzUFicmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kYQMPlbGesSeUWEzTQPAWP+we/nkLQ6VQS2JDPzV4zUtQ6RMyxoH3CFhZTwnibrzDjv5hcpfUoXiesCtyUh96ipcqLkK1I8iMoQtT3nSNQwO/dRZz3JBu8/PkqhpGcjOXvePh1ui2KCU0pLLWyX11Gg5/zcaJn6dvkMrDczEu+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=DBxUmgDF; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="DBxUmgDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1727463363; x=1728672963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+NDOGTVmsXxT1gPQhPkHFEQFR9jHtVt7H8Q2NXM1ZE=;
  b=DBxUmgDFIKG46tsY8C8HU7xAKzAm+jOHaYAT/yBytW4ZZB/WqtkJfIZn
   OvVUbDx8X9SBpEvjgd5ljryzBrqFgmhK3+3E7tIj9NVf+LIA+NtAcfseF
   Hj56OGt/OhgzDMh/JYS2OqjPAOl/wCe9L/8jUr9DUwL+1kRIa7KmZD6CD
   A=;
X-CSE-ConnectionGUID: Wnf5uCrBRrGlz5a3iMzJ5A==
X-CSE-MsgGUID: L9WG+6FIQLqOR3ZlSCWffw==
X-IronPort-AV: E=Sophos;i="6.11,159,1725321600"; 
   d="scan'208";a="258700094"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 18:56:02 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 48RIkQav022754
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 27 Sep 2024 18:56:01 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v3 14/14] scsi: fnic: Increment driver version
Date: Fri, 27 Sep 2024 11:46:13 -0700
Message-Id: <20240927184613.52172-15-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240927184613.52172-1-kartilak@cisco.com>
References: <20240927184613.52172-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-5.cisco.com

Increment driver version to 1.8.0.0

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 5fd506fcea35..e98e665801d1 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.7.0.0"
+#define DRV_VERSION		"1.8.0.0"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.31.1

