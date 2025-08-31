Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4FF2E41E;
	Sun, 31 Aug 2025 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756602070; cv=fail; b=H7Rk+7qZoPY354pnIWUnIBK8SeIC4a18/lZbzfu0HrnEjJtDqEY5zS1ZjMap2V527iee7Y6nyylk4kt2DW+GebQYhe+fidXUT61QhPSLSdvRenaR+S9EPN3rr9o5azklZfEzL9/HuEFWAjkzOI49HtnexTEzlLqnnjPRKRhec4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756602070; c=relaxed/simple;
	bh=LjLVGxfnyLsO7LiuY8JaT6TcqZPRLAOLf7c+9o3HcOA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=orx2avTK5hVu1ucpUniIS561YlsETvO496CPGzNpEbiRIuUxnXc107JAozwF+uEYIWeuc/oiBX+UidgdccRY0hvN77djhz2bHxA0G4BemtJhNpB9EJZfO1hAmYay7apiRfyCzoTSWjkhz+7CiA8+qlHV9g69s1yIY87AhTng/D0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ad72zas+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OsjzZBYM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ad72zas+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OsjzZBYM"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V0AE65006760;
	Sun, 31 Aug 2025 01:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tur+Tjx3BTqpCIea5u
	I1WI4X60ODxfwMk7DAmsro92k=; b=Ad72zas+2lqrbRBDgSbyTfHycUjjBn/spK
	S4XJ0Ay815Ycck2og/2ii9nEORybjrEfKs3ezrWfla3f8ZisqQjxvYzzQePMqXa9
	qoxJNFsJ5LjgfhUBBOyx0ejBpxyRfrC+LIKAtCy8WulfZ4UEeosh3+QYwmFrDd0d
	cIm2nePBjUbmbblh3604o6RJUjCmdGW0MDw9J4Y3lLJbAKyqJrLxwc/g97EoTBMx
	MtsXDYn+B1HCf1Lxd9XEWTUUQVvOtaXVTBFuvkHDON1ggL/4n8Nx13jnyF9T/5vl
	l3/a3MC4Ns92e7uBW7A0Pnb0C0yD014l+CQrq3NOKqU7EL/deuxw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4g2vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:00:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UMU2Sv026871;
	Sun, 31 Aug 2025 01:00:54 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01k9fya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aVrvW+1SrDWCcHgcmsb1Esi8M2KnJ4n8usivDeiPmRrGp2puMa4Hi2cqvdLrqWHFhlYwj5/dw5+xG3Yh2IPM6Lp+1z6pknrBlXPYXOniExXw08OdT5dqyL8XfSSPcVyVWxxAccfU4J5T8vomm2gvY6ynZQLjnSiCNXw/y1V9eQY5e/S7fBPydQs4vM3L1sm4rDNayELatUzBfL8Gjk4QLaYUd7gbZ2Df3EF4udu2EbwC6KtQra79sJ094MXAn/tiY1m2lz9498kh9+kaLbUqyY5DTpuQeAIIO9xEKM23NDduLNlmqYVJYfAHuYnAqL9AogAzzy19/GasWuB2bVe+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tur+Tjx3BTqpCIea5uI1WI4X60ODxfwMk7DAmsro92k=;
 b=kCwYmouuw6TRKb1PI9N6T+rbcvWOWQIQJsNYIfloZpc5NqWpAiafIlkEYXCktA4I1IaYcWFd6+SfYWYOhmLg02pB6vt9afr3wHZy+9BySRt14950G0t9Fpax5JQR9+3wOkTNgKlfBBqyi/xVFB/rzntiZYixnG00k8DqpaCYYyKlSJ8VGAfuBGTu3nJpH4BhMBxDVYhxBhatNfpEepYenEu3Nnw0mXvyJ/ao/7kMVb5vuE8yQlT0fCsSszWg4tAZQLV8Fw5sY0CMF1iVSmzOmTgfhf+FMXb+4+w4lp5Lg7K9JbF51iuDz8tIve5K0V5kLL2lvBkr0CNBnWQHYgGE6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tur+Tjx3BTqpCIea5uI1WI4X60ODxfwMk7DAmsro92k=;
 b=OsjzZBYMNE05jNu6ov1DFJ827bojwCaK7ye82/1UOVN+F3KmF081dEnVwMCZC/TZ5W2UZDZjovHweR5vDlw03CP5tqmGJX7wjficU7/qrX42qv3dvywx3dHpS6KK6tis86lkZuK8zQ0HOXjT/wpj6JoRcizM0JjaaEY2yYOPzDk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6450.namprd10.prod.outlook.com (2603:10b6:806:2a1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Sun, 31 Aug
 2025 01:00:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:00:51 +0000
To: Bharat Uppal <bharat.uppal@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-samsung-soc@vger.kernel.org, pankaj.dubey@samsung.com,
        aswani.reddy@samsung.com, Nimesh Sati <nimesh.sati@samsung.com>
Subject: Re: [PATCH] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device
 in reset on suspend
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250821053923.69411-1-bharat.uppal@samsung.com> (Bharat Uppal's
	message of "Thu, 21 Aug 2025 11:09:23 +0530")
Organization: Oracle Corporation
Message-ID: <yq11posgv9j.fsf@ca-mkp.ca.oracle.com>
References: <CGME20250821053938epcas5p290f78790250d8cb09df2f35e45624359@epcas5p2.samsung.com>
	<20250821053923.69411-1-bharat.uppal@samsung.com>
Date: Sat, 30 Aug 2025 21:00:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::11)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 8096c838-5d36-4075-6aec-08dde829d458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mlPWPu4GgnveZUuiokLDxn407KvzwrZxjMc322nP5vCVORVsfavyJC86ffjj?=
 =?us-ascii?Q?1htMkLhgBWjYXsL8kIM3osTbgFlvwojvfRU5Y2niGY1RhQ+Md5fXrUihRbd+?=
 =?us-ascii?Q?sMaUMF1HiqMdnWd7c83sp3eT/279bFHyAILJl55muiWDuWY/STdfcin/3X/c?=
 =?us-ascii?Q?LTMuCTO4OVxt7SOVSDZXosb2cotcfwxL9OpxDjVWYPPdaZ5aVqCuwaRTQfiw?=
 =?us-ascii?Q?Lqu1jRjK+dSKtxuW9u7V+u7RpgGJJma70awpGxfgYArKCyXmOEliaREszSkd?=
 =?us-ascii?Q?3RacX3x0bHZ+gnFyblD7tB5QLmpg492aEmnRl2TUc5jNSmTqIaXWu8NkbIX8?=
 =?us-ascii?Q?Jx9K9aG8zpwmnzoCLq7jZjbYL/yO/2p/TbbQLvAONpcrJ9h1I4ZazF3xuu9E?=
 =?us-ascii?Q?+0o+UrTG9GGPuEETmuiXA/95bHtKP2U3otz4AYFMnSRU0DUuK5tHefJV6/JC?=
 =?us-ascii?Q?+F0Jlq7Li6fvBFiFW7EgylDNrTpnX8sBDWHZ/f1yfw+/nCYiBMoS8cMNTkbl?=
 =?us-ascii?Q?kgl7N2K2umoosOwrYBDkBg37z9LWOLJAKM/N1H682mZksHbmay2+chB9qWmM?=
 =?us-ascii?Q?GJtfl3/v+AMFYprcEY2GL6/o5twTHTcnzZSBHoy2ef7t4ud5H7Isk5w2hWBD?=
 =?us-ascii?Q?rPG7gl9gHCKLC+nIlCB0YqJOZ4YdGKk2dS/sO+CrJUvQlayZIE0DszIYVSdA?=
 =?us-ascii?Q?9M/pF7Bkq/ggswyERQMd9tWjV8kEKHeJUr3tyV9piqi1fBBJX1ZMeSErNb5B?=
 =?us-ascii?Q?U3yQf88RY9S90tThYPXlLtKvDhv4cy5EHWwaRJRT0BXdpdL384TXrK8wujrM?=
 =?us-ascii?Q?rZUmefDAiaKvbTsmMsx2p3ngmeLeY5OqSr+h65FkaOg/0HGJNS5sOhV+uEvI?=
 =?us-ascii?Q?BmGlnWf2OOwzTA1/HK7AqR6nrWuFnG0vFndromzW4fog94vbV+5j16Meaobg?=
 =?us-ascii?Q?IeOPSqUIiz/QSfbPvoLifY0WRF2W32DQNDZcghqq5GdafBTm9BmXsKSpV1iJ?=
 =?us-ascii?Q?XrBvy+vRs5XjrerIY6phzc75nqJBcl6z70RaXHO9ihESh75DGDXBeVl8lcCe?=
 =?us-ascii?Q?ukEKSblPrvPPN5sSQEtbOyOjiyfcj18SyMvrLkmdFpSGwmUa26J//yCX/EZy?=
 =?us-ascii?Q?0Q5qgU1hMXn09fewfQ85VFi66SR8PPH5D9o414RX1ddnzfUam8SMVZe5RgwA?=
 =?us-ascii?Q?EPZYX+LRt2+iEsKNRmahT9paAtXKg48daJvrZIHaLcfaOuYwpVcrF9hjhxef?=
 =?us-ascii?Q?7uEDuFrGRKMpRK4hOyZs/bi1URAEcaV/6s4rBOYIewqFUD+0Pye050ZjDLU4?=
 =?us-ascii?Q?oXr53d56wR5J7TCwKLi4uDdc4zYs450tOAF8+pmHt9+vsc2HXf4N5G/mPU2R?=
 =?us-ascii?Q?30+0wUHe9kzjCt3NkMS80xSTaR8oEwdLGp6Gnu0yUi8I+Q72nA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pvj+7YmLpekuFEPYgVSRdBLZ6bv0pCUpSoC21aOmPrDZPxY4C6aI3lFyS00z?=
 =?us-ascii?Q?xKHWc1DOywuqsMp4uTQ0VBO6p1vOhZhj9PQknbDed8i8V5kj1GUa+wVpOMOh?=
 =?us-ascii?Q?fv7mmvZpXCkrIGVIdenvkP5gvTXF++A4K/UgrpEuaiyz4Gq+aijB1n99Vd68?=
 =?us-ascii?Q?r95oZuqEijVoM9Euh8ruQeAbMcDceGEiO6RswuFmiw5TCcLwgte8wWYxmnDM?=
 =?us-ascii?Q?0iwZ0xTm/pz9gx3oxBjeTJt/IuFSmqQmOD2WyKFON/8pFHqbJWRLuf0/L31p?=
 =?us-ascii?Q?3/Ii1k8LUGpEauPw6HfdSQOhnF/6cOuXM42wZdErgOznc+BnXmyo60AzoBPH?=
 =?us-ascii?Q?mmE/4r2WlZ/BmqqUT7Ix2hVQ7634ZP7xE/jmbHU9xD/nZT9t+ScpPca+C8+6?=
 =?us-ascii?Q?FyaG7fYFaDm4dUS+bYdd5o72XkldDbzBpgiLmGOg7dMI5Ez/g+5t9MyskV1f?=
 =?us-ascii?Q?uKj6lMSo746QQwMqkWGQLwkIH7ZlVkhty6+lMQjSJ0+sgnZpDCUrpYaU/NUZ?=
 =?us-ascii?Q?fT8HUpv6h3ixbfqk1nJtlI63LHIGOPqDwqvsGeHHoeaBkjFYCocnzQ25Bk4V?=
 =?us-ascii?Q?zQ8evVZ4o6Imcbg0ziKWl1LEgTDJH/SAsEBRmNanlHE7k7GB03J5Rs4THr0h?=
 =?us-ascii?Q?dBHqBqsTKl9vbvb+u7TkEtXluZnYWP7BC9brCikaJ4IeodIfXI6rddZIpvn0?=
 =?us-ascii?Q?OQz7w80q/PgvpjYu6Uf9oXTnuAYQ+QUu8SK1HzlVd+BsR+E2uLCD+yswXuqh?=
 =?us-ascii?Q?Vj9qJOcCmXYtnKZS3YlxgMFekNdTnuA6WUy+Xe0yIVnq9g/UMO/AXvDT43IZ?=
 =?us-ascii?Q?+A30LEAlvrrP4AWWBkVbSxwAXZUvAdvCkoBXlsQumF78WxRdk8pUDTlvZfPR?=
 =?us-ascii?Q?SOrmKxh0axajFS+352/gExZVGk6JV/4IvJEB7A6dUZ409/+w9c2Ao38aL+cd?=
 =?us-ascii?Q?4j/F5UdXvUMsuRnP+ti1gWjYPn/tQEq+EB8kiICv2ep/ZvCcGYgOkpxixpU8?=
 =?us-ascii?Q?7orBGgB3hBnK1X6lcTdYHy5BoMYuUfPWqo74zPVX35FT02SYNQtizhfyyOss?=
 =?us-ascii?Q?O+fWS2Mbo1BJ8y8MGRnmLuOupe6jsN2Usb0+ux83B5NSdHc8RDnXUYQCeBF6?=
 =?us-ascii?Q?1yNrw3Hvd1F0+pHMyalQt+jglKVYTcFx1M8x4uR5ihiJQUszFWOLNM+K2HHV?=
 =?us-ascii?Q?XaLk3q6SfDenux2oE9B1F6ggOgBe7UeMS7606vq6YGak7UC6KFKHpsff8JH/?=
 =?us-ascii?Q?f5GK2QBupFksppzz8BB5PvMK0erwi1TUAGE1VLYJVD2MVPctGRnZXz7gzsKV?=
 =?us-ascii?Q?hjYnoA285H0iCwq3gwpAJ9OBolkY+ICQg4CxdJeKPvBXqUYm2R6DkZeSZ0O0?=
 =?us-ascii?Q?xK8MapzzJ1OxjWbBjtzY2u+s9NrRksCrFema4c8w65lBkABxaZIbG41RZ7+p?=
 =?us-ascii?Q?6NWpndbsfCivmJa6jwvJXO9leKaq+nSKkrewOEq4tjAKBSh2b6b6lIxY2KDF?=
 =?us-ascii?Q?5/GU4ynAH77Mpc5Di3pU8gi4vxR0ldq3F/in704TX7DFPxRLcge2qdauEG52?=
 =?us-ascii?Q?PJ3bm6ez77NwrS9+QbyCJKBcwVVLd7WuxCC0o2TN/9WNTyHUAvrYZFzwPYDX?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9SC7P3ZTWJdNes6lYAC6Pvw1ggIw8zLLnv6TZVJP6ZgTQPqGyEjgyKocMO9CI5hXWqZnOwTP3MV/sWBPGyVmkAGslnD7zlQLy8fJz+X3ezKNJK/a6PYgbvg+FdKh3Uhtptha6YvjyUBBijmWHmwLKzPW9gTy6SkXWEUdk4ayS2eFTHh1uycfDBUhgZX6vGUWWTLbCXsYL9uW3v/ED2lIrIbVod9GpJ+pLjQ4mJFyH3XY2yaP8fbHq4vGqrT9fTsEgrEXPDIK2Cs3F+26hLoOH5APflgI25XyN4Neugm/1Ln1RIbI9/NSUeQFRB6A0EXtrkUocUqjlWlOL+j3+GvsOBgnj88jo/eylW7EbD6fjlz+Er5u2x2Z9M3lied4zArEm0jZ4s7NV9tKfLH//2Pq//kvTcWTLIPx4k9UxfsNV1dHhQW5/Kec1ijDT3lWdj06llsX/UlSQRMCvlML3DRd9Un72caFXFGX8yaacAE9xWv3GPgek71dclMVUR+9pDEFI7T0cF38LVU2q3fxYsC+iU05I9h1XPUIU/lGhidmPE0NhI3QAcgNnxt1U56w/TtX6axMAa2gECZtqKjWIcOCwtpRXcH9ArPnVZRBNmtvwsM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8096c838-5d36-4075-6aec-08dde829d458
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:00:51.1849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6KfIGwqR6frrs9uSO5JmoghMlhgA7vhpxjhZUD74wNM4LnUJPez/m5yYwDEyFegIT8JYoVWuBotwJ+bPyVv0hDVWa/l2PWOkzbqFsDXuzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508310008
X-Proofpoint-ORIG-GUID: H_C8lIzzI1mRNo6xyb_XFKPnjk29weCO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX/PHKfq6Lop+8
 zjgLlvwYsKI3B+QyfrDq2+WoQaVpGZYfmOSV/aafYOX3yCb4giYgkR85jyXMlYgCsy2YHMAy4u/
 KSXemeRf608K9tA0988RYV1QeE1SPeo/9ALOdy49bUwskyTp90VgH0i7QZjFIYXoqbYdLDA9bH8
 GGlBpIUc01XfzQm2/KXX/OXopYahunfDV8y7QVWtqYRn/utQBhd3Fg5D0XcDN2yXhpresWReh3C
 M1PT086Q9aUh9rryE5nSr3hcR4jeZMRCIofn8QZNRkDcJcg8uHBC3R3ON1+gx93fmH8DC1xjSAx
 bquCbdVzsmEH68wPgohLK+zq7F/V6b1zGWm04rD9l3dPsJi0aJtt95LyenR5StDonz7/dnVP6OA
 oLd9vcuv
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b39ec7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: H_C8lIzzI1mRNo6xyb_XFKPnjk29weCO


Bharat,

> On FSD platform, gating the reference clock (ref_clk) and putting the
> UFS device in reset by asserting the reset signal during UFS suspend,
> improves the power savings and ensures the PHY is fully turned off.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
