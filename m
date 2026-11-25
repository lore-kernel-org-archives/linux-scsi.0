Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606522;
	b=RAsQ7FU0I1Hyu80yC8tpIx+a5R3QgODsgD8jno6FZxeZIxstHNjHslgkxcUmj18m33/v
	 sdvZG660KjDIS9Rih+nRpa+BegV9li2qwZdIPXycBGwu3uZMcrHV2DwUvBjWDQvMTuyBn
	 FtLavHgDb9oBHd8Bves5ycNvxWhI4F4tP9Z9WbYvCeynA1b+yDVK/3iozFIlkAqxw3zo9
	 AXK1z79ESYqnOzCjUJQ60tt5DojqUEVj3zZOazrvJnLGP4T/z+ki1cuQ0q0J6xDxsSTzy
	 yxww6hHilopIsISaOAxbvX1t5KIWrgPWhp1u3j9a7p21KBuxRH2KJ7F1ynX6nO2SjFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=F5GbJXNy2I8Y35zsER0NKITF5xwrl8SJ8GIitPAZ+TU=;
	b=ngQpHW5NVG9Irlt7ufTlxPRiO1HqkKzc+GK+ZKyDA3Z4cCRc/UniBpyI3ajiWsSl8lt7
	 37p2pWmdCpD1dRYVgFFbP4HdyAw9ZCYhb2jenHWmYgzEFKMDnirLQRWX1vKfP/lOXI0TQ
	 MQFfK/c3OF9oLOPTBwn+3p6sb133fnSI38GCwdt7Lxc9VWsh0MoN7p0DEcj/1x2cREZc+
	 yWf6CeMwXDpbdeJwd/HMpWjKKDgBXOnO8MCq6Y0KuxKJ0olT1NjY846YwLmv3HXh7DegL
	 GUoYIQ7VVq/iQmuqjgC3tOml+xRobRT+CkrswxdkWdH7EcQqPJz41DOAP3TkoZBlVQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Q/Zu0UzF";
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1036A606A329
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1036A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q/Zu0UzF
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so8848744eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795606521; x=1796211321; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F5GbJXNy2I8Y35zsER0NKITF5xwrl8SJ8GIitPAZ+TU=;
        b=Q/Zu0UzFMQSzn4VYfiVOh5JIYGjjCtv2on8CoYCFN8BOJgYJbEdJUHgcdKpFEAXVG0
         O2NJGUccsJvAK7bz3jHrkfrjZix/vWHJvWz6P/nJfV5hISuLXWuqeJECscUHKnVoQDRy
         A/rgNBSWyPnumlEfQVIvmKu8lMK9CnCFYFKdzSTkfc7msUXgKxc7eanLi1dEJH8tA8YP
         CkVmCd/BysRQiZIWtqOrOUtp2rb0b1jbRfLmWA/HVB1KaNANs8+NWVlyE43m/XYpteyo
         TpoNiT6/ElCC2sfSltORXp4TKHgbtZRGF3XjOKG4Dgcbm3zgIuCyVYNfovFXXHFa2FV2
         SrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795606521; x=1796211321;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F5GbJXNy2I8Y35zsER0NKITF5xwrl8SJ8GIitPAZ+TU=;
        b=d5Sw6xTRL/sR3PyLoZxhNqpGo/RlsbezMZCQ3sh8/2azJQPByQYXWi06+zCQqChalT
         Qz7x+qAPFQmiEaH/0BhqX8vNiaOVuMKKU3BEfCM5v8kM0MLtxyvEPoJgKuLE6TO7qbOS
         5hcsayo89crHowjaCOCH1PE8wMVPsG1IQ2itcls4PMVUPEv1CbVGkAN2QzkzklPZu/8S
         C1Y76GcGOBbvD+Un6mnqZCPlkakOtILZQxBuU9jN585RoCerpiAZnGWVn4SJtddUJZr9
         JEfcETyAR7ZCD+43WmwPiyQJO5ro5Fp815sSSnDDHulEpAxuiltDyADtVYhQvDUCWzS2
         Bl9A==
X-Gm-Message-State: APuU4Z+mBhe8vAWqTAVodN6iMlmm4YPOJRYS8vN3cJqWNd1kKFYZcwZY
	FT1mTLugcceq9/Lk+WON+NW4e+A9pb3muY93idZXG4yHcrqIboHKEnM1YbfbzQ+6aW04Zhe8CH9
	gKnhXFNBHysYcicU7Psk37tZd0j8LRBh2k8rT64LpjTT8ZwAq4JbcdLxtb5KifaAqiUOsl/XgQj
	UZpdpMfP/+hMLLVopy4FH3EtbDLtq+rZ2/tBlSMNhSAEz5STr0ZwuH
X-Received: from dyba9.prod.google.com ([2002:a05:693c:63c9:b0:386:a06c:3241])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:601e:b0:376:6aea:ab with SMTP id 5a478bee46e88-3856c5b58e2mr18609383eec.3.1795606520710;
 Wed, 25 Nov 2026 03:35:20 -0800 (PST)
Date: Wed, 25 Nov 2026 19:34:01 +0800
In-Reply-To: <20261125113435.1426680-1-powenkao@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125113435.1426680-1-powenkao@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125113435.1426680-4-powenkao@google.com>
Subject: [PATCH v3 3/3] scsi: ufs: core: Add debugfs for PA TFS/FEC error counters
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Randall Huang <huangrandall@google.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>, Li Qiang <liqiang01@kylinos.cn>, 
	John Garry <john.garry@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

MIPI UniPro v3.0 introduces the Transport Framing Structure (TFS) with
Reed-Solomon Forward Error Correction (FEC) in the Physical Adapter
(PA) layer, along with five PA MIB attributes (0x15C3-0x15C7) that
count TFS frames with uncorrectable FEC errors, TFS CRC errors, TFS
format errors, and 64-bit corrected FEC symbols. Exposing these
counters allows observing pre-FEC symbol correction and framing errors
for HS-G6 (1b1b) link-margin diagnostics without dropping the link.

Define the PA_TFS_* attributes and UFS_UNIPRO_VER_{2_0,3_0} in
include/ufs/unipro.h and expose the counters under debugfs:

  /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/
    - fec_err_cnt
    - crc_err_cnt
    - format_err_cnt
    - recovered_fec_symbols

Skip creation entirely on hosts setting UFSHCD_QUIRK_BROKEN_UIC_CMD.
Otherwise gate each subdirectory independently by UniPro version:
host/ is created when PA_LOCALVERINFO reports UniPro >= 3.0, and
device/ is created when PA_REMOTEVERINFO reports UniPro >= 3.0 (the
pa_err_stats parent directory is omitted if neither is supported).

Each file reads the local (host) or peer (device) PA attribute and
resets it to 0 when '0' is written. Because MIPI UniPro v3.0 does not
define hardware latching between PA_TFS_RecErrorCountL and
PA_TFS_RecErrorCountH, reads sample the high/low words with a bounded
hi-lo-hi retry loop to avoid 32-bit rollover tearing, while writing 0
to PA_TFS_RecErrorCountL clears the full 64-bit counter per Section
5.6.7. Positive UIC command result codes are translated to standard
negative errno values.

Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufs-debugfs.c | 230 ++++++++++++++++++++++++++++++++-
 include/ufs/unipro.h           |   9 +-
 2 files changed, 237 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index a3731dea11c7..4c8b6274434b 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -15,7 +15,10 @@ struct ufs_debugfs_attr {
 	const struct file_operations	*fops;
 };
 
-/* @file corresponds to a debugfs attribute in directory hba->debugfs_root. */
+/*
+ * @file corresponds to a debugfs attribute whose parent directory stores
+ * hba in i_private.
+ */
 static inline struct ufs_hba *hba_from_file(const struct file *file)
 {
 	return d_inode(file->f_path.dentry->d_parent)->i_private;
@@ -206,6 +209,229 @@ static const struct file_operations ufs_saved_err_fops = {
 	.release	= single_release,
 };
 
+#define UFS_PA_ERR_REC_READ_RETRIES	3
+
+struct ufs_pa_err_attr {
+	const char *name;
+	u32 mib_attr;
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
+	/*
+	 * MIPI UniPro v3.0 Section 5.6.7 defines PA_TFS_RecErrorCountH and
+	 * PA_TFS_RecErrorCountL as separate 32-bit MIB attributes without
+	 * latching the upper word on a low-word read. Sample hi-lo-hi to
+	 * avoid 32-bit rollover tearing.
+	 */
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
+	u8 peer = debugfs_get_aux_num(s->file);
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
+		err = ufs_pa_err_read_rec_cnt(hba, peer, &val);
+		if (!err)
+			seq_printf(s, "%llu\n", val);
+	} else {
+		u32 val;
+
+		err = ufshcd_dme_get_attr(hba, UIC_ARG_MIB(attr->mib_attr),
+					  &val, peer);
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
+	u8 peer = debugfs_get_aux_num(file);
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
+	 * Writing 0 resets the selected counter. For recovered_fec_symbols
+	 * (PA_TFS_RECERRORCOUNTL), setting the low word clears the entire
+	 * 64-bit PA_TFS_RecErrorCount counter per MIPI UniPro v3.0
+	 * Section 5.6.7.
+	 */
+	err = ufshcd_dme_set_attr(hba, UIC_ARG_MIB(attr->mib_attr),
+				  ATTR_SET_NOR, 0, peer);
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
+static const struct ufs_pa_err_attr ufs_pa_err_attrs[] = {
+	{ "fec_err_cnt", PA_TFS_FECERRORCOUNT },
+	{ "crc_err_cnt", PA_TFS_CRCERRORCOUNT },
+	{ "format_err_cnt", PA_TFS_FORMATERRORCOUNT },
+	{ "recovered_fec_symbols", PA_TFS_RECERRORCOUNTL },
+	{ }
+};
+
+static enum ufs_unipro_ver ufs_get_unipro_ver(struct ufs_hba *hba, u8 peer)
+{
+	u32 attr = peer == DME_PEER ? PA_REMOTEVERINFO : PA_LOCALVERINFO;
+	u32 val;
+
+	/* PA_REMOTEVERINFO is a local MIB attribute cached at link startup. */
+	if (ufshcd_dme_get(hba, UIC_ARG_MIB(attr), &val))
+		return UFS_UNIPRO_VER_RESERVED;
+
+	return val & UFS_UNIPRO_VER_MASK;
+}
+
+static void ufs_debugfs_pa_err_create_dir(struct ufs_hba *hba,
+					  struct dentry *parent,
+					  const char *name, u8 peer)
+{
+	const struct ufs_pa_err_attr *pa_attr;
+	struct dentry *sub_dir;
+
+	sub_dir = debugfs_create_dir(name, parent);
+	if (IS_ERR_OR_NULL(sub_dir))
+		return;
+
+	d_inode(sub_dir)->i_private = hba;
+	for (pa_attr = ufs_pa_err_attrs; pa_attr->name; pa_attr++)
+		debugfs_create_file_aux_num(pa_attr->name, 0600, sub_dir,
+					    (void *)pa_attr, peer,
+					    &ufs_pa_err_cnt_fops);
+}
+
+static void ufs_debugfs_pa_err_init(struct ufs_hba *hba)
+{
+	bool host_sup, dev_sup;
+	struct dentry *pa_dir;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return;
+
+	host_sup = ufs_get_unipro_ver(hba, DME_LOCAL) >= UFS_UNIPRO_VER_3_0;
+	dev_sup = ufs_get_unipro_ver(hba, DME_PEER) >= UFS_UNIPRO_VER_3_0;
+	if (!host_sup && !dev_sup)
+		return;
+
+	pa_dir = debugfs_create_dir("pa_err_stats", hba->debugfs_root);
+	if (IS_ERR_OR_NULL(pa_dir))
+		return;
+
+	if (host_sup)
+		ufs_debugfs_pa_err_create_dir(hba, pa_dir, "host", DME_LOCAL);
+	if (dev_sup)
+		ufs_debugfs_pa_err_create_dir(hba, pa_dir, "device", DME_PEER);
+}
+
 static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ "stats", 0400, &ufs_debugfs_stats_fops },
 	{ "saved_err", 0600, &ufs_saved_err_fops },
@@ -497,6 +723,8 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
 			   &hba->debugfs_ee_rate_limit_ms);
 
+	ufs_debugfs_pa_err_init(hba);
+
 	if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
 		return;
 
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..27f15ac7c0ef 100644
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
@@ -391,7 +396,9 @@ enum ufs_unipro_ver {
 	UFS_UNIPRO_VER_1_6  = 3, /* UniPro version 1.6 */
 	UFS_UNIPRO_VER_1_61 = 4, /* UniPro version 1.61 */
 	UFS_UNIPRO_VER_1_8  = 5, /* UniPro version 1.8 */
-	UFS_UNIPRO_VER_MAX  = 6, /* UniPro unsupported version */
+	UFS_UNIPRO_VER_2_0  = 6, /* UniPro version 2.0 */
+	UFS_UNIPRO_VER_3_0  = 7, /* UniPro version 3.0 */
+	UFS_UNIPRO_VER_MAX  = 8, /* UniPro unsupported version */
 	/* UniPro version field mask in PA_LOCALVERINFO */
 	UFS_UNIPRO_VER_MASK = 0xF,
 };
-- 
2.56.1.839.g22a8290db9-goog

