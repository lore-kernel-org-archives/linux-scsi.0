Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013046.outbound.protection.outlook.com [40.107.44.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18573128D2;
	Tue,  2 Sep 2025 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819489; cv=fail; b=Xq/lwe14yW6hYUod0220YsEV7A2OBaFN4M3W34mX6PDS8XeDfVzf/Eldhr0eV1rjxQyVtO/pDGfidjxjIe91NWxpTl61V1JAG3RTxCcsmBeu1Em+cCF+xM/gpDBKntIQK9qlD5Ywynen1iQM3U1NAzfwUcMqHnNEu5COE8ghHrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819489; c=relaxed/simple;
	bh=xpArSAOCY/EjJBJlME06wEZAOQhtfih+ckLbCCALmWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BwxlFQuCiAjW+2a+qwWUvaJKXoAK8Zqb3Qb87a+9hDM5ne4Euhhi+19sWs3L+JhKWYf7MXS9AheWJvbaMl9y5U5beR/jlEJ73fVkwO1Q5tstJrS8Jpuu8WWZGecRDVl98zQcG7do35U9ltyPHDlIscqBjsUITWIp/0uvaqAO5Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qXGIDEhv; arc=fail smtp.client-ip=40.107.44.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qXGIDEhv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pfLBLEwTANeI0wwTSL4/XzDONTVqOtbm1ofCwR6xzIgXwe5hAJuhG0X2NMrvSS18Jg3sgrvzvdFSF4poOulGAdc6iRDz56n/oTvhKvzeExrXRoRm7vNa8z8q7aVAq386g9Ncumr167CgtpaJ3KpwgeVArQm8hgPplj9hEQ38j+IJLjD0Fcnq0tIgCpmAY0UqQTu97mZI8Tq6p+paGKUrHnTn8bbAkNsIWlxVOZFXDVt446MDyo5PHVN/++DQSV7ReAPEpqvFTWdjahkOn6EOPGxjQeP0j/PPfdNXDz0WeyCFH/ggWYZAE4uPZZDua3BBR3EGGBXmwOnJ8mGOGDXFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPBT2TFSc1Yc7kCmoo4WbwJmYiEF1Y1antgqlklQh9c=;
 b=keCtgJj6iBQhuPQuLWkeSa1O21j4lEAPuBWtEY2A7IOSNUpZx8uStqn7Ex7DAxqudykk8jD02LmFrQue6VzIDyo4St5IlV9xE8TEedAWVvxDjDIs69XsxpahnuaBr/LoSammG/UUKCneT7vGqFn7FEjYDubgYloOcra5VpchnDjjSHZuo2tTgQpqg8ENSp2SxaIsX+NGoLQr9OWhEIKKvl0RThISx4h3i5Oo3EGGLZsMEI9EAmlHOWxub6HmgYB6cjh2TwubITglwvGHxNai5p+6zQaApAduaWwTQUoJxBT5c/uOvy6m4pjgefHAiEp31DCNKAOD+S8kjKNK5TQ1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPBT2TFSc1Yc7kCmoo4WbwJmYiEF1Y1antgqlklQh9c=;
 b=qXGIDEhvKsMaJqRZpK6hkyl0GF754ad/PIQSNUdGjiZZZiiIzJHH4pYMDlCCpd9RHat58YwcmuMc+p2Th4s3kBhXL0laNbGiWRIEIFCLQb+MlGEjqmKftPU4HQbo3skf9AqEaEorB5bgROWlqELpnHHIrNvOi6oTSu/B8a0ASNIXGfpKsbX/wKCNPI+cGApiQ9kyT8PeXM3n9DV8GO+10SAi0opvStaanjDqPqGO2C6w47Q9hwtBOYtl7VQtG9xlgf0ZJgmXnX/O0Z3/IDVSIJZLYb+qAJWCPCLs2USAuqUEeXsoqCYmUFsK6DqGM+5jdVArlxoSNrRLWbwAoTDJuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB5078.apcprd06.prod.outlook.com (2603:1096:400:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 13:24:44 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 13:24:44 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	linux-scsi@vger.kernel.org (open list:INTEL C600 SERIES SAS CONTROLLER DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 3/6] scsi: isci: Remove redundant ternary operators
Date: Tue,  2 Sep 2025 21:23:43 +0800
Message-Id: <20250902132359.83059-4-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250902132359.83059-1-liaoyuanhong@vivo.com>
References: <20250902132359.83059-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0238.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::11) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY0PR06MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: d5124c16-86e4-4f64-443a-08ddea2414c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3XO4CIVIF6o+/TODoYDE0AJ820QmREM11WFh5WRVJuHm9lCw1fHdKUCDXaLR?=
 =?us-ascii?Q?i9kzmrMQ5C3bI5TxpketeBx3++nvuQgO/ud/He36hKt/hS39tAAUP1ncXC6Y?=
 =?us-ascii?Q?XHxM9ltIPokLz/X2x+j8yf1dWh/v2x+O1p439nHUHBfld/T5qttL42HiDrDD?=
 =?us-ascii?Q?rdlDyK9IOAKBc9zT22CSJqLq6NyXpMdlEXf++cGDNRxhrk+2YIVW1vwueQgV?=
 =?us-ascii?Q?tFlJWkqZ4iDBXwnCUcRGGzWLPCH2+G7MW8X2OqP4mKeX9sl0umctPzbbdxE4?=
 =?us-ascii?Q?ivDDAqbI2a4bc34Ci3iDknLZwr7O4/DdihT1wFcrTZ6EHIkqWyoWiDIiJLMu?=
 =?us-ascii?Q?ey08MLJyj/xN+3ursSkQ4aouaiHWAOdViapmWVtoeLklwSyHX+gFBzMkH3Oy?=
 =?us-ascii?Q?8jthVgJrOGpr4S5lE0bp0TbHSrqMa3MeIeQSeWofz+3rSoT3ELGN+mRauPKC?=
 =?us-ascii?Q?w0BULI27W/hA9PEotzNdgFYywRQXE2ctPCPe4VwuWo43uQwR+BpWjFR5mCwA?=
 =?us-ascii?Q?qj/eKlZv6FLx2QDDCb8xldHXrZUON9x6uA5VCwwvEEIhCJ4HPdXMIvNIU9Wy?=
 =?us-ascii?Q?AiVXu/TJTQqasiiZaNgI8lRCuSms4+buOUJ8SGsUpHteBrXtTkFXxoM7NMRv?=
 =?us-ascii?Q?2qkfGh5663XTLT5zx4d1dkAiLLLRuYAng83YRH4s6l1U9MEU64ed3IVYY2b0?=
 =?us-ascii?Q?OqVBNcKRFD2AcN6c/Om80FIOBg0sKigfLVNDKCeYmQHjCbkf0Zu+qEHyqbgv?=
 =?us-ascii?Q?fIHSTTFCGrGg+lNpML9LeGYvaOp+eqzQWohm0LeCLs3tygd/kZ1xKqKVAC4j?=
 =?us-ascii?Q?o5VP4ta8Ir11wubZrNME27xC5mBit1jjEipFRGicTMrrHEZcToXphXh/xBYQ?=
 =?us-ascii?Q?44ShOOwHsn0xyV8t1Qe+PUojGyz6ac/+rWIShaXP96SU6d1Zem61BVRlfXAz?=
 =?us-ascii?Q?F2VIlnX6xXUhT92wgbhU6oEURuM0JDRa9m/+9TYHmTeXY4LG2q1CxRstJAbQ?=
 =?us-ascii?Q?5KKYDxmSRCtguLN5xWCPH4E2I8WfxLkrDJp3LOON/6+BrTNXNJXFmBfyR0JF?=
 =?us-ascii?Q?OdvwQNeH8S0NDmlpWzOmF2vUDmJPBjP0uZuFAy3Gy85ZNA685xaU0NCWVZGW?=
 =?us-ascii?Q?tHTjWA5oy5ZPnUI45VLKY9dyvV63ostlw3h/37cMol9tibgdKHvS1J118DsN?=
 =?us-ascii?Q?GjeMHkPFSYo6zPQqfTVzsaC5XzOUEPdUv196UbBQslxnPQxtLuQR9LoD7VX1?=
 =?us-ascii?Q?chZWPAnzPEyn23gaYWJgrbjsOC+A8/VEB0u9XD1JHOqLghkbs1hYbIDC1TAH?=
 =?us-ascii?Q?iY0m2RF1Q61/S6AHb3xCIDThRrnHaoxtEfjPQ2v00l7YbRmMzi6AP9p+1Qmu?=
 =?us-ascii?Q?Ike0DHkuho1EVzCPx8dgF7X9L43z7WT7odxZCBfhWZQgTg0P811uPTYVVp8D?=
 =?us-ascii?Q?yreATxI3V4X0tiZ6zYkuiqtqxV0OvCakw62t88StaJ+kQhkaiCpwig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jxlXowJPhPUY60tvz2IhFa69QgmapD6Z8eSxiDLhcsqXHyGBKe/C3TPAA2pK?=
 =?us-ascii?Q?ztB7wDLDyQ//nCudNYC90tTDe9S+gtpa63PtfYNCALai4YpFMP2kbPvos/d0?=
 =?us-ascii?Q?93wBX6oyc0aPpURcP/Y51e3jysTdKQMDeD3GVsYSeYz8HmVOlgf85gusMKug?=
 =?us-ascii?Q?oIC/mnaOnTB7FkvSgy+sD6CQCPTU11GdciV5rY35R33ZQmSN7Riabs0e/aWb?=
 =?us-ascii?Q?+pxEnUxFEwxgL82BLcQd3bg3wpEBx4HHNr1jx/YI3wOOh2NigYoeACDnB+XC?=
 =?us-ascii?Q?R0lKLLRxs6nHSnfRmicxr08vzfuPRK7ErTrImtxxEt+wb5eDScAPJCpRDCoK?=
 =?us-ascii?Q?kYVvYDo4k2IZPVg4eIy1wyVdKbO9zB2nh3u4/I20SUdvfAVtx01AMa6QStTL?=
 =?us-ascii?Q?HN1Gn/UEvBNpzpPRzSAToUhVT8RG1ZlSm0sYz2CRDge6cDzuQaiiAOeDiBgC?=
 =?us-ascii?Q?FarRCpBT6be4JNmmd0JyF0TDDjrajIlv3ajBVb/PTUOXzlSfPj4aXDpgDzBN?=
 =?us-ascii?Q?PLNYSjaNe0ACyVOT0qQXVnh9ukClVn6ezruVoI5S1NC+dYneIfu/vlz/mw/u?=
 =?us-ascii?Q?UGWz+hYfTe0brPBNdwHtMv6mmkUDs3NJ31Xs0XFS0KpoPW8sdvjCeSWkKywW?=
 =?us-ascii?Q?XkbMPsUEL1jYnV8+Lb4zJVTKoXvvF4F0mKw5PLf0OoVYR5wOpLe/d47UFn+5?=
 =?us-ascii?Q?dwWDsyna1MDbh7lXwqZj8fUDSCgO3G96vA31hBgju3O4fhvmk5t2ukZ3U0+k?=
 =?us-ascii?Q?55wfdViGsT9wfa0Vvor1NCBT4B+VGajXkwo4DuIqXJsWWXT8mIH+s2mhSxMA?=
 =?us-ascii?Q?P2MK8O8XuUOA5gsejiL6piPGyj3Oj3MfCwGrxCet/+IGgZVeq6MxYTK0YxVa?=
 =?us-ascii?Q?8EaNwq1XgB86M1hM1GCI925+cR/9FnOw+mT52pSfrWU2dmjvXsh0fTNoNuSt?=
 =?us-ascii?Q?MJgeTrMyj8278/qrBRopERBp8qst1aDBV4ByMDLJ3QOgi1maEzLpRmT3Nmia?=
 =?us-ascii?Q?m6kqO1T8gs0QL47TSsPeFEgpFDyx/Z+S3IV4P/Des6qz8KYbE5UgLHL+aKXh?=
 =?us-ascii?Q?R8A3wFohJbA4PnHCGflEdfbiCIxHzEH0TvXz4fGLOkYanTlSDOYHs74swvlK?=
 =?us-ascii?Q?35iMmNOms8eZ16xpek/ILDJn5+Nd1/fszXJ+qlh7HwJ7vVT8BdXmEbvWxM4w?=
 =?us-ascii?Q?0mQa3CPFKs4aPgPGWaQysRg4rRtasry8Ra8d8jmS0jYRfZCCCzkHE1UhcFeM?=
 =?us-ascii?Q?ge1m/Q2B5R58JdJzrMOV6RPDsIQE3wrFUR4LhidBKIWTdhRvqbkrezpOj7le?=
 =?us-ascii?Q?BUeoK6rXMN7EonMZKtgbvDSL6oh6tMAW7TIh1xt+iiOsyCAe2TNPmZpJeFDu?=
 =?us-ascii?Q?9UJxp2FFukR2nhzjYIUtTZz2L/Kc85xvx6TqLMIeUulJjVJ9jVOZYxGaTjP5?=
 =?us-ascii?Q?61oGp/m3C50olm8yQ8X6niEK1nDD+Lmr57H1d50cVfJa2cwy9g5Vt4jtj6mC?=
 =?us-ascii?Q?0ndlSqmoXkeQG2Abi376sWiJq27g9JvZhAWA15lqCyZ4adBnB5JOsplqRhxO?=
 =?us-ascii?Q?EafVUnNsSB8TZq2DqCn/mgv0ItROM7peW/PXJl4v?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5124c16-86e4-4f64-443a-08ddea2414c4
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 13:24:44.6855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6La+Vf096uuP+577SWRQwkEKn6kcejnDKTo2EMzp3WIvKm6uDbNi9P1Tbv/3OykSJFUwHTgSDRDOfjr+RttRmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5078

Remove redundant ternary operators to clean up the code.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index bb89a2e33eb4..8b3fc1a86670 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -757,7 +757,7 @@ static enum sci_status sci_io_request_construct_basic_sata(struct isci_request *
 
 	ireq->protocol = SAS_PROTOCOL_STP;
 
-	copy = (task->data_dir == DMA_NONE) ? false : true;
+	copy = task->data_dir != DMA_NONE;
 
 	status = sci_io_request_construct_sata(ireq,
 						task->total_xfer_len,
-- 
2.34.1

