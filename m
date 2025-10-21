Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C139B244677;
	Tue, 21 Oct 2025 12:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761050771; cv=pass; b=uTUSLdFHG9kDMT62GPQ4ifiYZYGRkF7GVSaLXADauIyNH0Rqnjq6evHCiWRn+aPRsApb7a18AmSWz43wcslBt1eZXh+ktk/bagW2gX4Wv6QATMIKHnciAtLDtB79vbUsXW89md5yxMJsQckIRcuglddb4JJGRRSIb5Sjam2SRJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761050771; c=relaxed/simple;
	bh=1q6vN86jbGv3nIognT51qbJqHH1WBSGgAJTpN/qG8Mk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nuUjBcVvNAmfrbf1TIZ8ApsgrVsnoDh8MuUJV3JOO9AiRET9SHuWG7n7joE+JrY9PK5EdVYb/H9XTmBJCcNV4hiC9NZO5uuQQNNbOZoo9STJNCMaun9JXGpjUjcJgORoB/x5pzu/aUkt4rEs262kzkwZQNJ+qvX0z9iXor4A9Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=J4Sh0dbQ; arc=pass smtp.client-ip=85.215.255.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="J4Sh0dbQ"
ARC-Seal: i=1; a=rsa-sha256; t=1761050584; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=dwapvN65ZFtX+7uD+549a2hjoI++KNbT7/TR96atZIzCnEPs/mp+HCdD8EYsqH8G+u
    uaQBRb1ZNlF+aRQr+CV7O9Br2GcpHeQf4CxO8QOZJ43OvyEd9ihyOME33A0t4dX69lAw
    3XnGviMTfeLgGKWvMaYKlXzgKvKFr/jymneaUMAFskKnAYPp6/5b04Eo2CnOmUu4Wr51
    saK5ObEUDaqvX3A3qRmF3hIq1uOWpATqyo21oscidoFakKeHT7ADfJX2/rPIF1e8kie3
    dnMo94IFfSCaswunmmLN1HSP0K8oYYzuGLu1OHaihCgIVkelW0FE9taT1FUw3l0eee5C
    kN9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1761050584;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OvLNPSDEQavvu1VF7E7TIN224K3UOaN9Gwv18btOmIA=;
    b=aHazwkGhKrX7OdEtHkhFCRbZehyTldC5RGi+51Q4aSsBgeNOPEL9nBoShLWd6ViL/d
    013ILzGwdimAG9CyVj63daXFA73b1+5HDWbBoXKsByRpWfEk78smb8zwGssjuqTe9S/B
    LJjYjO/BHrMZ8SZVctz2kXt4O8w0LEsMQ4nfld90VYRVz5DyvKv9VCMYerWBJAKLBnmb
    K2WICyJnBLJcWQzn3YrdHDlHIqwWLO9eYZgn87i0loyCxye2lCa30hlXajCQTUelDKKo
    Bg3AbQ1x9e0HU3AHAIAOyFxjkg1Wkq+Jb4w5DEYLvQNxVl6RrbSsTaf8376oPK9tQ/JO
    7qrQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1761050584;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OvLNPSDEQavvu1VF7E7TIN224K3UOaN9Gwv18btOmIA=;
    b=J4Sh0dbQIN1yp6g7x5BZcc1DvODAp+SavEeu0I2KIeYjo+uj93+P78UiiaSQwukm9r
    OYcr3EDoZoJwmvQpZK59SFVvLg450XqczPpyYExXgGDY9W20fBNQguECQNos7N1p89Eb
    Js1NcVlMJ2L2BilT2S4YrMxv+vyp9aZF9KeSvYzU9KUhRuLfDmRVbKWt1njvLf216EqD
    jvIz6bBk4HRQ+RHNm6kiMcF6qRYAvgf2VqLivAgskqXn30/Wouu7pGMBec2jQIFFKRmV
    M8H/yFd+3xv8obgkKRawROMUIH5LuQndM/YXUSe8Z4dmXOG5UNcNhAuaU8wZldYgG4cA
    peIg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19LCh4114
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 21 Oct 2025 14:43:04 +0200 (CEST)
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
Subject: [PATCH v5 1/3] scsi: ufs: core: Convert string descriptor format macros to enum
Date: Tue, 21 Oct 2025 14:42:52 +0200
Message-Id: <20251021124254.1120214-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021124254.1120214-1-beanhuo@iokpp.de>
References: <20251021124254.1120214-1-beanhuo@iokpp.de>
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
index 8339fec975b9..2a653137a9ea 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3773,16 +3773,14 @@ static inline char ufshcd_remove_non_printable(u8 ch)
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
@@ -3811,7 +3809,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		goto out;
 	}
 
-	if (ascii) {
+	if (fmt == SD_ASCII_STD) {
 		ssize_t ascii_len;
 		int i;
 		/* remove header and divide by 2 to move from UTF16 to UTF8 */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..b4eb2fa58552 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1431,10 +1431,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
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

