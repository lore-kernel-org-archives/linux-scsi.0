Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C5319A;
	Thu, 12 Jun 2025 00:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749689080; cv=none; b=f1z624tdD3/Wi2GnCPO2HcAdPzGPCzxiiF5AmAJdJOlI3ipr+8j20BCLDapzsDQk46vQC/MukdDUhWx8keXn4vn3XQFejYHRhrGQBGVtGGuLy0jSpKXcI1b2mUYJVMRi/ZHo0sy9el/sBR7wPNkr07/fHgqN6X2YYRTyt1t5hTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749689080; c=relaxed/simple;
	bh=MnCr9OEVlQ7GknTARTds4npHpQMQRi/DiitUYHLyMJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k7U4/AUq/9BUBpgY52VnNWOT5qQFDmY7eyC+2/v4mvS4HKsA8P0yW7ad+NDaPUm3u+ygUXEJObSHUtd/hT5njG9lmE02nN3+uKo3f5r5epo7LvZyrGvL3Jkl8xrQSvts6UuHASIQpYA5vm0hvoIRa64vxCfgeztZtkEsARJ7QzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=HX6AVwk6; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="HX6AVwk6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=980; q=dns/txt;
  s=iport01; t=1749689079; x=1750898679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JPGvyzDxmu2hP40yELBEjF/T5i9eYvf8QiI2IbJNsD0=;
  b=HX6AVwk6DK1NwxCV0qVXkDh/o9xrqGXXGGJdz4z0sXigJ99NkPIPQdoP
   le9ndS+CZ1NPHKOWlFJH+H9VfteFiEsObuWZlb848C6oF01hUb1y9cv3k
   g4NBZW/yvx9t2mO39Tm+4DPvwe3V9wIiTdnZRyCQg9sfY/APZaEwL1u+D
   lS4M6jXZwc0BDBcq7T0Tx1jnnq4bpFe2yBMbZ7X8ARwvQ5rLSFLc2ROKZ
   8jgjnz79qv1HUJWAZhnmKvudyp/3RQOqgAMS21N6VQMYWDpjBCHR50UkS
   Zh4p7rQZ935f+lUt8YkTVfBuMmHA3I3BDhPPOaSBg1MiEtH8sfW86Y8xr
   g==;
X-CSE-ConnectionGUID: 4Fi0DSYRTlymudt4lCBKJg==
X-CSE-MsgGUID: o96KS16SSpKBxpRrQjpz4w==
X-IPAS-Result: =?us-ascii?q?A0AnAAAMIkpo/5IQJK1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB4toAiY0CQ4BAgQBA?=
 =?us-ascii?q?QEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhl0rCwFGgVCDAoJvA?=
 =?us-ascii?q?7AOgXkzgQHeN4FugUkBjUxwhHcnFQaBSUSCUIE+b4FSgjiBBoV3BIMmFKEeS?=
 =?us-ascii?q?IEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEoQphl6ESStPhSGFBSRyD?=
 =?us-ascii?q?wdKQAMLGA1IESw3FBsGPm4HmAuDcIEOgQKBPqYAoQuEJaFTGjOqYZkEqTiBa?=
 =?us-ascii?q?DyBWTMaCBsVgyJSGQ+OLRa7VSYyPAIHCwEBAwmQF4F9AQE?=
IronPort-Data: A9a23:U5lSdqqzbFFjDxe/3oAud7A+SqteBmLIZBIvgKrLsJaIsI4StFCzt
 garIBmGaKqDajajL4p0O9i28BxVuJOAydJmTAtr/i83QnsS9+PIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9z8ljPvgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQHNNwJcaDpOtvrd8Uo355wehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0rpZADliz
 s0iFDQcaw2Pm76y65iYaOY506zPLOGzVG8eknhkyTecCbMtRorOBv2bo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtJYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofaFJgLxhvB+
 Qoq+Uz+U085D4XB8gGd0Vi8ntXVpCHjSt4NQejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBBzlitrCaSXO17LqYrTqufyMSKAcqfyIaQBEey8PurIE6klTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRLt1VXGIu
 HwC3szb5+cUANTVxWqGQf4GG/ei4PPt3CDgvGOD1qIJr1yFk0NPt6gMiN2iDC+F6vo5RAI=
IronPort-HdrOrdr: A9a23:9GIAR6l2I/Nh6QSqaz0mcqXxe8HpDfIf3DAbv31ZSRFFG/FwWf
 rDoB19726XtN9/Yh8dcLy7UpVoIkmslqKdg7NxAV7KZmCP01dAR7sM0WKN+VDdMhy73vJB1K
 tmbqh1AMD9ABxHl8rgiTPIdurIuOPmzEht7t2uqEuEimpRGsVd0zs=
X-Talos-CUID: =?us-ascii?q?9a23=3ATp5HCmsXu8V3XYe82eblW3es6It5XHyF4EzhGXO?=
 =?us-ascii?q?8GGN0RKHJTXS624Frxp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AYjAzzg+69yncBe9mMpYmsliQf8A5vYeVUR42qo0?=
 =?us-ascii?q?lkdmcDzZJOS+P0CviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="389560517"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:44:38 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 80CB718000443;
	Thu, 12 Jun 2025 00:44:36 +0000 (GMT)
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
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v3 1/5] scsi: fnic: Set appropriate logging level for log message
Date: Wed, 11 Jun 2025 17:44:22 -0700
Message-ID: <20250612004426.4661-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-09.cisco.com

Replace KERN_INFO with KERN_DEBUG for a log message.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 7133b254cbe4..75b29a018d1f 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1046,7 +1046,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		if (icmnd_cmpl->scsi_status == SAM_STAT_TASK_SET_FULL)
 			atomic64_inc(&fnic_stats->misc_stats.queue_fulls);
 
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"xfer_len: %llu", xfer_len);
 		break;
 
-- 
2.47.1

