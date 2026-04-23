Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [139.138.35.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0240357A5E;
	Thu, 23 Apr 2026 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.138.35.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776979103; cv=fail; b=SLAOt5GgZq593LHO5Y2ejSIm+TIcXxJ4QbXunlg4eO89C3+ZnWwi9PKKMuynx+Ql7G+RtBEUN87necQPcZKR1NR9fSU+HppCM9OuCt2IoChww3mVxFuX0KgDnhcT05FbE75Qr5eOPgFeGdWEYf6lmdohkMolDqw109DJlEUhiO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776979103; c=relaxed/simple;
	bh=D+ddLEWJQBqa3uCcBQVAiPw0d6APCIVyEF+JFAZkcMM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uxeFwgawf9UW2hzHr0cnqi3aPyJcH5swEOYuNwabsPDiOQoNj4wAqtXaOZ63INragkZ8D2Xenus17mfdfIHN2zZj4rDwdp2IiEJWUuMvhmTzitmrpuJqfrXNmhClG776ySxdL3ji4t36GYXYnZ3fGweWznJEOO7yq8UUvrAftGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seagate.com; spf=pass smtp.mailfrom=seagate.com; dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b=KH5gKTR0; dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b=PJzuF3l2; arc=fail smtp.client-ip=139.138.35.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seagate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seagate.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b="KH5gKTR0";
	dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b="PJzuF3l2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1776979101; x=1808515101;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I2OMoKjYs4Ciq1M4moPVwI2IEJzEb6etnPWwUK6YDQQ=;
  b=KH5gKTR0RX7qfnC+yh6bn24hLJqFr6hTEenjtTNNOyTu5oC2eWB4YRyJ
   x5fxNCDUrcEOlE/mT6s3loXlTg+jWc8c1uDOvCON4lmdPeV3rDDSXQil5
   Eb9o1Jv+9tvtbSwrodbuNE2yEFaycYuZKA5FKXyc0khRHuFzZI/YUPUk9
   s=;
X-CSE-ConnectionGUID: O1ogCDIUSVGnLx4sqfvGJw==
X-CSE-MsgGUID: e4843UIZTAqwTrMAxn5fyA==
Received: from mail-bn1pr07cu00300.outbound.protection.outlook.com (HELO BN1PR07CU003.outbound.protection.outlook.com) ([40.93.12.0])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Apr 2026 14:18:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IjWXVECBPRCCEXiW1jVerIF7Ck5Vyn0YyBifX4PLoSfJVYr7GLfooLiJnS1MjLLv1XQnP1Q+vqhx56fqVQAx6PLGzRi3xYN+EQZaEL1AgD/pLm9cdIqoXLMJIUl+j7KRGBZ5wBmAXqtTmiXtG/omKBYZspeJV0UTQESJs4htvzcKGAERxgzYBXsnBnCaX4pTrRjtrzgcSQSFAg2CThzMtuLb8Xmii5CCC0ZwRdqWqAxMnhnCk0hGICOvHVNE3v/hZGCFi2B8rXLEcw4yvxWwRcYMRlKk0tBprTeXlqZLNjePwRndEfKsH1Xdt5k/cz18jP9JkiVDRlPoBXGKXzyybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I2OMoKjYs4Ciq1M4moPVwI2IEJzEb6etnPWwUK6YDQQ=;
 b=U6UnGhW/R4LrLmHZ84wqVcfVnykK7Z1NzI9r1Kjz4MoizAHQ5v1r0cA4ZO9goP2IWxcGJXlwLcDHO5+6hAJ5F2gAF+1WMlMrvmRdjMQxJBGRHZXYUzntIcgpKOA9YQlumoEiZHfsr762v+z9pttZFImlEkvoJARkBs391M4lXHO9bvDjS04X5YzKARXNdxBgvnuAFrOr2DQsTm25UV5MwHigBP886uq5Cfyzbcc0gse6OTxSfy1SY1/0OxeemFyBJvdQxPQt40Y31+UdJFexQcZVn9M1T4Vh0Qd7rOk/xJZFS+r8u8FG3SGguHOgFm2NI/JANorssR8iIqMNbWRhFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 134.204.222.53) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=seagate.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=seagate.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2OMoKjYs4Ciq1M4moPVwI2IEJzEb6etnPWwUK6YDQQ=;
 b=PJzuF3l2S1nUInP4bO7nZ2jekB4wvdDCMJeasFw+IRkHEDnCKvGHd9WGglZcZINT4XQ6/91kpiV5LhuIEGoZ8Evprm+eADVzLGerreOpcYiy/kkePeX4/2yBJN+iNzqM0YJqJix0i+kYBr4z5347tUvSir+4rCWup0HL0fSTGgg=
Received: from BN0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:408:e6::25)
 by SA1PR20MB6961.namprd20.prod.outlook.com (2603:10b6:806:3a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Thu, 23 Apr
 2026 21:18:07 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:408:e6:cafe::3c) by BN0PR03CA0020.outlook.office365.com
 (2603:10b6:408:e6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Thu,
 23 Apr 2026 21:18:06 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 134.204.222.53) smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from lcopzesaa002.seagate.com (134.204.222.53) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Thu, 23 Apr 2026 21:18:05 +0000
X-CSE-ConnectionGUID: GLkdoqV1QySn+80G9EiywQ==
X-CSE-MsgGUID: G9CzFx6UQQGc/FO2cgoRKg==
Received: from lcopiesaa01a.seagate.com ([10.230.120.56])
  by lcopzesaa002.seagate.com with ESMTP; 23 Apr 2026 14:24:55 -0700
X-CSE-ConnectionGUID: 5xhDlmNMTA6Gt1VLkBkCFg==
X-CSE-MsgGUID: nxqHuINqToqueIF3JiOsoA==
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="737543"
STX-Internal-Secure-Mailhost: TRUE
Received: from nick-desk-ubuntu24.colo.seagate.com ([10.230.88.139])
  by lcopiesaa01a.seagate.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 14:18:05 -0700
From: Nick Spooner <nicholas.spooner@seagate.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nick Spooner <nicholas.spooner@seagate.com>
Subject: [PATCH] scsi: sd: Use string_choices to fix Coccinelle warnings
Date: Thu, 23 Apr 2026 15:16:44 -0600
Message-ID: <20260423211644.3481898-1-nicholas.spooner@seagate.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|SA1PR20MB6961:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 5853a3cd-d6b9-486a-3e6e-08dea17dcfb1
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AlvP7fT0nyavMLdVUHrFZeBEi2ZO9rSdlVbpfXt34IEi/V9eifexgwFKTiSwBPU1y28R51BIh0sgNbl+Kk2WoVw52P4JygGxVyY/ooYJWluaLE/K3WbRq0ITtVhuaS4NTWo95/6jmX+tkyauSXNWKZoBjT4gVJP/k+DCM9SWQA/5tr9U0nMuYMDVxIKb+nG5RuIqJCAzhZwlS/zao0G3COunKSDirugp9/IcQdnMZ4+HXy+YBOkl45E3RB3DiyoeMo0B2sNYV6qad8RB7n5TwTy/pUj9T4/5kmy7acvJgOqG1oX2a/GG9EU1aVMM6oRRySNG1RGW96ZtyeZqWM925u9z/RhpjMvNhfTQvrrYN4pTQUHMTs66C1swTw9GDiQuUSOUk8WVqcXv0XuWKGxxt9t48G4SADmqv/ncndmqDRgvMdAzq1JstTKGCnURCITcrmfTtzztlDJRiVseGdSlQr1i/amToRNrtPYWWkKCGWT4sdd2SjtVU2HI6E14s8XItsr5T0cceW285i8+ykk1du0yPpWnEkiqTerPeu/aLu6sTk1hwE3/ghQECpjFnhmTrqKHAcHarWQlYAY4C1oDgJx70WNLTOLnAYJxC7MFGdg0BNNEBH7R1D7LVPg5Ezr8ts/88zkQTwD6l78o+RF5UA8Ck/tjyO5eK4gNK9g03jPZz085HT0fhoziamVHK/s4IeoQxRTtYvqoaTju5s+m6mhjMfRnUmwGhD4b3sKLBZZaFcnPpFsUr80a9BhaQzzyTiEbZEbHiyN/Kbeo04uMtw==
X-Forefront-Antispam-Report:
	CIP:134.204.222.53;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:lcopzesaa002.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	u8PA35tJLHHzC/O+uA++uSUwWO3IXqBqJXK5/gYp+VRIG6Gan27ggMy6XD7wqmE9Iu0QKNoGHzKd81QVoEUUUUcNgM4XF0gxFgofSDdV7VZ/IcKe38cHBPW8nKWsEiRZypMBhmbpoA9v+5Ix0FS6N0qHjkZC6e+8MNcEdfb9/vwrr7CtzLiEzCc0K9Y18XvNudne/WbY4bs41MGhVvZNuAwwsJY+MA4qvCZSSQp7a/lNfn0OeukZ1vesmmI4l5H6oQPoVJLS923rXrc7SDiNaLLBO63KAYQ4ouUCw0l/3ydNQhzwDTyEH6kky2ysJLvbnXJgYNfTw1TOTqupmIsMj2e+oLe/QjYrf/S+f3P13ilZTZbxLXRHIq54Lg8bfh28yNJMYka/0gRiESkIs74YUaX8SdgWDJgDvNnqKcwK6mPXJAB6s3iXmcWSZv5IaCxi
X-Exchange-RoutingPolicyChecked:
	RIDlmv3Bz0lHSSEDGU1Gz51LINiOCUxovwZJAqYcym5E4S452W5FUhVxzKqqcz+uapocY1GvUboCWSVGvg04v/An+JqVMy/FSix0g5g6A8v01dooB0le5GXNBzXy3YWTIPeVDVdaa3SBtYYc6BHZyFins/+O4wWeN51HtChBfAe9XTnqsqS4cfcWgvzUOOxoY0HH0dfVrSveiaQEa0GZbro72R+0LtC5t/rBRwCBEiSxONjkvHZ/7UDN+NqrsWajYQKKeaK7dLn/JfFF8YUXdcy0wiFwHvOvVeVqRFl2t/50EPcVuuoAEagQOx3wgE08MwY+SchJxUHoEg560CRraA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i7dOrk9CY24k7ImBQgeNTn2h4wxTFAdDwDlg76JcVXWzlwRiM8EyBPz/pMwO+Om0gr/ry7YT9//4uNCpaBSeyV2Soa6k7/xz0TYROMOVbXcXVa9XT48JER70r8mOCtzcdFBqtEe681PajScWCj/Iy/a/SLMuK4mJgMBye7dzSnDC8ZMBibHXQDmVFEnm4MEI1CSaU+kusC5sVo/HgheVf/AoF99/GouKyhPPPurbtwm4gQlzBiuda9dV3G9ZAH9HcHUDVNoO1ai+VtEcoUw8NI3sgi2o2Du+GQ92OpyDFL9WSatXpIaYHowcgP+hI3VaVOxc33OWcUqdGSH3dglKfj6FgYiSOIRjfUc8XpCudx6/PxGx+XrXbuU0wnt01i2GWmxsleK2NcgUwNTnnvjhj8s7CTpnpriiTwc8Ggy+u1JKHyEOobyfXErjwSA8KcW4/zk7d0qYtlJHLWwGNCIHwON4IHFf6cCxYDTC3YOBhriZ5kjGhb/hNeRW8pwugQUwg61+c1rmQn0nb7RD/74n9RLCEuS97rEEv7p0fhn67NsEknTpTh9LhlzQppMzBwd73iP7XZQos+GsqSNnFuANLhY/vVzXgPYyBNhVOlPgS3V/wW55jfX2P6RIpZYGD6wy
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 21:18:05.8139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5853a3cd-d6b9-486a-3e6e-08dea17dcfb1
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[134.204.222.53];Helo=[lcopzesaa002.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR20MB6961

Fixes the following Coccinelle warnings reported by string_choices.cocci:

	opportunity for str_enabled_disabled(sdkp -> WCE)
	opportunity for str_on_off(sdkp -> write_prot)

Signed-off-by: Nick Spooner <nicholas.spooner@seagate.com>
---
 drivers/scsi/sd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adc3fa55ca2c..dd284647ed64 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/rw_hint.h>
 #include <linux/major.h>
 #include <linux/mutex.h>
+#include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/slab.h>
 #include <linux/sed-opal.h>
@@ -3084,7 +3085,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-				  sdkp->write_prot ? "on" : "off");
+				  str_on_off(sdkp->write_prot));
 			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
 		}
 	}
@@ -3235,8 +3236,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Write cache: %s, read cache: %s, %s\n",
-				  sdkp->WCE ? "enabled" : "disabled",
-				  sdkp->RCD ? "disabled" : "enabled",
+				  str_enabled_disabled(sdkp->WCE),
+				  str_disabled_enabled(sdkp->RCD),
 				  sdkp->DPOFUA ? "supports DPO and FUA"
 				  : "doesn't support DPO or FUA");
 
-- 
2.53.0

