Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975242;
	b=odhbkfu6oHbFFzb05X9jXrpU50oC6TZHvP3S2B7DQQsf3rG61Pe/5TKXHfanX1IT3aBo
	 InUUBDa2+0OV4riFNQZxtkGKCt7TZhvyhXzk29XQICE9VEB8NDnpPs3dp85u/503kBHIt
	 gx7x69dTNYYI3eKq8vp7mP4hMG6ixMFkLC96Bq69jgElG1QIAQGEhpPzwjSFsloi/oK14
	 NjXc4F7I0Y4SnCOg8jKIZTH1YNWSDYzD+UxQht9J5H/HzUn3BOIgWq34bgn1+9UgtODzi
	 evcy6lQX0+7gwUTjmEgZI4/1dcZnRjRZu7EhnssOVn2qnqWWSo4LZ6xLCzGmoMVDRxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1tGDjTxgOOQgjqUI4QLTxVZiaieo9oTy+UBHWYy4gNM=;
	b=K2X2x++cIPLshxRCFqMlbg6cJxTcWjnUyYj6B6T4vgkWKyz80Xpz6JVKEznVtHu534Um
	 8GnfeuSlLNu/TbAPXlK37WbwNQ1svOjgTilgaL3CuT6IG9GNsG3EQROEDURsQ/Ho8C63T
	 +N5wXL6xfI3tHYm1pTCMCcHgHXZXhJYwXVzvwI0V/l22ZozfBXv9L4y0jZtMdW1ph3XII
	 sSReL36wSE03WnE7xXH1q6UVwLR4EubCgBIGdv1/zZv1lhS1g7/rNMPO0qR/aga12Rc7e
	 2PIxJLXeD2SYrDzdZ0LFYZ8WzfNKuYp7tPAwJiAcPTiO/BR8Y0M66WLGrvanw/AtUow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dwZrFfes;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7D606A331
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64D7D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dwZrFfes
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e977109392so3125435ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975242; x=1795580042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1tGDjTxgOOQgjqUI4QLTxVZiaieo9oTy+UBHWYy4gNM=;
        b=dwZrFfescLuDyXqWVdT3f0QbKnWaUoxNOVfV4Tr58kL4+/kqtxPGF/NQ9gzn+bbQEO
         Qk7U+LEv4EiTBX/zvyZXtd3GU87PKyYURw8Q6+xehN0MYV58sDbxhGMbXw8rdOVJLgb+
         1iVpx+EmINmScwm0/mY/NAAbVQnoUHUjyIiAyYSKO8AGoCLwwuui1gh8dKL1WFdl/sUd
         vNCSn3PGagivZwYIcEJxx1JxTFvgjiygIxm0owT6kUUHR0vNdXfjLfKs6FqkZ4R+Va/Y
         63Aj0P0WygXlrHiA0p9bZRB62eIQXbIv+mkx7BcdaC6f/l66o450TSP3R8CI84z5XWIk
         HLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975242; x=1795580042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1tGDjTxgOOQgjqUI4QLTxVZiaieo9oTy+UBHWYy4gNM=;
        b=I4fNS6e1tNAqD5hMctOpPz6/y3IWTQ6cqdsnfrsu3VxLenWu8JCqDwEuqTGhLp/9ga
         2n8rZXp5PeXfwldC+IPDJgg69vnxQguqXt4h+fB/vNqH5IIlqnPrd0NqsOjokRII994v
         F3y+P2qO1rCO7WE6eYpXtQ+kFicinZ/r8P5pA9l28Okh8DHtQSYrQ+LRvN8VI/Zn3Fz7
         oiCx/vnz9ySHbjClD5sfLHr0EIgt3MQZEI5Cb3zP9gI7l6IrXj8JdOsn53YgeIshM8p8
         5/s2Oqj7qDXZZhzxf8V9MHDKhndgDgtD6fJF5N/+iM9EWK+sUWV868wKGtG+zui+ivEz
         VFkw==
X-Gm-Message-State: APuU4Z+qVzdhmpCrnV4i53jrlSySOu/Y2BCDSKWVPFmcLaAmdDKQFXgW
	JXmuPDHT0EZCP5JGjleQNhnlpFP6Wvr8pLDRuKwx1beUfs218VkC0mej
X-Gm-Gg: AZFdTZfK7NvZHF8xyLcpxVQimL7tCxlrKIyJjsO8+PrN5HHA58OEdmhYpDoDpNR8GW8
	1dC47nC9AGxrzi+K5R06a8rkDCagJhSSpWc382VMSfQ8Kz8WA9GqUuP0Kc7u0C904+nHd/IInWn
	bAUHwJi3kglYl0wgMtzg5kdOpgheMqELjGGDX+amCC5YYti0bKxPfZKtT5iDi0BJoWURqM0RSww
	gGJCHfFRCOydrdi39nlc3GvET+jSto1WQlmGci1MDQ+X7Gb6oFMezTWJbRq98uxbQhwabJ/+dDo
	TNOYPTdKhckyiXROrTSSB96ClP8wBo9QAf+b4OEMTQA5DLo5zxw9vucEOQ2vmFgJSjK1Bp+CEkd
	URub2E6l4tVby5Bzz0wvhg969BTxF9Wg1TYISZxGfOolv/pfQz+G9s/uZt/EAzM3Zrixv404thb
	se5Mf6idgyvRvqTtQ1vdgMUAYEVEDDVSnKEsRJRvRy49Q/dh70+/Pxh6zTg5kMQcSoAnYkHBShW
	7Orr/oVRwY6oTWY5mdwXn73Shxcik766M5/iJo8s90wJx1jjxrYhb+xIUhYYNf6hCOxZFXgLAzG
	IFbr+PKpvQPGqOFnjhcQ3ls=
X-Received: by 2002:a17:903:2345:b0:2e9:5714:6079 with SMTP id d9443c01a7336-2eff754e83bmr14304455ad.31.1794975241606;
        Tue, 17 Nov 2026 20:14:01 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:01 -0800 (PST)
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
Subject: [PATCH v2 1/8] scsi: target: take COMPARE AND WRITE data from the write half
Date: Wed, 18 Nov 2026 12:13:04 +0800
Message-Id: <20261118041311.19011-2-physicalmtea@gmail.com>
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

For block sizes smaller than a page, compare_and_write_callback() adds
block_size to the first data sg's offset to locate the write half.
This assumes that both halves fit in that sg. If the compare buffer
ends at a page boundary, the write entry points past the page even
though the write data is available in the following sg.

vhost-scsi splits guest buffers into sg entries that each stay within
one page, so the backend can read beyond the supplied data.

Skip the compare bytes across the data sgs and build a table covering
the write half. Pass its actual entry count to the backend and release
it with sg_free_table(), including any chained allocations.

KASAN reports:

  BUG: KASAN: slab-use-after-free in copy_folio_from_iter_atomic
  Read of size 512

  compare_and_write_callback
  __target_execute_cmd
  sbc_execute_rw
  fd_execute_rw
  fd_do_rw
  vfs_iter_write
  copy_folio_from_iter_atomic

Fixes: d94e5a61357a ("target: fix COMPARE_AND_WRITE non zero SGL offset data corruption")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c       | 100 +++++++++++++++++--------
 drivers/target/target_core_transport.c |  11 ++-
 2 files changed, 80 insertions(+), 31 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb86d70c0..adef903652ac2 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -433,19 +433,74 @@ out:
 	return ret;
 }
 
+/*
+ * Data-out is compare bytes followed by write bytes.  Take the write
+ * half from whatever sg entries hold it.  Do not add block_size onto
+ * the first sg offset: that page may end before the write half.
+ */
+static int sbc_caw_build_write_sg(struct sg_table *tbl,
+				  struct scatterlist *data_sg,
+				  unsigned int data_nents, unsigned int skip,
+				  unsigned int len)
+{
+	struct scatterlist *sg, *out;
+	unsigned int nents = 0, left = len, left_skip = skip;
+	unsigned int avail, chunk;
+	int i;
+
+	for_each_sg(data_sg, sg, data_nents, i) {
+		if (!sg->length)
+			continue;
+		if (!left)
+			break;
+		if (left_skip >= sg->length) {
+			left_skip -= sg->length;
+			continue;
+		}
+		avail = sg->length - left_skip;
+		chunk = min(left, avail);
+		nents++;
+		left -= chunk;
+		left_skip = 0;
+	}
+	if (!nents || left)
+		return -EINVAL;
+
+	if (sg_alloc_table(tbl, nents, GFP_KERNEL))
+		return -ENOMEM;
+
+	left = len;
+	left_skip = skip;
+	out = tbl->sgl;
+	for_each_sg(data_sg, sg, data_nents, i) {
+		if (!sg->length)
+			continue;
+		if (!left)
+			break;
+		if (left_skip >= sg->length) {
+			left_skip -= sg->length;
+			continue;
+		}
+		avail = sg->length - left_skip;
+		chunk = min(left, avail);
+		sg_set_page(out, sg_page(sg), chunk, sg->offset + left_skip);
+		left -= chunk;
+		left_skip = 0;
+		out = sg_next(out);
+	}
+	return 0;
+}
+
 static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool success,
 						 int *post_ret)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct sg_table write_tbl = { };
 	struct scatterlist *write_sg;
-	struct sg_mapping_iter m;
-	unsigned int len;
-	unsigned int block_size = dev->dev_attrib.block_size;
-	unsigned int compare_len = (cmd->t_task_nolb * block_size);
+	unsigned int compare_len = (cmd->t_task_nolb * dev->dev_attrib.block_size);
 	unsigned int miscmp_off = 0;
 	sense_reason_t ret = TCM_NO_SENSE;
-	int i;
+	int rc;
 
 	if (!success) {
 		/*
@@ -499,34 +554,19 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	} else if (ret)
 		goto out;
 
-	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
-		pr_err("Unable to allocate compare_and_write sg\n");
-		ret = TCM_OUT_OF_RESOURCES;
+	rc = sbc_caw_build_write_sg(&write_tbl, cmd->t_data_sg,
+				    cmd->t_data_nents, compare_len,
+				    compare_len);
+	if (rc) {
+		pr_err("Unable to build compare_and_write sg\n");
+		if (rc == -ENOMEM)
+			ret = TCM_OUT_OF_RESOURCES;
+		else
+			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
 	}
 	write_sg = write_tbl.sgl;
 
-	i = 0;
-	len = compare_len;
-	sg_miter_start(&m, cmd->t_data_sg, cmd->t_data_nents, SG_MITER_TO_SG);
-	/*
-	 * Currently assumes NoLB=1 and SGLs are PAGE_SIZE..
-	 */
-	while (len) {
-		sg_miter_next(&m);
-
-		if (block_size < PAGE_SIZE) {
-			sg_set_page(&write_sg[i], m.page, block_size,
-				    m.piter.sg->offset + block_size);
-		} else {
-			sg_miter_next(&m);
-			sg_set_page(&write_sg[i], m.page, block_size,
-				    m.piter.sg->offset);
-		}
-		len -= block_size;
-		i++;
-	}
-	sg_miter_stop(&m);
 	/*
 	 * Save the original SGL + nents values before updating to new
 	 * assignments, to be released in transport_free_pages() ->
@@ -535,7 +575,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	cmd->t_data_sg_orig = cmd->t_data_sg;
 	cmd->t_data_sg = write_sg;
 	cmd->t_data_nents_orig = cmd->t_data_nents;
-	cmd->t_data_nents = 1;
+	cmd->t_data_nents = write_tbl.nents;
 
 	cmd->sam_task_attr = TCM_HEAD_TAG;
 	cmd->transport_complete_callback = compare_and_write_post;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcfe945949167..3cae5ed67d417 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
+#include <linux/scatterlist.h>
 #include <linux/unaligned.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -2724,10 +2725,18 @@ static inline void transport_reset_sgl_orig(struct se_cmd *cmd)
 	 * Check for saved t_data_sg that may be used for COMPARE_AND_WRITE
 	 * emulation, and free + reset pointers if necessary..
 	 */
+	struct sg_table table = { };
+
 	if (!cmd->t_data_sg_orig)
 		return;
 
-	kfree(cmd->t_data_sg);
+	/*
+	 * compare_and_write_callback() built this with sg_alloc_table().
+	 * Above SG_MAX_SINGLE_ALLOC the tail is a separate allocation.
+	 */
+	table.sgl = cmd->t_data_sg;
+	table.orig_nents = cmd->t_data_nents;
+	sg_free_table(&table);
 	cmd->t_data_sg = cmd->t_data_sg_orig;
 	cmd->t_data_sg_orig = NULL;
 	cmd->t_data_nents = cmd->t_data_nents_orig;
