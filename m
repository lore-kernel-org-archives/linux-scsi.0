Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926812;
	b=E0U51KjJbEi+0YQtSr6RKVhV78pK0fm4bIvuHnNSa8A038ig/WPZ2e3eoDhAnqNTnqSm
	 iEDktUaITy5sgn81HmoLXjKP6ze6yOsX4+JLGEP3oxMlL2IVLQvrQoYBeO2hhG8Bjl6Om
	 1w8yi3u8Ci3U+CPhyNtdZzXmELY3EyzVEFd4GXqAZJ/wvGZNeo3RiU5h08LkhoDCpPRGI
	 7VM2BHcNLPlvqDzxiKYOQ84mXYtBGmz5yERNQcKrVr868G66GrXCswEXnM/ZNZpmcrsJ/
	 hkG3cr9j45Bl3OvgOVCxI/tCYDPsrygeOjezFLCVVjDVfePMbth4H16xhHnp7KPlUzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926812;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=6nGmi9N83o9GwRS0B2nx1iaHiH3QtOEKlDYmEo39YXg=;
	b=dYH40dyjK80Qn5BHP5Ut0Paq3PqKo/ZVNMFFDDtm66VJYrGCbt7RJFdIrH8LuHYjzT74
	 9BT1GPf0QGGrxA4rqBkRouU1OfdaGfw0VWEJ/N632C0L8pTJcVEZb5Ye/rEXclA2eNXN5
	 AlP7LHeLKSGGONbrFjE/OrfwDcyohuQaf/KLx8HjRUTnCiIw0eNj0fTmk7l17TJKx1Hvg
	 IWMWXofSjUqxsdc7ADvmQR90UcUJsUxouL/Ws3wwnOmO8AM6WKZMYbdNeAldA0rzq9eQT
	 Tsl/yM7puCE91hsmu/Mc3jQYilGViBBU2lWz5ruWc2KVdSF5B/+pg81BrfDFGcUMNvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=I3TrB42I;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6759B606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6759B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=I3TrB42I
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc147d86bebso112108a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926812; x=1794531612;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6nGmi9N83o9GwRS0B2nx1iaHiH3QtOEKlDYmEo39YXg=;
        b=Fbd+yAo0TZvw6KJtBiTKKGJqGiycrjGI7TvKpdX5SXRiSsjLL54dFC7MwEtOH9luO6
         GcRFlvtTKd9s3eKcEVbKYQUxuJJlcbQ3ZCrJEQ2XYLWV7aa3AVixeomh8+b1gYa+r0/e
         dQ8qOFTh9U0y5FFQsHOlsgl/NKi+cAXLZvqudcPfzUorLXpReMwMOqpGy6vUV+u9Y3i5
         LEGMlyuxBjbYWQrLI88yvvmnTkw3Ts26Cb0n2dz0vq11lNfBH0rJcX5aDU49+AFxNFhE
         qhkN4mNhEyn3bfOtK01hEKjXL43Uz6UO3Kk8IPQTNAiaWQpH5h8w7qjVXuK9rn3cLbh5
         XMVw==
X-Gm-Message-State: APuU4Z/9uUPfOwDxhi6wzEOG61yyJHNph3SU7yem4PWfUhMAoiAA+O4/
	XJesfu/IkJHKZFSEJvUYSyezLIAVFOXbI/9bm171AbbUKCujPXr5DtwVizC//+T1NyfCzef7SjU
	4phoOc6T7ZqU3WkJw019i5R6hw+4XZp7qs5aVvgKGQu5Ni0NyEiq1k5bY6EV7+cybasZ8SyTctK
	i3/Y06NaYiADc0JLfvNrDJoaBnxuSITwq8yHSp/EHPeCddQNmnVzg1FEMo2P3LNTSulrS3l/zOH
	bTttTmBbefNSFMos5qwUSAlSqk7o8JJyK8=
X-Gm-Gg: AYBFou1g1bCOqJ1mk3UsQ9FzjCe5H73SB5NURF6ZXvSV7skV/n1xwh+IeXaPLBFEBqY
	qBbynNNQO8D9gKKiZK5anGr9yjgbXWgZgPlj8UFngP8226Bz2djfCqhG2tzzbfdOvZTQQ4zwNYM
	xc0R+kLB3cZNyQlEJEK1WTe2Qg1p9QlWgBi1eSsckgE/Scp8eNyKsoCEh89FYFoG+/w4rr4222y
	xG1GMA6R1MroW3+6ILzG/HbnOmkQO8JRSPbgvjScZtqMG1Y4BLcT9R0ycqjcWw6htH5mU5aHZgo
	I/QTUq8WVr9vAxcHsogtfHNpVG/Vw2Y/YU7/FJFIewFZbKjGwHz5kmVZlNi2p1+PjAaZ7H8+8bh
	eeRv8BPE2Duu4I+8BtGt+WEFKwxetoSoI1ULsawdlpaef4jSXGB/6pZjn0sBDPthZmPNHp2V5ZV
	G7ytxi/eVFCnuhXUIyv0+slXdNSFnuHLvMLEQ5nGF0YmReEHGiiS/Qmw==
X-Received: by 2002:a17:90b:2684:b0:3ac:9ad9:6afe with SMTP id 98e67ed59e1d1-3b0db70db18mr490648a91.39.1793926811612;
        Thu, 05 Nov 2026 17:00:11 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09451ee93sm2330036a91.0.2026.11.05.17.00.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:11 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed216ed20dso1157965ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926810; x=1794531610; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6nGmi9N83o9GwRS0B2nx1iaHiH3QtOEKlDYmEo39YXg=;
        b=I3TrB42I7H8mUrG/BLPRsyJ2wlrdaTYTT5l140/Y/lqOKelpTf5E9DX/XMFwcwZgPC
         SBGB5DULNtB0EewcAbru1sMiMgQWVjtZanhyuv30l5JIJLWPFsGQHrL803Em+0y5o3+2
         spZLiGyXiib482BRquE+MchkONMMTK/w0f8bg=
X-Received: by 2002:a17:902:e80f:b0:2ed:3e82:c43e with SMTP id d9443c01a7336-2ed40c1b5b0mr8380685ad.19.1793926809792;
        Thu, 05 Nov 2026 17:00:09 -0800 (PST)
X-Received: by 2002:a17:902:e80f:b0:2ed:3e82:c43e with SMTP id d9443c01a7336-2ed40c1b5b0mr8380445ad.19.1793926809090;
        Thu, 05 Nov 2026 17:00:09 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.17.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:08 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 37/37] scsi: mpt3sas: Update driver version to 59.100.00.00
Date: Thu,  5 Nov 2026 16:42:52 -0800
Message-Id: <1793925772-1303-38-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Updated driver version to 59.100.00.00.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 192b8e8a5b4d..f88f85b054cb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,8 +77,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"54.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		54
+#define MPT3SAS_DRIVER_VERSION		"59.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		59
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		00
 #define MPT3SAS_RELEASE_VERSION		00
-- 
2.53.0

