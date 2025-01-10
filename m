Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3519320B200;
	Fri, 10 Jan 2025 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500698; cv=none; b=C3YOUqooPIK3pAWtWqGek0P8yO2YAfQOnbDuEqR8ROA9G8d5SOLeKaIidoDuF1B5sPOlFJ9YN+agWgCDxeuSB8/H4MfRj4X1rxqvX+AqdqKjFlnLPWvKpUUN5SwL+cIVipwcYAySZspV6IsGtdN/fkyb6B6ZmzlOJczl5BqFbPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500698; c=relaxed/simple;
	bh=KW5LX1zGbnQvQHXIUeNOMe/eQV4O1SeF5Hy37NCrzOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SrPNXfwG26WUuMbLJzaMe485mV5zVdJuEkYOUIF082h3UhnzU3l312GdtkxSPYrOmZPbZdtvMjr2+UJVGre06yfC3PjDjQIRmNxUz5bCOYM7TcpfNzO45GiUxzGp40aRdXc3mL83WUcAOFR/Kh8PiAJt+UC7JlRZqp7/BXGeCTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=eIcYGgnu; arc=none smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="eIcYGgnu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1692; q=dns/txt; s=iport;
  t=1736500696; x=1737710296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NmUQn/0Lj+0XkDIiXo8FmxPSbVmVgdgXddxdnuCPz0Q=;
  b=eIcYGgnuXXUqVc7DQYB8LRG4gfCP8c0PUgo2tK0Y9uX5yBctB56iUZx8
   1i49D5JhU9WdyFbazdZu+KBGTLA6dwBB1QAmllLU2bV9ksw8pUNdmrqxf
   1wuDnBuksTew6Vyy82six5KLHJ80tcwdOMCjFed36coU2xbatOut/6R9R
   I=;
X-CSE-ConnectionGUID: 8w7pkwCwRaiIQLxrEzCtrw==
X-CSE-MsgGUID: VqkqzxN4SO2vURauyx7q8g==
X-IPAS-Result: =?us-ascii?q?A0AjAQA35YBnj4r/Ja1aH4I9hBpDGS+0XoElA1YPAQEBD?=
 =?us-ascii?q?0QEAQGFB4p2AiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?RQBAQEBAQE5BUmGCIZdKwsBRoFQgwGCZQOzNoF5M4EB3jOBbYFIjUqFZycVB?=
 =?us-ascii?q?oFJRIQOb4FSgz6FdwSHaJ5KSIEhA1ksAVUTDQoLBwWBcwM4DAswFTWBGnuCR?=
 =?us-ascii?q?mlJNwINAjWCHnyCK4RchEeEVoVlgheFeEADCxgNSBEsNxQbBj5uB5sbPINwe?=
 =?us-ascii?q?wkKgkCTSZInoQOEJaFGGjOqUgGYfKktgWc6gVszGggbFYMiUhkPjjq8HyUyP?=
 =?us-ascii?q?AIHCwEBAwmGS4pTAQE?=
IronPort-Data: A9a23:FyP6GKIDA1MLCNHIFE+RJZUlxSXFcZb7ZxGr2PjKsXjdYENS0zIDy
 WUWDGvXM/+MM2OkKdEkPNvno00FsZTQyYRgS1Ad+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCea/kr1WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrX0
 T/Oi5eHYgL9gmcsajt8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN0+Ex4uPpIz5dx+AEB30
 ewCBSImcgqc0rfeLLKTEoGAh+w5J8XteYdasXZ6wHSBVLAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2N0Sojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjOG1boKKKoTRLSlTtniBp
 XvU70KlOTZAKuGlwCeU4i211uCayEsXX6pJSeXnraQ16LGJ/UQfARtQXlKhufS/lkOkc9ZeL
 UUO/Wwpt6da3E6mTNPVWxy+vW7CvxQZHdFXFoUS7QiX1qvSpR6UGmUeVTNHQNs8vcQySHoh0
 Vrht9foAyF/9b6YU3SQ8p+Koj6ofysYN2kPYWkDVwRty93ippwjywnEVddLDqG4lJv2FCv2z
 jTMqzIx74j/luYR3Km9uFSCiDW2q92RF0g+5x7cWSSu6QYRiJOZi5KAuUeE9fVfB5mjR1igh
 VwUgeWMx/wUEsTY/MCSe9klELas7veDFTTTh19zApUsnwhBHVb9Jui8Bxkgfy9U3tY4RNP/X
 KPEVepsCH5v0JmCMPQfj2GZUphCIU3c+TLNDa+8gj1mOccZSeN/1HsyDXN8JVzFnkk2ir0YM
 pyGa8uqBntyIf04l2TqG7hAjeN3mHBWKYbvqXbTkkvPPV22OS/9dFv5GAHUBgzExPre+VyLr
 4Y32zWilEUHCraWjtbrHX47dg1SciNhWvgaWuRcd/WIJUJ9CXo9BvrKibIncMoNokimvrmgw
 51JYWcBkACXrSSecW2iMykzAJuxBswXhSxgYkQR0aOAhyNLSZyx950Wa5ZfVeBhrISPO9YoF
 KFdI61tw51nFlz6xtjqRcKk89U6LEj021nm0ujMSGFXQqOMjjfhorfMFjYDPgFeZsZrnaPSe
 4Gd6z4=
IronPort-HdrOrdr: A9a23:ysB0261IrtCphRM3lZfnCAqjBIEkLtp133Aq2lEZdPWaSKClfq
 eV7ZYmPHDP5gr5NEtLpTniAtjifZq/z/9ICOAqVN/IYOCMggSVxe9ZgLfK8nnJBzD++ulB1a
 1pbqRyTOHrAUMSt7ee3ODBKbYdKB3tytHOuQ8YpE0dKT1XVw==
X-Talos-CUID: 9a23:5TWkAm5erTWX6+Kf99sspFFLAsM6WWLnxXbxGmuoE0t7Y6GPVgrF
X-Talos-MUID: =?us-ascii?q?9a23=3AKp3dQA8D4XeY6kvrIdGW2VyQf/lx4L28GGZRqrJ?=
 =?us-ascii?q?cpfS+PDFhK2iE3DviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,303,1728950400"; 
   d="scan'208";a="410607803"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:17:56 +0000
Received: from fedora.cisco.com (unknown [10.188.32.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id 1DDA218000295;
	Fri, 10 Jan 2025 09:17:55 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] scsi: fnic: Return appropriate error code for mem alloc failure
Date: Fri, 10 Jan 2025 01:17:46 -0800
Message-ID: <20250110091746.17671-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.32.212, [10.188.32.212]
X-Outbound-Node: rcdn-l-core-01.cisco.com

Return appropriate error code from fnic_probe when memory create slab
pool fails. Fix bug report.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index b5dca8e7e2e4..d366cbca04d5 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -888,24 +888,32 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
-	if (!pool)
+	if (!pool) {
+		err = -ENOMEM;
 		goto err_out_free_resources;
+	}
 	fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] = pool;
 
 	pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
-	if (!pool)
+	if (!pool) {
+		err = -ENOMEM;
 		goto err_out_free_dflt_pool;
+	}
 	fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX] = pool;
 
 	pool = mempool_create_slab_pool(FDLS_MIN_FRAMES, fdls_frame_cache);
-	if (!pool)
+	if (!pool) {
+		err = -ENOMEM;
 		goto err_out_fdls_frame_pool;
+	}
 	fnic->frame_pool = pool;
 
 	pool = mempool_create_slab_pool(FDLS_MIN_FRAME_ELEM,
 						fdls_frame_elem_cache);
-	if (!pool)
+	if (!pool) {
+		err = -ENOMEM;
 		goto err_out_fdls_frame_elem_pool;
+	}
 	fnic->frame_elem_pool = pool;
 
 	/* setup vlan config, hw inserts vlan header */
-- 
2.47.1

