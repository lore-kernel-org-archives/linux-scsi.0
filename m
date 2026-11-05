Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878421;
	b=NmX4Jtu/BmQG+6HZAUqiQpfKVssCJlnAmmBrfnEbFSWs2Sj+4PVC4JJgDYW30+xLoybb
	 63JRnNBBnNlwc84SeY+PUhBcWnSc4+xvpEiM9fze0CDLO4P2VTtX06THzO1wGNFYO4sik
	 iOs+sNsuJW63PCkIq9iy7acktNx21PhYeL1eAtbCnE3h2Wwawcpi43tVwBMMcgiy+F8Ep
	 ijxKK4ibQmO077zcEDmWEttqX9lEu15ziEvYOxE++7rPVK71X6umNILc28SR/N5WLro4J
	 ZGY6uOdoSoRcOLv3zwWpqFKTsw8/+NVLxQ8bcv0VBnR0KMHBCsQqOf/8mr42jdqt1NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878421;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=bzQ/4W4SgD4uhiCWQ4jBEpI0TFVsXO9Qa32Fu02lix4=;
	b=q3n080GFHFappjdKhdvSxgQ3BQP9Xp6Rx1iH6yUTR5t7baAZYhDZgSzj96NTUl6ysbOH
	 1K+vVXCgTwv/i5YTHJy/4DsG+FOyzuNcHyRB8R2a6EuIAy0wLCnDkGWf+WkqOxiR6Yf4U
	 UejXAyQAGyVLATSxo4i2XMaBvbqrzIwMLBX0RFs+d5ncq5ben0hBLl+iWNomiVxxQzpah
	 f1bfXspVNHpdHF9pxonPslTRpkjCKZmdqN3ykXNHkDjs77Ber31fU89th3FTNpCqVz7LX
	 Hpe9rMvHhE6aZFem+FL5JmbuIxHvvZGs+PNZATOOgAvZjJAoRdRL0W7mCMT1Am2HUWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E83606A330;
	Thu,  5 Nov 2026 11:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9E83606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jL0Yv3D6Bz5BNS0;
	Thu, 05 Nov 2026 19:33:39 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXWTK068128;
	Thu, 5 Nov 2026 19:33:32 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:35 +0800 (CST)
X-Zmail-TransId: 2afb6aec698fa8b-1529c
X-Mailer: Zmail v1.0
Message-ID: <202611051933353749X0R8jRBz5_ukO3ZdKD6t@zte.com.cn>
In-Reply-To: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
References: 20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:35 +0800 (CST)
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
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <loberman@redhat.com>, <jmeneghi@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDIvNV0gc2NzaTogY29yZTogZHJvcCB0aGUgZGVhZCBWUEQgc2l6ZSBjaGVjaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXWTK068128
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:39 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC6993.000/4jL0Yv3D6Bz5BNS0

From: Shao Mingyin <shao.mingyin@zte.com.cn>

scsi_vpd_inquiry() returns result + 4 where result is the page length
and is non-zero (otherwise it returns -EIO), so the returned value is at
least 5 bytes and the "result < SCSI_VPD_HEADER_SIZE" branch can never be
taken.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 05232ab6366f..fe4d748cab1a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -378,13 +378,6 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 	if (result < 0)
 		return 0;
 
-	if (result < SCSI_VPD_HEADER_SIZE) {
-		dev_warn_once(&sdev->sdev_gendev,
-			      "%s: short VPD page 0x%02x length: %d bytes\n",
-			      __func__, page, result);
-		return 0;
-	}
-
 	return result;
 }
