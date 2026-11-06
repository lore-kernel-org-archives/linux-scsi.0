Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926758;
	b=iDW6lP8jWc07i5bI9xGjt0HClYKuDkkBxnh9aBVRca31NRUlpSBO3JWSUbTIrxb39nKt
	 eLnJLifi5nT4T571r5TbaJaFSIFAgVir4qLP2NHwCslo24+aXWu4cT/PJwy7rYMm8vbQk
	 7yDwcPhyd9LTKuY1/ZBFF4zchl9vMsaUl6x28aDUUmZ3kzQTQb8ARiJALy9+qKPkn+ppG
	 hkKu5xAEq6a67BeEUeYhdEXKY5LmyjWNjX9MAnAluGG6AqqsHOB6tSF4+Vdw+oqneXzCL
	 YBjuiELZQ44JxMFnCtQ83TLqNwXYmHosk4BgqC0i81isUQjgLWf0tTEVt+N5bVGkZtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926758;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=QL4m/SzrBkD70TCdh1Oc/+1d4S7jGnGOqESeY0UeUQQ=;
	b=YDWvJDIqEqs5FBdVLrzOosuYRMajVDWhS9+XRsoDpPIUS59niOhPitQmtBOnP+cW0CCY
	 KaXPlJJO0FuGaBPio3fWYCf3v7yD7MThncJOI1WxjuF5lxZAPnzyvfyQFQqyXKjaN7aqC
	 K1VEMsjvI5Fnn2uhM7yW814I+ITC4bTCjRz5rYvc7xomlR60dSdAcB/l76efaIq9phDL3
	 LYclfL/uxTbuUa4R5L5K+n7JvH3gS/jMpDq15RjfLRh/pFQuW8Ngh6yZrbUuj2P1udfSj
	 h6tWOrO91Pluo8cMHcD6q63CdgHfU5yZp+VLWjohyaRw/YhydTj47NR5ZMh+lSoHvEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OCmn48pg;
	arc=none smtp.remote-ip=209.85.214.226
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEBD606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EEBD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OCmn48pg
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2e96502e447so760795ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926757; x=1794531557;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QL4m/SzrBkD70TCdh1Oc/+1d4S7jGnGOqESeY0UeUQQ=;
        b=K8OwEQHHj16+ObQKDar4xVKowO53EWgDlQjaZRmT8dTqoNeb9DTVk0doHKipSVuwTF
         IqYpBdeCZFw/hL6FpaIcNLujipBCmLxdn9y2EVwbvvMClmboCP/VwgGCyMSNDsWOdKOu
         fOGAsInCYQHGhyu7C/FJf/IiNZsPpiYfJ+HGJ5zf+m9fbz1uEIpwnCFVrMpqiixwzpa/
         iG3tIOVcJo/16SN28lJGIalhNcO6yyk6C+wwqNM2OWNtcrqm0/8ajNJYZMXKP0N1/npG
         vnjXOo+6//+28UYiNIyrKV26IvGCaKbNQb8A3yIf9isrOEyZWIFp9hTg51JmLwSEMqdR
         stJA==
X-Gm-Message-State: APuU4Z+jkDuGVqv45l+BvH5Dcw8umh9yjr+EDM/WZJ1CL0t3UCxJ8Htq
	RM7rTCk97LUqR3ddsWv5++D7Wn87HNuZlLkGTPxQUU36r2NgL+oO0xdNuG8f9rgKjXo41MAv61j
	Gf4JtVRRbIqCMQDQy3DErz+sD+XYUomHwQsvNUB2g7ww3Tgzpb90VPnD2YgRW5yydQUhj6xWCar
	KkepAJeBcvf2L/PFfLmIRC+bODPCjm0+oL1UwmQkOxTH1hoWZiA73uRENBlRrJi0p+XXjADVTFd
	vEEumWSgxmY5Mi6qxK30Xhj/VbogJ5+kYQ=
X-Gm-Gg: AYBFou3HfmOVr7sQkBe1g42jrBHNCBDESBDSpjVZcS+rj61cM9uUufeswoNO5ypSAwM
	+G4xj5QDrtyLdSl1cOerTDvpch4a8SPgTsPiNFCTl17GKBuE7lkcy2muJoJFKipvlKW9FUJ2FO/
	/2qO65DCqf9EsFMfIRl/dpPr0ssyIpCGnapjfmlHD7mY/lEbLtltmNg0UioBXp3f+1Eg1jhQkZ6
	PQkEwPaelaWr91srA7xGOXCZgccTkMbJiI0KMySrvZbaVun1p4h/OeUFQtsvlqnC6OZHavu6WFL
	ShNuGQu/b3F0bcynaFANW2KC4JoUf+Bd4CApVtaNQyePMHGd9R9/E2eM+49cRGiBan1Mr4GHIIC
	9QQEumCXaDgu3fkwnFjaJZMZQk5HN13flt/fq2figpFFzLC/oDRUPr4+b5TjbZbkZvOs1BNn8Mm
	RVgwqox+8H8awvE4Sc/jJt7Z3eW2oljPn8rmScfhC5gtWWMNe7tEhQKw==
X-Received: by 2002:a17:90b:57ce:b0:3ab:be66:ddbe with SMTP id 98e67ed59e1d1-3b0db6d649amr644008a91.28.1793926756843;
        Thu, 05 Nov 2026 16:59:16 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b315a3f7sm3012969a91.1.2026.11.05.16.59.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:16 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed05900df7so1232455ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926755; x=1794531555; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QL4m/SzrBkD70TCdh1Oc/+1d4S7jGnGOqESeY0UeUQQ=;
        b=OCmn48pgv72TRV/mZGUgM64bud0kj/4foOmm8oHScYlMS62uwF6r+t0BUJJrqOq3+0
         gONi+eQf7Gj5JumRdfFAZ2O0r+DnKULpWUhz2ZTzBduwb+qkern0S4x0Q/0yniwAE7GR
         zxusC5ms5gUdc6RuMyeG4hGnVulp04gCH7XbY=
X-Received: by 2002:a17:902:d584:b0:2e9:776c:d52e with SMTP id d9443c01a7336-2ed41c0ab5dmr12651245ad.52.1793926755229;
        Thu, 05 Nov 2026 16:59:15 -0800 (PST)
X-Received: by 2002:a17:902:d584:b0:2e9:776c:d52e with SMTP id d9443c01a7336-2ed41c0ab5dmr12651075ad.52.1793926754686;
        Thu, 05 Nov 2026 16:59:14 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:14 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 21/37] scsi: mpt3sas: Clamp sense_length before copying into transfer_packet->sense
Date: Thu,  5 Nov 2026 16:42:36 -0800
Message-Id: <1793925772-1303-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp the firmware-reported SenseCount to sizeof(sense) before the
copy.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 59ec75e0736e..073a487430e5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7579,7 +7579,8 @@ _scsi_send_scsi_io(struct MPT3SAS_ADAPTER *ioc, struct _scsi_io_transfer
 		transfer_packet->valid_reply = 1;
 		mpi_reply = ioc->scsih_cmds.reply;
 		transfer_packet->sense_length =
-		   le32_to_cpu(mpi_reply->SenseCount);
+		   min_t(u32, le32_to_cpu(mpi_reply->SenseCount),
+			 sizeof(transfer_packet->sense));
 		if (transfer_packet->sense_length)
 			memcpy(transfer_packet->sense, priv_sense,
 			    transfer_packet->sense_length);
-- 
2.53.0

