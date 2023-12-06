Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Rh7pbLO8"
Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6598F10FF;
	Wed,  6 Dec 2023 10:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1056; q=dns/txt; s=iport;
  t=1701888435; x=1703098035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DvpvexVDMU5638wqFKGLX6VF8dgg0xDpZ3MUoNlfWeY=;
  b=Rh7pbLO8lRb+VAfCFVi9uxswufie0P0oQICcwGUSjpS9vbm3FS86YwiC
   72/LAaW41Wso5O0weUDmLHb3Hq1D4G41dbU01C3SYn+YqvHQkclVCkbnE
   mhFTDt9RHm52ZV7IFAJUVdxz+CnpzcQKLDBRfpBBJTqeyfFAxwyOCld5K
   s=;
X-CSE-ConnectionGUID: 0VqnhO/SSNu5vJN/vZvf+Q==
X-CSE-MsgGUID: /Vur/SGrSamPKHoNazhmpw==
X-IronPort-AV: E=Sophos;i="6.04,256,1695686400"; 
   d="scan'208";a="154982619"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 18:47:14 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPSA id 3B6IkHD9010013
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 6 Dec 2023 18:47:13 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v5 13/13] scsi: fnic: Increment driver version
Date: Wed,  6 Dec 2023 10:46:15 -0800
Message-Id: <20231206184615.878755-14-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231206184615.878755-1-kartilak@cisco.com>
References: <20231206184615.878755-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-4.cisco.com

Increment driver version for multiqueue(MQ)

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v4 and v5:
    Incorporate review comments from Martin:
	Modify patch commits to include a "---" separator.

Changes between v2 and v3:
    Incorporate the following review comments from Hannes:
	Create a separate patch to increment driver version.
	Increment driver version number to 1.7.0.0.
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

