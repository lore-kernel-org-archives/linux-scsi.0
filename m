Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3766115535A;
	Thu, 20 Jun 2024 12:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718884874; cv=none; b=q/pIJNIZwbsVByFKuW2immLDl96IfeqMbDyi/8vNuveztkRvGYKtswlEYTUu2kpz9HGw5GgfJMVK7YJ2UcUeS9RHA9mf8pARQk/0g5tcd1M+TiyoBZf7onlLljJxqvd9GaV/Kz93XjDRUX1S7G03ZO0hYCI25UDBH6SCUeIrgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718884874; c=relaxed/simple;
	bh=W4yL/5i1kNtJaJQhYoGE/VtURx3W0KrN7GvkKdi+Tlk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FJKPIis9xMxoY8wGisXxjtpLH2if8YKElwcwaomx0SR/lMGaNauiVxJz8lI98isb7KtK10W83pdHkn4gTkSlp5OGV38SDbOkanEVw2ADuBWqcIXXFE8nZOXMZ/u/T7E6UBHdOw9mNXPY6j2ybGHBpaJ3Rm2IzI2s37bRXqVrsGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQWy8b1E; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQWy8b1E"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-1f6a837e9a3so5351315ad.1;
        Thu, 20 Jun 2024 05:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718884872; x=1719489672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YtNJHhlV6mJ1v6W6jC+d4Qq86uRWEHCi5uCcFwKEoBw=;
        b=XQWy8b1EFNWDroTTSggoqNZ+IFk4X0MkWNfgEYRhcb02Nz9bidjX8N8s7E8y1ZI0A7
         yXLpoXBiJXD5Tv0Op+9fJ1phlKdTo/KazSI9T8sxafIkkJmkIRkcMYdaBTFJq0A88suC
         1y/U0B+mTzauKgBmkKoqmAc6lkfiMKbgCuuq9QkBUvmr+3En4nXdExDHp1koe5yO8552
         3f8nIJgy2fpRy360U8gbkW8IHdolv1D/hfVz2DisbhZT9yB5HHAE88bJAD+7iwXYd9Yk
         sNXJyTe5nHRy22rvQPgRte5QfD5eQpxADlbljbCGTFEDve0vx4ivVJVKpdPDmx//tTIW
         +VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718884872; x=1719489672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YtNJHhlV6mJ1v6W6jC+d4Qq86uRWEHCi5uCcFwKEoBw=;
        b=n2gvUbZ87R4LVrCgTrEgRgmsCUercSwSQZ1lx+z/FXC2jO+aRq/Yo5CC2e3CkGxFHz
         NrXZU0Qv2eEJmoSO4vQAJtHKwokyQCslvGCfSd9RDiA1EwLGeKDrxgu7qcWnkLJMNo43
         ty5cCN5HIkoP7lHrgkQTwmrGzXTiLYFwzJnsFXdRYA2h+sQ1lErXqzA+B0NXzXXGB3fA
         Uzd3h4C9aOlhEUo7SF2jIlruAHOimzFoFNjLkXK03EHhHZDn20eJo/+EmdAEThIpg6xQ
         wfvMBAzAtmr9KZA/kxmhmQVDpB6KfXHChKYIAFBq9qAd4ypJQHY84QwtJwiPz3ZzXkvL
         vixg==
X-Forwarded-Encrypted: i=1; AJvYcCWkcSw6ZTrOc1phD2MCL2XdXb8KQkaqMRiaUTRije7qg3RZHoRDikkN+OrSHaxSPWSBJqOCVa6jsobxwqp7cVVVE4teaeP3nXkB8oCU
X-Gm-Message-State: AOJu0Yz9NWDajW1IuDgu4II3adnjubNYXL8O1JQSySpSl24NlMKfzJNP
	2etPcEd5Nm6Phk7rpqp1cja8J6euwth0LumSbDgDKXiWS/CGnCQV
X-Google-Smtp-Source: AGHT+IFONsWMnnvW8kz9aeRXrEqy7IIur28O0PLnCHzbWoz273VuTzabXuU6y5y56doY95zQ+6VOKg==
X-Received: by 2002:a17:902:f54c:b0:1f7:92b:4e6f with SMTP id d9443c01a7336-1f9aa3ec3f5mr44204995ad.29.1718884872181;
        Thu, 20 Jun 2024 05:01:12 -0700 (PDT)
Received: from lhy-a01-ubuntu22.. ([106.39.42.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55e54sm135628135ad.23.2024.06.20.05.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 05:01:11 -0700 (PDT)
From: Huai-Yuan Liu <qq810974084@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Huai-Yuan Liu <qq810974084@gmail.com>
Subject: [PATCH V3] scsi: lpfc: Fix a possible null pointer dereference
Date: Thu, 20 Jun 2024 20:01:01 +0800
Message-Id: <20240620120101.419437-1-qq810974084@gmail.com>
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
just return len.

Fixes: 479b0917e447 ("scsi: lpfc: Create a sysfs entry called lpfc_xcvr_data for transceiver info")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
---
V2:
* In patch V2, we have removed the unnecessary 'out of memory' message.
  Thank Bart Van Assche for helpful advice.
V3:
* In patch V3, we return len directly instead of goto out_free_rdp.
  Thanks to Justin Tee for his suuestion.
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a46c73e8d7c4..7d1e38ea9e52 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1907,6 +1907,8 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 
 	/* Get transceiver information */
 	rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
+	if (!rdp_context)
+		return len;
 
 	rc = lpfc_get_sfp_info_wait(phba, rdp_context);
 	if (rc) {
-- 
2.34.1

