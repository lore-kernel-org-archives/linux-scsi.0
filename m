Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926789;
	b=JeihCxIV24Ze6TAUBI+qWXQDjSSF2P+8xZdgqSAlYSYqd8GSM0MxNQR1N+YoFNWkKrGW
	 kzW8itPLfHvph93Kr3M0EWMdhOcsXGGBjoe3AuVHJwpFwo0ZXGmGy0r9knz5vGBDcQ5Ja
	 3KnzqvBmMpfVzojm50dPUBn4bAAwnTWOfAxRcGh8DZjQ0uCMsLJCiR54CzN5NvMWf8xsZ
	 j1occxA3YlPrR3QlyAKy6Mioay6HVmEAlIhv9z00PnvlPMwV8CwZZMKPuMItvBKR1JK+x
	 aB07LQbirZrmPKBeOGA0aGrf62Abv8a0J+M2HLTaUvx/P1KhIO8QPwUjq7H8PFehYnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926789;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=KPYxRgLXMjD90AfKQ4TTDP62resPAc3vl0b+d4YSlss=;
	b=QTBpVm7QybeRqAX0cRONcwpcBurF4awzTUsQTdmu2PbQt4yAn4EUoihSY9f2Y598+5R/
	 E1a/h4k0vpyE3pXQkP2RmiwE+7zKtzGckWQ0b2Z41WgoCUwShtXrWqK1pEzeEOObWko5g
	 e5ruM3bJKY2gybBqcJmD17oABoKzJcv10vPW3msNW1VtcvZp+jlz44nhdleeu5NKLlsQU
	 zV3esDv+xi0Kz9tgu0OV+0CST2nXYuv1RbKWzWCtB2xRY3M4rh/pN506b8acOjFgotTVV
	 WcJjad3E0fpC6bmddDd8RrvtWcQB7giJJwrK3kY0NngU1eHb1yewbsy7vhTJHJzk0ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BLFWzFd5;
	arc=none smtp.remote-ip=209.85.219.100
Received: from mail-qv1-f100.google.com (mail-qv1-f100.google.com [209.85.219.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A1606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 980A1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BLFWzFd5
Received: by mail-qv1-f100.google.com with SMTP id 6a1803df08f44-91791ec1b83so525316d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926787; x=1794531587;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPYxRgLXMjD90AfKQ4TTDP62resPAc3vl0b+d4YSlss=;
        b=ssssWYsKTD5XuayTwwM4M3P46COZDq9YQxNfblKXXxspEYAxgvB0o2xlFTKgMe2LAU
         ncYIimfUAeArnBjgleY1RXiOqwIhOZztyd+SdJ/6ftKtWwrXFobpSfokxbR3bIvJPTeA
         oh9Y43H3WwFDETpIJN97FSXW42G/1juSq3MWCi4bFq1BY9XrXJikJC54fF/ewGifaLDt
         5hC3uh2dtXQoUS5y+CCYAhfcTPsaf3UzzBY2icqhSNVooGfVIl1jdRiXoataqZqox4b8
         e9eamqM5eggxbopCWs7rcO/yeK8eBIBctyZi/ibm0bJB5EimfeuhFhehPUARx0U1HJBC
         M9ZA==
X-Gm-Message-State: APuU4Z/90i71671YGwCIw7kGiWzTbIz7Cho4v36WKOsckHazt25KHAxf
	n2cRfDKXAago+udsjRHOOQjgxXGHEMM1TvnPhjmH/e+Q+bpvVfKxx+qAnTS4KU7DbF+Ir2zmb+N
	rLLlyenb4oWWxxi3lj2aAVi0TKauGELB/4gQglKhIrXFzlWox+z+X6ap77sjQJ9be4bLSMMpqHU
	+BZUywEQHzkeKR//HXDy6zzV/NgNYnIod5KQX1bit1K9QSdIUdLMwrAGODRz3vrJgB6eVDt8l9t
	EWTKhBta7gv7JlTDDFMNq+Mu94Ncf71FU8=
X-Gm-Gg: AYBFou28sz7QwAU/HRftqzEnxliP2iOQxxD9lkHW3GAvOXUxlV8Un2UgwYdxoz12Z6G
	wV7GecMZEpB6qFsYr/hwQW8rOVAlEq5am8Fa28CCUFzX47E1g4ayf58CvuyVfZ7xJ335nIHpkJf
	fSD7/8TrDeSiEmeyrCcfCvra+FeO6fLlbNU/FQxrCW8oFEAAABuhX6w51o/4GBxuIJiKlNY/hDw
	Cq/wfNw6Cg04kIppsqeZoaqMa4db4x5MORsDdv3jwlO/ZZJHEIrQZwqBSDyrqPydfc6R9wDux35
	dRkjTCdhziizdbQ6LZyTK5zcr9lPCCL7qRix8E7UCBPa6c2QdU/1AlwXNBb3Wc2LFZHcn7LYbUO
	q+0KPaCn+5y4zMd67XmfAPHm6acybPUvaNp8u3JTTG+sMPsdRSip8rLu6LRJKq/iJJ3U2/XUKEd
	Nb6UnnQwi3Sbo1SF7hSMJHukOp/bz73WpQ869hdXesL479dSXhPILOSQ==
X-Received: by 2002:ad4:594c:0:b0:91c:6258:ec97 with SMTP id 6a1803df08f44-91ea974cb18mr10863876d6.11.1793926787498;
        Thu, 05 Nov 2026 16:59:47 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-91ea69d31f0sm170806d6.25.2026.11.05.16.59.47
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:47 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed08be1c84so1730275ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926786; x=1794531586; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=KPYxRgLXMjD90AfKQ4TTDP62resPAc3vl0b+d4YSlss=;
        b=BLFWzFd5/9LNDH6TIUNCKybJ3tQQv53QZX1AkQgZpx+IAAXK2xMDJZfb3huj/vH4Gq
         55qZ/EVJZbjFibgGK8yZniBKJziNVRgNLwEGZWH+c3AnELYScyi1ZuLQL3qzhKa0VPpa
         S5sbhV+gQDhZ8kEj5a6laFFWdRlBCDJoOmX8w=
X-Received: by 2002:a17:903:1b68:b0:2ed:3c61:bb83 with SMTP id d9443c01a7336-2ed40abb2e0mr16101205ad.16.1793926786332;
        Thu, 05 Nov 2026 16:59:46 -0800 (PST)
X-Received: by 2002:a17:903:1b68:b0:2ed:3c61:bb83 with SMTP id d9443c01a7336-2ed40abb2e0mr16101065ad.16.1793926785846;
        Thu, 05 Nov 2026 16:59:45 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:44 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 30/37] scsi: mpt3sas: Add _ctl_diag_buffer_reset() helper to clear diag buffer state
Date: Thu,  5 Nov 2026 16:42:45 -0800
Message-Id: <1793925772-1303-31-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Consolidate open-coded diag buffer teardown sequences across
_ctl_diag_register_2(), _ctl_diag_unregister(), and
_ctl_host_trace_buffer_enable_store() into a single helper that clears
the pointer, size, DMA address, status, and unique ID together.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 32 +++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index a8e92a786265..6870172c5ebb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1651,6 +1651,28 @@ _ctl_diag_get_bufftype(struct MPT3SAS_ADAPTER *ioc, u32 unique_id)
 	return MPT3_DIAG_UID_NOT_FOUND;
 }
 
+/**
+ * _ctl_diag_buffer_reset - clear every field describing a diag buffer
+ * @ioc: per adapter object
+ * @buffer_type: diag buffer type
+ *
+ * Call this wherever a diag buffer's DMA memory is freed, so its size and
+ * DMA address never outlive the pointer that describes them.
+ */
+static void
+_ctl_diag_buffer_reset(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type)
+{
+	ioc->diag_buffer[buffer_type] = NULL;
+	ioc->diag_buffer_sz[buffer_type] = 0;
+	ioc->diag_buffer_dma[buffer_type] = 0;
+	ioc->diag_buffer_status[buffer_type] = 0;
+	ioc->unique_id[buffer_type] = 0;
+	if (buffer_type == MPI2_DIAG_BUF_TYPE_TRACE) {
+		ioc->ring_buffer_sz = 0;
+		ioc->ring_buffer_offset = 0;
+	}
+}
+
 /**
  * _ctl_diag_register_2 - wrapper for registering diag buffer support
  * @ioc: per adapter object
@@ -1904,9 +1926,7 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	if (rc && request_data) {
 		dma_free_coherent(&ioc->pdev->dev, request_data_sz,
 		    request_data, request_data_dma);
-		ioc->diag_buffer[buffer_type] = NULL;
-		ioc->diag_buffer_status[buffer_type] &=
-		    ~MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
+		_ctl_diag_buffer_reset(ioc, buffer_type);
 	}
 
 	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
@@ -2127,8 +2147,7 @@ _ctl_diag_unregister(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		request_data_dma = ioc->diag_buffer_dma[buffer_type];
 		dma_free_coherent(&ioc->pdev->dev, request_data_sz,
 				request_data, request_data_dma);
-		ioc->diag_buffer[buffer_type] = NULL;
-		ioc->diag_buffer_status[buffer_type] = 0;
+		_ctl_diag_buffer_reset(ioc, buffer_type);
 	}
 	return 0;
 }
@@ -3862,8 +3881,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 						  ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE],
 						  ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE],
 						  ioc->diag_buffer_dma[MPI2_DIAG_BUF_TYPE_TRACE]);
-				ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] =
-				    NULL;
+				_ctl_diag_buffer_reset(ioc, MPI2_DIAG_BUF_TYPE_TRACE);
 			}
 
 			diag_register.requested_buffer_size = (1024 * 1024);
-- 
2.53.0

