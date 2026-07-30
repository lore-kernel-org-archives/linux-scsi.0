Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A939CCF9;
	Thu, 30 Jul 2026 18:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437500; cv=pass; b=MUonlEsrbkWT8wHhK6MlAJ/VyXjiC7loWsljuc0X+7ItQYFdpQgCcBSmcCPz/CUQYkkanr5kw+eko9YCEMqqvvBbIOE8JwOf9Hz0UPNlyWzB1LeKhOMT2DMHI/qS+31+tR5HHlI3KwWVTFgrtWSzC2GNsMUFtyY59Hlp7PQJ0R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437500; c=relaxed/simple;
	bh=DFaGJgUgHHjhUK0hKOSTR+kTtqKbmrpBrpRNIWiTuNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JU+qkpRvZAPFMe2MHrCeJOMPU0AbxrwF62Yy/z5UnXq0WgIrjuAU04b8bEqHUKp4qSKMaY/lnSN4zXVhv7OtAkjg8AfoXwqVtcDq0fjFZ0O9oP5LkSzeeJTMQw1Q8ElakdKqo1mAgi09Yj/oMcv0J9h56H2K4UDDL4SG9Gr0jPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b=KJwQembJ; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b="KJwQembJ"
ARC-Seal: i=1; a=rsa-sha256; t=1785437361; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RwAGvuSSUnsqrWeITf/RdjzxAxxGRiChsCS7+BXWRhL+C+1HLxNO8eVnxuKCr8DMj3m8DsTvu5sMO9RR+Ov1VTGYmD1ECCYAtjc0xQkXylGr138fjYCBWDX8PVdlMwVd+59Tg1QdN5gayvC/DyBSV951vqCUHjAJQepKKMj2Lak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1785437361; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id; 
	bh=zdqvRklY+BiCnU1uJQN3IGhN2teNLhSbHuYPEbDlmDg=; 
	b=j/6dHC+pAx04b4v1aG0BsLtlGxBk8F57Qgi2mlLMWKlXmlbPQOimar0pktQOVQNMQgmXfuvKvhKqetRh3hJzi6m/2bunjkh0keE4hbU5HIJ53WPF7n5OoFRn4dMkjQtIfaH1UEXa3ul7VvO2PABdtk7WJsdG9ODBA1oNhQcDsZA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=mhklkml@zohomail.com;
	dmarc=pass header.from=<mhklkml@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1785437361;
	s=zm2022; d=zohomail.com; i=mhklkml@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:Reply-To:Reply-To:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=zdqvRklY+BiCnU1uJQN3IGhN2teNLhSbHuYPEbDlmDg=;
	b=KJwQembJ36QlwZCSEzhShm7ywL0ew7r9zFhNQ/S4p60U3IdmYII5Pj2iSDbglB28
	vSC5dFGOVBolt4iIRBW6uHhkg6zxX5sOm0mu/axC+MOp0S0pbr/4qIsRVuXQRSKa2DQ
	LHkXJOgeEan0lQkXyKYWX6S6QE3K8JQqkVxir9tY=
Received: by mx.zohomail.com with SMTPS id 1785437357521542.225772617644;
	Thu, 30 Jul 2026 11:49:17 -0700 (PDT)
From: Michael Kelley <mhklkml@zohomail.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 2/6] hv_sock: Remove check for old Hyper-V hosts
Date: Thu, 30 Jul 2026 11:48:42 -0700
Message-Id: <20260730184846.3165-3-mhklkml@zohomail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730184846.3165-1-mhklkml@zohomail.com>
References: <20260730184846.3165-1-mhklkml@zohomail.com>
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: zu08011227e0a9231d155bf6f3b585e99000008800a95a67008c8c2b449e09fda758c9a83b5a2300b7445c14:ZohoMail
X-Zoho-CM-AccountID: 0c88436b239415d28725328898ceccb9ce2ba3b61598c1c37bcb2109e0248174
X-ZohoMailClient: External

From: Michael Kelley <mhklinux@outlook.com>

With the overall removal of Linux support for running on Hyper-V
hosts earlier than WS2016 and Windows 10, the check for such versions
during hv_sock initialization is no longer necessary. Remove the
check.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 net/vmw_vsock/hyperv_transport.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 5405c2680dec..855b15971c35 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -961,9 +961,6 @@ static int __init hvs_init(void)
 {
 	int ret;
 
-	if (vmbus_proto_version < VERSION_WIN10)
-		return -ENODEV;
-
 	ret = vmbus_driver_register(&hvs_drv);
 	if (ret != 0)
 		return ret;
-- 
2.25.1

