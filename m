Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427906;
	b=D/zX9HrFwf5S00I5gV4yC+hlVCCH85HW0vbe8ezVGo+Som+HXBmTUDf6VDylY8HWixgy
	 Tf6PzroO4ssh+/rs8TzHEaOdR0RDDuTwnwcIx+Q1L3tOIBxym4iJB0AFIwaBS+++Vv+iX
	 F2ogezx1nR07cHZQDWdKEWEpJvH4Goz+kxDegdyCK9KKLkO9LGOr6rKONYYw2+loQPROV
	 8IOqUZsOITYtGw2Fenf9ualatdHOnikYpdPPr9HXRx5ePG/pClWrRII3KgLmf7mGN8ADS
	 iI3fZ5AHWeubiFDXVeYpaOFqV+UGdm+mAMjFTHG2GTWgZoqAZ6UeAcIfYX2DiULEAGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427906;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FigEJHOTXcmrN6GdEEhScAmCCjRdv5trAdW++5AKErs=;
	b=o8UGmQx9NAMmc58WAY96QVpq7dc67JpyavygB3Xpr/zUWflW97xGTC/Qj2El3Wmw1pV3
	 o+uthjhbAUe0shfFS1ZVP6c427VFISGB9hK5G8z8xpI3tRYSs1jN6Z+sxfSz7oi0gh6XU
	 LjRLioEHze/YtVaWZdn0J8JYHpWaWsKjhEiwzukUHEF4RHc1ToQpm96TV/ZVq3hril7+4
	 2axlSN+7P0LFy2FSex9ET1w/cLXVas10KNMvSFKf7o0vLsxuXz1ca/fNoxFNyU3gZZovP
	 8Duoj1KdHlQpswecOAvGJ5Rm4Ylh8KWBiA7lJLY8fwelmfDTCxfp5Q1GwQXrZpyUhzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=r+xBEuMw;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C1A606A31F
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 16:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2C1A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=r+xBEuMw
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a16af2a232so17042055e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 09:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792427904; x=1793032704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FigEJHOTXcmrN6GdEEhScAmCCjRdv5trAdW++5AKErs=;
        b=r+xBEuMw1pPbynNijN2smEhoLWsXKecTVaNh1oCzXiNQPK31mbEXywlrqLExpUGzzX
         vuDJgYx5eLBvFXmi9TTFT39sDvbMK6I+b7h7E6xbi5MBNZ129r4EwBQ6Yx1AHaIpekai
         Wrx8Z7CzRKUX9ZOz/O6LPeylEMqUQF06rRW6YDoOEaGV16DYRoFKQi/qWdsLHrTi6Y2r
         uJMtC39Jj/yTesn5Nc3i4jT9Y1YHsYHjZQMJ7v5CtGzH5HcH5GV2qxRxCur9WhzMTRSl
         kj5CXRlxBiNU9W/nGvnGxT6+WnaE+TqrxXIwvYzZCAv5bdwEXi7fjtU6Hu8qc93C2y54
         +2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792427904; x=1793032704;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FigEJHOTXcmrN6GdEEhScAmCCjRdv5trAdW++5AKErs=;
        b=b1uYc7nIFCpRu1fHOLlhyOj4nDIQzM6nzB0nYEGDd0e5+CEzL0U8RnBB2Br91Pb/q9
         BkbhaiajzJx50LUJwKhZ0SLXL+K/N667W2wKSogeukeyYGEphzBoffG8BIW/sEYTJw+/
         5Hr5MIDLcdnh1tL/Mz17r84VXQUGgVrGQhQbkncbV6R8t2YowXKLuOGyiSOBgeNB6G49
         rr5jO6jFAVs69hMkXm/UnGkx4kfYon9H9Erb2FJMDA3msrzuNi/JF48WV6B5Gj3M43JV
         TlRXnFvjCJZHgOZh3pjlKAMlltVZSKTeB7CPa8X5OHXOzwKnzFdEItbB32n8JDrCVqIH
         uVsw==
X-Forwarded-Encrypted: i=1; AKwUvBzAtnZfIE7KzsuN774dcPcs1fxoeO2a+lfO/Muz7DbGZ+vrdvRvB3+ybH45BXC1ORJKKwG92mjERasD@vger.kernel.org
X-Gm-Message-State: AFq9FYL/6N+gaKjP1hTvYRf7pWB5jk5dmZoPaV+gPEFXcR6u5KrM1bW2
	Xtpcaq4bZF/mMQTujCwCo+Tus7oqkXok9g8qKBS9S/tJYZNC/ORXKV8=
X-Gm-Gg: AYBFou2ZLTdqgnxSeoKFCZhIXXPQ7R4uycF4jyYdtMCLSWtrIXtukIwb5UUKO/UovFf
	YFJz+oODl/rkk6MGZFJbaQ52toKXdWxEC+L38LtHc+anr7Gsqo4dxmh1TznO29p0XNx1gO17fKY
	1rxS70D4WFjdaVPb8jt6e6lSHyqdCtlCN/jh+/tBFUe6/KmiG74PHqUOKzLxeP1lrbFVKP/6f2F
	Eya1jvtrSFz6kybhYDJqiVTLGov9VmJS0FADCa4ndeEJv1o3RMjXpn2X0RFvExh4sNAp9sDgoKa
	56G3Vfb8Etmff9yEUGZIoaeFcU81jxxM4i7p0wLnRU+raO0EsAt/nJKm7cNxAWrYgTR5I5YKBKy
	MYJYg6HwK0rGIyyqVrqHtV9Ww+KHl+Y9WJ68qqy79YL+yNGV1CxJZQO9eGp1evkDyAYLPPd/QBM
	f2lH44npEvbS37uK5tt+V6yYU8xsv5njbEbPGqCJE=
X-Received: by 2002:a05:600c:8709:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4a1d75e6f32mr170196745e9.5.1792427903791;
        Mon, 19 Oct 2026 09:38:23 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d32412sm3752065e9.7.2026.10.19.09.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:38:22 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH] scsi: ppa: cancel delayed work before freeing on detach
Date: Mon, 19 Oct 2026 16:38:21 +0000
Message-ID: <20261019163821.659714-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
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

From: Tristan Madani <tristan@talencesecurity.com>

ppa_detach() frees the ppa_struct without cancelling the pending
delayed work ppa_tq. If ppa_interrupt() is still scheduled or running
when the struct is freed, the work function accesses freed memory via
container_of().

Add cancel_delayed_work_sync() before teardown, matching the pattern
in the sibling imm driver.

Fixes: c4028958b6eca ("WorkStruct: make allyesconfig")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/scsi/ppa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 8a4e910d5758f..7f4b2a4157725 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -1136,6 +1136,7 @@ static void ppa_detach(struct parport *pb)
 	ppa_struct *dev;
 	list_for_each_entry(dev, &ppa_hosts, list) {
 		if (dev->dev->port == pb) {
+			cancel_delayed_work_sync(&dev->ppa_tq);
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
 			scsi_host_put(dev->host);
-- 
2.47.3

