Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996853;
	b=Ke12dgdTrG0IRizgqwiqrKEWGHCTe3nY7WH0PT2Ms2FzisfCvj57wsxb3mKO3o2D3Jov
	 S/hUZklfVeZ9V6SbWd84q51oTMhy6buu6iHeKZypZm0IHPPtlRSTr+XDyQpJfKpjka8L4
	 RNX782w/avb9j9AXi5HTThZnBLKUoOvCt69TtqmtPXV7Fg51orsU3ePlGj67LbaiYEDky
	 KzpLQlSYUaOffic0l0xVWtBcH8jZFdE9mCYVV2ZtWfuA14MqHsbFOQTTgdVp4VtxAZtvA
	 u/pbWTJSXngJLEGVpe4SByhVod7WvkuHHhVwyp/1j6fCArYhXcXMVx6D9fUnfVCyIrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996853;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=8MlXPumT+jMiUsdqcQaQBZNkCUmUafOkeRFIF1VCn6A=;
	b=sxdcUOh0u1ANhp/rWp3Sbg5HVCXRX7bWkX3DoBo90cf3TXMTCFp1du80Pzlm9QRYVYXK
	 BWDnFpMW5sCwq/fhCq50u9Qe+dOdXwzURPRCv5SI27CvVgExCwwnuEvYgbnytm29vxaF2
	 ANODwTt4aEtfQenEhZeEiBwUsTTuGCHFxHqanGbWQ8Y+oSmDqVjhg5ooCRX1+1BQ12nQW
	 TEKTbiaaT3CuqpC0bwE7PdYB28ATnaWcKwSdcDhC9Zc0fJlXiqpA93+o1flX98KERVZK4
	 5bQ/zLUzxjffah0Mp6gLlCtgcX9LGly8WqF/LhA2AsxeCWJ1X5oJot7XWuHBXBSbr7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OQoR87co;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8FC606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD8FC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OQoR87co
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b3a42a4bcdso374673a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996852; x=1795601652;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8MlXPumT+jMiUsdqcQaQBZNkCUmUafOkeRFIF1VCn6A=;
        b=wAi13UhNhzvf3fX+1zsppZZLrpHUX5I0fa001qDOHPaZHx9sxlHisGpYa9Zw0BhFPE
         nnShCNeFZK+RXlBdNlPKcSlFVxm/F3KfdLz8GQY0R2jH5he1DDTRcY7UBQipDaZ/YiyS
         gxAf54Gnf46Vpbc5XeEbBKFCA6HeTCEWgm7VPQWnSkJ3v98juoWPIxFBLisUYL4m7T2g
         0uRoiyyxJMEculJp+A1CcyHF9WEjp0/FvyAWQ0DiBIEFWd9otQhrkhL3OHjiyMsQkcTw
         bMNlPQYvZU7heeSsV9GjSz+jm6llp7Lhtx/uwstM1gnzNp7PKcyhXlAKf03JiF9OJQiU
         4e/w==
X-Gm-Message-State: APuU4Z9rrxsDmUzjobXVqQAackAZDEktv98Iat5WqxyKxPXVdy8HtRH2
	yb1FhppFC4ObwPaOLc0V7Xr8IDh9GFpw3rsh5teiP24UgL9pEhFV2TYMeRfXLfySigLjE+01Wg2
	ALObw99I4r4a3qLAhl0UUiBuoLj6xoi+Y39dHTdUVcpnAl5ElRyqQpuRfC6JRXCO9dTBxxhmnvh
	2pc+RDzsfF27jGQKL33frgw6qk0Quc2v7WYO1QIydyJ2lE3MSYp/pQdu4cQA344brEOQvsQFFDV
	ol5axK4/z7aQOE92AEQAOVgBCtE7ut9bi4=
X-Gm-Gg: AZFdTZfJR5AV4j19YWeDLXCG0+ngZuHRTfROaUOrnYqWyB/QKQVzWAg/mssNXc7INCF
	tzm9iqfAjFVKnkAObCH3Nz67mEZxVgOcqay0FzLlK+veLlh6wmUuirIDUScRqiILRmaDV4Wd8AM
	cKXo/sdigTcVqxXGQR4n7lFKEqpX1ZV0dJ9etDMHcbjjuWdssXAKRv9wTy+0xDpGVX19M3ZHCtp
	qGJBbpXCwbrrcaN5fWX2QZYaMLZqRnEHx0F6kXiYXJtBsyoTxsMwqZY9ze54rYFUoFZXHTZaLs9
	1WamWsmo7scayorcexYuOx5YlxkIEBLGCX8dZQYSy8TkT9PUBoQ9/NP6VSBwe/7iFV0mCh8uW51
	aZs8EZk7/E1mPByJaq8mcKbQRYbLlZgxX/8SHf7IFvgqV3ani59i4jigkCcki9/ZSD3x/KrT8t/
	jwJmFBQIxx6A3JIOqgI4obO0VipGTY1rC4lGtWkb5q2bd4/PUNGVLxbQ==
X-Received: by 2002:a17:90b:4a48:b0:3ab:c80:9365 with SMTP id 98e67ed59e1d1-3b3d07d8066mr2104455a91.42.1794996852102;
        Wed, 18 Nov 2026 02:14:12 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3ac020c2fsm3978078a91.6.2026.11.18.02.14.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:12 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b3a74ee77fso532152a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996850; x=1795601650; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8MlXPumT+jMiUsdqcQaQBZNkCUmUafOkeRFIF1VCn6A=;
        b=OQoR87cogiERC6vTP8LScravB3aJe0/+xrJZr9uTeaXSGu0YMcxzhDxsjRJNLt8zEb
         RhrR0GJtkTyHpZfAr49rwyJZE+2eyBiz6fjDsOLGTMrYbkW+fFHOku36rOua7rjApRLu
         B8ZyMBtnkL2r1jNnHhvav0+invkEwzP2zqL4M=
X-Received: by 2002:a17:90b:224c:b0:3b0:accf:5c66 with SMTP id 98e67ed59e1d1-3b3d07d84ecmr2238971a91.49.1794996850350;
        Wed, 18 Nov 2026 02:14:10 -0800 (PST)
X-Received: by 2002:a17:90b:224c:b0:3b0:accf:5c66 with SMTP id 98e67ed59e1d1-3b3d07d84ecmr2238947a91.49.1794996849859;
        Wed, 18 Nov 2026 02:14:09 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.14.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:09 -0800 (PST)
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
Subject: [PATCH v2 35/37] scsi: mpt3sas: NULL the event_log pointer after freeing it
Date: Wed, 18 Nov 2026 01:56:44 -0800
Message-Id: <1794995806-5835-36-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Set ioc->event_log = NULL immediately after kfree() in
mpt3sas_ctl_release() to prevent use-after-free if a concurrent path
dereferences the pointer during adapter teardown.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index e8c5dee499fd..c3d337c203ef 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4628,6 +4628,7 @@ mpt3sas_ctl_release(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	kfree(ioc->event_log);
+	ioc->event_log = NULL;
 }
 
 /**
-- 
2.53.0

