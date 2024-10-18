Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B90126C18;
	Fri, 18 Oct 2024 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268753; cv=none; b=mVzWJc2oerJTRw1FkWCacJsTZPUIJaJ8eqTBzLiW/aHX9X4KpJYTmtJF7C6Bw8iVsTLmk+eivxyjz6z0JCbjWET+HATPdHkFDACvLpVAhRlxh7cGFeixrovk7DTBZHLpb2NxPruLjA2xy0F+5z9K2Wgl9x5wKl1BjnatHqsgbpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268753; c=relaxed/simple;
	bh=5qfWodULDLVsekB+OCOLWzJk/ZdiqaiLkSFAzUFicmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLbXSBRtjNNyWJtZxY9AaqmiuhGLbwrYfDGTOSq7ZE7cn3VWhNHCe+ky8TLOhx7VcrVJPkruWfejhGAqK6Lx6HBOUObo3d/nh2rfTG+kNABOIZUXUW/lBLetVHN31zxy4qBXAiMGsq83KmpzuZG7r/J2YBZEFqnUDKpjrgVvhqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Trj+2q26; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Trj+2q26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1729268751; x=1730478351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+NDOGTVmsXxT1gPQhPkHFEQFR9jHtVt7H8Q2NXM1ZE=;
  b=Trj+2q261jRajJKGsfsafc/6vv3fXsmZSJjQ7I+t40PIE/AipyeCTYNR
   sTM1YMaNZb/HvhliSbiJF35vlh5Xr2MgVzpkEDHQyCVew339TrI9wB3O+
   x8/6i8xe3aA4OJNnEf9mSazeFsEQKbC/11aFdZCq3oXXjdi4LKD4nfPmB
   4=;
X-CSE-ConnectionGUID: HXTZ3BxvSbWRhvDhDLj2Xw==
X-CSE-MsgGUID: bA9fgGr/SvG5APkkZdkAtg==
X-IPAS-Result: =?us-ascii?q?A0A5AAAoixJn/5D/Ja1aHQEBAQEJARIBBQUBgXsIAQsBg?=
 =?us-ascii?q?kqBT0MZL4xyp2iBJQNWDwEBAQ9EBAEBhQcCiiMCJjQJDgECBAEBAQEDAgMBA?=
 =?us-ascii?q?QEBAQEBAQENAQEFAQEBAgEHBYEOE4YIhlsCAQMyAUYQUVYZgwGCZQOwB4Isg?=
 =?us-ascii?q?QHeM4FsgUgBjUVwhHcnFQaBSUSEfYFSgjiBBoV3BJ1vJYk9kUBIgSEDWSECE?=
 =?us-ascii?q?QFVEw0KCwkFiTWDJimBa4EIgwiFJYFnCWGIR4EHLYERgR86ggOBNkqFN0c/g?=
 =?us-ascii?q?k9qTjcCDQI3giSBAIJRhVI2QAMLGA1IESw1FBsGPm4HrFJGgl2BDoJApVegf?=
 =?us-ascii?q?oQkoT8aM6pMmHekOoRmgWc8gVkzGggbFYMiUhkP2WcmMjsCBwsBAQMJjCaBf?=
 =?us-ascii?q?QEB?=
IronPort-Data: A9a23:w73KdazP206v4FjwNul6t+cmxyrEfRIJ4+MujC+fZmUNrF6WrkVTy
 GMfWmCCOKqIZ2Sme9klbYW09UNSvZfSnNEwGwU9qlhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlpCCKa/FH1a+iJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 IqaT/H3Ygf/h2csazJMtspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJGEGAb9D0PZpOmtxz
 /wGBDAhShLZt/3jldpXSsE07igiBNPgMIVavjRryivUSK55B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cP3WjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC3b4eJIozbHJ09ckCwr
 EuX8WvWGFYhKvPC4AKG8UCghcbTknauMG4VPPjinhJwu3WRy24ZIBkXU0ar5/izjwi1XNc3A
 0kd4DYvq+4q+VCmVMLwWTW/unePuhNaUN1Ve8U+6QeQ2u/X7hyfC2wsUDFMcpoludUwSDhs0
 UWG9/vtBDpyoPiOQmmc3qmboCn0OiUPK2IGIygeQmM4D8LLuoo/iFfLC91kCqPw1oKzEjDry
 DfMpy8771kOsfM2O2yA1Qivq1qRSlLhFGbZOi2/srqZ0z5E
IronPort-HdrOrdr: A9a23:34HVEKlRFigXH5Dk7Qsl8n+/9UXpDfID3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV0mlhD0Jczpy1SZNNW97OaY=
X-Talos-CUID: 9a23:UvjkSmOzVsngSe5DeBlbxhU+Ct4eeELnzGn8I2OcCzxZV+jA
X-Talos-MUID: =?us-ascii?q?9a23=3AH8RdfAzmud6hPGI7J8/CNytFPpuaqK6HWU4Cvo9?=
 =?us-ascii?q?BgNeraAVIODSvgDeeXoByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,214,1725321600"; 
   d="scan'208";a="275408910"
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Oct 2024 16:24:44 +0000
Received: from fedora.cisco.com (unknown [10.24.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPSA id A8CE118000229;
	Fri, 18 Oct 2024 16:24:41 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v5 14/14] scsi: fnic: Increment driver version
Date: Fri, 18 Oct 2024 09:14:09 -0700
Message-ID: <20241018161409.4442-15-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241018161409.4442-1-kartilak@cisco.com>
References: <20241018161409.4442-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.40.136, [10.24.40.136]
X-Outbound-Node: rcdn-l-core-07.cisco.com

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

