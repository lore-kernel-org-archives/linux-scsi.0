Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745330;
	b=fo7VxdlgNT91hSPKULgjZnIc2U1HQyNA0AbqbLX4BfJ/W7AWc/XffQFGo9l4WyFJqgtP
	 VQceHoSoPI/3T2/bpYXIaePTh/EX5JMB9curvtJ5eLMeiC++bUtt3E3Y5cz6IIkMFenFZ
	 gGnDa4CGdM80UwjkrI0R7BZy9lOXqalT0YHZ+6lPr+oJ4uTjBP8OrI6j8oL1UbMynw2NK
	 Vi7tHQxqjS+Q0xHslvpldWTv0c0tOHevtoeOVVqgxmLhO36M+a9DQycBMm1mEbKMip63x
	 dBdIKUV+/nqa8PIUJ8HamEteDtIiIUEDalA1A1+KLszPI0wuYc3s4E6CmXQyQ5fcsgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745330;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R2y/sy9kcOzgZ09YoYPacmoSf451Z2c95GvvGBXLGJM=;
	b=gv1xuOoroYPELyOb07cFx4hfR8Ez9L6YsrA5743uMWQVqzOx4NBquil2diBKm39qMfCq
	 3NMhf6TgG8hvNg34K4zcMPczxoOxo/XHBnGbA2/g1ckdGGn0BgaC+6Za4kr0ti7tkKQjv
	 aKys0Mb2ymtRY8lb+bJtQQKZI8ce1dvk0aunRs4vw3y/9Mqx5RrTfRn1J3KeytIUG1oEm
	 dmhlt7NT3Zt+89RwKopp5dkTnXvraBMM/XnoG+mU2OpR9zsrIrWICYlJ8bCBD/Fzmugs0
	 9LZFa/LHgxDoKML84GvKsDK+hDDejAcE0kaJ+B/ndWTSjSHH/3jvM8JmH51Mf4AFAqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sg3SdeKp;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB974606A337
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB974606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sg3SdeKp
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso834084a91.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745329; x=1795350129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2y/sy9kcOzgZ09YoYPacmoSf451Z2c95GvvGBXLGJM=;
        b=sg3SdeKpJT6A5EFRCtF0Nu+FmM6+lPowbYZtuMOh2BydzpRwITV2sMBsCQQuhdla5t
         02Mfp4BH5W1Q3zT5leYnrKp03MkX1IsGFP3lj0gOCHFKAHH23cDVtgkaD9fd9JxDuHV+
         5CkkmygAes+ZodQD7HsJDSPxiHhoV6Ixb6kjkfGH+Dxef7Ctpnra0AAMRl7cGyq4YNlj
         orQAOsYYN5qiA2nIIys0kKosxJC+pZXzNWdESr9RLCikSp31sSYC7MJaXTu0L2GyUJIJ
         aSn6Sb0Vi/Ttil+KxhbA2YNBC8maxDrowE7eZESQ/7eU5YdnWsXG7lyPiI77HvyZv5+R
         uVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745329; x=1795350129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2y/sy9kcOzgZ09YoYPacmoSf451Z2c95GvvGBXLGJM=;
        b=RPbY9xr/xI4+Z4Ilt2MapmkwHRlkCixM3l55pdg28Btk0b3OM7SPDIEU6M2Me15c4E
         qa0OCgWdslHuY0EHvwx6YTgrVbE40dnA+xiqKVHzlLMZZsnYgEzuo0B4y3MRf/1a682t
         GrBl8SKJ04DvPOCuUTWi6MpwW4cKYQRzIOWdHcDVESIjQLHXzhG/enXIAijVa+HII1pu
         eLOj/1fQpxUavTirWw0Fx0hxJE5NQyJe3mE625vGNKuvxyV7aCsRCVw1c1LfH6Uu48RE
         fR39WTaHfAFhj8sLTwnXhjbBbYvlAgdZ/nbep5zRnR3omQr/0wDsL6ixkarn8x99x65z
         A7aQ==
X-Gm-Message-State: APuU4Z9+owjaahMuABxb/ixLZ0vFcNsoyqqlilS1eVN31lpDTcZSGyBv
	RDUqe2OREB3IgyL3Wzp6Wbc0hmUD6+GRWC81OuJKwhMP12GMzIgOq5b1Jq4AdsYOvsU=
X-Gm-Gg: AYBFou2/E9q5LGn7EpjgjmupeahRW5P0wHx8CTEsxSdkkC8xyICxYhGpttQQ/TdvIXb
	UJAQxkuAibwXJfurmv2xwlb+Y2pcDleMXBhKyul+kP7zO9pebgWo27opQEvxVbTJAOmkxY+NrtC
	yLRIAUMHQBXHcMrPoAUnXy/EpunESHs8voMmLCRfZDCjBtBc2vR5fplQCDMQxJcxKlDen83dH+z
	UYC4mEdB0km0qLEymE9QxjbjhuGM1xn9ztVxjS+25SxHQPdI0utvmDGfwCQ6iY3FA2s+QOxpoRp
	FoW5UmwRnXnpwAJO66Hh6EnocDkm9Ziow0zxusfszFyzAK70dZZ7NPt96sN0kK0rZNIwLX2c8P7
	/voYU+QzdTIcWAKnUY6BXFgKahA8KFlTR22YBvpXbgVOt9Uzx8wH546cYyNJc/C/mpqySlZkCO2
	q9ZG+Kwcft5MJ3G4GMS8205uMmGG565IbOMOE75U3JEYSn76AaDgIf4q4xIp4UNQ1AkxFFEQdXG
	mt1na+OQjbPoirl22+ebx1XwxVnler91KlmQ3UVjNETkZedRTVZxoudW1qNl6A/wJuZF/vYypj/
	4yAxIVI05nOHZdZjpI+JJ0lfCG6pgFzV8FJigJQLot1rB1lJ/s2uqrAHN2mYBHMfk445vkUI1wl
	wZcl0AUM5mpYiG+CN1AT0zKN/KV2LG9xA9pIQSg==
X-Received: by 2002:a17:90b:39ab:b0:3ae:8410:ae6a with SMTP id 98e67ed59e1d1-3b1b0a1eec0mr7647326a91.22.1794745329249;
        Sun, 15 Nov 2026 04:22:09 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdded58a9b9sm1220520a12.12.2026.11.15.04.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:22:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: mvumi: stop the controller bus-mastering before freeing its buffers
Date: Sun, 15 Nov 2026 21:21:51 +0900
Message-ID: <20261115122153.1446810-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
References: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
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

