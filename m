Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242214;
	b=G41srD7bPgH3bBuYY6lWWZt3TF0XLcepzOBR+Wzio6TJrNgwDvgC+xbOr7pRCG/S40/O
	 uzX0KMJr6VjZHis8ljjogcvWiqQdUAUnibWLNAMO9FpW2SwFlV9bGLp0YfLt+YsRtN0/7
	 a+Gh5x02Htv5bJGO5jV2sI2dXtfNH+T6k5dSu+i39Y6CIRbJgb/ekv3Z8Z6pKzrPoYyMg
	 N2OesfsbhPZZ2ZWAk54FUCNu+SvQXbaZJ+50HDxbDnHtQFiEqUvVsY7cpQknDdD3DB2F4
	 /2p87akcewonCLlvPVT+Ri6MrQK36lqMarKVnVnYbYtBPQsHZS6PNEaoM6ENDmmaoOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+i1MwDM3O2yhOtvhcZrVhI/0oNqRtv4EvJtbPIkjNXA=;
	b=fn+E5+4bWMYpfAruXc2FGRjXLX7+NJ8rwFuzad2TEh/fx71I3pzbJwXLpsHYAfmqitQv
	 oanZKF3s5maEgkl43G4vMsd+uklLwBF4WG+9rt9jejSBGli28FaRJgbvQtHoWNTPQ51X0
	 sNK9Dt/xf73qNfdsbwkpqbG7547hIFcS3VjOwgZYHSaeQOGCJgaga9KO2qFWCBPYHV/qS
	 vQRma21kg+p7LMrFOLEhZ3dcn4nWhy6baq6FUiTw1C6+hjY2qq8RqbyMB/Uue/s/kv/V7
	 g+N6yTS4DuFpc1EvT6r4hc3eOqcbsqaJ/b8KqaHqcU2ZyHCEAfIIWQaA+16fD+Gwl4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FoIzAwNj;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B460A6F55
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 16:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C2B460A6F55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FoIzAwNj
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-53bb57f1310so11533611cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 08:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242213; x=1794847013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+i1MwDM3O2yhOtvhcZrVhI/0oNqRtv4EvJtbPIkjNXA=;
        b=FoIzAwNjbA8Th3jeM5HQIAMdkEjsi4l+IETeNlmZjX0H7yKQ5UlCYjP9aZSanbN02b
         lSkEqTWyIYFpn0odRR3V16lY9j89BjQ1AkCfhWHi/LAf3EaSESFbTSSvYAv0ryOgqnQ6
         rDlVBClRe8MPuwinpJsXvREiBYqPqZPdc2lyRKLXurFxL+IHtNH+tuiRkstSTvAl9ytJ
         fdDeQs7Cl02lXbISyjiHKTZVDtmsxY4r/HJqjJo0y8w6MTFioKF+mAU+RQFwXUSrnst+
         +EwqDtnuRq4NrECFuA9uxXzYFg/cjXfgzDylF09QI6/azYaH/5nVVeUpz1xOgEZnTGBb
         GGDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242213; x=1794847013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+i1MwDM3O2yhOtvhcZrVhI/0oNqRtv4EvJtbPIkjNXA=;
        b=t7WK1ZYB3H9vgbh6TaMVjh/OLzmWVBbgx9igkG5ZH06kx/ELNj+7mXA8MzIiPcXnEB
         xULUXWpJgT7pYZREDBvolSLX67aKD6T3G4DThE8SP8dVAPCj0bBQI3RohxG8rW9Sm1Aq
         rqkA1YjlWz+8ylz3q8XZKYO+tVHvUOsj63bm5sBLtPG5MkiKQ2AtoOH1bp0jVlmbzloa
         jeGNUPcullXrvotfU+P2b0j0/MNTJWAw4wV4UM+Uxd2HkrZnggx1OrlQvFbiQ3HIGBPc
         zSbO0vefetsc/A24kA4FYVSOoZvBNU5GWRzBoHJtR3WCJmUoc6XMA7HPFzLuO//gxxFi
         Ilfg==
X-Forwarded-Encrypted: i=1; AL+hErEcVmU51vSqZ9Z1HAQ5qPou9rKe/8AuPGWpfz5Y558gGXL5ytfqVdP9ch7o96cmpsrUowLeCSrQpOSp@vger.kernel.org
X-Gm-Message-State: APuU4Z8Jr6dMan1axAFUusyiJvpH7B2EYbFobv85dTVHhxbNru7pwLpg
	ZM8Y5fW59GW2TjxZ57uUfnNcIFRCfW7WCXobTlKjJMGPFNU1BXyTyFoY
X-Gm-Gg: AYBFou2yQehgS/0HUm+Bq/XvaFtUBLRzusajeZjYInwPqHFrfCzzxDwMKEMQ1nYKWak
	Vn/5RKhGCZcB1ySsh8Ix6NMEl/wduYwFv6zjDotuexFp2aSBvlXWBfz8mR/gh/qopDyCDkLfIAG
	pXTpQbRewCBVXecmlFOw+T8vNsaMpH8vuRbditrayWbq9E5sl/5q5l9MN+V5sNgZnoPpS+dg2kP
	LsIP5+PTulpa8h2XxidM/jlBy/qwLz0DQHIcvpf1QQ1lYKfRWEVp3Zu1umpQjSzyFq7Ht07PPYs
	5yfHPPlypWnW6+UeC5jYLjJfhNGrnJzx10uexmnyie4Vtx4j71Pt3DINReFWpQ8RM++2aq+YbLX
	lpJSAkH1V/8Lyuvbjy/EyBT828ey+JehE8iUO7PUHYgPPnpaIresP9IS/beJ4TJXUwsuLMqqpGX
	hzmazdH0BB/awNe/oE4RCuFkguq6Cu38tscQd6SccAEHZMlfT5CZipKJUOJ0nB3KbQslt3J/ifa
	m2GdC+ibZ5CurnMhXHpw4WYt08LGoykw7R4KUJVGxSTRRy596CCz/5LfqFZeMwUf9KiJhCUGMNP
	84LnKbMVz/0X+nG86g==
X-Received: by 2002:a05:622a:5505:b0:535:a5fb:6446 with SMTP id d75a77b69052e-552a604f9ffmr71709701cf.64.1794242213378;
        Mon, 09 Nov 2026 08:36:53 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91eced95d91sm45729516d6.9.2026.11.09.08.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:52 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH] scsi: iscsi: Remove the endpoint ID only once when device_register() fails
Date: Mon,  9 Nov 2026 11:36:49 -0500
Message-ID: <20261109163649.1092897-1-lcy8047@gmail.com>
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

When device_register() fails, iscsi_create_endpoint() removes the
endpoint ID from iscsi_ep_idr, drops iscsi_ep_idr_mutex and then calls
put_device(). put_device() runs iscsi_endpoint_release(), which removes
the same ID again. If another endpoint gets that ID in between, its
entry is removed and iscsi_lookup_endpoint() no longer finds it. The
next endpoint then gets the same ID and fails to register:

[    6.689361] sysfs: cannot create duplicate filename '/devices/virtual/iscsi_endpoint/ep-1'

Leave the removal to iscsi_endpoint_release().

Fixes: f014165faa7b ("scsi: iscsi: Fix possible memory leak when device_register() failed")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing. Sashiko AI review
also pointed it out as a pre-existing issue.
https://lore.kernel.org/all/20260617204203.91A3B1F000E9@smtp.kernel.org/

Reproduced in QEMU (x86_64) with CONFIG_DEBUG_KOBJECT_RELEASE, which
delays iscsi_endpoint_release() by 1-4 seconds, and a test module. The
module makes device_register() fail with fail-nth (an allocation in
device_add()), creates a second endpoint and looks it up after the
delayed release. Without this patch, the second endpoint gets the same
ID 1 and is not found, and a third endpoint fails with the error above.
With it, the second endpoint gets ID 2 and is found, and the third gets
ID 1 after the release.

 drivers/scsi/scsi_transport_iscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b094af7c997e..6e38fbfd5a9d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -246,9 +246,6 @@ iscsi_create_endpoint(int dd_size)
 	return NULL;
 
 put_dev:
-	mutex_lock(&iscsi_ep_idr_mutex);
-	idr_remove(&iscsi_ep_idr, id);
-	mutex_unlock(&iscsi_ep_idr_mutex);
 	put_device(&ep->dev);
 	return NULL;
 free_ep:

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

