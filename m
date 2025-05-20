Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012030.outbound.protection.outlook.com [52.101.126.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79859264F9D;
	Tue, 20 May 2025 09:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747734502; cv=fail; b=h/uBzQ3QvTAtWjhx4crnfOYX96mqqEXDc18kMblpQdSHhOqAzpr0iJL4g0urLgAO+OmbQshhZjLgqfzJaDEc2iW+C8qdMpsjTV5+sW+a9ZXFDg+L8K3BMZ93WSarHYkEsOrEG8Fn1u6PersX2bU8+UoE44AfGewrdQA6aQYUrk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747734502; c=relaxed/simple;
	bh=2r2mZikrhq1vv/SVptSvOIUSsVfF2NEkwpFZ6BWD9QU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PFUCabvHlX71hTw/0mBqyyr7AuXdrcdwr1/uBoY21QoJUYYZXLlQwrDUEIk5M1LBVNH51h4+uAavxK2azpycdkxDA8gZZeX8mzi9dWYOIs7xut14O5eyVxnBlgV+0A9uHAvuM7K+vxrKEojqvsRkb63mVsdLm55rNV/irtE7JkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=iEpCB58v; arc=fail smtp.client-ip=52.101.126.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="iEpCB58v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYKi0jsDB9CJ8sAR5WMhDp7WgVg2t7uiP3G3MGXU3JXWD3sKPfScn7mUNOszlmVszfxPdfuLNaO2LwCDGl26V1znWdLh82SyLpMZ25uflytDowhhZuR20vyEUPGRudNW306K/f7gBYn5EIfF+XJHxX/mNB8xIZ7nhvpX6CfC0zyLFCOmA49scP7P4jPodYRdQbIcFaYvvZiiF/abEl5pZw2Y7/tjpgqvPc7hXiuMspPUzBiyuC8v6N9ZF4JIEOmfrZV1Kml4twsY9YMuOucKV9S3zFD3MKRGGXtaLYvVTJuFl2ABx/T5WYI/iyYGzNy4dhx9KjkxZA65WHjaboeGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2r2mZikrhq1vv/SVptSvOIUSsVfF2NEkwpFZ6BWD9QU=;
 b=l9X+smuYiTDu9YPDwfU2n9lbikq6P420+C67UA3KC8ByCEPbhhTD3S/4bLowo6HfuD8FoO0250WIVUGf/EBv6dj0YrqsOVrk112H+HZZ3DW8JNZnStBxdEoNhsBkyRHsQbYHU7L0DCcVEdUzXaI+6OVv1YuDnQ9nLIHqCSl0nKmPk8bgoIWA1XHCLIGxI70vuPu+ChCPMHg0D4kKUhZqu7UBwE/OFLMlzY1ku5agyLZVxUzXrf77qDDq/bzierh7GGR9gw95eCWhA2iiGkxIY9F2JoN5I3DGK8JrMwu942yRzQtnIP3A2aWpTZa0/g3x2U1oWZ4z3ZOkOtyYBPIjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2r2mZikrhq1vv/SVptSvOIUSsVfF2NEkwpFZ6BWD9QU=;
 b=iEpCB58vhksi3IpU1jA35tF8oH25b5XyfDhwRSx1zRiuqGo+Li28MQeD+Llw9sUj5imgpo2JZ+wh0nnO0STx5yNggCyMJnoiyC1O2isgh7ST6KYRyqlKvhnVyFZTzpBxh+7hDn11ajgT02CfbyUgKV3LvQbVg9g8YyMgmJfnuIPsmysP0CfEm7qLRGb/en5CdUTFVBJsXpeIvIY31P301tfhCsONX65BitYA6ayO8EG1j/ERL/vxcLQQzhNrHriRd4b6duFRvBHQI0FS2/Sf5VP5L2z4I50+hIUAOR2sEvT4iamOsRbBHoCL12med6kCgRBRfyxouONrqLUOfoqFxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYUPR06MB6175.apcprd06.prod.outlook.com (2603:1096:400:35f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 09:48:14 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 09:48:14 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alok.a.tiwari@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	angelogioacchino.delregno@collabora.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
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
Subject: Re: Re: [PATCH v4] ufs: core: Add HID support
Date: Tue, 20 May 2025 17:48:01 +0800
Message-Id: <20250520094801.411-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <8faf7a11-b312-4062-89a5-8aff192ee1da@oracle.com>
References: <8faf7a11-b312-4062-89a5-8aff192ee1da@oracle.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0047.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::35) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYUPR06MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: bb438ce7-d921-4e6c-c4db-08dd97837001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FkZlMAVBh4mZlvMclhDoSCO9gIufbzhqEeJ+TccBRdZZRMDZc3FfIL/dcKPr?=
 =?us-ascii?Q?TltpoKp9RH1bgTm7YGFkFUF3jVBwhD8Y9WrLe6yTLwi/irtKwpjTV6pt9bkE?=
 =?us-ascii?Q?6B0U5X94PGubwK7gUjIjcoYZgx325pPi9ztvMp6OKUyiqKizKwUqZJYiy/6B?=
 =?us-ascii?Q?rGe3oKxbGnQHX2xbc7Hj/6s8XnWsQYLFV7Wn+wjPsgWF1o3vFmeF01OG2tg0?=
 =?us-ascii?Q?WuzHxSnGdNT/+O/5e+Kt/M7aH0aWdCf9+XRJLJy1is0+iAY/g1VXlEjanLSx?=
 =?us-ascii?Q?6qQbeqR9r2XKyzrg9kbwKBIV+g0aAeQAT9z2gF1KNscjKaJe3WoxRo7XZxEb?=
 =?us-ascii?Q?OX6GY1EoWR49ocAub5UUG1tiLbHquH0cusN824Ngmkf9BurjEncDb97xzq8R?=
 =?us-ascii?Q?e6s9ZEvCj568ZCV+rA6iKhTCe7elhS5wn47uqCwYYBNkcAv0yGFa/zF8tA1q?=
 =?us-ascii?Q?1mEeyk4J5Yhzf765oeHXge6eK27Ou7fVPedzXP6WkBRAnY2bWmgI2cKhWxfp?=
 =?us-ascii?Q?CoqRRHmdfRqvsUIg+pCUIKXYFhngJWW01ju4zXnPnHFpSJiuwqEQw2McUncg?=
 =?us-ascii?Q?x+IIAnEZZElp2orlNou7qi7MyWxpE9QtMzUb/kSkSSCTkTAMVozUaiDzsTUr?=
 =?us-ascii?Q?X5k1QSSB7htvjwVySo0Xg+JrMGqOFp8VkzMvGxh9xER4e1Dpt5tGmISf2/IX?=
 =?us-ascii?Q?VZjFT8v1Cv4wAYI83xgcmZvq3an6J9uda1Dh5uK+H3vhUKSCQqYZP1BIKMLD?=
 =?us-ascii?Q?GELfrjbYlcjcLK0SJB0VT0K0DurGUGjZZ6S4lkd1WElikoOhrFdfreGwd2vP?=
 =?us-ascii?Q?Fik2Jl+rrHuDKSwbt9JupTwtlKvmiW7Tb3mSxNlhHJeshN10YUGCCqqY8mI8?=
 =?us-ascii?Q?FfobtWm7fh8/hcseQqESyCyZH746w8StEjR6Ql8KaHeZL0P/XLtOL9hFFBHV?=
 =?us-ascii?Q?/qWf/jHrrg8X4OWyu0dgj0x0JVzyMQyQrGKdPVRHP988t8VclBNi/ZoB5+Pk?=
 =?us-ascii?Q?iru6uFC1287owV4Xs4c7vunDQxe7d7veBUt87dK3o4I2wig8opyky83McPxN?=
 =?us-ascii?Q?7cMdQhKjxqCGRMccq9qHvascnFH5uCBR3SDLfR5pMtefs45it4g0ZNuWHzVz?=
 =?us-ascii?Q?ByyYyHMPkzrunkA5HfR5W1DqzzoRatjyIGUpivRkhz+nnH3jJexz++v+ioOs?=
 =?us-ascii?Q?jACUZv4+HiRBV7ICi23FYw9UFo0fOS2pRSsfjku+wpNhRYlu9FMfnKiJzFOe?=
 =?us-ascii?Q?HnGENsruPMMfnXfWZ8eGD/1hxbidti5ueweIxtpfUkkgD6idGdvBGRRn8zf0?=
 =?us-ascii?Q?sG/rY2Y2yg2+3YOBTfv1Gl/yf4wNFWYcDdgOB+lpGDKQ791i8WOEBiwWjP4F?=
 =?us-ascii?Q?ertHjs5z6/367PIO4qsscVtBZhBWUoX7LKgcoULlAusx2aNBEBLwA9t//SJ3?=
 =?us-ascii?Q?UrHUBKgdaTE+5Af/RN+uH3PEEhVyIJ4LnpzzxXc+tB/xWVv5VvGhOYVLJL2V?=
 =?us-ascii?Q?pk1RXKkrtF31w8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PRUM8E5JeQu1TSHCQCO3pLyvvBWMwAHIzPyNrP7HHx+2RjNfGfiZN98jdw5Q?=
 =?us-ascii?Q?2LqIv5MbbBD/lYtPYLQejtdmfKrm4o6swwuR3M9vh0fqnbbbVzrXmiUavOST?=
 =?us-ascii?Q?pKBtPj9WPchNDSb7SVYhLILy9WeZ15AUhDOjKFdpR0X1O5tiF4riU5sxPurP?=
 =?us-ascii?Q?NPhEM6yrMq1G+PbgvAyiXqzo89obWi3aNvromRvgQtMXFPcLolUk6RszHEkg?=
 =?us-ascii?Q?RnqylN003q5pJnGQD9Ia/w5tq1qdODAVUrwZSs4BkBITtBJ7MAyodMzNeKYW?=
 =?us-ascii?Q?yFwSVzqXB4vQKcK3dVIB9OP7fNqKPgPwInbeLG5vRof+ofXkqgSmH9ef/TSv?=
 =?us-ascii?Q?mUJLjji674VhFBdgRuSLEu0c+GDSOBCSLWjtCVk4wUXBO4KwJi3fVbreuwLQ?=
 =?us-ascii?Q?66yOy4/r5MI7v4IfG0XKgrKUZOBkoUvFGdkS3Z1lUvRyBUGJoJNLrDo4cO0D?=
 =?us-ascii?Q?zGa2loM4s6GF7C8NKh85kTznz/rY2O2L1bEr/VDUlCTjeZOVTrjc0rRwbXvB?=
 =?us-ascii?Q?3oB1EOs4Te3q4+AyRMYVE9r50DMmPhGE/Dti8KwKrSVN0SOy8dWYtI7moDk6?=
 =?us-ascii?Q?QxtYN4KfXagcO9cxYaz59Y84yxS5CFGI2h3OPijbprem1I6B6bpPk4b2qUbn?=
 =?us-ascii?Q?YMzomSOAyZ7h9R3eMQCRSqw8oJL9brhjCYD8DTgpjPqPm4aA1iGp4ZpnsmVK?=
 =?us-ascii?Q?LMuT2K2ePyCKBTq7Ebqj8sTQbdf3ehYHXmJ9M7TYmvpd7drQxz6z6hqFDia6?=
 =?us-ascii?Q?zMeuGVMVOKVq7vDQRwuS4V/WI5D8acFu5NmxgNGCxTIT7kZd5VAKeYJX9HeT?=
 =?us-ascii?Q?RLIS94gn/2O0dG2ZXeMUgeInQ5CjbA4Y65jYLPjrfIXQstBBszN8r6gfl8lk?=
 =?us-ascii?Q?qKIjAfgMGugrHhq+bivVKzA0gjAXtSSx2PuGukUzPpJ7UqmxhLJyoknDCojX?=
 =?us-ascii?Q?8PqPujfhnLMQRDWR1I+hLRVHlDYRxSgEs0+EZU1rrf116e7aazHm1y0dPQJr?=
 =?us-ascii?Q?bV2oaFZOJoweGwwMADzsEd9CiBy/wNTRBhdo4wZtdR+3NrakdL7ex37KchYq?=
 =?us-ascii?Q?5e1pubLqfNarY6RD/rEUAefdBNhAr0qruQfF+FfB4mlOuEm50uULm3JhSntm?=
 =?us-ascii?Q?IgWH5bC8U8Qd5iA6LU018tc93BQmyUwDf3XQPobhD5PbiC9+coS43mL6bcnY?=
 =?us-ascii?Q?JcBFit9NfcanT/H3jvikiEotKGPWI3C1nnsMKsrI5NSS/+YW9bpYX/8V8bfR?=
 =?us-ascii?Q?ITq0ZPXKSO+KoPvWFUOUqJ5UwNanKD4uNaedoX6SBob0euN4X/EWkolBsIGM?=
 =?us-ascii?Q?xdjbpC/fW/VbwTNXBT4IFiF1hQqBa1Oe0hdRdnAtg6/VV+faGW4ItvJiM6oN?=
 =?us-ascii?Q?Hvf7vXLgjW2uvy7VNczQWCkOtmk5p6T031IXG0Y5cuLQ5DDO7e1NNcWw8pfi?=
 =?us-ascii?Q?UToP04Oku88pxIGIRB5MkY9Hg9f+IFrsWEZHZUJgW8faaJqXPX4ne2r6s1N6?=
 =?us-ascii?Q?Nu8Q2IJlZnzKlRv+Jv5TJQK8hi7arvNYvFCmKTOtHk41z0u7/uyh/CTWf6Sc?=
 =?us-ascii?Q?rvPF0/hJMPig1V89i1+NteKlBpRnKue8Ef7Yrc10?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb438ce7-d921-4e6c-c4db-08dd97837001
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 09:48:13.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sc9FgqgbrovpiaIl9/aSVnBkEhZySmh9C99l4vJpPO0nhEig8fdrVop2oWc+D+vhMCAk3mA9OdBxTlGBMnvfIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR06MB6175

Hi alok sir,=0D
=0D
Thank you for your comments and guidance=EF=BC=81=0D
The v5 patch=EF=BC=9A=0D
https://lore.kernel.org/all/20250520094054.313-1-tanghuan@vivo.com/=0D
=0D
> typo indicateds -> indicates=0D
>=0D
> Idle (analysis required)=0D
>=0D
> remove extra ' ' after umode_t=0D
>=0D
> _IS_ is extra in an enum label, or sound redundant.=0D
> I think DEFRAG_NOT_REQUIRED sounds cleaner, especially since it's used =0D
> with return "defrag_not_required".=0D
OK! It has been modified in the v5 patch.=0D
=0D
Thanks=0D
Huan=0D
=0D
=0D
