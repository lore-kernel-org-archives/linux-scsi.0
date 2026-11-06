Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926765;
	b=ldBDYERSdeTiaMVag1GncZ9SDoxwQOS61p9Ion7OLumNAZ6HD9K3ap4Lh3bZMblZE6Zq
	 6xgceFLxJmHvghdrlO75pJHCdaT7HYComjomzOYdupmQW/AOXhtEkjXaMtWdB2OiYhhyk
	 QevsMWX4NP0Gz8ZBbE7jfjl7W6CGUQlYieC83I5nKLkqwXjD9/VGI0SMJ/Ce04LBwYJu4
	 tMiC7SbwgemePNSBAUxLAYOfWy2v4VfBGornRNfFfNUpvvCOxIvbDZt5/n2HYPj6P7BJO
	 54h6BU2aS9jMUXVmLV0y90RIJHJykoC0pzSEaezpWGCFsHT9oQJVItcjGxscFed5Dzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926765;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=Bgt+30oj8u5RNf/+RH8LRvncsPSDUfKqaaQLxORbxc0=;
	b=3Xjxtlbho49WD7nu4VtD3ny8vPZzcp4bn+cepwsKUFOtBvR/PRRNkmdYxyVcSOzR/9/c
	 ahGKDr20D90y5ejpiML1ZlWXQWD6n+KfzFzrGACqPjeThFuzj8GfbQs4cT8Brit9fuJpT
	 P4+i6j5A2DUaVbQWV9yStNS0evvfINLnk/rQ3Xfh6lg9QMaANHVchCWYyZuwLyxLe0fyt
	 VheY0qKlxU9z1jP7SnRsTgTSTsDcMJEh6J7wzLpKRL5S143ye7zGpAYd9tSr2F7PemaDu
	 R+7WiFGd4RonpkQiwNyX3gvMJMqd4K3ZgwqXqIRe12BOyvYeeKLa6ejLUvpy08CC0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="e2UN6j/k";
	arc=none smtp.remote-ip=209.85.160.100
Received: from mail-oa1-f100.google.com (mail-oa1-f100.google.com [209.85.160.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAB1606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EAB1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=e2UN6j/k
Received: by mail-oa1-f100.google.com with SMTP id 586e51a60fabf-4a77dcc4ca0so33241fac.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926764; x=1794531564;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bgt+30oj8u5RNf/+RH8LRvncsPSDUfKqaaQLxORbxc0=;
        b=dmIKlPkJuU7Z1d+shtQuAkclecJmORu+UeTdp7OQWy7gcfm5niuVsU9pp09/2nkyQp
         1MHsGE75LJCxcr4PMOmHvJqsyhSlAgDVjZYPbCj2f1GK2KoGCBcAQYttSAcmUWHgjLHz
         vJmruQ6g1lw6J5zXQ10e2rV7IkI3alH+GBHCECQ3zvjnwcZwbilULD3R55bQ9VDSlPKx
         8+99p6fNPbVn7CKm0iCShGM+Zmt1xCRCC84dv2xfqGzDfKxkid7lcmRzjadQGlPNhuKG
         7JRXVNwDQXcFymOvtzKBnP+tc6WeL+bCbCFaUevC83zb12nLjUgpuS12CIEgfDnzSi7T
         QRgg==
X-Gm-Message-State: APuU4Z8h8jEJ8BxOtYNZf/UJk4t6hwIH9KuF1pkfZqwDkf6nINruink6
	fRBdMyIJl/nIhHosez1NG4XfLRYQ2gWfJogZ8A0ZO6+OGMwatEAgmsaZzkcfdp25VKctz/3/dxa
	Dq8cqmtA3Qa/4MU2IFCamhfO0Ya3XNOc/fPRjFW/ZKRZPaj911NZRIVSBrjgKPg6jnYSNvND3IG
	pEDr1Z3qwwjC+KxNb8+6Bgt7Deg6gmlcOU8g5jhXmdcBDDRMCk+c9b+jneaSggUf4J6f6MGGI8C
	oNqIGVoP8TioWdIUJfCr+rtz+Qt15Tr6ZI=
X-Gm-Gg: AYBFou0qQF75TTbx0j9mB4UjmOj9aabrcpcwD526YMcjh/mQlydSThLqE9R6QSHH529
	rI7HysfA6zQsegBX5c30mtwYGpDzGr5duLKsX0WQdQe5aHNyBBDuWFn4kBWysesjEcnGMNAjJLO
	t90WOEi/QkshF30dJLurkWB69AzBENNnJh9eYNSqpDBGCkXvkpnGKa1+r67yiOC8mNHp9dkm+O1
	vS6pl0sQgWRYvGu6UGsR3R1Bw9QskNZbHpuJeh5g60pprINikscAQ/AqMKmuCA+0Mt8FHVk2b2n
	dK98Fk72sL3Hw+CnQ+Enk57xkasxWLtwB7ydSt4Oq0zz4W/kuaTcguUHd1vgV+ak6Kbv7XHVlbb
	eKR3yN64NwIINIBAUqANUCB1BHqepGNRuZAz9QJhDtOHRcw/G/DDyWbzpxZltCh8Asr5B6jUgOX
	QK4/StaqtIcLtL6E9mxbZhaLVYLsA5bitJgZ2Xxf69Gk8p5RqzQWdDzg==
X-Received: by 2002:a05:6871:2b1b:b0:48f:e147:afb7 with SMTP id 586e51a60fabf-4ad99118ea4mr634632fac.59.1793926764131;
        Thu, 05 Nov 2026 16:59:24 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4ad978a35ccsm16933fac.6.2026.11.05.16.59.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:24 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e9d52f684fso1094495ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926762; x=1794531562; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Bgt+30oj8u5RNf/+RH8LRvncsPSDUfKqaaQLxORbxc0=;
        b=e2UN6j/kb31uDlWRtCPwTWbNQSrvXjrQo9+BwooNHseh1BoxtqWQqN+r+iC6HrmZAT
         rpjac/jcUTLpdi2Q2zgtiYy+E5Y1I0HDTZoBBE8rYMgbSXgiJaQ2s7XuX31CIfEniOGO
         eA7XBennmdCw3r1cKKLkjlcyo7BQzC7++c4fk=
X-Received: by 2002:a17:903:228a:b0:2e9:9522:ed31 with SMTP id d9443c01a7336-2ed40aacfe7mr14088795ad.13.1793926761842;
        Thu, 05 Nov 2026 16:59:21 -0800 (PST)
X-Received: by 2002:a17:903:228a:b0:2e9:9522:ed31 with SMTP id d9443c01a7336-2ed40aacfe7mr14088635ad.13.1793926761271;
        Thu, 05 Nov 2026 16:59:21 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:20 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 23/37] scsi: mpt3sas: Validate phy_number in mpt3sas_transport_update_links
Date: Thu,  5 Nov 2026 16:42:38 -0800
Message-Id: <1793925772-1303-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Check phy_number against sas_node->num_phys before indexing the phy
array.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 32db07ed808a..1041ee7591bf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1176,6 +1176,11 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		return;
 	}
 
+	if (phy_number >= sas_node->nr_phys_allocated) {
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		return;
+	}
+
 	mpt3sas_phy = &sas_node->phy[phy_number];
 	mpt3sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
-- 
2.53.0

