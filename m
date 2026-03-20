Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542AD2C08D4;
	Fri, 20 Mar 2026 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774043771; cv=none; b=RMUd1YCnOHYjlR3BlAt3ZdfItLSalJQPUrQ2Jeu1CGNzTZWmjVQimo8koko8XBz3vPmH7u4YbErHm5p9yjUAHIvJyIG6rhN6Db0RtIyGYzYYKjNQUPew+1bu0vEuzmxjYGo5I/e7EPIxsOPMPVHTc4aF9qzDyTRpkzl2Qk7oVkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774043771; c=relaxed/simple;
	bh=/Rf2eakh5ZeaAaheFJYAVxm4fy6YqH2KFkakWRjpmuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CuG8hQBLU1NK5TdKjW46N4YdNXBKqqv8jiFy1dxdmbUHKgnNwNNL7rivjMNJZ/YVLMX/xBddbgw/bCeRlaohlGp7Vomj0g5cpk1Dw/v+3OhgS5swWZEFjyACh+XQQTn1vUF/GqJjcwEZWYBIDehebjDCWo1mkyC0rsA29Rl840s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmBP6vwm; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmBP6vwm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774043770; x=1805579770;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Rf2eakh5ZeaAaheFJYAVxm4fy6YqH2KFkakWRjpmuM=;
  b=OmBP6vwmwkW+kjZbjRMjAh5HF8o+bsC4ksMXj8MicvWjyp1kWdAWj60l
   PDJwG8EGusvSqI9pFqX0cf3pX5N+A7awzLGB+OkWjKyfYR+vVuig8UXas
   80lSMxr/ZE7rPETxELLMHZUla/uD6Dvq7FRlGhVRdxn4DCwBzrIAsFuvZ
   gIaQetj75a/G36vjR1liM0xw2HwD1ekfTOE5uaQLhCWZV4KGgsVwi20nQ
   XIOQXHtBuViN0vYzpIdKTM1F9RURTcKjufAPb/j+pUM8/ut0p7fY0n2kH
   tEwnW5kkyotN6T2/mA6UYQpDm+/TSTlUrEx52SW523DoPyyqwyXPutToh
   A==;
X-CSE-ConnectionGUID: EGf0mmyaTFyRzyawpNS1Qg==
X-CSE-MsgGUID: m4Jo797vRBahNsNGrTlUzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75206238"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="75206238"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 14:56:10 -0700
X-CSE-ConnectionGUID: RKkVuXzFSeeUmx+o2YwLYw==
X-CSE-MsgGUID: Kp0B0jduSwCPwqIM2VlfoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="220732837"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa008.fm.intel.com with ESMTP; 20 Mar 2026 14:56:07 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id DB47195; Fri, 20 Mar 2026 22:56:06 +0100 (CET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Shawn Lin <shawn.lin@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: ufs: rockchip: Drop unused include
Date: Fri, 20 Mar 2026 22:56:06 +0100
Message-ID: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This driver includes the legacy header <linux/gpio.h> but does
not use any symbols from it. Drop the inclusion.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ufs/host/ufs-rockchip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 7fff34513a60..bac68f238e1c 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/clk.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
-- 
2.50.1

