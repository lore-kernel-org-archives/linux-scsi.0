Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072791;
	b=2iqhclD6L8q3pImTx4AgThDinwbvmOwvx9wweYzd2D7NmOnTB40oBg6qCrSipuldCm0E
	 7mir1lvZ8x0diLhz6AZom5vzne+ROUAh6BA9aq9R6XOjJXIilCRS30++G0HYGDWqDYkTA
	 mJl62X2PecDqmwnk8AdBvGRbD61arSUa5F6sYqJZb7u1uYFG82km4TkYRgj7XBYOVD3L1
	 lvYMglipi6dlwsItdpdJYVXZqR5ShgWGBr13VzDCyzyRrWm28B88Zrn85/2NegdkK+fNo
	 +MxOc2g8NLh5tiKyChYBSiWohrLv5g8nKKXJpyUZt2aXi+5my/1e6FEyAkjlNjyuF6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072791;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=Yl4Aud4+nI01JJE7OATDLhNZN7IHI7ouTIMUBxeFQtg=;
	b=E6e3A0+yCJGiiIDGU1QvyyJNwDM0bDZMpG3dvOuqLk3nRJ5JdHR2m8/C0dWSwYS15/HV
	 j6Q4E0Rx8785jssll3+fiVU2VRqy05WBMrOd1rtTKRWcT87xupujTl6fj4HoiJ2GkAiqJ
	 z5u+mrsnCTqyr0/Hg59K6ggTZnsqT0YdLK1WlPjGhZyDJwhMf81bPSoTSyzz7pSP7xpMI
	 HYtntPxec1KRs5dY3LuBHNr5m1p2TWuePYsCY8OKKCEs99G/EKklmOE/dEgi93IZi4azc
	 siCAr4jXO5uTbctRvlhfNivVA2wr4C3cZFjxLzDHyPSDhYWYHoUVBsgwnEz8oAlm9lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=CO2lO3uB;
	arc=none smtp.remote-ip=209.85.221.225
Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFFC606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FFFC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=CO2lO3uB
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5ead9f60e26so587541e0c.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072790; x=1795677590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yl4Aud4+nI01JJE7OATDLhNZN7IHI7ouTIMUBxeFQtg=;
        b=xkzTuERYEAE3mvvs8bYmhxH9Dc0WjksfCPQsFO0KeB+/lrSJM+D8qYuyXZcDgQ6TeK
         YCkvkhUJI4vxdW4bLOVa7ZtSJUoVf6SDjvs4jlwyihyoEYnDDCIquaqeKau9k5WMTRto
         4xfh0wNuBSVM848DTjh+DVNpNt/+BOQ/vhayF0TwPSckSXwxCXhUjVKTLI2l3UTI9uE6
         IQz8esm9FWPABYz+NsQZBTdI3pQ/4MqGt5NnSwIbIqCsFAjoEIHmIC4ZjDyhAw7KEFIJ
         jY3fPNP379FrShNZK2LCiIKkm5b1yYksBFbOqlMolc8NjDC5SeZtD+8l3DJdkCrxtA/U
         7q4A==
X-Gm-Message-State: APuU4Z+EtOjia4Rm+RJOrUJ6iiI+yiaKrqvFFcPakYhh9uqia9V9zV/f
	F3UmhQRNO/dSgYRrG6BOT34eHtbxgjSvCZQCRdxKU2VpCzebW9McbgwiI3bNlYO6EX8FpHapiLX
	EVHYODZdyuvpYJVu4fU7vXKKzV0jtts05CNb3kZOB+Z0oADdSJI/CZZ9FlnUfBXJqtQgKVsaHao
	3zrbZ3H+ajhdbfuLiOSG+81gT1+qJyiv4dJpb2AViO8k1AGYZvQB7F9VU7n7lCiTpAkA660xHHf
	6tvoN+tUZDHHbQC
X-Gm-Gg: AYBFou3C322eYcHOKaXfoTEfV+rHE/HhcmdWpVW6Kd0EZhT8GeTD6Dssiy5q3kKamEU
	ml9MXk8NAOl7EM4Tr/KVUQTqQWRw/a4TUeO9SPAUFm9ztREsfwZS1tdU/3cn0b/fD5hcKTEt/55
	YdmCA04EscZwmsG+7lZWXvnx7lM2g/a4tAyAmVSXt2npgal2oNOFy31YcdXE1+hX2IBgUyPgDNl
	ZBQxRoi2mUdYulqqnQy7Ihaze97EmrFPEH6YFIqNNPOlbySx3mv+3hX6hZa2f4P1ydhOHwyGTW5
	Gt4gnBVDADagkVWmvxxKyo8lZUNaOwYqZBnN6C0fy+AILjjUjZWpSB/NXLJwCo2BzCP93sapSGV
	FSIQsuxQa6qNW2zJzZRsUiEbbIzI7ZQb1CcTYV8WvvCULdSnRZlD3OPf1nBCE9jP6A3MQ6IwWL/
	iAR7cdqICjn3LQ+b34fjh0HydAVSuUjW668jY=
X-Received: by 2002:a05:6102:f8a:b0:7d3:133e:a37 with SMTP id ada2fe7eead31-7d6db98991cmr51149137.11.1795072790178;
        Wed, 18 Nov 2026 23:19:50 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-99e4a5f5aebsm471578241.15.2026.11.18.23.19.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:50 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3aed37745bcso555853a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072788; x=1795677588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yl4Aud4+nI01JJE7OATDLhNZN7IHI7ouTIMUBxeFQtg=;
        b=CO2lO3uBDCxe3Lfp9xexwCvu2rdklH7T/NTOui5fNs1HZA6spAS7NhC+FMOfSZ2d+R
         itZ0i9M8CN+qPv6HK3br8PYh+/vX23PNiOAVz7QZ1c4pjlUwhMTOGi55hqPRNXCl/ZS/
         BPnLPExyKr4g3uodyDKN+hMSodxr1gN/+4JDg=
X-Received: by 2002:a17:90b:268c:b0:3b1:6e2:3693 with SMTP id 98e67ed59e1d1-3b409ebc8c0mr192195a91.17.1795072787884;
        Wed, 18 Nov 2026 23:19:47 -0800 (PST)
X-Received: by 2002:a17:90b:268c:b0:3b1:6e2:3693 with SMTP id 98e67ed59e1d1-3b409ebc8c0mr192182a91.17.1795072787306;
        Wed, 18 Nov 2026 23:19:47 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:46 -0800 (PST)
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
Subject: [PATCH v2 12/20] scsi: mpi3mr: Fix empty device list race in the all targets query
Date: Thu, 19 Nov 2026 12:41:24 +0530
Message-ID: <20261119071133.127282-13-ranjan.kumar@broadcom.com>
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

The number of target devices is counted under the target lock but the list
is tested for emptiness later without it. If the devices go away in
between, the user is given a count with no device list.

Decide from the count that was taken under the lock.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=13
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index bd105efdd9cb..db27bff58c27 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1499,7 +1499,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
 	if ((job->request_payload.payload_len <= sizeof(u64)) ||
-		list_empty(&mrioc->tgtdev_list)) {
+		!num_devices) {
 		sg_copy_from_buffer(job->request_payload.sg_list,
 				    job->request_payload.sg_cnt,
 				    &num_devices, sizeof(num_devices));
-- 
2.47.3

