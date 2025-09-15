Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2524A05D;
	Mon, 15 Sep 2025 21:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757972974; cv=pass; b=fZZixAD22qKKCOlHP0ejWipfRLRW41mfKM5oNomP1TJdVH0CcKGNcYujbRU7JWmTEJxiUVVOmZsUnL9kzKnwL0sqhqfixOmTbCDvpWqxbU/VSkbbYAC8Pn7PQ7fOedcyZSExTQ1CPE+E/RpIJKOOQE1zTPWvW5Uyql/+l+mdf1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757972974; c=relaxed/simple;
	bh=qwiePEkOo4PDGdk+XqRZyGqMFzlt2biwthmfhMb/e6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxykcZ7v/mlQ6rkbSqkLSj9/NlKw1xurNn16f5jH3JndQVECwAHQSX9EMWocQdcVaMxF9IQ8Z2ADxlNA9IXLcBGnwSbFz0XGuFrLLa9fSlX6esyi+89ad1+ocrPMNNDtT1WAxjfDoyvs+yV4W7t/8nb2Xq18rZEnlaEjnYEBJqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=knyZjcYE; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="knyZjcYE"
ARC-Seal: i=1; a=rsa-sha256; t=1757972782; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=s3J1256e9i0Y0tDEqmWv4Ys/082ZVG5PV03eEqp+nRTqBQlSUzeWToUtlqwrSeO0XG
    2eiFyOAnt0Sh6O1+7hD/KfVcF93HGQJwV2/bGDUEP4Z6TuM9SK373yjgSxInuo2cV6NH
    1evzMOX/P3tx01txVIx2ETkwgbk/dPuIHiMrSn1xnIS9dQK56c7TozGZyFMV8D6ymCWi
    g6qHca5+X+YfoGsB4vtxGMrBLFelLEKsIzK6v10TmYq6aE9hzMosHsN6A24jzWst+VwU
    G+nhwTEWtFYjSpZA7Gl1XzOy+fTk53XF0asSz3Gy2oZ1pvu6nlJLuPuUzzsE+2PMknZd
    XaJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1757972782;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=0FA5vAsG3JRVpjxKIjbrtaM+d8WZfWAWyieDa0sc81U=;
    b=azeEI1nLDvB6mDTI37q0YVKXyW0zysPg/RrDGOAIYMjZASmPtCFSr1NQw8Z2xGetAD
    qlm31mkXPyGC8FZLHzVSrywYPCldc7XKATF0URQig/sO0Dk0rMx5YkNIz6mr8o0+Qjta
    FX3mdTB5pKQu6TUBXIBi3egeE8vPsOlB2MB2KZ61AgRFgK85QQqwa2ziQleanSvl9hd/
    RrN5WWm7e0E7h6d56DeJ7nZsRR/ZaPi/Qjc/g0vP63dFM5BdUJTvOJZo9qlUKb51Qulq
    TMxRvHdzN70poZJJ/1DbCNHJVGNEwClHMvPpVj/zk1C9EZbZ+n3EEj9haa5kNbcUT/lh
    kWjw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757972782;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=0FA5vAsG3JRVpjxKIjbrtaM+d8WZfWAWyieDa0sc81U=;
    b=knyZjcYETkYdbONOQo/G7AGcMgPCtIBq+J7QJ+UcjZ7wUJFGsE+e6FXu8J9R/TEdDQ
    4duZIeDOCzl1SQpzWkAO8a5KBkiTbxtZgTL/q0hBqn12CAtY1pGDBWIbWdXDIXlAy0eH
    tiW5cROeNs8X/sr/OSQQjaOFHM2/VC7reS1ljmK+n31tkz+Khrw9vMALJFk0I4Q47ipX
    ExrCX92Kfqt5qaDmzH4EtkZ35ESmPZljFkSM0yfFqdy//BxSpJi8WaexXteQdq91T/W5
    G2YZsEaiMkh5fDry8AFUBjOA5NRCv0usQgO/nFa55QNrUKFiSApkqbvZgaKbq9zUkOv1
    ItkQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCg6IWQdI9ZW5fgNTLz+ViCLXbUTDqukxFTraA="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 52.1.2 AUTH)
    with ESMTPSA id z039d318FLkM3HD
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 15 Sep 2025 23:46:22 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mikebi@micron.com,
	lporzio@micron.com,
	Bean Huo <beanhuo@micron.com>
Subject: [RFC PATCH v1 1/2] rpmb: move rpmb_frame struct and constants to common header
Date: Mon, 15 Sep 2025 23:46:13 +0200
Message-Id: <20250915214614.179313-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915214614.179313-1-beanhuo@iokpp.de>
References: <20250915214614.179313-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

Move struct rpmb_frame and RPMB operation constants from MMC block
driver to include/linux/rpmb.h for reuse across different RPMB
implementations (UFS, NVMe, etc.).

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/mmc/core/block.c | 42 ----------------------------------------
 include/linux/rpmb.h     | 42 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 42 deletions(-)

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
index cccda73eea4d..25b69ecf5392 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -61,6 +61,48 @@ struct rpmb_dev {
 
 #define to_rpmb_dev(x)		container_of((x), struct rpmb_dev, dev)
 
+/**
+ * struct rpmb_frame - RPMB frame structure for authenticated access
+ *
+ * @stuff        : stuff bytes
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
+	__be32 write_counter;
+	__be16 addr;
+	__be16 block_count;
+	__be16 result;
+	__be16 req_resp;
+} __packed;
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

