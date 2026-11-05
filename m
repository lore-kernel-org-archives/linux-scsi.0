Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793899380;
	b=quLJba671gKWcAq/gkTqPbXMfjUwaHKc4UgToQODXKw9mr6K8CUn5NueMO8PALuUug6q
	 inqJBIWqsqEdgMoglYNoaUYxVvRMFLkWnpkuJywW/ZJGpF3Dsy80w0jFv0eA9gl7tEMeX
	 qoAWAhBqZRe8JLURz/XcL6DHqjHk3Rsc+LohlltqB7wfA3Ws0Gr/xl82HVs8NBQ4wKJLI
	 HB6/K5lIRJykA9uoKmUUgo2J8aUj4OJfFRYhiBO5LiqizUZDlyaeOd5NIqnkVDMewIcpU
	 d/ziwhNbsXM8N6jg75t9P0u1fRkT+E+LOAac1ttQZ0KB4MThXPleYZ3Lhojg+7TwnEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899380;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=0x6v+LbVPu2PiMGORVyd0X7ouGF5QPmCs09YKADiePDG3p10lyEcn6Y46v/YoTUDlb7k
	 HQEz33RK3IPFGXbQylpwy+MDVPTK5lqImUn0mqYA18YHsBFbxDwQjG/Gw4Uz3Fyr0RFwW
	 0C9iwrcuWtZM56h1T8ufBp4jLchDKJWJyOCmaS3Xis7SJmDvr6ow1zykkzrtDd2LGItGs
	 mCSfVyAjPzU/ietLPblSfY8hXvCl4h1GOOXcVH1zMSn/XJ5KSWzxFlGhy7fTEUXx8x3Sp
	 bkDCzE+h2VYU68OBDYuwGlW5bXJWIwgqW1Ft/YdUnf50+PpNu3sYBm4//eVpgBlV/Qg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALTdeZ6f;
	arc=fail smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB9D606D807;
	Thu,  5 Nov 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALTdeZ6f
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899380;
	b=nKQpYCqHSW7yDVHF1ewf+t80bRJzkDMWqgXeFcMV4/W6oKeaf8H8z7UXjCRk8wRvuVSr
	 D1zSUdblc5a7/0pJ5wxbkTpIdJiZFM/YqveXtqRX3agrdljkqg/e5NDUT/mGsFTaprvLa
	 B/w1CiQoK22C0jzG+EufZZKx9Vh4yfcnOFFYR5VN0w1QgkUEQB6Ld5Gu9sov9yYzfO6pQ
	 1M+xDyVJ11f1eSBpTLMdjYae+/Dekf4WOWtjoj3Xuo2e+v8T10Vpuyh9J9OZcpG/Al8ku
	 A168Tt72giOsJCsZjwNm/nxZMtS12R8jAD/1zIcHZPefS7GcEKyuLvQDav0pfCzgmLQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899380;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=ABNwrL0kqNRQ9lh4f6tJDUGA5p4YpLIffeMW6/WgtnDyGu766lcxooF75vtMY7oVRzex
	 YhecQ0977QA6lHtMeiKeHxNc3zDzraTwIWxDEKGa0n2vHu6hZJ/WyyOiy7lg6OqrPC00+
	 haJJJI8FQ5vLoHZ5cZVb4OmheglbTqp2kbEFYQeT+L2dKshgUS7bJpEc7871/81IGpo+o
	 zG3Ol8N/K1MfzbvO3XumLKBNly14wNLnpCr6+ECupZDxUo/70k7muunn4+9qNY2yb6OcC
	 surloG04euqPIevJycI52d/VEGcqKnvxlzO9OJu+DncMYrel4yn11yAyQ5hBMo5swDw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C322F1F00919;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899380;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ALTdeZ6frgGXNc38GVMk0PrKA9oQ+7CUFBzd9SIz5VHgZHhxwpqjRvEFpSMjKC/gp
	 jf1WWLxdKLIaPbolVhNI/RS1OD92GGrHi7uiUXZM5CNp79dsfPMrXk+KV+43AlkL2r
	 JqVQ3MSrVU9+T9t1btbE17t3hFelU+565HN3hB7X7W7e/K/Epk9DoAp1eI/8E5fcbs
	 4OvhEBGQbS4YGpAyrjb1M77C7N56/jhxqpo2Dll1E8Dj2GqQALCoqbwZd04UXuRISK
	 vWtM4l9WiU5M5mHJhDgzx23IouTpiWaP4lnMht1O6FxKY+BjD4ev0ItcddFyFh+KVw
	 zurhI8xB2c8XQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 47C3547372;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 05 Nov 2026 11:22:55 -0600
Subject: [PATCH v18 02/13] scsi: ibmvfc: fix potential clobbering of rc
 after failed irq setup
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-ibmvfc-fpin-support-v18-2-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=nvE9rGLbRD6+mhvHw9wBWLEiRdGSv55IfTVTSl/45g0=;
 b=4y8qDzRzYG/kzx6Q8TlxM/H6fu1T6qWmkhTlblv0WhXXN+GyD3yt4/vaqwkqquHbbPfYY7sFu
 E/vFjQsIi6+AE3lKWOk4aIp64y489l0OCFM4R+PbX34/TpzdAcOBq8+
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Tyrel Datwyler <tyreld@linux.ibm.com>

Fix a variable-shadowing bug in ibmvfc_register_channel() where the
irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
clobbering the error code returned to the caller.

Introduce hcall_rc for the cleanup loop instead.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7818838669ae..145d559041f1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6391,6 +6391,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	struct vio_dev *vdev = to_vio_dev(dev);
 	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	int rc = -ENOMEM;
+	int hcall_rc;
 
 	ENTER;
 
@@ -6446,8 +6447,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;

-- 
2.56.0


