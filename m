Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04olkn2045.outbound.protection.outlook.com [40.92.73.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F29953390;
	Sat, 11 May 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.73.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715426339; cv=fail; b=Dt2rkwEf5MM5SVQ3u/0Tqc3Wr6QE3XHhtsCDztKC4GjiTEpIkgL7aYW+XBb/RCuGbVRFWOELAM9ADCnDvx74w8uzRXbJrfANPNckR/qRtaGh6jZIspJzkw3OZ7mUOHmC06jhEDma/j+YxkoDhgtD39PC8DEtMh9L41t1pRrlvDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715426339; c=relaxed/simple;
	bh=uMZZVQ3kPsHlN3AIfE0bR21QsKcbOzVSCcDf+vuUbOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oqWDMXvDjHjWxtTZSjaE9Z0F066cV3ZCIMOSWdAk2j/aEL9OQ907qTcs9m60k1nDNYXFACV38SqbyYjoIK5SBTGKuhq2G/fHXQlm9rdyjeyS62tkl0Z5QbFxjk+l1Y+gC9OE3yldNdo0wyq+smcYUVkE79UGy7+Q7uyxqgnt9x0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=jsooCApb; arc=fail smtp.client-ip=40.92.73.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="jsooCApb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfU/8l80TJQu5xRHfM5vWdzQw6eKYsdcAYctvTzgk6couZc46KFDOT83kqr11SvkZnUCjT4ho+HsaCOGwmrJq1WgVVpCui366GmhF5QyRUwRRlZOXiqYyEmWU3X0enPTUoC8mrbHfKIpWmoVH6h85qKJxJKHRzklTgLLnrKD3m0O+7XyTJgfkY0LOedM330P2whaLy4f3lgE7zNOai6c/lnFRxqa+ZSHtYUiI+pB4+N5BEXehefqno7OZfSz8bVMZ/fEwqq3de34ZP2oBOPr8FCjy4bIbZ9qLJIy8dzza+JFmybGqjPRTLO/XDAEriPW3dP2SKgwe2HFocwp1yGDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02prNc+2KpAXKIDg3UuXVJGJ7t636sA/5HsJ8IMfbjU=;
 b=afEbVsQTy9EOPtmTaW02vai6Y9Y3f6aV6aoPz+bV/CbAKNOzoX5UBKpY6rKrFz46SzJ32fjJSHtjh0GEk4Jf4c1dG5L8HAZmCTgUTkDWP/Ca6fyQohrATCVeV38v9bFS9cAO5RaFb13sBnDM1FkPL+KItCpa4IzW8+Pviu8iX7DpapJ3e2V6BWkahdIihF/ZqWWcPb9IRsF9BSRkfi0RJgO27J0r7/U4lf5LmNh4k7/qP73z8dWjA4ZaJnBRL8CuagHdlMFARA/OfODOURJZukIKqQD921EKfJ+ZBviSmkbtOQiSfMsHD1zaRFU5UqKnAAaIFFFbQWiyeBXzjbCmwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02prNc+2KpAXKIDg3UuXVJGJ7t636sA/5HsJ8IMfbjU=;
 b=jsooCApb1GRsnxKoPvZIX7TVuFUGbvgf9rxdx/fMWZ5taZ3l7AJ28w89IEZ7qy5SV5lynspOsqH88qax0faByqd7KC9ILZ1a7c1cWDutIwnRkYVkqOnw4DfRocyOk2HQw8FAI/mfw0siKkpl4I+tZM6LTzg78Pui9wlgZsAbY+ntw3YeQ0D+hUqaLsXgccVv9kARIw1VKk+qPP00UkfOtXwkqERFxhiaDDNBeDMwU0KZg46lNMPQqSvNB9w57KIcfJP4wSoPOqsXHqKhsKdJIPHL2NobO28JrDOGXigW/Yz8xZsq1uq5oL7cwB8xvvy+66tO3Qut8mlLJQb0swIm0A==
Received: from AS8PR02MB7237.eurprd02.prod.outlook.com (2603:10a6:20b:3f1::10)
 by AM7PR02MB6068.eurprd02.prod.outlook.com (2603:10a6:20b:1a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sat, 11 May
 2024 11:18:49 +0000
Received: from AS8PR02MB7237.eurprd02.prod.outlook.com
 ([fe80::409b:1407:979b:f658]) by AS8PR02MB7237.eurprd02.prod.outlook.com
 ([fe80::409b:1407:979b:f658%5]) with mapi id 15.20.7544.052; Sat, 11 May 2024
 11:18:49 +0000
Date: Sat, 11 May 2024 13:18:46 +0200
From: Erick Archer <erick.archer@outlook.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <keescook@chromium.org>,
	Finn Thain <fthain@linux-m68k.org>
Cc: Erick Archer <erick.archer@outlook.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Justin Stitt <justinstitt@google.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] scsi: csiostor: Use kcalloc() instead of kzalloc()
Message-ID:
 <AS8PR02MB72370EC6DA36600475300FC28BE02@AS8PR02MB7237.eurprd02.prod.outlook.com>
References: <AS8PR02MB7237BA2BBAA646DFDB21C63B8B392@AS8PR02MB7237.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8PR02MB7237BA2BBAA646DFDB21C63B8B392@AS8PR02MB7237.eurprd02.prod.outlook.com>
X-TMN: [f52T9AcyEzrRgDldOA0aInv1ESLIrKUV]
X-ClientProxiedBy: MA4P292CA0006.ESPP292.PROD.OUTLOOK.COM
 (2603:10a6:250:2d::16) To AS8PR02MB7237.eurprd02.prod.outlook.com
 (2603:10a6:20b:3f1::10)
X-Microsoft-Original-Message-ID: <20240511111846.GB3139@titan>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR02MB7237:EE_|AM7PR02MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: 754762f1-d637-4ea1-2d17-08dc71ac2157
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199019|3412199016|440099019|1602099003|1710799017;
X-Microsoft-Antispam-Message-Info:
	x4IFrhVBC8rQx1qujeoD/qyYb5C1GJmQQwasxYeAPMzhbuvQA7FvXoJZFPAdB0TfooUUBt/mtQaZlA5L438/yiNVIX/X7lcpL66KA9QBpt/R0Y7mG3gwPHj9cihPM9ooOsVJN1xhGuse8zySBNtbFAobwhmSo3qemxPDnZyYijyzFXf/OXGU1WFQb7IEt583cClX55PavlqjG24NPsIRHVygC5fTCoCp9GHBu3cCCIu+dzQnekBl2lJ2srf+4CA0ttEkKgAgm6Ml3ys8dbX99ladmFi7vyIv4V6g6ybZbzP4QHT95+IyjhdGPChYzuXyUkoju9qcap3XWai+U/cBaXijZvyNQW18ddX1sN7+dOt4FFSUTMKtFKbJB7Oyqk9U2h+CeM4ndyKvkSF+/XeTSFH+FsUWWfRQTvPor4EyspETu/Lnpyee1X+v+O5wsd/rgGQAZC5ZOgIGB6+zoNUnyeTiOUmPXY2lTkr0r44U1gzRkdo+uIbelirDBYCy/3OfiQcOwS+/J+MHeheIrIebglAkrMUIAStXfNtDTf4S5H8z6LqT3h98AgZ7d4Huy2vtKVZKUWq6O0qVnrhC4Rwg7Zx1MUe6DoYGhvOE4Ks6rbJSW6txs7yo9SXnr803ruKUsMaeS4Ul805nzAGpDXiWXXh6BhYaUZdyMOPnyyiyFA8bQzf7bqlQYy/3Bjqh35cn
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lXoqp6Eq+oLh5vmzumgOCtOcgumCgu9cNgoRHjS9a3bD4CDRbOq6dpVV77RC?=
 =?us-ascii?Q?YZOXzHLo0ITS2zk0DYAURa2QG5DNOYxSRfBq/84EqQ7fEqs6n/M8Xi8CNiTP?=
 =?us-ascii?Q?s8pGE9zYpFt/xfBHL7iL3tvcszjbid0MVxy62TKSLQMAfNHfOFcm+I90i/ds?=
 =?us-ascii?Q?ov82dAmkqJSpLnVkzKEws64hsGMLRZGcf2awN5/mBRPtKo8tVuGarFOwFXiA?=
 =?us-ascii?Q?wrPivya6JnASr8yRmGys03s+ibAueOhTok2TdOGaC48m4NKWLvhzRpeP3jxY?=
 =?us-ascii?Q?c4VCpUfZpeFiQ+OgINV3xyjVe0/tCtJ1PWFukMTpSDvEEVV2jIB4SRYVtjh6?=
 =?us-ascii?Q?uPB/sFBoso092CFo7eWAZhQ289T2SFJeieyrd8NcrYxoG3+k0TBBqnfDgDgN?=
 =?us-ascii?Q?Wb0BuVqLWTgvhfP7YIG2VVZ9RFvYtCFvwsnHwe/5coKTIXA9qCy1uil4/Uvg?=
 =?us-ascii?Q?dDMRRk8wKGD9ZASJpca+zaFZWi+f3qIWjINEcSyBr0uYTSuBSyY1fT1ojY9b?=
 =?us-ascii?Q?DxoJN+CSwITwAmOZUOSDXuOCDo+/D12Tmk5qQx1uzwQPfPRImJXReBsPhvl2?=
 =?us-ascii?Q?zxtLykE1fJByB0StMxISBsekkjEUBUAnC3mjS6qWT3/Ho436a7vsEKFP1E0O?=
 =?us-ascii?Q?LQf/35HjHL+K4BGowgFqp7nmTCOvMz9MYJ7L6KyYOoE6tI6oWyq+kqQxxuP7?=
 =?us-ascii?Q?4uSQ5GdY6ECSuME2Z8slnChjd/dg3Pn3lujRZzbNIuPKr8NABiWAE+emgRcW?=
 =?us-ascii?Q?O1h/8+TBdVW2SbbqSbYyeaSLMzQk3xeFBdgvFtlfyRwBfxxvZNIe+Sw/sUcE?=
 =?us-ascii?Q?KZQLl7sGHDPKgJA0B254mzACmIoB2OT0SSYuGQj8DUEuMV2ZGP7tmesgez4g?=
 =?us-ascii?Q?PvJdA6MNjbYcPjo+NtuY+vW0E5n3i9VgD6EjrqkfxI+mba2z7tJYwdC11EKl?=
 =?us-ascii?Q?Yl68qKfunCfzF1HIF/T1WPzfpuQnsE+cWFhOxyjcNK8VW9q2uLX4CscVwpI5?=
 =?us-ascii?Q?qFqYqx4SUgUeQw0+/jEpZD0z+pOUfaU3pHJPfF8GTocT2yoAUzItLzMkCU9U?=
 =?us-ascii?Q?vdEA6GY0LKJEQeuyL6g59/+AI6csejQah1Z3wLoHyMlpV10JwAK2MiZ2qGe3?=
 =?us-ascii?Q?qxEIh8MwUNkgkKorSB/6gTssUrZKnRU7hMUxYUYEqxyTAcNOPU+SF8AKsNIK?=
 =?us-ascii?Q?P5YY+mQb0+5h4YiIE/oljifeiriHRqOe3Oc4Mlf0Ls/j7adMyVgjZcuYVkqh?=
 =?us-ascii?Q?2hCRHyPYs8JzuEjJCDxr?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754762f1-d637-4ea1-2d17-08dc71ac2157
X-MS-Exchange-CrossTenant-AuthSource: AS8PR02MB7237.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 11:18:48.9155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR02MB6068

Hi Martin, Kees and Finn,

On Sat, Mar 30, 2024 at 05:17:53PM +0100, Erick Archer wrote:
> Use 2-factor multiplication argument form kcalloc() instead
> of kzalloc().
> 
> Also, it is preferred to use sizeof(*pointer) instead of
> sizeof(type) due to the type of the variable can change and
> one needs not change the former (unlike the latter).
> 
> Link: https://github.com/KSPP/linux/issues/162
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Erick Archer <erick.archer@outlook.com>
> ---
> 
Thank you very much for the reviews and comments.

Regards,
Erick
