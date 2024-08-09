Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDD3B1A2;
	Fri,  9 Aug 2024 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222388; cv=none; b=obXenEc0S5wYqcTCNyqhIcnyhoA27S0jWlnqfEJxF9+tRxB+UOOrS7O99gLcWBfAGMSMU9kEBlje3bQDzP4+ZB4N/UIZMRiJSecwLw1ZKXGOw11i7Y7qPdXJUbaelK8OM2xXPYUtgDzrX2FpUnqLsDSOShK8Ya8g80xnpv7FoAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222388; c=relaxed/simple;
	bh=7pj6kBCs4+H6dOhjQfRNZktbtz4WYcaGtzKLKb71x9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o/pi/xK0a71qL6jH+ieN7HCLcYy0emlQp3Z4nKi5RNd2dMVcDvzFkUMoLTBZ3I1IvyzAvimuME7lQUmQAlx/pa5DCLBhDwI4ZMc1f5zkxXIcGeuGxmeCRznDtKgy3N0pnSn0E/CE1spURvtgLSlOGxoHb4hwxHkkOWc61mZ8a0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=KDKrV/FR; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="KDKrV/FR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1723222387; x=1724431987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umiK6JdZ/+LlMP7/GPYlTcXUbHKuF9jmp+eKzvNbYGA=;
  b=KDKrV/FRloTxlg/C0retVJR4Gyw24Ozyax1P0kl4sZ7K02QynjHsJ5PM
   IkPud6NvFlYb8DJBKrnJs/QBeCBJfCiWWP/N27M/Re7z3PQq5Be0xLmYr
   waImWaucTsZfj1l6qJKJbs8luy6b88sSEWXmrELFG0+8bLSS9U6FChGqa
   A=;
X-CSE-ConnectionGUID: y5Xr7T8lREeGu1r6ADTRXw==
X-CSE-MsgGUID: LsSM0UZHQheN9QK5EDebkQ==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="239376523"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:53:06 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2j031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:53:05 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 14/14] scsi: fnic: Increment driver version
Date: Fri,  9 Aug 2024 09:42:40 -0700
Message-Id: <20240809164240.47561-15-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240809164240.47561-1-kartilak@cisco.com>
References: <20240809164240.47561-1-kartilak@cisco.com>
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
index a5aea8ba648a..b4d28610a1ad 100644
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

