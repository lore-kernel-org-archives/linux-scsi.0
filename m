Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B974C2DC79C;
	Wed,  1 Oct 2025 06:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759299090; cv=pass; b=qoQKVklM69U/++CzDgEARWC2EOfbU6qUhPTRC8rGOOAVXgw0qYgmJhts5iQI0xf+c5bAGVfVsjWgPH3s/K4t0S5e4wb6ojfr+XODE+u9ofhd/7yVPf+Cye/Y9cBuhtNzbFBYpzxsh9x06gByPVGqiWETZgJ2ZIte0EJH/ul/7NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759299090; c=relaxed/simple;
	bh=kwcq6wSawbK9MsfC4RAARhadzFKSQCwjq8nbkMxWphQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PD6ZSgnP7Dp24Di7jRg+l2nBfFvXFpUdsX8zILmgJa2rOsco90tuAD0LAtZXzwqqJ/Lnxe1vpjgm6uSkAn42/boI3kRUt4hSH/+ydC9XbW23+pTl9eV7wSsdUR1H407Ebjg9Jfg2PpA/OuFVraWgTGAYqA6NvMaV0mKbLKRPt1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=RzGu/TOo; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="RzGu/TOo"
ARC-Seal: i=1; a=rsa-sha256; t=1759298898; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Mh0GI93rstICfZ/4Xldb0YhqjdQbNtHrVZ3OL9KNeM4kBRkoziYjo1cRVrGOJvU1ar
    QC6xkzmhtEDUq3iJtQd+PQq82/5HWMnZo5VMwi4jYBZTbRuXSt4aYpSG2lRkxq3wrRXo
    SU16vjJtNVtJ2Lwkdx8r7F7zvRcx/lM2hXlsFolDkkW5dDG4QEbAaxBjrs5jV7ja48fU
    +dVkmG/h0cLua4voWNY6NNebRKeBuutanqOrO4JWepSfuXCLhJxRy1zOPIBeeoxiSE7P
    DHzEtKestJZyOiKT7UCmQXbr/4ZTTVL1ZfTVdX/DQaLY2psLL4obgbMJuMXuzn8FaGzI
    yfew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759298898;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YSyxsdgrlVxMmnvY9WXOMGgPGiuic8SC+YqcLO+lvOs=;
    b=ZUnbPGTD71Byczatx+uiwRNEGVwMVdWTQvUs9YU9AQIRvnk1NVa2XkCkl/PX9cvZgX
    gGtH4fJEyhc7i9+aPVznDxsTqe2vzvLwfFpDOtT5Xa8OZpQAW7klJulM7vGBFaDCa156
    az9YGmCfPHURUifVLk600m1ITcDh5Qz4qs9XT6e6Ev+lB+p3iKMDGoapm5+Ps9+tzbS+
    9D2wv5yxBSrz/95idIb73J0BA2+xoD3U5ydPpIkiUJCdZfCY2ASmmJo0v1CVCbpn0m2V
    6tGkFZsEdJFCVj6XMVZyAg1J3AA8TmQWkvjIsWPg69B3aRo5iv2IcA/jDkcFiKT761uR
    3mgg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759298898;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YSyxsdgrlVxMmnvY9WXOMGgPGiuic8SC+YqcLO+lvOs=;
    b=RzGu/TOoF0jh33jqkzLVs2GViiCxDI4SxtsjyE/GPnqN9ArkQyHgt6+yIhmLWj9YXv
    PleP51qR/VzJFIftFhHaeZs39uNyvKb0YTq9ail5NyLO4DZTYF0hfwyPuTfagZgXjFHA
    8M5o2BBIVFA04hdf3hehUu44xDkvahw+fVvQgXVoUyI1vl/61ZZtxMlH+bfkOULbQYRI
    kgMg78xc+ut87b7PPi7p5qaYqZtXljz8Ns3bMANRkbMxgGpimKlV2X1g4a0RxzPSmNMW
    bQegjIj61p2GUZIKKD/c2r8BALM1C1UM9IWXoSpdyZIV0d8d95h5X1C+jDJkf/LOcQqV
    kzyQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2JmZOo2yQsAdmCB+Gw=="
Received: from Munilab01-lab.fritz.box
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc619168HY7H
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 1 Oct 2025 08:08:17 +0200 (CEST)
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
Subject: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to common header
Date: Wed,  1 Oct 2025 08:08:03 +0200
Message-Id: <20251001060805.26462-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251001060805.26462-1-beanhuo@iokpp.de>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
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
index cccda73eea4d..ed3f8e431eff 100644
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
+	__be32 write_counter;
+	__be16 addr;
+	__be16 block_count;
+	__be16 result;
+	__be16 req_resp;
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

