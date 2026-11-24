Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483817;
	b=V/wHEh9KCWk05St4ghqKLqM/Nby/9ZMHDTcqOZPAqLdO+G+hlrHmq0JMP22/cHKt+5jD
	 TjlDOSliV5lykXV9WW0ckIvwobMcO+hZ4J7KMwegztMBFli25ceE7D7zbbCj11CKtX3LA
	 i+5BLlD+zJmGkKiksq5mGkTig5+nb283bJNUeDQg3XGNq3rtWYfrmBKfR80zxBL556aYb
	 v3rcMFjeu3OuMEuq5PMGuRRJnUL8KkIPGs0VzaC0pN/ECNo85YYGEjCGvqCD58erP/Iy9
	 65sOvgICU+zcxBVdR5dIQVgZ8fI++El0e5LSvHd59oFxIa+/HESgRfNDV8ZWQVPBf1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=2FIA87CiZS2yZ6BVy7ZaQJLxqkasxBGdfUSu6p0khMY=;
	b=ZKsjfC0rFUPhA11KZVl3EAqwlVWEU4uMantzVXg6opm+p0dwcA9BZMsFj6ukCanvgU3p
	 fusV/8OhZ3LtGQdzGwtQ7lqOYNOSHixdJV1bDAfFHAi6K1+uKN7Nt3uX5aLqyRcXzFGcq
	 lep+/9NO6/+ZFpWTgdjuEx5uks/7t5zbevQmhsZ7/mIWFz8Rfs5tvKkUQg/1snnAPx9jU
	 UvVeOwE7MxGuHyjKdvM/i7jmQoXKs84pKwyFNiUsKj7gkP7jcKMCSoUjOI/6TRilP225b
	 pdEgoZ24bV24ESb5mHDD8k4eIa38lL5vZIXbnvXOhxovAdYDSVW3o3uj5r4d4Cu+ZtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m7mZs3FU;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9503E606A321
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 01:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9503E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m7mZs3FU
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8b8cef34b43so4200742b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 17:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795483816; x=1796088616; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2FIA87CiZS2yZ6BVy7ZaQJLxqkasxBGdfUSu6p0khMY=;
        b=m7mZs3FUdyzTv4wdTDHTQXiA8tCJO3nHXniLtY0qg4HzN+yFVa2lGvsjBCCQ5Db2+e
         ktyKeMrtGeuG0emMOaQUx0g6Pg5s8x2SbcfsKVvpYw2MlJU9pAzdBoR9VNmCzKzfzHny
         dWv3+tySO8RnYJMvy8ykbCn4QrqI9WK91oott2sh6QDgHSpfaDTsbGAHcNa3ofGt20uL
         WGmCAq5qRi52fUZTjUdy/ZcJdCthwANggQkDKI0rCNlgBEzUKgINp5LLgz4nAEUQ0bPL
         zD3GCRh+jKW9p9oj3BMmxEUvRIYCzB8sK1n/uWi5tXBvDk1vPKXIjIwbPhku+LV0TS4P
         z0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795483816; x=1796088616;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2FIA87CiZS2yZ6BVy7ZaQJLxqkasxBGdfUSu6p0khMY=;
        b=EtttY2iuASUeipbA5b0tgPq0wRJX+HjLv+/fEttjuIYJPxj4/qC+4XgcEUKFUly61e
         RGAo20gloeHpyQF+XaZTXA1Spr1Wehb1I7NB9hUiVHOiQWOxpnBhNALMI+GntTvMRIzb
         WS5fr/k4BdwAoQLkgZBL44UzaYAs5ACuMDRZEiGl8fENHZN5gNH51p6wl9Dr04b2E54S
         gtveJytryBwWLmTL9DK10oFqgRW6BEP+Rt3P37zudaEe7SaNhixv1B/LpjnrgFhOvrnA
         g6pxontrQwK4N+bd0LuYdIay9bdgDy3AqoLA+V7DlCfqPSApXI02mNoyGWTA/DxMnqF+
         aJrw==
X-Gm-Message-State: APuU4Z8YYl60he7jzZ8Zk0iGd8MnVmVQdU+LGHirXBXWSeQRHG27JBEq
	DCBCmzYcL5ivR9Z70RMdx3xoIVXF9IfMfawZXzea5Ri3qJ1ySIZ4KMq8Zutr1k6GQky5adBGtfY
	JDxcgOumtqflz/RjG4hVSDtVfD5XB5HOtPoheMAI2Edvsm4Kh9uh1hVr1iuAemD2er5uPF1hKfl
	QCUtFfGnyF7bapuiIhDvcN0YYY1kDpnFuM/CHWzk56DC3MaZ9DfUxs
X-Received: from pfblo18.prod.google.com ([2002:a05:6a00:3d12:b0:891:63bf:32])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:10c7:b0:8a5:7006:1ecf with SMTP id d2e1a72fcca58-8c87c671b53mr12496620b3a.39.1795483815488;
 Mon, 23 Nov 2026 17:30:15 -0800 (PST)
Date: Tue, 24 Nov 2026 09:29:33 +0800
In-Reply-To: <20261124012951.3143833-1-powenkao@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261124012951.3143833-1-powenkao@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261124012951.3143833-3-powenkao@google.com>
Subject: [PATCH v2 2/2] scsi: ufs: core: Add debugfs for PA TFS/FEC error counters
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>, John Garry <john.garry@linux.dev>, 
	Li Qiang <liqiang01@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

MIPI UniPro v3.0 introduces the Transport Framing Structure (TFS) with
Reed-Solomon Forward Error Correction (FEC) in the Physical Adapter
(PA) layer, along with five PA MIB attributes (0x15C3-0x15C7) that
count TFS frames with uncorrectable FEC errors, TFS CRC errors, TFS
format errors, and 64-bit corrected FEC symbols. Exposing these
counters allows observing pre-FEC symbol correction and framing errors
for HS-G6 (1b1b) link-margin diagnostics without dropping the link.

Define the PA_TFS_* attributes in include/ufs/unipro.h and expose them
under debugfs:

  /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/
    - fec_err_cnt
    - crc_err_cnt
    - format_err_cnt
    - recovered_fec_symbols

Skip creation entirely on hosts setting UFSHCD_QUIRK_BROKEN_UIC_CMD.
Otherwise gate each subdirectory independently: host/ is created when
UFSHCI >= 5.0, and device/ is created when wSpecVersion >= 0x0500 (the
pa_err_stats parent directory is omitted if neither is supported).

Each file reads the local (host) or peer (device) PA attribute and
resets it to 0 when '0' is written. Writing PA_TFS_RecErrorCountL
clears the full 64-bit PA_TFS_RecErrorCount counter per MIPI UniPro
v3.0 Section 5.6.7, and reads sample the high/low words with a bounded
hi-lo-hi retry loop to avoid 32-bit rollover tearing. Positive UIC
command result codes are translated to standard negative errno values.

Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufs-debugfs.c | 211 +++++++++++++++++++++++++++++++++
 include/ufs/unipro.h           |   5 +
 2 files changed, 216 insertions(+)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e62b942b37dc..7913c824d49b 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -206,6 +206,215 @@ static const struct file_operations ufs_saved_err_fops = {
 	.release	= single_release,
 };
 
+#define UFS_PA_ERR_REC_READ_RETRIES	3
+
+struct ufs_pa_err_attr {
+	const char *name;
+	u32 mib_attr;
+	u8 peer;
+};
+
+static int ufs_dme_err_to_errno(int err)
+{
+	if (err <= 0)
+		return err;
+
+	switch (err) {
+	case UIC_CMD_RESULT_INVALID_ATTR:
+		return -EOPNOTSUPP;
+	case UIC_CMD_RESULT_INVALID_ATTR_VALUE:
+		return -EINVAL;
+	case UIC_CMD_RESULT_READ_ONLY_ATTR:
+		return -EPERM;
+	case UIC_CMD_RESULT_BUSY:
+		return -EBUSY;
+	default:
+		return -EIO;
+	}
+}
+
+static int ufs_pa_err_read_rec_cnt(struct ufs_hba *hba, u8 peer, u64 *val)
+{
+	u32 hi_before, lo, hi_after;
+	int err, retry;
+
+	for (retry = 0; retry < UFS_PA_ERR_REC_READ_RETRIES; retry++) {
+		err = ufshcd_dme_get_attr(hba,
+					  UIC_ARG_MIB(PA_TFS_RECERRORCOUNTH),
+					  &hi_before, peer);
+		if (err)
+			return ufs_dme_err_to_errno(err);
+
+		err = ufshcd_dme_get_attr(hba,
+					  UIC_ARG_MIB(PA_TFS_RECERRORCOUNTL),
+					  &lo, peer);
+		if (err)
+			return ufs_dme_err_to_errno(err);
+
+		err = ufshcd_dme_get_attr(hba,
+					  UIC_ARG_MIB(PA_TFS_RECERRORCOUNTH),
+					  &hi_after, peer);
+		if (err)
+			return ufs_dme_err_to_errno(err);
+
+		if (hi_before == hi_after) {
+			*val = ((u64)hi_after << 32) | lo;
+			return 0;
+		}
+	}
+
+	return -EAGAIN;
+}
+
+static int ufs_pa_err_cnt_show(struct seq_file *s, void *data)
+{
+	const struct ufs_pa_err_attr *attr = s->private;
+	struct ufs_hba *hba = hba_from_file(s->file);
+	int err;
+
+	if (!hba->ufs_device_wlun)
+		return -ENODEV;
+
+	err = ufs_debugfs_get_user_access(hba);
+	if (err)
+		return err;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (attr->mib_attr == PA_TFS_RECERRORCOUNTL) {
+		u64 val;
+
+		err = ufs_pa_err_read_rec_cnt(hba, attr->peer, &val);
+		if (!err)
+			seq_printf(s, "%llu\n", val);
+	} else {
+		u32 val;
+
+		err = ufshcd_dme_get_attr(hba, UIC_ARG_MIB(attr->mib_attr),
+					  &val, attr->peer);
+		err = ufs_dme_err_to_errno(err);
+		if (!err)
+			seq_printf(s, "%u\n", val);
+	}
+
+out:
+	ufs_debugfs_put_user_access(hba);
+	return err;
+}
+
+static ssize_t ufs_pa_err_cnt_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	const struct ufs_pa_err_attr *attr = file->f_inode->i_private;
+	struct ufs_hba *hba = hba_from_file(file);
+	unsigned int val;
+	int err;
+
+	if (!hba->ufs_device_wlun)
+		return -ENODEV;
+
+	err = kstrtouint_from_user(buf, count, 0, &val);
+	if (err)
+		return err;
+
+	if (val != 0)
+		return -EINVAL;
+
+	err = ufs_debugfs_get_user_access(hba);
+	if (err)
+		return err;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * Per MIPI UniPro v3.0 Section 5.6.7, setting PA_TFS_RecErrorCountL
+	 * clears the entire 64-bit PA_TFS_RecErrorCount counter to 0.
+	 */
+	err = ufshcd_dme_set_attr(hba, UIC_ARG_MIB(attr->mib_attr),
+				  ATTR_SET_NOR, 0, attr->peer);
+	err = ufs_dme_err_to_errno(err);
+
+out:
+	ufs_debugfs_put_user_access(hba);
+	return err ? err : count;
+}
+
+static int ufs_pa_err_cnt_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_pa_err_cnt_show, inode->i_private);
+}
+
+static const struct file_operations ufs_pa_err_cnt_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_pa_err_cnt_open,
+	.read		= seq_read,
+	.write		= ufs_pa_err_cnt_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct ufs_pa_err_attr ufs_host_pa_err_attrs[] = {
+	{ "fec_err_cnt", PA_TFS_FECERRORCOUNT, DME_LOCAL },
+	{ "crc_err_cnt", PA_TFS_CRCERRORCOUNT, DME_LOCAL },
+	{ "format_err_cnt", PA_TFS_FORMATERRORCOUNT, DME_LOCAL },
+	{ "recovered_fec_symbols", PA_TFS_RECERRORCOUNTL, DME_LOCAL },
+	{ }
+};
+
+static const struct ufs_pa_err_attr ufs_dev_pa_err_attrs[] = {
+	{ "fec_err_cnt", PA_TFS_FECERRORCOUNT, DME_PEER },
+	{ "crc_err_cnt", PA_TFS_CRCERRORCOUNT, DME_PEER },
+	{ "format_err_cnt", PA_TFS_FORMATERRORCOUNT, DME_PEER },
+	{ "recovered_fec_symbols", PA_TFS_RECERRORCOUNTL, DME_PEER },
+	{ }
+};
+
+static void ufs_debugfs_pa_err_create_dir(struct ufs_hba *hba,
+					  struct dentry *parent,
+					  const char *name,
+					  const struct ufs_pa_err_attr *attrs)
+{
+	const struct ufs_pa_err_attr *pa_attr;
+	struct dentry *sub_dir;
+
+	sub_dir = debugfs_create_dir(name, parent);
+	if (IS_ERR_OR_NULL(sub_dir))
+		return;
+
+	d_inode(sub_dir)->i_private = hba;
+	for (pa_attr = attrs; pa_attr->name; pa_attr++)
+		debugfs_create_file(pa_attr->name, 0600, sub_dir,
+				    (void *)pa_attr, &ufs_pa_err_cnt_fops);
+}
+
+static void ufs_debugfs_pa_err_init(struct ufs_hba *hba)
+{
+	bool host_sup = hba->ufs_version >= ufshci_version(5, 0);
+	bool dev_sup = hba->dev_info.wspecversion >= 0x500;
+	struct dentry *pa_dir;
+
+	if ((hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD) ||
+	    (!host_sup && !dev_sup))
+		return;
+
+	pa_dir = debugfs_create_dir("pa_err_stats", hba->debugfs_root);
+	if (IS_ERR_OR_NULL(pa_dir))
+		return;
+
+	if (host_sup)
+		ufs_debugfs_pa_err_create_dir(hba, pa_dir, "host",
+					      ufs_host_pa_err_attrs);
+	if (dev_sup)
+		ufs_debugfs_pa_err_create_dir(hba, pa_dir, "device",
+					      ufs_dev_pa_err_attrs);
+}
+
 static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ "stats", 0400, &ufs_debugfs_stats_fops },
 	{ "saved_err", 0600, &ufs_saved_err_fops },
@@ -494,6 +703,8 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
 			   &hba->debugfs_ee_rate_limit_ms);
 
+	ufs_debugfs_pa_err_init(hba);
+
 	if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
 		return;
 
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..b82f9a9e838f 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -200,6 +200,11 @@
 #define PA_PACPFRAMECOUNT	0x15C0
 #define PA_PACPERRORCOUNT	0x15C1
 #define PA_PHYTESTCONTROL	0x15C2
+#define PA_TFS_FECERRORCOUNT	0x15C3
+#define PA_TFS_CRCERRORCOUNT	0x15C4
+#define PA_TFS_FORMATERRORCOUNT	0x15C5
+#define PA_TFS_RECERRORCOUNTL	0x15C6
+#define PA_TFS_RECERRORCOUNTH	0x15C7
 #define PA_TXHSG4SYNCLENGTH	0x15D0
 #define PA_PEERRXHSG4ADAPTINITIAL		0x15D3
 #define PA_TXHSADAPTTYPE	0x15D4
-- 
2.56.1.809.ga0b61035b5-goog

