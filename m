Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D2134BD;
	Tue, 22 Apr 2025 01:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745286974; cv=fail; b=KLftcre3L4GkE7N9aYXChu1ZCnrRxdbYOU0qH7scMsIcijWWN1O+t/PNOHSa2qZam0vzGjLUkeOc6WZyiyhKwGdmGcpB7Bzpt22htVJnvhV2vO2ICURnAaq1zcaz5gbJ+i7ezbzr2a8oxp3bf10xsjjAgHmqXvWTjk+fgoI6ASA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745286974; c=relaxed/simple;
	bh=sFOkaggZo4d7aE34AEkAmXs/Z9xV/GnunGtmOmmQ99s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iGG2jYq0at423b0FZ5f5UsyJgMb8RoCa68Fw4wBYW3MNmGTwfMyRJaG0W2Gi4FcE8rRNBUdDsNp5I7UDMYuevNrXkoECqhd1Nvb9t7mLnPICUXlJ4JD4QdWODm9+DOvcYZu62B/hhCBbbc49v7TFDONLIFZAqclANuCVFJ5gatI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B9PuIzqd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hvxyhiu4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B9PuIzqd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hvxyhiu4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0ghQC021920;
	Tue, 22 Apr 2025 01:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=bMyci04CQcBpBVHsb+
	EDHHfw3FtoT9Frt8sCrydsTps=; b=B9PuIzqdJ9jTFLI94WvTFenemFk4bsxgn0
	JOIrgrHmp1/It6Z2AVnhJiFhP0UTRLqkW5TtyuCYAMmDOlZcKpUXd4EHQSLkdUSx
	4OOVbgnEkS4U/k72WUhukc00WEW7Da+zM+YScrJdKK+eTwpGj3u6VpLWpJQYi5vy
	jxAPcj8ehK+PW6/UIa8xnlYUKU5icvpo+HG72lGPXjuHESsnKzUNgioo+haU+mUa
	dVly55NH03P0AMcWRlRoH4t7fFzP5QpU2M4RxzYgCO0c1RRCkTMfT8uiKYcdhSXp
	zxNZEELvg86S1x/0cQFV04FN28IvsKeS34+NWaJBEYYLl8Eebwig==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643q8uhe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:55:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53M1qapu033440;
	Tue, 22 Apr 2025 01:55:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 464298qve3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRTQ8mMA+DmS0AOyIm4dnvXnegcMHssDkGSvh50AQ3Dw3DbjGulC/LgPQoJM9iqTpJiIGbWtA/WfomrfU/ZiDqSJcT2tUUKuxH4lf0d5lyl3N2pPQi1if0zsaNGAS7I7TeqeH2reLq3/l5KArUEcjnf1sDXUzz9186iuvBMbXloTp40K7TLkU1lTmT8ULaG8ieUzqOayeAauiXd1r225WUG9AYWUf2LZKuAr89gultl5dohbelpj7784/DpBWwC1+8N6uPmP8qnzcNPM5a2vsNSWc5Wq/8/E4Xg4u9tE5vn7nrai4lJQwj3hP0HoV9RVD+EWouuB83YuO4fe3c5IPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMyci04CQcBpBVHsb+EDHHfw3FtoT9Frt8sCrydsTps=;
 b=Yf9Qhg1hGVQylgK1LISFJP7cwIMUojdYHW110kk07Zd5dp/0pzQpGsYrTXyGcU7yYUxlWQXx6zpfCkRBVs5MQitMzE1AcoYSJki7RzXOrFZa78hmh0X1KSwQcQAQk+RLYX1+bb0DybOXhEeFNeEEXTs67fY83bQAqu1DRHBO7DqeKI8TdXawn/xrgYzXCSlRu6m+0ZhWlNN5KJojTIrXTBJsqkV5PsDZCa9r7TBMbbGpzquFckkIdCY3DZECaglFg84PP/JqdXIaKTNpWPwH6Ni8z3iTeROHJ2AdsTR30nwT25HQJDdcjA1EGJOHGzOcV7mmpJSwp78ans4KZVuPPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMyci04CQcBpBVHsb+EDHHfw3FtoT9Frt8sCrydsTps=;
 b=Hvxyhiu4N+DYFEHkR5VULpmJBwEQRkh48ABJZ56A5M9MkNxU7GwbX342MqPBOBSQS69L+U5g7LsoFfGMigkF3SRPvld0x0X9WXEV9xd0D5NKE5+2Udvr0t16LtKpEzpdpc01A9H68ZkZ3hpOAPYsvxeEZUd/3zbV+qIElE9hcyY=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.34; Tue, 22 Apr 2025 01:55:54 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 01:55:54 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuyonglong@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: Re: [PATCH v3 0/4] hisi_sas: Misc patches and cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250414080845.1220997-1-liyihang9@huawei.com> (Yihang Li's
	message of "Mon, 14 Apr 2025 16:08:41 +0800")
Organization: Oracle Corporation
Message-ID: <yq1fri19cym.fsf@ca-mkp.ca.oracle.com>
References: <20250414080845.1220997-1-liyihang9@huawei.com>
Date: Mon, 21 Apr 2025 21:55:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::48) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: a340ee0d-d694-420e-b219-08dd8140d100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?93WQC+vFHPgZ6PFjxz3dLIYeEL4eXl5gH8ohFk1EF0CNygUlJKH0bwLW4Cc/?=
 =?us-ascii?Q?txMr5I44LKOoenp1gX31jBNHLX1MU1P/0XqoUbhxdsK7RmKi2H30c6rnKSEE?=
 =?us-ascii?Q?nyaBi+DUJBa3fNlf2Sikn5TVEV+BAuG13r3i4vid+HGxyy0TuHTWnN3liyhI?=
 =?us-ascii?Q?ehydrJtb/5iMPh7pQ4W/mgOwMeenAzodAPFfOLMMiTZNKZetVU2sArYXoRUZ?=
 =?us-ascii?Q?sAsFOmk71hpsg4gG8q/d2JNYgqVZfvSoBdaYrQYp1sWG3ha0Z0iqGkIZSA4e?=
 =?us-ascii?Q?gDvh8HrBHJGu4PbMa4rrjyTkTkDk7EUlGM5AREMNxQ8IjaoBMpGEIVTQ5qRu?=
 =?us-ascii?Q?UG7y3cXFOIg0hTYnL+2SKQMEbt8vbTH1h81svJ+5sVBSpHrapXvpNqoU3kRV?=
 =?us-ascii?Q?gU5j4tSM3S3Dqq4fhDLXdRl4u10pP3BmGpIQiYhTq+3C354HYjStxmC9wkNY?=
 =?us-ascii?Q?vEljwv1Qee9GqC4sqw1+WhFVrsF5AgdLdlY/eA/QhwdXAGVqSxoBb21ZbtmO?=
 =?us-ascii?Q?hj8cXFsoEUoiqdlqPv93YqToq5I9y4nA4NdoZgL93jjq/MwcgHhv9FLRru18?=
 =?us-ascii?Q?dwka7LnPnqeTSmuqIO/gvB2d2a/IyqS3hctVIvXo30hW45/o/J8ovgHCg0vl?=
 =?us-ascii?Q?AbChtb2e1umpd/yzY/hKyUTSUoo3q1DMeoftEhmb6ZfpkOzLDKvm+Pw76JMA?=
 =?us-ascii?Q?R36PQbYTt9GxhN4VOeT/SLRet79JZimQUWAljVMKFlffGljFuzSSNOCY2ohR?=
 =?us-ascii?Q?Qy/RNTFvhb9E0lqdx1MSD+doi99Cd0MntPqD7Gr+WlqNQVh4lgFp64AmynYc?=
 =?us-ascii?Q?/pfRWDw/DebkJ9FxnoibTOvj09YKC63C4VXiyadS7GX5e21uaOmDino9QTGi?=
 =?us-ascii?Q?a35e4lsxCIvkhFlo5e/AIBL2Bbe2aWz+n3IAMzwK/HD3fhU0QF+ZR7ILts/r?=
 =?us-ascii?Q?KsMBDIGkw+cW8zcUfURXQzFyKEMrKRJeotYpu0S6maQ1dMDlhR7/0zMMF3GV?=
 =?us-ascii?Q?pvWrVW6MQf9jIjonStlYVaghxBSuEabkLl7h9ufMMpk263Jk0Mzy7FFRhCdf?=
 =?us-ascii?Q?uVYGC5Lt4mP26d8d2l/ZW8iaH3hnjvJBl8hiascNDhqCRu+XA3csd0jonepw?=
 =?us-ascii?Q?Prec0DcrKOaGT/HSSD2s+7qqFK+UhY01NUEKXMK9cNLdXWRAG+bdtde6e7y7?=
 =?us-ascii?Q?rIErrx4ibXVASgUn7oIxrd5WQkW2EiHUje7bPYs8VZymUvEv0ydwB1l0NCXw?=
 =?us-ascii?Q?hOw3RXGUiK+zPB4VmsdXdIqfFwMOrRNd9ypKWyEvx0694PjI+uFiwi21z7m1?=
 =?us-ascii?Q?c9QKBlsICkXx4PS5fNtfouGDgMuaA+H0fPuvSbHdcFGFj5CO+f9sV8+w7XCk?=
 =?us-ascii?Q?Lhw4UHXlaMD0Wl8kTn9ED05LjmDSWqCLYbJA4eby/gqiRSkGrwu/csQ8voW6?=
 =?us-ascii?Q?z7RYUSHby0Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xa4ade1/abZoUB8IV3YW+dusclmxSuslkZT5bqbPjwhr75oQp7InpxWMKCYk?=
 =?us-ascii?Q?cvUtJx8IlC6IFb9pDvWdxJsv6juSELhIzI+iWukq/XoFO9pqqjphLWoz/XBz?=
 =?us-ascii?Q?KPrFIydqfnRhBx5b7xnpVVTfRT6E8jI4kuPf6SLQsy4XeuMFN/CjEbvGzVPa?=
 =?us-ascii?Q?TrD8/byqfcN645JCN92TellfBjxbonANQ/lHE5b3ivLSVRL4EI+4mv0/F7hh?=
 =?us-ascii?Q?WuU0k99ADh3xLp9KTEIyKha1YwwxeWjNB3MEvf8Vl9XcISh0RxuBitvcCl+0?=
 =?us-ascii?Q?NFPXQ8Ek1R51CtsyqCTKcsA+vnU13BFQbhwLjd91LP4Q9Uve0UgVotI6mew2?=
 =?us-ascii?Q?R8UAUfNejCZ6ARY1ZiMaMGIO2TasCqOArClMP4jWp6hiy6GL7kaaHqxlzqgc?=
 =?us-ascii?Q?aEv1gRZT2tns595L1QTKWkTn7cfIfQopVE5HHXpbWy0Vj4SYkoOdazSLIWDa?=
 =?us-ascii?Q?0dEz6PqubV0DU5A10qgp9TtXFaxZ3Hj6N5+hTXX9SarWLjtmGkhs3l3TX8fz?=
 =?us-ascii?Q?Qt1CIV5PnSw3Prp58rsn9vqY1ZL02lVgZnYlAyA+zLrrjDz9PpAFEt99W5Fn?=
 =?us-ascii?Q?M49geYpach4YQWqetzHlIJGAZuw499OoMC86v/TtY+okl6O4UpGosxpmXjGz?=
 =?us-ascii?Q?3ekT7LPg2WM5f6DZ9sVZy214Bg8C1TN374JtQ/oMvslu7mWp6Gpjv+ysu9ZF?=
 =?us-ascii?Q?7uU8/gVHyroLE3fPYpHSM9Ct9kA2LbsMG/JcCODq13yuob5yFNZvWKqnV619?=
 =?us-ascii?Q?W1So1yHuNLLSsu0dAQb08DhpJvUR9/SgnoZQ68V2nm7PhgbROLBu3srDTTOn?=
 =?us-ascii?Q?T8WeLOgfx8UKYaFYgi+B2By9jawHeRHDoIfQwR0bq2uxefYInwN9RsViufuM?=
 =?us-ascii?Q?/blhHbzXIYYMKl2kRh/1+i4xG4VpkZ31xlp5ByfhP10djPK+rJs2CFHEDC/u?=
 =?us-ascii?Q?JR3+eZ0cofwPAMsTtsoiGV/P2fidUyZV5VrwHEvQPRr/wx+OAIgeLTDRaQ2r?=
 =?us-ascii?Q?BqQ+1ggaoPVPsQZhWL9iD2HJehvkTRDXk8oMJgXRW7UNLvc5VGUIHYUAzvZi?=
 =?us-ascii?Q?XH+S+uipB5D2aXgoS+8GyXGj7euXQW2/FZd10cnjwf0U0ljxIImTpZdyz5vD?=
 =?us-ascii?Q?i1oSdYymJJN/xQq+laRL/ikFI8uT8nWkpbsEKfD336cYmwH+W856DjRGWDqc?=
 =?us-ascii?Q?qrsZkYVOj9wD3PGL018gzvTgv3FmfTPaYQ1FHJBEt+Hb/69X854L8uloAD06?=
 =?us-ascii?Q?3ZEvaF2X+WpgQf71Rql/Q6eSOmvvrmddrv5UHl4j5+dZGH/8HTkHmOkyLXFP?=
 =?us-ascii?Q?sMGQQDjsQkHG8FANHNAZoxV0ZemjryJMN+W5n90iLHjHNqP6crjOMDkq2NfB?=
 =?us-ascii?Q?2PawJXVPynDRlklnrKzurf0c6zbLEXp+ObDAVlIeFcWgkUbDd21syXci12al?=
 =?us-ascii?Q?t07lhkxJaMyQRJHvbS8gjM6+GGRpo/C36GenLXtb1Nmrig0eUZgOKzLF4yDF?=
 =?us-ascii?Q?7FgkRBiIxYvCezfIfew6tiW9hKeGBnmc8RAErZsMum8z7uNg7geplVpcUCNg?=
 =?us-ascii?Q?16RFI7ZjyOisQAJntOkWTNPah57VhUyFHqPAMsb/bUqc/iQIBeNxJ/yDNmKW?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P1MjhKSzBiIHPnENLi5804ZHVXOHVfbWIfBT4BoxHuj3d1ym73MCEhJ3NBJwt/LPU0FXR+ibSxhFVjS3YWkTL/oJKKNaAlGLE6ZosygJOtHKm/CfsrEFl7xijhhn/O882ALdVBFkLNOEJ60X/6sU4qjeSnEaG4bpVNpZxN7402Q43nmB6lpoQiCvuRgP6uviO6ExzO35aMdK3904HOuj7ZObWBAjo3iHtOU4Hov1pl6+RCJCEBViHBOOh6miYILAaBPnumI8/1gm3FfNX+pWa5TcsEh9ukgA0QyiibtAIv3c0VNWFDQfo2Y5bpuN3V9kYyy02p26uXhI+WNB9XsJ/oXUMNRsdurrYnz+HuJNGZkeReIIKYQcKNlbLskUssEIHYbHjnrMjrtYL5zcBQy9JuLG+lX2M6O6jwNLH9y/lPS30CHOik1d1qxY8p9caVOLgBNlhmrMTS+BiXcHUjc/3NzYTf1kLWSwrMRpsmJDZ6v4D1sgsa4eib5oWszrALR7QUtfI9B8IFQAC6FgcBteFeiPSu1WOx/Y2pL6mK4xK3f4vGYTc1F9pEDd9iM2u7bpeg98FEfWcHbNqjVuDDF+n8lVyLEDPPCit8a5hT1W/1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a340ee0d-d694-420e-b219-08dd8140d100
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 01:55:54.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jB8UtJUBiqsRZcDPVmgsZcu8bdVJ6V0mb1DLoR/lt5l6DEKAJBgbR6lIccINpY+UNzP3xspMXRTycmAsKUF+gi/91AXnl3oFgqdUMrOEnCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_01,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=826 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504220013
X-Proofpoint-GUID: w2C4a16GVTsVP6Y7-FcSw3bZ2QUfr5sD
X-Proofpoint-ORIG-GUID: w2C4a16GVTsVP6Y7-FcSw3bZ2QUfr5sD


Yihang,

> This series contains some minor bugfix and general tidying:
> - Ignore the soft reset result by calling I_T_nexus after the SATA disk
>   is soft reset
> - General minor tidying

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
