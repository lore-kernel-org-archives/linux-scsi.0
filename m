Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926725;
	b=IPVeY+4/ifKn3UvTprDySXGpv4E/lUY1uegqf2T48IDdOLocN2rQJ8V8NzxU4DCo1b4M
	 +EWhQU8crVFy3QUjxcUtr55htvCSLKeNkDmWvV5nUkiGdkTLlqevCYAsg54lJHL6W95sA
	 2dRlPag43B1GviGRAqUFIbrZnT4cFP1GubwIgS/Cb7zAzMiI4s6h0dQnACCUOxpFIxkJj
	 OHvtvyEEpFHq8fY/psouwxbtFFIpnGqxOUTcHz5UQAP6CFsf8bME9LlS5/9My/PAKXaYV
	 CNItXDN9FlDkCl83HQKrbMW0z7PnPiOTliVSW840K4jos1qYWxOPeBj0S43S9W8eewQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926725;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=p1WmhQkQy1gvk1oH4pFKIZ9uYFADakeViRXEe+vNixo=;
	b=Npgtgnv8sFzbIfGyauMX4wwLuF6tgzJ/chYq6r/y9sRt6nVgxn+rkHm2hiLX4CIHvJJn
	 c6+cfxKh0ilSVr8OFiJ4KyI+DMogvNOHGURwxIRbFOO7aLP+S2G9BXRJOMegnjcpMagDk
	 08zvgeuMh624r+9t7Hke71SsmCJHKnr7VdLGSgfIyvzjPFwr9He0OcfNju+jXeNXV9bJH
	 TSKVSWsshdkQRS0trjOjSKg/9r38NE3eNBCtVydGOdE0awGoEsHmKYwu0i6FE2Y0vfuWC
	 l4aXl1/ObYMCuabfUWMvX/JnyBqynTUS9flUDe9eSjYylGFrxhohFTJLx4f9PS6/tQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="BW/SF3fg";
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5A606A328
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06F5A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BW/SF3fg
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso64279a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926724; x=1794531524;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p1WmhQkQy1gvk1oH4pFKIZ9uYFADakeViRXEe+vNixo=;
        b=vXt8UXalPwj9KvMueI5EHnOcMcGuuPfFwPkVLq5pGqPpFFWYmMrCqAzBaFxZn7KPC8
         REBgmtNOFwwEvuuF3tHO0X2w4743IMLMRkYu3+A5bl7qxXiZ5pC7IAWMeYXEba9kMJ3r
         otqJbu6P+K6Xt2CY+VHfgE6HYzt+Dye9IshLSAKlmf2oL5onZc1YBU8bJJG7NHT1GARr
         AoWjq63to17TX8SeH59WFy7AgzNplkswng7ntzbNs3GCaLtkySr5MH/U420dBN67DSVd
         N4qt80sA47AT9falps98+KEW1LKDuILxgnYijEN57rrlp76rjOBBc521/c11h/21+S+i
         qS6A==
X-Gm-Message-State: APuU4Z9dNuUVWVQip+cISoHLn0nfKPzhdbQZodSz2vWnWCmxxqwePWBx
	aM8z9OtFbF+SEQDGDN54J2TKOrmFOyGSeWrEHTKb3P4uTuXDSXPsbxd2h5DBd2SkEZejwJoldbb
	f0C5RMwIhjVU2doyE/aucPi+7GeneQuxtOI0amZaPoyimDUmIT2uSMAPcfdguFPAqG4N4hsaw0x
	807cL4/Et53ZzcZY/aLOsLCRNC6NdI9e7koKiT1kcgo/bM6bh3Pz7frWVJhnWxCz2GsjnDc4fV/
	Hxto6UN6kAs9bqbCZwIduGSEKAZtMrwb/w=
X-Gm-Gg: AYBFou2kZyqdfXeAk7JHc5R/MHv5Orh3ABKDw8hR7zDE4b+NcOgQ8yg8sNEqovsw2kq
	4uxB6pkFpLFbN88F4382ILltCeaZbnImAlwrIIQTd0EnY9Jm8OpxoaxcavWMKX8Emo8GyPzCeum
	+eS6jqdG+y82lUklWgvlvmcjDPJpl8CPvm9fZvNapbOuo+cw5vfUky8nW6LiBl61DM/RHCpbfq+
	N3Pb5OvRwkAtYjAMJ2jAJeucKoRYYodLHt7GFdo2hNJOSNqB+WRQ2YS5n4N3v/MDh+/0cG2E7Wt
	pkpmYxsSEZKa4DB4j3QJp59pKu19Gu4L4dqvXEFgZCtw95qJY421EejVRuOOM/msdTz502odgkG
	m3H6L0/g6F6X3xRnUjAY8OAQSbbZzyhoDfDW1K8fILHuPQgfEOYnXNyZXgDo3aBPAcIIdwQZgdE
	6pfTEa1Ge+BhaLjkHtzIG5iLAZHrKMGA27TT4h2CbiO9cBpIA2F7vcmg==
X-Received: by 2002:a17:90b:2c8f:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3b0db713f11mr805527a91.59.1793926724273;
        Thu, 05 Nov 2026 16:58:44 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b32a5585sm2872300a91.8.2026.11.05.16.58.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:44 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed077a15c3so1317065ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926722; x=1794531522; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=p1WmhQkQy1gvk1oH4pFKIZ9uYFADakeViRXEe+vNixo=;
        b=BW/SF3fgfKe+GJyK71Rrx5EdE3HFG9/uQBiZgFmXUawkC+UL2y4mnxrOghycahmkm2
         kuOeqsmzSmKibO89kEQxE5bjgbBsGbuks4tbZtECH6fDhhrROb3cmGn7agxISYPhNqHW
         7IOobIKshFURhruVH2JwDXy5l0QY+FWtwgOZs=
X-Received: by 2002:a17:902:cf05:b0:2e8:79d:15ec with SMTP id d9443c01a7336-2ed404dd1e5mr15761225ad.6.1793926722291;
        Thu, 05 Nov 2026 16:58:42 -0800 (PST)
X-Received: by 2002:a17:902:cf05:b0:2e8:79d:15ec with SMTP id d9443c01a7336-2ed404dd1e5mr15761045ad.6.1793926721725;
        Thu, 05 Nov 2026 16:58:41 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:41 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 11/37] scsi: mpt3sas: Fix port_table memory leak in _scsih_sas_port_refresh
Date: Thu,  5 Nov 2026 16:42:26 -0800
Message-Id: <1793925772-1303-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Free port_table on every exit path, including the early return when
no ports are found.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1d483a560d75..788b611c7c52 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6783,7 +6783,7 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 
 	port_count = _scsih_get_port_table_after_reset(ioc, port_table);
 	if (!port_count)
-		return;
+		goto out;
 
 	drsprintk(ioc, ioc_info(ioc, "New Port table\n"));
 	for (j = 0; j < port_count; j++)
@@ -6846,6 +6846,8 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	port_table_entry = NULL;
+out:
+	kfree(port_table);
 }
 
 /**
-- 
2.53.0

