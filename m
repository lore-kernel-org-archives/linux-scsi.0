Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732375;
	b=AaGo2G3A4viWIobvJAobSEbFymyMRXyPyOr6B7qyZOQH7fN/nJsPYJd9TPhWC91WUUQB
	 HEBmTbRVTn4G2sqrmTXlZHfVUTnHpZXlrXQaG8svV80QUYxRHNEp6mSdshq1SeUndNsfT
	 kyoyxvtdnZjyeNkSJL9/VLXBOn/aFXrNVfzFfvSK0XhqlJIwaFBzCk2AATMamniwAWCFs
	 8jml1AZC20qacqF0vE7CQB871UPNy6rvocvy1qX8qJILwk8D+MewUb+W8bh7fjeIIDuFA
	 uF4t6fF/0mDWdKZh+v2TzGU3xJxXComWhirZ+V2XCMFfesuSOt975McQxpOS5t9xOkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732375;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=o78jKYuZGfQgN8B8bpOjv64+HE07JQuSIZVVEgvqlvg=;
	b=yJqcBCZsO9ix9fM0NtagxYsjMf8E1GhpPtn5muDOFv9zkOqspl+bQSPRudR9CnhrH5A+
	 2p6Ak4+kZE0X/kKgp3jxIXDvM8F5CGKGsdYYUr0mLS+OVl9AEHOGbo7gpOLdyzoFKj5rF
	 KM0TEsfU+6j5lT3GSQpfqTc+jJJpW/PxvyMNXQmv197MQQJN+8S5uvE0GGHJ7mD60KzyC
	 tLAwPwqeAXKMIwOwmkvVYbnfrCWFsPxlLtv0+o7Cnmr2dhoefoZeqizVfnrZo+KAQf5OP
	 lzZyccFdKLmNqFCw1PWZ+Nr0QM9i8VbqaYzyuTvhHtQ2O7n10CexJ+MZwzI/q+4NMJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDFF606A33F;
	Tue,  3 Nov 2026 18:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEDFF606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJyYJ2MmWz5BNS0;
	Wed, 04 Nov 2026 02:59:32 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6A3IxPua077206;
	Wed, 4 Nov 2026 02:59:26 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 4 Nov 2026 02:59:30 +0800 (CST)
X-Zmail-TransId: 2afb6aea2f12bc8-d310e
X-Mailer: Zmail v1.0
Message-ID: <20261104025930358oLNtuTSPBX9Wqd6hMaegb@zte.com.cn>
In-Reply-To: <202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn>
References: 202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn
Date: Wed, 4 Nov 2026 02:59:30 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Cc: <james.bottomley@hansenpartnership.com>, <peter.griffin@linaro.org>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvMl0gc2NzaTogdWZzOiBjb3JlOiB1bnJlZ2lzdGVyIFJQTUIgZGV2aWNlcyBiZWZvcmUgdGhlaXIgcGFyZW50?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3IxPua077206
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Nov 2026 02:59:32 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA2F14.000/4jJyYJ2MmWz5BNS0

ufs_rpmb_probe() registers a child device whose parent is the UFS RPMB
device and then registers an rpmb_dev on top of it.  device_add() takes a
reference on the parent, and rpmb_dev_unregister() is only called from
ufs_rpmb_device_release(), i.e. when the parent's reference count drops to
zero.  ufs_rpmb_remove() and the probe error path call
device_unregister(&ufs_rpmb->dev) directly, which leaves the reference
held by the rpmb_dev and the release callback never runs: the RPMB child
stays registered while the devm-allocated ufs_rpmb is freed together with
the host.

Unregister the rpmb_dev first, as mmc_blk_remove_rpmb_part() does, and let
the release callback tolerate an already unregistered device.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
v2: rebased onto v7.4-rc1 (for-next); no code changes.

 drivers/ufs/core/ufs-rpmb.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 65f2d71cf073..1ed57d50c3ff 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -149,11 +149,19 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 	return ret;
 }
 
+static void ufs_rpmb_unregister_device(struct ufs_rpmb_dev *ufs_rpmb)
+{
+	rpmb_dev_unregister(ufs_rpmb->rdev);
+	ufs_rpmb->rdev = NULL;
+	device_unregister(&ufs_rpmb->dev);
+}
+
 static void ufs_rpmb_device_release(struct device *dev)
 {
 	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
 
-	rpmb_dev_unregister(ufs_rpmb->rdev);
+	if (ufs_rpmb->rdev)
+		rpmb_dev_unregister(ufs_rpmb->rdev);
 }
 
 /* UFS RPMB device registration */
@@ -250,7 +258,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 	kfree(cid);
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
 		list_del(&it->node);
-		device_unregister(&it->dev);
+		ufs_rpmb_unregister_device(it);
 	}
 
 	return ret;
@@ -270,7 +278,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 		/* Remove from list first */
 		list_del(&ufs_rpmb->node);
 		/* Unregister device */
-		device_unregister(&ufs_rpmb->dev);
+		ufs_rpmb_unregister_device(ufs_rpmb);
 	}
 
 	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
