Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996721;
	b=V4+5D+UkqodWFo+qrcIct6wT+3Y12y6VeU9tGx5aRqz5xctouq9A0ClYNlbkYniczk96
	 IjFE7IpicDtXx1wBx+8anjk5T+Wneovcm4KcXS5KijIs4VsZ3qm6Sss4GKDGFsckGuHXD
	 xammWGE8ZXjCzCu6j2Tjnpy/X7JQNqOP8NAHmpyCsHoo9S/yuzWmHrTfYT+BVs5PUtYW4
	 ZKkqA7ZiR36zoPzd9kQnY3IYmfJw0wQZ/z7uGRdLyTvlLf7tT4s4v/Z45XPc4HzM0TlBC
	 Yz7m1TLGKjMjObHz4xmyyX6IAXtYsfWuiSEnUZs8UGkaLUTM2VheoQHCER1asD0qRzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996721;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=VtNhr4q/j06OnSORtRAK87peu15jl1iaLeFvy65N+FI=;
	b=ACpwEjzqv8pTweUepAYXVyrucH0DIwZ5QR6FLfGK6SO1SjdpQD5OUEQaVYpyDTjYOQZ/
	 TP+8fUQs4sgF8j79i4L4nDmrIhxCBeL/BGcl9Jt5rK0tFMZLYyPGDFjhxDSUwmVJHytHq
	 ysHRORmoCz1W6Xq1DYKG52qI8qohTyQ3wVf+B2M68jOyTpCrdALZyWyz8qxyijyUnZ8iV
	 RoazrNJQhLs0AloWXrzrfyGdWFoMoyvrM8VludI7jJhg3qUHrJkVWRWqef9FYFdIAQ275
	 BgqR9edSUIjfwtHni+k2szS/oIzDA48FJkAzUH4b55UcrZvP4+Sn8qvJHJ4lI28Vpqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VuEUeFLi;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348E2606A320
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 348E2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VuEUeFLi
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso403638a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996720; x=1795601520;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VtNhr4q/j06OnSORtRAK87peu15jl1iaLeFvy65N+FI=;
        b=zNFeIqiNLX62V/uAv5kUttaHD+U716GSv0Oba+w4wYpAEljgTL+izEhugd45wNqibM
         jAmWuskcEVjtKDTt209b/WsrUvQhibnYEFFhVukm+3mfrqKm96FHFW7xlBaSBNysEaBP
         oTUpWuCt6hSpcKaCs5SMBA8OEVLtLvkW/780jnUYUI60pNdsEvbVAw39w1GQt+QeTUOj
         z+3RhYj98BzAbqCqkUgQtOtV/F3VIK4vZr3gYDrvAXnPvwT76yzeuycVVtJ0swTZ+LWT
         OS8u70AvS8pNrwNA+TUnX4TCKOriVzpr1M4A+SLMKySP4BrWcth3FHG2jApYZPinhb0q
         bchg==
X-Gm-Message-State: APuU4Z+XsVsNLTLwLgFn3yPvW9goNpn3ocy7IZKr2EbNRaMMYCUkt2+K
	tZSgaRwRKUw1FdvX483T+hrFKmbo3swsnAYEYNWiJLJ3Pa+uFhd63KW23k3jpleTzeWwd+ZlVAG
	6cyhf9Gri+AS8nOk6d3DlNKZO3MDYjHnL94m9iLxTedOpdFqc+e3BT6AGbpkbcv1ltH/MCSxBxV
	CNo7x6d3ChuRnSXHHwnIPOm6hkMjM9TOxA11iD2+z4lo4B0lJkVVdELI+ruwC5bM6TLCYw6/0iN
	mZ8wi9im3RFvOsyTgR2ZOz8lqOKLOsQPn8=
X-Gm-Gg: AZFdTZeSO+HPFQ7o3a5rLklJxo8nfkRhbWGfc9fey4UfYVZkYcl4emk8BjdBwmz1q6D
	bVNuOrhOavmErD95ckPobSRXXz0BzTqWGyFBjAKK02/TDGE/00A++LTQG7R96ftHSH+dT4KJHKN
	ecxyEZhrWlxK1Mj7y5fdQPqNs4zNVHM57Le/jWbPF58xUqCXx/82RzAmu6RdLBFMG+OoHtNgA9O
	u7ceHKQVIzZTb9IX7ezQAse6Wv0QhGQTHCdmUJx0eVHHrfdJLquelU5AftSEJCc0f2OirCSSOIp
	qF0N5MZDUe+JsOs6fm15tjKZP4xo0+rFGlfIGKvU2Yz2cKNAXfM0dfipvE7PTH/wDViU1IwRzAR
	cBh42ra1fwhkyvLha1+8Ot4D+2SNXcZblx7Bpb4gY6MvUEl0SInsQi56JOxavp1MNIDIBv1m+S0
	zhu951ik3snoI9m+xCZ+quamy4OJ6XPOt8bc3yQhbjfPLxifJswVpoCg==
X-Received: by 2002:a17:90b:288c:b0:3b3:b0f4:1bf7 with SMTP id 98e67ed59e1d1-3b3d07598c3mr2175004a91.23.1794996720400;
        Wed, 18 Nov 2026 02:12:00 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1423d6asm1648640a91.4.2026.11.18.02.11.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:00 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd0cf3b1c70so657989a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996719; x=1795601519; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VtNhr4q/j06OnSORtRAK87peu15jl1iaLeFvy65N+FI=;
        b=VuEUeFLixc5y2TBxslWObCuhRi8X/55WguqWdJzvsW02GhJfYViUBYBviYP5TqaWg+
         82a2bezUJ1I0aH0d3huUqozw6k6RYPywNDbD3bPFojw9GiZHt2eq1Kpr8QtEOBukXu17
         11dILY/2+4VVxKqIfLHT2E+oZQoxyL9WLb8No=
X-Received: by 2002:a17:90b:4c4b:b0:3ac:83c1:2bd with SMTP id 98e67ed59e1d1-3b3d0764b26mr2482380a91.28.1794996718608;
        Wed, 18 Nov 2026 02:11:58 -0800 (PST)
X-Received: by 2002:a17:90b:4c4b:b0:3ac:83c1:2bd with SMTP id 98e67ed59e1d1-3b3d0764b26mr2482348a91.28.1794996717983;
        Wed, 18 Nov 2026 02:11:57 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.11.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:11:57 -0800 (PST)
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
Subject: [PATCH v2 01/37] scsi: mpt3sas: Validate firmware-reported IOCRequestFrameSize
Date: Wed, 18 Nov 2026 01:56:10 -0800
Message-Id: <1794995806-5835-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject an IOCFacts-reported request frame size smaller than
Mpi25SCSIIORequest_t, which would otherwise corrupt adjacent memory.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1af25a22611a..aea300f55051 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6296,7 +6296,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	u16 max_sge_elements;
 	u16 chains_needed_per_io;
 	u32 sz, total_sz, reply_post_free_sz, reply_post_free_array_sz;
-	u32 retry_sz;
+	u32 retry_sz, req_sz;
 	u32 rdpq_sz = 0, sense_sz = 0;
 	u16 max_request_credit, nvme_blocks_needed;
 	unsigned short sg_tablesize;
@@ -6371,8 +6371,15 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	 */
 	ioc->hba_queue_depth = max_request_credit + ioc->hi_priority_depth;
 
-	/* request frame size */
-	ioc->request_sz = facts->IOCRequestFrameSize * 4;
+	req_sz = (u32)facts->IOCRequestFrameSize * 4;
+	if (req_sz < offsetof(Mpi25SCSIIORequest_t, SGL) +
+	    2 * sizeof(MPI25_SGE_IO_UNION) || req_sz > U16_MAX) {
+		ioc_err(ioc,
+		    "IOCFacts reported invalid RequestFrameSize (%u bytes)\n",
+		    req_sz);
+		return -EINVAL;
+	}
+	ioc->request_sz = req_sz;
 
 	/* reply frame size */
 	ioc->reply_sz = facts->ReplyFrameSize * 4;
-- 
2.53.0

