Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926761;
	b=V+F37VcbmWPZNFOaTcjBiYGlhFYyA1b3w2AXEAnbJ/0CIxcGlO5zlDK79WPQn/ttItUG
	 JvmtmAH/tSCnVTz8LRuiicnK8FC+Pya0IlPUzV1SHtCcnTBBA2v32/QR463BhsFJVJArI
	 1MsXp1ScIp6RmbWlEvjV88rmgOz6EvY8SelY5hnxdmf/cDR6nJoKpm7upTiz4FB3ss8/d
	 Nh8wlhB+amW6Cy71PQ3/a6cqTHgqYHfR+fububiBEH1lVR0ss/w48aNIIYJe/ZrwHEwC2
	 wynN6HIqcIzEYAOIbq7VQ1YPltuv8EmCwfI/EpcYLh/0+em8NSy3nbUlK66NkY8bNkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926761;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=XraYbSTpKMxWarskCmy7jyc5U1HIuNZhG/athdE94x0=;
	b=rL+0RPafbQXUWEOalx/6mfWmGRiinainTAtPblkEie42LLztElqtRhKQIbw2bk9qPvZG
	 oaqLsQpSLVgCRgM8C8/4LVwUkqHb49CX4rShYdlkdSZ9+pLfDTk3Hp6KCUF6D6ZU9mJVE
	 IrL+QjQkHYufzcdJVmZUdx+RT9T203B6rrMym0qJQS1/KYJCcSXcFrmBE9jKlSbepgMoo
	 noIPt5GjkkKzWmXwFe065Y5IklN8TOXWEluZeRZNhT+qMNUxjRT4Agi2E+2Mr8CNBK7wX
	 YwKjml+7N/cn+95FGVNQmgwGE6aaK/xYQ55wNkk9RKDcwKmXiSL0YRYJdqbS5HAO9Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="BHu3/R9n";
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAE3606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BAE3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BHu3/R9n
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so70563a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926761; x=1794531561;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XraYbSTpKMxWarskCmy7jyc5U1HIuNZhG/athdE94x0=;
        b=fx34fxfl28UpMN7IvCchoFlUoYPJfrZwm0sqdGaEszQ0/hqS87OXM9hs/ZSqdSKZxE
         +eUtd2Hib2n6J5gx2uZFakHGT6hbW1U90UzhRlPvuNq09JO5e89Sj/MDwVqk7xSSM0mW
         GoVp4LU7O2xgB7GbEvsJGVX100Vm8NWh2ymNoc2G6bxD9MsxWXGj+TLtlbwJXqINJ0V0
         C2/cRhU5Kj+cyMdRgxBg0/0jIUbdEwf8m3v37i8UWQUG1QI+SE24dxoXJI/QCuti6Bn+
         WagoDjNE6dYDDHEUayn4oDGuJxWRd6nP6A7UvjfZ8vas4zKz8cRoUK/Q0eXqrsQKsQOv
         4NBQ==
X-Gm-Message-State: APuU4Z+Lw4ZICOFz1z1GOdQIeFg0FR3CXFyqnBW8cjbE33efTzLhvfsp
	iTFaey/KojPCq7coEVhSml2vqzHm/aOnZxAy9Ecd+sSJyXTzlQPS4nBkOa3hQegtmV9TomNr0vC
	tU0FCbboYADUgRmDl5W3FIQAnAs8hJHPBAk5o+QJOWHTMZPq/9qVVJlJrzENUtGo+fT9hvVOxka
	Gvm9o2kgNaxxfe/fyhLeL5/nJBUa518cAZLcR7CDhz6VVfXe5OZ8wcG+AM3ii5Z3b23FniW/LfH
	9HvF1rCuqk1c8qCa1fRgeZPORO1qRxjWh0=
X-Gm-Gg: AYBFou08tmFhX0pYYPjGf+iUCUem/IirPD+QY8dnBsG59E4jKEojpiySqszRpqZulMl
	6A6/PyEZHix+74wOQmU0oSYQNDIFOf4xE5MFmxnnENvG2RbcPtme/AfijmfX/HfKZ1yIMiiMxaU
	RyEEEyTXacppmUUFflE0VnWtKtet4J/1Iu2e2VRs56cLy9kNys7MGZiyIKE4d8cS31YEsU1X6Eu
	eKJI5yzCG9Vy5ptEVQYqxxA/0RdgSmm3PgpK2xPQI7ocQtTTBbD30ZYYYSK5O1RqH5A3vQ1n/bc
	msCV5MifwHGpfIa1m4fvV24DaOj/mKTAEDhzf3FImxU6a3ttlB7QV2d+SmI9IZiDtorHkVchup8
	eRMC76cDocK16YeS9zb38bw8Adu6KgIb8P7Kp29DN/conUY8tyCXVAXpkCsFAaEXu2VAh1DweIY
	Qw6ngPbpZqSHy0enIjTJeGeDonf4xNfdllWrncXYTSL30KaAlqOH6PTA==
X-Received: by 2002:a17:90b:17c2:b0:3a7:b260:9ced with SMTP id 98e67ed59e1d1-3b0db71d594mr725467a91.58.1793926760570;
        Thu, 05 Nov 2026 16:59:20 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0991e86cbsm2161505a91.4.2026.11.05.16.59.20
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:20 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed02a00b24so1139875ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926759; x=1794531559; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XraYbSTpKMxWarskCmy7jyc5U1HIuNZhG/athdE94x0=;
        b=BHu3/R9nUSF3vDmjrO1kbW6kciDw6YZA9qkDFyRx72TvFjePZVtQvFSkalr42cHWAr
         6mwDBqUucroBom1nexf72l1+5ZNAqiCKsLgchOKWn+P0ajeEQQhfT3Q2V2Sk89DwC3dy
         e6XlRs3itYP71UbKEsD3ChI1yNhlMKS7nko7o=
X-Received: by 2002:a17:902:e94d:b0:2ed:3c11:67e with SMTP id d9443c01a7336-2ed40c1fb90mr13654325ad.24.1793926758740;
        Thu, 05 Nov 2026 16:59:18 -0800 (PST)
X-Received: by 2002:a17:902:e94d:b0:2ed:3c11:67e with SMTP id d9443c01a7336-2ed40c1fb90mr13654205ad.24.1793926758137;
        Thu, 05 Nov 2026 16:59:18 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:17 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 22/37] scsi: mpt3sas: Clamp num_luns in _scsih_wait_for_target_to_become_ready
Date: Thu,  5 Nov 2026 16:42:37 -0800
Message-Id: <1793925772-1303-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp num_luns to the lun_data allocation size before using it as a
loop bound.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 073a487430e5..df5f16db8f48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8187,6 +8187,8 @@ _scsih_wait_for_target_to_become_ready(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		(data[2] << 8) | (data[3] << 0));
 
 	num_luns = (length / sizeof(struct scsi_lun));
+	/* Clamp to last valid index: loop uses inclusive bound lun_data[num_luns] */
+	num_luns = min_t(u32, num_luns, MPT3_MAX_LUNS - 1);
 
 	lunp = &lun_data[1];
 	lun = (num_luns) ? mpt_scsilun_to_int(&lun_data[1]) : 0;
-- 
2.53.0

