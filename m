Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072780;
	b=a3E+Zo+cqCFjuq5MYEOS3AcIl0eEMRT7J83+HnaW5lNOQlQG6mLsUihESMVhEwT63+TE
	 wV+SLZ4kX6yuXLnhFilpeKBZlKPiymGKqO/fnnN8LRQI3oTPgB2EmEb36W5qYAGmrUqgS
	 Odf0iXHVNirTdkQRa3rXYOvjs0PnEvcbPQVn6iIPc82+VfTlBUKLJmNnVSAVrHVKlbEWs
	 Vw5w8Uiyn7bX/NFQU9E+nTF5SBOpJ3IWXV6hT8tEJGKSuBSAxsG6cCJQwdzGirtJH/r7v
	 doyUi0kPbcYPIdOJHD/fzikvDAjZDlSYmXi7mlwAzI1hgESPjTRLQR01jnr/fT9904A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072780;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=oujmMz9BCSgEP63rK5A5KBALQH4TEIQdpFTTb1rGEOI=;
	b=BnotpEb+iTb7jSjZCz3sJKaDFOjAmtuwBU5IbFou17WaLee3QpP46HULsEohKMcv2d7S
	 i5HoypKn60w16zZoGGUATk3d7vbV2s+oq9HwV8BjlzqsEnN9jnYF0GAJHWONmjw2FiW9k
	 p4R+6YAv1vRmUSj46nMse7UK/L86XOORPjuGnIx0ituUkznaJ5BG5bpCeddkOv2nTRgTc
	 fdBLNhl3ioZskC3J0i+bkP/J6WYTEEpdOm4OHaZpzbxkn0H1C+v1n/lDq+mWxdLJv6sL7
	 8i3l4uNeQsvSHd7Zr/34WS2ZiBsVe+aqnLhmR69OC7Ae9h/w9NubovkHLD7LMtklg5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Hemcnrzh;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642B606A32F
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A642B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Hemcnrzh
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso1127670a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072779; x=1795677579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oujmMz9BCSgEP63rK5A5KBALQH4TEIQdpFTTb1rGEOI=;
        b=iJa2SisaHC7l1MBwF23T128bQVmZo+nWq2O04O/WJ1uny3e1p/FwIvDK6b/+aNhLBI
         LKVEBvUVm3J8K+uN38gdtUze3RcJWo9iZCGVxiKxW92cy0bpwu5/KDAyI2DO2bDuJ8/3
         ESbHeBw6sudh4GA78TjMQvgU4RFghdh8ss81PzhDsg06UlTj1MvcGvi6PapCxqfpCUPg
         Kbyc3G28BrL7yHtS+9ex/dT6tJ83PKiunFSFg/MPRXEGENDZLyUrAzvq2HHLPuMohz6N
         Gc8y8cclxsZofr114qt0UZbUYlZ9qPPPom+Pi1CvD0EUDCg7vUbTCRZlv8GAJt3yUExo
         wCmQ==
X-Gm-Message-State: APuU4Z+CykxWnf97fdVjQ0N5yr6gM2ceFLs8rKxIzBLV0noacUpz7Ksl
	DcgGRb780GyacU9bevszmsJFItl9JZioTqn9N0ejUewUifqnCKcDiHejcCFJ7vOHI2Wm6NwcbiD
	E3eKSOVHyfyCFBDcY/GivC8lUVVpIS2DZxm0CnUph4fTK8YmmV+oUeRKI/c0cEjenrAAh+p8zm/
	UETShnQPkhWnPa8yEskLh9FJNB9YR9drJ8KkBHLgqxS+jNRdpRjBjMZnSNGPs3yhYqbQeITTBoX
	FYN0gVhGaWkYEZl
X-Gm-Gg: AZFdTZfSKdBsnWL0o9+iG1ByHZulXcAWwtUwqqFd2bBD2n/PRbsZsOSaRI9n3zcRQtm
	JmObrSBE86E6W0d6zeByL/+f6owyKLmZAbEWwx2mcQ3wnM5dii/XRoBnlRFAQv68TUtoNFFb3at
	3TBFteO4W3ZWdj3/7xyt1Ojpo58jQy9wVfJfW89Xu37ORP3TJpdSN/hl+Y8/o7GoXl5227EFyhi
	H2EWPnnY8+j7a7CJ2cgSo1pBPh/lfCIxiZcT96Tv0f9HYUingwYP0osVgHlpd85LS2edtvx6Py9
	UGRwIdRQJOE5Snn1ksVvfn+LhZ6A0VrBrGeW6IWLxGWWBcum3YLpqGfylFZuBfF0uG7eCD1154s
	rxB47tLwkzHioItznu0SrbBfh/kdeovvCk7dNEDgdvSmLdimNgRh+08CA3Cs1Z93Cug0Q6jAFTv
	fm/nB4U76Twqmi9fW4XD/cmQdTS25Ol4KaZKc=
X-Received: by 2002:a17:90a:d005:b0:3ab:9c73:12e with SMTP id 98e67ed59e1d1-3b3d06a257amr5792171a91.6.1795072778919;
        Wed, 18 Nov 2026 23:19:38 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b4059714dcsm507761a91.1.2026.11.18.23.19.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:38 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ac8f449d1bso1509649a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072777; x=1795677577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oujmMz9BCSgEP63rK5A5KBALQH4TEIQdpFTTb1rGEOI=;
        b=Hemcnrzhgt9TUMjF9x5t2tBmcAvGwbcG408jsBdtkJeL3JfTcrRKJufZrg3AKAVOWn
         zip6hDY16ChfIpM+OIW/9wSToP1ac7+cDWNfOCMgnRXRaNS9mfKFg8hzG/Kyrdi7L9UD
         iUdpn/u7hvmKbQeusfCfTYFKLMAbe1UCF8XAM=
X-Received: by 2002:a17:90b:4c0a:b0:3b0:934c:5e41 with SMTP id 98e67ed59e1d1-3b3d07aa71bmr6111010a91.29.1795072776989;
        Wed, 18 Nov 2026 23:19:36 -0800 (PST)
X-Received: by 2002:a17:90b:4c0a:b0:3b0:934c:5e41 with SMTP id 98e67ed59e1d1-3b3d07aa71bmr6110990a91.29.1795072776505;
        Wed, 18 Nov 2026 23:19:36 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:36 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 09/20] scsi: mpi3mr: Queue DEVICE_INFO_CHANGED events to the bottom half again
Date: Thu, 19 Nov 2026 12:41:21 +0530
Message-ID: <20261119071133.127282-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The DEVICE_INFO_CHANGED event shares its case with the LOG_DATA event.
When the log data handling was added to that case, DEVICE_INFO_CHANGED
stopped being queued to the bottom half, so device information changes
are no longer applied and the event is saved as log data instead.

Give DEVICE_INFO_CHANGED its own case that queues the bottom half.

Fixes: d0d19250ed81 ("scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=11
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=11
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6b0156e54d45..7de8f20e396a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3273,6 +3273,10 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		break;
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	{
+		process_evt_bh = 1;
+		break;
+	}
 	case MPI3_EVENT_LOG_DATA:
 
 		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
-- 
2.47.3

