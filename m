Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9DE78F24
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2024 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733830241; cv=none; b=S7Oa2mUw5YFGebMNJIvHMyYSFawggWRBvPaLYG8Vj78zRnu6YRP8yj3ReStuz+DnAGv+nxsSAy9IFLtfRx+D0fJI28sv2vn3mYpf550lOM/xHFCQxZ1pE/v13CtguEFV3QKlIu1/syce0vp41AiIO5ym3NkJ+/B2sUEdBBfTGNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733830241; c=relaxed/simple;
	bh=KEVQsC3T6+iAqrQ7FLyL+SB2OiYbN3HNw6W15G36LSI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NqSZ9gZozddQdaDFoJ5aOIlfd6b+AtHLHbYl0wirOMjkZJnGbj48SfYfBkZ5l2f1GIeNWpDotFmGW5j0Tmiat92C58qBTcz1yUNOG4tsjIpaNSlgo7svLbbj+L2JztwbbAa+jDmJi7kP9vJ5CprJjYOgIhghj/qayA18IjXbfGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DJIaiegg; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DJIaiegg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733830239; x=1765366239;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KEVQsC3T6+iAqrQ7FLyL+SB2OiYbN3HNw6W15G36LSI=;
  b=DJIaieggF1td2e9CKFpRIA0BJMn11lh2aTKDfUtijk6OByLhVtlRPe/f
   b+qv2qdlGp7ki17eDervSY/UwrPvoG29/3VGJPkkh6qkYDRzKnBbnOTNa
   Mu7vl73qGl6egNSRHNokoGVy1Gp+o50uRHsWRNF3TG5HTCEK3JhunU+Y2
   d211mbzkS/nPZatOYBFzgqfGKYuCSGdbO6vxEAwcaYVpVKT8Euu2mm6Hx
   rF5RwJaEurPZ1SNd4USS1LecesMJxpXbU6iIlj7PBPBAPVbwoVVmmmU/u
   usDxCiJd654JF1lA4nIudCatkudzEh10ErYLZTIjXE3NYY4juMYLTLxEX
   Q==;
X-CSE-ConnectionGUID: 78dDRWOGSsuI4CCBr1Bvfg==
X-CSE-MsgGUID: cd+xzBDWTrGjaW/pWSYt8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="45550808"
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="45550808"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 03:30:39 -0800
X-CSE-ConnectionGUID: 0c7Woq/lSj+n8th4HleUYg==
X-CSE-MsgGUID: 3jdk2KuQT16w3vIrIdNPyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95259207"
Received: from unknown (HELO apaszkie-mobl2.igk.intel.com) ([10.217.181.53])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 03:30:38 -0800
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove myself as isci driver maintainer
Date: Tue, 10 Dec 2024 12:30:28 +0100
Message-ID: <20241210113028.13810-1-artur.paszkiewicz@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'm leaving Intel and I could not find a new maintainer for this so mark
it as orphan.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 17daa9ee9384..2d5c2d1057f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11442,9 +11442,8 @@ F:	drivers/mfd/intel_pmc_bxt.c
 F:	include/linux/mfd/intel_pmc_bxt.h
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
-M:	Artur Paszkiewicz <artur.paszkiewicz@intel.com>
 L:	linux-scsi@vger.kernel.org
-S:	Supported
+S:	Orphan
 T:	git git://git.code.sf.net/p/intel-sas/isci
 F:	drivers/scsi/isci/
 
-- 
2.43.0

