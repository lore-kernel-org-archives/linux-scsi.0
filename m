Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926803;
	b=tUViiHFPHsrldc4FSTme8bOYvaw1ZBNtcSNPj7kJ2Qd2uzZRMeHybXHqj9dmdFQs48EN
	 HhttC/8w9XIMCqkO2jfpoaBgW02f1miYtzmHsWnVys1+BGLe56+SRvg/G0aKKh1A3JIui
	 CvMMUcCQM1aVKzTRulGRE+mojPmn6FMcT4zsHUU77ioXHHax1K1rGiuyMCcEywxw25B52
	 rsMFJwZirVVaaibpbkBsGhk8rOtfQXuseF+ctEWJMZ6o+Mb7EYBMLanfmV3g2MV9etL0b
	 DFcjdDyqptlpwTApdwwX2frfR4fMXChpqHGK+KMw3szMuyLWSB4a+ep+J8ZrONMKdaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926803;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=0U35rs0HNvj4YsNpryL5cxWhlW/C2mGx/8DGQO0GhWI=;
	b=rYU9VbRl19Mt3HAjthLWlZlp7A0T3ybPE/w+ApdwjVC07ubdu5sm6Kp9/WaQVHORDd6I
	 A4HHZPoEZsgVBltymMTweZCYsghZygSi0HKxIbBCoZhFPa9dpeacIiWL2G3rWQcH7/WL5
	 in4zN268E0+GFoTRvMvkeC+HkKEw2z9F6SjQl+GVALva//9vcmC7hBYDrBbYGf2Tt++td
	 WJiweArQgAqDRl930L6MCFN8sEp1oDpgbFyfvEsW6WGi5cAtjVZbXZQwBaljnZLVoiR8j
	 mRHo6Li2iM6wCYFHau/aL5fSKmhtPjp7Pcr535Zx9ei/oSi1LK2Nu+TLbMuplnMKysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=CL2CzhxE;
	arc=none smtp.remote-ip=74.125.82.228
Received: from mail-dy1-f228.google.com (mail-dy1-f228.google.com [74.125.82.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B665606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:00:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B665606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=CL2CzhxE
Received: by mail-dy1-f228.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso313956eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926802; x=1794531602;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0U35rs0HNvj4YsNpryL5cxWhlW/C2mGx/8DGQO0GhWI=;
        b=GYIZlQG5CbapVRXF73JJAdy7Rpmcg/pV6He4bK+Eqcx7Cu+4wocRphSxZyARM/oH0G
         xPw+IjoU7c5R6IKsqcIqwEJPGDdUqW4Q5e7i6ro0Q4Rua1cdlcunI3KfcIqj9g6C/p7X
         ZMC7I897ota3bG76lu6jN4lahiH6I3GPE5444ce9zdCbdZFSmy6ZcNY00pWEtGtp0/2k
         WHIbthXvOVCFfeoeZd+gkubcQWuP73/qAhOVB+JRM9Zpd7YCnk4EtKd+aMqmXQJJ54o2
         OYV9eZ81LRwVMMIVG3jqdg5sAQr++RpesQsESweokNJuei7AvWWFlsGuZM8uG3UQn2Aj
         1flg==
X-Gm-Message-State: APuU4Z9kQwq/2kd9Doh3JP5uks2rdaPIcJyxyHGw/P5Z/W48uU5KJ4cz
	qdLamEpixV8u1D8Kmi5ZjUXDrllN2e2PdCaLqh0nEidyRHYqFU5URWzciaUb1lKowvVDFaN9gtr
	Dsxt34rwW06oLVF9f6Gy/7rOkViphalrbXXvH0BhcaZpcOkBTGNXpSORo/7d0j00x+ORZEfHvJU
	CZ9tOrbYne/+qrK9eGfffd0mvnrtl++OcW/5Wp7ldwOmCr7yRDlgBBtJibQebRbZCNY93QhXHdr
	sWJ0uWz3HCXIbzIz+fssZu8APchLJ070zs=
X-Gm-Gg: AYBFou1828KvodJYw1sGdcMMs+6gT+iwLLJHBQ50t/M2aAI0YQWkdWKmE6uSzmNhysU
	y1vzG3k0Tmhu6gp3+/yx2k3XAYTDpHQ1AHckzMqMejQJKBa8RxMl4Cfc978fgG9viK8juQk9Oei
	a6xLPFMiBAw9dHirJFUbCQLV0IJw5KNCfwlqPfRBAPm4mzF28LVHfFZ7T3jFtoKHoZMO32pFzXU
	WLXUL4jJSG3ccFdLgx3W6aXx4EHy8qIPgrEqgbKixG8YrhBhi6BhW6D/8sEjEbxkHXK0nrNseAs
	G5IzWdZOxYGXk9F82wk+o+B2pYun+onUrcjdnpuLJ+6sx+qFzKvTNYncYX5oq0g03HUZhlgfYTu
	QeGwzr5N0o3cCGPyjuS4XGRlOEpKQSIlqVK04dkIRrEhZ63mD9o/mbuHlCnYApAZwEAQVGd9r+q
	h0b/a+DVD3GahUqCIS71fOE0DPvTJ7xxSWPSaeQdw/aIAhgdrR8IEc0A==
X-Received: by 2002:a05:701b:2207:b0:19b:39f4:88c9 with SMTP id a92af1059eb24-1b25d305844mr936217c88.10.1793926802228;
        Thu, 05 Nov 2026 17:00:02 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-1b25e258c24sm7974c88.0.2026.11.05.17.00.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:02 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ea63087d79so1179085ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926800; x=1794531600; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0U35rs0HNvj4YsNpryL5cxWhlW/C2mGx/8DGQO0GhWI=;
        b=CL2CzhxE6pY/qDmOsHN9Ls7LTP80wx/NMqWM2NxXC/9WWi/N84x7nT04+PNLsDRe67
         bG9NgmAuqJL20k/+1fgQd95+HwaMIPGwjiKnwHImL5qQ0jbZPB0REvOLIEgJ9mpBXg0T
         6jonkFoMnsCQlKa/olorQyyncXBeSk4u78w+U=
X-Received: by 2002:a17:902:ce03:b0:2e9:6790:212c with SMTP id d9443c01a7336-2ed40c494f5mr14727515ad.30.1793926800348;
        Thu, 05 Nov 2026 17:00:00 -0800 (PST)
X-Received: by 2002:a17:902:ce03:b0:2e9:6790:212c with SMTP id d9443c01a7336-2ed40c494f5mr14727295ad.30.1793926799863;
        Thu, 05 Nov 2026 16:59:59 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:59 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 34/37] scsi: mpt3sas: Release sas_device reference on error in mpt3sas_transport_port_add
Date: Thu,  5 Nov 2026 16:42:49 -0800
Message-Id: <1793925772-1303-35-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

The reference taken by mpt3sas_get_sdev_by_addr() is never released on
error paths that branch to out_fail. Add sas_device_put() there to
prevent a reference count leak.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 1041ee7591bf..4ae11f226014 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -866,6 +866,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	sas_port_delete(port);
 
 out_fail:
+	if (sas_device)
+		sas_device_put(sas_device);
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
-- 
2.53.0

