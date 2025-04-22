Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013048.outbound.protection.outlook.com [52.101.127.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D701F19AD70;
	Tue, 22 Apr 2025 07:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745305469; cv=fail; b=PWUNi8etUGoZQEuCQRQLNQd1lJJAL89D21aN9Eav9Q/7aN2hR+63ZPfA5mMA1uTOVEIIN2nj962GzwuO7PtMX/wiQR6j+/wOmPak56lWJYsm8gLlJPu4xfBh2wImebhqQfpycR8V8dkq+W65sopO4VDvDkQdF8xPNhWCKLODW2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745305469; c=relaxed/simple;
	bh=aqHAyYBoZx1XjLmklDgpbX7hBYXXWO9ikZgWPo9It/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OFN/iYv0AQmKi7pZnm8JuQaLxuKLnLcbV6K2aU/yG8aRvleW8k8PieQDHWGmdjYMCxISiJOnp/hvJHCSFsPt8UrdkWN68siR2FLfwTDGoVzfX0YQi3AqWYRQqOFReBxvomYWvW43cr9RrSZfi7+loXgjjkZVxPUtyOY2N25TGLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jURyFIYd; arc=fail smtp.client-ip=52.101.127.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jURyFIYd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfhBUHRl7wk8gC7uDy++7F2tHfo8Q+gxFqOZI7oEwX6z1D0AAXt2w9uiQnVtVxOjQdLSYTegi1lEYBvjbb8CxO2xBSw7avRMMZ1zsfZ3s5oVsp3A7+hRqcQomHSz/kkH7m6FHeMP5+5GG3VvXWG2GO0OoeMtfYbpkJAwyKodT8Gi4yArbaifi2HVHBRCcHnGxRQThfnoC7FJLdDDcZdPw5eDWt5rlfatycgx56i5k996AFyfgDqYUcTrRxoBU8iYIJ/ycMA9KOwVpOE/ceitw7Cs2tsr9jmrvMiTn8laTGmtpL2MICQw590JKJEIvQO0i3X3mQXhxM8mOQD+YdUEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqHAyYBoZx1XjLmklDgpbX7hBYXXWO9ikZgWPo9It/Q=;
 b=w2EdAO668d5gKm97dwuov5SqL9T3ok8d7lhsS8vMsydFKRlD7H/KUdlqMTtNiyriUhraZeSRsd5nZyXXX2yfxEOcluHgDUP/BaNF60yLmBhIN8OaaBmNHxZyBwHHpw1OPr8eft7gFDniOjSwA0/xz736+EGHcR/pu9mDwjTilQHuVU4DANgc/yqD666nmERlB1YCFhwgcH7hpS9KXrNfvl51bBZWWdKhlGo+l7Y/KLsnc+DUlSOQ/hmKYlLtJz59mwleXZdkJDZSQrjxMt7VdQYeJbq1FLxFR2qpZza0q0otkREuUwZxATgqkypMYV9pRvdv427KmfPWKI5o24YT/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqHAyYBoZx1XjLmklDgpbX7hBYXXWO9ikZgWPo9It/Q=;
 b=jURyFIYd+z+obRtUmGP3BL/QIKBD/36TEmNl/hTp4D3bomWUWBCZKgcRDX+6HNbXdQ7hTxuwfOf2e3ZeZJe5uej7cmsZ3ztYn0LczSQUbKBX97bjLsYkUizviqMkd8f+I3PAMZn5Wd2t91lhnsUOGMTrf0EdutMpZwc5UPB3Eq9y2Qhi/5C+491JWifjDfV4eGCWDTtlby4uLjLIqqOg8hSXZxKTSPRkqB3tysSraEZD4TTkwxY+R9pCSG77hTTKKSu5l4XZGzRALXIesRhqrQM0uRoEEIEQpQrxSjZR0FEDedgvQWL6wJ5rACudUm6QgLtHvD0YehLXTBz+jywz4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB5920.apcprd06.prod.outlook.com (2603:1096:101:f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Tue, 22 Apr
 2025 07:04:19 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 07:04:18 +0000
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
Date: Tue, 22 Apr 2025 15:04:11 +0800
Message-Id: <20250422070411.744-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <PH7PR16MB619679B002E0AB4CD28CE93DE5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <PH7PR16MB619679B002E0AB4CD28CE93DE5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 14750326-2ffc-427b-61d4-08dd816be5ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iUOgtrxXRvQ2BcH1mBpj0XnzX8bb0p5+/UeVp9Z2Repv1YBMUZjHhx7XH3EE?=
 =?us-ascii?Q?02efSK/Gs5Pd5qcbzczL/4Dy2tizRKgMcfJ/IcXWWu2FE0O2k5Ad8vKvsXGZ?=
 =?us-ascii?Q?bL9MgzICPe3yjVqIL8SbmQm4bNsXwMMU/wTwmbEseh72UamY8DIinFuqgfbL?=
 =?us-ascii?Q?tBrV3F2XT9xi3cPAtl9FbMqpxkCq9aL+u0lQ+o2GhiahWJiO4gBhIB0DDepA?=
 =?us-ascii?Q?vwou+LvtJWRhharrTbfYj2RnssbYtLekks/ARphtY/Sq/gwwLBT3tLr9va3c?=
 =?us-ascii?Q?ctdiuEfMWOUkio4gOqs8u+Pr13YGzlKHmuuZmshWWaOhuNFrKoOvZ21YNVXv?=
 =?us-ascii?Q?S0p2/6Tb+iWnQKnrGhZaBEL/1oF9oB14d5buu3rjUk8epmdyAbfvaU7KtHv5?=
 =?us-ascii?Q?KZINlm6zEm7PsLPrgSpDEfN0zZz0fcX5sY8hFpT8Od48dTGKBpXuB2rCOcZr?=
 =?us-ascii?Q?kfxjlsUD37Mfp9OvQnp6mxC7gY6K7HjTIwbzj2keHsn866VKnCjB/Vq/KgwV?=
 =?us-ascii?Q?l/xXY2YwCOnqyYiitDy7wq1sqlgyYzp1o5MuC51yyTBBz5o3123h9TNOhuhT?=
 =?us-ascii?Q?+vf03X3G1QmXZggc/tLJBb84czvyKimVLsvSRfU0FSYZLnGkQr+F9Boq3vjW?=
 =?us-ascii?Q?bVGG9j0sh6O2pek0gAOywACXVEKL4ikrIDPWyWAFb4wlTBrXDXw5ewvUeviW?=
 =?us-ascii?Q?F1bdugD7vg2Bfl8pH/HIpDHPfT95YobMuA5A0PIgH/qxZCzdWKckNPXSGIhL?=
 =?us-ascii?Q?MGnZPUD6GJiR7jgH0ZgwzaYig2t3PgDOOz04Yr0BsP+LL9uKeA3jkSEahPZl?=
 =?us-ascii?Q?km9UdSPBDpzRmx3Q4lj+9grGBKWVS3MZdnejeRXbTIHYkme16g5nxsprh7n3?=
 =?us-ascii?Q?KnuDG88x5lSFR3KpySrYx516euhrfQlbGH6Fc1keohe6STPPL0SNZPW2HX/m?=
 =?us-ascii?Q?5Lar3VrM5jmUJSUbugOOgWIae3tFbieXHCRyjSrv2O8vbqUu1UaB2/k61rCv?=
 =?us-ascii?Q?/9sK/vMB/wMLV2rqvU8NWpr5uX1e46PiVMe/x6nV9nnF3r0Ej+xraD46BR0c?=
 =?us-ascii?Q?ZSly9PFJ5ZmzNV/A0R/2gnSIcy3aUfuCZfXSfY1gbBibdv4LHbJ+WNSD/O/r?=
 =?us-ascii?Q?g74eGzvEf25uKKqKOS/uLe1WkNty10js4P/RbtSUZ2auIr0TcYVhMLXtiZUA?=
 =?us-ascii?Q?5epwiawootxqWqcgKXhU2N9BxsPlB7sUR5ndVEZ3o3AXV8kPHgWM0ypoJVNb?=
 =?us-ascii?Q?qoxLlqJCGXp1FNdypz3AF82RDcG28ldYECn6oprxtIJbe8wzs7BDt6pndZBc?=
 =?us-ascii?Q?Kr1bmnckRDUe8tLul5WcFNUst3XgkuaShZ74H8aVpi2+JXLPt+Dvrx0437S1?=
 =?us-ascii?Q?hka9QTFbWTE1l3EshjxxyZVBZNzF1T5OIuEZnPpT1yiUZCxYxBPiGh4IQaSC?=
 =?us-ascii?Q?SejD3aA5Uzax/3wkBKdQA4kSA/ipr2xfqEt6GYv3l+nNGzdQbJoFHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7kE2cfWRToRpw7dIFHu/dRhonUVjrQg9kQ5ZOnrTm+cSvk7lV259lgqiMUbW?=
 =?us-ascii?Q?Ah6faIwZq6OHk9XDiOikv26GO5IetFGqgHkiOHxztQvA+S3W/+O0XTa5vZop?=
 =?us-ascii?Q?meefKEnPxh4VC0tPD2n+2b08YJ1hqCirQW+HLOcvD8d+ZkEqyWDIYvrpxLy8?=
 =?us-ascii?Q?MqZgt0YOI55upK0rVY3PuKAVbGAQiWWJrWD4BW6cyODHRReiXjbwKLdZD3Qd?=
 =?us-ascii?Q?Iwco79iJ5JACqY2uwcJ5H9vt9XnP1o5NQzrn1fjoGZfwm/tzgXePPahwhlc+?=
 =?us-ascii?Q?0sjGEH3NOxJsnU3uHsdiAi18eHPrliEFJAo0zx4TPPM1/AWxS0/CRmpr3EHJ?=
 =?us-ascii?Q?Jm2skcORNa2fueN2nNYZIfWpaBCU3JcXq5N+iS3Grn97yKlUC0KAGdDDYhY4?=
 =?us-ascii?Q?1234alvX+vpQwiI45syjqtbSV3/FO7GMi+sRuDcmLhlPa+39dBrgXQk23OJV?=
 =?us-ascii?Q?fcGxybaovohp7HcayNudGM0kpd2KfZ7qYel6yZOa5nk0mQqSELBPou8PIQ4B?=
 =?us-ascii?Q?lcShrt1iPH2gk9valizZp2TqiDe+qLbtyTeX7ObXmhl9Q3ZBtodX1Y4Nu486?=
 =?us-ascii?Q?JjZ0SLJbDvbP5WIQvRxtZGloz144eSr/mKJ3sMZ2S5A8ujOVA2Z5pziXnVoY?=
 =?us-ascii?Q?CAcrmzJhs3AjPFrwXqupprQ2z2vMAZjYXNj5qS0q7DPa+Bat8gcOeHn+TdhM?=
 =?us-ascii?Q?XjTg5owHDga2QCbILTadI+BELYFSPKuLQWn/Yeph1qQk3ZTQhnAKl8S704yL?=
 =?us-ascii?Q?tfydmBVnQoBTj55EqKDpQQWamvwSZ/A7azQjScQ0PkhhijpPwDNvekOHsZQF?=
 =?us-ascii?Q?ofWwkCsMc4Xk9DeYG7Bdd1X/i9Z3LApe/hYfNZE+15TXMymcu+9AJomO7fIR?=
 =?us-ascii?Q?KYL9mrxUahBU3bnmxaPCuWWoQpGmVqqo1ZcbGaSE4EbU3NbmHKhoRZsfrPA6?=
 =?us-ascii?Q?9lb7bzxRwUXiBqrmsj1SFgHhad7+58rdwi6jzoNJlltVicjVgninz2m79cho?=
 =?us-ascii?Q?IJ6mJ2qxPEVWklocdAdHCE3B3hZ+iSEhE3LF/2+Uby9xDxkG4EI7lew/eYQ7?=
 =?us-ascii?Q?27nhi+1RZgVcGadqMFi57BVxMo5yLLyAmsHnl3+Ys1i0ccmnUrGCZOwyENOe?=
 =?us-ascii?Q?4LxlDsYOeAqlwbA/hMrMqWqN6dCKdbEA9pvxhbT+UgUcprCAKJXI78skolLv?=
 =?us-ascii?Q?bGzVckqaLIYF7oi1Gu1wSr1yRHEZditXhud/LOm+RgsS2Yy127LvHMid0mzi?=
 =?us-ascii?Q?sAGNJQRV0zjyAda+GZJ4e75plsHGcAgQncuUMDlUzC3HLeJBsyceyCPYUrOR?=
 =?us-ascii?Q?nPkbdu/BvodXojZ1FyeO+HlcSPL4ZwXWIWzFO9/W2rw7n3tahiqCyzZOv4Ed?=
 =?us-ascii?Q?yY9imp4il/AFI3vlLgS7JCUj4lrI2Y33+ZhTQMbwtgneq6xBMn2vn94+M7+9?=
 =?us-ascii?Q?bA+sWSunbX/nZuBmR4jV7AcEy4iFXRHWfTU7UgbVvZKgUh4olhZQyuac48W1?=
 =?us-ascii?Q?F1LeDR4pj4WeoEsMss1ZW9zS/PeW8d+it9f3zNTjfGOMibkrQdDEL+d+0CED?=
 =?us-ascii?Q?3I6cGbL4bVKZqjXa1BpmKdASF5oRDQhT/O4XB52+?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14750326-2ffc-427b-61d4-08dd816be5ff
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 07:04:18.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzG1brakYBSZP6/1BJQYt/IwWm7eR2Ifwc57QcqAlRtq7+gd0e+OP21zJ+pTSua3S/9P8l/JwCt5JRshMJvokQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5920

Hi Arvi sir,=0D
=0D
Thanks for your reply!=0D
=0D
This means that the soc is UFSHCI 4.x, but the ufs device uses ufs2.x.=0D
=0D
Thanks=0D
Huan=
