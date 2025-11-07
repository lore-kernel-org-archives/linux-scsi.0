Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4F82FCC01;
	Fri,  7 Nov 2025 23:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762556917; cv=pass; b=JBKi2wWBh5dRCm45IjTlysBaZkC+fiOdUp1pck7SP4Jfci2hBRRrPRVLQESfSOT+UDLRAGnDJJPBeeajednU5OZs7QhitAawB/zIScu2R59AXvfOqqbxSHDm1k+pYSIAnOt6vEtedkUgn+GvMTlqT8GS+QYMx+T5FNg3TpC96Ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762556917; c=relaxed/simple;
	bh=egoiJtwPjZGIOorc5g5Af/WNfUoMyIkVsLrAX+1kAdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJPtqYfQBrmOoNIj7l3LmyB+jI7Guqzz3mtLtitPsBEwDlDKqSY2EgWAH9ngwGG/CTrS8QgEBECfoc2900SoB5NtQ7J3cOwVft9h3ga3gt6rFRXv7Umy8ZHpQ5zQSGhaH0T3+f+kz3aCAQRYInUCGrYRQrdOlSFgSdMxZIxh0vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=RxuZyXCy; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=0PeoL4oc; arc=pass smtp.client-ip=85.215.255.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="RxuZyXCy";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="0PeoL4oc"
ARC-Seal: i=1; a=rsa-sha256; t=1762556733; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=bn7gRN6N9076q8VlX6FhFj3J2oEp2fRkbLXGPFCU6PavVDcKyGo8kofRpwXwhs62mN
    YWiyaua4bVh0Ui0EiGYKM3wh3jzsrF7fRm7oS4n+P9pU/Oaaxrmg9weX7VP5gvKxDND7
    qUpdD/t5sIsHQw57bNCqvmtelS38DMNhI1Ya9ZhVdi6t8o6uwUbZXQ+WdI8EcG3o/SPU
    zLbwGmWnc4pepqaAV9GldNBwabpXfQybRavms98Rskod0w/VSmFKMi3KV4AIaptVoUWL
    KGKgkS4SF60ULaJi9KQotRUK20JgJiecf9BIwF0ZPzEYQ3eYCOBRaZECpGx2S5r+kYqG
    rn7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1762556733;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=n8p4GaEJUPyQ5WHhjeoHGpZO1UdnQvpCL1hsdbJ9Isw=;
    b=XutjK/c4Bu236dxb8Q9Oo/y13HAk+16jKC/ttTlDxjD5t3vWsfd+Mcv0tWy4FLwGOf
    NIbhFcE7SKsnSImHMd3VQ1AtB9Pj4D3IeduJupsVMBe6DHQ6X3ZTG0oNozga35MkIheN
    pYsLEliKJ6hss8CM/FbcDR/t/uLnwm5X2LINZdNgaedE/6CboCfCahaRBVKJq2icl6Gx
    7znxMv6XS3JkGIpVc/XGdCVVuKSsWUP+gF7RcsTcyGfJzLJkryHHGoGvxb8Oi6XjxCEP
    68FhQKNSZKKos1KHyRYHR5G3pr9ChVJW+L+Z8YlaRc+YpNhusMmPdebHEwuv8XW0bCwS
    vLzg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1762556733;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=n8p4GaEJUPyQ5WHhjeoHGpZO1UdnQvpCL1hsdbJ9Isw=;
    b=RxuZyXCymjI0GLWS5o00cpWEcqPyJRLIofP6OdVqoKQpQA578P4kAR63CW4DoyOU0N
    0rQ5rE7nXGddeSy07yAX7uJ29Csb1xm4k/3SQuHsaUN05itNT3dZNZt1ZKeSee2f0uMx
    am2G1ikQzyQhm+rEuh+hAFhd1wqOVH3cqZ9zHHZwEQQ9RS+TGJpMmbm12bb7gx7kqr/0
    GO7+N4LhUdL58i0FVafSPiS56yB7WMTIefp0fkkzduzNWqEBx5cBy7A+SVJcm1NfEcGJ
    2Ce8x7p3zC6ls+vOj23dw0VBjZOsfpuEnZDxQ2BGJEFOx9qRVYSQRKcyQD/tgHNjRK5L
    OuwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1762556733;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=n8p4GaEJUPyQ5WHhjeoHGpZO1UdnQvpCL1hsdbJ9Isw=;
    b=0PeoL4ocklz0+TK2H3NG35dks7klZ724DJ7oo1hVmrE3gEfng6ZQdVKzH2/oqPIkF3
    bAkKA7ZreGGGot9dChDw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCk6IvFmDk3pfNYaBAA9V8VVg9RNybYRrdPP/A="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761A7N5WNXX
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 8 Nov 2025 00:05:32 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altan@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <Avri.Altman@sandisk.com>
Subject: [PATCH v7 1/3] scsi: ufs: core: Convert string descriptor format macros to enum
Date: Sat,  8 Nov 2025 00:05:16 +0100
Message-Id: <20251107230518.4060231-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251107230518.4060231-1-beanhuo@iokpp.de>
References: <20251107230518.4060231-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

Convert SD_ASCII_STD and SD_RAW from boolean macros to enum values for improved
code readability. This makes ufshcd_read_string_desc() calls self-documenting by
using explicit enum values instead of true/false.

Move the ufshcd_read_string_desc() declaration from include/ufs/ufshcd.h to
drivers/ufs/core/ufshcd-priv.h since this function is not exported.

Co-developed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Suggested-by: Avri Altman <Avri.Altman@sandisk.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd-priv.h | 14 ++++++++++----
 drivers/ufs/core/ufshcd.c      |  8 +++-----
 include/ufs/ufshcd.h           |  4 ----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 1f0d38aa37f9..f3eeaf45cfdb 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -80,11 +80,17 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 			     struct ufshcd_lrb *lrbp);
 
-#define SD_ASCII_STD true
-#define SD_RAW false
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii);
+/**
+ * enum ufs_descr_fmt - UFS string descriptor format
+ * @SD_RAW: Raw UTF-16 format
+ * @SD_ASCII_STD: Convert to null-terminated ASCII string
+ */
+enum ufs_descr_fmt {
+	SD_RAW = 0,
+	SD_ASCII_STD = 1,
+};
 
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum ufs_descr_fmt fmt);
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fc4d1b6576dc..35ab61aefb72 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3774,16 +3774,14 @@ static inline char ufshcd_remove_non_printable(u8 ch)
  * @desc_index: descriptor index
  * @buf: pointer to buffer where descriptor would be read,
  *       the caller should free the memory.
- * @ascii: if true convert from unicode to ascii characters
- *         null terminated string.
+ * @fmt: if %SD_ASCII_STD, convert from UTF-16 to ASCII
  *
  * Return:
  * *      string size on success.
  * *      -ENOMEM: on allocation failure
  * *      -EINVAL: on a wrong parameter
  */
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii)
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum ufs_descr_fmt fmt)
 {
 	struct uc_string_id *uc_str;
 	u8 *str;
@@ -3812,7 +3810,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		goto out;
 	}
 
-	if (ascii) {
+	if (fmt == SD_ASCII_STD) {
 		ssize_t ascii_len;
 		int i;
 		/* remove header and divide by 2 to move from UTF16 to UTF8 */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 00152e135fc9..4fb1998b84cf 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1432,10 +1432,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
-#define SD_ASCII_STD true
-#define SD_RAW false
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii);
 
 void ufshcd_hold(struct ufs_hba *hba);
 void ufshcd_release(struct ufs_hba *hba);
-- 
2.34.1

