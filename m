Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FBF39768F;
	Mon,  1 Jun 2026 09:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307686; cv=fail; b=rCQ6SW+EzuPsgZsgff4Ksz87dLk5Frc9VwY6GMmjg3yszLeyTlKo2+PXDria2C+7pvOaP/X3YTfGAtrJNoQYWwP+wdFg+mNiuwQUY8D2+cU4IFFbtssN+R+OXkMtIFmJVUkTjnheRBiJdpZgV+uKffT5UYk51vVdTpl2Xu2f0So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307686; c=relaxed/simple;
	bh=9RAXNB1thajNc+zk8muT7QDq8HBKkn/lFJbaGY5CIsA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=baEdDE2rx7dLAvNOFVnxrhV+551N2oZDvA0uTp2Zv+gwn1UQf25TkksnTNvqufEpYgqdWbgipoRGMwyk/EHkyWlxpZ3A6u0FwdZq+pui8D43M3WoT0Q+8QR2d8lvUZtpbJ2vukLOEF75TzwzzNkvct6QQrgybJ8tpzTxxXMhAQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4jaDkCVi; arc=fail smtp.client-ip=52.101.85.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4jaDkCVi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJK/e8VtO925Ujm1ny/XZpiEwXu/HC3tZdulJgIxbMRp2FPrmHAgWcp386hY+PRBbMpqetetBmtid4z2L2MIzCLJE9AsfL23z9kVjAsAfbE0bvsXBombI/ubCXWTnfrnRx4j77Eg80ua2k4p7C4OPnUb2AEMpq8DTLgR2k+rC+xQ8HkDjrMUSzThU8umvi9qp9II7HfnaT6Lg7hoZtsM6ayYm5MGU6lzOJs/zS0fVdtISlbg6iVSbmPKEMA8ga/lIcewHKl/6B5kuWPa2bRQr9FDUEAvdCD8ts/teD1/u9jv1kjlRKAz5MV3bmWVGzne9XEkMNOjEAHi+qmbtMfwCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8gCPTV/uE6vJXhUDQ65mNgh8E+XqQOl9KOOZUQVA9s=;
 b=ju/1u7sBiXUsaBcl5BYRwtMRKbZOP+5/+6EgXIkjwxhIqhLf6/adyyp1Gkv+MAgFGAb45cCTDT/IbgEFpv/HN7jAZ1vaNzo4kvJ8RuS2ZlDbRVBK4k3O8zf/mKty3UfnmutIz3zNohtKuV/Ol6Cbn3Q5DncqNX7PtZtTg8JVwU0Sxd6E4Gq+phM1TIUiCLt5s6xhH2nZxeYcbdiEk3XuExwTO0R17RG7HJWcI2xY4KwJBd0c/2y9mpLAihOls4+uvYaEf/q9APmhCdAij6DC3ooBvHfMf0stsiCljvrcZfBG2yUDU2vchWDVoLJ1KH8j49+FTECnnEg4rEwwmDGuyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=hansenpartnership.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8gCPTV/uE6vJXhUDQ65mNgh8E+XqQOl9KOOZUQVA9s=;
 b=4jaDkCVidKSAWoCqJB0lIlQX/M49e9QH/aRVGTHLPBSH5AdvPKf29YPZaaqFjK8aZT0IwOtSiChEBoT6W/Z/50Rk1ePLcm7B4Zw/chzJv/oYL8MmHoe7ujZGCVvnnTFXtEXDEfOC1t00GyPLw86+4o1Dq9z680zHnrxFUQg+E0c=
Received: from SA9PR13CA0069.namprd13.prod.outlook.com (2603:10b6:806:23::14)
 by BL3PR12MB6426.namprd12.prod.outlook.com (2603:10b6:208:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 09:54:32 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:806:23:cafe::b) by SA9PR13CA0069.outlook.office365.com
 (2603:10b6:806:23::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.6 via Frontend Transport; Mon, 1
 Jun 2026 09:54:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Mon, 1 Jun 2026 09:54:31 +0000
Received: from airavat.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 1 Jun
 2026 04:54:28 -0500
From: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <adrian.hunter@intel.com>, <archana.patni@intel.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
Subject: [PATCH] scsi: ufs: ufs-pci: Add AMD device ID support
Date: Mon, 1 Jun 2026 15:23:36 +0530
Message-ID: <20260601095336.1396787-1-Rajeshkumar.Sambandham@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: abae490d-8d10-4129-247e-08debfc3c766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|30052699003|376014|36860700016|82310400026|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	mtnX0inKwv7/3D7ckT9DmxTVU669b3Dw3FLUu9fsHm6AW5O6KWfX6UCa4erwGj5KRf7VeuGRGJI2A2kkVPTD2GZznIHkCtGZMdM6aRSZlA4Yf88VqAzT9ZP15/Kck2ZJuj/sPyQo1Y4U7q+wgerb0EoJL1GeVULi2cZMWaaUPRVw0vKSALs9/d3fevFr3TYAMmyO7KLjBHGXuCUHmDLFtbn2ia2iTzMf/8oUXncYH/FqRt4oGqVCWoNvN4fyIp65dl4DLPqUAuUWsPcp/AbQkkbEstKsBhdlbs9V9UPTCQMRoxvoYKPLgjMzHY1Tvuyodg9zpXiHkDhBl7jBpfIZ0j6eaqhS36ZVEA51E0do1m80wGkhOnT+28sHmdtxfyoK/EuZ8ypq758m2u+GI85U4YfHl7Gi2e7NNMUQGsjqyGs7t4xGFMO0toGBD4fXK2+/0fjP5NgmuOVy5AybbDvc2/nB0C7owtqD5+QzOwarH//o0P3CTSvHHI6pq140+ehISdmIH4+Te8xHFahvW2xMrMTjI4sWOJLZoTgzvH46RoyKhvYkHP2NqXa/rjZcNY9vJtDHv6MtWNRQptgRJXD2Cw5378muBcmoe85hb8OXjVAHE20v7Cxc+MKwRPVlJHtoCRi4ml6N0C2wYbE1kt4CsLacJOtWWBiqXA5ujnVU3zbd/DheNHhwxa8NslrSJ5FytI7dPCpGdz7O78CenCUi3uPaVEHXyQIXs5pY4+t4dQw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(30052699003)(376014)(36860700016)(82310400026)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eNyrvNvM+3xhsoUZhucKX/JtcnNK7xdg9jFBzQx58GUmjUx4RTU1pbJc6XKB6gh7iwsmXB61MklAmZn9LmYc8AQn44hdW+7E+agIPOZFH9awzrXHhYBYYt2ZPgx7x3Nb67rMGe+8ELklTa+Pxdei1oyDwhRw054sey7LHK6fJ5+qlctaPh3tUPy0DH/kpAWRc36NxeT6iyK7+MUCHvnYI1hC740INPl/sNg9SydkH0pDzKOH2xEnPK3UUImO9xe62lSX4hcNrFHAYEp4CIENivtXgNhYp/0x7SBzI7JaxdDscdhaF1mmQMBGH3M/xRRIOiMv0AqdBoYaUJtl/e31S/erXn881ae2ip7cW+a2jfJO5HlDG5Dty65wAXmhfe4/tSHA60m4PzInb2NxDRjgaMzZ2Nw81K2Qo8hQPTy1urlKLpCLpfoYi4qC6LA7LDYN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 09:54:31.7445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abae490d-8d10-4129-247e-08debfc3c766
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426

Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.

Signed-off-by: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
---
 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 5f65dfad1a71..9ad42e07a94a 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -684,6 +684,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		(kernel_ulong_t)&ufs_qemu_hba_vops },
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_AMD, 0x1B29, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
-- 
2.34.1

