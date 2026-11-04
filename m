Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794227;
	b=X5lkdr4pDJ95eFOjDXgiry169haet0ldflxU+bvMx3n4w3dLM7PxstO3KRRqDgkUUJXs
	 1SOiqUYU74pG+MGsKYGT0mPAPrFR9PDonjaUy5QXCXB83OwCh3krrK6XeSVu02fRq3gAP
	 2M2GTbUJLNjdWm06Y/dZpVR6URDO2YLWks7jN9Yi7qyO9RA27BZX67dFT9zFpn/zjKufW
	 7G5aiqi3yV9Z73zjkpEbXgOeUU4TahoQExXONfCjlBBZvZG8cgcDQr2tLTYQ3n9dosbCD
	 vJP22DqzSloGVBRLcS7K9dWr9FhM5FF5ABZ4CkOvaxwskysWnYtLeBKbJDF36ibalNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794227;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=ACJE6elMxceHVzZn1k9zK6i2IYtdR8aPLXR3UFyqycM=;
	b=h9uGMU2+kQ1Xh6Uyrw+DJDLRPtB6diCm2UjCZYrJk2GV7Jj13Aq47hcCm5v37UaiGsr5
	 Jvk9fUFKbnkfKFLleGYoAT6KJXOcGnKnrid8QTqaTjhy/abKDjg8+0Y86XZh+49NTFHJN
	 dCnwZxwjCNTEMujhx3Nty8vq77kRxQtXJcxxHGUJsyitapY/CPit7lmlKsHSgQLGSbc9Z
	 tGRAAzkWMQzL8KkaXvg++BR//yp0XlIO3nL3zx9KuaCQZbVo8CJPpBllTR07dyZBMl8sP
	 6FKplAH/jFkMBZDt6YWmzJcn4iGOoZjUtXb5x7WE7fd/nnAF/AyyLyPT96dCVqBqKpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PHnKJbqI;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F90606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2F90606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PHnKJbqI
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso228978a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794226; x=1794399026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ACJE6elMxceHVzZn1k9zK6i2IYtdR8aPLXR3UFyqycM=;
        b=TK6RPPz7QRFXgQHRJdQmwMYj15YCEIOLeM/Oq2IuQWSR1BqLg77sTdK15AlktD4WC8
         qyt5JqddIKoP9OBMJjvegBmkRSX+tINJeihjN3boLytGyaYj2yq9JDNfXv0WsGWqR69F
         O3YjmkHUC//AzjlkeM3klZRf4rRHY+mHOil7zI8NtxA2mBFahmqMOcC1Gwt1XhPB/Cwz
         OvyfsqyF7SIbOXIRO3f14MKd2UCWwldYMGbUdcNkWBPqbukdJZxzEyGIrkl9KNWgZeYi
         NGu4LgQDeFbPhtIm6bB6mMd399+ZPmfRVIJyMbp+ZYgTeS+NjqODmZnaweIjAWaLAtqi
         L7Ug==
X-Gm-Message-State: APuU4Z+3c2A939mVGn8NZ9HIAJXTqbok/Hu663IXia40iTPcDXRvIEPT
	1r53Mw1ouIErd2yUKxe9JWp0eExFZ0C8rRiJZpY+2QCHZKNc3E1KKii6YKcPu4uL0ia2Z94wHWz
	dR6YGAXObCVFwZqO8VoOfMpv3rpqxbqymGA+Zcw43vS6LcCHYmuZMNeUUe6FXdlAOPA5FE4W1X1
	IlfydaQfOOxTv1yfekq9F8MR446Tj0XA5FbbhXPOTJvw6mwRr4afLjjmFbpvL3ydprFq0igDD+H
	ezvHZ70EQJzp8/R
X-Gm-Gg: AYBFou372c2SSbDp9OaMAhnK0qknN4jgoRtpQBegC5Cc9kbHQ6rY7qn0IHcJQk7zdBO
	6fxIT05WnaIb7cfMcH/EPzPV/LgTvyB8B+lDFPBSaq7fCc9dajf1fo/FEVQjJgfeWIO1xW6de+6
	JwniTMcPCUkRoVOW+p3gjqOtVghgtIyj2bVT5HrwMZ5HdyCzKd+HURWlyWfxX5UDTFE68KXFTEA
	ZR8hWPATMuJMhA1o/Ewf4qtC5SmgJ+lr+jlIfaKHdqRmMXyE/J0s5UV8SS1X5TYMpz1xOmN7Qa8
	XPbep4filfp/UfhBZjmBZubKrm/u84Oc30aL0IjipZDanzj/WndudgjO/SJgbkNmS920KT33w/m
	TjMv1lSJ3qbRMW6oFaYse7FjrQt+Izf6nYJszH3nQ2kT2rDglSAqqwWT9VAs3dxZwybLkvVRbV4
	IniYn8zbSetsIsyFrZd6/nY7AqWmm0XT4hoKs=
X-Received: by 2002:a17:90b:4b0c:b0:3b0:9fbf:8951 with SMTP id 98e67ed59e1d1-3b09fbf8dc3mr935713a91.5.1793794225853;
        Wed, 04 Nov 2026 04:10:25 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07ca31151sm3798818a91.6.2026.11.04.04.10.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:25 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1663fb7e005so887419c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794224; x=1794399024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ACJE6elMxceHVzZn1k9zK6i2IYtdR8aPLXR3UFyqycM=;
        b=PHnKJbqIzvlrEBVCdEXYE6PJKNfpDdbCd/u+FYzrAhhUWs09ToWmnZE1ia97CYsR4K
         773PxjWmMFYqzpl3y98U8iOA+Bbq5i3n1Ej0RVQOjEuVy28O/tUDBam9XKvyy66SQQIA
         XKAvJOB7eC/G4nX6DDMdu1RWrmhZrd8uGVJXU=
X-Received: by 2002:a05:701b:4508:10b0:1b2:40be:a929 with SMTP id a92af1059eb24-1b240bea9efmr6369130c88.14.1793794223968;
        Wed, 04 Nov 2026 04:10:23 -0800 (PST)
X-Received: by 2002:a05:701b:4508:10b0:1b2:40be:a929 with SMTP id a92af1059eb24-1b240bea9efmr6369075c88.14.1793794223170;
        Wed, 04 Nov 2026 04:10:23 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:22 -0800 (PST)
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
Subject: [PATCH 11/21] scsi: mpi3mr: Fix the 32 bit shift when building the phy mask
Date: Wed,  4 Nov 2026 17:30:52 +0530
Message-ID: <20261104120103.503871-12-ranjan.kumar@broadcom.com>
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

The phy mask is 64 bits wide but the bit for a phy is built with a 32 bit
shift. For phy numbers 31 and above the result is wrong or undefined, so
the mask gets the wrong bits for those phys.

Build the bit with a 64 bit shift.

Fixes: cb5b60894602 ("scsi: mpi3mr: Increase maximum number of PHYs to 64 from 32")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=12
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=12
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 26dee121bc43..ecf312f007dc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -610,7 +610,7 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 	mr_sas_port->num_phys--;
 
 	if (host_node) {
-		mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
+		mr_sas_port->phy_mask &= ~BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
 			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
@@ -641,7 +641,7 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
 	mr_sas_port->num_phys++;
 	if (host_node) {
-		mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
+		mr_sas_port->phy_mask |= BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
 			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
@@ -1417,7 +1417,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
 		if (mr_sas_node->host_node)
-			mr_sas_port->phy_mask |= (1 << i);
+			mr_sas_port->phy_mask |= BIT_ULL(i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1814,7 +1814,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		found = 0;
 		for (j = 0; j < host_port_count; j++) {
 			if (h_port[j].handle == attached_handle) {
-				h_port[j].phy_mask |= (1 << i);
+				h_port[j].phy_mask |= BIT_ULL(i);
 				found = 1;
 				break;
 			}
@@ -1841,7 +1841,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		port_idx = host_port_count;
 		h_port[port_idx].sas_address = le64_to_cpu(sasinf->sas_address);
 		h_port[port_idx].handle = attached_handle;
-		h_port[port_idx].phy_mask = (1 << i);
+		h_port[port_idx].phy_mask = BIT_ULL(i);
 		h_port[port_idx].iounit_port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
 		h_port[port_idx].lowest_phy = sasinf->phy_num;
 		h_port[port_idx].used = 0;
-- 
2.47.3

