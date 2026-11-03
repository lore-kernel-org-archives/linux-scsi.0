Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703237;
	b=b3QXDJvbMR3tAW8FZ5OMv8yrjLx68klwHyD3fShdORK2UHSARaI2Azm3Ljt2pt8rIEt+
	 w0YuJgkytnfrR9TV32d4LBu1dXOqWACZzXfCRRSohj3z4sb4taxRTBDK0pCyLaADEJyL7
	 1vwr+iWaxe9cdX7NSJys6f2ZQ2hPVV7zbmSVvVRhWykNplh3yWdiVa211/NJjOGik68BH
	 8NHPW/utIbgRWRys+NhIYNSvUoNnEA8Vq1mYBlfAUaXqgZfCLZ711RtqtU7gpKmeNgWO0
	 wa9nsYDLZ5XoVCBX0MgRhU0cWcb8Y9oIDU3KMFrKXL4Xy/NNKx1p89+B8z8otD/bNbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703237;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=U+ORXMqaOXg6t6xSZ+rypV+aRvjTEzPE/DKzgfW4tEg=;
	b=45/hDru5cYlTJshiyTbMs2zCzeBuQR/ewGAmVaIxTQ8rOfOdn0cZNBNKK72XthJf5gNL
	 EnS5iKifFt80BsEym5ZNeU2nVzx/SdT+5Tb3B5vao+jfrNrfFXId4Kcjl6ZRnY3dX7CKp
	 rG2C3At98fYzsDgDz6bu6igqkmRYrDhoQpxpXyavCEfRq4iNXkv1/lP++3FELg0PYDwWa
	 dQ7qqK2U0l1OHOUin+sD4fLhcX726KT0IhsUVnRoEjFevkWMQehoQFLWhGFwSLYrf2luX
	 WBMBtIv/GZP7AIvGndbAcmQPjkA15RTIiVoTukVfoV8si+qAgby9ONdIDBlso6w7Kgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29776078F39;
	Tue,  3 Nov 2026 10:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E29776078F39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJlmv1RJbz57HS8;
	Tue, 03 Nov 2026 18:53:51 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6A3Arkxm088466;
	Tue, 3 Nov 2026 18:53:46 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 18:53:49 +0800 (CST)
X-Zmail-TransId: 2af96ae9bd3de97-af5ff
X-Mailer: Zmail v1.0
Message-ID: <2026110318534911091Mvzh5diLU9SKNWyne2p@zte.com.cn>
Date: Tue, 3 Nov 2026 18:53:49 +0800 (CST)
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
To: <mkp@kernel.org>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiBjb3JlOiByZWplY3Qgc2hvcnQgUkVQT1JUIExVTlMgcmVzcG9uc2Vz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3Arkxm088466
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 18:53:51 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9BD3F.000/4jJlmv1RJbz57HS8

scsi_report_lun_scan() allocates the REPORT LUNS buffer with kmalloc()
and does not ask scsi_execute_cmd() for the residual count.  A device that
completes the command successfully after transferring fewer than the eight
bytes of the LUN list header leaves the header uninitialized; the bogus
length read from it can trigger a multi-gigabyte kmalloc() retry or probe
LUNs that do not exist.

Request the residual and abort the scan when the header was not
transferred.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 52f3b525d2fd..abbcf529bdc4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1475,10 +1475,11 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 		.total_allowed = 3,
 		.failure_definitions = failure_defs,
 	};
+	int ret = 0, resid = 0;
 	const struct scsi_exec_args exec_args = {
+		.resid = &resid,
 		.failures = &failures,
 	};
-	int ret = 0;
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1567,6 +1568,12 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 		goto out_err;
 	}
 
+	if (resid > length - sizeof(struct scsi_lun)) {
+		/* Short transfer: the LUN list header was not filled in. */
+		ret = 1;
+		goto out_err;
+	}
+
 	/*
 	 * Get the length from the first four bytes of lun_data.
 	 */
