Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072783;
	b=CRANrhrsWo51XIJsQ1ZGngsCcqM7ccrifz/SXYV3THxmaDrACYHl8iYZxNeYzQMQwLSp
	 1TfKkmzKVHTCBaDM94yUAgd6xd81kkQU/BKm0xO3NLw8Dq+Ibpd8+mjUV6GnSoQIL1Lcb
	 8y8bptIz15nS08mH3W9+FzKolN0cQF0ZXFcuC8jW7ZQRs7CVisT3lCjU10/BX9kEppGwM
	 L0XYoU9HH4Q23wBO5gMP3fBdk6et396wN+DwwzU0Suh41pL3+HG+D93SmN1bvPZuxCrEW
	 76x8ZJOaqCxb4o+F50LLgagUDus3t1b2N7ZaBBLVjmnvlu03yPapfUBQ0xnzbm7e3LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072783;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=nFPX2ljdfYklFs741hM8uS3dFgbuoJMTx95Uqu2YaiM=;
	b=JDUSqSkuRZ2vUQTgipt/ePER11Tc2Fhm+KfuTGsRF/lugHjlLXR/BRiDLMiAW1h3XEfV
	 Js3YYCZIrT3VC3g16A9+kJ8rS+lTZo0ggJ/QdQ9ZdEqTdnTcWh0JQty5GB583JUhjj7Bh
	 Ga7RmneW7lqLIJz7NYQ7j6kuKhDJiavSXzc9cOLcqTBmRnCDrhdl7OuCDR425TUTZkzp2
	 m490iuJ7yTZ3u06hlmrev1Fv5pFuaQ9NJGm4wMGUI7ghye2Rv7fODhNL04GsqB5IekQkW
	 bY0dRkfyRopf00AkxJi/QPbmhyqOzFG82dgxQaEKEbycc7FmzLtWgHcS4dsfibH4OpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=AlJfS29P;
	arc=none smtp.remote-ip=209.85.219.100
Received: from mail-qv1-f100.google.com (mail-qv1-f100.google.com [209.85.219.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC2606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DFC2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=AlJfS29P
Received: by mail-qv1-f100.google.com with SMTP id 6a1803df08f44-920fed989b2so16841466d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072782; x=1795677582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nFPX2ljdfYklFs741hM8uS3dFgbuoJMTx95Uqu2YaiM=;
        b=vli8c3NHQDSEtaQgniLE3zL0NtIH5ziPU1ym24T+qlsNWCCvXxd1sB7Gm38Wts2yuJ
         jBgXEjPngqqciRyUOoVk5Yz8YCxeQIksVUJNNbwLNdwBaCwoHkdT4DGU8dHfHP9CRT5E
         cTct83zGHRTSTP444v3C82rrwzjrwH4NxVfCFJkDiTACOToEuLoruUyn6nYqivqW8vDp
         2TJmnm1llbMk1VRHRRAOGRqBecWynrHhsWJe0o6Mg7pxD4sbTv2AHx24RHbvpxRUnbw4
         JFmR9TSJ+esfsByxtjmTu65sBEsYxqUDmaeqk1AVte6BS/DfhVmj3eR2KHffy6mzGO9b
         r4pg==
X-Gm-Message-State: APuU4Z/yhfZJc+t7/uXDVBVRD3x4kwe68fIr1erUVkW7Koc2QCyv2nYo
	5qXN+LY0qbeD+AjyX+MA1Xctbamov9vDNOAOBNcAGNEltWnuEKcNCduJGhU0+P/ytVcP//CzxxE
	CPvcY1knRTpQNhH1Yi9KFvMWaZ8aMOXaWqVyX+bOxkvCzbvZqxyAXW3etGCXSGPQRFfyrkK/mM/
	FGEtpTDDzvtL48gjdQHLh/w7KA8gqYXinrFMmL/rdCM2u/P+9bD34t6n5lK4uy8FkySNEryVqq1
	ahhvwAq3f9C04HW
X-Gm-Gg: AZFdTZcpC8Yq99//ntaWSztFawSEoxlIJoeCfRaZXj42R7Mgr6rQWJpYmthFvhlQoO8
	3gNn6/XCJr7UuCHD+4PJIwjnNn06cLjoSPLLbPcrk0hSuWDD+2uEZqrSzARqwNF+Dr+SGV2z2oL
	ScuUP9MAU3sGre000OL0ht7VtvmYrvOLpU410/+NHMy9Ba9U5p3hL6OekVTx/dtppiQTDPrfAOX
	XYxXmAxCh4wyQarXpgMmaV9RSfLNs6Gl8WYQy+JcHtiTHIF8FTtcsIzLwxfdH/NtXophWSw4cgH
	e2yWjNsmaqSOfSLsyoykLIePSVApj30GpIyARl2nMcyfkPKSU68ngMz88X/xLuZb7RYV/nJ+aPo
	lZiq5O9sUzo7nZh70vLRKjv6OVXWnVAZTFd+vZgOLoManGE+Xwx5GZAiNekLUvj5sEliua4bzxX
	u5XZoTOImgnM1Fgi9HBPhJ5GWyI93/A0cbX9I=
X-Received: by 2002:a05:6214:240e:b0:921:552:e01a with SMTP id 6a1803df08f44-92114f8e56amr86119446d6.26.1795072782064;
        Wed, 18 Nov 2026 23:19:42 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-921149eb9c5sm603526d6.7.2026.11.18.23.19.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:42 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b3fd219d07so466469a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072781; x=1795677581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nFPX2ljdfYklFs741hM8uS3dFgbuoJMTx95Uqu2YaiM=;
        b=AlJfS29Pk4B9WR4sYAG1BVNEtJn3bFptUNZTNlILwdcj2XKKNgyTMpDpg2AX3/kR4x
         uh0jj7cRXuHTKe/uvzOpRtyyElELMvsBVe1QJKIiaj/UMoHap9q03VHKeexB59iGv6FB
         iGd9Y0Wcze5c+IPnFG92qE0k/eh0cFH7GztuU=
X-Received: by 2002:a17:90b:240f:b0:3b4:7cf:5e5b with SMTP id 98e67ed59e1d1-3b407cf5f76mr296045a91.31.1795072780712;
        Wed, 18 Nov 2026 23:19:40 -0800 (PST)
X-Received: by 2002:a17:90b:240f:b0:3b4:7cf:5e5b with SMTP id 98e67ed59e1d1-3b407cf5f76mr296026a91.31.1795072780102;
        Wed, 18 Nov 2026 23:19:40 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:39 -0800 (PST)
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
Subject: [PATCH v2 10/20] scsi: mpi3mr: Fix target device reference leaks
Date: Thu, 19 Nov 2026 12:41:22 +0530
Message-ID: <20261119071133.127282-11-ranjan.kumar@broadcom.com>
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

Looking up a target device takes a reference. When a target allocation is
refused, or when a device has no HBA port, the reference is not released,
so the device is never freed and its count grows with every rescan.

Release the reference on these paths.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Fixes: 626665e9c38d ("scsi: mpi3mr: Get target object based on rphy")
Fixes: 8e45183978d6 ("scsi: mpi3mr: Bad drive in topology results kernel crash")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=9
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=9
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 10 ++++++++--
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  7 ++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7de8f20e396a..99928fcc5bd7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5114,8 +5114,11 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 			scsi_tgt_priv_data->wslen = tgt_dev->wslen;
 			if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_VD)
 				scsi_tgt_priv_data->throttle_group = tgt_dev->dev_spec.vd_inf.tg;
-		} else
+		} else {
+			if (tgt_dev)
+				mpi3mr_tgtdev_put(tgt_dev);
 			retval = -ENXIO;
+		}
 	} else if (mrioc->sas_transport_enabled && !starget->channel) {
 		rphy = dev_to_rphy(starget->dev.parent);
 		tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
@@ -5132,8 +5135,11 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 			tgt_dev->starget = starget;
 			atomic_set(&scsi_tgt_priv_data->block_io, 0);
 			retval = 0;
-		} else
+		} else {
+			if (tgt_dev)
+				mpi3mr_tgtdev_put(tgt_dev);
 			retval = -ENXIO;
+		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index f1e34329f5a2..26dee121bc43 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2575,9 +2575,10 @@ static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sas_rphy *
 
 		tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
 			    rphy->identify.sas_address, rphy);
-		if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
-			port_id =
-				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
+		if (tgtdev) {
+			if (tgtdev->dev_spec.sas_sata_inf.hba_port)
+				port_id =
+					tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
-- 
2.47.3

