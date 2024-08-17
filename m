Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12olkn2026.outbound.protection.outlook.com [40.92.21.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974E1C32;
	Sat, 17 Aug 2024 03:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.21.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723866947; cv=fail; b=cKIO6XOlLf6H/McQyONx9AU8os/cLqJIXtP9n14bDbyFCTuyVFOWq81eBZxuALexK55Nsl0A67IMWOv8QBuxXh8Azzxcs4MZTWeNtRtsR0r7CxG6p8VSP7llaLyJOksSO6IHtX6WtCrpJyVLRKIPLNT1/SvDh9lUBNTXvwdKdHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723866947; c=relaxed/simple;
	bh=nbVRnNLbqBKYVrUh1PAMqk0W12Bqm3xg4tamocDcx6o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=li1QqA6o4YZpYvJfF/yndXj7UMGDBuV/c49I8FfJ/B7vH7IRbdrzquMIFPkz7D0nSVOFrfA9cClIVmMq5cmrUQDBfit8yH60f/bab/MbFVA5Dtt66qqpL283BATA68gvfsNi498rV5XglUd9NQPv8qoNiGZ4tI0peLIEyVwujVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=ZxhmrfxL; arc=fail smtp.client-ip=40.92.21.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="ZxhmrfxL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U64i3dKx3KsOZwbQYrnwZ9DGTx5Na25lBvrtuEuuajm1gY+Mc+CCQXkV7M4GoLFQZNyfvTkHahmvoaVOaZMndkpWkLMI9O507Y7rVYFHuF6ks0sdpnmO4QZo7qpieGGLT4auPiZArorteTShPuwjqhT2RnRnwZ0Cvv8v7tkZ5HOuUVoum4Jn7NTPQaIcSFzm/9azj73L1mJM05hU+gW7+2iydApicQt/3bOowUA1o3aDH2Oe8USuSY6Ll4LcHVTwjMlPTxbiY8Fu3LvJRLwhxVYntWAd/OFS1q9YVGp0d3OH8UnaG5LiUrEalvb9wcTU7Uhc3/HE4vbkojYcwpId8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QI1Y9qRGYbbF4bEl7IUY1l6RT+J5CBkYMJGw2k61dg=;
 b=XXa27YRfgNY1AdvPj3T7oscp/uerxOQnvLENFo6WkUmKdpAs+qOokT60BKbnqrILYQv33zJPmbGsicS4OZar4bJKVdgvU/5OyoN910tsVqBhLLvrCIr3W8P+8XlT9MvutFF1GXN7cL57sTY3sApERPr+PZAjt7aImiuPNwBoWf7xA7z4opfmxlHwY3H+3w+dFx05TkUELGhwTtPv/Fhj/Bp9h1dcW9Fh2R0Wcm0pjfyZ8aiXPVD/47AzA2HgB3++K06QNrdnWLAAWXMiHADr0sdCQafLyPmvCjX7AYiegLa28hJ8kpHa4pWkFP3TLN+jRfKmxe0Kii52GUKR4j8QgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QI1Y9qRGYbbF4bEl7IUY1l6RT+J5CBkYMJGw2k61dg=;
 b=ZxhmrfxLzIGkL1RSWaq3H3HygwaBdBFa6GfEg8pbD0fRdGvIWUh5DfZpXUea38SUSNb2Jgi9TvGX1B4fZlhIdiiXQCUz0cbzSPSBriqfh43xOQFGCYH7vJqkP9Yh3UtypKkO7Pkf+ypyieQM3GeltYVp9bJTWqF6SAfP6Nt953WaFNztzAVxzhVOrOYURDj6sL6tBhLV3VBe0XjAGEH/bzTgDoM9B2fCVfjxBe2Antllo5EM+RCqZ+OIaFjCn3iegSm8M+vq+VzqqNhdfcI8DpX/i6dQ+Mk4vxIxmiiHoi1++m62k9ajGav1k2X46puvB1BmbNA6MZdis+1/FoVCIg==
Received: from CH3PR10MB7762.namprd10.prod.outlook.com (2603:10b6:610:1ae::7)
 by BL3PR10MB6041.namprd10.prod.outlook.com (2603:10b6:208:3b1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Sat, 17 Aug
 2024 03:55:42 +0000
Received: from CH3PR10MB7762.namprd10.prod.outlook.com
 ([fe80::136:7fd2:6a9f:b3d9]) by CH3PR10MB7762.namprd10.prod.outlook.com
 ([fe80::136:7fd2:6a9f:b3d9%3]) with mapi id 15.20.7897.010; Sat, 17 Aug 2024
 03:55:42 +0000
From: Txanton Bejos <txb2@live.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Txanton Bejos <txb2@live.com>
Subject: [PATCH] scsi: make minimum cdb size 6 for group codes 6 and 7
Date: Fri, 16 Aug 2024 20:55:28 -0700
Message-ID:
 <CH3PR10MB7762FE48ED542A0BF7C1B59BFF822@CH3PR10MB7762.namprd10.prod.outlook.com>
X-Mailer: git-send-email 2.46.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [UDXcc7T3D+32oMWvXtNSBR64B16nwI/KH5DRDOKfQk+vaAy0w7h7pg==]
X-ClientProxiedBy: BYAPR11CA0084.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::25) To CH3PR10MB7762.namprd10.prod.outlook.com
 (2603:10b6:610:1ae::7)
X-Microsoft-Original-Message-ID: <20240817035528.40913-1-txb2@live.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7762:EE_|BL3PR10MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: 897a7854-2c88-4ff9-e334-08dcbe707708
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|461199028|15080799003|8060799006|19110799003|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	B1OFKDdc9WUZ35dyQ5rEL/Fj7t+6jOXPZ80sf/h3lY37tJFgN8//g9+KahuD8UOaciBWKWnqqsRAsZDWsCGxi6YFCreaYbEwi1J0hjCunwUbg//gZvprAbbnCS+hMe/SvCNQg4utstLQK03TxNEc+Tlvrkfk8OYA4F0B2o7fjR6po72BQWLEVAJ3OOLsc2006uICxLLYo7lpaSit2C7v9N6YabzhdKTLPGcYxbkWG4MNtlgJe6BYsap3iMasRDgYG118z0tE3Rl8QRd3aUcJHbSpYHAL6I1RdG6n7vBPU4O+OQqi2if7R38zD7JacT70lipNLBypm6YYhHjepadQq3CBe0nFTyW4LN807bCM5Ln3inKAmOO+Avcz7oED+VVSinos0v0DBQlxhTDCSzuYXI1j/XRaJAb3ymRIPzDLCfeC1A8VCiyzWAXK5pUAi4o5I4X/6ErPgA+wdFvAoe57YFZSDpTu5Hu6IL888wXWJUsBfKas9+04SmS61SMeut0/iddS58GLuSB0OKKiY9Z8diLP8WFvNor0ZHDSmJ5nIBpvSOkAi016d56BbXO1f3TmLqDizfWqxOb2n+zXrqi7ICp2x+ymsksMtQvtYeIm5rsoVew3V7tCh5C2X9W6jMRupQvqP7T15hpW1PnCihjujY5j60icJn61BAcm4GBkogiaXKkpqN+Nj8EUSrdjdEgUQkWEEZSPW8dtjHTS2n9CB6a9d71rumj5Ent9xQTnXUY=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CV9cgdQZpzIKFvEj65gJf9R9IY17nzU7rcIHkzhr/wpNJHnE4nMD5elCXXC/?=
 =?us-ascii?Q?lNJ2hZXRBmsY+SiTcEYdBGuoiqJAvqHAxERIH3uD+0/ck9jFRLig3u+ec0wK?=
 =?us-ascii?Q?+2mob/gmcBhmzANTyIP7r/16pjo1TWK8+MlEjDLUzdEBG1TaDHwdB3FouSjZ?=
 =?us-ascii?Q?Lsmi48v5ybLYTqtNhzgYEawT/OFHxmGB/8ergabQZQgYuxD4+DYgDVSPXm0X?=
 =?us-ascii?Q?wFE/9uxF4ed4EXVsKl5qVAlCP/YoEdJxT9XZ1Boanyd9DiR0M6cZ/ptyMqLS?=
 =?us-ascii?Q?zquIK6vAakLyDu+Ux/nWmDzILz7dCW3++YllMU5V/2xuwz5HBs75lStfvIMl?=
 =?us-ascii?Q?6wSQYGMMelaxU0/zRSRPR7b3jCMi0AHx77YXVcicLpN2wo/jOf6J215EAz9J?=
 =?us-ascii?Q?NiD9hD1DCWmCC2Zw2EPxQKagAeFDYwAfvc65FdOUO4ppFuMFAvCZpwyNCBtR?=
 =?us-ascii?Q?mpWSf+YwhP01W7mNUzR6iTfPFlIoDFEMLDrCr6dcX1FVkcFttcqZ6dU8Pfk3?=
 =?us-ascii?Q?CwAR1VxJedB2Ncn2UIyJo7DwhnUfLvduZGZpt3P9+Bc06XDWsguy5FkZR/He?=
 =?us-ascii?Q?NI14BwOpcUlGr8aZJANSfOYVAba/2B5biu0fiWOniKVoxeRUN707vL9nbjIY?=
 =?us-ascii?Q?57BBSH6S4+8sUresR7HzH76twqkk3W/1UawOBONKCckrXtbmAgJDkoEtIBKA?=
 =?us-ascii?Q?d1pLXFfzldx2gJXaWzOh3JrznA/JWG3geSwWFj/Uvk1bW26soJLL57mQxDo6?=
 =?us-ascii?Q?BXq709mXSx5c+0oHARqXH6K4O52g08JxPQWkUH+kKbYfFzNpnfrbheHS2zPa?=
 =?us-ascii?Q?OIo66GcnkYvvEMR+3TFFyjJqFnJwO1m9GK9M8ADIMy9INu5bPeIDvBBnjGTe?=
 =?us-ascii?Q?1zMAG4aLOiCeHLlyf05nQQfVLcORbESVg/rqrnlR1d9nh9gFm3y/OAKYmxhw?=
 =?us-ascii?Q?WN1wQMK3Yg7rVUtiFQeUg/wUiAs+vkIKSdqidPWsl7Ej3XtiPiBN6Cijb/ZU?=
 =?us-ascii?Q?9oz4QgV1iStBpDwSkEvpYx8YA+KsqiEWJnH3z612bueXzp5CvXdiPgddgq55?=
 =?us-ascii?Q?Zff+bwrT/Vn5kyYMX38Bpb9UUALchFo6cu8XHHJqWq6TyonWnrRbYaZxwkUe?=
 =?us-ascii?Q?mgbIZkDq3SH4be9+HPEVj+MrvKSHLFGcUv7Z4xfA8a+NBjClJPQFCoQME5gT?=
 =?us-ascii?Q?cNhW8TYHeziEZcfcWqbwYv1zUQc3wrmIIW0+Crr7N/WkMx2TDHz65CEG+jD8?=
 =?us-ascii?Q?K9X6+ZP/uqbiHHgo+bVr?=
X-OriginatorOrg: sct-15-20-7719-20-msonline-outlook-c3cf4.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 897a7854-2c88-4ff9-e334-08dcbe707708
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7762.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 03:55:42.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6041

In Linux 0.99.12, a table of the command size for different CDB group
codes was added with a value of 10 for groups 6 and 7. In the SCSI
specification it is specified that for groups 6 and 7, the length of
the CDB is vendor-specific.

This fixes an issue when sending a CDB of size 6 with a group code of 6
or 7, where libata will respond with DID_ERROR instead of sending the
command because the length is below the value of 10 found in this table.

Signed-off-by: Txanton Bejos <txb2@live.com>
---
 drivers/scsi/scsi_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 04749fde1636..b482c8732f75 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -17,7 +17,7 @@ MODULE_LICENSE("GPL v2");
 
 /* Command group 3 is reserved and should never be used.  */
 const unsigned char scsi_command_size_tbl[8] = {
-	6, 10, 10, 12, 16, 12, 10, 10
+	6, 10, 10, 12, 16, 12, 6, 6
 };
 EXPORT_SYMBOL(scsi_command_size_tbl);
 

base-commit: 5f36bd89a9948ae23571f9ffd122d7de1ced73e0
-- 
2.46.0

