Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703173;
	b=fCFwDMj9v0AHuh8QGwxxaKmmSjDcrD5IRAF0xrREPUjNB9F30T8doZir7uHmj0YKeMQ9
	 i2eXMFOarJqe6ytfujuUNP/zi8pGPpndyPxf3ckucFTT6ydvoy2mRi/YMhG0E+2u0zjR0
	 opq+/IRXRdAEhtEdV18Y8Z/Xq6RWB68OJwEbB++wMUglrXOjQBawqK8qxZ8yGZQGoQh8D
	 cAP01a0MLvcYV/mb3sAh+lDr0gpwIZ22KEiia9oQM7lLeWs8TvaRLmhVsSEe4cPwmuxmL
	 RtLy+/0X0AsrdSpnen9DoPdQ6YhryceLgbAX3USdw76/op7iu981SG80wpqXfvhEjwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703173;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=jEbHViCewOt//5sCydb1e1mJRYmAXTqv2DOj5G7xWSI=;
	b=UoK0+LZWwnNSjMtZykbOI43mXEKg0UO1xOp5MrwBPU0Ahzxt2nzdCY3sfMNh/WStR7BK
	 rARSHyzttRy2kRDcpKPup3HYOxN8ECLlBLaEa5cmZjNd75HOX2XH/ymgGNQ60O01HFn2f
	 giIPqXFcCXEdRxxTUmlyqdMOlnpx9w4TVfWtulVHPayxKWcge4m4U/QnwdKIToJiRm+2W
	 7a52G1JVY2klOq8aO9g4d5rS4d4MpSBIkcRkEXsIcwLCMm1nNwA2r6+yVHAsfG/FFChFS
	 bC9W/rlmtczui7n7f+aXwpEagcm3uk9d/B+40XWOhF79HJd8D4Q7/OzuswSKb/D9r9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EFA606BA51;
	Tue,  3 Nov 2026 10:52:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96EFA606BA51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJllT4YyNz58fcB;
	Tue, 03 Nov 2026 18:52:37 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A3AqW4L050708;
	Tue, 3 Nov 2026 18:52:32 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 18:52:35 +0800 (CST)
X-Zmail-TransId: 2af96ae9bcf32a7-ada10
X-Mailer: Zmail v1.0
Message-ID: <20261103185235033sSfbRNdG9dGBNRQIy7br_@zte.com.cn>
In-Reply-To: <20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn>
References: 20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn
Date: Tue, 3 Nov 2026 18:52:35 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDEvMl0gc2NzaTogdWZzOiBjb3JlOiB1bnJlZ2lzdGVyIFJQTUIgZGV2aWNlcyBiZWZvcmUgdGhlaXIgcGFyZW50?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A3AqW4L050708
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 03 Nov 2026 18:52:37 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9BCF5.000/4jJllT4YyNz58fcB

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
