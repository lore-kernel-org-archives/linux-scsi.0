Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926691;
	b=NUm74KA4UhAq+wdWbxAHQqdzqzFWKakj1EGT366ujbwWl6UKjoBPOO3baJDI07sYmb+q
	 uq1+B3RxZuW4j8HOEzgq40dxradN/YsyQ+4lMmUMzyFkCk7/rQCdz72YAbtyankWZTIcJ
	 iLeuHPPWm8GumsplQbP41dIt64C9Vy0th0ziG0wpNLWgjLGUBMAQL8kt6WWcbC9KA+25e
	 PMwEZ0BXzIXxQBk9QQ9+2+NJ85/ah2H/spQ6bPYsAIz/0vEq162/VnK3ve8XqjDhyt3yx
	 hXfAs2VNeOyNlDzrKYS37Sy0fw5YTXGVZg0I9nwNZqcf3HSdXc1gIOPtDiGXFPUcBsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926691;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=oc73ZAq45juyJEmqkqLsICyOBnuIUlz4Nvas135XgFQ=;
	b=EI+nyyK/q0ic52eXn0Alb+SGqa8yK/xvWS207c5CENIetpIOvEzQIahMlIU3Mic/EJHB
	 9Y8bYvSjdul0Yq3x0vCZ24dKVgEZzLlG4C0eRgfz9UZtIi/TRQxnmUXi3caDASn6I2+95
	 Sao6PHXlYD0L/nFmBJYgj62BuvT84WUZJQl/4koYyOdC4uryS3yuk96P0SI5AB+eDpobM
	 15EIaK/g7gIXRKoQB6PKbDBb2PhCP2JXvXsObAbfJXqwf1qtFlNaGRHM+0yAgzhkHMp1M
	 OCuWZ+lDBw6FbdB08jxz6Fc5UsF0CAtnNtLdx2bIJkskvsXDZrtUgIE0X0b8Kq6k6yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=dOyVVZR7;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09100606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09100606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=dOyVVZR7
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so50553a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926690; x=1794531490;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oc73ZAq45juyJEmqkqLsICyOBnuIUlz4Nvas135XgFQ=;
        b=axKspXN3mw6QC0aokvi1z+AwdHGB6jLaSrWiRRTGOXNMobofdG+nfcRcBxFVU932O1
         WznpZHr0mxLJ50IXjHk7nSQtgbSsEOdvStlQxP2GW4orc+SAekMSJC4eAyHtBzbtZdeU
         +sdO9XD+6SqYBm2GrbgYd5ta5GmaSaDjnCEJ5OKLr4uxVEczc1/l9mSwU0OSoG25Oe3V
         Ym7tICfbOWAWVt9caMX4G08UQY4W7rkQYGEcKJYYLexuW+ZiGUSD8sACm5d9YadN31pW
         4gb+qMdpnv5CxD8yMgaYyTQuCBlFVVkHoBgziwxZr1C2MVcUsVX2jECmlygFuMzQmuz/
         maCw==
X-Gm-Message-State: APuU4Z/BDkylEp42ZH895uMiGxR+U2xcl0s06kHrQCdGwdjktNlCLZ/i
	YZtrWpM4OFH/cwnVMqGtvdY5DfbJu4Vw58q23Kj/uy7Q+YxkU7rlpfpHsq5VlOsXXYKq2vN5oAk
	tqbfdi58qOkHhhFowk14YdlapHK/5P2N6myaZ9yAFa2ewTi/Ayq8pR40XWAvl5GagLE7xld5l7S
	WoEMYJtsjHrTtdspb5EEcvSuxIPkFDR3oKuGCNJo/OOPVDoh2LYLUOGgD3SDdaEcn/REThYAYXE
	DKh/xiJxirzDa6QcRkIwGbzIz22LMjhytI=
X-Gm-Gg: AYBFou2wUTFKd4nI+QPRGuZckUotYH1cDWQ6kePzmjrmu8GdFCRNXXgL7UP93LKazjA
	P50oY1cpSYbhvUeULJI0F58pLI/p3xOFG8G/GiLRifqzsI5r3hwkz483Tf/E9uACd/srWBIZcPH
	nmDbMdckL5MZf+IpQUw5lDKWXTZrQRH5a+kWwi8K6lnOpgOhvGsSTpEHbf5KrFs0wSgPdYrq+0u
	jEMnjzXdFlKz4DHv6vMAE8rcwx/uXjVpDeM6QndCDSwOjqQfmChewIl9gdgrQXakMpkkhP5ishK
	v9+LdR9OvCdQfx35wkyHzdVS19O0GH68F7Qs9zd7d1pXKSsNGkJ3Aq9zmIzHXoRkpbGqt2OWHz7
	m+WxXMFXbLoAq2g2GG/ehGYuSVnyhrZxnSv+jYWvejAhHJGn+IoKPyoQkiuOTCR2tP8A53hVyUP
	iIKzgTmysscDY5YEEILjXwxNv4nMQLw+wD0lCJQ5GsaXWq715z1H2wgA==
X-Received: by 2002:a17:90a:e7cd:b0:3ac:a11a:7c79 with SMTP id 98e67ed59e1d1-3b0db6df03dmr721967a91.16.1793926690255;
        Thu, 05 Nov 2026 16:58:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b096bd09e8sm1528332a91.4.2026.11.05.16.58.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2eb5375cd68so1111255ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926688; x=1794531488; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oc73ZAq45juyJEmqkqLsICyOBnuIUlz4Nvas135XgFQ=;
        b=dOyVVZR7Z34MgwMByxu5sF3Qy4W7u+XHyzJ0kcg7/xARE9Ob8uIgnMXeLgbi0q1QXc
         sE4PV3njuAIjChYFqJy5OGUM/A62t3bZ9ylDzXiqT59K8Zc4KRvQA6qB8vh3jBHN9in7
         snMryFLZapZF512RzpSN3b97OixltpTLKJfbE=
X-Received: by 2002:a17:903:32cf:b0:2dd:c053:82f1 with SMTP id d9443c01a7336-2ed40bfdf02mr13877625ad.40.1793926688173;
        Thu, 05 Nov 2026 16:58:08 -0800 (PST)
X-Received: by 2002:a17:903:32cf:b0:2dd:c053:82f1 with SMTP id d9443c01a7336-2ed40bfdf02mr13877405ad.40.1793926687634;
        Thu, 05 Nov 2026 16:58:07 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:07 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 01/37] scsi: mpt3sas: Validate firmware-reported IOCRequestFrameSize
Date: Thu,  5 Nov 2026 16:42:16 -0800
Message-Id: <1793925772-1303-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject an IOCFacts-reported request frame size smaller than
Mpi25SCSIIORequest_t, which would otherwise corrupt adjacent memory.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1af25a22611a..9bf92c4a14b7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6373,6 +6373,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	/* request frame size */
 	ioc->request_sz = facts->IOCRequestFrameSize * 4;
+	if (ioc->request_sz < sizeof(Mpi25SCSIIORequest_t)) {
+		ioc_err(ioc,
+			"IOCFacts reported invalid RequestFrameSize (%u bytes)\n",
+			ioc->request_sz);
+		return -EINVAL;
+	}
 
 	/* reply frame size */
 	ioc->reply_sz = facts->ReplyFrameSize * 4;
-- 
2.53.0

