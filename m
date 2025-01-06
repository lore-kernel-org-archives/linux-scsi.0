Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A21E1023;
	Mon,  6 Jan 2025 22:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203612; cv=none; b=ZBwiAfyBmqkeX8Y7vhmcIQ7ghYHfF4p5BUkwBCGKHykxqZOMx90sNA0OnHQTf2P7pn69R9+sVmsxX+dbzar+AlJZs9AuhWdMD8H2JeWyAT0HZLyu1F4/i0hH2U8ERvz2wIvDT3tZ9IawYd1IvYdO2xnvllPgwnPm/mN/bKZ1Yr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203612; c=relaxed/simple;
	bh=T3eoqBxEdsM9eHOp5GWLUU16jZKxAJc2ONLHG3yQQqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUiLNi2EO2IKh+FLSTRzdBU6o+TrNwcfHHnPXIUHj0BIQyRpEgPT2FMLwt4IaI9Ds0qqbhKFLiXJegiMDzuDjJNI/TRvhdz2ABR3Ecddg3fGTAj2jf5nLgSEgdTvcFAoELsIhyh2qu4Gcg5LBCAlMoPBloPHLH/OUzT9OAO9wjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=kDdUldTc; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="kDdUldTc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1413; q=dns/txt; s=iport;
  t=1736203610; x=1737413210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m9SeWd2Cd94o1scMlQR5oXbooM2v106DAHykBUqJ6TY=;
  b=kDdUldTcwepWeDy4MfWbDlR4MRJMf5EN4lRp2ismoT9OX6gxoD2hYdei
   ZIWG8QdYh0tBjsl1nPEjRJhQ67/c1ExB5TphJljHirt8z1G61Uxtff0Yk
   2fIg3lKuNaEL4XoHfDmsCmufq1N75slkIL3GFH8+HK2P056RtHgcmweHt
   A=;
X-CSE-ConnectionGUID: 6sZC6BuNSOOvClutsb3pOg==
X-CSE-MsgGUID: LuDLKqrkRRuRCLsHm8DwhA==
X-IPAS-Result: =?us-ascii?q?A0BAAACGXHxn/4r/Ja1aHAEBAQEBAQcBARIBAQQEAQGCA?=
 =?us-ascii?q?AYBAQsBgkqBT0MZL5ZDnhuBJQNWDwEBAQ9EBAEBhQcCinQCJjUIDgECBAEBA?=
 =?us-ascii?q?QEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGWwIBAycLAUYQUVYZg?=
 =?us-ascii?q?wGCZQOwSYF5M4EB3jOBbYFIAY1JcIR3JxUGgUlEglCBPm+BUoM+hXcEh2ydc?=
 =?us-ascii?q?EiBIQNZLAFVEw0KCwcFgXMDOAwLMBU1gSZEOYJGaUk3Ag0CNYIefIIrhFyER?=
 =?us-ascii?q?4RWhWaCF4RWKkADCxgNSBEsNxQbBj5uB5pkPIJ8coEOQ4FmFgGlcKEDhCWhR?=
 =?us-ascii?q?hozqlOYfKQQN4RmgWkCOIFZMxoIGxU7gmdSGQ+OLRa3VCUyPAIHCwEBAwmRd?=
 =?us-ascii?q?AEB?=
IronPort-Data: A9a23:UwBNMq1zRb9pTKcV3/bD5cJwkn2cJEfYwER7XKvMYLTBsI5bpzVTy
 2UaXGqDOPeDajDzfYt/bovg8ExSv5aDzdVjGgpv3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmE4E/watANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU4
 7sen+WFYAX4g2csbDpOg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGUloEFtMy58BMJkZQ3
 vgFNCsHNQikiLfjqF67YrEEasULNsLnOsYb/3pn1zycVa9gSpHYSKKM7thdtNsyrpkRRrCFO
 IxDNGcpNU+QC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OO1aoWPKoXWHq25mG68u
 07i3H3jASsgKea07SGl9yKAme/myHaTtIU6UefQGuRRqF+exGY7DBwQSEv9oPO8zEW5Xrp3L
 kUO5iso67A/6EGxVdT7dxqiqXWAs1gXXN84O+k77hydj6nZ+QCUAkAaQTNbLt8rrsk7QXotz
 FDht9foAyF/9aaeUnO16LiZt3WxNDITIGtEYjULJTbp+PH5q401yxaKRdF5Hevt15v+GCr7x
 HaBqy1Wa6gvsPPnHp6TpTjv6w9AbLCQJuLpzm07hl6Y0z4=
IronPort-HdrOrdr: A9a23:ShVL8K/JtIZ1cIQ4O4huk+D3I+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/85+oJjsaEp2JKGxCe2CmLnE=
X-Talos-CUID: =?us-ascii?q?9a23=3AltqBb2iVr4oVtxgwsC8uuk+ZIDJuLGbv5yn6Pmm?=
 =?us-ascii?q?DLkF3Y7mIVUSao7tDnJ87?=
X-Talos-MUID: 9a23:ixi64ggogYLs5Yl/3heFA8MpENpEx4e3EkM3q4g8kO2fFSkgFyidpWHi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,293,1728950400"; 
   d="scan'208";a="302728143"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Jan 2025 22:45:41 +0000
Received: from fedora.cisco.com (unknown [10.188.112.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id 5C30A18000299;
	Mon,  6 Jan 2025 22:45:40 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 3/3] scsi: fnic: Remove unnecessary else to fix warning in FDLS FIP
Date: Mon,  6 Jan 2025 14:44:51 -0800
Message-ID: <20250106224451.3597-3-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106224451.3597-1-kartilak@cisco.com>
References: <20250106224451.3597-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.112.101, [10.188.112.101]
X-Outbound-Node: rcdn-l-core-01.cisco.com

Implement review comments from Martin:
    Remove unnecessary else from fip.c to fix a warning.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fip.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index aaf5f768a9bd..7bb85949033f 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -154,16 +154,15 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct fip_header *fiph)
 			vlan->state = FIP_VLAN_AVAIL;
 			list_add_tail(&vlan->list, &fnic->vlan_list);
 			break;
-		} else {
-			FNIC_FIP_DBG(KERN_INFO, fnic->host,
-				     fnic->fnic_num,
-				     "Invalid descriptor type(%x) in VLan response\n",
-				     vlan_desc->fd_desc.fip_dtype);
-			/*
-			 * Note : received a type=2 descriptor here i.e. FIP
-			 * MAC Address Descriptor
-			 */
 		}
+		FNIC_FIP_DBG(KERN_INFO, fnic->host,
+			     fnic->fnic_num,
+			     "Invalid descriptor type(%x) in VLan response\n",
+			     vlan_desc->fd_desc.fip_dtype);
+		/*
+		 * Note : received a type=2 descriptor here i.e. FIP
+		 * MAC Address Descriptor
+		 */
 		cur_desc += vlan_desc->fd_desc.fip_dlen;
 		desc_len -= vlan_desc->fd_desc.fip_dlen;
 	}
-- 
2.47.1

