Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926782;
	b=wAu8ZoMSBxdb3WIhW+1KzVRseNY819LKTxdqfpw7mSgdqFOWU3k8b4QL9+9aTezeG/pC
	 9jBda84WTOnlJb0VLUYf+Ti4XXvEj/3D4CzV4gQSY08gFNlFOZUJjTq2nqWPOp1WK8sVm
	 KekZQyAmvig2BD7n0B3LVrw/XuJB1d7tA3fRhrPNh8vQcesREtJ9KO747k9ejQrYTy6sK
	 eWOobnsMdnVYZ/8TH8qsYpbC9kwjbhdwY6Jgdp4F1DaVODYLviKrkNEK0DBkqvnUDa8An
	 ueq63yOohu/UnwoM+dZtlfjf1XzcGQMu/jK7A5Gihex0ErM2o5k2ZcQCCSAw1XNlL7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926782;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=KrI1gYIRIn5NkDzENTe62pARY7q88p/To2IlaYgiHzA=;
	b=L1IGVH7+2ec9uM0y6zEYq11TFuevHLtawKTTo8Flh4Q5c6V0ZbTWo38OxoOCOj7Bl4O+
	 yDcvn/fbHoq8RHy2gAagXTDH9A0kIBF3PRs6owPsdscvgcgeqdTvYornUtC0r3zV22ZeM
	 W+6LWofxepjwI8X7uVPiNmPdRJ7P9kfgcHVlMWmOGsPqujSvjLucg4Nz8xb8KzpoN6LA1
	 im0J5DiLwLMsT5o1HBtTvcHR/ca/fwoqKmXb0xTKh7sKijPX5AXAPJTVfhbZhwHKIirO+
	 qM+/Di9WQv43Us/3hEe3eBJbsaLiMHeB0xchtNU9AJtTg8u8q9KxDzYkefHSUH0hqSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=HnkPwgdM;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A7606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D0A7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=HnkPwgdM
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so70646a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926782; x=1794531582;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KrI1gYIRIn5NkDzENTe62pARY7q88p/To2IlaYgiHzA=;
        b=afCey2zpUx0i4sMccC9YEgjZ+UQHE0X3GwoVCEFmJRVvsREMo8Wc9PQ9GkwlnH/zwK
         6XEqtQiYYNz2/m2h43ZVUGc/Is07g2YmCXKA4hRISfXjPrgycCyLkw8pGjFDjLzNvONF
         hGOIWUL1FXa8M4lxD528MyAcvG6sl+zc30FdM0/zIfuYSnzD76zrZS4fchhPS8tvdtun
         q8ohfMlaK8JGCyUEPeyPRQepDjNqpvLjtd1Cmveh/UG4UNRhDpIu8sE8rnycxAIooW2l
         dtEIoMzcKd2MT5VIPqcHPFugzm/y9vJY2xwqc4Pti3lH0QBvRE2q1L6yoHo51CmdOiVx
         647A==
X-Gm-Message-State: APuU4Z9FWWTp2CLm9YDmIiuqwUgbn0Jrr7JwN/qK16cGM0STN2PmfVD5
	IWysfllEgamXK/+7LXudLZ/AXLJ6izAQ+FEi2MVRLg78+BTR474pELsRju6BdGGPgGf9sNgYdyN
	L+451KbJydIagjN3/vIXyeDBvp9s9nRnAGTXCliVPOq0S0+hqA3MIeNcHJu2I3IH+VTFifAA5/1
	3LPatEELEAGRNnKXFeQRh47SY5ZHmTp98431lmUspf/kTECRuPKkRJro2NYcE0iEFVUldclFmEd
	8/ecwjK/QmShpBplrqBmXuD/O48uUFFasM=
X-Gm-Gg: AYBFou3GzpWtw1sPwvxnS1gCLUy2hw+HFL36ItIYCIyzvrzQHZZzmQIQbOyeyLNAaUF
	pEVhTEglQDtI/yKrhXKLSd9otTcXTuFIX5mw/76UuS6++3A3pVaXXXpy9dMAV1VlqYcHdua2vSi
	2QUFSWelvsTRUJH1GMcHgUBeFXueYcmZa+Y293/V1ESGhDAwy8s1uK50rTQKKrlwamCIo1q9z5v
	2uGNxNbv+DsX0JKZvKCWfDLqQcmdWXVbeFKWmyCVWbch8m6k6TEbC51qHn17rvZ6HsS08GSP8Ie
	Cb3FqAKxef9Lhr8wZFbCWD9qvNlWCp9+68GU3YxFAozSAsl2sRxSz7ECcRVPZlwPGjYlmYHJv6f
	uBpePLXxE/aHTBqbl0Q/Mf+gPbI+hwSXkCsgBNIKrU19Y26RUDIq7Bn1Tjk5HmabbRyEx9deNiv
	S5ciE4sQ3MIQ+trY6igI257wYJKDt/DZdrHsLKV1Crc7PkdgrDi7hRFg==
X-Received: by 2002:a17:90b:540f:b0:3ac:80dc:f40c with SMTP id 98e67ed59e1d1-3b0db6d7586mr842848a91.14.1793926781566;
        Thu, 05 Nov 2026 16:59:41 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094cf3bdesm1841879a91.0.2026.11.05.16.59.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:41 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed02a00b24so1140955ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926779; x=1794531579; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=KrI1gYIRIn5NkDzENTe62pARY7q88p/To2IlaYgiHzA=;
        b=HnkPwgdMW6bwA0hYANXq8K1m2O58IP3K1WRoszkZPBI9JjM4SNXHqmhXqnXntjzDBV
         0tZAr4S7STp1ASI/TU8fAGvP6QUsmi9ytU8jRdrU7wq9Hv+W1yPI+CxtEzVbWyk7LvjA
         t749KkaYzLglC7+c+dJX3TdziLajwwA3uV68M=
X-Received: by 2002:a17:903:26c6:b0:2ea:1016:27fb with SMTP id d9443c01a7336-2ed40ad43c4mr14933095ad.13.1793926779611;
        Thu, 05 Nov 2026 16:59:39 -0800 (PST)
X-Received: by 2002:a17:903:26c6:b0:2ea:1016:27fb with SMTP id d9443c01a7336-2ed40ad43c4mr14932815ad.13.1793926778909;
        Thu, 05 Nov 2026 16:59:38 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:38 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 28/37] scsi: mpt3sas: Replace panic() calls with error returns in _config_request
Date: Thu,  5 Nov 2026 16:42:43 -0800
Message-Id: <1793925772-1303-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Replace the four panic() calls triggered by firmware page-type mismatches
with ioc_err() messages and -EIO returns via goto free_mem.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 42 +++++++++++++++++----------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 2b5e42255d3b..271d7dff7c07 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -416,10 +416,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
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
@@ -430,10 +433,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
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
@@ -459,10 +465,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
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
@@ -475,9 +484,12 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
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
-- 
2.53.0

