Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795764311;
	b=keHTuSfNURV03S8+QHCzjItf0nqAYLvWM4lCZnO3DMW+ryjm9Gt04xcVlVQWt+taQtnb
	 /o5+RVqMWiqB6yLhkvdYLCjMA3Fhq1vPs7KEEJEO+qRnH2grQgH4+Vmcr9Oms2LTzORnw
	 WM/LNy0cOZsz0UZ8afPbsj7+UE28/DwdxOrOZ4PhoaPmF8dGE83z9g3II0Ll8wPtwZRPB
	 EEYilFH9nHfo7n+A1nKTGe6hPxGcrpnNOkkp7aFuLiVmomMXIZUOg+XGWT9bVp3nsLHZk
	 SKWtQu4H6C1xHFdr/sTCX0Itvr60Ht2YaKYGage3Ge9zh5GbpwPN6Nn7BKLT6HwAvrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795764311;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/UnVkS186rBjFORx1WGGhaXS7CtMdNP4mwIh27hA8Y=;
	b=YWRLkS/1NKUBaoTB/8O5MWhlsvIdhmdXcpInwC5GeTVGdgJnFVVqISn8tzXW6BSeXQcx
	 XnQCzhbnjy4STFs5SEEXX7BjjddSnv0hGzweEBucW8WQbcnrnyxo1UWCyJu2lApj7Zaof
	 yK/3ZSs/uFVG4AnikTgQRRVmo3UD5FsKeavaVl8KsQqKUe2znBXJzHS4Q7KXDm0zmcUj2
	 OLTsaXcCPlVTOnT1miz9QEw2ElANlxyZYIAA3q1PK7b3ay3eXL8/fb7GFwzQZmmXKblCb
	 fjPZEazvKgMGx97O3hcQ3SJTbl7y2AO2MSNcV7eNK95nNtxj50B7917rsYr63Q8U0tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mu1wGTtp;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19BB606A32A
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 07:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C19BB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mu1wGTtp
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so3781556b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 23:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795764310; x=1796369110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1/UnVkS186rBjFORx1WGGhaXS7CtMdNP4mwIh27hA8Y=;
        b=mu1wGTtpH7UUTWRT7TKwKzu3xkLTvTXP0a98+GWdOLXcaFf4mij7v2At8GSQ4bbJf4
         B15+Ip19sYUkCisl2knTnQJfFC6F9rs65Dw3jrrnc9KHFZ6PWAISYe8XGdjwRPLhWLkT
         HyAl1pGjZzz8bT1v05xJyGnnlHwyF44zaeKptaGPYFJyWZFFlxXOfav2IWesSZ4eYdpx
         9MTxHR6bw/a4yRdHPBYmoV7gizOSm5fF3syIC7aJtVm27V84zboleVlp1pYWilFTXI7y
         wYHcJodei2P0VUciszrQJOMnlg2rcvTGbjAymc9VpamcDga2JBSfQqlRs4lfvyLtNsIN
         jnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795764310; x=1796369110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1/UnVkS186rBjFORx1WGGhaXS7CtMdNP4mwIh27hA8Y=;
        b=cS8zj12Bhk0jIjq66f4QfzZhTzlcl3YZyriSdSa3fYfgecpvfE8juhVtwhdU+5sCzW
         D4s43mAbHzIPro62hyM8a4dHwV71Nw7lkxjnUuyEB1P+9jnUn6bNxiizUzDFCrDhOoAh
         Kx9fCXWjhEFfABP9D2NcynFAAualHIr2HKbM34vOHfuzChQwGysZ5y+Wl5Tz1amILYgs
         B/xwlBlYZIgk8gzoftRbLLUzPc84cxbXm1OGp7G0NF1uDvqbZF2nepKD7ymOh7TcFmE1
         qNCgHAtcAtCEK6ZHaFAqIJsQOqr/onk2KhMCdunuVxFmWRwsb1jw14l0SLVJ81OjBftI
         VPJw==
X-Forwarded-Encrypted: i=1; AL+hErGD9U2l8BnaiJR4UNX5zTqcXK7FwFtLCgh4XnUEeJWPLzQGYwcNAcgOxFzW9VPgqA8CN6jILFwdfe4l@vger.kernel.org
X-Gm-Message-State: APuU4Z/Wkdxsw1q2ENeyctZnOr7zriDF8/uM9H3wEbnYBP7LBy/FV6Ij
	z7kMyx10e/p4ym7jfe9XkOhYpIjmZI9NbzYsrharA7eWbxbhO2H+vgez
X-Gm-Gg: AZFdTZeWpd+wbMxozcS7gNsgn5r2U55vMK9nlpDi/2uI4+7CTaQLG9/6aeI40bzV1Ya
	LEmT+uBw/tSnT0ImZoI+SW1RPkP5icycoCtft7vyZIOpjVppeB33Q/88/FmDeq0H9igvTtaGe3V
	4d99k2v5pS8Vt8Jj43UzK8V9Ge48O72+//0jXsTsVNA5iCKGoce1RxkhedLrjbhvkfmbIbd29nA
	TIAxfad4M2qUqnKsi4/kado6ZOouGYZLuYWbxpH5/xfUUpplDrTtfpkg272FToUrAhJGZXuvCP4
	QhFMN3B3xjROfSSPPnIi8wL8/f7+UsJ51xgoWFdqhH6cFynid9mNs6e3tNZaD2j/CDyWE0MzX01
	/ffg13WsYE0ykv6pYn61IivEtJ4dRy5H1jnPspby1neT7FtcYqEOgboggaSFtpLHIJ76HOoR5qj
	Q6yD4F7aEBj8AyfoJ7Jmr7wxdBDNtL/7WtsIbj2/9f/wliP50YE339yf0Feu9MinTCAlV0/C7PE
	9u9+MD3rLUw1In7M5BF0oe/KOmnQ/nhUFFdPsoST/yXmWvaiHmhUqAkMrdgA2zGl+LpxL4PuyOZ
	+q6Wj7BbwlU35MD2XBGbHgURlcy8NgZwcIpTIwTxV9se/z3NvtcaEjbBPnAmKBJxkhYhi1umjMJ
	/1htrqEaxk5Wfbd+za1+tkpRr6xZhpk+Tj0rJXAYNoa8fkhQ=
X-Received: by 2002:a05:6a00:170d:b0:885:e2eb:23b6 with SMTP id d2e1a72fcca58-8c87b9cfab5mr22744252b3a.11.1795764309893;
        Thu, 26 Nov 2026 23:25:09 -0800 (PST)
Received: from lwq-server.tail118c18.ts.net ([74.176.208.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e485f5sm12186385b3a.22.2026.11.26.23.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 23:25:09 -0800 (PST)
From: Yaohan Li <shunsheng1218@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Bean Huo <beanhuo@iokpp.de>,
	Stanley Jhu <stanleyjhu@google.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: core: disable exception work before removing hwmon
Date: Fri, 27 Nov 2026 15:25:03 +0800
Message-Id: <20261127072503.3922964-1-shunsheng1218@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261126111400.2828356-1-shunsheng1218@gmail.com>
References: <20261126111400.2828356-1-shunsheng1218@gmail.com>
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

Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
---
Changes in v2:
- Correct the Fixes tag to e88e2d32200a, as pointed out by Bean Huo.
- No code changes.

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

