Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B44D2ECC;
	Wed, 29 Jul 2026 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336505; cv=none; b=cqKFc2N15C67AdtFMj7pYyXra0hNqByjGpee/v916w9js2ZSNfd7ZUekdtj+HW0fpdcZjojHSkI+i3QKecPQXNTGPFl2qY2YkT6xqapA/l+dkwcQnSi6D90yIF9j97ktqz5ZtldOmZa3U1x9YE8919UiBg3BPbOi4EbG7OEuFGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336505; c=relaxed/simple;
	bh=xLanNwlby7ApZwqrmT8Gx524VL75pS2+vIL6wKgL3rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJoeXNz3giOEEGL0vDe1Ygdq7Np88LarPkUc4Cur4Zgc9g0qcTPO+0kIKlzbtnS0x2eIV2sMtYkE7x8MKvLoRb1Bz/xhkwnvmFD9YNVYRco/7H+67DWowWOnCIfVouZ92pHHqBSQN/FG4KLc2XwauSN3mSSQKEwe38l+e7up11E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=cjASi6mP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fj6zWE+Y; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="cjASi6mP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fj6zWE+Y"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 08440EC0455;
	Wed, 29 Jul 2026 10:48:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 29 Jul 2026 10:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1785336502; x=
	1785422902; bh=myP4sKyD78EExUNmIKw5zozrdspuNEDwyMYDkHU0N4w=; b=c
	jASi6mPQ0WL2vj652fzfM9ZRouwUqrHtVyI2QNIUIAby/pApkexVj2/Q00rxi/Lp
	4gVt95rA0WOQsDu8mhi7vKiUmhsJfBZPPL4M94FLWJogPGB3Bi5uR2hdQsdGgFZx
	uUmGWoZePjoaFYSp4r4ZakCDdcQPfE6cDCKgnEkJ8dMbxSaJ+viDMWCJHPcZTBR4
	bIdwIT5DiMDz5uQW4JR3EmuDiJw8RZxon1brLLAiotw6IgOUOIYccz37diiFBovU
	jEEsLDh/AVY2omSIGTjq2NCr691M2vtiNzmu/irp7YW2SZd1Z8fzTl6tV5OG1z1F
	UjBz3wmQYOlZHdEn/gq+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1785336502; x=1785422902; bh=m
	yP4sKyD78EExUNmIKw5zozrdspuNEDwyMYDkHU0N4w=; b=fj6zWE+YAYsvXRPkC
	xWN5Cm9AiUSc5fnGNdWyULOUYj92fJ4grpbScL+JU8X4dIVMoRy3WYibnDt7SxEd
	/Mv1BXGSvJX7mXtWVX2X/KdGXnw+THDt1J5khG/gMC0rzctEQ/oR4YW7xBOKImYD
	fv/t8MFZ+yXYB2zy93r+OzyE0Fk3al5mtuQiCznQ2nw1ZDYsOAc+8lrrHcK2qVN5
	3+ALENbV8Zp6fzimoNPi3gNPuPRptLfV/nCG0dRf/ZmTTPvy1KNa6LEHlRHPb1Gr
	dOiYHcnPPBH0iIV5MnwpIJ1HFsgQ5VoT4bgbrk0voPQRnFO0iMICyZ9iQyM4rsE6
	N48eA==
X-ME-Sender: <xms:tRJqar9nKYSc80Gsd1ng6yEvmU515Y4gs0bwMC7rU8OeaX-UFUioqg>
    <xme:tRJqaoJ8jNAkE9g5koD2PUGJfrW2Xvnp4tjokZ3F2FrptzGOiVgLL6IJlrzr-hoAs
    aVZTa4r8kGGQAddH5fO0QDFdR7yrzs0-MStA5o3gZO3opIpz6-yVIj2>
X-ME-Received: <xmr:tRJqapvLjFC-FX4qJuvUMyE71Q46JHTall1bKAjib_NQtKf17_8nHqhG_Eo>
X-ME-Proxy-Cause: dmFkZTGdY+pN5mJnrgzNuvwmdIN4d0cDYSqljSTh2mUqdNx2KQRv8woOMZK16LHlSFcnbf
    jOSIBa0vThOogUDaEi+5ez1Xl0OPjIQRcIXIsJWxjizs3VRsx+PMpxZuahU5w78vSQBw9i
    3Lv5FqTUEpvJuokOw4iodBXccwzCLD4ZRijkOuGu1eENavOMhOVEQWqkDazNBk+um3UHA0
    J0NJPsou1iaRJ99lubBEIYzbve8QntDkpnxLlpvGY6S3eTIHghDIL3qydp/Iq0L3TgMM6o
    wqVqUx7M0KkZx0A+/5vyaVdxo+XeHtuOzcm4iYQ4h8b0QjyG7+mUvKbduYdqPutScAbJdb
    SEadwpcnUbScdNX9KLLzn4d859xn/qmjtBhghe2w/ASoba5CbB5e6tU5dE/4TeGnuETJy5
    FQskjqAeztVtB2ntuHJiT0m7urTBqWSMkUxknjQ91u3IWRQ5CZzmaN7ZsMR+UJ2Rkz5g/r
    Hfa8uENZJNzEsLHjqO7mLTFdW3zoVSKbgaEbl8JpR5s1zvdT7qKSbYun6urlP4QBMhx2oC
    nxHVK3m2w2GVzcKA9x1+lqwpVoe1djmiB2f5DlNav/CXAZT2hZlUD3hauAt/2D6WpISQX6
    drpPiFPZHXkV0D6xjNZAOMxeZZX6oag+sxmZgX2uEKRVLDX4uSX87eumKPJA
X-ME-Proxy: <xmx:tRJqavDZj18WfhEJowAM2k3q66uNAxeDNRjXQtVM7jvbJGksHLccEw>
    <xmx:tRJqahOk82qFBegixo9XAI5tKHnOrfGRK2KIam3IKGAIfVqL5lX9KQ>
    <xmx:tRJqanDvHlvyB7UsVfcXNEedvIqaWJxBChVk7U38cvC9ytALyCp96A>
    <xmx:tRJqaq5qqM5kUFu_msYhpGlDUbWmK_oYLeKvE1CzP0_7MXGUnPKzDQ>
    <xmx:thJqar4fnB5TdARMNw162enEIhbYTR9FbBMQLl-t1Oae3e9VJu08yBBx>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 10:48:21 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 5/5] scsi: lpfc: Replace strlcat() with sysfs_emit_at() in the sysfs show functions
Date: Wed, 29 Jul 2026 09:46:17 -0500
Message-ID: <20260729144617.1388646-6-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144617.1388646-1-icb@fastmail.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for removing the strlcat() API[1], replace its uses in
lpfc_cmf_info_show(), lpfc_nvme_info_show() and lpfc_scsi_stat_show().

The three functions build sysfs attribute output, and sysfs_emit_at()
is the designated helper for that. The single write paths become
sysfs_emit(), the offset zero form of the same helper. Each
intermediate tmp buffer and its per fragment overflow check become
unnecessary. Once the page is full, sysfs_emit_at() writes nothing
more, so dropping the early exits does not change the produced
bytes. Each loop that appends keeps one exit, so a full page stops
the iteration. In lpfc_nvme_info_show() the exit also releases the
fc_nodes_list_lock as it did before. The unlock_buf_done label loses
its last user and is removed.

The old code capped every fragment at LPFC_MAX_INFO_TMP_LEN or
LPFC_MAX_SCSI_INFO_TMP_LEN bytes before appending it. The replacement
formats each fragment directly into the page, so a fragment longer
than its old tmp buffer is no longer truncated when the page has room
for it. Both macros lose their last user and are removed.

The running length that sysfs_emit_at() maintains equals the length
that the removed strnlen() calls computed, so the "Could be more
info" overflow markers keep their trigger condition.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
The differential harness compared 60000 randomized cases, including
remote port lists that overflow the page and exercise the overflow
markers, and found byte identical output and return values
everywhere. The fragment cap removal described in the changelog
produces no byte difference in these three functions because the
fixed field widths keep every fragment below the old caps. The
starting strnlen() preserves the append semantics of the replaced
strlcat() instead of assuming an empty page. The KUnit corpus
confirmed the same as compiled kernel code, including the page
overflow marker path and both the target and initiator branches of
lpfc_nvme_info_show().

Notes on the removed per append overflow checks. The checks were
added by commit afff0d2321ea ("scsi: lpfc: Add Buffer overflow
check, when nvme_info larger than PAGE_SIZE") to stop a real
overflow. The snprintf() size arithmetic used before that commit
could go negative. sysfs_emit_at() removes that failure class by
construction. The offset is validated, every write is bounded
internally, and the accumulated length cannot exceed PAGE_SIZE - 1.
The 6314 truncation message added by the same commit keeps its
trigger condition.

Commit 79080d349f7f ("scsi: lpfc: correct rcu unlock issue in
lpfc_nvme_info_show") made the exits inside the remote port loop
release the lock, fixing a leak. The kept loop exit preserves that
property. A full page stops the iteration and releases the
fc_nodes_list_lock as before. The exit checks once per port instead
of after every append, so on the boundary the lock is held for at
most one port's worth of writeless appends longer than before.

A userspace timing comparison of the old and new function bodies,
extracted verbatim from the two trees, measured the conversion 1.5
to 1.8 times faster wherever the page does not overflow. The
strlcat() rescans dominate the old cost. Without the loop exits the
overflow path grew linearly with the remote port count while
holding the fc_nodes_list_lock. With them it stays flat and faster
than the old code in every measured case. Each remaining writeless
append after a full page costs about 170 nanoseconds, bounded by
the fragment count at a few microseconds per overflowed read.

 drivers/scsi/lpfc/lpfc_attr.c | 555 ++++++++++++++--------------------
 drivers/scsi/lpfc/lpfc_scsi.h |   3 -
 2 files changed, 230 insertions(+), 328 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f4e8164b94ab..bb5c84f0b787 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -57,7 +57,6 @@
 #define LPFC_MIN_DEVLOSS_TMO	1
 #define LPFC_MAX_DEVLOSS_TMO	255
 
-#define LPFC_MAX_INFO_TMP_LEN	100
 #define LPFC_INFO_MORE_STR	"\nCould be more info...\n"
 /*
  * Write key size should be multiple of 4. If write key is changed
@@ -126,133 +125,121 @@ lpfc_cmf_info_show(struct device *dev, struct device_attribute *attr,
 	int  len = 0;
 	int cpu;
 	u64 rcv, total;
-	char tmp[LPFC_MAX_INFO_TMP_LEN] = {0};
 
 	if (phba->cgn_i)
 		cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
 
-	scnprintf(tmp, sizeof(tmp),
-		  "Congestion Mgmt Info: E2Eattr %d Ver %d "
-		  "CMF %d cnt %d\n",
-		  phba->sli4_hba.pc_sli4_params.mi_cap,
-		  cp ? cp->cgn_info_version : 0,
-		  phba->sli4_hba.pc_sli4_params.cmf, phba->cmf_timer_cnt);
-
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len = strnlen(buf, PAGE_SIZE);
+	len += sysfs_emit_at(buf, len,
+			     "Congestion Mgmt Info: E2Eattr %d Ver %d CMF %d cnt %d\n",
+			     phba->sli4_hba.pc_sli4_params.mi_cap,
+			     cp ? cp->cgn_info_version : 0,
+			     phba->sli4_hba.pc_sli4_params.cmf,
+			     phba->cmf_timer_cnt);
 
 	if (!phba->sli4_hba.pc_sli4_params.cmf)
 		goto buffer_done;
 
 	switch (phba->cgn_init_reg_signal) {
 	case EDC_CG_SIG_WARN_ONLY:
-		scnprintf(tmp, sizeof(tmp),
-			  "Register: Init:  Signal:WARN  ");
+		len += sysfs_emit_at(buf, len,
+				     "Register: Init:  Signal:WARN  ");
 		break;
 	case EDC_CG_SIG_WARN_ALARM:
-		scnprintf(tmp, sizeof(tmp),
-			  "Register: Init:  Signal:WARN|ALARM  ");
+		len += sysfs_emit_at(buf, len,
+				     "Register: Init:  Signal:WARN|ALARM  ");
 		break;
 	default:
-		scnprintf(tmp, sizeof(tmp),
-			  "Register: Init:  Signal:NONE  ");
+		len += sysfs_emit_at(buf, len,
+				     "Register: Init:  Signal:NONE  ");
 		break;
 	}
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
 
 	switch (phba->cgn_init_reg_fpin) {
 	case LPFC_CGN_FPIN_WARN:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:WARN\n");
+		len += sysfs_emit_at(buf, len, "FPIN:WARN\n");
 		break;
 	case LPFC_CGN_FPIN_ALARM:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:ALARM\n");
+		len += sysfs_emit_at(buf, len, "FPIN:ALARM\n");
 		break;
 	case LPFC_CGN_FPIN_BOTH:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:WARN|ALARM\n");
+		len += sysfs_emit_at(buf, len, "FPIN:WARN|ALARM\n");
 		break;
 	default:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:NONE\n");
+		len += sysfs_emit_at(buf, len, "FPIN:NONE\n");
 		break;
 	}
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
 
 	switch (phba->cgn_reg_signal) {
 	case EDC_CG_SIG_WARN_ONLY:
-		scnprintf(tmp, sizeof(tmp),
-			  "       Current:  Signal:WARN  ");
+		len += sysfs_emit_at(buf, len,
+				     "       Current:  Signal:WARN  ");
 		break;
 	case EDC_CG_SIG_WARN_ALARM:
-		scnprintf(tmp, sizeof(tmp),
-			  "       Current:  Signal:WARN|ALARM  ");
+		len += sysfs_emit_at(buf, len,
+				     "       Current:  Signal:WARN|ALARM  ");
 		break;
 	default:
-		scnprintf(tmp, sizeof(tmp),
-			  "       Current:  Signal:NONE  ");
+		len += sysfs_emit_at(buf, len,
+				     "       Current:  Signal:NONE  ");
 		break;
 	}
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
 
 	switch (phba->cgn_reg_fpin) {
 	case LPFC_CGN_FPIN_WARN:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:WARN  ACQEcnt:%d\n", phba->cgn_acqe_cnt);
+		len += sysfs_emit_at(buf, len,
+				     "FPIN:WARN  ACQEcnt:%d\n",
+				     phba->cgn_acqe_cnt);
 		break;
 	case LPFC_CGN_FPIN_ALARM:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:ALARM  ACQEcnt:%d\n", phba->cgn_acqe_cnt);
+		len += sysfs_emit_at(buf, len,
+				     "FPIN:ALARM  ACQEcnt:%d\n",
+				     phba->cgn_acqe_cnt);
 		break;
 	case LPFC_CGN_FPIN_BOTH:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:WARN|ALARM  ACQEcnt:%d\n", phba->cgn_acqe_cnt);
+		len += sysfs_emit_at(buf, len,
+				     "FPIN:WARN|ALARM  ACQEcnt:%d\n",
+				     phba->cgn_acqe_cnt);
 		break;
 	default:
-		scnprintf(tmp, sizeof(tmp),
-			  "FPIN:NONE  ACQEcnt:%d\n", phba->cgn_acqe_cnt);
+		len += sysfs_emit_at(buf, len,
+				     "FPIN:NONE  ACQEcnt:%d\n",
+				     phba->cgn_acqe_cnt);
 		break;
 	}
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
 
 	if (phba->cmf_active_mode != phba->cgn_p.cgn_param_mode) {
 		switch (phba->cmf_active_mode) {
 		case LPFC_CFG_OFF:
-			scnprintf(tmp, sizeof(tmp), "Active: Mode:Off\n");
+			len += sysfs_emit_at(buf, len, "Active: Mode:Off\n");
 			break;
 		case LPFC_CFG_MANAGED:
-			scnprintf(tmp, sizeof(tmp), "Active: Mode:Managed\n");
+			len += sysfs_emit_at(buf, len,
+					     "Active: Mode:Managed\n");
 			break;
 		case LPFC_CFG_MONITOR:
-			scnprintf(tmp, sizeof(tmp), "Active: Mode:Monitor\n");
+			len += sysfs_emit_at(buf, len,
+					     "Active: Mode:Monitor\n");
 			break;
 		default:
-			scnprintf(tmp, sizeof(tmp), "Active: Mode:Unknown\n");
+			len += sysfs_emit_at(buf, len,
+					     "Active: Mode:Unknown\n");
 		}
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
 	}
 
 	switch (phba->cgn_p.cgn_param_mode) {
 	case LPFC_CFG_OFF:
-		scnprintf(tmp, sizeof(tmp), "Config: Mode:Off  ");
+		len += sysfs_emit_at(buf, len, "Config: Mode:Off  ");
 		break;
 	case LPFC_CFG_MANAGED:
-		scnprintf(tmp, sizeof(tmp), "Config: Mode:Managed ");
+		len += sysfs_emit_at(buf, len, "Config: Mode:Managed ");
 		break;
 	case LPFC_CFG_MONITOR:
-		scnprintf(tmp, sizeof(tmp), "Config: Mode:Monitor ");
+		len += sysfs_emit_at(buf, len, "Config: Mode:Monitor ");
 		break;
 	default:
-		scnprintf(tmp, sizeof(tmp), "Config: Mode:Unknown ");
+		len += sysfs_emit_at(buf, len, "Config: Mode:Unknown ");
 	}
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
 
 	total = 0;
 	rcv = 0;
@@ -262,24 +249,18 @@ lpfc_cmf_info_show(struct device *dev, struct device_attribute *attr,
 		rcv += atomic64_read(&cgs->rcv_bytes);
 	}
 
-	scnprintf(tmp, sizeof(tmp),
-		  "IObusy:%d Info:%d Bytes: Rcv:x%llx Total:x%llx\n",
-		  atomic_read(&phba->cmf_busy),
-		  phba->cmf_active_info, rcv, total);
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len,
+			     "IObusy:%d Info:%d Bytes: Rcv:x%llx Total:x%llx\n",
+			     atomic_read(&phba->cmf_busy),
+			     phba->cmf_active_info, rcv, total);
 
-	scnprintf(tmp, sizeof(tmp),
-		  "Port_speed:%d  Link_byte_cnt:%ld  "
-		  "Max_byte_per_interval:%ld\n",
-		  lpfc_sli_port_speed_get(phba),
-		  (unsigned long)phba->cmf_link_byte_count,
-		  (unsigned long)phba->cmf_max_bytes_per_interval);
-	strlcat(buf, tmp, PAGE_SIZE);
+	len += sysfs_emit_at(buf, len,
+			     "Port_speed:%d  Link_byte_cnt:%ld  Max_byte_per_interval:%ld\n",
+			     lpfc_sli_port_speed_get(phba),
+			     (unsigned long)phba->cmf_link_byte_count,
+			     (unsigned long)phba->cmf_max_bytes_per_interval);
 
 buffer_done:
-	len = strnlen(buf, PAGE_SIZE);
-
 	if (unlikely(len >= (PAGE_SIZE - 1))) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6312 Catching potential buffer "
@@ -480,17 +461,19 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	char *statep;
 	int i;
 	int len = 0;
-	char tmp[LPFC_MAX_INFO_TMP_LEN] = {0};
 
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
-		len = scnprintf(buf, PAGE_SIZE, "NVME Disabled\n");
+		len = sysfs_emit(buf, "NVME Disabled\n");
 		return len;
 	}
+
+	len = strnlen(buf, PAGE_SIZE);
+
 	if (phba->nvmet_support) {
 		if (!phba->targetport) {
-			len = scnprintf(buf, PAGE_SIZE,
-					"NVME Target: x%llx is not allocated\n",
-					wwn_to_u64(vport->fc_portname.u.wwn));
+			len = sysfs_emit(buf,
+					 "NVME Target: x%llx is not allocated\n",
+					 wwn_to_u64(vport->fc_portname.u.wwn));
 			return len;
 		}
 		/* Port state is only one of two values for now. */
@@ -498,167 +481,131 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 			statep = "REGISTERED";
 		else
 			statep = "INIT";
-		scnprintf(tmp, sizeof(tmp),
-			  "NVME Target Enabled  State %s\n",
-			  statep);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "%s%d WWPN x%llx WWNN x%llx DID x%06x\n",
-			  "NVME Target: lpfc",
-			  phba->brd_no,
-			  wwn_to_u64(vport->fc_portname.u.wwn),
-			  wwn_to_u64(vport->fc_nodename.u.wwn),
-			  phba->targetport->port_id);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		if (strlcat(buf, "\nNVME Target: Statistics\n", PAGE_SIZE)
-		    >= PAGE_SIZE)
-			goto buffer_done;
+		len += sysfs_emit_at(buf, len,
+				     "NVME Target Enabled  State %s\n",
+				     statep);
+
+		len += sysfs_emit_at(buf, len,
+				     "%s%d WWPN x%llx WWNN x%llx DID x%06x\n",
+				     "NVME Target: lpfc",
+				     phba->brd_no,
+				     wwn_to_u64(vport->fc_portname.u.wwn),
+				     wwn_to_u64(vport->fc_nodename.u.wwn),
+				     phba->targetport->port_id);
+
+		len += sysfs_emit_at(buf, len, "\nNVME Target: Statistics\n");
 
 		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-		scnprintf(tmp, sizeof(tmp),
-			  "LS: Rcv %08x Drop %08x Abort %08x\n",
-			  atomic_read(&tgtp->rcv_ls_req_in),
-			  atomic_read(&tgtp->rcv_ls_req_drop),
-			  atomic_read(&tgtp->xmt_ls_abort));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+		len += sysfs_emit_at(buf, len,
+				     "LS: Rcv %08x Drop %08x Abort %08x\n",
+				     atomic_read(&tgtp->rcv_ls_req_in),
+				     atomic_read(&tgtp->rcv_ls_req_drop),
+				     atomic_read(&tgtp->xmt_ls_abort));
 
 		if (atomic_read(&tgtp->rcv_ls_req_in) !=
 		    atomic_read(&tgtp->rcv_ls_req_out)) {
-			scnprintf(tmp, sizeof(tmp),
-				  "Rcv LS: in %08x != out %08x\n",
-				  atomic_read(&tgtp->rcv_ls_req_in),
-				  atomic_read(&tgtp->rcv_ls_req_out));
-			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+			len += sysfs_emit_at(buf, len,
+					     "Rcv LS: in %08x != out %08x\n",
+					     atomic_read(&tgtp->rcv_ls_req_in),
+					     atomic_read(&tgtp->rcv_ls_req_out));
 		}
 
-		scnprintf(tmp, sizeof(tmp),
-			  "LS: Xmt %08x Drop %08x Cmpl %08x\n",
-			  atomic_read(&tgtp->xmt_ls_rsp),
-			  atomic_read(&tgtp->xmt_ls_drop),
-			  atomic_read(&tgtp->xmt_ls_rsp_cmpl));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "LS: RSP Abort %08x xb %08x Err %08x\n",
-			  atomic_read(&tgtp->xmt_ls_rsp_aborted),
-			  atomic_read(&tgtp->xmt_ls_rsp_xb_set),
-			  atomic_read(&tgtp->xmt_ls_rsp_error));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "FCP: Rcv %08x Defer %08x Release %08x "
-			  "Drop %08x\n",
-			  atomic_read(&tgtp->rcv_fcp_cmd_in),
-			  atomic_read(&tgtp->rcv_fcp_cmd_defer),
-			  atomic_read(&tgtp->xmt_fcp_release),
-			  atomic_read(&tgtp->rcv_fcp_cmd_drop));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+		len += sysfs_emit_at(buf, len,
+				     "LS: Xmt %08x Drop %08x Cmpl %08x\n",
+				     atomic_read(&tgtp->xmt_ls_rsp),
+				     atomic_read(&tgtp->xmt_ls_drop),
+				     atomic_read(&tgtp->xmt_ls_rsp_cmpl));
+
+		len += sysfs_emit_at(buf, len,
+				     "LS: RSP Abort %08x xb %08x Err %08x\n",
+				     atomic_read(&tgtp->xmt_ls_rsp_aborted),
+				     atomic_read(&tgtp->xmt_ls_rsp_xb_set),
+				     atomic_read(&tgtp->xmt_ls_rsp_error));
+
+		len += sysfs_emit_at(buf, len,
+				     "FCP: Rcv %08x Defer %08x Release %08x Drop %08x\n",
+				     atomic_read(&tgtp->rcv_fcp_cmd_in),
+				     atomic_read(&tgtp->rcv_fcp_cmd_defer),
+				     atomic_read(&tgtp->xmt_fcp_release),
+				     atomic_read(&tgtp->rcv_fcp_cmd_drop));
 
 		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
 		    atomic_read(&tgtp->rcv_fcp_cmd_out)) {
-			scnprintf(tmp, sizeof(tmp),
-				  "Rcv FCP: in %08x != out %08x\n",
-				  atomic_read(&tgtp->rcv_fcp_cmd_in),
-				  atomic_read(&tgtp->rcv_fcp_cmd_out));
-			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+			len += sysfs_emit_at(buf, len,
+					     "Rcv FCP: in %08x != out %08x\n",
+					     atomic_read(&tgtp->rcv_fcp_cmd_in),
+					     atomic_read(&tgtp->rcv_fcp_cmd_out));
 		}
 
-		scnprintf(tmp, sizeof(tmp),
-			  "FCP Rsp: RD %08x rsp %08x WR %08x rsp %08x "
-			  "drop %08x\n",
-			  atomic_read(&tgtp->xmt_fcp_read),
-			  atomic_read(&tgtp->xmt_fcp_read_rsp),
-			  atomic_read(&tgtp->xmt_fcp_write),
-			  atomic_read(&tgtp->xmt_fcp_rsp),
-			  atomic_read(&tgtp->xmt_fcp_drop));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "FCP Rsp Cmpl: %08x err %08x drop %08x\n",
-			  atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
-			  atomic_read(&tgtp->xmt_fcp_rsp_error),
-			  atomic_read(&tgtp->xmt_fcp_rsp_drop));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "FCP Rsp Abort: %08x xb %08x xricqe  %08x\n",
-			  atomic_read(&tgtp->xmt_fcp_rsp_aborted),
-			  atomic_read(&tgtp->xmt_fcp_rsp_xb_set),
-			  atomic_read(&tgtp->xmt_fcp_xri_abort_cqe));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "ABORT: Xmt %08x Cmpl %08x\n",
-			  atomic_read(&tgtp->xmt_fcp_abort),
-			  atomic_read(&tgtp->xmt_fcp_abort_cmpl));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "ABORT: Sol %08x  Usol %08x Err %08x Cmpl %08x\n",
-			  atomic_read(&tgtp->xmt_abort_sol),
-			  atomic_read(&tgtp->xmt_abort_unsol),
-			  atomic_read(&tgtp->xmt_abort_rsp),
-			  atomic_read(&tgtp->xmt_abort_rsp_error));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-
-		scnprintf(tmp, sizeof(tmp),
-			  "DELAY: ctx %08x  fod %08x wqfull %08x\n",
-			  atomic_read(&tgtp->defer_ctx),
-			  atomic_read(&tgtp->defer_fod),
-			  atomic_read(&tgtp->defer_wqfull));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+		len += sysfs_emit_at(buf, len,
+				     "FCP Rsp: RD %08x rsp %08x WR %08x rsp %08x drop %08x\n",
+				     atomic_read(&tgtp->xmt_fcp_read),
+				     atomic_read(&tgtp->xmt_fcp_read_rsp),
+				     atomic_read(&tgtp->xmt_fcp_write),
+				     atomic_read(&tgtp->xmt_fcp_rsp),
+				     atomic_read(&tgtp->xmt_fcp_drop));
+
+		len += sysfs_emit_at(buf, len,
+				     "FCP Rsp Cmpl: %08x err %08x drop %08x\n",
+				     atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
+				     atomic_read(&tgtp->xmt_fcp_rsp_error),
+				     atomic_read(&tgtp->xmt_fcp_rsp_drop));
+
+		len += sysfs_emit_at(buf, len,
+				     "FCP Rsp Abort: %08x xb %08x xricqe  %08x\n",
+				     atomic_read(&tgtp->xmt_fcp_rsp_aborted),
+				     atomic_read(&tgtp->xmt_fcp_rsp_xb_set),
+				     atomic_read(&tgtp->xmt_fcp_xri_abort_cqe));
+
+		len += sysfs_emit_at(buf, len,
+				     "ABORT: Xmt %08x Cmpl %08x\n",
+				     atomic_read(&tgtp->xmt_fcp_abort),
+				     atomic_read(&tgtp->xmt_fcp_abort_cmpl));
+
+		len += sysfs_emit_at(buf, len,
+				     "ABORT: Sol %08x  Usol %08x Err %08x Cmpl %08x\n",
+				     atomic_read(&tgtp->xmt_abort_sol),
+				     atomic_read(&tgtp->xmt_abort_unsol),
+				     atomic_read(&tgtp->xmt_abort_rsp),
+				     atomic_read(&tgtp->xmt_abort_rsp_error));
+
+		len += sysfs_emit_at(buf, len,
+				     "DELAY: ctx %08x  fod %08x wqfull %08x\n",
+				     atomic_read(&tgtp->defer_ctx),
+				     atomic_read(&tgtp->defer_fod),
+				     atomic_read(&tgtp->defer_wqfull));
 
 		/* Calculate outstanding IOs */
 		tot = atomic_read(&tgtp->rcv_fcp_cmd_drop);
 		tot += atomic_read(&tgtp->xmt_fcp_release);
 		tot = atomic_read(&tgtp->rcv_fcp_cmd_in) - tot;
 
-		scnprintf(tmp, sizeof(tmp),
-			  "IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
-			  "CTX Outstanding %08llx\n\n",
-			  phba->sli4_hba.nvmet_xri_cnt,
-			  phba->sli4_hba.nvmet_io_wait_cnt,
-			  phba->sli4_hba.nvmet_io_wait_total,
-			  tot);
-		strlcat(buf, tmp, PAGE_SIZE);
+		len += sysfs_emit_at(buf, len,
+				     "IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
+				     "CTX Outstanding %08llx\n\n",
+				     phba->sli4_hba.nvmet_xri_cnt,
+				     phba->sli4_hba.nvmet_io_wait_cnt,
+				     phba->sli4_hba.nvmet_io_wait_total,
+				     tot);
 		goto buffer_done;
 	}
 
 	localport = vport->localport;
 	if (!localport) {
-		len = scnprintf(buf, PAGE_SIZE,
-				"NVME Initiator x%llx is not allocated\n",
-				wwn_to_u64(vport->fc_portname.u.wwn));
+		len = sysfs_emit(buf,
+				 "NVME Initiator x%llx is not allocated\n",
+				 wwn_to_u64(vport->fc_portname.u.wwn));
 		return len;
 	}
 	lport = (struct lpfc_nvme_lport *)localport->private;
-	if (strlcat(buf, "\nNVME Initiator Enabled\n", PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len, "\nNVME Initiator Enabled\n");
 
-	scnprintf(tmp, sizeof(tmp),
-		  "XRI Dist lpfc%d Total %d IO %d ELS %d\n",
-		  phba->brd_no,
-		  phba->sli4_hba.max_cfg_param.max_xri,
-		  phba->sli4_hba.io_xri_max,
-		  lpfc_sli4_get_els_iocb_cnt(phba));
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len,
+			     "XRI Dist lpfc%d Total %d IO %d ELS %d\n",
+			     phba->brd_no,
+			     phba->sli4_hba.max_cfg_param.max_xri,
+			     phba->sli4_hba.io_xri_max,
+			     lpfc_sli4_get_els_iocb_cnt(phba));
 
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
@@ -666,15 +613,13 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	else
 		statep = "UNKNOWN ";
 
-	scnprintf(tmp, sizeof(tmp),
-		  "%s%d WWPN x%llx WWNN x%llx DID x%06x %s\n",
-		  "NVME LPORT lpfc",
-		  phba->brd_no,
-		  wwn_to_u64(vport->fc_portname.u.wwn),
-		  wwn_to_u64(vport->fc_nodename.u.wwn),
-		  localport->port_id, statep);
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len,
+			     "%s%d WWPN x%llx WWNN x%llx DID x%06x %s\n",
+			     "NVME LPORT lpfc",
+			     phba->brd_no,
+			     wwn_to_u64(vport->fc_portname.u.wwn),
+			     wwn_to_u64(vport->fc_nodename.u.wwn),
+			     localport->port_id, statep);
 
 	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 
@@ -702,77 +647,55 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		}
 
 		/* Tab in to show lport ownership. */
-		if (strlcat(buf, "NVME RPORT       ", PAGE_SIZE) >= PAGE_SIZE)
-			goto unlock_buf_done;
-		if (phba->brd_no >= 10) {
-			if (strlcat(buf, " ", PAGE_SIZE) >= PAGE_SIZE)
-				goto unlock_buf_done;
-		}
+		len += sysfs_emit_at(buf, len, "NVME RPORT       ");
+		if (phba->brd_no >= 10)
+			len += sysfs_emit_at(buf, len, " ");
 
-		scnprintf(tmp, sizeof(tmp), "WWPN x%llx ",
-			  nrport->port_name);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto unlock_buf_done;
+		len += sysfs_emit_at(buf, len, "WWPN x%llx ",
+				     nrport->port_name);
 
-		scnprintf(tmp, sizeof(tmp), "WWNN x%llx ",
-			  nrport->node_name);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto unlock_buf_done;
+		len += sysfs_emit_at(buf, len, "WWNN x%llx ",
+				     nrport->node_name);
 
-		scnprintf(tmp, sizeof(tmp), "DID x%06x ",
-			  nrport->port_id);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto unlock_buf_done;
+		len += sysfs_emit_at(buf, len, "DID x%06x ",
+				     nrport->port_id);
 
 		/* An NVME rport can have multiple roles. */
-		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR) {
-			if (strlcat(buf, "INITIATOR ", PAGE_SIZE) >= PAGE_SIZE)
-				goto unlock_buf_done;
-		}
-		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET) {
-			if (strlcat(buf, "TARGET ", PAGE_SIZE) >= PAGE_SIZE)
-				goto unlock_buf_done;
-		}
-		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY) {
-			if (strlcat(buf, "DISCSRVC ", PAGE_SIZE) >= PAGE_SIZE)
-				goto unlock_buf_done;
-		}
+		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR)
+			len += sysfs_emit_at(buf, len, "INITIATOR ");
+		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET)
+			len += sysfs_emit_at(buf, len, "TARGET ");
+		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY)
+			len += sysfs_emit_at(buf, len, "DISCSRVC ");
 		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
 					  FC_PORT_ROLE_NVME_TARGET |
-					  FC_PORT_ROLE_NVME_DISCOVERY)) {
-			scnprintf(tmp, sizeof(tmp), "UNKNOWN ROLE x%x",
-				  nrport->port_role);
-			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto unlock_buf_done;
-		}
+					  FC_PORT_ROLE_NVME_DISCOVERY))
+			len += sysfs_emit_at(buf, len, "UNKNOWN ROLE x%x",
+					     nrport->port_role);
+
+		len += sysfs_emit_at(buf, len, "%s\n", statep);
 
-		scnprintf(tmp, sizeof(tmp), "%s\n", statep);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto unlock_buf_done;
+		if (len >= PAGE_SIZE - 1)
+			break;
 	}
 	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 
 	if (!lport)
 		goto buffer_done;
 
-	if (strlcat(buf, "\nNVME Statistics\n", PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len, "\nNVME Statistics\n");
 
-	scnprintf(tmp, sizeof(tmp),
-		  "LS: Xmt %010x Cmpl %010x Abort %08x\n",
-		  atomic_read(&lport->fc4NvmeLsRequests),
-		  atomic_read(&lport->fc4NvmeLsCmpls),
-		  atomic_read(&lport->xmt_ls_abort));
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len,
+			     "LS: Xmt %010x Cmpl %010x Abort %08x\n",
+			     atomic_read(&lport->fc4NvmeLsRequests),
+			     atomic_read(&lport->fc4NvmeLsCmpls),
+			     atomic_read(&lport->xmt_ls_abort));
 
-	scnprintf(tmp, sizeof(tmp),
-		  "LS XMIT: Err %08x  CMPL: xb %08x Err %08x\n",
-		  atomic_read(&lport->xmt_ls_err),
-		  atomic_read(&lport->cmpl_ls_xb),
-		  atomic_read(&lport->cmpl_ls_err));
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+	len += sysfs_emit_at(buf, len,
+			     "LS XMIT: Err %08x  CMPL: xb %08x Err %08x\n",
+			     atomic_read(&lport->xmt_ls_err),
+			     atomic_read(&lport->cmpl_ls_xb),
+			     atomic_read(&lport->cmpl_ls_err));
 
 	totin = 0;
 	totout = 0;
@@ -785,40 +708,25 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		data3 = cstat->control_requests;
 		totout += (data1 + data2 + data3);
 	}
-	scnprintf(tmp, sizeof(tmp),
-		  "Total FCP Cmpl %016llx Issue %016llx "
-		  "OutIO %016llx\n",
-		  totin, totout, totout - totin);
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
-
-	scnprintf(tmp, sizeof(tmp),
-		  "\tabort %08x noxri %08x nondlp %08x qdepth %08x "
-		  "wqerr %08x err %08x\n",
-		  atomic_read(&lport->xmt_fcp_abort),
-		  atomic_read(&lport->xmt_fcp_noxri),
-		  atomic_read(&lport->xmt_fcp_bad_ndlp),
-		  atomic_read(&lport->xmt_fcp_qdepth),
-		  atomic_read(&lport->xmt_fcp_wqerr),
-		  atomic_read(&lport->xmt_fcp_err));
-	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
-
-	scnprintf(tmp, sizeof(tmp),
-		  "FCP CMPL: xb %08x Err %08x\n",
-		  atomic_read(&lport->cmpl_fcp_xb),
-		  atomic_read(&lport->cmpl_fcp_err));
-	strlcat(buf, tmp, PAGE_SIZE);
-
-	/* host_lock is already unlocked. */
-	goto buffer_done;
-
- unlock_buf_done:
-	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
+	len += sysfs_emit_at(buf, len,
+			     "Total FCP Cmpl %016llx Issue %016llx OutIO %016llx\n",
+			     totin, totout, totout - totin);
+
+	len += sysfs_emit_at(buf, len,
+			     "\tabort %08x noxri %08x nondlp %08x qdepth %08x wqerr %08x err %08x\n",
+			     atomic_read(&lport->xmt_fcp_abort),
+			     atomic_read(&lport->xmt_fcp_noxri),
+			     atomic_read(&lport->xmt_fcp_bad_ndlp),
+			     atomic_read(&lport->xmt_fcp_qdepth),
+			     atomic_read(&lport->xmt_fcp_wqerr),
+			     atomic_read(&lport->xmt_fcp_err));
+
+	len += sysfs_emit_at(buf, len,
+			     "FCP CMPL: xb %08x Err %08x\n",
+			     atomic_read(&lport->cmpl_fcp_xb),
+			     atomic_read(&lport->cmpl_fcp_err));
 
  buffer_done:
-	len = strnlen(buf, PAGE_SIZE);
-
 	if (unlikely(len >= (PAGE_SIZE - 1))) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
 				"6314 Catching potential buffer "
@@ -844,13 +752,12 @@ lpfc_scsi_stat_show(struct device *dev, struct device_attribute *attr,
 	u64 data1, data2, data3;
 	u64 tot, totin, totout;
 	int i;
-	char tmp[LPFC_MAX_SCSI_INFO_TMP_LEN] = {0};
 
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP) ||
 	    (phba->sli_rev != LPFC_SLI_REV4))
 		return 0;
 
-	scnprintf(buf, PAGE_SIZE, "SCSI HDWQ Statistics\n");
+	len = sysfs_emit(buf, "SCSI HDWQ Statistics\n");
 
 	totin = 0;
 	totout = 0;
@@ -863,22 +770,20 @@ lpfc_scsi_stat_show(struct device *dev, struct device_attribute *attr,
 		data3 = cstat->control_requests;
 		totout += (data1 + data2 + data3);
 
-		scnprintf(tmp, sizeof(tmp), "HDWQ (%d): Rd %016llx Wr %016llx "
-			  "IO %016llx ", i, data1, data2, data3);
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+		len += sysfs_emit_at(buf, len,
+				     "HDWQ (%d): Rd %016llx Wr %016llx IO %016llx ",
+				     i, data1, data2, data3);
 
-		scnprintf(tmp, sizeof(tmp), "Cmpl %016llx OutIO %016llx\n",
-			  tot, ((data1 + data2 + data3) - tot));
-		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
-	}
-	scnprintf(tmp, sizeof(tmp), "Total FCP Cmpl %016llx Issue %016llx "
-		  "OutIO %016llx\n", totin, totout, totout - totin);
-	strlcat(buf, tmp, PAGE_SIZE);
+		len += sysfs_emit_at(buf, len,
+				     "Cmpl %016llx OutIO %016llx\n",
+				     tot, ((data1 + data2 + data3) - tot));
 
-buffer_done:
-	len = strnlen(buf, PAGE_SIZE);
+		if (len >= PAGE_SIZE - 1)
+			break;
+	}
+	len += sysfs_emit_at(buf, len,
+			     "Total FCP Cmpl %016llx Issue %016llx OutIO %016llx\n",
+			     totin, totout, totout - totin);
 
 	return len;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index a05d203e4777..3e0937cf3ff3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -158,6 +158,3 @@ struct fcp_cmnd32 {
 
 #define TXRDY_PAYLOAD_LEN	12
 
-/* For sysfs/debugfs tmp string max len */
-#define LPFC_MAX_SCSI_INFO_TMP_LEN	79
-
-- 
2.47.3

