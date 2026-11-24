Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795543360;
	b=SYUg0DRyLHRe4dVmCmAPAcBQqjY7BNY/m4BqATEmuHyq5H8cPGuigh+hgDtMtOqiIE2W
	 3Fgu4k4DrDJhfC4rojE9MAgVVXeYT1sPd0f49pHBqEsrVwnId0BR+9cPs9pssexJVV6y/
	 KV1svxlarANpOWS/26bFENqa1EECGoY87XTnYzp1V1vdVrc0CXFPL9/ZnNMWYotwzWIbH
	 F/TtMfXaiJv3BtAaW5jPdHQIN5mxu3tUA7exHDnnWYm6aATnNz0x63/3mh2SjQ3mfk1r3
	 k12Q59yotxSAGMejyAS5xGeoY4Q+SX8YCDJwQ5cUcJa2YmzHi0C9nzpzZZ1MUkvdpgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795543360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zQkgUQWvgHuDLhp8zgHPxhn7fVYRY6fg/KKwqiExn3U=;
	b=wvkNttoMPlT+6UMEPdR6VuQLXuzQ0iXCnwVg6MKJHf+v9UrWUPN2+Hm5O5m7g6cjs/qR
	 VW6lZdag69Mm6htcByg3du4UJ8uIfrlbKymaGBdR7r4gO1Z8R0LHMiJ5r8+aD0g4JcbfF
	 nBWS20v377UldXuaQcURKyRW0/u/KF9ud4o64KvEmOI+/r9VuX/UZRjLgXoephxzwSLfG
	 qjnM6V9QQU3j2PDKIA6Cgt6WoKfDluNsYqMvV821hAKFjOG0XK2oCvtbVEoCW2srYQWRx
	 pH01FWHJXQJWR2ybPBpN1iMbPrYaj647Gv5NHUqH/mU1SJ6yqfgcHCJuIjH7bDO/Xlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="kxT/wa2m";
	arc=none smtp.remote-ip=209.85.210.45
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C108D606A329
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 18:02:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C108D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kxT/wa2m
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-847ac7ccd85so2773316a34.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 10:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795543359; x=1796148159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zQkgUQWvgHuDLhp8zgHPxhn7fVYRY6fg/KKwqiExn3U=;
        b=kxT/wa2mI5ypXdXzTiyqvREnUl3j2J6bmqGMGaiBZ70znPMyiS0zD00BWruxAwBCVW
         +2R1JiAl6gG9Y9yi2kEUZEEBIyG2s1WTzUAhQ8BllT+bLodxvbnK13O9mNVKOEuuMsLd
         iaCZ8SoUlALn+ghlbpOBdwYJ1cbidOo+Tdrl+l6SDW2Pm0wRRF4KKb2SB5vwe5ZYoPhg
         e2NJq6TBPgszeLWlddzfV3ZRhnPJ6wTQH9Tfj+VhrGMauSuhET6PXYPgubfprLrp/h4P
         UZfZLahhI1SqEQB3B/fBGeSvBJ9SnOa6LahihtQ5dnD15yWkFauIxty3GZmHBx/LQDp8
         5MFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795543359; x=1796148159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zQkgUQWvgHuDLhp8zgHPxhn7fVYRY6fg/KKwqiExn3U=;
        b=Nu7RXFAFpSl5xjx1C8PBgFH0H27ED2lowXlXo3O3JCAEjyKT+TYh8b9nviJsoHx3GV
         3PTpzbm02fCV6wQr849JLAN0C80ZsJXnLh98NlDBhAujry3m8tCZ+EpEYy76vG1Bh7hr
         6CJKSxkOwDyyttAkhRJNeHYJ7fyrtJA/n5Lmfc4TTGoDqJsw8zL2YalWX055BimQTRyh
         SHS4HyiABYOQ0xcopuaydacK2ObXjxU9Qm8Mh4H6+5rYNjVMF7cBXSqR/RDg8MTdOE38
         QjhcFOpEh41gEYql5xW03IJ+OPo3sBCfmdu6WPp0DBrxG51aq1D395t8xOzybijyHjjU
         gEVw==
X-Forwarded-Encrypted: i=1; AL+hErFNc3ocqA3uKJHsChgQ1sq2KBXRao4g5rBk/ltYuFi8v5BNjfkCIXlkkQiDKPlzkZsfB6/zlgG6jjgB@vger.kernel.org
X-Gm-Message-State: APuU4Z9PsiAdVyqZPfv7bO2XhhlhRa2H052RwXY0mkwUxf63aFLCY2st
	JCLalUtn84CVVyhHzTYQUR82bGq6O23dF/PZnZ4YNNr9K6Ef44MBGrC8xvPmug==
X-Gm-Gg: AZFdTZccjiE5wxHlDDSCPHdBX/EVwf5MzieARmM65hULYkal8Ex1ARHmnPIAZ5yaenK
	fn2zIGuHSlhG/n0yMxhF3B6cUYYTBEMVcFhV9nV7AxMdr2ZYenGr0ZeC8QoQzzi42xCAM3vlvEH
	yfZ+0+4wrgm0PaZawAih2n0mrNXXRHj8tBFiH7YlTjQxSe7AYXOUK5WCihmf+OWN0OVhVHsRVkt
	OnqQtHQcGvByYUbpsn/itnMS/V089kAyHv1B1ocQDRAd9LGYQ5kC4HY5IaALCjKcho5ebuGQGNu
	Q+5WDl0KbgH0q+KJeVz5Kewvh1xceKnza3f8y0M/SIV/EMJZl83LLETsRFUK1HORHF3fuMSmSjQ
	kccOv/7Cq6XTJunpl7+5DOl6yyYgKtpgf7IJlUYqiQ6dYMJNhWXyDp06SNQK5alGNJhM+2AbNVX
	JoCRPKf6b+W+LA1KqMHMk4sYwD5sru9Y4/2Zl7dm04T4+Eg/lb6FMQr0qn81pJlunIjFwvpTaDz
	O3mHzKT8LKVGJCCtZHn852Kn0oHU0ZWifSPhxs/wM6aBmSriIS3QDIF6JZsnvOiptEBDMRrEwZv
	QDZKvT5WTS1LVFbR26Cv0ApK04il/BB6CEJY26fqKj4f8TdgIdd8SkX1VjNcmNJOVZ37xTYupEV
	M4tLT7R7hfV/VEsJYDlJ0OXb6RxJfM2lMRdke3pWEIKtiRIYbF3ZDxcxeaKSkIOysQE0=
X-Received: by 2002:a05:6830:719f:b0:862:c685:84bf with SMTP id 46e09a7af769-863152f7117mr15179705a34.4.1795543358575;
        Tue, 24 Nov 2026 10:02:38 -0800 (PST)
Received: from tempest-testimage-cc-centos9-stream-server-1191361818 (chi-dyn-129-114-108-164.tacc.chameleoncloud.org. [129.114.108.164])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8631692d9f7sm11940806a34.24.2026.11.24.10.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 10:02:38 -0800 (PST)
From: Yuho Choi <oss.patchbox@gmail.com>
To: Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Narsimhulu Musini <nmusini@cisco.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <oss.patchbox@gmail.com>
Subject: [PATCH] scsi: snic: Disable the devcmd2 WQ before freeing its results ring
Date: Tue, 24 Nov 2026 18:02:31 +0000
Message-ID: <20261124180234.400564-2-oss.patchbox@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vnic_dev_deinit_devcmd2() frees the devcmd2 results ring before it
disables the devcmd2 WQ. The adapter writes the result of each devcmd2
command into that ring. When a command times out in _svnic_dev_cmd2(),
its descriptor stays posted on the WQ, and snic_remove() ignores the
error from svnic_dev_close(), so the adapter can still complete the
command and write its result after the ring has been freed.

Disable the WQ first, so that the adapter has acknowledged stopping the
queue before the results ring is freed.

Fixes: c8806b6c9e82 ("snic: driver for Cisco SCSI HBA")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
---
Compile-tested only (x86_64, SCSI_SNIC=m, W=1). I have no Cisco VIC
adapter, and the late write would come from the adapter, so I could not
reproduce it.

 drivers/scsi/snic/vnic_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c
index 22303f827583..44a2cc59821c 100644
--- a/drivers/scsi/snic/vnic_dev.c
+++ b/drivers/scsi/snic/vnic_dev.c
@@ -421,8 +421,8 @@ static void vnic_dev_deinit_devcmd2(struct vnic_dev *vdev)
 	vdev->devcmd2 = NULL;
 	vdev->devcmd_rtn = NULL;
 
-	svnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
 	svnic_wq_disable(&dc2c->wq);
+	svnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
 	svnic_wq_free(&dc2c->wq);
 	kfree(dc2c);
 }

base-commit: 8dac6df92a2e66e2098bbc69061964cfe7e8375b
-- 
2.56.1

