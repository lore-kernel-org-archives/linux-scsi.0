Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA9F11712;
	Sun, 26 Oct 2025 21:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761513933; cv=pass; b=OqFTN8JFbpFNKhQt2vsAp64EMBRUZrk4/C51aOTHM89kwYDZpdM86PA6PlB+IhtbTnjIW1hKkcvhd1Ak8OpHCvnzqY0cVO+g1d9Q1PIITx4eEFGadnNmP91noknCSCqbbOKadXUUjJl2nf3nT7AmPT1ksZl74k3ePW56BvCiMdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761513933; c=relaxed/simple;
	bh=1q6vN86jbGv3nIognT51qbJqHH1WBSGgAJTpN/qG8Mk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ckx/L8UdYqP/KcgAuuANsJs/f/7Fwd99BsWqwtt8ftbl42UyPjFkX4oxO6LpgudwCltaijRJ7xkoWjb3aHLpPMt4GwJkA++XNNBmYA23sd2q2sKn5cSQQXhNpOY0ZQehq/A7ZIomfL8RTHRiFgfX1+KLFY38mjUVIxMxnaxV8OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=NqkMtlbd; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="NqkMtlbd"
ARC-Seal: i=1; a=rsa-sha256; t=1761513920; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=EDYxc5lXRaQb1/v4+0eq9Pcfw22xSOuM0LWfJRZOhrPajIvjGfnsYKJm9hLSFsuLph
    Wm3nUSMeFIuyQspbamWlQHUuVssDDQk1qyITGO5YuyC76BPJQ375KBGfEFHPOiToT6w9
    gU4Vir/Blzj5LyXkBlCRt+DKru2xqOABNKW3TmnjHgU2kbKQ+p6uGV/qDL0+J4ZdgVnm
    IHjh9X90Bypho//2vWxaNlU8uv5qdzdkfE2CNCmH44DE4XXfdtfmOWKoPv5PqWL9iHSJ
    55RnW7mvQkdIF1b6icql2P7tfKgO7WM2y5zslLFO5e/Y8esNqMmv5QEpNibY7Ju8UWBt
    26+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1761513920;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OvLNPSDEQavvu1VF7E7TIN224K3UOaN9Gwv18btOmIA=;
    b=BjVes5qfprOS+4JP/N0KPqCL+QbKGJQdf3OrOfDqNRebQ7udzaETkb7f+BF1771tCD
    tLrlLnjm5K3NmceiO0mIh1WAdoZ2fSfipn7Ab64ZCzR/zyO93lJQiIDI7X+x4LhSwnJG
    mtHwJ3KnuVgAJ/iyr3D7piTiArAlKmkO3iPU9v0o05xfZuBrS9N913bXQRvTlUr3h/ll
    ld5xhC/7ZZume+MGBMCENvAqIwKI8lrj4J8AqGsOeMFw43QX8QAFMpn3kKO0tGCmzyba
    0Fn911+PcWKYjU3kXjOjI//vtXa6/qhcm8zsTTepINgFSoQKZooSQtjosjbduf6yBVeH
    ccaA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1761513920;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OvLNPSDEQavvu1VF7E7TIN224K3UOaN9Gwv18btOmIA=;
    b=NqkMtlbdQHhdxiC+kS8rBqgCP9cppdQT3g8FTPjxuZFFt329yoxJH0KDZ2YsGR+pSl
    6BAMyggAzrvxAmQjJfrcjOuuVUlVnFnIaIAIQu5OiDPv+MycTtZufBvqfwFwGFZkzATs
    omxv/kawzn/XOAvcKdg2Ke8hWamkLcWCguhaoPLYY6BSQKMrN/2TrRkqJVmnGJXXDY+c
    pTXRrw69+5bWcq04DEGjGAIyXt+t+2RXoDTtc927NorFlVW2mRxF+oK+xwitBAtsrFf0
    714c3crUwRWo/3bJhv9y2F4awBiBEkS6H30LF1LzOz0Z43P15C/LTrSlI2i0YcScADYJ
    QYJw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCk6IvFzzg3pKYIOBA3pK3/fXp3o2O7xeGwra8="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19QLPKSOz
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 26 Oct 2025 22:25:20 +0100 (CET)
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
Subject: [PATCH v6 1/3] scsi: ufs: core: Convert string descriptor format macros to enum
Date: Sun, 26 Oct 2025 22:25:04 +0100
Message-Id: <20251026212506.4136610-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026212506.4136610-1-beanhuo@iokpp.de>
References: <20251026212506.4136610-1-beanhuo@iokpp.de>
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

