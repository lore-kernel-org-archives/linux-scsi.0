Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794222;
	b=NbMSc4Yl7h4ZHfr1fnl6cZ2iCmQtdzWLlnKpnIWP3UUPC7Y96dvKTkTmLD89KfsKfQ6Q
	 u2S4PKTtlc81Bc5HkSMLwrOJNx+XjIim4e0Nb2kbIeW9YOvZ6AtpGnpkuVr/OvGNufgp/
	 3KXpgVE6f9rWoZYNtYkv9g+Z3Klmbxw0DNT5C4tGNihUzGBC8b8AjqSS+8TK7yRAwrv4C
	 UggVua97+YhRsd+7JiWqNmr7Ob54LJyjxnUeAN1ja7AxWNhweSG1CdfCN7wbpYJ1OyNrt
	 e5v/OJ/0d+rrntA9y0ORnJBuOcUGksw2XPdoJZssWQtzPbAoOrfbIui0VL2zkgzLoKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794222;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=nFPX2ljdfYklFs741hM8uS3dFgbuoJMTx95Uqu2YaiM=;
	b=ANNuKDn4TMw3AGVb4ljtD4cXY26dfPabeaSiMs1dVDC2yzRaJf1Rl9heRlS4NARpiK2a
	 kuL8V9nQbYfx1ulIvraOmiVhb0gOtkawqmIkkuTt6Rzli8SUhe35+I0RJMHwhD22f+8hS
	 3agA5X2k7ScGlIgq1lZDfYYapJ72j33fRefmM+qS9HBTNlNKUqxsfIeI5Wf2cVnpe9Wkv
	 W9JXeOLZ+KHQoXemCNmbcwr1/4CnDgrswmXW2pW9DLp9dzObnbnfx5rqYSu54ljaDY0sh
	 U6FctnnqfxBHxWjewY6ac/gg0yiqmD41c8LLigh5IFKxC4M1eOa/yRBEOGHjTSF8rqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=V4+rbdEK;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9EF606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B9EF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=V4+rbdEK
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so438273a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794222; x=1794399022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nFPX2ljdfYklFs741hM8uS3dFgbuoJMTx95Uqu2YaiM=;
        b=UmnHcLJtn4rSphORn2cmwSQcBiLIju7g/9AH7oTurvQr0xSnrkX7WwQPwRtnQaKbTo
         hM9QckBr7DaQJXBFoZWc0fniqaAYRlZdRAobtxTqEUnsJLS3nkOVWZAYo1ZcvdmieeIL
         lRN1JjE07UZaF1TnZIPFvDkmR+0Q7QwQUN8cQr8OrrZcZQqYZ0b6F8Jyivup63MR/sTI
         CdUOBujmw7KXNNWqSC3vJN6UKm26pyltowegngf/KkWQjMF+xBB5eUOAoRgp+XlTYI9c
         wWnCJt27J1iIGsfrBCnLLFdBGN2QJ7nJmEmgcNypBk3kC9Rdxt0M0djTQYtmCZJBL+RA
         OHlQ==
X-Gm-Message-State: APuU4Z+ahDDd4BAyzI5gpGuBiMoQz9VyjD5QeHZWl7CLVq6F4pbZV/Qw
	mi6KDJRKzmlLHEGRv4xP8hqEtj8x4HHDhrVXLXm7LJOqizCIP73jpBoWu0qe4Ukl76dEIgXeaWL
	fwK6bXbe1ZWhKcqRElcyBPM2QXgCB86WA7ETcZuU9dJn3Wr3J6WML2Kutqth+FBd+f4IBY6ERLt
	s4cnop15+UNX2Y8D+3/sVPtGJgsmDHd1168HQLDGmrL3RbmCKjhcLBZopFK5dO8EAqzzFWiJ54j
	qiBMR9J64acXhVM
X-Gm-Gg: AYBFou1Qh7I3tUVc0NwxEWF/Xx4iJLaK6MMPqZ836aTf1B2Txh0QstQ+NyQIR2sF7kh
	9EhZVT89YhyhmgVodUj/cTc6gA6P2E0TT9d8Ktz8Mr1LY2ypo5lAd497v3+LJ6WjrlRI/WqTgfO
	VIDcKfJ6zky6Tnx5K1s+B9Gi2LmihtoKDwELeLVPnQENwr07yO9jcU8ccBsQZYA6JbDk1cBJ8G8
	thI8SgIaMs9fZe87OiN52bUXNWjsNW7Bb85Up8uWZ8vYsipZbbja4DhqUKIcJ+6fimv5k2Ip+AF
	D3p05tRa9KqkM+8AnGyU6vR+1NG7po1v3UH5pcMU1y/JTgsUNP+8zODlZERqPu0hClhBgtrBZwA
	fsPEABHzZd4O2ocIx2yi/3riyx1nQWv2tPNxd02BPkd9P3ftoBnW1+yd9YcWZ+hPNav9YU79KGe
	qlGB3XHDqF83igIt7xWXKHx3InBsgVR7x9+Gs=
X-Received: by 2002:a17:90b:4a83:b0:3ad:b86d:dbad with SMTP id 98e67ed59e1d1-3ae89747e27mr12823945a91.30.1793794221565;
        Wed, 04 Nov 2026 04:10:21 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07ca36545sm3838009a91.5.2026.11.04.04.10.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:21 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so766686a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794220; x=1794399020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nFPX2ljdfYklFs741hM8uS3dFgbuoJMTx95Uqu2YaiM=;
        b=V4+rbdEKYYXVrfAs/RI/b05MdMItguJ6u3hmNrtFtPpUMj73/I5dHMSObcCzOnbWV0
         t63Ti0hSui6J55ylzF2V8HJLJIP8A3728AhaYYBB6K6LaEcHdIdWV/c/u2+lloyreGY3
         insOfFvKlUs6YxWR/dA2bDtcwYPTEvQq7LgvM=
X-Received: by 2002:a17:90b:1e47:b0:3b0:a651:a7c3 with SMTP id 98e67ed59e1d1-3b0a651a96emr384253a91.43.1793794219624;
        Wed, 04 Nov 2026 04:10:19 -0800 (PST)
X-Received: by 2002:a17:90b:1e47:b0:3b0:a651:a7c3 with SMTP id 98e67ed59e1d1-3b0a651a96emr384208a91.43.1793794218886;
        Wed, 04 Nov 2026 04:10:18 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:18 -0800 (PST)
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
Subject: [PATCH 10/21] scsi: mpi3mr: Fix target device reference leaks
Date: Wed,  4 Nov 2026 17:30:51 +0530
Message-ID: <20261104120103.503871-11-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
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

