Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2051.outbound.protection.outlook.com [40.107.117.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B7A1993BD;
	Fri, 11 Apr 2025 09:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364276; cv=fail; b=Sr4vtjsNBLg5eaP9melfNWP/EzbhBjbTciBE8wGaG/aTIK93GCTVj4oVEt9m3AbjL6dRKeKD3lsiOKuzLqV6YHVZSIbujubuDUYaA+Nk89fkCcBnx5ZWGkoQgn/g6qevX94IaoY7eiLJZ4pTG0tT2ShqA4kcNZgv6A5BkT3qwJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364276; c=relaxed/simple;
	bh=6RhTCxfQmVf/sixjUl3TGwfyMmke9N++uoaK/cre8Tk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QDF6n3N2Bj+Z24/thKbkgYAVcsDOxFq/FKmgE/wTJXUrybrGzbFYhtJx5fHcBwarbYg0b1CosWEFofacWpGfS3XoXoimtYbUjxa4jHLP5dhWlGt3K5YbuJ2DRTP4nea5wHMLCfyBWvXiqJXhc5C2isZpkrtVI8Kbr4+pK6lJ908=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=GuSuCoMn; arc=fail smtp.client-ip=40.107.117.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="GuSuCoMn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8/DuyBqS/+hzc8LEAEsvKIe9JpO9KWho09J269qpU7Du15FjAuSx+dDVKR0TE8ET355PoCBHjNZiOJkKVwTF8g7sQMj+w2P8AEZhH0l4noYJGGet8BMffJ1PDWuNd7b9mSolL8ITuO9/LCsG/KTb8bImQLpfU9XgYtZEjyn26tm5+v7Ni1GmnMUcOhE85LE77v9fCwcpce3sF5kcxAjCJJLRsd76WEyyISoFvX0XI8RaZcFxO0fU3ICJ0FY9O0+u6t+QvEDnb7eWXe912q2XGg0HODDw1AfozRFiHUvF7nmlzUrXav2ZMyvmJbG2I+gT4mj3Mi90J03ybrBG9MOhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RhTCxfQmVf/sixjUl3TGwfyMmke9N++uoaK/cre8Tk=;
 b=Qn0lQh4xijyrJkVp48WudiEH+FM1fHEQmKp1Wcw94Utvx0jbRQQq1Qxx0z73DVcTR0doAkEhxQK76HtAS0BDnvvL6cufORT+YPNEZP0SJjCYu6vQh5srDwlQ/jXmSGsmJCNxJ+IynfQ8xY1gjFGIJVb5fMY54pFHftM1ucbAEEliVEFlQ4mgGCrgchQ/pbhYL3hTT0IuispDIwTcpNsi5r6NMBowhuGbXT0eJ7REtS6c8wEAVJlsEKokatM5WwlUVrojNzaUg5SfgGl5W/WZv4dIEbH0xulwyK5Gr7V5pdHppewgUQcOcT6JgctnWOoL8gQlqPyEVm/s0Kvp7xqhyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RhTCxfQmVf/sixjUl3TGwfyMmke9N++uoaK/cre8Tk=;
 b=GuSuCoMnfwas7udEKK1AbKZrE4OdU6Lvkk8GV8xSlIBL4sjv1O9BB7QCJ4CHc7a6iCp6ovOhAViOtjgXygm5SfaObrlAUAdcGg1It2j63RMewB6X0ZedI7FmAzmyYhe4Y3QtIXQuMy4pWJJVrqHCsDeeE/zuSQF1EQ8P1EpN1TBFOc/fyW+3zI66bPN+6BxkU72DF91m0Ifr7zY1nxj0jRb311hSZFibQvHL2Pfc3nzzvWbNWBw5a4LacGFhRFurFrXvC9kAPEChiJDJNS1maNbqOhWqGRAi0IIBnBksVsuQP+ud8pyXUlGXSKii26nv0A8hot8arzS3kV4i/kyGyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by PUZPR06MB5852.apcprd06.prod.outlook.com (2603:1096:301:f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Fri, 11 Apr
 2025 09:37:48 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8606.040; Fri, 11 Apr 2025
 09:37:48 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	ebiggers@google.com,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux@weissschuh.net,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_cang@quicinc.com,
	quic_mnaresh@quicinc.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk
Subject: Re: Re: [PATCH v10] ufs: core: Add WB buffer resize support
Date: Fri, 11 Apr 2025 17:37:41 +0800
Message-Id: <20250411093741.1212-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <4ef0fe17-c30a-4d15-87e0-35f0c0163e1b@acm.org>
References: <4ef0fe17-c30a-4d15-87e0-35f0c0163e1b@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::19) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|PUZPR06MB5852:EE_
X-MS-Office365-Filtering-Correlation-Id: d29fb0e7-40b3-4500-637a-08dd78dc85a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|366016|376014|7416014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w4hIj+0AlqxscIyVMp29zvc9Zg8GhzfnZSho4yW/ZpxgDNeOHfWjtKEOQRrK?=
 =?us-ascii?Q?b0sYWSFw1UyJjFWOzE1UBe+M8uZTNaVWNNpJBpub+T9NzFXvIo9eMGp1e0KR?=
 =?us-ascii?Q?m/CrbzV/8jMFUnm1gX3Y52iPbHaG5dnv2ZIv15MuOfMSGrBoM/1VO2bg0e2D?=
 =?us-ascii?Q?o0f2X2JftG1yS6JqnSQadHEZ8rlPrmUAJvHhbDVJxrN3PW409n4JdCG3iNxa?=
 =?us-ascii?Q?zuGd75ERqGcn8ZJb4PIwZJI9jqb6pnzvkHr/bDQakpFBtZLc1jQ9jmUxzVEl?=
 =?us-ascii?Q?oGDkg6JcrNqJ5GQ6ELwyAJL9rLfuMBfsKH77DPuTWG7Tvdj2X1Meh2vtHBuA?=
 =?us-ascii?Q?6rdV3pFZpVDPujEk/UeP3TKer+rVkdpSb2+IImpJFvon6o4LuKYwbPF/tKv0?=
 =?us-ascii?Q?AV2IFVOG4OdbQOz143G/sBMJTQ6iOaLNEqBQ0OwlNSiZ4SYXVh14p9aoUJ94?=
 =?us-ascii?Q?rCs3dH5pKgAZ288RFkgByNTKkhCxSKv+jgCdgZoiXJPZN0mfykcHnnU8PdE7?=
 =?us-ascii?Q?FkHlgwEqE5vWxhqw2SeEH0xi21k3Bqs7k/siWoP6MBE4jnsVv7yhTH6imGBs?=
 =?us-ascii?Q?R08hX4+aRQ5ONM+1k61BXdsEulsx/OtiAPDxCuzP8V8kwOsMTZ5ihczjXslg?=
 =?us-ascii?Q?A9ZiYoMKPGkEztGk5xZ7XzUF8b4eZqmKftFJc532vbthfFdVmh9s6uFr/wLv?=
 =?us-ascii?Q?os4UMbZQDQccU6AhhwZkVCvl1obCiuUyrAXadNTBihPthy5oxLPv6W92ibB+?=
 =?us-ascii?Q?s5q/U5CeOiD+3/cssrLmzm8wDpzazGN1BVMlrPDf2YCSDQ9wrfX/9VqkVSwg?=
 =?us-ascii?Q?n43G8kFt9pv/BLbUmSouDAtzRQyvvI1Th5w4SbLlVDeS9+2rY6VzsxFvJ6op?=
 =?us-ascii?Q?o86AcUcrUDK5g2hr3ReZuJClXCUmrfupETZe326Viv4/2BB0q5KhHo3R5VvH?=
 =?us-ascii?Q?lCWcsURyoqEF5h3DY5WGKGWKRb+OluPP7XyHQRX0ibfUw8nTJd7eG4swusUP?=
 =?us-ascii?Q?a7YjHzQPlnz23ES4xQudW4ltnCGZDffa3OS5uOPayDcnHvwQmmYWWQutN6Mz?=
 =?us-ascii?Q?agDSYsiRFdVaV/HedIoqDkoYlvhiB3xDzsidJT3m5n62f3AuTgj1dflpqVIm?=
 =?us-ascii?Q?nGEHmP0+/x4vcSeY/2BcrrvcFsC84HjUp8z78cTzNb25w6nvkAqTZV/Eecht?=
 =?us-ascii?Q?M+8OD5Nt/lokHls5isjWkSPSDIHqvKC9l0D7qeIwlW9N22TwqJKMi3TQIFfE?=
 =?us-ascii?Q?gcMMi53/DMgPMLdk11n+lCNOm0IF6orpNGUAQPZC6p9S3SXMTB5P5o49/6Ve?=
 =?us-ascii?Q?xCwfElxj3NyskUtiAgivJxlen0TadnNemerpHJaHxr4iTUXTmlm+SdI8x4jb?=
 =?us-ascii?Q?QUFD01VkE9VG6tJHuVW66yg3PiYFOLRuKQYWqJVLxpyWAkcuzdmkfYPGEG38?=
 =?us-ascii?Q?+3WW+Q25Um8MTXwkw6KTJPmbwz4QQiZ4PNssPPxIxtruN2LLxB6Y8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(366016)(376014)(7416014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ImS776VoFhv9Lx/CJVyw2cwZUuJURI/MndPPPjzpRc1DgZfxqjrOxVjEpz2W?=
 =?us-ascii?Q?60EQm6AUprAOC+Ak4RxSgzZFtF5DmIbJRlDXQ+PZj7TGH9hxfLRI537JWUra?=
 =?us-ascii?Q?+BkawpduCfA29ZL6mwXsB9WWG+U9zqf4vlcIcSPR2YzweHIAIVG+bvjRjGHx?=
 =?us-ascii?Q?K2RJgEbZUUaLfXDFS3RMXVyq4YuX4fOFk8n6rRtMkTXd+6c8cVosmEreFBNG?=
 =?us-ascii?Q?ljE0VY5IODug4w1DZ9PJe/Bw5izAyZpw5rwswzDvHIRarTqlGANsytET3A2b?=
 =?us-ascii?Q?KRvY/W413p+v0WNB23m/bNDvxW0WD46TYxOI5W+QYenLkeBmjf7lwSfASIhd?=
 =?us-ascii?Q?MBoBJ2gqqQtvbQCUxcJJ9iAXJleF77+RTapuNaVM5RtMK+lzppM70Zf9bGQk?=
 =?us-ascii?Q?+bWxWKHI6iCxnfjYpatlbRE8oxFSje0mT10iOICl8B9jqcBHgIjAY/lRcGco?=
 =?us-ascii?Q?cVMmS203IC/vXRUaqwzDKM+NDu2gH8IklzHtjuiX0LxNvlOZ+DG+5jYGNbVI?=
 =?us-ascii?Q?r7r6wCgKRBLcI8ICAEH2c4nqloaVFYL/Y8GDHWvm01PWwA7Jo5KuXvSzlosb?=
 =?us-ascii?Q?VGrG1eC/iZPm41pfarn4e0+xDL52WVbAujDXrDOc5NIFJrOEP0S/CTjEiOPM?=
 =?us-ascii?Q?nIVzoWbaxRlGYA+zpX5PTm8JgkOCFbjnONesFnoJ3vocOpNT8iDUYSsIAzsV?=
 =?us-ascii?Q?GdkFCXTjan/y7deCIqOr8mTxI2tPhY2Wq9LkQm6yTNKRMg9KCoGAdJJPqRPx?=
 =?us-ascii?Q?lcJCiyOfrAx12Pf7ymUFAuisSFyBt6i4vUYyfZxQRSNq/bOCTg2KcotyU8oP?=
 =?us-ascii?Q?z2c1d8WzwZqt51uC9x6a4Wgquu9nTraXyNT0c5WZKrrCxW2zomy9lovkFgvI?=
 =?us-ascii?Q?eEGOyBMtwF5TbbmFQx01Oqq/cfIvMRn4cWCzuN3nqGdRVf9ezEZi1ISuvTfj?=
 =?us-ascii?Q?AlXJo1RK1gfQJUlxTxlaeAHVSmkHdKFQiCYVh80s8lwm3irTDpkagcY+XkbS?=
 =?us-ascii?Q?r8EZPVX7BMlYxEXAkR0UHO3EfmTZJdUXNY0W9O2N3Rt9jcUhp/M84AA8PHGE?=
 =?us-ascii?Q?2k1k4MEJKKs78bwYEUqV0LSAi/iOKhv4mq8WNK5p7e8tFUPHGOu0XcIxHQBP?=
 =?us-ascii?Q?1hGLQ70Z9SsFqT2GBvojQLnXc6X2Ey2sd0gALUQe+mvsUz4oykiP2jdJ3MYf?=
 =?us-ascii?Q?YbZzEvifoFfcRA8sf9oVCQB4yjVJ7qOx/th0pD4qlr+NssIhW9hpZwV1TulR?=
 =?us-ascii?Q?q+W5/rFNpBGCmszqjCOCE0cWm1xGbuU3XcFe2paR7qL8V8QLn+caikLhRaI9?=
 =?us-ascii?Q?IfdpBmWIxTdxZ6d2U4lEHmcn5NlHdsC+jwmk347YX6ffhw+XwRok5i0AHf7U?=
 =?us-ascii?Q?GmDrs5AzX2mUpz+xn3lIQSw1rMhzEyL6ADuk3kGFd1X+UQ1BTpSzMCWJm/si?=
 =?us-ascii?Q?Ew/Cm5LifW20pWEvfU+mZ/sbIelxWB3YsWO/j2WAQpdESvUZOg6fcwrRnMBP?=
 =?us-ascii?Q?dcFSUXxnR7M6SDTd/SITzenhVJyJZfa8+62bqzmuZ22EDndqu9DarJOk5+Xp?=
 =?us-ascii?Q?3yIm4VxckkYQSOsSF5vO2pyw1h4/PTQNj6ixOj7o?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29fb0e7-40b3-4500-637a-08dd78dc85a4
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 09:37:48.8406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igfEAIGoalOaTOYVizWUUIccYyR+UK6qUoils1X+dfq8KqmznaMj3SwPfllqX13DhPH7ECPjaJUSI35dy9kn6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5852

> Please remove this attribute again. I don't think that it is useful to=0D
> make the value of wExtendedWriteBoosterSupport available in sysfs.=0D
> Additionally, wExtendedWriteBoosterSupport is a bitfield and hence=0D
> exporting it directly violates the sysfs one-value-per-attribute rule.=0D
> =0D
> Why "general_fail" instead of "general_failure"?=0D
> =0D
> A minor comment: please remove one tab in front of "=3D" for the value=0D
> assignments in the above array definition.=0D
> =0D
> The formatting of the above code is not compliant with the Linux kernel =
=0D
> coding style guide. Please reformat this patch, e.g. with "git =0D
> clang-format HEAD^".=0D
>=0D
Hi bart sir,=0D
=0D
Thank you for your reply and comments! I have modified it as follows=EF=BC=
=9A=0D
https://lore.kernel.org/all/20250411092924.1116-1-tanghuan@vivo.com/=0D
=0D
Best wishes to you !=0D
=0D
Thanks=0D
Huan=
