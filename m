Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E8A1990AC;
	Fri, 14 Jun 2024 12:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718369083; cv=none; b=UhL2/lpTsmQIWQvuQUAozjuxb3rnvgxv/J19MapxwDopcZUriSdm5g04SLgxuGE7LMOUPi0b6Afgeq88vlIow+4npQOiJBsbywXfNbBizXzo0AV5+PeWWfglQVhac54hMzOUFOvKLSipsezHDGeN8iHm2MsHPriaxNLmmJH5nzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718369083; c=relaxed/simple;
	bh=6haZaBoCzYDbs6gYHymH85S6kUGBAmgTaEwCfRsPvpM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TzbxPSNi62OlZUYgxxh/E1udYpXB4vB6BS8R9muyIMpYIN4QN8VkltxWRMAlpoYuRudBQjezoowoH5+EHn/fOKWM/ypgix0D58hjspooNLU6aQOzeCnJZZoo10PYDCf+RTsHMDWWbHbBNkMxyiFsIkHA66vshs1FZnQ1qVRvIjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xl+olCv8; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xl+olCv8"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-70423e8e6c9so1894975b3a.0;
        Fri, 14 Jun 2024 05:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718369081; x=1718973881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ID8vcKMAuhxPQfV9/bb6FKbXp3VjWvrumIK/fNKJqMQ=;
        b=Xl+olCv8tK/IkH6rHXbSxyR7PiAC4B8yNRIjYIhr6mmKYersjhlxcR9K9qjX7EWaPD
         llBVqLj3yDRbK82SgkVpeH1VIvxc8zBoKg3OAEgEnuWh/vyityPj0c22HHqnaGL15NeB
         w0Tew/iOACI9IVpJW/2iBd2ME7FyJOpMw5zqEn8hyrlLRoncBvbgwYxj9jl14sc9Kt2Z
         IW4OvjMc72kNryKKnbZ7NHOEBcMMKCN2i2q9ZCDQmfLQmsa59l7jkNfMTTAbyH2cxAIH
         3Wv7HKtuCQ5uI6Dkt/WCWOIg2DmsL2hlp5fvzmpSxfAIcli9J22B5OumpRYzrMjZwpAC
         tVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718369081; x=1718973881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ID8vcKMAuhxPQfV9/bb6FKbXp3VjWvrumIK/fNKJqMQ=;
        b=eQyZQKS6YcQB3A02qrQ8WcGKbLGT+8FsRJYOfVEJTlltecShbPnxNIOUuA71if4G0X
         XkEbfqbRbNt7HTYgYId4zSXH6TTgf8ZL1M58wtNKfrcIIZlmYUBH/Z6leDSohr11GVoA
         UNDT02wB9QKWskn671wGyLG1UjN9bVQJxWKqXOQSD8QQsgkPRO4SLA5VdC4FvfF1+AWI
         Wggm27FlhReUtQYkVYIKhJa2AHTfkz2oaw8NmHBHUMSDjaRmcX+k9vgydv5IwdVJ4qza
         BmV9bBDzFh+QDUXQP+IERd74ODZUdbhN9myHvBK46GmBz/kCc7QqWGoDFGJVDLM2/Sgk
         g0VQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa0js02t0HClUgsW0Ya1cG2FaK+ve6QG4mwQpbWAtAKCi6haxPTtmIPy+mpKx3x74vI/AYoPWSonGAHeh2neAXudghGaTbiyiRAAB4
X-Gm-Message-State: AOJu0YymsMByU9l6m4cgJhb05Hbcdj1kTxRnuYoQNzFvXzLMSlAh5ipC
	e2sLXugTIpWnH2nzxalfOormOssle8cDFEm4PLEM3ZknGDm4pN1/
X-Google-Smtp-Source: AGHT+IF6i2yJXoSE/ZnaP0Xb7S1w+yKGOYcVl1SB7CAAinDBAPE/W9opYHXowo+oPJhVfB+WzVROmA==
X-Received: by 2002:a05:6a00:3d55:b0:705:ddb0:5260 with SMTP id d2e1a72fcca58-705ddb05420mr1618893b3a.0.1718369081207;
        Fri, 14 Jun 2024 05:44:41 -0700 (PDT)
Received: from lhy-a01-ubuntu22.. ([106.39.42.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ce994dfasm2880362b3a.16.2024.06.14.05.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 05:44:40 -0700 (PDT)
From: Huai-Yuan Liu <qq810974084@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Huai-Yuan Liu <qq810974084@gmail.com>
Subject: [PATCH V2 RESEND] scsi: lpfc: Fix a possible null pointer dereference
Date: Fri, 14 Jun 2024 20:42:33 +0800
Message-Id: <20240614124233.334806-1-qq810974084@gmail.com>
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
just jump to 'out_free_rdp'.

Fixes: 479b0917e447 ("scsi: lpfc: Create a sysfs entry called lpfc_xcvr_data for transceiver info")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
---
V2:
* In patch V2, we have removed the unnecessary 'out of memory' message.
  Thank Bart Van Assche for helpful advice.
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b1c9107d3408..94d968a255ff 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1904,6 +1904,8 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 
 	/* Get transceiver information */
 	rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
+	if (!rdp_context)
+		goto out_free_rdp;
 
 	rc = lpfc_get_sfp_info_wait(phba, rdp_context);
 	if (rc) {
-- 
2.34.1

