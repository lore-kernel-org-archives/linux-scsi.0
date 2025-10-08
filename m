Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7DE26E16F;
	Wed,  8 Oct 2025 20:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759954804; cv=pass; b=dfEoQ1adqGaX97aUlJ+8GtBkmxIsRFiP0/IDR7L86blKeZZAnobaYRvFc8uuH9STYZz2GQk+NU5ZpiVTZTGL3m+y7nKDHVDnyy45gy1tPHHtgyv74Xb7sZeZ45jNJE0h8THj8Wj9MrR3bn/tzaowKb/2t7YxGJcKh51h++wVgyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759954804; c=relaxed/simple;
	bh=Z/1u284kTILrbc3Vlj2F6kAI7Pm5I8KoorjxQhAoJN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iLRlvogU2Wqh8dsL3YdDU5QkNp9ZggiVyh1vZaF5/Y87MJo0At7X3RqEp7fXKO5CLSJtChzsF3GpcYJGAM5rCK3K18CjZA+ufDx6Ga9T2mmR2pdH8mqsifiXoY3Mx28pOBtcoO2suvtwxNhcHH4CaD/lb34NHbGnKL4EPP3yIK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=H8QUiSeS; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="H8QUiSeS"
ARC-Seal: i=1; a=rsa-sha256; t=1759954796; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Az23f7SyQaNjUKSe+GidudBLBrjildg7MnRWN5Fg3TNBatuDhgoL8CFrggygWGxUyb
    cOLwd8Q7uFORiW164fBtavYrS6+8v0qG9dkJL/UaTNV+G/hqJ4VBWQTYhamTQDUZ9zMY
    x5RP4jA5L5yTz/7FvcVkP0nbTpMv+1GcI4OZKEya4qceQh1QcmPBODWzZqfLxg4zeRE+
    6KuQNOH3YesfqQxLSdZYr8XyqhI3TTKk38KIKBnFkz0XwxOEzcK3yG8R7biYfVYEYFH+
    EhIU0jiBUCeUoX7iRiW5Lg9jm60DssPnUxrRhEihicsopIUeZr6iEUsjWF2xTIM9V/Um
    +9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759954796;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=dr1R5XYu/hf+7l2A1TdMEHNZ80/JmT/u05H28rMJYYk=;
    b=iY9g4Mq12Et2QPixHgUYmzp4JpehzHsaCVQPESmDcKfAND8o0jZM1LKYbVH3dS6mdB
    ti5sdHMWVhhWV6dIbp7fGiOk10pGufPmAEU0xw2IIP5HoCRXpdVLB8b9qxv6Uh8TxUBc
    0RXOhfxR68ZvhRCnTpr8G1KnCQxAmdH16Iu6s3qrAsyvv4c0AlTCvyMPz546FnznyVHW
    LQEQ/QQ76XQS2A76MeSqkjV+vwcPE/MXhhcxpcerz2dibXdClHWFv/JuvVWhT448OlHa
    sGbO4Db4AvKRzKGA3TigBf7pq8z8CRQEZmU+unRuDee5pqG0TZooAGU14xgr3DTiFcY+
    Z4kw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759954796;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=dr1R5XYu/hf+7l2A1TdMEHNZ80/JmT/u05H28rMJYYk=;
    b=H8QUiSeS50airEtHYcryRQMNT2h8B/O14Aih2kXADKc3SdiXQYOM4m4g3JWvLPyGJT
    dK2aBOoA+u++HnaAHl2lNe1N9PoLJSuM7J6CS5z/BhplBUPdto7s0lzZBgSibRHovNga
    9bL2MDkCkWCDibtGMeyX96KbSjC+FwZo2X/AKeEgBn4G6OMIfgq2i7O9nnmHMHA+lAkq
    2mt9o8s8wa1PxgzbkgeZ6TwToOfBMthe1r00Mh0YZEXiKJtHddTt35XjbTP6tziI4GN3
    ql4wgHquZbWyXg8hXyJQaVmhDaOhfQ1FkNdw3yVo8vmruBh5Z88gMwjgajVy5X+KqUEb
    FO8w==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RX36IbE0bahBk7fQ77Y5cN0Av1YXTvXCMGxpd0="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198KJu3U0
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 22:19:56 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	avri.altman@sandisk.com,
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
Subject: [PATCH v4 1/3] scsi: ufs: core: Convert string descriptor format macros to enum
Date: Wed,  8 Oct 2025 22:19:18 +0200
Message-Id: <20251008201920.89575-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251008201920.89575-1-beanhuo@iokpp.de>
References: <20251008201920.89575-1-beanhuo@iokpp.de>
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
index d0a2c963a27d..d74742a855b2 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -78,11 +78,17 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
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
index 2e1fa8cf83f5..773926b04149 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3759,16 +3759,14 @@ static inline char ufshcd_remove_non_printable(u8 ch)
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
@@ -3797,7 +3795,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		goto out;
 	}
 
-	if (ascii) {
+	if (fmt == SD_ASCII_STD) {
 		ssize_t ascii_len;
 		int i;
 		/* remove header and divide by 2 to move from UTF16 to UTF8 */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d3943777584..9ed188d24cb0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1453,10 +1453,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
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

