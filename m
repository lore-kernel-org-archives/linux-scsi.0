Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4E1AAC9;
	Sat, 12 Apr 2025 01:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744421328; cv=fail; b=SU1Xo/usL5mYoWdQdgLQ31PlMHmZOhHPkCqMgzVc7tR0VJyUuwhkBw2962G5h1NXn1EACOrvaTDjEM/Q+gd8Di9YHMWghbcSqWRaBbCQEFTYhTyvnTk1q7JpeXxqSv2XhhwdTn1XNBlVoLYAK+zs3SmOCrfAZi/D2mGU0K9Dd08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744421328; c=relaxed/simple;
	bh=n/b7+QP12SXzzn/U/XiNwBk5L2xak24B1G4R6eKyod0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XVVbciT9ww8HRDQrsGhmygHHQK/wlgK2jHJTkla/+dGuLBGN9aqd068RUhGBpkX7HS+reMJEPR9JN8kOcS4aonvt+keUjvpeJSQwwdIpT2xO2l1PQPTazKOjLuBkfqzUy0Rh2faMTlDG/t7N+TIr5mu1gB2KnXrFaGuYezVmsVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hT7Xipbm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bBlkjzMC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hT7Xipbm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bBlkjzMC"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53C1Gxsw004596;
	Sat, 12 Apr 2025 01:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=nBczE2oaDujXgtNOBS
	vkkQcsfWLxySLKyjRG8ztg6Gc=; b=hT7XipbmWPEQmrfnro0N4f/X7rIZN+/AHT
	TimCdO+c1LahgTgelQPuvLLuEXQcX2J0sVHsARwaeHnYaa7xT0v4FBL0T1ARoxVT
	X4omK8LNJCxo2aLogtFV7hDt9WUAm71X0TS77yIyiqfHtOPhe4DSkwnsINgjqhaf
	cU43l4jJLHp3RR1MINad1ZYBoPnZdStLD9g7zzBV2pGUCSfTpBjPTK6UAKObfTHH
	J68Z34lB7+Oa/vXY2cOGhD7bSVX2jjt9dQvvlixscZtvqbIA+dhwrOa1jmmQGUvM
	yGQC/OvOS+oXR6/s7W6vVw3o1LxQgpA7qQ812cGHIQXro2FSBJBw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45yecbr049-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:28:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53BM84WA020900;
	Sat, 12 Apr 2025 01:28:33 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013078.outbound.protection.outlook.com [40.93.6.78])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttymsdch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzGDqIndJYIxRToBsPAcyQ/wCrCbXbefsMr5MTBYGDvXvUfWVjkX+hN/j+9P+qx74UnsReTvVlPwda7zVbaqZ83Gj71IKjIP1L5tJtd64f3rWv4qYAB7CxcZtgoheMtdVHsPAz0c2roT8uBk3Zwl5FjKajaNI0HbTVYt2VLcS4DN1HIaH/LfkIjO2TkfnVC4YZm4jyDyqtFK5/UXYqr3eCJSHUqmkAYChj21jY9klo7dtdL9CSH8dUCydGZ6ev1Ayggt6Q02ZBEglrV9Cqb6WzR3M1QYM/ut5lE8N24QVrHptp+MOUTFxnkcgm8nB8sfH+vI6XwdbfZwtkj+vORmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBczE2oaDujXgtNOBSvkkQcsfWLxySLKyjRG8ztg6Gc=;
 b=wHVfhcIepj2Fh80qpQjBU303gpNod9mJxdlfCoQVcjzcxOuQAcSsdzHQEkqutcgn4s42v35OXx8WqbY42L8GBdjUiQA20cc+UHhsZU6L4ZgPdtgJ7C3qziECO0DSDzQalHAeLpf9YFgYJo8RiiI6kOHt+E6wFTVRN7+YbNMmm2dC45SgrYsGDzO9I+6u/58M93jNwwJVZ8UNo9mPiiiIZb8DsnoTcy+DPnTA58Vqhh5Jxfz8PkBePRFLModoBB4LP0+PM9dy2l8favFFs2FTy4FQZF0AdAnYK25gNNBid2PtAPzSrisvmBVA5zZehJlhwpcN9PdISCFFPpIH/pm4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBczE2oaDujXgtNOBSvkkQcsfWLxySLKyjRG8ztg6Gc=;
 b=bBlkjzMCsCdJQVpweRzrnZlTehiaRUeQHnOF3wk4yuu+unbvpGQ8dLUCV3nk1nauutK01KpJIY9P1JjnmplH2EZWTEpzlq1Osz1kd+EHCt+q/swQoM74QrHfzyEs03IZPJ8tZeYP9wU0VkE0s7mJ/3I37GyYjBxyV38sMfUDZ5I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF4B2F62DBB.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Sat, 12 Apr
 2025 01:28:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Sat, 12 Apr 2025
 01:28:30 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: James Smart <james.smart@broadcom.com>,
        Ram Vegesna
 <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: elx: sli4: Replace deprecated strncpy() with
 strscpy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250408102843.804083-2-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Tue, 8 Apr 2025 12:28:40 +0200")
Organization: Oracle Corporation
Message-ID: <yq134eejhhk.fsf@ca-mkp.ca.oracle.com>
References: <20250408102843.804083-2-thorsten.blum@linux.dev>
Date: Fri, 11 Apr 2025 21:28:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF4B2F62DBB:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4dae89-5a47-4e18-728a-08dd79615566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EuPzReSCtxLpfvnMEx5dF9jFSMOeRC/0oEoN9QbicY+yDgHi8XLZhHF8zosX?=
 =?us-ascii?Q?7lVFJip9qey8slLxfZMb0boeRuBTCQPGMs5BEEBAIq14Dk9SKU/KnHmfQxrP?=
 =?us-ascii?Q?xCZ59dS/cwkRPVaGMTBfBifux3RqlM2W1QTwXQqLQ81EsBtmkv4lKuMQoZCm?=
 =?us-ascii?Q?dj52G8e+9LPorT9cNfN2SeCLYjp5BXNy9qcFEDNsNkbspCncumlx/wBFgGii?=
 =?us-ascii?Q?0zLwOvQvhQ+hHkPm+dWf/6YG8JjATw9IV8zJ0Tjlbt/Vq0iJ5V+LSnFYBqzj?=
 =?us-ascii?Q?GVxoZmWvC8ZleOnmLzkuOrMR8dca/Emn/gYQQh6cqdKHNSj9nfFsioSN2+ik?=
 =?us-ascii?Q?qRtk8rPasng4LJS/VETpaiIAxbpGq4INvoAp0d0TEZ+gbBEcfjiV7Ph3tfL8?=
 =?us-ascii?Q?tYar7fRHkWWPtE1KMf64H/kWg9TeAXWwyvGFsRhqH95mehuY5vbgi13aq1z8?=
 =?us-ascii?Q?auoVI6rygz8JATwba9dm6DDpwbNBpyxgE+ZuXyDvjB4hu3zedf1DNW1GKaKP?=
 =?us-ascii?Q?Z9nTqu1rlq7w+K8gTPhJZX4bmo4ZYocdKf5KZ08+r86XZaFht2WU5jYgsDwh?=
 =?us-ascii?Q?yE8588G2v5VUOGj77YYO4rAb8zIPMDe4/MFITnwBnz1L53zoxUuKnbZEGshf?=
 =?us-ascii?Q?azwv2v9lbuWHs8dP82lexEtJsaoCco4+cvVf/l53Q1fwRTx0N9VW+NIcPv3S?=
 =?us-ascii?Q?ndWvm8Cor71e/VAVCq3cuazFZY1X7uVPfSinFt4kvCyRaCljrQoqpwG5gBZ0?=
 =?us-ascii?Q?ayEDXl+bQgALftBIriKaNP8XuCTeuK6KjWK1hVP4Iv4y5OaKutiOegJpYF7h?=
 =?us-ascii?Q?w/co7fSnKU7WIP0eatDAObCKKMgi9KhcRJo93L9tWpxXYEYorFaDlHMWRxLv?=
 =?us-ascii?Q?zvBq5IUZB5Q3iCuyxQBDuAEB1dU0nDouKdR+HEfcK3a72DD7TnR6nOykUrpW?=
 =?us-ascii?Q?9kMVa6D8DpSC4LyWs+B3o1Nwqe3fLNb4/0nAx96JLeDDi8LOsT0hiHNW/e6g?=
 =?us-ascii?Q?YdiFX+pK/l1zJJjUaycAzXGytQrZbyAaPAQyWlo7eHeIuoohbBod6Au1pXJf?=
 =?us-ascii?Q?5dcyssteiDSJthle84XHnbmhmMKhc9bXDoC8hjnl4iWeHr8dhoeGmxIcfPVg?=
 =?us-ascii?Q?eBDUMdbdwYQ/7fK8s80ZpvE0x4kckS3L+zfMHDN60oSspc2pfQVUdzlcXopm?=
 =?us-ascii?Q?IeXH9GNPbPHwu/mD6DDLx5Npyvo8vqBVkpjx0YAPLrOiXyC9nnK9wmWkbhyu?=
 =?us-ascii?Q?YEgf4UPkMffh44k+Dj8XCqOn7X7YEL5j5O5M/9IHBF62zvwes8pkYx6GS01U?=
 =?us-ascii?Q?xdE7etfkGHQ5uh4XxD0Te4TgmyGe7+mYc+KqyTuxfRkUGmxgZOsmMssJvnfx?=
 =?us-ascii?Q?zOu6sdifcmYZJCOH5aQUXbEKt+4fJtNop9BRHyK6ddDJ0FDMTKb829mupFKF?=
 =?us-ascii?Q?KYktLjEI6Qs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LshvdlvEfOPuV7tX49aYje/XArAemuDFik9CvIOwDh2qDi1hS8zGLXQDXOcw?=
 =?us-ascii?Q?xbp9d4ltGQaXsER6YC0zLKcNFiXL9vrfdCsUhrWhsLqYdNj0tCiRo7Lj8qX0?=
 =?us-ascii?Q?R8UGNuaB6LqW8LLxM34wyf1F7YHwjv3xSh3zeFcQZZBsEiVrUREakc/xyNou?=
 =?us-ascii?Q?GTAfyZwgJ0Kj0S29DIdekr82/xYkCBhBa+e3wxypfU4klFwGO0BuOdCKxm2j?=
 =?us-ascii?Q?2QVH1dUClBjdc+rg0M07eIg+EGdYGjNxTK+IMC4XcjNkQmTi2zQW/lR5tJfo?=
 =?us-ascii?Q?/wAhiJbTzHOxs4uYuUrezc9zUL6SBwwvrvf+zNcqTOmUeAVNurJ/yMuqrUn4?=
 =?us-ascii?Q?R2BMPvaFRKJSQfg0rwkDWF8vF9Q3AK6soOzG0ypmaVump2/MF5WgVmJFZGY9?=
 =?us-ascii?Q?ZVAcPD1W7jxY6uCgy6DmndpJO/NVG/nS/w4OJnZlwtKiXuW8xJrkk10iY/Jd?=
 =?us-ascii?Q?UoHwm8dl+xnZ+W6eRdkqnkCT7G+X7jDu6llR3ontGdpT2kkrWO+gZn6sOJZs?=
 =?us-ascii?Q?VodC3zwf+gbL4YdQxbk94asuixVhn97kqJapcXOu531DDaz6MiZRnPfjKWQU?=
 =?us-ascii?Q?VqXawuF93WlU6nFiM7GTcyBxjPDCH5H/gW31S6oLIA0yMMD/cgoQOepMZAyf?=
 =?us-ascii?Q?zpgYUXUxXIqX3YAsfbOsdR27b9XYlZ+YsPgfS3zBm0sxTVo5Vs6/XC0rVblj?=
 =?us-ascii?Q?QDddP86YwthoYHk0nNP79tj5KbplBKw1CJvybnkRD+jTdwUG3T5aavs6l+Ci?=
 =?us-ascii?Q?StznShIFntrpDZ9GX9hrDTW6HPvOOwXYSIeYP/WD/yGC/BSMs1oWMqMioSG2?=
 =?us-ascii?Q?u0motrHGP1bc+2J49EIkHBr1N1tGI4qFrgD+PBEiXxX6nPgTp/ZMnLT4Z6Kh?=
 =?us-ascii?Q?YShy/da+nXtxiSxG4XMSYKBXJGfyeBDMCkl8fBrqGZqwwcc07Z51mreODV8O?=
 =?us-ascii?Q?r9udx/+8AuAdsKUF64tcZiejZC0QjatGTyQNF57jKhCB61k6STH6hYkC1lKG?=
 =?us-ascii?Q?jsgsHqZhcaHwghDi6JUj1Eb56RDOrWOvibSV+p8ah3mJQ0PMvehZvNVrFnQb?=
 =?us-ascii?Q?hKKYfx6Ep1MatbhZlW0Rca1LDvkNdnCYmVdeYMrvnahes2bZ/qNybkVTdcJ2?=
 =?us-ascii?Q?/oKw+6l1kEvSMC3YH+rgYAic7LHGby8pJ4e8R08qRD/e3cI9kavvl0mIE272?=
 =?us-ascii?Q?q8F2lkVdVSvmZm6+50wZm4meH9YIXHElToswIdKLm71UC5YWV6+ZP88t8aho?=
 =?us-ascii?Q?J6SIFiJ6SzUrRqgxoHtIjC5gFkM1RrWGd4N3v6gBKuPBramBmDoZSxjnQiP6?=
 =?us-ascii?Q?d18ie7WYPuG6JXMq7TPsnTRgEa34TTf8kT4pdrr1lTJTkmb5o4INzmTFB4NN?=
 =?us-ascii?Q?ddEdyDmLfFU3MRjZPDA+Uo8klhUfEvGQ5BIm64TCoul6tBdvq2c0n8HooH44?=
 =?us-ascii?Q?c07C7yXVZmajYfeM3qI53xAxMnDiOFDukj4p4rH5ftaQzbK1pvjd0CLLeQOL?=
 =?us-ascii?Q?SB3tLftHVpe7ej0IfbdZbQrPyNLJgHlOnbHOKDqwr1Zgkqt8tN1lop7DdfCq?=
 =?us-ascii?Q?gpXcyO8kzsYS0J9AXTxY0QR2clYdZk7Cz/nObD428qOuG/PIMd8Ot0CuKPRm?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+0++gaRblohMJwkuPYTWBjA4sa1eEoKhOe4U+pMedIe8zil4iGWzhwtjam1vl3IKth8/5dAaNsMhgWc/HGG5ZOgBFqYjjOkEbAktT0DLG4qlweSfOv1GWz86zOBiL9HZ8dOezIVbDj8+vD4I+imfWs5aUxLB+IGjwOL5tSs+A15Lgdv9iKEf37fKWZqdTUZZQGyLXAYn59emDsUqgDAiZKqePUOUFVl/I8kmiKtlow8KSMarWXsI8ws3mUoaJ4AkFt1GjapTF/mkkX4XA9Vz1CRtFiRda9MXQnJhkE5WoZyjM+dzeC/szNCsHsYrzp+GZhiG6HwAT8D4DbwfyY+/VcOBSv2qiW8D7j/+CrzpCOa37cOt6xzWH0w2kA7ZWGoorHEu+TLAS0gy11O/Le26yIxHgQ0HSD7iTcvAsj08On9viZTR0G8hTpUKg6bFc5CcX5k2aP2COhL7EMsHBuo2r2CaPyhiG4C4N08ap0hn3nsB68kEI1YwOrTMXPWgprmiZj/1apyfqD1S3sqSugd9mMqOnwci7IqLFq7VdeJWxPUD57uMA+PwXhsVbA/ZRnX8htpveLoTeXnZbew22QXfZdfPLGEFtcrrzH7nJ7/VnZk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4dae89-5a47-4e18-728a-08dd79615566
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2025 01:28:30.9168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOOsokPBAYirR/qq0okMutoZt4Gx+RhHD6pN7oUqKk6NaI/V65JG5oLna6OShp5TDZ2P0jXt/I6+fFFJSpqEw5JiTsS79a1WyTQbiz3aMak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4B2F62DBB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=802 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504120009
X-Proofpoint-GUID: aqdMpgACePytNQVktCtTIKyeOlqCu1p8
X-Proofpoint-ORIG-GUID: aqdMpgACePytNQVktCtTIKyeOlqCu1p8


Thorsten,

> strncpy() is deprecated for NUL-terminated destination buffers; use
> strscpy() instead.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
