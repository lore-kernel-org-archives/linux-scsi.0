Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44840313555;
	Tue, 17 Feb 2026 22:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368086; cv=none; b=EcofVYd7+tBziokr1CR8ArjjOWst3yoEIQV1JDey3q98UdSIbuajg1KJxdAzwt1a1q2ceV5zl+CVY48OnU0KyP8wOyRsEBDlVN4NGFSOzIgLh6LKQvrTBbH4Dc3K6jquKdrnXgevm+jX0Kqde/Nvz9fURQv3WI8Ox8Nsh96qxCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368086; c=relaxed/simple;
	bh=93eorr+pdQCrxm4YkAQc4Cp/XmiQDqFSXhecMQLIk68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHt1XtJKznC6S3VbVKj24vc1tOorS0v/HjzgS/HdrqUf8UxvhIUjUwF4DyHn8/IF2oPMqjiGejtbteaJnYVGheIsybtQ3PqtUYLSFEhYBDAt1w+XZIJ+TH0Vom9hTzuw2dDl3A+akVzUh1MLD9fKmhiE3M32NZVYODY2o5qj6V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kPywZlnf; arc=none smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kPywZlnf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=875; q=dns/txt;
  s=iport01; t=1771368084; x=1772577684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L78NDZNLVzrtrkruJPhz384/pib8nZ3A8haqU/KlMYI=;
  b=kPywZlnfQACmVd3Ni6WGFRTA4QpF95JQ+oEDrqriisoHVaF+0xZCSmBx
   9YkKeKTgl50/BsBb9V+bXFkiGqaQSnteRfBbP+VT7ksOr1vQDjcvius0b
   OgjQqKeAT3edtYpjUtkCtQ1+B/v7GKuuhLhgmxQf+WW8nD6CAkK3Qq8xi
   6bh1qKXPqnT3Mn7+6fpCEEoc6cKdzfhHnZJFWW8MvpJlaZ2H7mgukdf1Z
   EEvX5y7RwIHFylZZJEZrluEj3/SMuY+G0ekZxMx+iN216KVzCUsG6YwPb
   /jQE6blljyoWayZWYX0cKzEHZq9YLv6CiKbqo76RhWLOMlyNk7RBSlIgS
   A==;
X-CSE-ConnectionGUID: Y6GEHZ6PR2SWENv0YXhuEA==
X-CSE-MsgGUID: NDdQ41ykT32kHnl9ffgI1w==
X-IPAS-Result: =?us-ascii?q?A0A5BgCL7ZRp/5X/Ja1aglmCSA+BT0MZMJQqoD6Bfw8BA?=
 =?us-ascii?q?QEPUQQBAYUHAo0fAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZchlsCAQMyAUYQUVYZgwKCdAOteYIsgQHePoFkAQsUAYE4jVV0h?=
 =?us-ascii?q?HonFQaBSUSEfYFSgjiBBoV3BIIiehSTYUiBHgNZLAFVEw0KCwcFgWYDNRIqF?=
 =?us-ascii?q?W4yHYEjPheBCxsHBYdzD4l9boEfgQwDCxgNSBEsNxQbBD5uB446QYIzgQ6BM?=
 =?us-ascii?q?YEPpgyLd5UXhCahWBozqmuZBqlBgWg8gVkzGggbFYMiUhkP0xklMjwCBwsBA?=
 =?us-ascii?q?QMJkWqBfQEB?=
IronPort-Data: A9a23:sl8R56zJCm/spzHKQ9J6t+fVxyrEfRIJ4+MujC+fZmUNrF6WrkUHn
 WUYWmqFPfuPamvyKYhwPo6y9k8Evp+AyII2SwA4qFhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4qaT/H3Ygf/hWYuaz1MscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJHBoEqA4yLhPOzt1y
 tE+Nmg8XhCeqsvjldpXSsE07igiBNPgMIVavjRryivUSK98B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCzbouIKo3XHJ89ckCwg
 E7KxjigExImb4ac6TyBo3yiic6WgnauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc95WL
 Qof8zA2oK4u+VaDStj7Vge/5nmesXY0WddSGcU+6QeQ2uzV6QPfDW8BJhZEYcY6tclwXTE22
 0WSktXBAiZmu7mYD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCw/gagDyM0GzaO2+XjZjD+24JvEVAg44kPQRG3Nxgd4YpO1Ipej8lnz8/lNNsCaQ0OHs
 XxCnNKRhN3iFrmXnyCLBeFIF7az6rPcanvXgEVkGN8q8DHFF2OfQL28KQpWfC9BWvvosxezC
 KMPkWu9PKNuAUY=
IronPort-HdrOrdr: A9a23:W/oss6yClyP99HRMj+7mKrPwA71zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0uEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: 9a23:4gWG2m6ENxMbWbkPutssxRA7N+AXLEXnlkzvDmmmUVdZSKC4YArF
X-Talos-MUID: 9a23:YmexfQhCxM1avaKzqpsYN8MpEutk2vj3GUMxys8Fm8+AZCJ+NBbEk2Hi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.21,297,1763424000"; 
   d="scan'208";a="669589512"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 22:41:23 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.109.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id BD743180001CE;
	Tue, 17 Feb 2026 22:41:21 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	aeasi@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 5/5] scsi: fnic: Bump up version number
Date: Tue, 17 Feb 2026 14:39:43 -0800
Message-ID: <20260217223943.7938-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260217223943.7938-1-kartilak@cisco.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.109.174, [10.188.109.174]
X-Outbound-Node: rcdn-l-core-12.cisco.com

Bump up version number.

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index f1b6c7978231..8724d64f2525 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.2"
+#define DRV_VERSION		"1.8.0.3"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.1

