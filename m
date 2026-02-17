Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007C3C2D;
	Tue, 17 Feb 2026 22:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368137; cv=none; b=Nv9y1nJRYDhv4ppxa8fCgcx20mB0tuQvggGq01Lw82owSK8iU0RCMnJh0aRIVk+wmSYiaONdtSUd+w+RAU2TyR6MeqUxqWP7HdTFLUFTmFiaSr7PD/hlhuUHT5UGKp1sed1sB4l3JaAz3MgJm4h7C5XIxBRt+rAic69TJy2ItA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368137; c=relaxed/simple;
	bh=oQE+u/ggjLKC3JUUHxdKLQCi6qibW7b6c8jeivoBct8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPBC7hvVdL3a6FYHK8txkcA/9S2FTbSSTaFZItnHNcCJEaqjj0Fv0pWcFGbeuQWpgsq+eng9JujNDg99t/WxGGJyNibiihj6l0sLl1gCZPvTgS8AwTzrwcowGSNh3F/4ZJNXIvMaPSp4pbcN7HP1GzlxiIM2VRw7eLgc5OMkopY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=U0/wSO2K; arc=none smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="U0/wSO2K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1412; q=dns/txt;
  s=iport01; t=1771368136; x=1772577736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aQX5FTWT8CH8JrLAmS49XHDe8rEzPHZEZUTniOFKfNo=;
  b=U0/wSO2KqlCIDzzQaK+xAl+eup51JM/TYIMulkU2XTQjRVS2xOoUHIzO
   LeqkjK1xQZQDgtfMvHPVSIRCb+eoNiIeoo11HFYvF9jO+I+oHtFEUH/4r
   l8Z2IF8T4zHh23atUU5bNjDTtKP64S71T3XC/pcgfnuPlzrYNkZuumvoM
   QNy9Dfvu2tqA6Cb2pCx2eLkDDbwcNuho8VR3mda9s/Q93pjRIeRU+Plzs
   LEMJxJCDj35fRq5ufnViAPVeOF+o4bHsXgYcFHaPdmlWhueu33MzLDwcc
   jbU3PaCOX2SD942wupKcWlMG8sVbDPuaIEU7YwAO2ApgdaVqL8LM1hndV
   A==;
X-CSE-ConnectionGUID: o7j7fPHaTGWz/xVUNA8KpQ==
X-CSE-MsgGUID: Rz38eM00SU2+0unB2AitMw==
X-IPAS-Result: =?us-ascii?q?A0A8BgCL7ZRp/5X/Ja1aglmCSA+BT0MZMJQqmmCFXoF/D?=
 =?us-ascii?q?wEBAQ9RBAEBhQcCjR8CJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdAOteYF5M4EB3j6BZAELFAGBO?=
 =?us-ascii?q?I1VdIR6JxUGgUlEhH2BUoM+hXcEgzCKNIktSIEeA1ksAVUTDQoLBwWBZgM1E?=
 =?us-ascii?q?ioVMjwyHYEjPheBCxsHBYdzD4kFeG6BH4EMAwsYDUgRLDcUGwQ+bgeOOkGCM?=
 =?us-ascii?q?wGBDYIpF6YMoQ6EJqFYGjOqay6HZZBzqUGBaDyBWTMaCBsVgyJSGQ+OLRbEV?=
 =?us-ascii?q?iUyPAIHCwEBAwmTZwEB?=
IronPort-Data: A9a23:9Z0rTq5A7B9sMYoX0m7ncgxRtNrGchMFZxGqfqrLsTDasY5as4F+v
 mAeWmqHOa2JZmqkeNl2Yd6y9R9QsJaAn9I1Hgs9rCxhZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo+qUzBHf/g2QqajhNtPrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eOtIapehPIWhy2
 sMKbyAzUzaq18Gu+efuIgVsrpxLwMjDJogTvDRkiDreF/tjGMqFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkEeUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGISLJY3QGpsMxS50o
 Er87T+pDzRCbOeik3nd73SG3MbOgQbkDdd6+LqQs6QCbEeo7mwaEhA+Vlahp/S9zEmkVLp3J
 0USvCEnt7A/8lCmVPH5XhuxunnCuQQTM/JSHu8wwAWMzLfEpQeTAy4PSTspQNkvrtM3Q3oy2
 0OEhcjkAxRoqrSeTX/b/bCRxRuwPCUTIGACZAceQAcF6sWlq4Y25jrVQ8huCrWdlND5GTjsh
 TuNqUAWg7QVkN5O1Kih+13Dqyyjq4KPTQMv4AjTGGW/4WtRYI+jepzt8lPA7N5eI4uDCFqMp
 n4Jn46Z9u9mMH2WvDaGTONIGPSi4OyIdWSGx1VuBJImsT+q/hZPYLxt3d23H28xWu5sRNMjS
 Ba7Vd95jHOLAEaXUA==
IronPort-HdrOrdr: A9a23:28KkZ6m1DwGUbLxIzcE0CX4P2STpDfID3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV0mlhD0Jczpy1SZNNW97OaY=
X-Talos-CUID: =?us-ascii?q?9a23=3AiI0Nj2iWl4o4m2CpRWnZZKKExTJudSLfk3noA0a?=
 =?us-ascii?q?EJll7D62rdHm5qIB8qp87?=
X-Talos-MUID: 9a23:iDox/gluOqxHlbAWsM04dnpYJpw47oH2UHswy9Zeps+ubwVxJxKC2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.21,297,1763424000"; 
   d="scan'208";a="667927613"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 22:41:08 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.109.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id 9ED431800030C;
	Tue, 17 Feb 2026 22:41:06 +0000 (GMT)
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
Subject: [PATCH 4/5] scsi: fnic: Refactor in_remove flag and call to fnic_fcpio_reset()
Date: Tue, 17 Feb 2026 14:39:42 -0800
Message-ID: <20260217223943.7938-4-kartilak@cisco.com>
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

Modify logic to remove unnecessary acquire/release of spinlock
to set in_remove flag. There's also no need to check for init status
to call fnic_fcpio_reset.

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 05b203b9b69b..7e41bb8a7628 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1972,14 +1972,11 @@ void fnic_scsi_unload(struct fnic *fnic)
 	 */
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->iport.state = FNIC_IPORT_STATE_LINK_WAIT;
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	if (fdls_get_state(&fnic->iport.fabric) != FDLS_STATE_INIT)
-		fnic_fcpio_reset(fnic);
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->in_remove = 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
+	fnic_fcpio_reset(fnic);
+
 	fnic_flush_tport_event_list(fnic);
 	fnic_delete_fcp_tports(fnic);
 }
-- 
2.47.1

