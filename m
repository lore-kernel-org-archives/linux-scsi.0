Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975253;
	b=VG9o/qVIqiDM6C15KLkHrMUIdl5uvddhTeY08MYqZpWsUjuYqfFCoA5nYKsmxzOc5Ht/
	 zBCAwCI8k2wtZuaBtjDECSTjYkSf/aifZe99Q5rlFGEbgVJYkKv1EW9Zg3tMoRDp5Gvll
	 lzo6Hoq/2QthbNj4Dr0RTiyDOjUnaZzKi+nBg0t2Z4d3E7M8ae5hOlPeJ1rEx5StAo1S/
	 qbo+pQvjc7VVMJfcEfpRD1n9VS+8WZBe5+CrhdlqVPCrLaLv3LkXqygUR1SE2wUvQJMAK
	 KIjq+f6y64LlQM1K9dJ+DYP4MhoDtBI8n3sN4l49aRZsIZ+db3DeSJZghlOQ0zkOd9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eH3ClhP3K/6K4ti1IS/bnRGkykU5Vjlc6CVNj4XDITs=;
	b=p+TkYKuXhCzyF3C3hu+Pu/MGr6zcZZ59UD1bFGBGGrdhk4R/2tUSZOxl2ZMxViwA8dEU
	 NZJHY0GxAwiI+GgOm7edyZ/GrcuKVN7elIKLM6vl8UVHqN/d0OUE3vv3yXekG6eV3Wmtt
	 evs6coPiv69mVW24CQXpUxNazgtiARK6Z0upUw8laeeGDA8wHQ0Ekdl12Ui7QrcD9HxUQ
	 xSQx3LyXTB3ey01Z5wEhmDvKlq84l4W2mpLlRRKdneiupP3W4oT133ki2mnluKNrbvxUQ
	 PwI8W5houad2HJ46TO38LbPW8Qt97S5k4SmI4L7MtzrF84SElUZylWGihAKAphQGf9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=btBomLH7;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B98606A330
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56B98606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=btBomLH7
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e9e53d011eso4001385ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975252; x=1795580052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eH3ClhP3K/6K4ti1IS/bnRGkykU5Vjlc6CVNj4XDITs=;
        b=btBomLH7/q5gdlk3VKgt4rjNfgc/iVqTspfJjdXjGJqKUMuDZ7snDYlVZ6ciVtTsR6
         U3Bf1z4DVXGqkKcHS9u3k3kqEWToe5gNSnJKF7NKIoEgxIG4NUE9f4vZIi2t//lo+euy
         D2HXiP8Z5Qk1WxsO0nSUl8TIUOrh+59FkRMhj2PB3ooNraE8z6Rq4wGEu6MUDgA+1Jxc
         Kat4BFMjkcLmvYyJbuOz6pVd5smw7fzOWOaY/b143FPJzJmtEqNSH8JaCkxQUq3SYm3W
         co9e1lg6wOviCfkr/SvJUKkMSJWiz68JITAFzsIOkzE+X7FA4c6xNjsbWGGvoso5G8VP
         8EMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975252; x=1795580052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eH3ClhP3K/6K4ti1IS/bnRGkykU5Vjlc6CVNj4XDITs=;
        b=OT2AQQIkCnuhbs+G5OHIJrsNhwrSfda3dkilGnc/x4gNMoCWFnntub9EaGCsSYbiqo
         02hrL/glfEno9f5TG+S9j7PsPMFMpe2KhXRCoTGog9Iqc/kr8gaYokJ8twJh4y8VxWac
         kXYRXQrX5hZqv3xBin1QbSj+5dfh0ahKlDAW4/mU/hMw9PCOx+k5JUCFKrEdT4Vz2RgW
         vDQMCrT8f+QWn9xlTRYF99KEzhba34LU6KJwu0cRvAHrqroFp5oSjmhVxNfOj4nsOEiI
         V78rUUFWwPU/TMVQ0J7nt44OfBvegIFObKG6lArFlUu93E8HSYyb4DqwndxTQxindY78
         K/EQ==
X-Gm-Message-State: APuU4Z8JUi9PYE6HAsdzySw5iQjlkDcj3f3RfLXWnmsUSF5HNeyq3Y76
	0bAlPy80r934a5Q7TP89DPNFuANHNnMBuNZfaAU91aNKAhTIu/Lmpl3zpSJZZwLj
X-Gm-Gg: AZFdTZfd1FAburjg3a1vHGcvAZ2PyY2l4gS7VYQBgn1VsW6EQm2Nd3he3gNOcG21o/m
	8/e3IqSkIb/TMvlGCmuoskklXaJZxuDw6DuU3nVdTA4AWqzrnwUVimmWwv84mVMOlPWcRByJjWk
	w+KL2SK5cGQ7Cg2o68xYMIWN5V0/ZweC/SRTcrRV+wvIfKIc7+VrHjkIbFoBkfnGvgVnchNQ9LB
	8wkg2+Ed653SBSUTNWQEGwUUnZmAfUozmUuSsaRBeRvpEt1gVJ0+uMcm308DfqTUSuxWByerbzb
	hwXReZYKPWNKVsAQxEIfDcQT6XJyZsOLlJv4wFKouFLByqyM0nY+cv5DfbMl9G1L/HprIkX5uiH
	hol32c+Q0lmAqbenfpFDlRWTfiWpkqoKkrfcOa3SurQ47CK578oGaeZriMr/h0Uv6GQde5Tza3k
	JQ7yQImqqJMemBMQcfbhWAS/DC7EcwvC7DkpE5/Wgzys2SsZnY0HJfp67GWN/78bZBmJUHzfHku
	USyKFXrl6HuhL/5IiN9V0ZfEhVJqwxvw2ZN1wENXj5ndWr9skSvaUldpDeBmTWIjxAHNvy6IwRf
	yiEuE4HEoth6gPQ9h4ZUJQ==
X-Received: by 2002:a17:902:f687:b0:2ef:d032:66fa with SMTP id d9443c01a7336-2eff73f1f15mr13070605ad.10.1794975252511;
        Tue, 17 Nov 2026 20:14:12 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:12 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 4/8] scsi: target: copy a DIF insert tuple across prot sgs
Date: Wed, 18 Nov 2026 12:13:07 +0800
Message-Id: <20261118041311.19011-5-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
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

sbc_dif_generate() writes a complete eight-byte t10_pi_tuple whenever
any bytes remain in a protection sg. A tuple split across entries can
therefore be written past the end of the first entry.

Copy each tuple through a stack object, walking the protection sgs as
needed. Read the existing tuple before updating it to preserve ref_tag
for protection types other than Type 1. This also checks that the full
tuple is available before writing any of it.

Stop generation on a truncated final tuple without changing the
caller's completion status.

KASAN reports:

  BUG: KASAN: use-after-free in sbc_dif_generate+0x20c/0x640 [target_core_mod]
  Write of size 4

  sbc_dif_generate
  target_complete_ok_work

Fixes: 66a3d5bc47d2 ("target/sbc: Add sbc_dif_generate software emulation")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 180 ++++++++++++++++++++++---------
 1 file changed, 131 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index adef903652ac2..780f526c4d931 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1250,72 +1250,154 @@ err:
 	return ret;
 }
 
+/*
+ * Copy one 8 byte PI tuple to or from the prot sg.  The data page sits
+ * above the prot map, so a prot sg change drops and restores it.  A
+ * short tail releases both maps and returns false.
+ */
+static bool
+sbc_dif_prot_copy(struct scatterlist **psgp, void **paddrp,
+		  unsigned int *poffp, struct scatterlist *dsg,
+		  void **daddrp, void *buf, bool to_prot)
+{
+	struct scatterlist *psg = *psgp;
+	void *paddr = *paddrp;
+	void *daddr = *daddrp;
+	unsigned int poff = *poffp;
+	unsigned int len = sizeof(struct t10_pi_tuple);
+	u8 *p = buf;
+
+	while (len) {
+		unsigned int take;
+
+		if (!psg || poff >= psg->length) {
+			if (daddr)
+				kunmap_atomic(daddr - dsg->offset);
+			if (paddr)
+				kunmap_atomic(paddr - psg->offset);
+			daddr = NULL;
+			paddr = NULL;
+			psg = psg ? sg_next(psg) : NULL;
+			if (!psg) {
+				*psgp = NULL;
+				*paddrp = NULL;
+				*daddrp = NULL;
+				return false;
+			}
+			poff = 0;
+			if (!psg->length)
+				continue;
+			paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		}
+
+		take = min_t(unsigned int, len, psg->length - poff);
+		if (to_prot)
+			memcpy(paddr + poff, p, take);
+		else
+			memcpy(p, paddr + poff, take);
+		p += take;
+		poff += take;
+		len -= take;
+	}
+
+	*psgp = psg;
+	*paddrp = paddr;
+	*poffp = poff;
+	*daddrp = daddr;
+	return true;
+}
+
 void
 sbc_dif_generate(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct t10_pi_tuple *sdt;
-	struct scatterlist *dsg = cmd->t_data_sg, *psg;
+	struct scatterlist *dsg = cmd->t_data_sg;
+	struct scatterlist *psg = cmd->t_prot_sg;
 	sector_t sector = cmd->t_task_lba;
 	void *daddr, *paddr;
-	int i, j, offset = 0;
+	unsigned int poff = 0;
+	int offset = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	if (!psg || !dsg)
+		return;
 
-		for (j = 0; j < psg->length;
-				j += sizeof(*sdt)) {
-			__u16 crc;
-			unsigned int avail;
+	paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+	daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
-			if (offset >= dsg->length) {
-				offset -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			}
+	for (;;) {
+		struct t10_pi_tuple sdt;
+		struct scatterlist *mark_psg;
+		unsigned int mark_off;
+		__u16 crc;
+		unsigned int avail;
 
-			sdt = paddr + j;
-			avail = min(block_size, dsg->length - offset);
-			crc = crc_t10dif(daddr + offset, avail);
-			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-				offset = block_size - avail;
-				crc = crc_t10dif_update(crc, daddr, offset);
-			} else {
-				offset += block_size;
-			}
+		if (poff >= psg->length && !sg_next(psg))
+			break;
 
-			sdt->guard_tag = cpu_to_be16(crc);
-			if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
-				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
-			sdt->app_tag = 0;
+		mark_psg = psg;
+		mark_off = poff;
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, dsg, &daddr,
+				       &sdt, false))
+			return;
+
+		if (offset >= dsg->length) {
+			offset -= dsg->length;
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_atomic(paddr - psg->offset);
+				return;
+			}
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		}
 
-			pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (cmd->data_direction == DMA_TO_DEVICE) ?
-				 "WRITE" : "READ", (unsigned long long)sector,
-				 sdt->guard_tag, sdt->app_tag,
-				 be32_to_cpu(sdt->ref_tag));
+		avail = min(block_size, dsg->length - offset);
+		crc = crc_t10dif(daddr + offset, avail);
+		if (avail < block_size) {
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_atomic(paddr - psg->offset);
+				return;
+			}
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+			offset = block_size - avail;
+			crc = crc_t10dif_update(crc, daddr, offset);
+		} else {
+			offset += block_size;
+		}
 
-			sector++;
+		sdt.guard_tag = cpu_to_be16(crc);
+		if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
+			sdt.ref_tag = cpu_to_be32(sector & 0xffffffff);
+		sdt.app_tag = 0;
+
+		pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
+			 " app_tag: 0x%04x ref_tag: %u\n",
+			 (cmd->data_direction == DMA_TO_DEVICE) ?
+			 "WRITE" : "READ", (unsigned long long)sector,
+			 sdt.guard_tag, sdt.app_tag,
+			 be32_to_cpu(sdt.ref_tag));
+
+		if (psg != mark_psg) {
+			kunmap_atomic(daddr - dsg->offset);
+			kunmap_atomic(paddr - psg->offset);
+			psg = mark_psg;
+			paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 		}
+		poff = mark_off;
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, dsg, &daddr,
+				       &sdt, true))
+			return;
 
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		sector++;
 	}
+
+	kunmap_atomic(daddr - dsg->offset);
+	kunmap_atomic(paddr - psg->offset);
 }
 
 static sense_reason_t
