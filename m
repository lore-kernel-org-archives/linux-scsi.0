Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013031.outbound.protection.outlook.com [40.107.44.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53376A94F;
	Mon, 19 May 2025 02:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747622330; cv=fail; b=rZ0kTmdGD5zUv1Qw1wXftvSW/Es+cn5+BfV8l7BhdgNdBIO4CVN4wiNcSXXqZooeuPsmgqzVK4QcWQKjIQpQqs7a3omNxk31R58X1bTlDRsivlG1yP3QG6QZGQTSJWqrVajCRIeVbvybbRb/hwMQqL7zsIvH0jhxm6CGJM6fUHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747622330; c=relaxed/simple;
	bh=dW/MN8NOk44sIChSHB8BPyJ8pheRs6ulkhwFlqoMQHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JsgUiBi+42qs6Wf+gcU5vtWNNkWs0eTlWE4lxDGe5oU+58TNpSIIdFTwRvmE1e34AkCgS3KFlga8ac+WuqU0vK9kPQ9fyN/yHmG4NaO9YnO7rM0nYj0fLxXyOHWLT7N+hLIdJIPodlwnzyf0KPhT3pcNWLGvgkPRJm41xyxWoLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=V6uk0Ltl; arc=fail smtp.client-ip=40.107.44.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="V6uk0Ltl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sp/cPXGgzIJM1utzVoPYRa/EHhAKY/Jg6Lp8cTeyakWaU1YtQFT7orx14D1pIdU2HtcbtlEAACjWk2SFU/EF5gcfVBBgVLLYDZMIfVrhUPI+pucJE8jqvoLQxXX28vHG6RX9Wg1DCXsjZ/Spu9OWOjE3TpHAjEHnabvrR8kERV25VMamE23Esc+oX0vO8OW35bqm9sZ4SgpLwUm3XzDGCYC264m+uAi+BRwFNElcxk0Cj3cMOqBj2Xp5cONar2e12lOea6R8RKvqZot4ROZar9MJ4d78IZrjHq6v5AQY9p5mh6Aq1m3uhsLlhIv12UpYowIytZave2BQir7rsAWwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dW/MN8NOk44sIChSHB8BPyJ8pheRs6ulkhwFlqoMQHA=;
 b=DMlCBvqEkTnTlPMOqLKo46HBGjmSAtRAWHhoM7AwT0gxOn6CUYcuteJYLKQAXDJxGrByiZkH9RYMWpSuk6AFdp1ZcgCbP/Lsu/WiF1NFn4L90hLm7E9d0GRXkoZPXhNNT2zmtYuDARc6tFUw3w6PHMj4TTAkS8t7uJJPVrb+kRZ6cAL8eCVcmV9RZgP6c087hTpwLX3CzzywLmhZ/jV9GdHvZuNqur5iaA3zjY1JRx1lAPfidlfaIET9bcoz0wAt/3PlclcR0WMwoli1m6qbbIGtB2iWz/IfxJE0mT9keYUckI6O2caDl5Ovl63uPc9r/DN5mK228b/OcmYyHU6SdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dW/MN8NOk44sIChSHB8BPyJ8pheRs6ulkhwFlqoMQHA=;
 b=V6uk0Ltl1gTfIySvhC3y1BYji4ZRjWwR4O/7RWbo6fnNpU5sMgM5di4tvtQnrM2XPMtGnn+m1n4Zbps1SfkSPgS8EqQHfcOm8u5N3QBSM9yJB5iAud4WUKoEsdJ3cyg1c8915ZYp8BYenMNZu75ersGWrp956Wm+sxlwzMSF1Ofr/KQQF+5w2bWQLKGo0g9C/LcoT480aq2VOBaSUX5TQ2hqXJOaalcKoD1SpP9ZIesdpz9jNz+4ZShJyVNIUfjG7To7iKRRa3XKLz5XOjNWuGZB+LiC/AcBeEYk6u4G6kXwH8nl5Gdshbxb1a1tpTdOhONSh6csPD2tjJFqzIiSdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYZPR06MB5025.apcprd06.prod.outlook.com (2603:1096:400:1cb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 02:38:41 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 02:38:41 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	angelogioacchino.delregno@collabora.com,
	avri.altman@wdc.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	wenxing.cheng@vivo.com
Subject: Re: Re: [PATCH v2] ufs: core: Add HID support
Date: Mon, 19 May 2025 10:38:33 +0800
Message-Id: <20250519023833.343-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <88718b2f-0583-4444-8bf0-7ecf9a45329c@acm.org>
References: <88718b2f-0583-4444-8bf0-7ecf9a45329c@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYZPR06MB5025:EE_
X-MS-Office365-Filtering-Correlation-Id: bba04c92-e6bb-4105-087b-08dd967e4432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?noj8WP2VNDibyWgNKrGQ/JDclntmDi8oDl45WqV19GpUZI3p4V8WVBRDXofY?=
 =?us-ascii?Q?TmTTBve0+jlepksWkNnVMJO7fglmvM+6PSJ9Z7z32Q5lLd9NfFb9b/uImOcU?=
 =?us-ascii?Q?r1CieuTRe9PDZc8jpmWyRNxVpHMa9qiAV0EY2M5IzP9vSKkcnxeIuBc2JM2T?=
 =?us-ascii?Q?D0zinHx5kJpdA6NbhP+gJdDuDBhOX31U5oVt5m3QEwhHhOYCYiiq4ZTlpTUc?=
 =?us-ascii?Q?qCXooeSo6kDozXtGww2LUU+aN2BZN0+g8N5h2VcJzRPpgzjHNwakF8PLvPd9?=
 =?us-ascii?Q?OejOCrbNjy6OD2GRxu/o80aIUUEQmgaBx6Vu3XMpkQ8e+VAqcYl+254jhlKl?=
 =?us-ascii?Q?BLtFNQCsjMUxy65PpnSadShne+nxcFy80VBQ8SzpvQybMvpIx4MsegBN4x9a?=
 =?us-ascii?Q?nd0XtQK/hyPUUtkEyPegq/99uomQiP/TFPAhmLlzadWRKcTlKG9oKFCriMxC?=
 =?us-ascii?Q?0NNBCSjECQF0Tw5ZoeEOlL0ABSb/K3A1qEP3aDkqn8ypARpCUIJQGnt8MvNG?=
 =?us-ascii?Q?qqlAWghfi0TE/brozDW4b5r4RXP66zgAxNV3TZQojldm8wz1nQVgO9dr6HwU?=
 =?us-ascii?Q?PWyrq9h8tv4wGmthj2zAqT1iBrlK87GvLT8Fhad80+SsqUWYVTvYyV1ykixk?=
 =?us-ascii?Q?GZu+vb50qJmOLivxnZiOPp5DfOk+3wj/FVBXaIKIx3HHkYJEVGNQQWcyBCzD?=
 =?us-ascii?Q?uv+5BvQBPBEzuZLzXPUMzoMmeN9CSOnJ2t5vHRDZSmEqiobsq8ngM3AFnSAY?=
 =?us-ascii?Q?rNEbCYi/fwg3nI2uZMw7FOr6E/1OxNKyHO8zJWUYJZwR/fjM5kSB0f8bEXS+?=
 =?us-ascii?Q?ZrvpuLhcjo/Q2m895Sbc6W9AhtNKukCFO2MD/P03Fvqgdv1VtTzdUe95ugCZ?=
 =?us-ascii?Q?yoJ6G7JzgAF5gyuiEUqyC6NvKGWBAmrartoAz0XOizHSiwwkictfbuBMBTJF?=
 =?us-ascii?Q?EFGYUrCryb/ZdzF3MTPd4KXJWjJoXyBKtJYo43iEzcDUOKZz7KY1m0y7Dlju?=
 =?us-ascii?Q?dQws9DJohWrLH6RIVU97Qdlu6JUezzB0Ctm28TA6rBLdgrcBEFKmMg36dK+p?=
 =?us-ascii?Q?LmMiYxRO3vfv70caX+1L01ouCTJtW4vE6BTAJgKiF0G7X8pKJGTE6iwukUCJ?=
 =?us-ascii?Q?U7RAUAGJb/ZTTpn2ySiEF9xaOvOS8qnr9Tp9UssESMoTz8/7ZEiHNcW+SH6i?=
 =?us-ascii?Q?JaCLz31BrPY7Kxrtn89ixBOT5d6gp15xHQxYpQWr6y+taCdLZP7zg0jOpdVl?=
 =?us-ascii?Q?6yP3XZbOBTWk87uLvd7GWxIJ62PT0isp5LGDcgQF3e1/HN1RLHCh8cGKa3Ci?=
 =?us-ascii?Q?r17IrBssLQjNDloMTmUiVMd4vvNpraxAb/Z4CNP25NDu24JLDG4RWlQP/V/z?=
 =?us-ascii?Q?qHfLQUPz3oGIpaKPF3n8fvyD2kMhrXvQKUaJ42odyF6x9klu9o4z87VH79tO?=
 =?us-ascii?Q?N6kZv4ulQALQpiWH3vdfvMeYhc/+pGHNhxHHPEjIBxaqpjW7hvHbmeUA10/A?=
 =?us-ascii?Q?jWvg58JnytW2pKc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Oxijtk6olMHojo3JdQmTvrMYdztjpTPAmRvxK5RabnHrViKlka0KtjO28ZJ?=
 =?us-ascii?Q?kWLzy5KDQrUSIrnAqGMUf2r9UsPKPoQ/nXhksAemC3doarbf/2VQUYfpjX3g?=
 =?us-ascii?Q?lnd4ZqM2VJe0vhvCB15NZ2U3agcW1Esxi9cMhqWctXetYjlVnyN/htXzuEis?=
 =?us-ascii?Q?ez2S6v8vpe36BoWxOrlljKHSy1PTHHUFxKv3QXP3XaxUUxUr4vBby66yQTLl?=
 =?us-ascii?Q?fZUxtkZ5c9BAdzKqAZ5pB3XRS0TAQDsZK9crC3SG1m13joAy+dYBJpnh3B2G?=
 =?us-ascii?Q?LUq+rpraeJdeIrX5bs5Q4/Fq5x8zUnorGnAnKsWdjWscMr0T49DIhtbS8Exb?=
 =?us-ascii?Q?F5Kuc3VIfzLDroRs7K2QrtB2YmXYjfFdS+fUF72rYCAoBnV1uHyW8B5tewks?=
 =?us-ascii?Q?t0qDBBRV97/uRrk4KOhTFn2M/UKad5QZgiYyOweq5yebMwLRyrMI/XcN8V6t?=
 =?us-ascii?Q?HqieYtLyT/SxIx9L1lBywfc/3jmefpoOQPCCGABQNTzpQAmw1iq6RSW7ZxEx?=
 =?us-ascii?Q?AhW1Apia1bvORdCMePgVuZEp2WL0zQMyEpegS2HU1nurgIPnqBhbYNBM4P/B?=
 =?us-ascii?Q?rz5wRagtZjMpNz3TwAZ8nQ8DCUs+rM5DopeqBRnnYXm6Ikn6TCeNIloJPCun?=
 =?us-ascii?Q?a10ymQO0c+z69nPj2FOkL1CGuOqkixjF5x6XEz4HV37tpK2TOVqcSwprMLsE?=
 =?us-ascii?Q?WTXo1mt5VU3Du2pczfrNLwmUsQpHsXT26r+F+7fATniHf+2y/f6Z477DQLVW?=
 =?us-ascii?Q?k7hJ12EbKNFQGnfeHDBEvI5/Af6UUriYgwKBJegCRjiPlBrNGCNm24ro1odr?=
 =?us-ascii?Q?GdsOBAY6/rSnew1QS1xrCDqIRPMBPEF8VG1ETrVxMBqMO319tPK1tMaPr0Or?=
 =?us-ascii?Q?4oPZ67Ro2K+5zNsdC1zDbLU/XTJPOloHBUDf+43s4+DQ5oePKTc9lsTpH2k/?=
 =?us-ascii?Q?QMMZhUqfp1DT23xkrIVjegqO55I6KKm5mf++5cpP3f1fPCNTFTvBX6AUSVW/?=
 =?us-ascii?Q?mSyB3NNvjly5rlcFcpeX10/u7QdG+u+7E7rVKojNCK2z1uSPunoCcWyhAtjX?=
 =?us-ascii?Q?/bOmNWoxi4zSP69ktWZWdQWMjGRAYo2OEa3HeGWkF7u5iH4qHgsJLK2R2lBo?=
 =?us-ascii?Q?aWqtkgyaP6NQunNeYOC2Qv53txxHqJNa+LYP7IfUliRLnsOnLNCU7nHsddXH?=
 =?us-ascii?Q?6OquggMzEqjX27Hlw2QQZ4NQQLXVWnzdrX5R35lKZ/xUM8BLu1a75eJi78LV?=
 =?us-ascii?Q?7YLpGc4nlfNzKkm+1FtDibUWQs+NBj8oSp1P0e06yCvoGC9413UHazXuNdKh?=
 =?us-ascii?Q?fzJTp0ThWpbhblH5EC+zgEndsEa2CukGO4tO/EKfCeEfvHLzxuNMiiI9S1xW?=
 =?us-ascii?Q?nQeyxQXUJbqiw8Pz8I17L1KFFgpLmJaodyX5TNHVH2i/BF4/SqvQtrFthjkk?=
 =?us-ascii?Q?BqWvqYA/RlhYAR9IwKYV8WIDNdJE2VSHbItDCHkmECO2KXJlZrhQGxbKqPRx?=
 =?us-ascii?Q?rTd2M2+HCxCR/aomVM/TEZJxOo4DwoPN8bSoEF1JCqxmo2W/uihyj8uElKwR?=
 =?us-ascii?Q?widWBK0mzvoc8+HVoBJUZnpYlqV2YBbUvHudNJp4?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba04c92-e6bb-4105-087b-08dd967e4432
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 02:38:41.3547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbi731w1LXw4hPpfBRHtLa+T4MoCXRfz59BIrGcXxqKUz7s+0ZIgcITaDA+WODrwwHdbH+l1crMyRizXa4mV+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5025

Hi bart sir,=0D
=0D
Thank you for your comments and guidance=EF=BC=81=0D
The v3 patch=EF=BC=9A=0D
https://lore.kernel.org/all/20250519022912.292-1-tanghuan@vivo.com/=0D
=0D
> All HID sysfs attributes occur in the "ufs_hid" directory and have a=0D
> "hid_" prefix. That's two times "hid". Please remove the "hid_" prefix=0D
> from the sysfs attribute names since it is redundant.=0D
OK! It has been modified in the v3 patch.=0D
=0D
> Isn't the prefix "ufs_" in "ufs_hid" redundant since this sysfs group=0D
> occurs under a UFS host controller directory?=0D
OK! It has been modified in the v3 patch.=0D
=0D
> Regarding the name of this sysfs group, "ufs" occurs twice in that=0D
> name (ufs_sysfs_ufs_hid_group). Please make sure that "ufs" only occurs=0D
> once in that sysfs group name.=0D
OK! It has been modified in the v3 patch.=0D
=0D
> Please merge ufs_sysfs_ufs_hid_group into ufs_sysfs_groups, remove the=0D
> new sysfs_create_group() call and add a visibility callback in=0D
> ufs_sysfs_ufs_hid_group that only makes the attributes in this group=0D
> visible if hba->dev_info.hid_sup =3D=3D true.=0D
OK! It has been modified in the v3 patch.=0D
=0D
Thanks=0D
Huan=0D
=0D
=0D
