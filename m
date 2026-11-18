Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975257;
	b=E524H82YQjeCk5hwqTdgKss2OYVUbJPmD6Ot7BDFIZJvL5f5S6BorLki7x8dFHuLQJae
	 qurvMPmnEQFrG4S7wlJGV9w9mYYE9vt+WkMwuW0r92kSI86jQbRLLbzRj9tsuMr9R1WK0
	 2Mc3o7kFxJO+6osUX0FjjklX4dYE4/hyUaC6JMOorOrmfTy+1Psupgy7aDa61PBgbFbzj
	 WLDQkI+H2SqLVKe9CWYw2HxLbLvNjuYNb5jS6IJAmZIgI120Tx9KsDYnIolK3+F4rjLlz
	 fiHJjbD+eNtazDOJDC5LryAjzAxnUKWX3Xgpqa0ZJM1yuylUDVJFx/Q50sl0lBernWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975257;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iArswCvl2LjsC7ZL9+rF2SjrTBAncR4rm+LB5wFBbbM=;
	b=S8z1HcXr4k3hzaFX1V8va1bakkgDn1r2txT6OUXREFMNho7o8WK6Q2od0cf1EsIanbYy
	 nkFpJ/ScfB4WKgdSGXAXbyrw8QO7T8PlZPdg5R4yrjJqeFcAa3vFAgpwrNy2OXtypyfY8
	 EXLUWCb5cLWYNjizIwmM3QHi1WsFvsRB0XlH6zJg8YERwgQ3V5h73B6AqN0q+K4LgIEqS
	 vWI6YM0PvsY01OhCRgJQ6aE8LoKi712L0c1z2s8PcPmjtvxUcRnWeNwlQduYCtOp+esHk
	 2xuAvZz3evKaOLvkugUTpXFngNqzZcR7UGRNVtmJE0okXI3RIDDeBuQMyJtAnMRcvFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDRbmZmF;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FD0606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3FD0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDRbmZmF
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e987a2ba0cso3550095ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975256; x=1795580056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iArswCvl2LjsC7ZL9+rF2SjrTBAncR4rm+LB5wFBbbM=;
        b=IDRbmZmFpODZX2t0AiqXHjmXH+UuD44aleFs8mw8Rgrspkue5Xq6jAAQhVPB6TJRvM
         BJ9/4TU7RckWxXeLIbETYdFw2NsOGoxJSxlaydVDd3tcrRMIoEOrbZ/bOYE5eyc+4fhK
         g91sSiBZ48odmrz55yPQovvLiGKkw3LrjX4nh1W/X11lI5htjPuvFqk3ZBD8ln7Qrwwg
         qzfHm+TjG2oXfiXDciZkFxK5exEUrRqRgGO+8zeaTdTOyQhOpjeqW5n0KtDLFI5G/Nfu
         sKQk+c/KpQVjPL0rRM/WwRRteGa4RAiPREgDUdMmww2OraRlCutzjS1DvQweLo7K4CzW
         XIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975256; x=1795580056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iArswCvl2LjsC7ZL9+rF2SjrTBAncR4rm+LB5wFBbbM=;
        b=oOo+In2evPNkjx2x6nFWbuMjkWFnEIcptPZt+9RUkGsumNQ4vBxzS+nM8wvfKHnazu
         XGnz+zSOQtOJuUonbVK3MAaOEQa1Fz/8c2+tWK84l5wDPyiCnKQ+QpE/JKA9TiVE4/rP
         +8KzxT2EKWctF5vY8S97TZ6ftoS8SPQ6ayZKAZL4kGN7+UwUr2m1vcrloCIps1EfAFEr
         6E8wvQnnZZyGCmHaaj6oOr1cEowoq2CHmemU6Sm2m5OBSPTkFuUzVkluXG5hyf+xw7wO
         dwgsUpfK25+ygyTvrmKOpWQxiLp/jGhd9bif+H7phsCbchXl8al85ropKnnKfJ4NFLyn
         GhHQ==
X-Gm-Message-State: APuU4Z9ia80GudZWCLxlmtYFgITRu9B2nB6+OcmBJrFnDX3ylk3bmcc7
	Zto9rZqamVdfmYogelMx6Ym4UPtPvtwGQEQ+xZcmSIZQ3RqBRMHH3erO
X-Gm-Gg: AZFdTZddUsx7wPKpBG6pbzdjrtKbURGRIOjSo2nF3Kb6y+ER2fU7SGyVhjX3BfRX1FU
	EsX+PqbUCbs2fNd5Eva8cEbOdr2e3Pd1No7SQwH/RrrdJp4+O/dY6mnBEIsQ1NL6le3viGrIo9M
	gLIZMM5kkEYrxkBGuGpHREMtAU5G2icA4O0quvumI+jF7yo+USlOo8nhqhiahcshs4dfe6bq+Z/
	prRKULPXNCH2vcRVax7XgebZyB6wL50Z/JEknyBs2kNSJ1OjUHEVC5rZ3Jo5o1FTed9sGAM1KX5
	er7/CYnr9to+8FJ4aw4s9vDaDtAbXHwzecyuJVt8LoIK71L7bBYvHyHALCTPqurUiCNDbR9akCy
	TQbBe9OlQN0WoVnGwzuO0RssEdfynEmNVzcfs3zVetGbdHK8lag0C65supc1hUnVXiZPfygVTGq
	rGqqZLKPJKr+GEd2tYtKrcXE/n27mx1TlmO+LTp2+hNUUFlzyTttIrAZVPustC/+Cssq5J/zItk
	NT+TxQo12TaNFsow0qP2+YhaBoWegeFWPtgGCkYq8/29Iwoco0ZmQCZqNqeKUU+Xw7qMYXUzOTu
	esiNQqYRp0jh9ka9/4A/eg==
X-Received: by 2002:a17:902:e54b:b0:2dd:ad74:ac28 with SMTP id d9443c01a7336-2eff73f8febmr13805005ad.26.1794975256187;
        Tue, 17 Nov 2026 20:14:16 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:15 -0800 (PST)
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
Subject: [PATCH v2 5/8] scsi: target: copy a DIF verify tuple across prot sgs
Date: Wed, 18 Nov 2026 12:13:08 +0800
Message-Id: <20261118041311.19011-6-physicalmtea@gmail.com>
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

sbc_dif_verify() enters its loop when any byte remains in a protection
sg, then accesses a complete eight-byte t10_pi_tuple. A tuple split
across entries can therefore be read past the end of the current sg.

Use the tuple-copy helper to assemble a complete tuple before checking
it. If the protection list ends partway through a tuple, return a
guard-check failure. Keep the data-cursor adjustment ahead of the
escape check so consecutive escaped blocks still advance the cursor.

KASAN reports:

  BUG: KASAN: use-after-free in sbc_dif_verify+0x5ab/0x790 [target_core_mod]
  Read of size 4

  sbc_dif_verify
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd

Fixes: 41861fa831af ("target/sbc: Add DIF TYPE1+TYPE3 read/write verify emulation")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 112 ++++++++++++++++---------------
 1 file changed, 58 insertions(+), 54 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 780f526c4d931..360a9af0cf66f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1491,81 +1491,85 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	       unsigned int ei_lba, struct scatterlist *psg, int psg_off)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct t10_pi_tuple *sdt;
 	struct scatterlist *dsg = cmd->t_data_sg;
 	sector_t sector = start;
 	void *daddr, *paddr;
-	int i;
 	sense_reason_t rc;
+	unsigned int poff = psg_off;
 	int dsg_off = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	if (!psg || !dsg)
+		return 0;
 
-		for (i = psg_off; i < psg->length &&
-				sector < start + sectors;
-				i += sizeof(*sdt)) {
-			__u16 crc;
-			unsigned int avail;
+	paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+	daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
-			if (dsg_off >= dsg->length) {
-				dsg_off -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return 0;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			}
+	while (sector < start + sectors) {
+		struct t10_pi_tuple sdt;
+		__u16 crc;
+		unsigned int avail;
 
-			sdt = paddr + i;
+		if (poff >= psg->length && !sg_next(psg))
+			break;
 
-			pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (unsigned long long)sector, sdt->guard_tag,
-				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, dsg, &daddr,
+				       &sdt, false)) {
+			cmd->sense_info = sector;
+			return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+		}
 
-			if (sdt->app_tag == T10_PI_APP_ESCAPE) {
-				dsg_off += block_size;
-				goto next;
+		if (dsg_off >= dsg->length) {
+			dsg_off -= dsg->length;
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_atomic(paddr - psg->offset);
+				return 0;
 			}
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		}
 
-			avail = min(block_size, dsg->length - dsg_off);
-			crc = crc_t10dif(daddr + dsg_off, avail);
-			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return 0;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-				dsg_off = block_size - avail;
-				crc = crc_t10dif_update(crc, daddr, dsg_off);
-			} else {
-				dsg_off += block_size;
-			}
+		pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
+			 " app_tag: 0x%04x ref_tag: %u\n",
+			 (unsigned long long)sector, sdt.guard_tag,
+			 sdt.app_tag, be32_to_cpu(sdt.ref_tag));
 
-			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
-			if (rc) {
-				kunmap_atomic(daddr - dsg->offset);
+		if (sdt.app_tag == T10_PI_APP_ESCAPE) {
+			dsg_off += block_size;
+			goto next;
+		}
+
+		avail = min(block_size, dsg->length - dsg_off);
+		crc = crc_t10dif(daddr + dsg_off, avail);
+		if (avail < block_size) {
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
 				kunmap_atomic(paddr - psg->offset);
-				cmd->sense_info = sector;
-				return rc;
+				return 0;
 			}
-next:
-			sector++;
-			ei_lba++;
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+			dsg_off = block_size - avail;
+			crc = crc_t10dif_update(crc, daddr, dsg_off);
+		} else {
+			dsg_off += block_size;
 		}
 
-		psg_off = 0;
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		rc = sbc_dif_v1_verify(cmd, &sdt, crc, sector, ei_lba);
+		if (rc) {
+			kunmap_atomic(daddr - dsg->offset);
+			kunmap_atomic(paddr - psg->offset);
+			cmd->sense_info = sector;
+			return rc;
+		}
+next:
+		sector++;
+		ei_lba++;
 	}
 
+	kunmap_atomic(daddr - dsg->offset);
+	kunmap_atomic(paddr - psg->offset);
 	return 0;
 }
 EXPORT_SYMBOL(sbc_dif_verify);
