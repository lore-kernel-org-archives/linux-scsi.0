Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08E1127B5A;
	Fri, 21 Jun 2024 08:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718958357; cv=none; b=PwQBF9+s2vyMBxN//yUJbMiAXmUtuxRl0uRuqpQOeiCyu33bvJnqJDJvC+ZpwI7sojo0oCljoUAIn8HIfbeY6KYBtRcJJrpcDG0YLQe5sZv/ddr/1CwjGBb9JJt68TRyhTEpd+5GBloZOJ+wqdizUSGAGihBiSrC7WQupObVDzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718958357; c=relaxed/simple;
	bh=VJQJ8CcnNOzqYFH6HD1lzJUneopK06wtZw1yONb4nH4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ULwE0ZFYBMQVAZp0oLL8UTwcp+70Lz1s/D1YfXsmYPoE7Q8wdTEUOSJPjosDRmKgx4u2fLwIWAMvov1hbDpA+sBVjUUFTxJNPqS9mkPOmAI/P2vFQwMUZmVYGv0GfxICeDa+QcydwbD5ONK70h8yL/xfGbWvke9TnkvwdLHciEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I2LqyFda; arc=none smtp.client-ip=209.85.167.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2LqyFda"
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-3cabac56b38so978802b6e.3;
        Fri, 21 Jun 2024 01:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718958355; x=1719563155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=La5B2FGT+ErHbprZY/EFG+LalvzBERwzjgNBo11Bf84=;
        b=I2LqyFdaLfKC4Qt98JYeVabQMSeBG5wTLb3gJbi+Zoa8Of2TvKEDRPvcBkNkuEgYXu
         LR9IUWJmZFE2lBbLzC/dHhUrWyv8081uCf67z1AQbbSuJhtzDCHitGz9YbF9lpFWIatO
         XqFQsTeMKLXvWdXFd3dBvSVvOCucfNfpHrKUin4rA1njovvraCNERTj1LHAnQCnGBzE9
         R1ZXg4QobxsGM9V6JJSzFmOJjOG2YBnYfj5l0jfxZeZeUFu9TpiYXox2plZHRxGE7Dmx
         Rtivcq/1rEaXGqErvc8wKdImsTaUWAiXGt/Q1u5rMakpzaSwHZXwoncT+7dI2HQrlUUu
         +ySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718958355; x=1719563155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=La5B2FGT+ErHbprZY/EFG+LalvzBERwzjgNBo11Bf84=;
        b=wLL8msVhj1bLTgDv/nV4ACDOvGi++BDAjf3yPP5xjxLjr8PnG0dzhkkBNy26J0OzBo
         h8mKuQOz3pfSntp79ne0NKjKOtnxSx0KMFcrE73BedfKnCTDckrcHyW3MXYucO1pf2vV
         EHplDq5oRToV85H9PJnaGaDYfVVLxWY3vbqs2uR9G/s0v+7mkZBVoOR/pYnGj1C3ROQZ
         aZxKzCpqJ27N1IIxdvi+6AcGPqpx71B3xH79oePKlkVzZkkpqO2cCZygKWg3gS57tD1j
         7E7mOvZ+3pg4srQPvqlUC1WKAUOYFSjQRO3MtXF3e7OIS0DTBgIy70g2x613f0TP2ut8
         FDUg==
X-Forwarded-Encrypted: i=1; AJvYcCUZp+iWltWm/dBBN9jXhhDAClz09yHdLR7gtAdkDqvbh9TWaoexA7fyUmNozA7kTD6NT/AIBQwlDiTMMlNlZpQ8SF4QCyYtLbPFSToe
X-Gm-Message-State: AOJu0YzDaOWc0iURrxkP8nJbTqvNeqxnDSERVdWEY/08UE9OBjMyMCLP
	nkl/vSiZvJ/sCFjxbzQcnPzvuEdDfIQ5UMPhVGLR32eRidj6pGx1
X-Google-Smtp-Source: AGHT+IGSanTw/9nbSjINGB+wa0ekuWSNdPXw0eV0oWOmOdDDWwbFvq1UjP8cchG3w+zKsb3D1P321A==
X-Received: by 2002:a05:6808:130c:b0:3d2:178a:c18b with SMTP id 5614622812f47-3d51baea352mr8661807b6e.46.1718958354744;
        Fri, 21 Jun 2024 01:25:54 -0700 (PDT)
Received: from lhy-a01-ubuntu22.. ([106.39.42.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7065119503csm860459b3a.76.2024.06.21.01.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:25:54 -0700 (PDT)
From: Huai-Yuan Liu <qq810974084@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Huai-Yuan Liu <qq810974084@gmail.com>
Subject: [PATCH V4] scsi: lpfc: Fix a possible null pointer dereference
Date: Fri, 21 Jun 2024 16:25:45 +0800
Message-Id: <20240621082545.449170-1-qq810974084@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In function lpfc_xcvr_data_show, the memory allocation with kmalloc might
fail, thereby making rdp_context a null pointer. In the following context
and functions that use this pointer, there are dereferencing operations,
leading to null pointer dereference.

To fix this issue, a null pointer check should be added. If it is null,
use scnprintf to notify the user and return len.

Fixes: 479b0917e447 ("scsi: lpfc: Create a sysfs entry called lpfc_xcvr_data for transceiver info")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
---
V2:
* In patch V2, we have removed the unnecessary 'out of memory' message.
  Thank Bart Van Assche for helpful advice.
V3:
* In patch V3, we return len directly instead of goto out_free_rdp.
  Thanks to Justin Tee for his suuestion.
V4:
* In patch V4, we log something before return len, which would result in a
silent when len is 0.
  Thanks to Justin Tee again for additional explanation.
---
 drivers/scsi/lpfc/lpfc_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a46c73e8d7c4..0a9d6978cb0c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1907,6 +1907,11 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 
 	/* Get transceiver information */
 	rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
+	if (!rdp_context) {
+		len = scnprintf(buf, PAGE_SIZE - len,
+				"SPF info NA: alloc failure\n");
+		return len;
+	}
 
 	rc = lpfc_get_sfp_info_wait(phba, rdp_context);
 	if (rc) {
-- 
2.34.1

