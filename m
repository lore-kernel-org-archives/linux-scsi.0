Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926735;
	b=xkfM4ZXNsMfIdqCggdvPbg7vI73rvYm7Z4lB6gfcx8SB30Rs/8A1l/GWn9Mdc/l64uGo
	 Qv6mKKdBvFCey5k+jkjqAKUSI8VTnHzP2gDdp891c3QQSnWUfDFdIXWTtzBheFKqpy4Yw
	 w8tkEoX/Uc/OC3ZhcCnGeMVSSnBZhmPzlTe03KapwUnNXNaWiX4ZWzSyN9HQTzhktp5Hj
	 z12jfhigV39ZnzA4AxR05QzGFqWxNm/17QKTlhXpNaPU60udLonDUdPr9XGJ172emBF7+
	 /kRdJBJHJO0qd5PcLxnDM8ffmZC5PjfI5O3LMn3VCGxpyQAoE9VztJz+Q8/F/+J/MWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926735;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=V2aT2yAMIPvqe0vRMYDRggVRiHJTEh+H4rJ0rTsfwnQ=;
	b=Isd4LHHw6cMVsEIvskMhaC+KFo3Ee7Yaqb2Ozt2VU9Sc3cjrGMYXNzKTfK37G2+aAAyX
	 5apDCsF4MEnbPCpr1H6sHN1lpSMDbFUHRVPNc+nlVG9rCPuVFI6obRYdjZXIxYZYnrdPq
	 xXXgqgIc2O5fref/xgV/ypGpAauNt2eJP7WFtYGyxaVhMnMlyEuVWE4r2x/2lABC1+Nq7
	 ZxO08UUN9/WiL01aG+HOsG8g3CuvewB+YtJcmbW2JE0u+h9Tz1EbQOAx3fQl6OraG1aab
	 xmgX0bxwfsW6IjW3BP6hx279eyXy7wNxBYXYMk4wNCabVd5wRqJs8O9o+7WriKzGDTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=V9nEQDYM;
	arc=none smtp.remote-ip=209.85.214.225
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E2B606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26E2B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=V9nEQDYM
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2ed1f1a7695so297285ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926734; x=1794531534;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V2aT2yAMIPvqe0vRMYDRggVRiHJTEh+H4rJ0rTsfwnQ=;
        b=KfHH3SBrALNbfGNbS9bX6KgqmWOsFnRiVw4L4ltH7+72/0m1Tw6AFtg4IJSOiKZmAj
         rUBI/lYfQRolXQFR1QlSzHs+fKoRDnoNRArQv7/22fBJOjlrA5GpyM7xqcts9eVu1JRa
         J7cnK5fTlWmnzyMfrNO5icTTu5KCN7NjI6DQv94OZOZ4rcOIPscBgJe5dLgtFwNyTU+6
         8OE0Q2jvfmeEN7GIGeADihp9kv8pEBx8WZ2gl3ZBdIk0mdJBs1A8/myNkdCQTHMzeNlN
         Sm+X2GD7a7Lb4qD9VvbSnPGLPfWnIXQo1XQDLhgE7lY7hTNfniSJW4h82N5iaHK56FTV
         /Taw==
X-Gm-Message-State: APuU4Z9IfsZ1LCvRNc03WfYz+OAfJx4+/T9+P62Z7zKapqEEVKqWV0AI
	Uk4RvZYbEUbBYjR1NdoB5IUWSzmvKsq7GT7VnMCxKpA9VpG+/d1DCP6K8v4ZwrOQrSQjIA9noNS
	lBXC1Y2CLRewhgJWTPB2XVGWrZzfnkQKJomruWoWBaWApNDZiQ9NyqY6fkYHhmPXUQvDkeyYVIS
	BOT9CbIHctqfbYUgxoSrwZXIEHRBT0sRFlkJZUnj725OWRT7mJRMtsWr+3r/iJOFQlF2HWohF0F
	kPbyVy2ppEUfJaM2tse5mVhmKz2YMJf9NE=
X-Gm-Gg: AYBFou0IE6x/1B5r92tcc4dM/dWXz20rfLdKlCmz5cR6gvkRS8K32VjpK9rikcvFo7v
	YMrnlXBKK65HpCCZUCmZ/Xy68161C/WD+bn/Kg8Bk52pbhlKtK/M1afHGPIal7MuYJzaNHebZcS
	ZGrTjc52eLNIBHp3z99FvFi5+1HwaZXfUgM/OIM6AwsXEB0MlEtZ5CX5czjyJni0tvH/Nrg9NGw
	5xRw2Z3z0v+gQcwY1QBWnIvF75qH+EeF5DYtduiVZirPQNshnfGgT6MVppE0uB2/c+SztT7Th51
	wQ+OxEOXrw9Agz3WeL+39jxTJh1FPcC1tCM8SShC2djgIw5E6ktB22y7lLVUgOzafVgIg6VJvIi
	reF2BMdsouV6qf9CyX+jaDdIoq52aR87ciDYdDx4U+XlmUwgpoqMYVMrkOwBLs2qornbwLO4QK+
	uQEk0owW9t/JKBeAeh1zMw97uPQxY5U1JCtqvsuwiTbgD2Hvvja1pLWA==
X-Received: by 2002:a17:90b:540c:b0:3ad:6090:a17b with SMTP id 98e67ed59e1d1-3b0db6dfb64mr728445a91.17.1793926734452;
        Thu, 05 Nov 2026 16:58:54 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7de0ce5sm723466a91.6.2026.11.05.16.58.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:54 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2eaae8d29e0so1005545ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926733; x=1794531533; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=V2aT2yAMIPvqe0vRMYDRggVRiHJTEh+H4rJ0rTsfwnQ=;
        b=V9nEQDYMccNGId4Pd3luAiEAdnQqLSmZ8dLHccsfuvYlCG3JkEdjPQBXoODjP2WSXm
         wIHTdhL21ne+7Ii2t2/M7CKyyLcJPqn8MIBVdz9ZfDXin48WA3QGbHPMAH0A8dyY+jp1
         Dim7JwKLiGfUbd0GlN0iFh42RzR60O8PAOh2A=
X-Received: by 2002:a17:902:d50c:b0:2e9:95c0:7c50 with SMTP id d9443c01a7336-2ed40e25779mr13397635ad.71.1793926732735;
        Thu, 05 Nov 2026 16:58:52 -0800 (PST)
X-Received: by 2002:a17:902:d50c:b0:2e9:95c0:7c50 with SMTP id d9443c01a7336-2ed40e25779mr13397455ad.71.1793926732168;
        Thu, 05 Nov 2026 16:58:52 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:51 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 14/37] scsi: mpt3sas: Fix buffer overflow in _scsih_scsi_ioc_info
Date: Thu,  5 Nov 2026 16:42:29 -0800
Message-Id: <1793925772-1303-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Build the SCSIState description string with a bounds-checked
snprintf() instead of a chain of unbounded strcat()s.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 788b611c7c52..47bc48f7b9a3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5777,19 +5777,20 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		break;
 	}
 
-	desc_scsi_state[0] = '\0';
 	if (!scsi_state)
 		desc_scsi_state = " ";
-	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
-		strcat(desc_scsi_state, "response info ");
-	if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
-		strcat(desc_scsi_state, "state terminated ");
-	if (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS)
-		strcat(desc_scsi_state, "no status ");
-	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED)
-		strcat(desc_scsi_state, "autosense failed ");
-	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID)
-		strcat(desc_scsi_state, "autosense valid ");
+	else
+		snprintf(desc_scsi_state, MPT_STRING_LENGTH, "%s%s%s%s%s",
+			 (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) ?
+			 "response info " : "",
+			 (scsi_state & MPI2_SCSI_STATE_TERMINATED) ?
+			 "state terminated " : "",
+			 (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS) ?
+			 "no status " : "",
+			 (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED) ?
+			 "autosense failed " : "",
+			 (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) ?
+			 "autosense valid " : "");
 
 	scsi_print_command(scmd);
 
-- 
2.53.0

