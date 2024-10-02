Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165DB1D14EE;
	Wed,  2 Oct 2024 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727893948; cv=none; b=Rwz5tE+vYai0iLpym/N6HdWuiIUlPB6XfEufcPSzB8I9HqBjlhad+DZeK85OuZLfBLzMiJW85olX063CfCbqDikcGsy9ZG9cYLpL4+EjtL/jt9PWDj3LC8mlmG5c8apdc8BodPqNb1MnMCQhbqa/vgbX7AQV3iu6Q5ajjiC1B2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727893948; c=relaxed/simple;
	bh=5qfWodULDLVsekB+OCOLWzJk/ZdiqaiLkSFAzUFicmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c+LSve6ls4qxKxMRPyqwXbqsZjruGszLcrBvdcYQP6OBiCeNPtHJYM2Te3UMMf2fU9wBr1WD0OD/jHc96FLjxDKfniAtdeqimO7PPVh0/HqVDwRVkhUlk71H51ctnCeHcngdd3RVknS9e4PLmTmeIl+Tk9xYeZKBdTDLitN8AHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=YRuYv6ok; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="YRuYv6ok"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1727893947; x=1729103547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+NDOGTVmsXxT1gPQhPkHFEQFR9jHtVt7H8Q2NXM1ZE=;
  b=YRuYv6ok3KLG08OTsZIdaXqfz2TVipglb5fqPnzgUbEPm8jqnVBkEGfX
   OHjaNVd+JIiwjsGiOFbYCWrwEd40QQp9k212y9PrQroEsOd6dJSezxEXe
   3TGywJM92BJdSs3EQ5MXdIuo23V4gKw76CPtUx0K0Yj+oJt0Gv5KMmlsZ
   U=;
X-CSE-ConnectionGUID: Ismq2lGmRG6GEkTBpCE5AQ==
X-CSE-MsgGUID: hTPsOwKIST6OOfvOhlYoOw==
X-IronPort-AV: E=Sophos;i="6.11,172,1725321600"; 
   d="scan'208";a="260383806"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 18:32:26 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPSA id 492IOHQx009807
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 2 Oct 2024 18:32:25 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v4 14/14] scsi: fnic: Increment driver version
Date: Wed,  2 Oct 2024 11:24:10 -0700
Message-Id: <20241002182410.68093-15-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241002182410.68093-1-kartilak@cisco.com>
References: <20241002182410.68093-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-8.cisco.com

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

