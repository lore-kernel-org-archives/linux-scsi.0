Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9A42AA9;
	Tue, 23 Sep 2025 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758642324; cv=pass; b=I5Aqk4BsHhMJgZ84pvC0d4dsUhG6+doRaG7a/Wxj8OH75gsUUgagusFAiu04wAZWOrAiyjRbNGaeKeae0DLll2baROFqkfbAwJwLhja1Qc8jrPwhDYco/8vXEp0tngmBzha+kUrPYJU57qopr3z3pHfWVuqqGzTLO5Qk5GmhSL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758642324; c=relaxed/simple;
	bh=FLlDR2tziC5LTTUj1fqGz3p0kuBMiGN78op6NHzyngI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYQtXAUT0ZfqG9DAlR97Df+2IydanDzDsyJhTyTrmPQ5Y/pF6Y6axBb7ktkZllOK3lEi6QsN+8UWOZcDGkMQ1me09ockw3Uz36l5JRfRzMMrk2suLu8vUPfyncWqZATpfcEOnF7khk6mXWdQDj/sPJmbjn2BJ33vpqRkNLXV0CE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=tRrIZ3KR; arc=pass smtp.client-ip=81.169.146.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="tRrIZ3KR"
ARC-Seal: i=1; a=rsa-sha256; t=1758641958; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=EnA2qV5Fe+WQXOdCUu1usyLbMD46OhfMVO/cJmnv05t4/piuF347OoGVFsdObirf2y
    npisyOF17X8sGWls7Xnhtnkkc6r+/KC1YwveLWkoKiktu2fi8DlkX7QAKogNNupKqlIf
    Csv7tvVvktFyaUATu/vYS5He3Ius8Sj7X9xl+AYS+gKHbF7uDpA9/CB6TUp0BfLiP33F
    CPpin4QddhWjga2wqdvcnANIKtzXt41tFM37Y47wc3qvYVFCbYTDXcz5O8GOlKDlyIm1
    7QEISSBHtVi7ZhItIdufR6zT6EGWeSrnqq1fn9hQAkykIYQNXAdfYVGLCv3gRlIwIOTU
    ps1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1758641958;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=a+70373e+Lz+vAR2nKUbEkjl5RTJbQlaVGE7sifvdQI=;
    b=IBQjiN95Pzmy4TvXlx5dRJo1daANv2c5nfneLgP15ApzMcWMFagqnJmOBT5vvxoptk
    zRN6qg+OcWWE7cVUkxkEA3MfgZ8x6zQfEN5DJjV055aN6cayVKydsIVxRZRGWF9zalqr
    pY0NKl8dEnYWFXQ9MlRcKw2NpMPDwQg1LibsowU1uaTTtkHwS9bT2nsI685x25zwcPXu
    Zj49hpvDDTy22sDE0M0nCP1KxNaqHwNzRIVCZIJSSYe1Vi3r8y00YPCPU8fyY21Nz/vz
    K4KCTGDmkDR/5N9X8KvQdC+8nP3bPeFwa0CmAw3LeMpn0zV7QK7PBLCCG3eiGajbepgx
    IEnw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758641958;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=a+70373e+Lz+vAR2nKUbEkjl5RTJbQlaVGE7sifvdQI=;
    b=tRrIZ3KR9CrtNDEyjXImjIJv6r7YULGOnNva3CU6K245zsMn2DNNSjkklBgkH50mEc
    OEOwFafjU2gG/a5swGgt6OsHLpBx3aUvwg/x0KDRDro4spF+V2pW9dwObMOiNCp56jHO
    XK7zXj1cVbB9dg9g7BkApm//R1veQGizXkbsjJYQkrVL8N7RxFAPoeQ6uo/wXBMCiSmZ
    92pMg3sw0LUth6YDrz+lXecY/kungr8zFCbfw17Ok7I62cuvEVMYJCx8F/4M3qfI3hjt
    NQZ+0EBHoW3d6N3xhyT9Hg6wkVkmkv6nqVxs09JcC0esoIXICUBoE+HvYVxE9Y91xVPY
    cqHw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc618NFdI3eQ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 23 Sep 2025 17:39:18 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] rpmb: move rpmb_frame struct and constants to common header
Date: Tue, 23 Sep 2025 17:39:04 +0200
Message-Id: <20250923153906.1751813-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923153906.1751813-1-beanhuo@iokpp.de>
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bean Huo <beanhuo@micron.com>

Move struct rpmb_frame and RPMB operation constants from MMC block
driver to include/linux/rpmb.h for reuse across different RPMB
implementations (UFS, NVMe, etc.).

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/mmc/core/block.c | 42 --------------------------------------
 include/linux/rpmb.h     | 44 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index b32eefcca4b7..bd5f6fcb03af 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -79,48 +79,6 @@ MODULE_ALIAS("mmc:block");
 #define MMC_EXTRACT_INDEX_FROM_ARG(x) ((x & 0x00FF0000) >> 16)
 #define MMC_EXTRACT_VALUE_FROM_ARG(x) ((x & 0x0000FF00) >> 8)
 
-/**
- * struct rpmb_frame - rpmb frame as defined by eMMC 5.1 (JESD84-B51)
- *
- * @stuff        : stuff bytes
- * @key_mac      : The authentication key or the message authentication
- *                 code (MAC) depending on the request/response type.
- *                 The MAC will be delivered in the last (or the only)
- *                 block of data.
- * @data         : Data to be written or read by signed access.
- * @nonce        : Random number generated by the host for the requests
- *                 and copied to the response by the RPMB engine.
- * @write_counter: Counter value for the total amount of the successful
- *                 authenticated data write requests made by the host.
- * @addr         : Address of the data to be programmed to or read
- *                 from the RPMB. Address is the serial number of
- *                 the accessed block (half sector 256B).
- * @block_count  : Number of blocks (half sectors, 256B) requested to be
- *                 read/programmed.
- * @result       : Includes information about the status of the write counter
- *                 (valid, expired) and result of the access made to the RPMB.
- * @req_resp     : Defines the type of request and response to/from the memory.
- *
- * The stuff bytes and big-endian properties are modeled to fit to the spec.
- */
-struct rpmb_frame {
-	u8     stuff[196];
-	u8     key_mac[32];
-	u8     data[256];
-	u8     nonce[16];
-	__be32 write_counter;
-	__be16 addr;
-	__be16 block_count;
-	__be16 result;
-	__be16 req_resp;
-} __packed;
-
-#define RPMB_PROGRAM_KEY       0x1    /* Program RPMB Authentication Key */
-#define RPMB_GET_WRITE_COUNTER 0x2    /* Read RPMB write counter */
-#define RPMB_WRITE_DATA        0x3    /* Write data to RPMB partition */
-#define RPMB_READ_DATA         0x4    /* Read data from RPMB partition */
-#define RPMB_RESULT_READ       0x5    /* Read result request  (Internal) */
-
 #define RPMB_FRAME_SIZE        sizeof(struct rpmb_frame)
 #define CHECK_SIZE_NEQ(val) ((val) != sizeof(struct rpmb_frame))
 #define CHECK_SIZE_ALIGNED(val) IS_ALIGNED((val), sizeof(struct rpmb_frame))
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
index cccda73eea4d..1415ceb458fe 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -61,6 +61,50 @@ struct rpmb_dev {
 
 #define to_rpmb_dev(x)		container_of((x), struct rpmb_dev, dev)
 
+/**
+ * struct rpmb_frame - RPMB frame structure for authenticated access
+ *
+ * @stuff        : stuff bytes, a padding/reserved area of 196 bytes at the
+ *                 beginning of the RPMB frame. They don’t carry meaningful
+ *                 data but are required to make the frame exactly 512 bytes.
+ * @key_mac      : The authentication key or the message authentication
+ *                 code (MAC) depending on the request/response type.
+ *                 The MAC will be delivered in the last (or the only)
+ *                 block of data.
+ * @data         : Data to be written or read by signed access.
+ * @nonce        : Random number generated by the host for the requests
+ *                 and copied to the response by the RPMB engine.
+ * @write_counter: Counter value for the total amount of the successful
+ *                 authenticated data write requests made by the host.
+ * @addr         : Address of the data to be programmed to or read
+ *                 from the RPMB. Address is the serial number of
+ *                 the accessed block (half sector 256B).
+ * @block_count  : Number of blocks (half sectors, 256B) requested to be
+ *                 read/programmed.
+ * @result       : Includes information about the status of the write counter
+ *                 (valid, expired) and result of the access made to the RPMB.
+ * @req_resp     : Defines the type of request and response to/from the memory.
+ *
+ * The stuff bytes and big-endian properties are modeled to fit to the spec.
+ */
+struct rpmb_frame {
+	u8     stuff[196];
+	u8     key_mac[32];
+	u8     data[256];
+	u8     nonce[16];
+	__be32 write_counter	__packed;
+	__be16 addr		__packed;
+	__be16 block_count	__packed;
+	__be16 result		__packed;
+	__be16 req_resp		__packed;
+};
+
+#define RPMB_PROGRAM_KEY       0x1    /* Program RPMB Authentication Key */
+#define RPMB_GET_WRITE_COUNTER 0x2    /* Read RPMB write counter */
+#define RPMB_WRITE_DATA        0x3    /* Write data to RPMB partition */
+#define RPMB_READ_DATA         0x4    /* Read data from RPMB partition */
+#define RPMB_RESULT_READ       0x5    /* Read result request  (Internal) */
+
 #if IS_ENABLED(CONFIG_RPMB)
 struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev);
 void rpmb_dev_put(struct rpmb_dev *rdev);
-- 
2.34.1

