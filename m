Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996822;
	b=XajEVv5jqBR3XfUplWM5SzvM4wqzLvznyOM+MGoKyHZf96GdWTTh6ZKb2CsxXQ53SpXp
	 2c0pspaKUpslOJ/NxUD7ITxhqM6i/3aCj1HHWtj7CxQYv639rDuMVVa+aHQqWIT7gmduk
	 1Wrg/XuNh8KNtd9FtQvI2NSn9uxSUypmcNRzZ+ie+rcRZ7RxqTc8Ol4+6vcejDzD8Hxm7
	 w84PZxfV91yJbyay1pR9CiO473YjMkKOPLpG6ir/MpKsBV1a0k9hz2qpz7PSfznUtoFz4
	 nEmY60uZCCxb5p9mUJ63vEg956YARVLQh9ba30lVd/K9IRbhojPyiAMKPoB9Rxq1z5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996822;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=RDENDjgdLnId7A3HIBFL47xdJ6GEyoh2YZECbmIxx68=;
	b=Gaiis62UOQjax06SQGEEthd7235WlmIu5gX7myYf0x+q3d9bE1hUEbYVoFgWncM0/269
	 CQCg8/06kMGe3a4U+huwvexF0MNAlChjHBYlXFWzNfxchgDrDc7PoBwxbblYrB8fVateS
	 4eoUpUm5PZcaNwjiPqZsg0eiDxivjXVxoivB5/NZO3F+UJ3NzpRecieRla5wMwnYdY2u/
	 SOnvDGMTHY9tnranrMgvDq1iSeIsHMJxniiX8raXagtjOBbwCgBD5KmImJpoFkJ55D/+k
	 DIp2rTnkXisCBi1lf+T26BllskqC8PAvGKqA3npfDyrCulVF8oSZHlBpqmzGDAymnrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZQg8f23C;
	arc=none smtp.remote-ip=209.85.214.226
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9457A606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9457A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZQg8f23C
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2e9eb579c0eso4810305ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996821; x=1795601621;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RDENDjgdLnId7A3HIBFL47xdJ6GEyoh2YZECbmIxx68=;
        b=g2yYPv6iymoPewrw/t9AV55RF1zvM6lALkZVCUY+z1+HAwELp49vpmLXAYQZD1zpRg
         zIvrEtNM1udzFZd5nDxHEam0LH82HksF5uyDjlhA0nrbzxBHZG6nWNY/RhKjIFQvcwja
         9Y1vsBRTkl3kVaofSm/EaqIbzq61Ku9zXGNi0+KVjLDA2poSD8El4Ruz1nGZ8YJ5/55U
         lKNEiFhNSnUnDLbwVBWGEUFYSemFMg/ijbx2E/oKBV9W/PHpZjF1C/Fl0gdMC9rEQzg4
         wg8us6eTtn0dLKhXW2NXeuokiFABgMzZKacH3zDi/xu468KoFH1U3P1TcBCFn1HD8MaI
         uEiA==
X-Gm-Message-State: APuU4Z/9sFY5PHZjNBIsnM/sUuWX2jaNh4JhRg+J7MxX809pr/1Pqrdy
	FXF/EphaAlML1RnR47mbH3Pmp72byJ5pB0yOp70sRvzoI6OiKSc6oMzhhq456AOH0jmOb/8g+zk
	ZDN2tniTN4MnXImEUXHKvqielqRP/mlW8obebDDzN7cjsLjo7u2y+K7fmIzbiakIRvYcNH4vIAI
	Ayd3c/nGUkV5oXHzsodUUMGcjVx4oeeW3PF+VU3ZbtpiPD3uYHBNSv7h9TXkfz7ye/4llMr/EOQ
	I07l8OJdaTX4YN2g510a7FVepc/yEVyRfE=
X-Gm-Gg: AZFdTZex5One59b7LAXItacb7PYHsWvAP4583Y9MdwYWfcBhrzKY30/zd6ShoOq+yC9
	x4qbsMc8Ru39So6IZI0jdphoUYwSwWBPHK+/0S8dUHF8pw7PJRowOe7jRbDWXHR5mPbCjdS9TqR
	OCXJZN6hJcXxn4LRuKof2skflwsrgY4+HBhDSKF8HupoeICOzAHXPQOrGoF0t08bNAFs2QWWf7s
	PCj451o/jO4gMOza0NrXRvM6GNU1uw60eQDYjqEc2Yp7o1tkE7dyTzL/HeaZnih3aF6nJ3HQNXz
	4JoCuifBGsZM0Kbb9jIDHworlhgqvhHvGt5sX+kLkQ//9Ax3Tx4qtIfoPv9DRa/SkBHv3ij404Y
	FCvGo7EdN+rYyonGS4Ulm6+7pHxQxd+w2emZ/M2Sc3PS1M0qOMgCXmi/aD9EwhvuIYSgd0hWs4u
	kQU9cjWCBJwwPXj3u2ynTaGBSjbxgdYGGpbKwO3ej8CrjgNI5i/Rio6PXv
X-Received: by 2002:a17:90b:1e4f:b0:3ac:8897:7ba4 with SMTP id 98e67ed59e1d1-3b3d0689b68mr2166359a91.5.1794996820890;
        Wed, 18 Nov 2026 02:13:40 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1cc7a0csm823374a91.1.2026.11.18.02.13.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:40 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b3a9826f6dso680152a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996819; x=1795601619; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RDENDjgdLnId7A3HIBFL47xdJ6GEyoh2YZECbmIxx68=;
        b=ZQg8f23CMuPWf4LbYLWR4M/n/hh032zww7H0sfAQyzN9h36MshZCJmRKFHHPO71SHc
         58W8NO9LEZbGpU5h4600WSH6hmQPrDV87NXhwTc8itmTHFyEq60Z7FWzVGQugeeBvwhe
         JVwJNR1ieyicxwUipgiSZuWpWkVUS9xqDndc8=
X-Received: by 2002:a17:90a:dfc8:b0:3b0:9cc6:62ba with SMTP id 98e67ed59e1d1-3b3d07d410cmr1897336a91.38.1794996818916;
        Wed, 18 Nov 2026 02:13:38 -0800 (PST)
X-Received: by 2002:a17:90a:dfc8:b0:3b0:9cc6:62ba with SMTP id 98e67ed59e1d1-3b3d07d410cmr1897301a91.38.1794996818143;
        Wed, 18 Nov 2026 02:13:38 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:37 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	thenzl@redhat.com,
	mgandhi@redhat.com,
	loberman@redhat.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 27/37] scsi: mpt3sas: Replace panic() with error return in hard_reset_handler
Date: Wed, 18 Nov 2026 01:56:36 -0800
Message-Id: <1794995806-5835-28-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

When rdpq_array_capable is cleared after a firmware flash, replace the
panic() call with an ioc_err() log and a graceful -EFAULT return.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7e5f5576fc5e..c973b6b02733 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -9108,10 +9108,13 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 		    " image and it requires system reboot\n");
 		goto out;
 	}
-	if (ioc->rdpq_array_enable && !ioc->rdpq_array_capable)
-		panic("%s: Issue occurred with flashing controller firmware."
-		      "Please reboot the system and ensure that the correct"
-		      " firmware version is running\n", ioc->name);
+	if (ioc->rdpq_array_enable && !ioc->rdpq_array_capable) {
+		ioc_err(ioc,
+			"%s: Issue occurred with flashing controller firmware. Please reboot the system and ensure that the correct firmware version is running\n",
+		    __func__);
+		r = -EFAULT;
+		goto out;
+	}
 
 	r = _base_make_ioc_operational(ioc);
 	if (!r)
-- 
2.53.0

