Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013059.outbound.protection.outlook.com [52.101.127.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556CD230273;
	Tue, 22 Apr 2025 07:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745305620; cv=fail; b=fB0Vw+18JMM68gWTHCRoOaWNAN6PqkEfdrPaoui56uEhQF2+9LIt3PDGAwgGIipCakxdisZ+kp6A7ny7rmzmaS4cSAlJVOXzbZ3ILsIJgNOcfgNlX7NA4/LJXFi+aNERwmM6bsOQPcs4C33rDi/udxVxgaaR31LVIcJSW415qUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745305620; c=relaxed/simple;
	bh=S8e7269ZvkipNN9ZwaQYU9L8+W5a/xQJ4/Uw6vLs/VA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bye92HvQQnIntZgeCwPTl8LVFiNUa1kSewepfB4QYFdRJGmyNR2Xx+kRczdRH7Q/qpC+uacMcGdSNLO5iVN35zM8YSavoKD9QJ/jSTtXAYfzMIr2UUbn7eqBHg77g2gf2FKB+9F9yeDCfaQrDkHPsBP1aXRYXthSmRjSfDC57Lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=I2T4G3tI; arc=fail smtp.client-ip=52.101.127.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="I2T4G3tI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j3vyOJnWUih9HNiC0rApq7FDB29Mun15qRR1S3L6yKbKnzpYotdQ1FgpXAUcbJgK5Cb4d8d4JuSLkc7Tv7RvVIPA+syibdfDTsCXhMw5xVU3HwCSGGzUiscgQl0Jr40UoJ6n2INTpzPQ+22jMUoB95RWvBWl3t22GX26JDkpgfPejdWzfRHFgdWesIobcaAoOLFahwH+Cr26uLFyk22MIkbmFiFvoDoQLWcNaatmebu0lIY+EmsLvCRYTdYtrD1OXCR8OylOWV9KOYfXKTcZPUGmpBWjluDCil8cyjR7Z+/cYDLo3l7Iiuas7dwT+2AxRR7uG2QsuME9b69EM3YJbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8e7269ZvkipNN9ZwaQYU9L8+W5a/xQJ4/Uw6vLs/VA=;
 b=fxxqH0/uTV2HYV8RQGL7zpGNFilf//bv2PquisNtN6vQ6Pm2/ybQ3JPssbRKY3WvGCiGvnD8QhShukhs6IPbm8o1olKJKUPtEF6Hv72H7nihfoFKRZT/zuoZGgLbvvGuoTgVphzMZuQkeMBBpA0cL1CPUvZ8QWArkd+jeITeuIRah+IRmyvjpgtWACB+fiqKu8eyVfZ57KOUzN5HKwLi1tyw+jjPcpKfhCVyiUV9y3OPqlMi8YoY3yJQL4PTrTVPP1kXb8VCmWsFvOAABtvLHxhTbYPaFSLju7zAMQI5MBFcY50nh+9FReTSciKG6kv7/AWRebooXv2LHvqnOCNWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8e7269ZvkipNN9ZwaQYU9L8+W5a/xQJ4/Uw6vLs/VA=;
 b=I2T4G3tIOHMgap+pA/9GBA3YPhv1UI9Ynb3cb0qiN3akNb2eljQx9k4Jn12SPuJEssbYzDR8kaJ/wbiebHU46m2oezQjJ5z10ecxIR/NfjuBzK6dIcAW03wlKcX7kjYa7CvyHz3sCJht6FuQv3nJCSTkC6ZwTNTYrRPy5hpIdl8lxR2EhzC7jrLIb801/PNPsTEXvlT2LH47PnhrgFTtr3M8gcLX0tqnl4h/MEu24c7xI2k07qbNN9Ri0GYkp56dQBw4F4RA7Owf76j0mgfGBBExxw4fHcU8F5OFByeKU1Cg9Pt3HoR6Ie8MXjEo+KaKJgEyASwAtOdNP3kqI/17RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB5920.apcprd06.prod.outlook.com (2603:1096:101:f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Tue, 22 Apr
 2025 07:06:55 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 07:06:55 +0000
From: Huan Tang <tanghuan@vivo.com>
To: avri.altman@sandisk.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	ebiggers@google.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com
Subject: RE: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Date: Tue, 22 Apr 2025 15:06:47 +0800
Message-Id: <20250422070647.794-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <PH7PR16MB619679B002E0AB4CD28CE93DE5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <PH7PR16MB619679B002E0AB4CD28CE93DE5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 8922b2b9-efe3-4449-2d34-08dd816c4404
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aqTRLVbxAhxT2bwHaVPXpjw4XN4XJS3PTBe/Oe08e0o6k/5hGU0Nm20ngWQB?=
 =?us-ascii?Q?YA3mU1VguKWG0CW0FaU/t30Ro9DfzH/EYB5XI6JZE2Q+E5pJ0PkpLMNLSjBr?=
 =?us-ascii?Q?9dChSZ9zR3ZeMrsKU9T4izjpZHgzRpI/fjFt9d7W4Fz6GyJsHOzcvbCqXu4J?=
 =?us-ascii?Q?VzOv+ff5VMrQpDghu29v2LreblnLoY2rOQBzWRpz5N0dwwU9h6mIVy8Cb9zs?=
 =?us-ascii?Q?OvWuOAPRb6UZHvuDa+Q6kI263sm3nqmos2dXExNPsXkcJf3iMPeivrr2N/z3?=
 =?us-ascii?Q?ysvYc/DOBKw0dxQfjFwsOt1GD03C67HB9Tv2WhkXC/tP+bX6fAu1a+1Qa3NI?=
 =?us-ascii?Q?4ibn3GBe7sZayQwfoyLMl/V+0Ur2VBMF02ERqccP3Zp7ZhlCSr6uBr6dQ2NC?=
 =?us-ascii?Q?Cnp0ZJVmNHyk4S3We0ANfFCHFgpnSpneWUwYnd0saQiYyiE1Dk5PO5BGJ6kr?=
 =?us-ascii?Q?nNQmQnXP44gWDzlr4ocNCAQPf9W6ERBp5ypcvc9fUrzu8GBhh0R95mkKjyz8?=
 =?us-ascii?Q?r/S3Rg6EIHhTaYgF3w733ojO/EN+EIsiiTaLrQUStEaa4eKfIOBAY1SydnDj?=
 =?us-ascii?Q?PFUxkuCVtRkJnwAXj4OxgH7+7LcbNa5cb5OuhG42soSlRLhbUY09mJL72tUH?=
 =?us-ascii?Q?aDglEhZzkWlaX39uZQlKF1noB4xC/2RfGw5eEAWKcOqHP/kqQ+jUVQ9e678T?=
 =?us-ascii?Q?2CnUk7uRBzjTQklkURBbI5ixihXa00o0S++ZsDwyFOwOb/QtPVQSIo5fvYKU?=
 =?us-ascii?Q?EcPaKCmATorpsgju179LkxBjdjO49MhcarEC4sJJiV9H6OL0mUT7NtSrQfBE?=
 =?us-ascii?Q?lwVuQ+Nyrnco453xnV8Kvw5BnWPy5BqsdVb4H6LNwYgUKrZFbjFvtlPqbkzE?=
 =?us-ascii?Q?FHnG3NP+WtKkIcLQ2Wn2gYQk5uMrZ8PNyc8hqUsdL0iycQFm5DBL2Gtu2gi/?=
 =?us-ascii?Q?vxoA7yEoUCFTTtvJxXeBzcAM4sT4w9H3WCXnfZEF0iMQj4x0B6rwgz61rbPY?=
 =?us-ascii?Q?L+mxUqTJYtQgVnBlyv589qoG2r6JVwzfrAjce9GJEg9nAaMTetNsl140CX4R?=
 =?us-ascii?Q?YDf6K7DJ4ko6l0uMG7NSJ5rEecoYzVvtn0C1CwqmKRGdxDd8BxCPdAJ3P6ww?=
 =?us-ascii?Q?7d1LWNpH4JoRvdnGyfzzkXPhgbqOyGuIoFbqTL5ogXYkfzTb2S7QPIaOE+HO?=
 =?us-ascii?Q?d2XxlgblnU1ZtrdKyza0FqRlrJzZ4OFfXTro60u+lJ6JXosb1oFD5MoZvHbz?=
 =?us-ascii?Q?q9eHVBbTJLf4DX/b9bWkgRGOfKM4j4giDcWQZV6VGcpah6LTAz+gcrqUULsd?=
 =?us-ascii?Q?reI/C+ytg72i3IKqOyAVkgtO8X4EapkYcNVu6VHQ6vKwTJNS7sXyMC4v8jKr?=
 =?us-ascii?Q?HKm0WMxpVwIZ/DYgdD9vCA6b3y1YCoBtY1Xs6qTIIqw7SgjtU7aZr6/5oHky?=
 =?us-ascii?Q?IUYDtYIkjliGtuGmmdgICg6yBnUe7hpM0XU5/N65gsap9LGU/iwOoA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G3RwXrYknHvMLa/a+9/wP5spr+hBsNed8rN1/x6+mP2/H0VQ0oFy3qrcSiry?=
 =?us-ascii?Q?9rroNAIj+LTs3++2vhLWOm2E54xXKJAQF/N5ydEVdtVM8uKH+HYejMU1Eh8B?=
 =?us-ascii?Q?fJUZBYaKv+IgCktM/yPFea/0CD9wOVJNd0NVZAYqZAmQ9G3xCTAjvzD82tlq?=
 =?us-ascii?Q?k5jwDciIM3NdZtpXSE0QM6tfVD9ofl4Mn4Eh14QIVDZx/vOw31H1zuHAuium?=
 =?us-ascii?Q?6NNp/OcQ28Va519kE2AVvJSxu4tbYBQYoFIuEIBPl1Z6JnuqSbZVlHD9eOE2?=
 =?us-ascii?Q?azShgjKUu3/Riw3Bow7rHjZ1MpSZ/tEHOsYskP/jPP6Vc7Erlg6n+ni42Bcn?=
 =?us-ascii?Q?BCrumhblBXsXJYgCqOnb8plmlbgSXOnkg64SxzWBzp4NiqDy8JAj7y7yuACA?=
 =?us-ascii?Q?2XZPPgc+3O+J1Bt4lxWTDNMWa1RtxG4pN96Q7RhfPpATvPijCh/epMPwM+XE?=
 =?us-ascii?Q?Ye2JMC+AqlX1jzIfrWo8UgNSX6T8feQUApzTDxI5J1vUo3WJnwtiFd5Kt3L5?=
 =?us-ascii?Q?ihxtxd70xE4GT9EUvk/pcFBK2EwVj9YmBkef/lqQndJ8S2Qi4hcGN1JNGNlM?=
 =?us-ascii?Q?x1HRZgKNaRVsSzDYMpfzQ36/cv0je8TerOVWJGjEC6XXainQW2SlVrGa8qRj?=
 =?us-ascii?Q?QQEtpkueKtXxcyzS8amxaKu8WGhI36g/ArER5Jc4jhTh9YAvmMN1IP9Y6SWV?=
 =?us-ascii?Q?RxzL84jWQDW7krKGM+rWjGwstxDZP457J+BvO5noVFcz9h5Lf7MDxgwsvaCn?=
 =?us-ascii?Q?jDlf3JRN4HtlYizLSJihhFQeikaVA9evmeOcWh6zA0Mq49Zaq7gOIEJGEPO3?=
 =?us-ascii?Q?SuSF3/yZc1K3wyld3HgWldDdvYcEa1M1JOiSAMx9oh8GAwutvI3Nk1X6QErO?=
 =?us-ascii?Q?NrAKQk8V/8hzEMSnq5fr89O24MwB9kLBI46ww9GYhv0fqE1CNDCcJV20xaO+?=
 =?us-ascii?Q?8SY0soa55mzL0+pYJ4kxPOgjBoHpIIKWdnDZwNabloXVJhsio2gkLv1X2wnQ?=
 =?us-ascii?Q?ph3ZpM7ZRxR8bm0nr3s1TUV1BOk9UNJbTuDxX0aRCVgctMEyuY0gpvQG8x9i?=
 =?us-ascii?Q?WrkVU6tSltWl3w7k55miR0kfbBVuzpk6zYEsW3uM4PrKk/NEyl/eoat0wDzM?=
 =?us-ascii?Q?IUKpayEH/95McqDBySD/bKVxw9y3NMJkNWV8iU5ecc9rvr9daVgSeaQKH1Xt?=
 =?us-ascii?Q?Xq+cWhUjXvmltKf6O+i46pgkuGWda9RkrqHCW60mjBSYiQMSU/JjFOnF6+bi?=
 =?us-ascii?Q?1vz6Scre2eLmpzNaJGgVHx6O3l5dTzu6ky1bxGLsmt29FG7d3redXa4HJCzc?=
 =?us-ascii?Q?fYFH0mqqO24S4ftG7uI4hZok4Vb75mfplmiiKEgwmoGU8zkLKK2VNppIvBOt?=
 =?us-ascii?Q?JvXsasgmPGBTa3ts3ci67dcvQT+Nf6oE0gL7fp0HjMYDYeH9fd6UGwyDaf5K?=
 =?us-ascii?Q?LkFbAhJh8bOmaaKcAiTSXkgnz/CvmPp7OWRIe19+Kbk2K/Q54GvS7Mdo5Kfi?=
 =?us-ascii?Q?tcDnKPbAmfxC7aEd6MhkPWHZZaRttRJ0cIcLvySPxVuaLKzldK7Uh3H0aE9L?=
 =?us-ascii?Q?5N73aVXWeXRK9y3LeY9lpkGT55zCl5EC/a3Az0b2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8922b2b9-efe3-4449-2d34-08dd816c4404
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 07:06:55.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcWRg72dppO5PUBIxUVAsiGtsL8c+ycdgRwbOP71QudGdrnJOD/0uMV2SzjgO1smpKo+FbM3Up7G5wwgKeX6NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5920

> Do you mean that the device reports wSpecVersion >=3D 400 but doesn't rea=
lly work well with MCQ?=0D
=0D
Hi Arvi sir,=0D
=0D
Thanks for your reply!=0D
=0D
This means that the soc is UFSHCI 4.x, but the ufs device uses ufs2.x.=0D
=0D
Thanks=0D
Huan=
