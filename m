Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795402669;
	b=NmzSfnM7yHRLypScZxgJCmNTcUOenhcxxFZrSKAk62BvcXb5MYPWDe49iyR/wmuDMpM9
	 abeQl9IZckT5PM2UG92Ku6HCp053nKfRDsGGh6LqvVnnQ6dsUI4Km8VBcDQi/fRKCzWQ5
	 tXVVKKTMRn3Pix2FzLhdHGCSGonysqR2k6P/F44VGvrdCkrRYQiw4lbev3Dp6PsaHfSQG
	 KodRJHtwI/g/rmHcaWAYRi3rZVakGYYCCTZ1D4L3LlIC8IRaU4eW+iYTNtY3SoohhV3m9
	 eLelwvdr/G748oX3QtPD7fftDb8VzEufs/PLd5l2RwfHbJc83JwXr+/SHjZKbUORGEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795402669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=bLm68QDPa2RhRjjYUtOaDtc063dohvVN41bdUVpg0TE=;
	b=4a84WwgPhixBOc2PRWGb7Yki4SfIoQn9H0v2HiiwbKp8WmeRtEJP6nMXSs/1bdNNG/AU
	 VplQJquvghuA3ULLAUJEvAvdG1L6QQ4Fyqxbkh6Kf1S4nx9IbHEvf2R9VjFe9juRtuqHG
	 3b8uYaKP56KzK4hbHNZWL1Fv0zf3ntMY3njD/xInIMDKOqxCJGDG5IRBE+ZDP639L8pYG
	 bjGCTr3/e0ePOphVxHD2wmw1RJxfTgefscDJNB2+zhGlqvOQzwLIcqQmfFsQ61DEI5DG6
	 hqTuaz/kxnp4C2sxeCji5Tn25NBzNB9lYqPNfWh8R1LlCiU+zEAho9XsxxrnN28ssgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MqYCGATe;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4540606A31E
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 02:57:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4540606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MqYCGATe
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b41aa2b9a8so2063530a91.3
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2026 18:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795402668; x=1796007468; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bLm68QDPa2RhRjjYUtOaDtc063dohvVN41bdUVpg0TE=;
        b=MqYCGATepzYEtafcvmIyQQjkjXJeHWb2xod+telncm+SzE7zr+mYVnIkx5UqUaeFfx
         RS0jM8TaVCnm0oVah8bSJn8zATDAmARiLgP53pCrx00Gbm92YyEPZA38uFL1UmJ75iEB
         4Zvy7npMhf6uV+rR7Y+zKzK/kD1t0MqjRQVlVuot+Tg3jKRu5ow4MlrJdQthV4kIN5+X
         mVUTxYYebZsZS0/fvpY1Qyr5czGLC1xVSPhHkNGm1CmjcYr3sRc04vg1j8VcVhXNeQbf
         r8IYcacEPhy3WCkJ6s3wq6u+5AoxxQBVaY0R6uIHyL8vvnUO4VsiqAoelhk6aD3G8QzF
         CY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795402668; x=1796007468;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLm68QDPa2RhRjjYUtOaDtc063dohvVN41bdUVpg0TE=;
        b=mpJjmcqH4WEOKUFenHDWDISoVZ8n6gqA8kKw7Ze7rxv6asscZgZlL0N67vEMy2b5vq
         uTnHmaC61l6xGHHNrv6AMxUbzgzTYl1sTJwej8NhPs0g9Td4ENWp4MCIZh245BboHixS
         prMV88zDDleOdz0kiezdQuxQjNwaVSWgv50CnJcH2ItBjL45vRciQ6yWBTGF7Y3L3yQL
         4RKWzEAAZpOerMYOlXj4hxy0PtKa25Y31A7s717rzPvDQFJJmJXshPBPTKSNwZYIgQLK
         twg3jKjB+tYX13Edywe0wC7vrIh4UXQq84xmtks6Of8Kcvn/6nRqZI6fq8cWqXVlqrcA
         b3jA==
X-Gm-Message-State: APuU4Z9g9SpE8YEm0WKOevHYtinx/Fn1OScx/HMbHdIHA5fHPv2rCukz
	IKxfEeFF/TVydnCrTEO/bOWcjdIsiKA777YX9XyOmhhuKOOsCqpisk+/fKLgJscWC5udyKTcuTZ
	cemxIW9X9YYWZuhujVpO6/bE5pM7fS/SWlTaIBZ+zyeypGtYSpIhcKrVgXr/Il2QSlS7HJDOixz
	PFyy0OC4FVhvYWJJ8EH0qg5xp/OEtVjWvfHId+qQOuDmd/jntWdEvq
X-Received: from pjyl12.prod.google.com ([2002:a17:90a:ec0c:b0:3b4:1ffc:7a20])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:498c:b0:3b3:8b61:c44a with SMTP id 98e67ed59e1d1-3b41c7d5c1cmr7900978a91.4.1795402667813;
 Sun, 22 Nov 2026 18:57:47 -0800 (PST)
Date: Mon, 23 Nov 2026 10:57:33 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123025745.1743640-1-powenkao@google.com>
Subject: [PATCH] scsi: ufs: core: Add debugfs for PA TFS/FEC error counters
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Brian Kao <powenkao@google.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, John Garry <john.garry@linux.dev>, 
	Li Qiang <liqiang01@kylinos.cn>, open list <linux-kernel@vger.kernel.org>
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

Each file reads the corresponding local (host) or peer (device) PA
attribute and resets it to 0 when '0' is written. Per MIPI UniPro v3.0
Section 5.6.7, writing PA_TFS_RecErrorCountL clears the full 64-bit
PA_TFS_RecErrorCount counter, while reads sample the high/low words
using a bounded hi-lo-hi retry loop to avoid 32-bit rollover tearing.
These hardware counters increment only while the TFS/FEC path (1b1b
line coding) is active and may be reset across link startup, link-off
suspend, or host reset.

Because ufs_debugfs_hba_init() runs before hba->ufs_version and the
device descriptor are probed, support is checked at access time
(attached device W-LUN, UFSHCI >= 5.0, UFS device >= 5.0 for peer
entries, and UFSHCD_STATE_OPERATIONAL under host_sem). Positive UniPro
UIC command result codes from DME helpers are translated to standard
negative errno values before returning to userspace because seq_file
treats a positive ->show() return as SEQ_SKIP and a positive ->write()
return is interpreted as bytes written.

Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufs-debugfs.c | 215 +++++++++++++++++++++++++++++++++
 include/ufs/unipro.h           |   5 +
 2 files changed, 220 insertions(+)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 9f83628f3e2c..004d3c2ae11f 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -206,6 +206,219 @@ static const struct file_operations ufs_saved_err_fops = {
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
+static int ufs_pa_err_check_supported(struct ufs_hba *hba, u8 peer)
+{
+	if (!hba->ufs_device_wlun)
+		return -ENODEV;
+
+	if (hba->ufs_version < ufshci_version(5, 0) ||
+	    (peer == DME_PEER && hba->dev_info.wspecversion < 0x500))
+		return -EOPNOTSUPP;
+
+	return 0;
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
+	err = ufs_pa_err_check_supported(hba, attr->peer);
+	if (err)
+		return err;
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
+	err = ufs_pa_err_check_supported(hba, attr->peer);
+	if (err)
+		return err;
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
+static void ufs_debugfs_pa_err_init(struct ufs_hba *hba)
+{
+	static const struct {
+		const char *name;
+		const struct ufs_pa_err_attr *attrs;
+	} dirs[] = {
+		{ "host", ufs_host_pa_err_attrs },
+		{ "device", ufs_dev_pa_err_attrs },
+	};
+	const struct ufs_pa_err_attr *pa_attr;
+	struct dentry *pa_dir, *sub_dir;
+	unsigned int i;
+
+	pa_dir = debugfs_create_dir("pa_err_stats", hba->debugfs_root);
+	if (IS_ERR_OR_NULL(pa_dir))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(dirs); i++) {
+		sub_dir = debugfs_create_dir(dirs[i].name, pa_dir);
+		if (IS_ERR_OR_NULL(sub_dir))
+			continue;
+
+		d_inode(sub_dir)->i_private = hba;
+		for (pa_attr = dirs[i].attrs; pa_attr->name; pa_attr++)
+			debugfs_create_file(pa_attr->name, 0600, sub_dir,
+					    (void *)pa_attr,
+					    &ufs_pa_err_cnt_fops);
+	}
+}
+
 static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ "stats", 0400, &ufs_debugfs_stats_fops },
 	{ "saved_err", 0600, &ufs_saved_err_fops },
@@ -494,6 +707,8 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
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

base-commit: 08fec21faae44fe002467976befd68e6e62969b5
-- 
2.56.1.750.gf70dc682cf-goog

