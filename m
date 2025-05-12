Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012006.outbound.protection.outlook.com [52.101.126.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237E2295502;
	Mon, 12 May 2025 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057060; cv=fail; b=RakoyPMiRM25d+vf69DUdvGlAArwjBaiQI/sR9nqyNA/0SBv559+oWfuev0tZDwsUXYUL8KC6HbKqH7PtW9EI8uMmHXZPs/rXdaaxuKKJ4kuu/ud4q6ddezxIPBTZ7b1JxiQw3It3IXhooVTRDpOCa0QwNQqd9gxCsoIUrLvTB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057060; c=relaxed/simple;
	bh=Kl+N4uWbxmDyEFcvnZEBb8uLMdP32nJrX937Xz5Koxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sbZo/U2ZnWaKYQxhQ2NjZveSmzl37EzxsA0paqzn1twPqLQeIDQZyovcNrArtxc1QE6K7wBu56QUFj3A+EJjaqdy3fVYeZhHMUyUieAzY/6eAp9awc3ZAYoFMAGjUUcl13/D2+L26Y9NWDSF+lm1BmcKDF7cbXEOfOtI5IRNaS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=SsPau2K8; arc=fail smtp.client-ip=52.101.126.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="SsPau2K8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKa+I4LPuuVTWyClGWZFz1n29TpEZCe5p8S1XoYmQ+6vjvItKMm06xXrinirL8FLLM/Wqp37+4rSMlLx4NwJLoZYuWBWplOcG+JbpKwC2ZIsA/LBI3jVrSJJrI3fU7pmbiY4hGu2a924NW8yBRsgFw92YPElNhBA8V4qlEYpgLRQHJ2pUfLGyYuzOb/OJnQYXtvcHJ0VppDPA3xtjCpiyjFJRF4AHZnaF/p+Bj0XF+KZcYr/Kn6he9wKyeSGlUpi8l74sMNu3zs3v3YdEGbTPQfby10CQCgxXz6m+g1+UX8qk7iw7DUQz/Zfra2kdEd1XLd15wtgMfj3J2JWhQb6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl+N4uWbxmDyEFcvnZEBb8uLMdP32nJrX937Xz5Koxk=;
 b=S0UYcH/fTgH1DQvhI4Flq2c7p6lXRhlKLnSY6yTh24xVCK2zmhSwgXeZMQ4qryQPEIvoL/fRzZjB7oZr5NJ/KY3wHAdzSqOE2kXIZYqmlQHgKJP5NH5YGJ3513fshmv9CODMET4nWARbMDn2FqFm1gMekbvsiS/hjI4puYm76iJITjOAN2+RHFVfxiH9MbHLlLtXEnMUlFIhyP8OZPGA89RS+X1NHBJ7lAdzAxZlytEWco2pDa4aHi6YGBsSFjCLtrGANVKeAsMUQfAQwqNs3CMKIrFq7ms8EUsipMwBXNMBoeeLsCj9Pc1jg+3bj136MW20Tms7h4JDGDZ0VF+yFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl+N4uWbxmDyEFcvnZEBb8uLMdP32nJrX937Xz5Koxk=;
 b=SsPau2K8mfbbtctG+tEExNexNa4ZjJeTCDCTOvpuz3AvAguiuu0Di5EtWIzgKxIBcbmXy/Kxan9OlcW4hARpc1NmNO2eubWdlxzOrC45rySeFV6gxJsrK3uaDaBRhB1SITWoJ7EkuF2kFOGBdHNpYbJ+QUZmYa48TAUhjfrfZH5GcLAyLQPhxaDfO+F2xNars5B6nqWQXPHRsGSIZdwk/vEEaP7AEuBSbPs10eESg5GKf/KlK52se1fOp4aSd5sMUaJKcZaA3EnSDDRFfTIQI4yIocsU5VLEeL30VXTGUdj74oZ7NXfWnkDF/lFtAN7Aa+J3mCAjBdVHvrjHuqiOrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SE1PPF93ED7187F.apcprd06.prod.outlook.com (2603:1096:108:1::420) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 12 May
 2025 13:37:35 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 13:37:35 +0000
From: Huan Tang <tanghuan@vivo.com>
To: peter.wang@mediatek.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	bvanassche@acm.org,
	ebiggers@google.com,
	gwendal@chromium.org,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com,
	quic_ziqichen@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk,
	wenxing.cheng@vivo.com
Subject: Re: Re: [PATCH] ufs: core: Add HID support
Date: Mon, 12 May 2025 21:37:27 +0800
Message-Id: <20250512133727.288-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <59e91374fb4232ba22c8d80defe7ee65666dbd40.camel@mediatek.com>
References: <59e91374fb4232ba22c8d80defe7ee65666dbd40.camel@mediatek.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0050.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::19)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SE1PPF93ED7187F:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a979561-b376-4f02-53ec-08dd915a2796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VqvY5Hsd/knpq9ua8XqJcv9ZAN1zGQWj2WvD7VtJn+av0GERRSni9o8yUZ22?=
 =?us-ascii?Q?VSY3T/kTcsozcaUUTAHrCNkCcMnU+D7H8RIM2cfrxm0y6qeg4a1884sO5jWp?=
 =?us-ascii?Q?G3a6FIUeE9RKDrLI7LUO4oI04LgkZ9+zkTFwFhXcXqIIwNmrdh0s0IONzUOI?=
 =?us-ascii?Q?Am+Vm7rqy7nZRVXXov1awARfgYNzcdSqJ+sFshLfPxlXMuiI6a7Tsdi3h1wE?=
 =?us-ascii?Q?OI8IxLB+R02acHAhp68FCHbsfU7wQTKtsMhebTcYONJe+ToMk+wercNy9Y4p?=
 =?us-ascii?Q?rrJGqwgorqqOPo33rpava7YzhfbegHo7PgmEp5nYDpcgIcsdsfo2vbsG3Sse?=
 =?us-ascii?Q?dX2rdvlDTVuv+vad2CbL76IyAHb3R2JhJUNzivrAJ/L/Al5nlvJabQqNrzqv?=
 =?us-ascii?Q?WtWdmeUqFXHj7vYv8IkgxuK8Bm7o23o4KAlv8WOrO1rosYh9mG5SEpbC4J0W?=
 =?us-ascii?Q?2c/uWgL9UPjtuWHjoo9XRJnSKSi36UmrURd/bPyJIImiUAn2WMdTWiYb6h08?=
 =?us-ascii?Q?mOdFYZGA5SbAwwx94Dpm6W7UZ5nvjDlLQvov2S/BU+yREe913cx6rflMlR2t?=
 =?us-ascii?Q?imLQH34kTKUwMH4961d1n1XKwopZBh4BSGGIwOucF/jIwyVYBAzENQ/9TFit?=
 =?us-ascii?Q?alV6OEi1IP30Wx5znmQcdeOKoQlBlcZIEW0ZLHyKGdRRjMtKw9aMl8e22vPn?=
 =?us-ascii?Q?XJNGmquPsZSNBNga3ofmdX0TbIBquxT8GyaGgIlspZWveh47ZJ78+pYmCgza?=
 =?us-ascii?Q?sbF0KhQ2mgL8VTa+oOlSjHmQTtIU18C+kBrFvq9rT8L9gtPiZBXvdZlbTxXb?=
 =?us-ascii?Q?MvN5xyoOJ2zE2QMOQy533bPQM9koOMxgW1KP4fdrP9w9Vq6ETI2o+TvrU9fH?=
 =?us-ascii?Q?IXS/+uqdJkHTkQ4T6/KfWZ16D4+X/X0kOw5UQaVupiyISUJKeww3GvIvEoEf?=
 =?us-ascii?Q?33y1hkDXobMkIWDotRXR5Dn5HKetCT93lY8YYQy+oBGkAsXM2RxmoIwRq/on?=
 =?us-ascii?Q?PV9sFYeDsdRUbj/Ixg61/yrk+WBe74DEv6ILaNFDUggDb2plN6gjzfm249iC?=
 =?us-ascii?Q?CvdgpeoiPQpIqxvljonva5iJYGKkYbW6h3LSq8sgPNX2/XANfbVy8aG+4/XA?=
 =?us-ascii?Q?VJIHXvv6twHRNVc+R08qp7To8mvhXdtcxStMUS4OhqGJ2yDHAK5FfnusErt/?=
 =?us-ascii?Q?gb+bCLQTBJfz78VoNpDrfpC76h7c2rcJJT5jP80ZDtNnozdJ5gLx/s5xuKyS?=
 =?us-ascii?Q?IM5b9oP3sH7tGaA/cBPsbg2D4tjRRwiBD5/xyaiLTrQYoHtU2sfDinggAY2y?=
 =?us-ascii?Q?1AGX69wtTw52//LYGq8lJhaHt8oaTCMGaSx0HJ520oVsUpFZ+5sMg1/2EfAm?=
 =?us-ascii?Q?Y9dKRp0JiB9ztAwqnPUBcguCFWr9BVcLFlriN58Njz/Ef5uxPRNZJi507DbH?=
 =?us-ascii?Q?ClYQN9bd1rqN9CemurYjfSP5rRqdoxIQ5/Fth/Pgz7AyuyU0kOLP4B7N7FUh?=
 =?us-ascii?Q?1zrx5Y4idYYiTKY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xVwz/KYleuIJfkxshdIyh24GIMuZEE5LH/f3xB8lpXksVWjAMouS9foxKrWJ?=
 =?us-ascii?Q?LRwXzFcUm2q5wWVMnuYFa1rtR4gGuV6oX43ud2o5NLDclah957xmo/JTflKU?=
 =?us-ascii?Q?91jIBW+bTOMsOgYhYAaxz4VzZ2MP7KV+Expae3viqPWs6GpNaseLas12xHTb?=
 =?us-ascii?Q?vNojFdX+5q/kWPuXI3DozwGnx1Wm5NAwxchFp5ye7eNPjhMYtfHOszKOUf3C?=
 =?us-ascii?Q?wvsvhNTVaSfqAYa4AoYeDYkzkIqmUZdIUv5g3ulc8K6rA/kPbl6bkwcOBkY0?=
 =?us-ascii?Q?x9YSgwtT1/j5dtbvltWiMQ4BeM5ZFoETItdLDyWH7pTRwMElbRjQ+2owFFCm?=
 =?us-ascii?Q?He4AwuFaGXSDbopYlPR1ApgICFBwSGL9R3ITpF37HUbt/ZI4u7SSfnpWAwIt?=
 =?us-ascii?Q?yaHnPuN/kkxGfIt6msvsYlu5VVz2Ns+i+gufF2adodzx0ocN2nWo/VnP56ts?=
 =?us-ascii?Q?tav3yR+Pw5rtlh7HJNhg5FtKh2c4L80U/3kDx+nC+hbvbI3DWUiC4yPQNQb7?=
 =?us-ascii?Q?/POfUfTqNM3TbkJ16SHdMvVdYJ0lnaQpjhrgbbq0X1VRc8BkUyu9rm93PXQb?=
 =?us-ascii?Q?hG2pN2LhizbhscijWDcNi35gEx0rUcBepzp59bin5N8vD+NV6vgoaxOUvMOR?=
 =?us-ascii?Q?75oGPjXWds3ht+0piDpV30W1cewh2cLVnGAtZIrhhoT/jfhw+ajMe0GfpPs1?=
 =?us-ascii?Q?SBGrgbvwVd8GQ1aJYtPCUxyNuCuhmOrCOM51qcgUAydJ/xdyvc01J+jhhHXh?=
 =?us-ascii?Q?AtybAzhL4U2rgDSFFZc+5aYKkEqsBDcnQlFfhP8+EJt3SQmVdEPNYpRE3ui0?=
 =?us-ascii?Q?qTe96bqoIDDaZWJCs9YLl90vutUwzCqlAMRePHoTuFCrEPbEwq8J5ngXdCtR?=
 =?us-ascii?Q?Id/XNU4exLc+7jB9lBTrzXQzQ5rfBJ9uuEcaGunJAisH9wbRI9QcBgHZd3ej?=
 =?us-ascii?Q?lY0k3c1gMYfdpcw2oeS8AIb7sn44LLSyeGZO+qWsnAHxjnwaPlJR1KnhqbIg?=
 =?us-ascii?Q?MFn33D6w3ETGx1g1o9wkLhMImgifv6iTDKj4WAm0SsEprydgHA+MTiu6+lqX?=
 =?us-ascii?Q?92+bOxbnctH5j8wSnAKswWitT14B5OzRIOXwfqKcnQzi2O1Mt/++hcdQ8Xwk?=
 =?us-ascii?Q?/noaa5ZmPmOrcOq9Bu+UbMdo6gSTEaS8E1vgzmSwwVKrCbxvIXjVWeGr/mtB?=
 =?us-ascii?Q?fMscWJbpStxbWnxj0xvoGs0hS6lnkqVMbUC/pPTbk8P5XAy1PsSUXkYkkAKO?=
 =?us-ascii?Q?edeRHxTZkggXeQWike3zTxTE2W+I0hopEjYMKMb3xFUSBUPbgWWd0CoGFL5z?=
 =?us-ascii?Q?JVFiwfeF3dDFdkQyh820bVWtOMbd9yVpEAbiFx/2/Bagki5aIbrwcvIsNCTM?=
 =?us-ascii?Q?ad+elS8URcx+PNRQIbb/xvaJLMGeQapEJM4Zu02Kefw3FfZKjP1QBrFucD1S?=
 =?us-ascii?Q?y+H6eerWfgcnQ/FO5fLeOFhg3NHY0ywKYS0XEANlOWB/Y+z95SOV7LztijoR?=
 =?us-ascii?Q?W1MtD8Xe43SH7DRPHoUaYvJ3wbWkkBHxFJ42Cnaf5gLQRpwecy2PzxqEWLEI?=
 =?us-ascii?Q?pe4pcnmlS9Uc9pyeeWrTicLW/ItBTMX7RwBVI0V6?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a979561-b376-4f02-53ec-08dd915a2796
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 13:37:35.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5a23ICiDDMwYuwwk6bQJrVEOVQZu8zDsJoi4O+7uRbPvnsv+1kDsefA9ta8g5eB3WpKSS4N2JbdOpBiuSc9aWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF93ED7187F

Hi peter sir,=0D
=0D
Sorry for not replying in time. Thank you for your comments and guidance=EF=
=BC=81=0D
Based on your, Bart's and Arvi's suggestions, I submitted the v2 patch:=0D
=0D
https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/=0D
=0D
> Can just break? Because according the spec. =0D
> After the host reads the bHIDState value when it is 04h (Defrag=0D
> Completion) or 05h (Defrag Not Required), the following parameters=0D
> shall be initialized: =0D
> bHIDState value to 00h (Idle)=0D
v2 patch does not use this=0D
=0D
> Will have dead-lock when ufs_hid_enable_work_fn invoke=0D
> ufshcd_rpm_get_sync?=0D
v2 patch does not use this=0D
=0D
> Please align the arrangement of these enums.=0D
Already modified in v2 patch=0D
=0D
> Please align the arrangement of these enums.=0D
Already modified in v2 patch=0D
=0D
> Please align the arrangement of these enums.=0D
Already modified in v2 patch=0D
=0D
=0D
Thanks=0D
Huan=0D
=0D
=0D
