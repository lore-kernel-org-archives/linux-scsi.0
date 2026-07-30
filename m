Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D1A2D6E6C;
	Thu, 30 Jul 2026 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437544; cv=pass; b=rkpuam7+ZGLCvYlVUvtP/8GBZCEcVbHbksDJoXQzzI3oPqPmfuVAw/3WidoEe0iFfHKrr6HGy5UIoxc+qBRb+u75GmmnmgXBg8E/e3OyKHWtIvNubwDvvSgi9F3JT5TucE3lH50hrg6rcj/hR9dyRAUIRyNvt1O5p87wzmph+rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437544; c=relaxed/simple;
	bh=KfTvCFeyoH8ZpMacqlexoWalkZVCdM+husxlFpb5Bio=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B812KQG3SpJu4eubjSZHeZBDKzP7oRclhCHXb42qoC9SUXcA2VFyuQovdP2gojTX+gZrFXEJyTWB9d4GoLhOiKoY9idFSFMSrnaxiWrPY27NQtA1ViuD2HfQLi6J5Udh+kqn+2IX2kPPPsvbVkNoen1/MZerxhtvESK6gzGt4QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b=OY2/adTN; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b="OY2/adTN"
ARC-Seal: i=1; a=rsa-sha256; t=1785437363; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VwkuRCLGn4JoYcP/eXNsmW8n5GLPY1aEM27lHgk4on8pCmCudSsrgVWys944gO5yaW5B3CuKLQh0Ga5mnhTQBTU6QJektTipQSn4fdGX7UUvPgQmBPlZCjSavrIh2ZuGVA9pbJsCc8jw5f4eZ7kNm82G4uEaXk95ueZuyREXhJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1785437363; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id; 
	bh=WBi2dOJBNiM8vX6Ab5Q3yfRpu8YMYERM9mtRb50AB3w=; 
	b=exAyQL5qHhPFRDJfw8CVzxe3F5LZyKt0Pfnay/9obI0qFFzgs30zgdPmrWR9wn+NFD2jM9/pzfyqDXhaRtAmPvgMqYxDaiowFmpfMKq/7KnEwjcTxezALIsrC/ray1KwiRJFW0jH6jzukPS1/M1vAgVvjlIotewoE697GiMFtJM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=mhklkml@zohomail.com;
	dmarc=pass header.from=<mhklkml@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1785437363;
	s=zm2022; d=zohomail.com; i=mhklkml@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:Reply-To:Reply-To:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=WBi2dOJBNiM8vX6Ab5Q3yfRpu8YMYERM9mtRb50AB3w=;
	b=OY2/adTNZLserOR0+Q85pg3KW8dmqEulM+LtvtkYezvPnol+3WgYGoWOvUo3b15F
	bRSYfUp1aSUPyJTgdqDpmKFK27gmkmLsbncRINKoDK34ZUvyKODFo0iA8JiETw6tXNW
	ryZ2nigSVu67mSdcz9b/RQzMoODdWWjXsUURoL4o=
Received: by mx.zohomail.com with SMTPS id 1785437360554666.8373290285896;
	Thu, 30 Jul 2026 11:49:20 -0700 (PDT)
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
Subject: [PATCH 3/6] hv_netvsc: Remove GPADL teardown special case for old Hyper-V hosts
Date: Thu, 30 Jul 2026 11:48:43 -0700
Message-Id: <20260730184846.3165-4-mhklkml@zohomail.com>
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
Feedback-ID: zu080112274f702548114b3d9a6136176c0000b5befae3f3fa12c655b6e9591e7d8b72945cb6de96a13c5e1b:ZohoMail
X-Zoho-CM-AccountID: 0c88436b239415d28725328898ceccb9ce2ba3b61598c1c37bcb2109e0248174
X-ZohoMailClient: External

From: Michael Kelley <mhklinux@outlook.com>

With the overall removal of Linux support for running on Hyper-V
hosts earlier than WS2016 and Windows 10, the special case handling of
GPADL teardown is no longer necessary. Remove it.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 drivers/net/hyperv/netvsc.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 4d319c50955e..4295b96b4312 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -695,17 +695,8 @@ void netvsc_device_remove(struct hv_device *device)
 		= rtnl_dereference(net_device_ctx->nvdev);
 	int i;
 
-	/*
-	 * Revoke receive buffer. If host is pre-Win2016 then tear down
-	 * receive buffer GPADL. Do the same for send buffer.
-	 */
 	netvsc_revoke_recv_buf(device, net_device, ndev);
-	if (vmbus_proto_version < VERSION_WIN10)
-		netvsc_teardown_recv_gpadl(device, net_device, ndev);
-
 	netvsc_revoke_send_buf(device, net_device, ndev);
-	if (vmbus_proto_version < VERSION_WIN10)
-		netvsc_teardown_send_gpadl(device, net_device, ndev);
 
 	RCU_INIT_POINTER(net_device_ctx->nvdev, NULL);
 
@@ -733,14 +724,9 @@ void netvsc_device_remove(struct hv_device *device)
 	/* Now, we can close the channel safely */
 	vmbus_close(device->channel);
 
-	/*
-	 * If host is Win2016 or higher then we do the GPADL tear down
-	 * here after VMBus is closed.
-	*/
-	if (vmbus_proto_version >= VERSION_WIN10) {
-		netvsc_teardown_recv_gpadl(device, net_device, ndev);
-		netvsc_teardown_send_gpadl(device, net_device, ndev);
-	}
+	/* Must do the GPADL teardown after channel is closed */
+	netvsc_teardown_recv_gpadl(device, net_device, ndev);
+	netvsc_teardown_send_gpadl(device, net_device, ndev);
 
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
-- 
2.25.1

