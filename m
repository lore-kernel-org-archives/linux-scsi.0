Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4B2309A4;
	Thu, 21 Nov 2024 03:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732158039; cv=fail; b=JCePzBTdKwD5B1lEmrrWLjTOgOQ4GUrevw3zfY30lVNCoNu99ZCU5nNdiI/pT3hFnTbDadOnHwrUGrAWfAuvLQlKT3lek5V1Zmoq9madUHM5NWs0bRM7cAkSxMLkhO0ByLtMkE/hZP4UcZeFV3uu0hbqh8RpjcHel+c/dkuwQ80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732158039; c=relaxed/simple;
	bh=mq9GpbczF1RrPPw7Ilh9Gpu0B74FjK2RzS9oqWdh2AE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=b3NTr219sRjKx26LsDN9TjrOIDkNHA5NI/Qj75uvQ7CNRYFissqYUk28nQtOA8U6XyDMeltjyfgOFrZt/ZLeCVCGR55CcfQ0jGRJdBkpHaNg5ug5v5OZb40SBGXq3Pw0XJ+cQbpT1dpN8l7h0ORdtCfBzlzxNzmNtAwnch//NEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wp3BaOUN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FysnxC3f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wp3BaOUN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FysnxC3f"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL1gNBK005053;
	Thu, 21 Nov 2024 03:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7Pi1bKeWLabLlfQbPv
	jnqPBIZnJIORyACpK5CimJ1io=; b=Wp3BaOUNklYINNwQiIE55j1DdYAl6uBzmy
	OYR8YwNo+FLt6jeP+y9waW8rZUlCQTRtXr5CPX7dX74Kl7K0V4C0B5+s4Se693oq
	CvY4VnzBiSUySYQcslLBqtrdNc1U/j3KKErUbJbG0WtvvgCS3RQpaIusoAIlggV3
	mWz5oUD7ZuLKY3GY5/4JQb/UquRJygXeTsvCTC1yz9My9Ch+MBAzCFziOESC83Uj
	CpQG6EIPuw6OSchqsi8s1pb4NbzYyOsGQWp09k+8anI+zqsA6yPuZSHQCOGalNjQ
	ZbGpIhIqQxhofKbATjg8X+0Rxq/KmV0c7Suhp/t5OlkLLRIGk2Gg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkec0v8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 03:00:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL0rdKg007778;
	Thu, 21 Nov 2024 03:00:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhub16x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 03:00:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGtQmSMCEbyOJolDh6a8//cxV839xAJ2tXuGqLjK7XzY7/tV9WuQAJXcWGSKnpoQOB/v54+IQIgtpe0U0nEWzk0Vq5J3JqHXNGbAVwYYTLHqAFWTRyYgtBd2COKJdZp9prK2jItUnWT//YAQh96gaE7pPMH/fwFGtoufLUW5z8pcui7KToQJ0njvy+lA8ON8ze30rsdjFIH1SmszEgeXO7AxvPo4NyA/t+Qx8itaYywr7u5CVvTiTUX5/tHwvHP6/NG2mK9qP9ThCz/LghbVGfg/FafPWEFcqPZ5xtf9inYlVnnXMHT27ey5w/YraBldMMBcBNQEHDcWYPlyGQ0x8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Pi1bKeWLabLlfQbPvjnqPBIZnJIORyACpK5CimJ1io=;
 b=dRH9VHWSqUn+zDxANQzP2zG3WP90gvDNe+fQvDgAm8s5kGAi5ZEawRPYYntP1+1ukU4wN7Utv97lo7LiPObF2LkgZlfwKOxjiHrqN9+UZgW1IJkJeXR78P9nyiYxyWzLMWzWxpYiGvCbpyxhF/XFRd3XDsAnlkZ6jhjz1NYcEXO+BDNczCxaKZn4FZIL30SW0HcEI9Zm7seztDMTmTyKm62sn+NHVCzRGySbLK8bRrwQer0Sjc3cpdLC/u9c7cqE0jmMsIbc4hH4z0vWr/7OAYz6GgXKgpwu5IIiqVWWbKXRjF3Fn4x5hG032OY2USYZQykzzqJfZTEB64YHYLb9kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Pi1bKeWLabLlfQbPvjnqPBIZnJIORyACpK5CimJ1io=;
 b=FysnxC3f4XNF6HMv2cwpkstFj8GFyD0fofp+Wr+3uN1pSVVsThZaG/DIz20oAx6P1iK0Kf0wynyNPIU6e+LfCpHSC19PTxoL7ITZ58y7kttxVi2jGJOwxVYtL2Xis7++eTsnLciR6AH0Ou4qzrUOnxeHWO18VnMfYBdcncWb5fM=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by IA1PR10MB6268.namprd10.prod.outlook.com (2603:10b6:208:3a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Thu, 21 Nov
 2024 03:00:00 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 03:00:00 +0000
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com,
        linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        Alim
 Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        John Garry
 <john.g.garry@oracle.com>,
        Johannes Thumshirn
 <johannes.thumshirn@wdc.com>,
        Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: Re: [PATCH v3] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for
 UFS BSG
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241119095613.121385-1-quic_ziqichen@quicinc.com> (Ziqi Chen's
	message of "Tue, 19 Nov 2024 17:56:04 +0800")
Organization: Oracle Corporation
Message-ID: <yq1mshtp9zs.fsf@ca-mkp.ca.oracle.com>
References: <20241119095613.121385-1-quic_ziqichen@quicinc.com>
Date: Wed, 20 Nov 2024 21:59:59 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0475.namprd03.prod.outlook.com
 (2603:10b6:408:139::30) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|IA1PR10MB6268:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be8544a-598b-4a25-8abc-08dd09d896e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BfSamUlvxZ8IweexgVhsYdvBgwmQRItGNU0O42YoAWLVsazw2iupITzNsgra?=
 =?us-ascii?Q?0aEyW9d4ZM0c4Xfjg0vk30bsJicSaHENyX3C63J+oP4RqbmoFDounFC7v5ID?=
 =?us-ascii?Q?OixvzDo2D3hEX5x5C3cfue0MFCorpNEXApKb12vHs/GoSAfpRceLOUPs87qw?=
 =?us-ascii?Q?SoGhrIyNB0qqSQ3J9K2Ufx9Hg3Pro3wK2l7+m+TuLG2Jaw0WqpdkQdLOIi51?=
 =?us-ascii?Q?IljMe7BIIt0rnWyRoMvbGDQSF9/0CyNsteaGu2yviAc74c8eYkWckrcKXCqe?=
 =?us-ascii?Q?dWb2VwimMleFlKTE1FUoN2zbfk8iPuigICyqz04wRaEnbwFyzQmGRFvzo+Ob?=
 =?us-ascii?Q?uqSlb98zRMUu+qJF+hUEmeqWQxNORtZDwGhORn/t6cdLwR5r+h/N2gwP4fs9?=
 =?us-ascii?Q?gJKKR/Q46C44aLSUj7w9umS0H491EJ5bTPRuJJl8D1tNnApUU/qSFWrjcHu0?=
 =?us-ascii?Q?QeioQ/ygpRgbb4sRZTorBqDsP1O3GVfY/bdzFuMWXNWDDOtBcQzNVvx0Riks?=
 =?us-ascii?Q?kDrfsAm1DqkuBDeQIYDbtCZeeE1/RDFCIVO/r5CqYW+1/icYA+hBs7RaXbEz?=
 =?us-ascii?Q?adBJ7gtKCvelxB4wv7wvHQ58yuX+IY/Hy9/Ec6Icy/0REaHiNHek8y+M4DSY?=
 =?us-ascii?Q?TRCAdfDPFaRnva+R/uDlTRNWW/Izno+qaZHy/M+u0bldCbZf8tp7lXXKvM0V?=
 =?us-ascii?Q?/YPF1eMqiMECeC3lV5RW9yResaUuzjBvJerrX2LbX9YVVPuciADhONvZlhBM?=
 =?us-ascii?Q?A7ZzCagKec+sGxHKk/RFek3MqPiOggIsb5JxARIN2C1nrBrNr8WvGbJfObLx?=
 =?us-ascii?Q?SdiGCZnIa7/8O2oakRwCXMqPsUhUYwmahIc40qoi5IF1gqhJaFIVio+p4fAy?=
 =?us-ascii?Q?xlhExpn+R+Mhf4kcpLJoI+ocnnjhqSgKF6WMGwiLQxqzVYvm+VsfB7vo00uu?=
 =?us-ascii?Q?qAMphEIUYN/x6maBuqdCUExuGj0U/3iMdM1uN8FHeTjzNH3BUABcQ4oMKZxF?=
 =?us-ascii?Q?G7id4kduscQuFG9e0VCC3I4QUCD/1MKSOVMejZCGMwGGn3jf0gZTl1uHKwHt?=
 =?us-ascii?Q?bZv0LTjceFkCPO8qrNhXNe8OD1CpPLPRR+53i5AV/V53kTJiVEX6eZryTMT9?=
 =?us-ascii?Q?VS9gSCkOfoD5fL2jsOkIyHTffzh/GKVWYhyyrf2xaw4upPYZgeNWnRTZAzfC?=
 =?us-ascii?Q?9ex5/TIREW0owJEc63knjdCsmee8Ft5GYO5sZJ+1AtlX/PLbhhT/yif85DVr?=
 =?us-ascii?Q?YGjR7UzRi/mZwXNYtTq/J3lnnc4M1fdj+QK3pqUh41zJzCpkvBRXdr/JzvXg?=
 =?us-ascii?Q?mKgkapArH40TVInTtjN25uDi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sNefc8L2a7yOfl0ZtJqPsc/MqKFNgDVrpkroF9Vu6lRGelWea90eicbYIx9T?=
 =?us-ascii?Q?a2z2cXMSIQj6AOt/5byHPmME8C0PLnRNyM/cYn7H5yvfAuiMVGl8nUugGFb9?=
 =?us-ascii?Q?KgtsvT/oyhAcp23Xw069fvk339GlUxZtNdbeCmkDJuzghSxQYu4tp5jZ8Edu?=
 =?us-ascii?Q?Dd1EwvbxU9MnAnn1JF1cU+J45A0unvQZMhn3iw3aaVa3P8eOFSSKRl74QTe5?=
 =?us-ascii?Q?x8f7hkTAcyNPmiOs7Q7herfw2kwpjwd8BzYYap5TAI31rnBWJXtF2wH68x4C?=
 =?us-ascii?Q?2qpuM4rIzY8id+puEEMVPcs8G440r083SzMcVK0s197WNIQdE5cgqIyLJ4jw?=
 =?us-ascii?Q?tglgOcEeX7ECnx0mi6uaobPQgYuzJ1lmAq1VlQCf0FR/rKj0r7T/ewTET2EU?=
 =?us-ascii?Q?f4VfaHYYwzQ363A6wve0dBRsvficz7nA7buskVDT5nbYIkkVHRImezrC2n6u?=
 =?us-ascii?Q?E33p/snRet0kHlvqf7J2aAMQ+EoJGc1ZDDnmmO3qwGVY1MQ2LaBoFeIrVXWt?=
 =?us-ascii?Q?wysexkJAOtrtnMBenQMLGEi+ssZ7V/lrmlq6o/kAl1PwfkBnhwvzZ9rtFYkQ?=
 =?us-ascii?Q?7PMRFttPU9QphmSJhWtKs+moX6JuilfuJIPRR9P/Zljo+iXDXpq4z8JccxtG?=
 =?us-ascii?Q?F/sD4XTiaAU8jvCTtMZ4ZNoXUs6plxdy20kOpy+MeRsWK8VZCrkJQB+IzCYW?=
 =?us-ascii?Q?wAgpTG+5xn1RDeTWX1ftp9D+eL0XT7QfkColxistj/ziiBy0KXCRUb3RYtK+?=
 =?us-ascii?Q?Pnja5+WUf5xm39B89gxb+XScDcSPFJzXVyFocKrs8G0vm09w/ivo2Uj6mD5U?=
 =?us-ascii?Q?Pk8gBtWinjRkj2DMX5zjTxcbKHRDSp2kP0Jdd+mXA8KUYhI7wgu9uHxianlb?=
 =?us-ascii?Q?nLQg9+Pj46CZRFgKuG9HXcdN024P9OZoFqo1T+vkLXiJlDSogJsAv5kn+hq4?=
 =?us-ascii?Q?nEi23zOPlGnf7F8jZ3FT/xfBrJfmp0+8e3vcdsUbvdWbZmuJEywBxXu8NU44?=
 =?us-ascii?Q?Vv2A6vDabvMqc1Dt7EXi3U4BRt0H5Z0HFuPuKcLYDGMuKCarAxyNKDJ/mlQ2?=
 =?us-ascii?Q?UtF77zUuBPgxFn3tGrJoZStecfRIpQdk/zCtpgr6XaN6rn8abuYufLOkE6KB?=
 =?us-ascii?Q?7CbeCiRHVbPt/ghSFX0EGqQOXHqQn5XLc+Vnd1u/K67HVp4RmlrH9Rf6RCso?=
 =?us-ascii?Q?L9w3iq6ys3OtdOEbyQ81lo9NvxYUU0UK2VfkXFEmHY0LC1FuNQMRv3LmiWnU?=
 =?us-ascii?Q?VilfLYnmyn58od3IdxblYabeHpB2lTwvUh1u+nHCfS+20gK9a6bZblI2im7u?=
 =?us-ascii?Q?Qv4uaea2470TsYUuhPaPKV+LI4MDP5PyI+nXlvfGs487IsdFS1zZWn212lqz?=
 =?us-ascii?Q?PeCTHJQKVYle6/a5nfZUnZTSB1nfjpB4J84ZEqSsEL1JYhPrw6TH/XzurZOJ?=
 =?us-ascii?Q?CaECfMhLxwZqrNEF8RUmxZuvLZgziyzmnu0Ti2EZLrvrh2SXmbut47BbkveA?=
 =?us-ascii?Q?sXHj5MzRgd4ASlOT/GG0nDOn4u50Dr9rEHU74xFvqCDHRT5EEw9WizPI878j?=
 =?us-ascii?Q?gVBd9jBeG8lx/N3zH7PPEccs8uyghJQejupeXHAiwZ+T6o/SrTWLkrNA3GIJ?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fwP1NVuWh0t7xfVGtV5Whh188AxNHLlz7+QRzPqfQ4WiZjbYUMZEsuf2Iq1KlZ7+IJ+Gg3MWafR5jcXX/yTv/mr8rZwvSEpP+w2WhIvkE2HstReI7BQzWqFvPaE6pxeS7NU5DJzf0D1c0lU0ykptdfJBQFxDmzs9E1cSSkjUKoSkAhzb03n/BSfTckrVXkBQ8UP+eEsMRFncjRqk31En/4oh3k+PjkEAB9PT68VIrIaZ8aKqtBJDgwnYZzT55ON012EiuaMQC/ZHy5Mf8M+z6+k3c5uw3flMTeoX6679t6zhYTdTjddskNFsaIPfMPkugYVQgujnsvSYz+k2Topm2LBmwtm3aflDn8+g8nadyDJqu6fKsceYJwDqCVodPhcGLezVUXTeirOh+38xG99fAwyT0nSi1nZ2rYIMvwu+AqAc6W8GbW2VwNBSDgXN7+RxVQy7v9YFlFrDp+ScnC9Wnf/zKEtrzG+nFqjsm6r3gYD37gAZALzQeuewQYz97T1RvaNHruMU7J/CtC2V7maZ5WoU7Bn9JOkZ1o+x4EuW9Slo7S58iIRFqyw+xuJG4CtjFYJwVPCFBeg85S0LXYJOgHXk9DDOvfxwWhLDuqs9cng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be8544a-598b-4a25-8abc-08dd09d896e4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 03:00:00.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8S9fUQ38WVjrY4iZTAAPHiHsSykZyJQiZfwI+Nw5GP1/WukHe/XwHQzSfBlX1rIbTnTMiNmjDE2/dwBtKOns1bPJvUb9tlslR34fG7gaRNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6268
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-21_01,2024-11-20_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=837 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411210023
X-Proofpoint-GUID: lcccOkd87FPk5FVIYRXsx5FWVgT_OXZx
X-Proofpoint-ORIG-GUID: lcccOkd87FPk5FVIYRXsx5FWVgT_OXZx


Ziqi,

> User layer applications can send UIC GET/SET commands via the BSG
> framework, and if the user layer application sends a UIC SET command
> to the PA_PWRMODE attribute, a power mode change shall be initiated
> in UniPro and two interrupts shall be triggered if the power mode is
> successfully changed, i.e., UIC Command Completion interrupt and UIC
> Power Mode interrupt.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
