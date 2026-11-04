Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794235;
	b=Casoq9KRdsMo0Ips2zpPROCISLGJKRFI5dFktER5lqaJ8tvf6rtMVW7/9gO7LLYGmbeR
	 G+OyNLttQEFmnz3yr7JbqwatvFtb7M3WR8gopUbfSubbyXiNysgm/XvhB19fmcYObreQC
	 2Y3rmNhkdUizeqKIssn+OvtBJ73y2zwtaFX4UtbgbTWQJ9OJRW1F8MJnbEIQrQFqjtEWz
	 2Dsi6YVajnymS2ETiyEER+NQ/8SXtboVKDqVuz30ueNvvs3rHMO+l4UwEraUmDmtRH4t0
	 i53D3xoUIDclEZc5wDC3Dyu0qth99QPP66XFx9OaMQHzekKNDwZCD13nh4vtXnD6Dww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794235;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=cX3RJ3lczZMpwzQnXoneBQZZ6SSE5cGoZd2UZFTipl4=;
	b=Lm6kPogmz/nih/DD3iXRJwxtmkZkSSA4c8zQgJbCjwwbK0kBDZMEb9O9nwgiIKkFFdG2
	 n/g9ZP8SeSfgTbRcxF2TFlr+WMne/VmMHtUyFYQ7Xq8Akx9C06Qla9ad1k+lelcCTt4aj
	 ENZ/vd/86c8IFRTj8A69V83a/5vJe3mfeNUL9d6OK9KBU+iWRfl43mZoK3nVEohdTBa7M
	 DHNVlwF2Q5X3mT9K+LLuOAmgtxqou99NPcviYm98hrygJYIF7KDnaBFbxOrCWMc5KkDW/
	 qQrUuPYuweGmL+ROuLKzcyRtqO1Gcf6mee0smAuGsjsz+CddaHYSYVsRzrXZ02ob0RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BO3sQ2AU;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5BF606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD5BF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BO3sQ2AU
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1110105a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794234; x=1794399034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cX3RJ3lczZMpwzQnXoneBQZZ6SSE5cGoZd2UZFTipl4=;
        b=jIQb5rpyEj9ZRc89SJ4Ix3a0pkPDAnquNHmJF71kolkx7pA/ZJtWSsrNiVxrb1ggy/
         I96Kd4Ghr3GpIeyiHttJ3ie+q/n5lUVVbDD+00KZo/EOnLUoQkEiqEatenmrLEkEvQv+
         ZXncKHNGd65MIZsMtZZ9Aa3yum4olGva0nu69V4ftgx1Co7zNceJ7US5ZAuBB4msWKEo
         Yk4bHEs852kC3/cbp7qtYJDBhvv08Q6dSd4Z+rVmJs7RaBL4hjsxYv/gYsQ6zSd17nap
         L4mIsPG8KBhHb9gdS+7mjLCOZWgcZJrP+9d8QAzFnrj7MCmAAwOhFzNMfa7C2cq5Ryuj
         HJHQ==
X-Gm-Message-State: APuU4Z8ZShySKxXqEhJ0l5HwvW7MvxUvqWu1MqtiNqgcNOy/p8b6jVQq
	+Ud9viblEea/KsxBm18u9J+8KFlFzI/ccbmOR9ZgbgHdT6Z66VE1bst4PlDRfXcyY9xoP/4nPI6
	KkSOKSeZETQjDdD1H4LLyRdSy0hK8d+IBe7VtjrNXj9e1jDzgiFE9dH7clC5TfeDxQfA18SA9uK
	eLQ2NowIR8eXICOGK65JQkCivT4YopdPb4SrKNoHMUta7GOH6wcOgJ+hHIS2Q90lFFXUsu8nfcD
	cyvHkNMNTPk48PJ
X-Gm-Gg: AYBFou3sYZfaeiUHBZ5Q+neokYSDGBcI8hgBNEATTkz2vlQ6gjUNBCPOBMXwnegYJwx
	rL35/+dauhpPrsAMXw6PBv3q91NppfZ0xjliAjO/gZMuO3euv7nd+c2e7qVAFU1t94pecwi1WKT
	IT+WGCP+qRhxvW07Fa0JwtgjUoPcBIDZlfOnGp5LCwolvBfVEUvsTj9L8raVN75hd2ujnsd1ZAz
	jaGCS64JoG9hMS2S3YLWPhUVhZfZg4m2ghLSh0PoNEVi4dtOwdZCfcTaAGXwLBJuTh+c4uOo0aj
	c252MHdpSswdlfEBDRGmrOfcbojyXSeqvTJsg/yrsGBfI8kpXz5EOnb6KDHIbYgCVV5VDG19v+m
	T/knCj4EoUVWaTsy6CBam4VAjWVV4pV+oNjk40YJg9/bPp+zY8imtDiOtUiQ4unaVn8y9NmmgPv
	i98Pm9DUDFLX2Jxi8/Lv/2NHsTRNe141ijQh8=
X-Received: by 2002:a17:90b:1c0f:b0:3ac:a6a5:5757 with SMTP id 98e67ed59e1d1-3ae896d7df6mr8700107a91.11.1793794233710;
        Wed, 04 Nov 2026 04:10:33 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07cab84edsm3838824a91.7.2026.11.04.04.10.33
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:33 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1ab289bb41eso549289c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794232; x=1794399032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cX3RJ3lczZMpwzQnXoneBQZZ6SSE5cGoZd2UZFTipl4=;
        b=BO3sQ2AUq4s0RP9Lq4vbjSNkZUyzuQAJJmYjqJTfQ9odwSTaDLZKKKrJfqvRzp/JsI
         G+oB8XBJD086ocbresjb9YV1qoYZPYlD7UtuSUe28iSB+B/7UNB7Gz85JjTuHfXUiBGT
         Y3rGHG5j5H3Av1mMLu0LMI4JaoSBkf3tshPzU=
X-Received: by 2002:a05:701a:ca8a:b0:1af:194e:8264 with SMTP id a92af1059eb24-1af194e82e0mr19413348c88.22.1793794231779;
        Wed, 04 Nov 2026 04:10:31 -0800 (PST)
X-Received: by 2002:a05:701a:ca8a:b0:1af:194e:8264 with SMTP id a92af1059eb24-1af194e82e0mr19413320c88.22.1793794231008;
        Wed, 04 Nov 2026 04:10:31 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:30 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH 13/21] scsi: mpi3mr: Fix the lowest phy number for phys 32 and above
Date: Wed,  4 Nov 2026 17:30:54 +0530
Message-ID: <20261104120103.503871-14-ranjan.kumar@broadcom.com>
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

The phy mask is 64 bits wide but the lowest phy of a port is found with a
call that takes a 32 bit value, so only the low 32 bits of the mask are
looked at. For a port with only phys 32 and above the lowest phy comes out
as -1.

Find the lowest phy in the whole mask.

Fixes: cb5b60894602 ("scsi: mpi3mr: Increase maximum number of PHYs to 64 from 32")
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index ecf312f007dc..87f2e1841ce3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -587,6 +587,17 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
 	return rc;
 }
 
+/**
+ * mpi3mr_lowest_phy - Get the lowest phy number in a phy mask
+ * @phy_mask: Phy mask of the port
+ *
+ * Return: The lowest phy number, or -1 if the mask is empty.
+ */
+static int mpi3mr_lowest_phy(u64 phy_mask)
+{
+	return phy_mask ? __ffs64(phy_mask) : -1;
+}
+
 /**
  * mpi3mr_delete_sas_phy - Remove a single phy from port
  * @mrioc: Adapter instance reference
@@ -613,7 +624,7 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 		mr_sas_port->phy_mask &= ~BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+			mr_sas_port->lowest_phy = mpi3mr_lowest_phy(mr_sas_port->phy_mask);
 	}
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
@@ -644,7 +655,7 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 		mr_sas_port->phy_mask |= BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+			mr_sas_port->lowest_phy = mpi3mr_lowest_phy(mr_sas_port->phy_mask);
 	}
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
@@ -1427,7 +1438,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (mr_sas_node->host_node)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+		mr_sas_port->lowest_phy = mpi3mr_lowest_phy(mr_sas_port->phy_mask);
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
-- 
2.47.3

