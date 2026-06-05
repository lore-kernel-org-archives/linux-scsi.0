Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE088374E60;
	Fri,  5 Jun 2026 23:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703578; cv=none; b=UapSc5ddtJKdPv3czmSm5Nd3mHHlcsyIu+7/vEalxfIrpi5lX5aveoNdVLu5JdzjJfiit+eB4TQPQ8I7zZJVItqrvo2ujRClnoOnzA75DcneOjrGnt+EIHMMwMllUdKCA7vBIJfXmVMKjGh0ZLlc0zS9O5WDBIEzqxk0EEdQngE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703578; c=relaxed/simple;
	bh=WHaVe4lxP3vzySB73pwv+/q2GF2UEAHCOQH6XlTNEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMat2XcYHlT8TbpAtjsQ4CG7ySExBUa1kiTm51WROmVj/n7FCmZh4qSaT/fwSyAr2kyu9p15+fSC+mZhFBZeecFhKPv6nHRJ3kn26oiF+WHca5LNw3L+Cy63xA3DK5OetfbCfPN3IpVeall1zQmVYd4znk9eODNkGKHZRXzhqms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=lcQl8nqO; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="lcQl8nqO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=982; q=dns/txt;
  s=iport01; t=1780703575; x=1781913175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ih4/4CQtXsRllMF+cu0QXC1vYWo60kbbCDWls6M2bSg=;
  b=lcQl8nqOrhdZF5x+dRCZqi+ACHTUFtcp520IcmnRuQhIRdGt2EjtAYgG
   jCCO2T65rxiAsI60WYVmS1ZHgAGNPflQfg/OdqbnELn7Z/DWnCeAfO1To
   WqGobuU87YZk69IPZP7CE9ykXoql/m5knTdmEs3gV1njTcAEnhC2Bi/SH
   GZrK5fKQ1wZvucwYHbMb0reB8R3PnCpdA4McarPJwfi5ikSbEQgCWx/qt
   Pd03GjugRZnHuTaBT7dIbCUKYNkm8Yu4SalPW2Xm5NjaAOrjotoT7VTvW
   czkQmwhdswWwOqOXaTun0deRJRmeLoMnITW8aGLKJ9JuTI0MRMcUD7qRX
   w==;
X-CSE-ConnectionGUID: xSwMMa4sRPKxl2htBJgiOQ==
X-CSE-MsgGUID: 6DDpPirCRkyLxIN8CLo2Jg==
X-IPAS-Result: =?us-ascii?q?A0BBAgCrXyNq/5P/Ja1aHgEBCxIMggULgleBUkMZMJQqo?=
 =?us-ascii?q?D+Bfg8BAQEPUQQBAYUGAo0zAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThlyGWwIBAzIBRhBRVhmDAoJ0A7N7giyBAd5CgWYBCxQBgTiNX?=
 =?us-ascii?q?XSEeycVBoFJRIR9gVKCOIEGhXcEgxwSkFxIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQsbBwWBSoFJaoEEhRIjHwM5gReBfIEoZ2kVMToXAwsYDUgRL?=
 =?us-ascii?q?DcUGwQ+bgeMLhcPgjeBDoExgQ+mDqEOhCahWxozqmuZBqlAgWg8gVkzGggbF?=
 =?us-ascii?q?YMiUxkP1wwnMj0CBwIHDgMLkWiBfQEB?=
IronPort-Data: A9a23:tqDNtaNyrW2cD9vvrR1UlsFynXyQoLVcMsEvi/4bfWQNrUpw32QOz
 zZOXzvUaKmDZzTzeYt0aNvioUJS6JHWzYU2SXM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf7g2Msawr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj6+VVE2QTNNEDwN5UEWUU9
 eAyCj8MSSnW0opawJrjIgVtrt4oIM+uOMYUvWttiGiBS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzM3wsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtgeCwb4qLIYbiqcN9wGq0v
 lrH5U/DAQA+JP25mRGh9SiOibqa9c/8cMdIfFGizdZqiUee7m8eEhsbUR28u/bRokyzWdh3L
 00S5zporKI3skesS7HVWhSivH+C+AYRR9dKCOA8wAaXw6HQ7kCSAW1sZjdNYd8hrMgrbSYn2
 l+Ag5XiAjkHmL+QRHSQ+beVhSm/NSgcMSkJYipsZREI/dT5u6kpgx7PR8olG6mw5vXxFSz2y
 DmMhDMjnLhVhskOv42//Fbak3evq4LPQwod+AraRCSm4xl/aYrjYJangXDf7PBdPMOCRUKAl
 GYLltLY7+0UC5yJ0iuXT40w8KqB/f2JNnjYxFVoBZRkrmzr8H+4docW6zZ7TKt0Dvs5lfbSS
 Be7kWtsCFV7ZRNGsYcfj1qNNvkX
IronPort-HdrOrdr: A9a23:Gg2pJanX9wjI6bh5HSbSjzMSB/vpDfLm3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV4hQqyFkFw2cDkp6ACNCBZY/Cd
 6gw/AvnUvHRZzSBf7LfkXsmIP41qT2qK4=
X-Talos-CUID: 9a23:r50Ip21YxhpPW0JtspN2TLxfCvs6V1jUkGzqG2yoDTxpVJe3Rl63wfYx
X-Talos-MUID: 9a23:HKVu9QnUaxlC1vxUlRl7dno8GOtw26W0I3oOgLEWmu/UHgh3YRWS2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="490578632"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:52:54 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 2DC0C18000241;
	Fri,  5 Jun 2026 23:52:53 +0000 (GMT)
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
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v3 13/13] scsi: fnic: Bump up version number
Date: Fri,  5 Jun 2026 16:45:38 -0700
Message-ID: <20260605234538.7950-14-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260605234538.7950-1-kartilak@cisco.com>
References: <20260605234538.7950-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.102.68];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.102.68, [10.188.102.68]
X-Outbound-Node: rcdn-l-core-10.cisco.com

Bump up version number to 1.9.0.0.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 951549aff521..7a46b3ce0cb3 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -31,7 +31,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.3"
+#define DRV_VERSION		"1.9.0.0"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.1

