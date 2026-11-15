Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745328;
	b=ujAmE75v0R9xAKIj33iUsQM505PTRWBMTmjQLjTJZrwdEPZGC+n6pJ+2GBhBJorUgODd
	 8V6xasnCdqgM/bSynm3mtAu0FO9vygQKmz7tLukqyB4E+y0Qqalt7+a4pkJ/zkWsEUMK2
	 y5C84x92HLyIG33iyWHxrSUxGS5v7Bl4xeVrFW7nyYn7sD3+L/Du5BO7PesqUHlw51doc
	 EdofrBbJuq3A0Pb/gG41Xg9yQCDYFzvqRiW3Z1oj5LroGNFBpxsNXVjYa3i4Wz6AgbTN0
	 lKKKA83gAQlgyp3GX+eOtVxPQ7eUHC0HGa1Cl0nybfLdWv7FD4BnwphIqwZ8GfY0Rfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745328;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=V+iHTxqWLAe/kGlFuuYa1byGYNwjkpUiH9I6TQaXj6U=;
	b=c+5Zu/j6YlgFbhu4JYcJoar79ZNR36zClv6MntD016WjFIgQshGo/vrrPvWdOExAsVZw
	 +CjtcoYA6hqwG3dGujye9ec6nuV2jJE8SE8yTRm00yg97heizyN4bhcWjMOQ+u8ZFrMS3
	 /RgdStm2rxBCQegfLe0mLUep2raCbW0oHrUn4bOIA28cpvpJcqSG4kK04pUdg7gR9V26Q
	 HYGK7RO7MI8ztj2ZgBfYdZZqhMUSPMtHFPi272v6oHRFUSGO1x1ugle2kH4ZIdSuRxOoc
	 yEXYkbsIKoHp71plsBKr/LIFiY4TI203e/dAycbT1bx4sRCJxq2T6/KOoYvQTIgdTfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LGNmQr0G;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42989606A31E
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42989606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LGNmQr0G
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b58d6f67a5so1207548b3a.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745326; x=1795350126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V+iHTxqWLAe/kGlFuuYa1byGYNwjkpUiH9I6TQaXj6U=;
        b=LGNmQr0GVfYIB04gnbPzEbs1s0P/x1X/0+F9jbFrB/ihtSkIGG+dzxjeuH3xVE12xo
         3UHtCVrysKRyflQxL/GueDCUA4Ng7r+N1ZjTUvf2IyvB+9hgJgeoa1ucfXb0YjLKMrR4
         Q1LOXqFs05bQs0oyzAbw4Sjx7d1WBMTydz2ZFQxOlCviJDPJM7DKae7wQf+DQSGn5Bmx
         /hvMl/v+Wq0TgXgdM7Fc9nyjtejw8ysqzlKiDLznhxdZFDTkLJZavFvjNsU7HJASaexX
         QQkk99HNs/m+/JsygaA9AIc512huNwNR/faj8QP/n497Nh0AFUKR8kQ3xkaBFmYIm3LS
         kn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745326; x=1795350126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V+iHTxqWLAe/kGlFuuYa1byGYNwjkpUiH9I6TQaXj6U=;
        b=DSKOGTUxRpq5ejAxMHQiOdMA/mtjZO0xaU+PV+n/ioVyzWYvy9ds/xKQp+pPOQbwS0
         r06sawg5aWWDn8BBvW+i9KGbODU/cdysrdBLcITgx7q+Dfk099V2Qo5dL2Ksm0K/v8Qj
         sZoS5GVW7Yots57EAoQ2qHhKIy9JWX8zWlZmgmeLRmoblQdtX8nK1aPT/504AVZybGt/
         Q3PPSuFGsp5mg6CwAxTFF9lVQnjI2aPPtkK1sStaQz41ICtJLin1dVqysvB9vp9mhQ1p
         aWc5j1T51YRdVDY6j241Qv4lnVjmQBm12nG+B0Cxt+ofQMPBIkjFLG+BLpk2LjY3FSrL
         sdrA==
X-Gm-Message-State: APuU4Z9XivPBP5nq9s3pffKdgRFhI/DZdebrBJWKDtHslpUn1WL0sfsp
	llIpei4fHwJsuH+JcXFzLs057cDWNO1E03oV96K0AfKDeruDss6BLPK1PWZdDTqH63Y=
X-Gm-Gg: AYBFou1f84lY+Im5HMw/TxfJbJf7PzGgxtwDkAGcL2vLvVyOqtmiGDFDUpy2Cd5aO3w
	J5EKcxae75t3VhNVpPMQ64+CzHCX27tZRCzvgdXIDBZndM++4+GFlEyqRwCkkKNpcnROLXg/j/G
	tScmDfytiMhmz6FusiJ3rmAiWKq6ICIXgm5PouaMWtgYNp9j+4Qhd0eMbjdaAXTs2BYfIpX+B9Y
	tnXYER37jQwDgzqYf0fy0oGD9dsaG9gw87jOqJKS5HE7XkKp3DxPcID9dBXLnoF7y54Ygy6Xruv
	C6N4ZZDspjoI+DV5SoKDa0KG5toW67dQaEdXrvfsbru0LWcS46L5TmaW5EZEmAgYtfMOEaG6qd8
	yyhMqZWsKAUPbOrBbe0m4NshqDX4vm2hDiBaD1zxfgo/NJIOfgNcjMHWFa1PReFcipvoNItb7y6
	4h+VcieQi/ZV2pI/TX3jg0h2Vwt+Z/T0crlafYLsSzTxbUnzm7os+3H2cEIOmKc4DM7BEYNEJHA
	VnG0wGj+ycGQS1zrKPxlwNw82ROciPF4ZPpVROjq5vhkl2NwDAmStWgQ0NJU03hx0So5jH9wGWb
	Y99j6C8s8jLqL/bRXSX6NWuNwez/lr48+T5UNKDFylTfHRxX9CxVOAmyo33DXkvIBV8N6fK3dDk
	a/082bZNfImOcy01iNrpoTTnVDb+10PRLumeBrQY=
X-Received: by 2002:a05:6a21:38e:b0:3fb:1091:bfdc with SMTP id adf61e73a8af0-3fb1091c8d8mr732255637.37.1794745326564;
        Sun, 15 Nov 2026 04:22:06 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdded58a9b9sm1220520a12.12.2026.11.15.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:22:06 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] scsi: mvumi: do not free or reuse buffers a timed-out command left with the device
Date: Sun, 15 Nov 2026 21:21:50 +0900
Message-ID: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

1/3 stops the controller bus-mastering before mvumi_detach_one() frees
the buffers it was given.  2/3 keeps a timed-out internal command's
buffers until then, and stops the probe loop from handing them straight
back to the controller.  3/3 waits for the event work before the host it
points at is freed.

v1 -> v2:
 - 1/3 is unchanged.
 - 2/3 also stops mvumi_probe_devices() after a timeout instead of
   asking the next target id with the same frame and data buffer, and
   frees the command on the duplicate-wwid exit, which returned
   without doing so.
 - 3/3 is new.

The review of v1 raised three things, and each is answered above: the probe
loop's reuse and the duplicate-wwid leak in 2/3, and the event work that
mvumi_detach_one() never waited for in 3/3.

Two more, both older than this series, are deliberately left out.  The DMA
address rebuilt from the command frame in mvumi_delete_internal_cmd() is
already in flight as 7/9 of
https://lore.kernel.org/all/20261015045213.3975845-1-yhlee@isslab.korea.ac.kr/
which deletes that expression altogether.  The unlocked sync_cmd test in
mvumi_issue_blocked_cmd() is a separate defect in the submit/complete
handshake - it does not release a tag twice, both releases being under
host_lock, but it can leave the counter at -1 - and wants its own patch.

Based on mainline.  It still conflicts textually with that 7/9 in
mvumi_delete_internal_cmd(), only in 2/3, and I will rebase whichever
goes in second.  I have no mvumi hardware; this was checked with a
KUnit model.

v1:
  https://lore.kernel.org/all/20261114014430.489668-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee

Yehyeong Lee (3):
  scsi: mvumi: stop the controller bus-mastering before freeing its
    buffers
  scsi: mvumi: quarantine a timed-out internal command's buffers
  scsi: mvumi: flush the event work before the host is freed

 drivers/scsi/mvumi.c | 73 ++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/mvumi.h |  3 ++
 2 files changed, 66 insertions(+), 10 deletions(-)


base-commit: 23c62304dde29abe92013d85910d03a77dada35d
-- 
2.43.0

