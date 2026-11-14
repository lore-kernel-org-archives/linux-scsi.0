Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627514;
	b=ZdAWs3DjtkzQEAcjtm6QUpV1zgiJq1jDVLgA8tjkZpamCfI8Ph74mBfW9hni5AgWBo9u
	 SNmDPZIckjgHmDHvRR4dMeozgRAkUMjhLOsXzf3IfUNuW4+O8j8H3iXjHmPZsnakmzsH0
	 VIeDdB1KsaRui2r6pkd2DZ68VoPesjh5UXm4etBWgVWSNfiNkWLPKIQz7uvG7KCv1N1Gl
	 cbPUrazDg9V9+WtVoSyosA0MaXDviT18IMncEywVhdZ8ZpLlI2Kj2DR3q4Rb5Zf36AIhF
	 yNjuEYLM+I0Ff/x0NEphL+a6zB4nnnPZemKjCrmeV8Nfz9iSvntAdldYA59MR02LgmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R2DebVOq3WKtsewVANK6OfPbVtCvG0655Z0/I18ITcg=;
	b=4f+8vWs8fgnmit0s7/r/VqiUoP4Ak1rQyNv3G3sYGa+EEXOHird0cdqG1aeuX/DBFCUx
	 jWVYIRP4V8RkZgTs9VoBAzv/B720zp8JognYqs5bLtcTdty3yjf/Q2gQYcXb9VxjSXAgU
	 5Z6tGB5l6fpk/1fBcF1v7GqggGa9hsO0sl5X3mcyVTcQ7yWNolreqd0VNUsiPwjuqsxDq
	 Gd1Y523DSkA6kcHKMXV83CfK0Sa2VsYmUnOIDeBwmFUzWlzrfzUTeyr6n4JpMfrRcFjcs
	 x2hiRAaI72S9AxJFnL5aXKNXhQqTbDXu6r5miK30mRIcTk3mGHjLduxS+OY4kPP+NdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=icxv2y08;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7479160A2609
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7479160A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=icxv2y08
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b0d09df973so2449377a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 19:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794627514; x=1795232314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2DebVOq3WKtsewVANK6OfPbVtCvG0655Z0/I18ITcg=;
        b=icxv2y08hLJXp205BMvqbTunQqbdYZ4UUtGRkBQskjMjmV6ghNSQZbwhC1QzdtCTuI
         1NQs0rz17G/dZJgNZLKirnBmXlRSw1B2lzqmxI1n1Yn/t8O4GJ3hDupL9iz8kFH3S7eD
         g7juhf2PwgJ/pt4EWcAD2BTBEcbFjSCHvvtdK6vF8Lfh/P97pLk60GFQYJ8QQEO70dxJ
         eFroTJIEgtAn+up6GfByHvMlxz8kCE4+czyGJvvn+YZW2MknxbDOfgMGeKCKCKYlNTmf
         zFldaN85oP6axExKDDB4TrVJR0VDKBOqKa6lcziXBGfZ0GdjW68VPt3QOLlKcTVoFj3I
         aiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794627514; x=1795232314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2DebVOq3WKtsewVANK6OfPbVtCvG0655Z0/I18ITcg=;
        b=WGAyeNVwhgO45DQNEgvB6f0UPv7ieY7eDpfYBfP93SE9QEFR9VUDl/cL3g62NFupEH
         5Z5jtW8qOtgzc2Qu2O0e802iisbR0mx+ZsGFxgVG6Z9EbJ0n5HlqHh1Habrhe9JoRvsu
         oEOrPhjYQODkovXi+EMhevT8lffzjEZGSZZ+qSVvc3EPtSvlKODnIsOLZzYyX8TAnKoP
         mMZSfYamPHCfKF0bWJk1641uRoouhc5mw7Y8Kuh2Pm5K8mtN6qiMyLWxqU/oFf88b7WA
         wWUb1l30iIWBQYuBu50shVI9dOqvIgaqy69vMXcq6GXtoDj2kel0S05YPRzJalkNoBCx
         fDlw==
X-Gm-Message-State: APuU4Z+nit0z9Po1UDM/6+TFmum/K9tlg55GqJNffYtdOzSxb2X2k6D8
	UjE9snn274/kJLov+TnxK2OTuG6t2azec8e7GoVpaycf5bBeqWtiZOsbGDySP4RfYeI=
X-Gm-Gg: AYBFou1oImIZVb3pMlOjxXfx1e+zb/3Oy6Okc0n/yT9a2C3zFGaoiYsKi/C3yPB+xv1
	9uLLsv4XngTaEKcmdX39U/CBCmy/EKsbEWujuST4gxlqCYhC8a0qbRJ1w1VpDEwKvw5+F471zNr
	Ytiu+EcCSeesYj/szyp/F7Vtkk9IqIDKDvJI6UjqHQq4GRhf80/vS2ADruoVuAn+QkC0D95Gi34
	7qF0gb6cwgzogObQAVIjMna1XVLLyvqhXTZzaBCuuEuxkhsHM5yR/mErq3LoRPo1L+e302+QPwE
	iNrInqbNjkIIR2T+dvkRmsTVnRDM1hWNxSxIRmXBNc8zTu4tPpBGZBHumO1isg+VJjoDJp8x/Pm
	rqHcgqTDkcafW8pGcWWhgrBSulOA9Q8YiabBqjJVp9e+L+PUQGF/U7IalFpSN593poedKp75iZp
	HjO+WoBFGW/mz4hw9yeMHaOFBmiX1DgaUAcQ4b3vbz3TYN/lJUO7WyjwXHDRxC+h8SmApU9+xFW
	KcIKRFb8dSVg87QGj2F+mAfjgNmXrnvxUztgkiC1ivqwVeBCdGs7BRDcPNRpUz2Nn/2jsM2Fgzg
	HGLkp1pvTpQdwOxfW+kXjuHQ01EJML6LBwdf2iNUNgd4peSie6U+EBzPC4kO9GzQWOdTneFNZ/5
	UtCt7OBs7+Nstul7tdkXIDNy1yPi9YqoK6YQUsZztU4LCe2VulVeOnHFjwo4=
X-Received: by 2002:a17:90b:390f:b0:3ac:8446:c1b5 with SMTP id 98e67ed59e1d1-3b1b0a0fdaemr4290992a91.31.1794627513876;
        Fri, 13 Nov 2026 19:38:33 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3a21769sm3412380a91.4.2026.11.13.19.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 19:38:33 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	erich@areca.com.tw,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 3/4] scsi: arcmsr: wrap the type B completion index before using it
Date: Sat, 14 Nov 2026 12:38:09 +0900
Message-ID: <20261114033810.549787-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr>
References: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr>
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

struct MessageUnit_B lives in the dma_alloc_coherent() area shared with
the adapter, and holds the completion ring next to the index into it:

	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
	uint32_t	postq_index;
	uint32_t	doneq_index;

arcmsr_hbaB_postqueue_isr() takes doneq_index from there and subscripts
done_qbuffer[] with it, and only afterwards reduces it:

	index = reg->doneq_index;
	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
		...
		reg->done_qbuffer[index] = 0;
		index++;
		index %= ARCMSR_MAX_HBB_POSTQUEUE;
		reg->doneq_index = index;
	}

So the first iteration uses the value as it was found, unmasked.  An
index beyond ARCMSR_MAX_HBB_POSTQUEUE (264) reads past done_qbuffer[]
and, should the word it finds be non-zero, stores a zero there as well.
arcmsr_hbaB_polling_ccbdone() has the same ordering.

Reduce the index where it is read instead, which leaves the rest of the
loop unchanged.

Measured with a KASAN build.  struct MessageUnit_B is 2176 bytes with
done_qbuffer at offset 1056, so a reported index of 600 reads 3456 bytes
in:

  BUG: KASAN: slab-out-of-bounds in arcmsr_hbaB_postqueue_isr+0x1f5/0x270 [arcmsr]
  Read of size 4 at addr ffff88800c08cd80 by task init/1
  ...
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 1280 bytes to the right of

Fixes: 1c57e86d75cf ("[SCSI] arcmsr: initial driver, version 1.20.00.13")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e635b76daae9a0..d13bd0febb81ac 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2568,7 +2568,7 @@ static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 	bool error;
 	unsigned long cdb_phy_addr;
 
-	index = reg->doneq_index;
+	index = reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
 	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
 		cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
 		if (acb->cdb_phyadd_hipart)
@@ -3671,7 +3671,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 	/* clear doorbell interrupt */
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	while(1){
-		index = reg->doneq_index;
+		index = reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
 		flag_ccb = reg->done_qbuffer[index];
 		if (flag_ccb == 0) {
 			if (poll_ccb_done){
-- 
2.43.0

