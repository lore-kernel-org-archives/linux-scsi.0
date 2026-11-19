Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072787;
	b=adPodsj25TiYAYeR1P4rfdJxh8iU4bzWnier5ysU0wrgOAQ0u8alUyxxCCt4c616Cf9Q
	 VwndLxA8P1IXw52U1cj0wpnTylq5ympuhUtvSSyR4TqMHgmv8zfi/HfXyXX46ZK9sSDUN
	 +3g6pF4iOs/LYRiJG+uYt2mhAtstHdt2kc07AmwJ23ZdBv17mNOfHFNQZgcmhVkBVkafS
	 51FGo8/Oql/QWpZp8OKy1rVJnS6nnhHuQgl94Y16Bep1UCSqxfaoCeTjc9lKhds8Wu75Z
	 yQ5CXML6IECext3OB9vyoQseGdCZF8xIvbFzVjYN3oQrUIhXDdQYCTTKkpKSH3TL+9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072787;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=ACJE6elMxceHVzZn1k9zK6i2IYtdR8aPLXR3UFyqycM=;
	b=KXZciogalICtLE7RZutYPn5lP/vzvDHXJwJl8vzrwu42R50w090VijJqUl89AP3L9cJO
	 VE1WlKksyb2H0yvv4nJarp6yPFQcKFlzHu3jiA0QyH8S6/dANaIFCRmN1R+DQ8px/R6hz
	 gzG7yz+TT8WhDZ6hWD7FLvCN+AaCiDyzS6gDXQ1w5Jz410ShoY1/oDMrEiY+8dXGMw+Yh
	 bOBP4eHKz+bWvWZ7TacK0D6uW3lguxq1M69jTFWZfJz1sdV65+zYrBOrhr4sRZ4fzAY5E
	 P3V7KusmeHHVl9TRUWyD9NhhcHvFwfnhdD8JX7PcEDxdppmon14pP2ngAnyUX5nE0sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=enYDdw6+;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB6606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEDB6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=enYDdw6+
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso967625a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072786; x=1795677586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ACJE6elMxceHVzZn1k9zK6i2IYtdR8aPLXR3UFyqycM=;
        b=Q2Nya7b7V3nYIUNrDeqKapZDwvzfLrAhdbE5+H+K6Az+7buEvA4BSHKV0nvmhU9wAR
         SaSd+oS1OA67EjhovR9HiiENo3PSQhqP7+39B8lDlerSoucXtA6Nb9zaVDkMDTrefxPb
         hroVmiXTPMYj02GR33s0h/0tei0fNTT/548lJfbHtGeEQew3ugnGeoGyV8Kojgrs/wYV
         tT+8nJMveck0V4TIFQpZ8ZpYR8AD1WDL/PW3cG/hv30NbXzGp6cRVOZ0fUAy/gb1IW/o
         CNUKX3uQBu517rH2wRLIpjLIyvHAyMzXApHdxBIFmrce+ZyVHqqbZ3IdImS3Vr8lkIzw
         N+lg==
X-Gm-Message-State: APuU4Z8ZUU3XcQMalCLcKYyhHyV1Ei5NNKboKbBBSt6zHnQcOg6Y67Nk
	JF5fng+WSvgnwZVQlSNQolw8MHMxhnkTLjuiuazKZxUJOuIQ0hKoBffANhrQze41mMG9Pmr2Xdg
	W5f9LNjUXFMK8C6ivSrxlKKyKWBm8dd5myQKm5uRFVhnR75NB3K6+XjHGlVdIRhlBvnIbDio31e
	/WNPfK2dESIk9KkOE0D6lkzJfoBjDoZ4SViXlm09CX0OAqEtFKa0uwueHLpX0+sCBWKc0gH+7/b
	VSV5X637JYWRoFs
X-Gm-Gg: AZFdTZdBRFv3is7j2q77MvBeDZpez9JSAPMCHWgDE28iD57930oQ+9MKU8MezT0tE8i
	HnDFiex1bJsG+n0WPGMiVLRu3wd8sjZtFgPb2OREEKlxeiqes+WAXRT1F1HjXT2FUv9gqVDvW3/
	4oqoBtZr2PYdHGBjjKYkiu9W8PsW60slFn6sDRa6Cg1HfJB/4lWMFRPDPd6qkh4BOLW2zz1QcPa
	RoZ8/BfDbBHqCod6WZ8ngIn7IDFADpBs65pbqtaTmTWGJ7PDdxQlcn0PkyZ+KVllFzoirJS/QwA
	EyDfeRtTlZvr719ZfjTnppQsvzV8pswpQ8Vihx9sUv6w/aj9mXnEVG2QsPaHNk/vOldGYjCzQnU
	21G1E+d1Dg4phyGU+JrV9tM/+MY1JLkW8Fr/Xwc4gDEIjv6Rqnp0QIBjjTwC7icvEU7YNGEsRwa
	gPAATlNbm785CEyZ/TXkLLQBku+Ukm/fuzBb8=
X-Received: by 2002:a17:90b:398d:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3b3d07d4738mr5477254a91.49.1795072786042;
        Wed, 18 Nov 2026 23:19:46 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405960cd1sm488367a91.2.2026.11.18.23.19.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:46 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so1457657a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072784; x=1795677584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ACJE6elMxceHVzZn1k9zK6i2IYtdR8aPLXR3UFyqycM=;
        b=enYDdw6+cRFoUS28QUjdu/EpXVunze8MSVpGEBZ5aqG0ahumT/JvbFscG/dHd+Ld3r
         WXhloFDohoq6/LJE037MI1nRu8gRz1epConTa8neO8TGszyRBksXdV9orQ5RZS9qw433
         K6Hv4vVHLM5DJKZF6anMRu8co16v6WkZ7Tgys=
X-Received: by 2002:a17:90a:c106:b0:3b0:9fbf:894c with SMTP id 98e67ed59e1d1-3b3d079ff6fmr4979970a91.17.1795072784299;
        Wed, 18 Nov 2026 23:19:44 -0800 (PST)
X-Received: by 2002:a17:90a:c106:b0:3b0:9fbf:894c with SMTP id 98e67ed59e1d1-3b3d079ff6fmr4979958a91.17.1795072783761;
        Wed, 18 Nov 2026 23:19:43 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:43 -0800 (PST)
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
Subject: [PATCH v2 11/20] scsi: mpi3mr: Fix the 32 bit shift when building the phy mask
Date: Thu, 19 Nov 2026 12:41:23 +0530
Message-ID: <20261119071133.127282-12-ranjan.kumar@broadcom.com>
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

