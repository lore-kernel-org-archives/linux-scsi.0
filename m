Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996826;
	b=gureGng9oLCyTqu2IfE+RD1GJp61HcDjTi8Ph7hjCq4ruIH6wGuSbszOclLOMnr9+/NN
	 /OzIfGuR8P5F7yJAXrSfbe4CkGUsgcl/Bbf0o+yOAbMqa9vky+9M6uhAepPIWA+YFOwtt
	 OXWECLlcYLzg/zOqIxXhqi+9DfkdwsHr7P5kD0cOW9TE7dbs3cHC9YrMW2oy0sQzpuHIx
	 ey99ELOtOxtneClFGxPl3IOVmgDhBzc27hCH5WUZbXhAx2bcPelxr+BOv/Un7F56FzJeh
	 2dpq9a0t+YFGq69CK8p6Wx/3wTdVdDumEK32giC5KM3mzSUt1kMU+uGryO8Qu4Wwmlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996826;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=sGAH/ttgS+na1MmXrLsn3ei1RVfx4SlfRWitP/dfnhk=;
	b=oLPY6Wz3o0vM/wKs2tzCh5z3sNrN2axwVjQl7YdUrzuBNdadMKhtv+dRATxpH/fUhQjz
	 xqezT3TPUc5OsdRJFxq+yxMlQEzP8n/KKCv1ucMFtMr8TJPWs0n1VOP9a41veCKbtd1OM
	 KVUrYQKZJeYvynAttAQD2f1sixTh5Ko9QizDQAj6+63L+97Uqen2Y8yp98S025Z95R9WO
	 7CRAZT3TIJQfw+3SphAs0imBzb5D4KtMCBKddHyQNbQ6icLKT7apq9WptRPwF2cg+C8dZ
	 4Ym9GX/mtIY/32svOmCVTAde1JPFzfHDBxhNS3fOehhR/odz94cEF/RFUUuoN59OMvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=X7eY1RL8;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A0B606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0A0B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=X7eY1RL8
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso547957a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996825; x=1795601625;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sGAH/ttgS+na1MmXrLsn3ei1RVfx4SlfRWitP/dfnhk=;
        b=zoO2R9n+n7B89OpAfNP6VTYRsNIhZTYjs6WpCIWAGksdho3LXzCm6nVAKgxs+Togh9
         CJ/0HgALrDxCMou6aLjkK6AHDFVYcPsR8kvLTXRNkEEtfahhuWY2XLCQMGsEIJRv94K4
         RS6R2nbeGkKHn4GrhBCp8fT6FfTRJH9kV38zc1Qo0a255apYjrWbrnFWjIb6JuNL7Qgh
         nWH1xzioORONxzL+NIHgNeQa7lZfqrX1h/OjdmvoVUHskUnQoI3ZM2vtH1VoE1v4a6ke
         hnbrLGP992tdiqvhQb54CS+U3195l2QdqsuWUikao6LImG10V5V6zKZU5WZoPa/t/a+b
         I9Ow==
X-Gm-Message-State: APuU4Z87varhYS9+1czqHsIjeKrbOwKXCLgVGCviDExey6DDR9EeMDxI
	3yjfbrr+VkhQfnqrwXU5zitVi+2I06ykb19N+WmmHE0tZMUXqk07Jj+u6hwC0BLo736eObLnRWE
	y+bC2kmvJTxnzq2OYNWZ92BauhFbdQQyy9Vs4xwqCK1lWQs157pw03YGSANqXpdO6IqlKxejO9N
	K4sNDlX+MziZ3d8OU0vkKKo35COfFKMNh98dlCL8qloYHwkIfcwGVdGdfW0+xrW6QBYofDyr1Fx
	ewI8fomJpQ/rRKiVv760XTxeKC8n5gUviw=
X-Gm-Gg: AZFdTZfSYT0FlxR2GafHPMzIdlLdEtPk921ICGPxSNptG1S9vPshxP/w0xwYe+OV5lp
	mdr3NJ9oosH8eT2giFc5HyEERqZPPisKdutFDy0+aQxw+X51sr3/X9zWOyJTi6qvT1CqxzgzcWn
	quaFSQdlDYtPHZ5qbDQcE6Kptagh1stF8YlgOI2jT6oJyEx+HRl/oKhiGpMOqn+61m1GwpVvEUF
	OCz+G1CeUviwQk+A/IoIR/pqigoNXr0RBOVJf6GAIArh2lHJ4GDt6PAQzxNOuoMu1xFx54PbjEl
	Vrfm04Wwg7rsAnIOVUWChlkNFFLwHyuJst7llp+5a93jJSrHBfqhyflJtUNLGEE3rXcAF6yBD1K
	zwYpZv2ujEmnm0rwMwM1uBpeC4D6KpWGmZiheyPWDsEQcWnTq9BBeVRJ48b5yCj1KHcj8zKvfk8
	WFDQWyhZZJJXgeeLhW6t5d5k0n9r6FrvkGnJ4pWXcIXhbHWLgs2fhh9tgV
X-Received: by 2002:a17:90b:5390:b0:3ad:b8c8:4a84 with SMTP id 98e67ed59e1d1-3b3d07b9133mr2299827a91.26.1794996824903;
        Wed, 18 Nov 2026 02:13:44 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1423c73sm1651782a91.3.2026.11.18.02.13.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:44 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc7361c62b9so643779a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996823; x=1795601623; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sGAH/ttgS+na1MmXrLsn3ei1RVfx4SlfRWitP/dfnhk=;
        b=X7eY1RL8uH6nhm3Jce9WNViR4/rSRmrjK7HN9+dfXER4wCqT+fW1xIBmSvz1Sv51cs
         3HXdta87jCG8QCmdYYwU18MNsbg6Y5J/Pv6V3JBMVOCdyOM1shgWJMvoEqVMi9aaJIyS
         ESCPgllEj6Z1YqSpyVfTayrA99UT5ts699Khw=
X-Received: by 2002:a17:90b:4fc1:b0:3b3:ba43:54bf with SMTP id 98e67ed59e1d1-3b3d07b9008mr2010443a91.27.1794996822870;
        Wed, 18 Nov 2026 02:13:42 -0800 (PST)
X-Received: by 2002:a17:90b:4fc1:b0:3b3:ba43:54bf with SMTP id 98e67ed59e1d1-3b3d07b9008mr2010423a91.27.1794996822248;
        Wed, 18 Nov 2026 02:13:42 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:41 -0800 (PST)
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
Subject: [PATCH v2 28/37] scsi: mpt3sas: Replace panic() calls with error returns in _config_request
Date: Wed, 18 Nov 2026 01:56:37 -0800
Message-Id: <1794995806-5835-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Replace the four panic() calls triggered by firmware page-type mismatches
with ioc_err() messages and -EIO returns via goto free_mem.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 66 ++++++++++++++++++---------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 88dba4598d70..83757358015d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -420,10 +420,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 				    smid, "config_request", NULL);
 			_debug_dump_mf(mpi_request, ioc->request_sz/4);
 			_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
-			panic("%s: %s: Firmware BUG: mpi_reply mismatch: Requested PageType(0x%02x) Reply PageType(0x%02x)\n",
-			      ioc->name, __func__,
-			      mpi_request->Header.PageType & 0xF,
-			      mpi_reply->Header.PageType & 0xF);
+			ioc_err(ioc,
+				"%s: Firmware BUG: mpi_reply mismatch: Requested PageType(0x%02x) Reply PageType(0x%02x)\n",
+				__func__,
+				mpi_request->Header.PageType & 0xF,
+				mpi_reply->Header.PageType & 0xF);
+			r = -EIO;
+			goto free_mem;
 		}
 
 		if (((mpi_request->Header.PageType & 0xF) ==
@@ -434,10 +437,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 				    smid, "config_request", NULL);
 			_debug_dump_mf(mpi_request, ioc->request_sz/4);
 			_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
-			panic("%s: %s: Firmware BUG: mpi_reply mismatch: Requested ExtPageType(0x%02x) Reply ExtPageType(0x%02x)\n",
-			      ioc->name, __func__,
-			      mpi_request->ExtPageType,
-			      mpi_reply->ExtPageType);
+			ioc_err(ioc,
+				"%s: Firmware BUG: mpi_reply mismatch: Requested ExtPageType(0x%02x) Reply ExtPageType(0x%02x)\n",
+				__func__,
+				mpi_request->ExtPageType,
+				mpi_reply->ExtPageType);
+			r = -EIO;
+			goto free_mem;
 		}
 		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
 		    & MPI2_IOCSTATUS_MASK;
@@ -463,10 +469,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 				_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
 				_debug_dump_config(p, min_t(u16, mem.sz,
 				    config_page_sz)/4);
-				panic("%s: %s: Firmware BUG: config page mismatch: Requested PageType(0x%02x) Reply PageType(0x%02x)\n",
-				      ioc->name, __func__,
-				      mpi_request->Header.PageType & 0xF,
-				      p[3] & 0xF);
+				ioc_err(ioc,
+					"%s: Firmware BUG: config page mismatch: Requested PageType(0x%02x) Reply PageType(0x%02x)\n",
+					__func__,
+					mpi_request->Header.PageType & 0xF,
+					p[3] & 0xF);
+				r = -EIO;
+				goto free_mem;
 			}
 
 			if (((mpi_request->Header.PageType & 0xF) ==
@@ -479,9 +488,12 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 				_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
 				_debug_dump_config(p, min_t(u16, mem.sz,
 				    config_page_sz)/4);
-				panic("%s: %s: Firmware BUG: config page mismatch: Requested ExtPageType(0x%02x) Reply ExtPageType(0x%02x)\n",
-				      ioc->name, __func__,
-				      mpi_request->ExtPageType, p[6]);
+				ioc_err(ioc,
+					"%s: Firmware BUG: config page mismatch: Requested ExtPageType(0x%02x) Reply ExtPageType(0x%02x)\n",
+					__func__,
+					mpi_request->ExtPageType, p[6]);
+				r = -EIO;
+				goto free_mem;
 			}
 		}
 		memcpy(config_page, mem.page, min_t(u16, mem.sz,
@@ -1496,8 +1508,10 @@ mpt3sas_config_set_sas_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	_config_request(ioc, &mpi_request, mpi_reply,
+	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
+	if (r)
+		goto out;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
@@ -1946,9 +1960,11 @@ _config_set_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	_config_request(ioc, &mpi_request, mpi_reply,
+	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
+	if (r)
+		goto out;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
@@ -2080,9 +2096,11 @@ _config_set_driver_trigger_pg1(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	_config_request(ioc, &mpi_request, mpi_reply,
+	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
+	if (r)
+		goto out;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
@@ -2231,9 +2249,11 @@ _config_set_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	_config_request(ioc, &mpi_request, mpi_reply,
+	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
+	if (r)
+		goto out;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
@@ -2391,9 +2411,11 @@ _config_set_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	_config_request(ioc, &mpi_request, mpi_reply,
+	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
+	if (r)
+		goto out;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
@@ -2548,9 +2570,11 @@ _config_set_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	_config_request(ioc, &mpi_request, mpi_reply,
+	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
+	if (r)
+		goto out;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-- 
2.53.0

