Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795691648;
	b=eDSiRujeJmlmbuFrpi8Cd6cwczQ/4LlP6o0gYPG9y5VJNwegmuxo5HxuV3nOtSk3Dx+k
	 1iYz1xcoVix/JmgjgWOLwoaWDogyzVnmSqeb2uDTraj61ZQOMhtRVksTQulX1zVajLpRo
	 fiIrbWjkTlr8aYZoXA/kYGwWDLt1N2UjU1HMNsXOGQHPIChkqkrP5qv5K2zHbsxa9Nff/
	 BGiNSe7Y1JvX+OdGvKtvFriKR9gLOrRjtW23BvO2QywQ0jCPhQ39qZchw4oYiOiFdajvD
	 XYF9OlI+631Beb2SLGPkjLVdba5QIIvxl1gRRVcJLqKxhBO/PvB94HhSxTCCOvIkRLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795691648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LFWwc3+AYfzJIpjs6+s8KEhT/u7I94YZNIJa6waYCdw=;
	b=OcAgzHxDK3Q7i1LlpLYAdcrEozdZGiJ+DMM4hIPTqp9WfUippr2NxpDr37VF4LpIjmvD
	 6GrxlrhQnXWd9eK2BGklZzW3qdP72t55GWUQPRhRFONRybfiJxHAlRb1ZGFB6nDhxNV8j
	 +tgINJyVIoRBVXOOh9c/g+HW/M/FY7DYz5AoELXNnPG9mmQScHtxS239OB6AAW28BZALi
	 RH2JXEV6q/93PgUCdcNwbiCz8nGbUPr5GqzTiFLOHJGtK7vpq+xtXVitUMDSvkFxfAQuC
	 MQi8j/W9/NVOuthxZDJ83kqFzGbnM6Jfaqx2Ff99FnrK80zUi4017j6dTLO7ogpBv+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cGD8njSp;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C94606A31C
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 11:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17C94606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cGD8njSp
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdebab6fdb3so601679a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 03:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795691647; x=1796296447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LFWwc3+AYfzJIpjs6+s8KEhT/u7I94YZNIJa6waYCdw=;
        b=cGD8njSpm9yBoOYgmh7titWNydgvCEZKM08UtxzF4E/k7N16JtN3wLT4D7DDsTMcZS
         bKUcxitjH2pomIu/HeE34Gae4rAeLOmj5Dai/x3pGTczZu7OHT+Tx9R5kKA0qcEXzh++
         LXzeQFzWcGihYf1QJaftBJX0CcPSv8yYcAJV4Jn+4d6tCJh3irGusAwH13S7uUn5IgDU
         e81vSMbU8SDAsYZ6OcUO3TbMgExL737O8Kacb4RrkxDx6WRs7BA/vlBz0zl0+lNeWt3D
         SBqEs0JMuUhftESmvJnKr20AMoBxaW+pBEawVv6uATX8Kg5jxli/LrESf0b0P4jBc4R2
         iMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795691647; x=1796296447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LFWwc3+AYfzJIpjs6+s8KEhT/u7I94YZNIJa6waYCdw=;
        b=hUWnXWG6njO0d+qUKLBrhKMk5UONEJ1ubMX7fCu+Z3espeoQ6c84xlH2KF7yNRH0xy
         MI1uixzhye079G9B1sp18aJzKbMxSmDPZ4Jpoi8PhA2ad8P8yXbdUmgyZiCr1KFQV2P6
         57TV2SNNJu0IbbMIs0hAKLG/VSvHu70fABE7eKVBxFYoZMKd9mzlGv/QMr0X1h90YxdM
         4+3n7xO7lXpxtaucvMo+zq8k5QVmZtDWF5MYIIexbm34pQ5oD/+iVAE5XsyfxS2+Slvx
         +exDd8yH6W03d2R16afgUQOXXWJ4AYI/zSGkGmHtNVyBih9WJ5A0kIWwSvhiBmefyBBW
         ATiw==
X-Forwarded-Encrypted: i=1; AL+hErHG8d5QipMgexlObHO4uFXtgFxSE8h/mldt305F1sRkTPdq1tZ9nxuwhrM+Q2XAggBOATtGXUsij6mU@vger.kernel.org
X-Gm-Message-State: APuU4Z9cRrOBNm67uoPD/F94/4Ho/g0hkbG3M8rv+WZ71LRyXaBTvJ+t
	XvUn5/ca4gd5cXsPx9E1DUXKjz96BTDNu/uowF+eA2igCb1aYs1r2/U5
X-Gm-Gg: AZFdTZeznhFVZCUuunfDZLD9LZXzkdm3xYe2Gb82mC5wKih5UMF+xOZeEuO2a0Ff6+K
	Q9ksePDNeyM4QdJXXK9Gb4ctKrO2qiLc3iGk0A46yrARxgx7V5y3sAYkBQ++wI7v0y3ocNwLkVL
	itfgN6TJs0Dsq6oUdlfgytyK8sP1rdtMMPfAukqSyVsMSGDGW0vIDVykXnjQTtItdvdQlm8i2JB
	XhHwrpvg5m9LuxM02jw5DojUXVtvVRISVKllyHSuL7mU/sItZLYYkAIQhcd+mQiDk3eLHFRxbFv
	QjxQYa/bjuB6I9YIBs9kq/toSc7KjbkE4VygdXhR8b53u0JWF4Sf0oljf8iH9BOIE2EE9hNgYew
	X7QykW8SMSLzM6RsjFLNmQBDZFPbdky6lMYJWFmnVpmnqWt2MHX0mNZbi28yyzFE/k3EgtQArIh
	9/8++whi0v81kUyzyq6U1Ys9m7FQWon3ueA68cEEyt+T3cQwW6QgksDVS7mvrq6kBmowpqJTgxV
	4xRiWCkgW9dXsmtvk+yS9cJuebQpNsYNAydRBjQfzHQqCANCRm92kdpjSbJWJ2cETRgxfXuaLCP
	U/RA98/t/ikm9O8Fd4UzlGrUIQcuARm+veUgPg5mpigqWMqMrTtRkH73URxJzkEKb248KQpzU2w
	wsIpC+DghZWHO6yBt1MO4zOlfYrBU4it0u8Ag46lGYl7GLTk=
X-Received: by 2002:a17:90b:17cd:b0:3ac:9599:a689 with SMTP id 98e67ed59e1d1-3b41c9d3111mr17009544a91.34.1795691647272;
        Thu, 26 Nov 2026 03:14:07 -0800 (PST)
Received: from lwq-server.tail118c18.ts.net ([74.176.208.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41aab4729sm31983650a91.0.2026.11.26.03.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 03:14:06 -0800 (PST)
From: Yaohan Li <shunsheng1218@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: disable exception work before removing hwmon
Date: Thu, 26 Nov 2026 19:14:00 +0800
Message-Id: <20261126111400.2828356-1-shunsheng1218@gmail.com>
X-Mailer: git-send-email 2.34.1
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

ufshcd_remove() unregisters the hwmon device while hba->eeh_work can
still be running. A SCSI completion can also queue hba->eeh_work later
during scsi_remove_host(). When the worker runs ufs_hwmon_notify_event(),
it can access the freed hwmon device and trigger a use-after-free.

Disable and drain hba->eeh_work in ufshcd_remove() before removing
hwmon. This ensures any running handler finishes while hwmon is still
present and prevents later SCSI completions during removal from
requeuing the work.

Fixes: 66ec6d59407b ("[SCSI] ufs: Add support for host assisted background operations")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
---
Tested in QEMU/KVM (KASAN + PROVE_LOCKING) with an out-of-tree virtual
UFS 3.1 platform controller driving the in-tree ufshcd-core.ko (no
kprobes):
- Unbinding the device during an exception-event alert flood hits a
  KASAN slab-use-after-free in hwmon_notify_event() /
  kobject_uevent_env() from ufshcd_exception_event_handler() (freed by
  ufs_hwmon_remove() <- ufshcd_remove()) on the unpatched kernel, and
  passes 10-cycle A/B and 30-cycle stress runs with no KASAN, warning,
  or lockdep reports after the patch.
- Exception alerts on SYNCHRONIZE_CACHE during scsi_remove_host()
  requeue eeh_work on 10/10 cycles before the patch and 0/10 cycles
  after.
- Compile-tested with W=1 on x86_64 and arm64; verified clean apply on
  mkp/scsi.git for-next.
- Not tested on physical UFS hardware.

AI assistance: AI tools assisted with static code triage, writing the
virtual UFS QEMU test module, and drafting the changelog; I reviewed and
verified the root cause, teardown order, workqueue/lock behavior, and
the final patch.

 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3c28bc67c65f..86100ac90fce 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10988,6 +10988,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	if (hba->ufs_device_wlun)
 		ufshcd_rpm_get_sync(hba);
+	disable_work_sync(&hba->eeh_work);
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
 	ufs_rpmb_remove(hba);
-- 
2.34.1

