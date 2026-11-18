Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996806;
	b=2d0DVF04BWdMrulj0k3SNYYgxnEJiGOXgaDzxeORVE4N9lvVt2d9xj4dyh7z6AYLmKWm
	 JoLVTexW1thDbdjvk5la604DltcYsZof9TkU3+sRd58Rb8dx6GBiXlTrNePtoxyZu1QV9
	 Y2r2TiR94a+1yBNasSYQPAvV8e1ecJ/8Oq7t2XENWNik4L33IYTrvyOVkRBqVehxB9qlC
	 Ubpn1KoPIEarIGwySRAwF3irNMMHFu+3boc3qNyHjLoAFgxIZMbfmkASuH10ggLoKzwXk
	 Ma3LJyKbVgAypi953xEp9VkHvGqW/q4N2IqEnem9Dl64v/zIrf63rV9/X4m+rKR9CMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996806;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=xqivelIK07N/h484st/yfzFMDvHNJcFwOpyJa45RnzY=;
	b=Nipb0E4Q6r839mLiOorqZBbJm8vmtkaxEWZFa4vRs8cQQCHcsNku2RFa3xp5fFuElmtk
	 g1dz+13x0VfAU+WUlmy7WLk4M7XCRyFFXBv+YxJIU0lDzJGIzuuUg7tRf6CTdDUWs+7Nq
	 GA4rFB6PLz15jYYmqlWhsRMhXM7CrbvaIfN8VkLVQnZFcSNv7/wRM7qZp6wjvt5KYe2jY
	 Jq5W54lVRqquJbh2h740HLvqT0Q6W8nl1woXnatPPcWJyOtjmBGzcvwqaoQ6AT+DE9JQS
	 Lhs/cor8Ll94wOJOEla4sF1fPptHTf2MVcnMsuA4w3rWLc1SznOo8QmFsmFFRdFhD6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Luyxxd8+;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071B7606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 071B7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Luyxxd8+
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cde4b4e936fso72875a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996805; x=1795601605;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xqivelIK07N/h484st/yfzFMDvHNJcFwOpyJa45RnzY=;
        b=mscYAaRFIow94NFBfripmZoW2NWzqJpQEF134AWW6pxrgVO+56m5EohnmNslchKIbP
         vwPCaCJsnfotUK7jXYEbZRPp5kS45fF+Nm/tPYP4ihul+wM2H/V2tfeYTAA2ilD9e4c+
         U8yGqeMQcD3f4jjtcyKAZAcAbL0UDI3F8NfQmlYVK6iSJQZFnTddsVmbP9vKMXluIczc
         WSX84yWB7HoZeJO2/mx3VQtdLQJd4Pjmy6+X0sR4ccwYbHyIm4hJ+dwLNI5yPk2VctQr
         eeDj4U1kPxnqjEuvyzfS4rlqX/XAhRhU5BSaZBBqyFvSqUtf0/eplmoUGMg/6FZqDaI9
         N4jw==
X-Gm-Message-State: APuU4Z8cH1pdz2HroC0CmDah2tFDR+bOxZr2hnz94h8epMLf/oMO8Ahz
	W81HHyT8VyExW5EMY9ZGsYFpDa0nrjbmNX1rdcHgJ7BD9WT2zdino/qBljkPotJuzyWFzEi0pgY
	/8Vmj6ZemVQ5mxuxePPSQy9AAXRi115RHcBRS0tOhg0WXLhR3ShHIhqQnmmw17vPWPAtNIqqWS5
	ooMpig0ezWcTzZtcY9JtXWMcotEWy9iqNjSfkHLso3O1KpFZP40QFkTAjFXcCBMg6PU642nL7Rw
	iaQvK+RVhIONZNvcZmG729VtRMZAEdbT14=
X-Gm-Gg: AZFdTZf0wk1McfbgH4fg0sjLVOMgR7PvGYTOgVZXOEWWr/q7J3GXkGWScSylM7bofDi
	Q5YvIxeQJAKnERc/Ie7JhCoOg8kh3B0N2yd4lmtT1pst2tp95+TxR8UpXuw+I2eBURbsgPBqG05
	UqgK4CksTuKStquQGwe4CXuSd9id7gTlWYxYcs8P8EXdQlZ/YqmAtm8rZucjtmvWQf60uybocpa
	vvrWvYh0Fx4/idG1BimsK9yDH7UFsffT9/av4somWOdV0JoEiUf4xkefi6ZI1WBY+VxV4ZqOtuI
	QzsjDS/WxcRBn3giySCKVrJfpUIhSdkvLj7YO5rAdrfKVhLlMsfB2VCPoeUJTKEEWnpLU+36cZe
	KjUV3RylonnTx27s8k87vwHDnm4+ylmMnxaF46dm8DnY9Gv1I7JuHnDuq8gCTmtFGTt50GH66hH
	k5bNqy3M+fwsvWIE8m0q59ZxfsrINMR/JyOynD7tC28qSaxdAbYmIwKg==
X-Received: by 2002:a17:90b:4a08:b0:3b1:bd6d:fcc2 with SMTP id 98e67ed59e1d1-3b3d085a434mr1475372a91.40.1794996805273;
        Wed, 18 Nov 2026 02:13:25 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3ac020c2fsm3976749a91.6.2026.11.18.02.13.24
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:25 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b10afdf947so2668168a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996803; x=1795601603; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xqivelIK07N/h484st/yfzFMDvHNJcFwOpyJa45RnzY=;
        b=Luyxxd8+FknmQIEvmNqSXExmo9wtqseYLtqSB7Z26JjvUgX75CavYNZGAlXfZsBH06
         qRMIug1a9fqqg5tHVOnjDXkKPRHRLJy4fAsLP6TlFkXZg6G4wjGkPWnoeHQOdW19aBCL
         oRPtoB0cpfoz1Ctzk288HP3TxloBM4wdDTFKY=
X-Received: by 2002:a17:90b:4c8d:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b3d07d519emr1550111a91.23.1794996803308;
        Wed, 18 Nov 2026 02:13:23 -0800 (PST)
X-Received: by 2002:a17:90b:4c8d:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b3d07d519emr1550088a91.23.1794996802758;
        Wed, 18 Nov 2026 02:13:22 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:22 -0800 (PST)
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
Subject: [PATCH v2 23/37] scsi: mpt3sas: Validate phy_number in mpt3sas_transport_update_links
Date: Wed, 18 Nov 2026 01:56:32 -0800
Message-Id: <1794995806-5835-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Check phy_number against sas_node->num_phys before indexing the phy
array.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e88205b69067..5f087d0b4d7a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1176,6 +1176,11 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		return;
 	}
 
+	if (phy_number >= sas_node->num_phys) {
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		return;
+	}
+
 	mpt3sas_phy = &sas_node->phy[phy_number];
 	mpt3sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
-- 
2.53.0

