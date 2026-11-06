Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926738;
	b=4lztpEgUKtKNXP9vso281r9u9lOfSu2VoWkCrTx/kYL4r2VpTcH/wgaiuJPTyPwz+n2H
	 UabZm9Txvjn5duN7kOVNOgSKQ+C1K3I0JdVZsU8/a+7yuO8+1wBu0QHKnmEEFdyf1EMJn
	 syLYmuZZiDMoVJ4lrok9dP4Kf4RSgsTj0rWix1N/9x/9RZDhxRoWghlKbhGc1He+NbrrP
	 IBjf862VnSPrsov8L1j74tZ5oCHsq26+aw4gVAsD+RPMuejKZuMMYDqW8I9RrMAVSulCP
	 PfmRpi9Kr0ze1RLe073dpZwYICKDnTxMXWaSefy+nGKtlTu+wWuMCuZYAssZq09vT4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926738;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=Z8Yo3fC3yMCZvIGq1HQSYCLq8uP3MBjrUZTsB8dkO6w=;
	b=hkQK4uZovAAz+EtTojZjuxlhjJe9uPhvAgWLQPsTP0o9MYdDeKZSZvPpQ6zWe005J/HY
	 Uo4i0Q6Vxf4eboBUKRNvBcRw0y6aazWvy+pj2Kog+vhBYDwbwVeOG9W7UHLuAPQyk68zg
	 4aokTeARfzZA4iv/WW1aY/jJiH8zg9OvspOmYjcn83QjRUVPaGKyued9FDjwv8MkhcdEb
	 B2jd8zHP3j5yLUyC9iaQZO3QU2q+3MDQLfFczvpUvElQdHJyWsiihkUrxljnNM4cHmT8e
	 OvyQrpHAMMxaA3BMR02YVOHVL26J+cvuQgTf/5W3pd5HjwyQ6WqXCX6/y7SjpP+thuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UI5O3v0w;
	arc=none smtp.remote-ip=209.85.222.98
Received: from mail-ua1-f98.google.com (mail-ua1-f98.google.com [209.85.222.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161E6606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 161E6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UI5O3v0w
Received: by mail-ua1-f98.google.com with SMTP id a1e0cc1a2514c-9950a7530d9so30110241.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926737; x=1794531537;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z8Yo3fC3yMCZvIGq1HQSYCLq8uP3MBjrUZTsB8dkO6w=;
        b=uX4SUFMBbM2Zg3WuI+mJ9jL1q70UbecZoRiICTJHOfYddM8oqj8pvM/AooFmhgltmX
         u9aGSbFSTGyW4+tlrk7d2PRd4M71wxAp9RWhfAK/bleis7mzhEZppjSt30vXrJdbDOwy
         3S16pjIROtZavSnGVJPvEIDr/RbmPT7d6Rs3E59d7hClk+xT+nBe6VJNG1JObzd1xd7S
         IJ1elbP0Mk2ukGIFsmz1ld8JbW2Zm/X4ii+Z/2QvmgJYKvBv8l1cYg/DL2Wcb1UoxPAR
         VoPNzocTKa/J2WHfL2Kp8x4BVJyzDlAMUTycIfzehDlICgIIov4EysOQqsthJ72dOcDh
         OpwA==
X-Gm-Message-State: APuU4Z+kWpvP6WSr+LssjeZ8yboXmY1LmeiezpKeLEycDbg+MlwW1Tqt
	qpN9gyXHJ2fMm01bEaoJNw/Z+PgLzaf4fBFEMVXALvnUZHOcAh0e3rx5/OoRrO3HRjCaNLZEvGB
	dTDcPNAihjNxhn9SK6aquu4hkqPHKaaMSZAQ4ZqinyoE54/jRikPYyZf8A2j2fG0gQQCepoixZw
	/2PYwM+xNR/kVWEkNf7nVPV20RVH5llwYx8PJudmmAm99yyqb6pLUl6g4POizFDxWoGaoSiwzue
	YTpwCJusaiwHVnUEbVfOlu6YIHUsmI8/E4=
X-Gm-Gg: AYBFou33xIMkxBe0xDdaZyT6N7gw4SLZ2ZB95ZuBBiHqTpXTQOWmLKdGPZQv848xeii
	wsdIWlitsb6w4teGsZZ1FhNX7gMcjjIJjrBK2ZbtYg2PbkpTVwZayYX6JMcVMzJC6iouFMOph/9
	HEJvhwJlmQviw+QIuZwIH+zSWUPCC/QHU8VeCfN5+psiF4vCwwrK/4JVEcJ7/vW/mb1DHSy50pk
	lUDgEenbIql6saw4d19SRl6RhfeRGBXzr5BIUAdb4BJPzsgCXkI34A8D4oNt6tq+0UI0MztHgr2
	LY+eiCi+24JTOjOAqkdbZDZ35IlRPqJM6EuDUJjBBcj/j+Xq5E5cEHN9cSJkdXlrPGhnwAcATcw
	xqJ6+WHoxyINF9f651Q0gkto6X9MShulLKBJZeHr+iJPjs0lYjFXoj7gLk1NOxKBltJe6TaXPu8
	c6uaObX4uvzdFwmmQnmrkSdTVNm+oMi8j224NeuyqXjkNTkhUFMeFzxg==
X-Received: by 2002:a05:6102:5108:b0:7a7:198b:6747 with SMTP id ada2fe7eead31-7d2a1665d43mr877617137.28.1793926736980;
        Thu, 05 Nov 2026 16:58:56 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-7d2a89a763csm3080137.17.2026.11.05.16.58.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:56 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed00709df0so1129945ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926736; x=1794531536; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Z8Yo3fC3yMCZvIGq1HQSYCLq8uP3MBjrUZTsB8dkO6w=;
        b=UI5O3v0wlYQ9Wxd7JCfntWxSmv3cqvShrF6rpirmJpnZ28HdHxQgZg1goeimHqxV+w
         +CQtt9ddeLKtwtuc/b0X/55iDKiV6wterdsCABbnKWX9jZ84VY9jfq7wTVrTSA3XZEwI
         6pKUaqLpbyjHKrdscMn0KaYY0b30xs2mjb45Q=
X-Received: by 2002:a17:903:190:b0:2ed:2c40:6273 with SMTP id d9443c01a7336-2ed40dbc435mr14503205ad.40.1793926735830;
        Thu, 05 Nov 2026 16:58:55 -0800 (PST)
X-Received: by 2002:a17:903:190:b0:2ed:2c40:6273 with SMTP id d9443c01a7336-2ed40dbc435mr14502975ad.40.1793926735262;
        Thu, 05 Nov 2026 16:58:55 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:54 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 15/37] scsi: mpt3sas: Fix Scsi_Host leak on invalid/tampered device probe
Date: Thu,  5 Nov 2026 16:42:30 -0800
Message-Id: <1793925772-1303-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Release the Scsi_Host before returning on the invalid/tampered
device-ID paths in _scsih_probe().

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 47bc48f7b9a3..066378a00fa4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -13549,6 +13549,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Invalid",
 			    pdev->device, pdev->subsystem_vendor,
 			    pdev->subsystem_device);
+			scsi_host_put(shost);
 			return 1;
 		case MPI26_MFGPAGE_DEVID_INVALID1_3816:
 		case MPI26_MFGPAGE_DEVID_INVALID1_3916:
@@ -13556,6 +13557,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Tampered",
 			    pdev->device, pdev->subsystem_vendor,
 			    pdev->subsystem_device);
+			scsi_host_put(shost);
 			return 1;
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
-- 
2.53.0

