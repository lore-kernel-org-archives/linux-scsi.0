Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926806;
	b=4C7JT96I91beCfRH9yLcZTB1StpbPtjlckQMYTBQq9U+bF14LPVA/XxpwUpeihfHJf6j
	 /YczT0nlFnVQhlvB51UGtdzE+kGuFwKR735afx3W/S1i1S3O+Tce7REOUT1iUZojNHjME
	 N44nlMO7sPsUPUFmzqrzWk1GCrL9lDhtxhiGOl1nVC5J+ZM4qm2o0J3ajDbMeLk9m0Ew/
	 Gu9VB4AFIbruaF+0TPA45+KQ7aLTzH8tve7xC+JZ6MKi9/ciQsIzf3v1k3/KCDr+nEeqe
	 Kd58K1yqayr3X8HtuZxyUs4VEMwm6PuVZ6J8eIT36lRaKvAbm60Xq5aNkm95gccznqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926806;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=sBU3/HYw3xE569O3mPv67Kc/Yyu5gvt4DxRER0slxqM=;
	b=1aB/4VXgkxfMzWfuWY71/9RFm9Ko2dW4GNMJEwPgx8ws3qCo0aMkcvbQTVpa1+mxF5Xp
	 mPBRr7jk+CzgzDFjaBHH83BUBICBJ/rovuVGvz/73Xi7ma8Kc4lgAkcJSqhHOT1TdwcRF
	 SwJAwT/1gS0shLmGt8lHxifR2px9MWtChyHd6zoZI35dUCL4nP9qRQM5NzEwWRI0tJRlE
	 Y4rYBd54DgSs0h+iN9qMopkmu8DKtZB7gqbIboLKjbi03EdhC10CBZIG80/ZPky/o1aQN
	 ikNXaox3mOZfFMFQBtaTyDyo0b/ztCuBc+Te82UW1JetVqxwFPzREp8zHkpstKJHE2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OlUGyklN;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00C0606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F00C0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OlUGyklN
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ae691283ecso65088a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926805; x=1794531605;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sBU3/HYw3xE569O3mPv67Kc/Yyu5gvt4DxRER0slxqM=;
        b=CcBr3c8MmPrhgDL7bQzWyt6T+CLu/Y1c777tKz2VXkDAko9p+PpLIMqDky+FPwBsl0
         6NXs3tfrVy5hXMQqb0aaqeTSPBxUu0C64VnRQ8jOpc4T0cAyf1AbcZaPVYzeSgEwiJcm
         u2sU19i1KUGX9f5uQSS5xa7BfswaBQel+dNodFQgMSp2K8uH/bUe87wnHOkDnXpkV+Z2
         yE9nrnhWlX0ZlqvAoQlenGZam+r+E9uOkmGDU4Aw+yO3VeOC18tHn91r3YFPsWFJYojE
         7kJ8YoG4UN/IuM5rMuvhIny90MVMcjtm5ANN0rlkH8sBxdAmNccuEOuEPWh8GTz+Hn9o
         unJw==
X-Gm-Message-State: APuU4Z+PrqB7GoSltLOkcOwkEzSbVT87eIh0h8JoVsaNbGobrre5O26x
	IABmtUhjQL0llbgeaN+XQEmlxB4wiIO4mvjZYeF8fjuXlkg6CImqx36uoqmKi3wL2lGR9Uhv3UU
	c8Kirg3CAF7x3gQWoYZvo3w2sA3827X2yI4efnq5CllBICgqHnynLBnI1xCZTncPWQpXNy2GpNJ
	bAYsTMAdtlfHHIfWaAotJENbAPJQTBA7kB0Co86SRtSo5hdxFX5oTPDdufbAfDC6z5lzmnQvSHb
	JjnrkA520Ug0ZlqOvXpVlHNYEuemOjiZyQ=
X-Gm-Gg: AYBFou0TuYWTNRU3mmszAxDtyDQkX3PuooJ3cqDHFllqCfwcbPotdnTutjtmqcaHqRv
	p4PM82ilYZv5NhYlroSPB1S7K997Ufy9HKdGRB2rCOKBDyoahZmXjsgiUDBvf5oLqPlnOSnSnfT
	Ohn+3EqMwh/OOiuoCDkDKW6gCenL16pUSkox9nJ6TIm7+LClGaH55VpCZ5egHxvSY0J0qz9Qt9i
	yVs13DCC27AZPnPSzhRj4FK8e8Wioj8ybRCQPIz9GJVtYDTuBW4clVqwMRbUF0/VCzveWH7PZA8
	LZDmSN3HD1HTAgmtouB9XKDl/w7uU1Flo1mHlMhiys36TxV0e3aT2a5Ksj850b40pTh2LsB1GdZ
	Np1Hq1dwsqCUkrsrRZ4JXyOdX3JzqhuVc+o/wA5aBbAFkVH5leE1du6YHqWVJhxWqnjbnNwCTkX
	mzerp3CRwIXbTQMO8dhAI7dkT5g2s5tpBP9BQiRveKzM/EmDf997B4eQ==
X-Received: by 2002:a17:90b:1fcd:b0:3a0:295e:6e61 with SMTP id 98e67ed59e1d1-3b0db6b6c7cmr534624a91.12.1793926805292;
        Thu, 05 Nov 2026 17:00:05 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b327b8b5sm3072088a91.6.2026.11.05.17.00.04
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:05 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea381ce04fso2485055ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926804; x=1794531604; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sBU3/HYw3xE569O3mPv67Kc/Yyu5gvt4DxRER0slxqM=;
        b=OlUGyklNhSAyxMb3uAUcL/nsKzGnbyFSBwwneFNsjrsAtPD6yf71FLcmJJ8OZC6PSh
         enTNtHFUCsg6YtLjBYWoVRNyPOCXOcQ0RHTFdUe2Nriookbf72r0bh94hrfMtnoZUtLU
         zOH6X9+EnUHbmGSVKoFmb8c7/Gp1N7QEKdClc=
X-Received: by 2002:a17:903:41c1:b0:2dd:ad7d:72e1 with SMTP id d9443c01a7336-2ed2432fd6cmr31383785ad.24.1793926803631;
        Thu, 05 Nov 2026 17:00:03 -0800 (PST)
X-Received: by 2002:a17:903:41c1:b0:2dd:ad7d:72e1 with SMTP id d9443c01a7336-2ed2432fd6cmr31383595ad.24.1793926803001;
        Thu, 05 Nov 2026 17:00:03 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.17.00.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:02 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 35/37] scsi: mpt3sas: NULL the event_log pointer after freeing it
Date: Thu,  5 Nov 2026 16:42:50 -0800
Message-Id: <1793925772-1303-36-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Set ioc->event_log = NULL immediately after kfree() in
mpt3sas_ctl_release() to prevent use-after-free if a concurrent path
dereferences the pointer during adapter teardown.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index c80bb2e7c240..df9674fa2af1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4615,6 +4615,7 @@ mpt3sas_ctl_release(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	kfree(ioc->event_log);
+	ioc->event_log = NULL;
 }
 
 /**
-- 
2.53.0

