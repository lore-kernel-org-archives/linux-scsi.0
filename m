Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922972;
	b=PqtJWOADoqYemzJMI8qlW0DGrLrxxNvy2eIc3ZmTW8EcSMZboSTpLAxnkadXiYnLV7+C
	 dJwgziL6ouinGAgLVbEuqkZvmBu/qJweO4Vrb7T6L7C+Y6gWQTGjjvYXhLYCNw+AJHX9M
	 0OmOESdPU26MZbaZA3D3kAoRifbe90zeq0nBOu7e8BzOkn+WjYGJmgiu3uKWxotipRzyC
	 wv8iT4q4adR7Z1xWvIG6uTHp5ymKqD9SeN6PHl/JnHFE3/D+L4OPbFRgr1Hv+ZFkPfL1J
	 IrtlkqEuZaHFYg6uqHNilNNtnIFiBETMGFcxu2U3yok8Vt7ZvSdYgQxJy7vzaE/lCJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R2y/sy9kcOzgZ09YoYPacmoSf451Z2c95GvvGBXLGJM=;
	b=UZyupvd9k2cgBYqcJXgO2sUU0FKHnytfUGieqqO6eZ2DrTXcqfk066ccBZtdlx/fjCe5
	 OcHPgojPlNkDiwoPdb3t0iO7z80bBCc4KGmTmhz3IHB8ScmL/0hJxbW4PnqLyVu8QWxlI
	 tdFHmfqb7ozVlYMdVZEOqrJX0yHexLVim0jcryC9cZzeSrg15d1z+iGP5d3DSAiXnG4l+
	 nwpsF2frh0YVT3pi2Qb/DPPJs9ciNXMx0lP1IuDCl6muqS96hHvdWGFln2AsWh59+zIU6
	 vtmpugOB8vcnlf2zEWfrXxEYHhUJEi5ugxjFQyWV/P4pkQIzn4OExsB4amDDKeYqcgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NuVQqrro;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838EF606A33D
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 13:42:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 838EF606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NuVQqrro
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so2346041b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 05:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794922972; x=1795527772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2y/sy9kcOzgZ09YoYPacmoSf451Z2c95GvvGBXLGJM=;
        b=NuVQqrroMsezBs++beOdzdAskzrrPfRzJMfEGpTCLLyxjiYz4rjqdpQYhApn2BYMyD
         vNvAEHa4rs2Rqu1Xs3c//h5HYsK8wFDRbXRbPSKb1qCgjhtomlHTsvQUsKGnU6qiDh4f
         EOL64IRcH1Cs9HTIFETzO/ClZTWapWHIKH4HAvSs183dRKm80VmHNrXdjMUKOmavJshA
         86bP4l9bksPw2vaHd4eXabVVaQqJpBegP8pF2MSAfPCo+s3eLAnSwYOLsuN5kXnPv8vl
         nemcEXl2zRKIdfwhCSlQK4p+NVQ+NVhWEEaEd/UP+5aCO8Iopm1eaI7GcYp6eyvOCJ9I
         2yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794922972; x=1795527772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2y/sy9kcOzgZ09YoYPacmoSf451Z2c95GvvGBXLGJM=;
        b=IM9bK4Oh+Y/4BlP6SblvRjfYrSoCrBXSNyYf2iwpTnvcWfk2S4fXL67YTXZfTD0Nkq
         lfc5d7sDr7aC3bKivb5ymfMvXBj4IL9pmBvAb0TvHhYzadXXRcGId/9aqCd2GdRZojlB
         olmcElSQ81MkXWMErBjvFFiA1ybmJ73Whng+SAiHB4kM5NNJEzocz0X5tAbSFcG5qCpm
         3HTn/z/2D9sEuMkYdPYtxs7DYtNff9wK2H1SnuwQgTWooscM2fX2R8K0xhyLLEy12syv
         ROZG/aGc6m7IEKNqpbNbuVp1vpxN1kGt3fePHPL6Xx29osTFYCwFm7fCnlqVEUUMUQYU
         lAFw==
X-Gm-Message-State: APuU4Z8xvION5tJSN3syw05SOiSUzgGTS2Yzg1bm1Y3ToBORwzjjLQzZ
	UV+hkAoSL7fcr4NPOIgDUMqBJpcaV59qcXeRQspQzRMLXbxywfWX8PIIMwz9Ul0M6P8=
X-Gm-Gg: AYBFou1M2m4dIHITXnGquHiVJyePx6Zncvw3SW2s767kka/po4bNPj//t74bQJgePiu
	5fOoNsZw/wj2auVYIT3mw7P8Zf+X3Mjd5eGGoCZUlVV+GYk4fSRcMfALYM2C3lm7LjW4aOzIvjo
	3Wa5U6ZzRv24MJuT+kxltbM39XsPY3+ZX6AxquLIOmdpPtu7B89sXk2Xr76kJYFZWCQcXmoeA4W
	YqMZLCDGmoPcmEVoOGL859vRvtsnXKs3xK+JQ3ia0xO5Coko0rYY+m2EbDL4k9N+ZTN4iiCRzOb
	397Y7FrxJUeLUK6mP78gtlqhGTZ7zcFZahbPjQsi6a+tBRIF2qNXVm3HeinCnIqDlcZQ0DIp2w+
	694KW78ZeyYpN7UcrSx0rL6HqEfIeQ+jPFWV0lEQJak9hDG2PtQBML1QYeHDeyYjIP4Vfo2ChOJ
	04iWoSzglF8UZOMBFwY65MfwaszQAPSy2lBXsz1U6XVIqiksOCrI1IO7+2ZrTdJKMe8+qGdkNax
	oopkffx9K9NU3ugY4SGmeLyWsIxU2zTMZen4oQyPLNwaJQLMRM92Wuo1zlrxxLZ8KRhZ2Yb3Fj+
	gjn+PpF4jWyCf8bNn5Y1nYD7+2wWeCSnkf0FFJ1F90leAfSeRCPGrGPVW5uQB53s7M/cBm2Z4Uu
	HsQvOR9QvVwYWnoNRNeE2yfjk5j0G0TDaLhotbA==
X-Received: by 2002:a05:6a20:6320:b0:3f9:9897:4ac with SMTP id adf61e73a8af0-3f99897220amr5666028637.60.1794922971751;
        Tue, 17 Nov 2026 05:42:51 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8024sm5040714b3a.11.2026.11.17.05.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:42:50 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zilin@seu.edu.cn
Subject: [PATCH v3 1/3] scsi: mvumi: stop the controller bus-mastering before freeing its buffers
Date: Tue, 17 Nov 2026 22:42:25 +0900
Message-ID: <20261117134227.2077013-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117134227.2077013-1-yhlee@isslab.korea.ac.kr>
References: <20261117134227.2077013-1-yhlee@isslab.korea.ac.kr>
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

