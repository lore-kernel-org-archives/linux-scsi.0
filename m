Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926778;
	b=ZO59ZKnodirmiliklwjbJpVd9hMVA1e7Y2F/AGo1n6r7k8vrPTTrb1V57ZWBh3B8I5mI
	 JRJZHQMo2in6V9270Nhb5HHQhTG0xgH07ExgOww9CvL6FfHoI/FsihVkQN37MfFoE/qwB
	 q3M7C5rziT6Ip3zmApsKUfMPnX6r1+iFIjcJAr7nEhzGPNpPq9T8xqTsGxZs5kkzuZlzG
	 KEZW8zQ/PjOs/9Y6RiiODwzDziRRelv2DxHmoClppaWcGwArzmPnoe+nqDzg3Fv4jUQLW
	 NYF2wkdgwf+D07TqLQWn2SGDKE5Xv+6yh0gqdid5aYCL1a6UZWtTFwNDGT3ThUc/GSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926778;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=vih7m2czqLEAdlEJPQb+Iua3nat6BYhP8RN+soGKBCw=;
	b=2jHsV1qGVa3bCPoayyfd1LljKzEiEYn2olp8fUtddApxYJpYuAYN+SZutRB7Vuxdh6i7
	 WkV6OJNPInnKrM2v65QTFpGX2gzhpWJu8TMYqj/rEHwYZqIFfOHDP7TXWSgaddW2MxVM/
	 n3W4l3EJgnTPhrMPYJzsIKPXjIyGWCYxWecvlJG+0lqbI+ZO3c6rVystuk8XG5C+Z2myS
	 0A+6k3zeA0PMJtAuJrSSgQavbqtmIvG63xGPdwuL6/0joZtLWyVDe9vEz689KZGwewS+k
	 D6gDtEtWRbbzKCnxjey6pOPpbtf9c3UUjjf3yFErsgDDf3v3b1mTXfbjVwP8qIWsUNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=fLH0wx3K;
	arc=none smtp.remote-ip=209.85.214.228
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280C3606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 280C3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=fLH0wx3K
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2e9d1114320so731245ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926777; x=1794531577;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vih7m2czqLEAdlEJPQb+Iua3nat6BYhP8RN+soGKBCw=;
        b=YWFSnsiEaaCDpT/msGzAo85tJe0AhgX/yrE7pdgOK3GQWN/HGEufW17PMNs8qsVUZT
         pf1DRBDDnUbDBfJm6Z+ELhfU8oEknqanIrzGAxrgh20nGVZ8kOA8tHmiZ/kkXzPIhkA+
         LQhhagWkPNg6BOxHnHZO0l8X3J57A1hAgkoE18I1yGEDTJsDahIi5ekGuY0IWnuXT1Dk
         RN3BB5jqGObjfyQ3kMmlI7XhZn6KHMfg7h5HCvEyaFv3+ZiChl6mGMoJGmsvV8WUYmwA
         HiFxCIvZjw3CeCTNjCHO3VSfZSzpUYhW0lWI9yYXXbaP1kiYuSPoqJuA/sXfMr3/yksu
         L/6Q==
X-Gm-Message-State: APuU4Z9pFLhC8RYUFn699MAXVEBzDH9P3gc+DJBG5zIufOFl4TzZgOby
	UlXXf4o3h9loPhjBd+9JXUorIH8SdCu72b/dRYf7lg+spjOZ2CkrysS9BZUg8Gan9bYoiwRnfCZ
	zc3TD7fRA00kAE/r01oZhFSjlBg36L8vJcx0SdVs4VKTbVyRoX0EV5jonortuMb15KBv6hsbuNf
	Bd4xlqHESrfSF24C28jZo9RDP5RK1P8LtC7TqDyGPhBXrbkxrOy+qvgFwy6RzePuz/XCOmuHX1H
	H2E2gGlgxkTgHICwfmOaIsCybFBzlOnTuo=
X-Gm-Gg: AYBFou3aupKuRbOZI4Tf/2vtBdX2bbqYgwReNc6UCjTrOjvRGn8zTXEUY3N1j8GV83B
	+ENvDPbqPJBKYVnfajwxfrioK7mJmP/3ZCw0LN0hLtw2m1dKVpFQPy2QPy6sqkWJrYPvG3ouwaU
	ojt76IdHUli5rNP9H1VqxgckogvBVlThh7KAlEAZhLW728MMpPyiPYGrjeWSCmrLyDEb+lQu7qu
	dPT5kSC1Xk4iHou5XpH4T49dYPn3GakJuOwR3IyFDJL96oZx3dIdsNnO13W1MiWe7tjKeMZX9rs
	802Xi/kJVgtDhIosY/sbq+skEBFn4S8nO3LLwiW+/3du/qK3pwSDLF0dtvnyPa5+pCAJRPJEdLO
	dL6NgyFvMAl/OoiHxr+Srpvpm5nQQScLbFN3N3Ra05vf1KsSrA1CyksXKmRWSSAyU5t7R70f29Y
	sVJpuSHhT7IuEhNqKzBnzgpunHO6Ay+Tp03kXD1yd4XiX6JssLH+GaTg==
X-Received: by 2002:a17:90b:564f:b0:3ad:c4e9:7beb with SMTP id 98e67ed59e1d1-3b0db6e0315mr772970a91.43.1793926777340;
        Thu, 05 Nov 2026 16:59:37 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0a7d138d4sm1678364a91.2.2026.11.05.16.59.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:37 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed2c307e62so1769865ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926775; x=1794531575; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vih7m2czqLEAdlEJPQb+Iua3nat6BYhP8RN+soGKBCw=;
        b=fLH0wx3KA9ysID+nAHUxcwO1+fOBXP/Vn4qWXVVBds1YVOaCS2tkgASAGYuHNydQgH
         Xa866zrMqXBMPUZhXqLZauXP22CdOG3gZSOggr3bpa9jMdiKvTs2yfnZPtFoTixG6XIW
         sHihvNXMNdC/Yo7T2MsHJ1VUQtpTDZ2c63wCo=
X-Received: by 2002:a17:903:3c64:b0:2ed:f9c:3e5b with SMTP id d9443c01a7336-2ed41c6a865mr13538365ad.52.1793926775362;
        Thu, 05 Nov 2026 16:59:35 -0800 (PST)
X-Received: by 2002:a17:903:3c64:b0:2ed:f9c:3e5b with SMTP id d9443c01a7336-2ed41c6a865mr13538175ad.52.1793926774819;
        Thu, 05 Nov 2026 16:59:34 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:34 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 27/37] scsi: mpt3sas: Replace panic() with error return in hard_reset_handler
Date: Thu,  5 Nov 2026 16:42:42 -0800
Message-Id: <1793925772-1303-28-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
index 1af9dc241666..7cc849dbf706 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -9069,10 +9069,13 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
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

