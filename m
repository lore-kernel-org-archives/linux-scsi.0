Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794620685;
	b=S4bTlSVuT1RuC9QkkBkLD9MfBpjcEWho/nUCj3HABlxOVstZnQYbS/JU1AAf7LHjNadd
	 bvyLri0juZlPOgQXf50ZVrgqZLC7LpFmZXmf7Ihkl5BqQslppSbiEjx5+Ek1TueDK8q20
	 ngCM1N4N0lnJmyDD7C9ELaCAtqCJVWZoZH3D1+iaVbtrVVJ+IR4crxqjC4IAVL7XF+jGL
	 EFftzNXW+gUUZYIxPSexprrKPqL48zpvQHBzilsBz9+/Ttz/eDcF3EKlwvWU5rMAlQCgn
	 l3vdBKxl8Dsy1D6RcghX3izOmlgB5kstASgqhmZDybb+gy28j8AnCEV/SZjcrLAu1iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794620685;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6bf6t3Q79m4DHDjPwrZwc68kd6cEw+Bo8zLmu5APiVM=;
	b=ebVOiGhhwlk49zV0ZSO86Bw/2/xuRi1CfKuBrUtajHjcKA9ZKX+8AMbscO+Q9PKfU7iK
	 Xc7n+DU4Gend0+ClVS/MzBSKas+w1JZwVFncxWc3VraPpS0LRhIBArL7L/rTCdwKACqvk
	 sxcY6yindQoiWqY7XoGIJaXPeHNJ5DrervrYiKFqdCUPRRVLHcc9VWfy7kuYP4LmeTNMl
	 YMj6M3j/+xdabuGiyryc9rln7TICyXlNlY3aMEBvKLbLBBIMBGcquCIxzh6/VTKefuRH/
	 kxhzy2/i0mvXo3VEJv1NVciG1vRg6xqcKzwTTasfNlLnJuTT1vInbO+9cT8hy3+WXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ef2GEjks;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED51B606A8A5
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 01:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED51B606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ef2GEjks
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b1535be329so1485688a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 17:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794620684; x=1795225484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6bf6t3Q79m4DHDjPwrZwc68kd6cEw+Bo8zLmu5APiVM=;
        b=ef2GEjksHjsOhvCWnT6KiI0YSJxZ1o9YELJwqkdxHnHVtGUAbEFwpPPReRp5n05527
         CoUEXdf8E4bDDRpVYeFGT/RkrtNLjr4hk6JE5bOoNtukx/EWkIbRX0AHoAQYVv3oW/9F
         Zj5lgB/28cTF5VwpY73q6Csl3u7Q3AEOmwvyuyrBtZUbEcoFb36NKfEI1HR3AY9VK6Tt
         fmOZSrck1dHpzgSxGtwfQnth8ygdUxJa7C4JVyhRuC8cQLu74V+SGFZG+QI8Wv31n333
         2fZElH9yXVvhR7edwVe1NdzZqiVn+NOJHFphlRoRXsEybFpawF5uBYfjjckL6klDMWNx
         1rUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794620684; x=1795225484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6bf6t3Q79m4DHDjPwrZwc68kd6cEw+Bo8zLmu5APiVM=;
        b=er2gHdBhpzIwEF8P4esBWsS/aO1d4wI99tG3iLf0BK/78YgofM8C7g3Y0Qy1lYXUEh
         UI5mjSjoNJ6cPRYgHy5dRxWTy80DOWD/ENFBMkt0TRmf/561YWYxt3Vhhx9P80CgZ2Ex
         E7rnCPdH8CxnGgusCVjrT1AB/JsPrPrDPwCP+vWU+tFLmIEmhrkHYCrcKRBl7mjZ1Sxp
         wIucFcN07NnosJoKabtKTRgU7RiQaZ7l2GmKBAQziw6atSonMZFneBvoFE12Q4xHWQt6
         v1JTTrRVwCl5VahNKxA6SsOam36sZPvvhHo0EJqPR1P8vvxTz+6pi+Ek/Nr3KY39TYFT
         5xyg==
X-Gm-Message-State: APuU4Z+uhDZ5CGj0M4v3djQc8dsUCKuqunNeb9CzvTPWL+BvW0gRjXjE
	h1kxmjsCODNw+DUiV7svbhb8pgGTAKL9F1NTirT8acNXs+92KK3Q9Cm8p0lCCCOtRUE=
X-Gm-Gg: AYBFou19T5OIzPaiFP5FViimNrzcDJz5VSqaaO4ZbSWbqkrEqN9JZfZNuVzo90bRM+0
	qeVRTZYKe3wzQPmCHw+Th2UjG/Ge6qwNjckbmixhbEnDgKVwQn9Jh2ehq+vrGSgCtRPL9mChZKO
	jp3sRdBvBikBH3Bw86OjuXDkoeaUX8oqAEBu131ZGKC6umEMwKkeUJbCP8NvxKPtS02uNJwxt1j
	YCUzp9tqeZhpl6qfswPCCooqn3xT17LUL3HBan41hYacwRZRvFrz7dwC5rK4dqCN9p/+15Xf9sh
	m/Z4XI6k4Q4z4OpUn9BLItZjmB/4K8iSR5GI6WpcMLIdIHFbT1HLhcBePOug7V9uiNBXnp/yTAs
	4Q0bVJbEyTwM9PNV+zjliDALdtf1Ss5G1UtstyekbxmTibgyvU6kMCUQ8EF4NMkbZlnaf7++Npl
	Y1/wH7KDeUxK2gQ/8DWYNcpDKq06EZO3mFFjIDdnALUu3QsGoZG6+hX8SBzOdxCjabhCJun+51S
	pyGzKnw8gVlcrh8tsSu9eBxbJ7kwU7p4mKfoaO2CbVCScBEJd5YKvPD0cOmQyd6iT+zKgA7G5ns
	tBMB4CT30W3FIHjRdB+C/OXpZP6bkgN6mHws6SvSnJjYfoxrPrcmW9aIOByByVerbrL/3umAfyb
	wOJOIn3DvI2whlHE1wK1BW0dub9etSTLSJV8wtskPoLJI22d0ZIFwLpTmsQY=
X-Received: by 2002:a17:90b:554d:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3b1b0a4c61bmr4603149a91.49.1794620684252;
        Fri, 13 Nov 2026 17:44:44 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm3437082a91.0.2026.11.13.17.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 17:44:43 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: mvumi: stop the controller bus-mastering before freeing its buffers
Date: Sat, 14 Nov 2026 10:44:29 +0900
Message-ID: <20261114014430.489668-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
References: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
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

mvumi_detach_one() frees the controller's buffers before stopping its DMA:

	mvumi_release_fw(mhba);		/* frees them */
	scsi_host_put(host);
	pci_disable_device(pdev);	/* stops the DMA */

mvumi_release_fw() frees everything on mhba->res_list and the handshake
page.  The controller is given those addresses during the handshake and
may read or write them for as long as it is bus-mastering, and only
pci_disable_device() stops that.

Disable the device first.  Nothing in mvumi_release_fw() needs it
enabled: it contains no ioread32() or iowrite32() at all.

I have no mvumi hardware.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Disabling the device before scsi_host_put() is the order myrb, myrs,
hptiop, wd719x, qla1280, dc395x, fnic, snic, atp870u and am53c974
already use.  Freeing first and disabling
afterwards is the more common order in drivers/scsi, because a driver with
nothing outstanding at teardown does not need the device stopped in order
to free safely.  mvumi cannot assume that, which is what 2/2 is about.

mvumi_probe_one()'s failure paths are left alone: they reach
pci_disable_device() from labels that have no Scsi_Host to put.
mvumi_shutdown(), mvumi_suspend() and mvumi_resume() call neither
pci_disable_device() nor scsi_host_put(), so nothing else moves.

 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 91c2db697c6913..8d22d370d8608f 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2548,9 +2548,9 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 
 	mhba->instancet->disable_intr(mhba);
 	free_irq(mhba->pdev->irq, mhba);
+	pci_disable_device(pdev);
 	mvumi_release_fw(mhba);
 	scsi_host_put(host);
-	pci_disable_device(pdev);
 	dev_dbg(&pdev->dev, "driver is removed!\n");
 }
 
-- 
2.43.0

