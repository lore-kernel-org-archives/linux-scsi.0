Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9AD1879;
	Mon, 10 Jun 2024 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718056753; cv=none; b=KOwZt6A5i4Xkl3Xltgd459YHB9H9mm0Q0Zf9PoX7uRQdfNT33jD1WgJtBNyBhkcMjVKV73IFYcYLphLEh+40qbwa/rPStrG30wtc1vOMbbw/8oh5fp3/4iJK3HHApmHrvBCQkgRB4CdTqsbp9X+KIhaBgKVVqTywWvpCnIDo/gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718056753; c=relaxed/simple;
	bh=s6AKf2rw41CuqIC+ov9OURowxloV3qJ1rpMVfuh3PZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8UUZPPHJXOwNSa0LHGxwqqY6cV5zjVgAimsFwtuKWZ1Q21XyxiLD3xLHgavv5ACjuhNATpDJ4YJ3myrHyZILfq5ijKzdI/LB9IIc3R0y7tr0sdA3VIpCuWxz9bceM4IZYHhVnJamabxwevNxk7dfZcEFVm2zOjQuZfFCTjUfH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=bS6Qn4Fh; arc=none smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="bS6Qn4Fh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1718056751; x=1719266351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tAh2Y+dzo30unDYIsvmEMV6pDuRIP7jOTBLF69yuE5c=;
  b=bS6Qn4Fhn3Mgc0zw4LOfyZnoUcLhWRtXDz3eyyypOEnH23HF1SVnAKOR
   ygiKv+LRJiRkZmCk/Yhvf8rh71ydeUn9FKSr35rCWwkFYqUsVKgJxNMf7
   UwaqNHw3h5zfF7WxuI+DmIfYZxbeLrycEBNhfb+SfSBShh1CzkhsEe1Re
   M=;
X-CSE-ConnectionGUID: zcg7fJCsR1W/lANtoA3ImA==
X-CSE-MsgGUID: p9xZx8UASzK7c9ZBxLXkzw==
X-IronPort-AV: E=Sophos;i="6.08,227,1712620800"; 
   d="scan'208";a="293601214"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by alln-iport-6.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 21:59:10 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPSA id 45ALpBCc012699
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 10 Jun 2024 21:59:10 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 14/14] scsi: fnic: Increment driver version
Date: Mon, 10 Jun 2024 14:51:00 -0700
Message-Id: <20240610215100.673158-15-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610215100.673158-1-kartilak@cisco.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
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
index bcf2aaed0b1f..8bdfdd67f08c 100644
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

