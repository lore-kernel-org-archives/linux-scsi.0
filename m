Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1F3A1A21;
	Tue, 22 Sep 2026 07:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062413; cv=fail; b=k/+79gUPL3U0T/LbgKQvL7VTBV7jxIwZLCgYdFK+CnOOp2p42JdZuXIJPXYg0Me1+9H54sdMqEtcArVbVTSPepIhRpWq6F2uAS1WhU5fx8xCJnMyP1156rPzzABuN2jSokAzIBLeHnvEJ+sS2E/fmHVb6+veCpmXljHmf6eR8BI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062413; c=relaxed/simple;
	bh=U2tzVEz0JK08IWbV0s8nIDirr3fkOVae54aP0HVhR4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bth38lXi8Mk0OCqyCvlrArMCDrjLDQvohB2deEC176WYRnH0RFJVPt0AaGHoRoJCmlYMeNK5G7ij5/Fq0Zla7guDE30h3JwVasSHcOF8mb0zwES7VaTbERKm/JSis4ZziafRZnvJ0oUFdoWUXZFNOnQVTMK5zRmZYbGe7c41Brk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=fgmCgpJr; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="fgmCgpJr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPcE2JGmuN45OVBGuCEDkxub7wihu4kQzDXFm+M5q/J7rh8CH03Yisap7MHojLA0A1soXxj+nJn2MYre8XfCYDdFLmgOMKW0DcszuDtEun4sADAl3oY9B13lLArxw8uhzNJpV16xg0Qy4k3LguguhC0TkdcdtP4LtfmJcPBl/po+V03vQZi/U+cgSedLxSVzVwcjYy3TLio8YYAAzYjk51R4sZC0/GEu85G+HODk+9Hteqkr102mvngIrPtK/FBhSaDCQicW60uEyGpHy8wn2OUsaCmouORXM1g2I8jM1opU38HwvMdnxx1lz9+c0Z5E15aUcp+bEEN1RZn4v7tVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2oJ4yNhSpBeZuELzbBJ0Td1y8pC8lwDln4OtsLAUXW4=;
 b=IPYAmhn+2GaoLDfILtCVNzD/aBEddzgcsIxbchL0YCO1dT0OPP5JF7b9lX/uaBtgPMo6ObQzbN6F0ezcyBJpnjIpwxfKFz+j8ATI6ghRpxEqUa5Lb95NkrFtScZhp/mRYQB/XnB2wDV9mdJH0kFyPqbMw93X+RjSbJeFsTDdGfidK98Q6lpohI6x4ewLkFk2KamfpJ0lupBwhA513iy+ghRDIVOr5tZEQfIAkBYzAWwqCh4HFM6aaz76V3shQIVqmsd54Aem/YgHM6F+0MVTVaCjDRcd2Eamhi2EnrWhuTFLuF/A4AQ9j+Q72NCco2XUYLCuHdBcKXB0ZRSoyfH/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oJ4yNhSpBeZuELzbBJ0Td1y8pC8lwDln4OtsLAUXW4=;
 b=fgmCgpJrcW8gHy4dEhFsGHkG/D9Z8/wvygcXo76luE32z4F0twZrPBtvCFv68dvtiUKHitkt/HDoVOCUz98Qc0A6m/qCS4KswkQPfgqfg6+Dudny+ClQrMCkhGKnunJk7bf866nXyer6zOeYdNA/rpZDThCExyMujTmAksOT0Kwzf4qsy4+zLmtFLSYLYREvQsmzAfA2l9JvMOVvZ4kUxqrOtu6J/JusCnnSpbvyejR0KW0bIymmuXMnMrKHo6iknIrkZs9HKygwBwqZ1hQzzvb3Xc+H6hre63I4hzguaNuVbTDbtLt3Q82lF9BljwpbqMMZ90l3Hz/Wg3kac3H2ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:15 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:15 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v5 01/12] scsi: ufs: dwc: Return a negative error if the link is down
Date: Tue, 22 Sep 2026 09:29:58 +0200
Message-ID: <20260922073009.1449688-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0017.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::27) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MMZPR04MB213195:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e722540-f7d6-42d2-ba47-08df187bc3a8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Z1D6fKMQdyOaHsHxyQsfL4VdO8sp2VA3dh8Y+j+qsDyO9cuZP8v2G/kD5qOaaCMlS3/5W1Our1gsUXR6zopIMO4cnCosMfRj65IXnEDb1xGp/CtQt3sm6hAIDTSInuP9YyyFxAY7XQJuGP3iIcAgS4eHo3FjNNSbL4Zj6eFK/P3ECLxnyhN8fewOGxmcnMUJt9R5r6SVqcguygmA9Fjz5984HtOAjUOhSAZg8ssHwt0cF+bFasP9Pei7eu0ocdRB/is4aGFMWGEUbILMEObcb/WbuIEr7E8zcdGti5jD4S5Pc14zN4Be7eGSXFKiesAD3FR0k+3lscH5O2/sOjVUFXZmXPZV0Els9PrQm3ibzlamHkl7tNlaraiPU89JvMU7cQ7XmPQ7FTzQ6Uj7a03M735jASnv4PNdlclnjtfH83sKLUwAtxQOXdY0lbv9MXRes1HLNCi1VwEW1VLFqv9fUXOXE/Lf4B5sr8zJEXtVvNuWM1OFiWDiNLZHPAEK22q9u7sZo0a5UWGiswpSK8ppQmU+LZU/U3T3Yh2qh5S0QPxRKj1HQUswbH49wu/+m/7YtIXaU1lhBAqJbQo29kb7jdL1as6841vw8E65MlpBq5GezfCv96BluwbRJXjROhuCXBlc/qLY8gbxAETXG++753SV8DT1zKy89mUeyPTIrwllFbdL5Mfn3jpnhzXTZnIuTWy8sDt6HbvL+VFtDaMCPg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dTVRdWN3U2FMVTI2azBJSGNvS21qSjE0WjJjUDFENWR1K0p5cVNHVWxPV0U2?=
 =?utf-8?B?bDVzc2NpdG85aVFFeE5aSEVpT1R1blhaczlOcVlzaTZHL1RlZGJzai9vSnhx?=
 =?utf-8?B?V2xFdjczWlh4QVlCMklGMFFtcjAyU1RpWnJTK2FpeE9QcUtGRm14TnlEYnh5?=
 =?utf-8?B?bXBoVjdlL1ZXdkl4KzhjMnlEVVpSbHBSSkdINW5MdHQySWh6MEhIN0JWaUFj?=
 =?utf-8?B?bHdKclBBNm1hT01jMFJNcGNEb1hsWUhFNkNJaUJpQVJUb01WeEh0dHA2dG9T?=
 =?utf-8?B?aFk2OWNrR0tlQzRPOG5RMjZkTEVXeTNmUk1RbWhpUXNGWnVEbTByUXpqV2VS?=
 =?utf-8?B?UzBWNDQrRnpmMEI4dDRpalBURjdmWnljRHBGd080WHRyalpNdnptK29EQ3VJ?=
 =?utf-8?B?c0xCLzhYc3cyalF2bWxqeFZjTlllSUF2MC9OZUQvTGtVOVRoSXljQ0pDWklp?=
 =?utf-8?B?R1p5Y1V1NnlmQlJIZ1lZMUdGdTYrbWM2WWUzbWRnenFEM1hkVXZBU0JLdGtP?=
 =?utf-8?B?dmh3aW9tN05ZUkhJb3R4cnZjcW9nM0YySVVFUHE4RzBGUlJBS3pLU3RUZ3RV?=
 =?utf-8?B?V2ZqTEZ5aVMzd2UxS2JHSC9xVVBqbExpcTgwK2NzVmkwS2lyUElzNXdiYWtn?=
 =?utf-8?B?YUU0UnlnanZSOXFGdEgwVVhuaTBRd1B3d2tJU3lhZ3dleGYyZXQxbk1YNCs0?=
 =?utf-8?B?QUxOQm9NS3VPaUxjNng2TURsejNqYzBQM2paSlk4bUpEVWNoejZRb3VtMHRP?=
 =?utf-8?B?V1RGYVJQK09vK0xmU1UzbVZmZHlFNjNGNWcwRDlKODRhWDdjMkt4K3RnYXor?=
 =?utf-8?B?Vld1bFBqY3AvUExIU1VSM0hJQmdWWmVabkVLNmtBenRWaUR5S3ZKQmxrTWM3?=
 =?utf-8?B?akhrT2JtamNKMVZNak00aWJMQjhSRUlHRzN6RzRRUVJOVE42T1kwV1MyMk1D?=
 =?utf-8?B?NUhieTNvanp5T2xPeTdKbnhPdEg0ZkE2V1B6V0FrS2cxMmJZK0o1UFN0Q3B0?=
 =?utf-8?B?RTQrYkFZeldkOHJNWG5VR0RXU2o1Y2dEc2liaW5zcUJNR2NTWDdFZ2Y2SzBu?=
 =?utf-8?B?aWZBajl1MnA4dk9KVmdXS0hYcWRBL2FoRG9jaWlxSE0yYmt0VDVRUnhCWC8w?=
 =?utf-8?B?dkduS09zWjJaYjI0NVd4TmlRa1RzYituNVIvMjVUV1p1amltVXNDQk5vaXgz?=
 =?utf-8?B?Ym12a1dlMTVIb3NNVlZkL3FpbklrYkZDM0NEbnpCMHg3a1J4T2RtNFR5OWUr?=
 =?utf-8?B?WmxXMXdHc05oVHdNNjRsSzJCaTVxejVEbWF5dnV1TThqTElPa1BWb0JRcy9y?=
 =?utf-8?B?YWtKamd3STlQTTloUCswQUhuWjZTTzQySzZNc0NKWTZYRHBkM1ZhajgvVm1P?=
 =?utf-8?B?VWhGcmUwc3BXaUR3VEpLbm9xZXhuNVFFV0MwVWFta3F5MEx3clYyeC9POExH?=
 =?utf-8?B?L0M4MGt6c2Y4WjNVQnpKdnFSQjJZdkpRUlFkWmNnWnRicVIzVlRvNG1LZk1J?=
 =?utf-8?B?cE1EamNaNFUxdnBUWUlZaGpqMFRkaU14RmkwMGNoeFljMGJUYUUzY2JPZ2Ro?=
 =?utf-8?B?THIvVlJaWUN4ZTYyWDBuNVQ5MzRHT0tsbUkrR3BFRmloTzdEcGs3MDVVYkcw?=
 =?utf-8?B?cG03Qlh0cWN0OTZ4V01sa1FSZnRNL0d0alVlcTB2WTRBRnFTb2hQNlVUbnlC?=
 =?utf-8?B?cjBsRmFkdHZzeDYrZDFxL216ZnFLUU93K3Z4REJCSUkyVWNYdmJ0c2RNOHps?=
 =?utf-8?B?WnZVLzM3VnJZdStlU1JFa08ybXh4MmpUcDltbHAvYXF6Tkc1N244RWtxMjNv?=
 =?utf-8?B?UlMrOTdXTTV0VFo2MUJ2dTlERWozSFd2dkJ6UnNxTTlVUGc1MEdjMUo2OGhT?=
 =?utf-8?B?OU9jVFlNT0VTT0YzaGs1MmxPRFVpZk1OWHZ2Q0o3K25vOGZLbDZjMmZrUml3?=
 =?utf-8?B?ZjlKczh5eWxUYzljTW5GZFVocXpNQisvaXRGQTdTcjVUSG82V3RIeE03UnhG?=
 =?utf-8?B?NWRRZEJ0bndkbE5hTjNtd0p1RUZIbWQrM1RRZTBCZkhFUjc4Z1dySHB4T1Rv?=
 =?utf-8?B?eGo2dFhEUGJRb1Jhd1VmS3AySkx5N0JwazUrYWhua3h2VnNnYWhxc3lhRTkr?=
 =?utf-8?B?eGdCSUUydnVpRUtTcm9xTjZrV2gzbEtRQVVVWVAxRCtVTGc4NWloVXhlSHJY?=
 =?utf-8?B?NTJISjJIQVo5SCtUSTFab2FONHhzMnlzdUNDdkxEMFdkVzFzZ0dyVlgxeEQ3?=
 =?utf-8?B?SDdOU0lKdlVyekdKdjFmTmdlOVNjNGc1bWFKOGxJRXB6WHVoUVJ1WmZFT1A3?=
 =?utf-8?B?SFR0SDd5VXVGM0ozbDkvU2Q4dUswZDBHbWNFdHRvSU5UUi9iSnpPUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e722540-f7d6-42d2-ba47-08df187bc3a8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:15.3548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6Azgu7fb/9mhCXZXzX0txLqVLHNBmS3Fu1/DrG/w9D5pQRuBUI+74pXjHJwM4T3I6vknc1gsP+d34eIx1dJQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
value may propagate through callers that expect failures to be reported as
negative errno values.

Return -ENOLINK when the link is down and propagate errors returned by
ufshcd_dme_get().

Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..ccf785fce6cc 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success, a negative errno value on failure.
  */
 static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	int dme_result = 0;
+	int ret;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	if (ret)
+		return ret;
 
 	if (dme_result == UFSHCD_LINK_IS_UP) {
 		ufshcd_set_link_active(hba);
 		return 0;
 	}
 
-	return 1;
+	return -ENOLINK;
 }
 
 /**
-- 
2.43.0

