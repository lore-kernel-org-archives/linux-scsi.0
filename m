Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012051.outbound.protection.outlook.com [40.107.75.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0EB291E;
	Tue, 22 Apr 2025 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745306561; cv=fail; b=hB8y9ztoqttGGRcl8K7zTuuDKqseNvjb0RQEEvnrpnwg1ZnvYghsmhY2lSkjleIW8IrirYYYyZvMQwxMgYfYgXHLrEwV5EmJWC3bBcamk5wLjk28iQ6SMmOF4bU5DhA80LD3J1WCre1ESYdPCohkiJ5+OPP5g2IngNcMRSRGxnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745306561; c=relaxed/simple;
	bh=C8nnQqdxxd0nxpqPQFhqxFTMK03YOfI3n2+I2M49aZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=poUQfTyE6bnkxBbKHDIy7wS3ab8rlOHh6MBAcZX2U9z3OZAjUJyifjajHpfGbIxTLl0keKZlSt/CS2Tg5U8eVuOXqwtdLT2q++69iniiRgf3tE2kZZ49u22d77J9jfned4qPqE2lxmaEfI6YJvnjdoKkIavW28YfxmrzwOg2M4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=mXY1ukjA; arc=fail smtp.client-ip=40.107.75.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="mXY1ukjA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvLS6OJadxFithEOh4cHP6Vxxkzwy2n4T5wnoUFaymgWO4KCkTUy4PY8qPxqrvsd52PXkbE6/9hV/OCD/MopNKNOdItV1z7RNMTzWJ9LcS9fLunP/n6qrDith4uL56IegBhu8zbpzpLIMclVuNTw1+ljCtbw1SDAKtFGhJSW/wpQfLUnKEd7Rt7A0O+4hjCMa+lUEqeRyhCLqY2/p2jQdolcayuJ58zZFImy6NfPejtB5efwucX6y/Dz3efhHb7vLR2dtu1VIutPc/HCDrCcPLrZbYIYRs7Q2wiCtEM7uVRj45qs4oaoOmukGBOxyBGR7WzwKsSuVuP+H78m+zCKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8nnQqdxxd0nxpqPQFhqxFTMK03YOfI3n2+I2M49aZY=;
 b=yj9GZJHL2VY4SUbX+2Jjs42w5ztBheUJulQRKswcW0dMwkFTJ/r+XDzW+13+ddvnPmtDbzlBVtYU47S7++9tUUEmpVMMo2WjbXFjNi7RrMEXAVcU70gPV/SxUk9dVaoMdnH10uFVyJP62T5hKpb27mWxqqxMyk1G5QZ8x46V8o8D9iBX19BQm9jSDA2yAFOvkHs/Y2esD9RgcO09hsCglcWT70nRnQRPIoxvN6GrCjxj/ViezpnX/Q5RZwWzIvd4shOlLrJ+XBnd0ebWzeHqnagvKYUGVth4ZkQV3Zdz78B+yigXFo1/VHdcK+LolCqjYL5G2FDWf+AAEJuCROMCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8nnQqdxxd0nxpqPQFhqxFTMK03YOfI3n2+I2M49aZY=;
 b=mXY1ukjATayKWeetwegw2en5aCLz+AMDDOVJfh4/aGv/vUKctgkG9k8iFeerxXoTRPqfB/t+AetDQjVs6PeXFEOgzc7SYhIoJBlxI4sFVbIg8Zl2a+jF66BR/porNSNxHtT9K8EFXPaEAdyOvr/losnv2ajKzTrpb1T70JkMv/ZfV98YXfdQcFGLm9xf/AGk3YrqC6jWlmhoWrqdoXPe3y8nGsihTgNC1Cmq5eLBTxjgr1cpTpFTXXC7uADpS8E4bnAyWj2qyCigcWe+tE2lEgfRbOzo1LoH/cu7ol7RqtCzwKP657DWwthg22575Xyp24mO3l5eTXfJlKTo8e/bHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TY0PR06MB5103.apcprd06.prod.outlook.com (2603:1096:400:1b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.29; Tue, 22 Apr
 2025 07:22:33 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 07:22:33 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
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
Subject: Re: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Date: Tue, 22 Apr 2025 15:22:26 +0800
Message-Id: <20250422072226.844-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <d78b244b-e032-4d6f-b6bf-87be2a98693d@acm.org>
References: <d78b244b-e032-4d6f-b6bf-87be2a98693d@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:4:91::20) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TY0PR06MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 32de4aba-95e4-465d-c56f-08dd816e72c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|1800799024|7416014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wgeQxUWfxSeLbqB4ABRwAruh/41UkAaqcJrRZmbig29p628+P8RMWjEqHbRy?=
 =?us-ascii?Q?eijUp2zSnBfGUdK5X5QrJWlbIktAna0chosknn6NMONZGnoz2cv0La+jiHvf?=
 =?us-ascii?Q?0IctqZc73CyU+ZSee/WA2BNihgIhbdjJTC/6Cny7Yyz3YRTCJAMeqDbUd0C4?=
 =?us-ascii?Q?KcAVHgK6U+44zGOnE3IW/7iRCdsAloKNnXC72TWL3pd0SWIMaBGTpX9zYei5?=
 =?us-ascii?Q?q49QbP4N0/TIAkKC83ijhfG5ih7R/8zwDisIJ27u/iwc/SCgxFILUrhGBjka?=
 =?us-ascii?Q?8W4+BvdzRo8m/uNaqzrjPfY/KK5BqYm6thgsvGYKMfeb2jAFcUIVEmnAAxle?=
 =?us-ascii?Q?0ZZhVCTeu2oT5m+bPKKx4ucMheX9yrDCx+9AW2S5s/gdJALp0hyx/KpBaEJe?=
 =?us-ascii?Q?ixavd9HoTI9chDYQIqnntKNqUUGDAePYKw6FycZhU5k8lCGGRYsaVVPR/GWs?=
 =?us-ascii?Q?JISQlCRS1thgopSN2VbbZIpi8NNMFdbuWIow29RQ+fOIPytX65EdUOVjOImn?=
 =?us-ascii?Q?UVHIHzIFMEL/u0agxFsvGl3iGHUGaAguRnJeoUbwTsf6cgFUistBeYK3DiWv?=
 =?us-ascii?Q?Ru0WMQU77HEZ9TGOxumhz28PwsrV5dQN7aJ9CXqXJkKtWZi1Bq0XPO9sPn0/?=
 =?us-ascii?Q?EPUEDEDk9mdfxPdKTgxM7LrAZbu9bUZEbRAsZjemHr7wgZ5P08xGDVIasyhX?=
 =?us-ascii?Q?Wop/W3SiEpnx57EtcolmBjDi6BVlg8aon6m29oN1qjfse7/Fy/R01uUo1CUv?=
 =?us-ascii?Q?Te9+W2HErfAXL20FYFPbHV84Dn5aUuQ0GY/n5oeontxBkuB4PQYsALQyBpmk?=
 =?us-ascii?Q?2qSGVEWv8/biQixqDJQ0nVcy/CY92kbBC2A2UjGYXzufyGsRmV+OvLbTukjM?=
 =?us-ascii?Q?KArNQYh4hg4RVMuHEvzdSfP1I/kqRkAnU/FcPh+9JBNbC04/5GnI/19jV93e?=
 =?us-ascii?Q?4vkGSK5NQRdcQvtl+VIW2otkzoQvz/jskNvscxRbYrDTAMPWRTBEFih6wkKR?=
 =?us-ascii?Q?oLQrzhOhoZpfevBCudMNDnTcUMsxh7nV0hDHsj9xzpMjFIA564+I12b+CMQK?=
 =?us-ascii?Q?7A0/hgXCnNDP3Ck1OyZL+SqCcSVn52pCi/AARTjowpTyRlUT/Nw5GXyzm0De?=
 =?us-ascii?Q?MAxbyxCLGBS0s21ZoLSOPyX3Y3d6XlTkc01w1Z3AUZ0smNLX3rxh8HV//ocX?=
 =?us-ascii?Q?7SNMMaiZetaKMI4/Pe2IfGhV7O7pHawrbtqAxoT3urNcdtX40k5kubGdl84l?=
 =?us-ascii?Q?eH+jlGs8H7y+V9HVir+kRYbIIAz1ze2Yj7zawHS6TwIEIeRPHOqfyxRPUJIE?=
 =?us-ascii?Q?G+KzIKStmPVgEaKdGTY0hPf1yIT/hl9uT6C5ecnbidbIEqK21D614guJ4ZU1?=
 =?us-ascii?Q?ZNls6LJSZlYmmdXFjkXiGNyBs+FKoKyRgh0yiRdA1WrWL574+nzgr6qRx4EZ?=
 =?us-ascii?Q?kVHRdDptgYXjYNMM0yJ1VXhwhzAYBQCQikhF/UqEdAuiqReWWYvcMvM739u+?=
 =?us-ascii?Q?jz4TqYM8dOYu0cc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(1800799024)(7416014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bzrhWuxSCnkc6Tt3LAZNgxOJaHKDg+AUEsPooy/Klu9JynoDgIe9SzHLsYgI?=
 =?us-ascii?Q?nVSrgIT37HRQukw5idcJvBXeWhCi4k3o0tzI3we90B55NG9wRogIf+f2jHat?=
 =?us-ascii?Q?4zxCMg1wEl60Ls+aFLEI0gDN//04dJwXBGbPQq+s3bdkRzFRgubDU9yEjb7l?=
 =?us-ascii?Q?GOG4rHHR5iyrPZkq53pXa5uAQBCAAOQ2P0auznlbZcAZZODD9azL8dsNVHXQ?=
 =?us-ascii?Q?QxtlqfFl/swH9bnoh7aITIcj/nPxkerdil2r+IOeufcwPhImLcoKGP5YEjqu?=
 =?us-ascii?Q?w3tLN/UUzR3wwn0u+f/SbM9Cu3k/kzKCn6eIoYZ4faz6J8onjVjYlDhQNXGK?=
 =?us-ascii?Q?RmRQH7MLR1/aFCyMdcruP0pi0SG++cLwVPFmZ9V4rePjflMoE9TdBQoh/7e3?=
 =?us-ascii?Q?UKi0OraFSwpfQtBsrBO8eKs7VNtpoc/SoD8V8miUbvtDyYyuno1rN9WskGsi?=
 =?us-ascii?Q?Yuo/o635EwsP9cZj0+yHYQbQdp9Qwbpt3vHifzD/5Js4WBGvVToQh7HJr7vi?=
 =?us-ascii?Q?xbQQaQktI4cig2t4WgpifI00Zg+xA76f3c3efynyRoQZDiPFBDkrm1DGee+H?=
 =?us-ascii?Q?09helAuaho2ZgcqCbzfSbp7YHQXuR9uTgzFeSroP/WbWCAETJ+s+BBvHnnm6?=
 =?us-ascii?Q?JOQsZx+acT7hlWWUQ2d8owE+sPF96YT+9etEGhMGkkfmoStF5ihF2SOXKf1x?=
 =?us-ascii?Q?6eHtY2EutbUfo1jwxM33M9ldXWtTUjgYfiw9FH01DAL36kSmRpDvngV0LoGj?=
 =?us-ascii?Q?TXWW+32Qsjy2epeklTUuOleXnO/HVhPJ3dULLvqiGLdHpdiprngwdqkNjONP?=
 =?us-ascii?Q?/6yzncWXZxt5v5LPPR+8wgExM86iUh8Eby9+3RZyW9a8kkBzZakIY7OdOphf?=
 =?us-ascii?Q?zdXxZV4/QoV+dT2DQVIsSk2il8nJeFXNXnVQKCYitunGAgCSglsDq/sD+D44?=
 =?us-ascii?Q?Gi8eUITNtq0nhlXIM/1dejfHmRKrYVc/Ep4bqTHUIcTIVqa5mQKWgKHk+Ocr?=
 =?us-ascii?Q?J2uB5kmWI4rAM3D2z9g1d907coMEaONaLvDErMVbu5fm7DAbAtnpKFxuEvlj?=
 =?us-ascii?Q?ZkGkFCJiNoj8Tm3B804uNH/DcC7oLakAkEpU1ch+izdCZEfy+s9soYXjaBIh?=
 =?us-ascii?Q?5YJKIgYC70m6fa0fYJ+0uMEYyLsH2wAMzEHr7FlPG3bfE2qFan0NzVhrw414?=
 =?us-ascii?Q?DgN5ne6+Ji1Cca93J10Dx7f0xpVvjeA7VuVorJWYmXYVX1VvQJfMZPb8azel?=
 =?us-ascii?Q?bQGoSKnFBHCAJ7+di4Oi7mAd5TsWmfyxnpujWSv8WqSncqtKNLOY1d64P+NM?=
 =?us-ascii?Q?CCLlQJYKyvxKyj4k5bFJ41iu2/DHdec7tnvQQ1Goj0mAdk1giRuEjNWc9F6D?=
 =?us-ascii?Q?d084Jq1j1Jh45W5l6dOHr+vE5vSG44+AFcYSjW2TVjtHtTJAu17jRBJb9tLO?=
 =?us-ascii?Q?QwV7kDBc/VCb6zM0Stz40B2DKI7rg6frmNGwC4BqPo5ZbQn8GJBR9Gg7IbRA?=
 =?us-ascii?Q?V4j4Mp/RoWQE4D47vrdiUFS+yVg7YJXq6Ij6TTihwvY0kqo1ZvixjlG5/ZuO?=
 =?us-ascii?Q?Bq9kSeC1ABrsg8Hc87vhCUTnEcCMuJ0lrTBjMmSW?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32de4aba-95e4-465d-c56f-08dd816e72c3
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 07:22:33.0416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nDEB9m7Yhijk5wjgWqWQDLUVkIVdBs6UnKkP1An7VMnvjui5fwJ0ZJxUrH122JKjmxfaC22DJwdrqRgu7UT/mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5103

> What is the root-cause of the high latency? If it is the time spent in=0D
> UFS interrupt handlers, please try to switch to threaded interrupt=0D
> handlers instead of disabling MCQ. See also=0D
> https://lore.kernel.org/linux-scsi/20250407-topic-ufs-use-threaded-irq-v3=
-0-08bee980f71e@linaro.org/=0D
=0D
Hi bart sir,=0D
=0D
Thanks for your reply!=0D
=0D
Thank you for your advice on the direction of interrupt handlers. =0D
=0D
The reason has not been found yet, but a comparative experiment was done, =
=0D
and the results are as follows:=0D
=0D
The failure probability is 7/400 when MCQ is turned on, and 0/400=0D
when MCQ is turned off; the definition of failure here is: the maximum=0D
latency is greater than 5s.=0D
=0D
=0D
=0D
Thanks=0D
Huan=
