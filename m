Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="hTw7cjqZ"
Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF495171A;
	Wed, 29 Nov 2023 18:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=877; q=dns/txt; s=iport;
  t=1701311782; x=1702521382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XEQ4NSFM5Uqzyo57IeSl2o8heX6pLC+We2PwToQ+IVw=;
  b=hTw7cjqZrYEFHKpQDfnaPBGTQwU/UjlRxy4/DHk1SAKBHVlbGdWXCdIu
   1SAfmnwARGTo6OFSC4m36MZg0EFNue8AFDWV1/DHX1lmdVsTtoiAyKTE8
   jkjCD370MFChuGl7X6kmb3ndc0/Pl0Sh+ca1BSsWACEV3SwJJfT0t9m2O
   4=;
X-CSE-ConnectionGUID: pNs4Hyj5TUSlq2YEjJWXKA==
X-CSE-MsgGUID: u90wgHi2TPKyM/+9mDsotA==
X-IronPort-AV: E=Sophos;i="6.04,237,1695686400"; 
   d="scan'208";a="148824002"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 02:36:21 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPSA id 3AU2YA4F007614
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 30 Nov 2023 02:36:20 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v4 13/13] scsi: fnic: Increment driver version
Date: Wed, 29 Nov 2023 18:34:02 -0800
Message-Id: <20231130023402.802282-14-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231130023402.802282-1-kartilak@cisco.com>
References: <20231130023402.802282-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-9.cisco.com

Changes between v2 and v3:
    Incorporate the following review comments from Hannes:
	Create a separate patch to increment driver version.
	Increment driver version number to 1.7.0.0.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index c4edbd7dfc25..7241aebf79d6 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -27,7 +27,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.56"
+#define DRV_VERSION		"1.7.0.0"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.31.1

