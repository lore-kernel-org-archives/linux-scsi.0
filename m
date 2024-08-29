Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1357134D1;
	Thu, 29 Aug 2024 01:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894337; cv=fail; b=mVCUhdKYe7YgkaJxrbR3xx+Zv+c4SKZyM5gVxCmsP0R62sIugnfVGreAkVujm/Qg8UJsukEOg+SEy+WYe/nC2rhOEIbqaGdtem4ErsJcNaEmAlFLg8Zr6PNFGFmR2xbClIdg9Nb9uQUxqDQ7hI6c8d688xN+xQHpPSrxV4IJAFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894337; c=relaxed/simple;
	bh=uNW0biYZMFx+zsHRJjPJDtZrm1HloJfOjh2+QQZGUWs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PtZLVFlP+maQ+SVjNES/2Vf8TkHdR2xBN7QCzarn2Kwp+zjDRpiVX879NI2bj/vkG4firbIQPM7Xb+9d/Vyd0m2FozNrxNBUHKI2Bkh5OMgTyBuKb1+LaznOFNoMmk3smdR5cZHlRxAMIU3zP1smtN40+BhggXdaRlVUE1Ovjzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iHS91h0E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UUgLD8Ft; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iHS91h0E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UUgLD8Ft"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47SKiP63003324;
	Thu, 29 Aug 2024 01:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=FsWra2OqJD6ihV
	yU/KjxKLe4JN7b6TyDpRiJ9cVNk04=; b=iHS91h0En4x7iRp9B/LV1TYgtSG5mB
	252CD+Q8m+/svzbxtRt6UL0hWv5HIBKZVkLxEgVJlGWK5lb0z/xOfBbXC1Z0aIJR
	y9qWufy8UKRQXBIZvcJ09hHAhUilxvflFPJne/uNBhfQKT5aaxA68162PCesZwDd
	d4PMoabwKRCNEjmCptd+r+T9EZo3Gh9bQSoJtGWJ1DKp2+yQk4OJ96BUdToFTlIZ
	HMQ/sq/etNIxT300IwUuGmEjFdFFlThxANWsilCPXuUK9I5I0+RasF4izKNHoWsp
	Dv2xoaq2lflmMgEKVyJd/nVWFk+IpDAWl9DKE/Aix9yHKIPy1XyZpBtA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pukjyp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:18:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNTsR0017475;
	Thu, 29 Aug 2024 01:18:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 418a5ug1s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVOhGQOWVyvbE9IVriyOY/auK60G1hmLzUkfQ5fd+OIzw8jQkPc7lR5kap62pTe+lFXuHfglu4vVLGTJE52aLsJDEdCV6+/uHqkN3OSDco9nem25f/vA/SNlnvV5cgKTyxjSwLK/zTbbmDqmCFe/dyVTAXPMMXWNx25uxukJIX5e37IW1VfyTvTsgMivUx5rnFzv0ICCm5Xdq+qR2O3vmFOcMZv8c5vHp7CNXAtRO0jtviF/NpGB5ZKo5vLvpxDeZECvezC+3BfIsUMGtJE8ehwQjRzcdaiH8utmMAm/h2Pmhbwutp89ubimr587GNYVdCCEU/y2vnUuko1Ow8N7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsWra2OqJD6ihVyU/KjxKLe4JN7b6TyDpRiJ9cVNk04=;
 b=q5sGvXgX6xW5uLUKTI2YATYYJFfxxkO6JA2I5mj9esj3gjqeJ4YMnRRKtRlhyKeCOgDQgaQTBPLmJDXoKHiKEaubZG7X1grJVE6aNJk66MCydYWbv22JQ4Sje8ONX72lJGQn397pMJfOujpK0hncnCF3/O9ThAdcu6mh1vGMF7zmbsxag6FjoirYyVOAG1yEW4hDtUBxaiBuhR9jAK8F0FElURDLJ3nCwQmxuJ5LWmk6PQbnC5RNSxE0JffmJ1roTny2GQ+1RsmbW7tnV57QoUc6QQOfYvkttQFL7qRaO6JHY4nViAY4uZfYBK6KOCoAIBphbdu1KT0sFS5xmrZkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsWra2OqJD6ihVyU/KjxKLe4JN7b6TyDpRiJ9cVNk04=;
 b=UUgLD8Ft5FI0A/PIm2vd9lxxztyCuHOh5cBfMP/CU4sUIzxetGWr+Y7PzCnKcNkPKCXBdLW+1MKr+sgJGMEGE1mp6Nqac4t0PM3nbygKxIaxolFsMJA9ZowZFkm8eZ3Wh0Ef+OkjV7LOGSg/S+BdDDhtvTx3GacxEacjFnOzaBs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4887.namprd10.prod.outlook.com (2603:10b6:408:124::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.17; Thu, 29 Aug
 2024 01:18:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 01:18:33 +0000
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, ChanWoo Lee <cw9316.lee@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        "open list"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: Remove ufshcd_urgent_bkops()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <0c7f2c8d68408e39c28e3e81addce09cc0ee3969.1724800328.git.quic_nguyenb@quicinc.com>
	(Bao D. Nguyen's message of "Tue, 27 Aug 2024 16:14:13 -0700")
Organization: Oracle Corporation
Message-ID: <yq1cylsdt4s.fsf@ca-mkp.ca.oracle.com>
References: <0c7f2c8d68408e39c28e3e81addce09cc0ee3969.1724800328.git.quic_nguyenb@quicinc.com>
Date: Wed, 28 Aug 2024 21:18:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4887:EE_
X-MS-Office365-Filtering-Correlation-Id: ee22ff30-8ec9-42fc-6af5-08dcc7c87fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fkViY84JPTlrGinfAkGhWSD26A3EfGlzuO+5wfYZB4w1zp8X4k7NDwJ9NKQo?=
 =?us-ascii?Q?NtjKag4dvXwVJZ2iIjEaeVe8caC51W/BgAHk4gs09z4Q4PB0+4uhZq5yRYzc?=
 =?us-ascii?Q?we4X+yUSR2FG89HB0GYzE+GzAhG8XxCEKIYbUHw+fZRCcNVBRbGARwvl3ok8?=
 =?us-ascii?Q?jIpBdNAIlzDDQgX/7V7l9xFOyHP7uwrBSSEFMnueGsEdJJhLm8SQbuQhW6R8?=
 =?us-ascii?Q?JEb7L5vxQaSEzuT6H5+j0fuliyR0Hm/waE39Yw4izaZ8wEiQEJJYThXYSWLX?=
 =?us-ascii?Q?XCSoZEcZWRijqSqqT4tO6zsQOJEp9SUzopHtz8Vemr98w/GkEA6cssd8XdEI?=
 =?us-ascii?Q?OQjqjyDjKw8LRBzhYM+T/dHME+7cW2asY8Us4NuCoFhB1OwEK/MbQ3F7CVKl?=
 =?us-ascii?Q?nXt1z3JlRRD/mrpGD0dpgG0gyXG8Kj5LWImxie79oX0/mUZzTGmT378ZXiHQ?=
 =?us-ascii?Q?44/Q/SrhcVCpDkpSIzchuUS6utskFAY9Iq9GYMNPvMHKGS4Zamrtgp2aSSXH?=
 =?us-ascii?Q?w/L2UbmQ8b1s1fDRLMNd6o9v3TCcnp+7VIYzVp4h5mLKXMBmybGJ5+/t/32m?=
 =?us-ascii?Q?gFcwFgiFXLHo+G0dxqU5TDnn2M8s1brAWnRzVy94EqDL9GG+MxMLpSTpfQdr?=
 =?us-ascii?Q?mq0toX1BAl2SF2X5IoXA13n25C7EDIRABmc16EuVzk2Xb/img+qeVDb3ZulW?=
 =?us-ascii?Q?EDaHBGz0Z47mPvyo3GaNrvUtEt1DwQUrCcDaH681vaVSWPQXjyjbJTijDQH3?=
 =?us-ascii?Q?9uHuIc699p02D9A0bdXH7VA+55z4cDOf0v9kQRj132DB2CISFgaGl1TSG5HC?=
 =?us-ascii?Q?FsP7q+FLbY708O3+47Bd/hAKh0UOilhMdAzYxHYQ3nTxfKpyuraCKwHEBrq5?=
 =?us-ascii?Q?3lLwEiJTDNcqxqQwlzRiQolPHweXmXbnNTTRK2QtAEFNISanHHWUYIxFAaEw?=
 =?us-ascii?Q?ovaMjWMTQ8FVzMDXtLytrHtqIAPniv4wbDy7eLX0pjAmGQe8Bw4hAvFpM7MM?=
 =?us-ascii?Q?q+zZjdvtT9N9cAttomBLiuxaSLK128Au46IjcTO8uCxaYbcVrwcGkguCLaUC?=
 =?us-ascii?Q?vmO070c9Xm1a3+oLTFlJ2jSZwAR/ZCeX2y9hwgtaCWK7Cs4YKHp8OhBQBuj2?=
 =?us-ascii?Q?bsDerFf9qA2+z2mENO9umkRgbVBIKZ2+DknLtDhLlsl3sSJEUtGyF7WeAFDd?=
 =?us-ascii?Q?Gf2m0uAEsYhjL1eTGGdCqB2CaP0nuMZ6IyOt7VMQh2+lPLogMRLwBLEytBLz?=
 =?us-ascii?Q?jWk5sT6JZ0IbUXns1MsCLHoqs3Wc31yMrgxFQYyhBkcYKkv0IC1LkqdGx6dL?=
 =?us-ascii?Q?hIeYbHjZelomJx3QieAI55MzVuvzAVyaLlnRW0gaRbgmAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q6VPnpfzPTCRjkexBFBttb2UTjgpPsW/QNnDmyE3mcM4EoHDpnGHsyZaYJeM?=
 =?us-ascii?Q?1dZ9MVw87+YmlYKRJQompMFgFS3uk6l6UcNhA9GJ4T+3H0gI7pZoXioS/4Z7?=
 =?us-ascii?Q?Sp8Uo61JWRcV0jikIuxz62GpqoeBWYj4EpqEzMS74o8TbeBKcDCqIOHpcveF?=
 =?us-ascii?Q?X6YylZQiyOzEXfPDtCnEFTeCT1oxMAjhZere/H1c10wbOOsR5XpiZyJnMzHn?=
 =?us-ascii?Q?AM3xdyf2FoK6EfobPFnh8Ekp27XOtMFt5eCVRPjt4agMPE2siRHFjy4qC/bw?=
 =?us-ascii?Q?t0Vu+UIiHbnIhJV7MVlAACkxoLbQFfNlcgPG8MJwGBcDYKBzBI2ey+27MkJ8?=
 =?us-ascii?Q?4CrDOG9q3TzSusM3CVqU+k+XX8Cboqore/BkcsBiqMQByvTv4Be7lunc/rIx?=
 =?us-ascii?Q?UVfX+OHQ2JoO9cxBuAM3k9PhV7ia6Ip2eyr7vDDETMI+98iiAw7NGbrC5orA?=
 =?us-ascii?Q?CR8S1nQ+z2HGGDRHXtEMJBYLhwpztafG3O5Lwh2wsQLVj4VAKabDy2zOcFoc?=
 =?us-ascii?Q?EmvLg0xobEgf24rVApaL7tm+xLH5QdL/CtwYdRtCn+xso3+/yK1jIJru1/7g?=
 =?us-ascii?Q?Lmz10fW/w/PzVwC2arnZWGxoSuZhv7pDClPn6bFAfABDflEP/jpfeECzCBwO?=
 =?us-ascii?Q?t8FkG0KMEravgezBHmoWKg0OeHDYTrKNSNIMEJHQVxioWJpuyfZGXrcQw9Zf?=
 =?us-ascii?Q?VXSfqKn44nnhPFBZLMV6H5Jhkc2BdU/Z8WySOpsfBoOx6Wi+xDQ31D+l314Q?=
 =?us-ascii?Q?uaM26WoKrDS5W8LHC1ZLGdDptOSuR8lRaV/VC8hAepX1iVt0umY0XWrC+6jM?=
 =?us-ascii?Q?A7qDJjeNfpXEAiwbAt8tbcaLY3HlPPY7TeaDwCOoZNNL+CRPP5vuygaRnznd?=
 =?us-ascii?Q?ewFRtdHXQz2Dic446OesUvTMg4F7Gacii/bAURrkiPvn39U3pl7WAT5OMp/D?=
 =?us-ascii?Q?0d0RAISvEAFaokpjo6ziOE8ek0LzNw2ByWjeG1WoXD8fUKmz32Lag993O25I?=
 =?us-ascii?Q?kJbzyvnRJyBdgv4FMaE9Iddsds0L8DSmUW/8rfq8Q1D3vObow7pdOVhWU9/Y?=
 =?us-ascii?Q?fVlzQzCOX9f7mXvYLha3BnzZRnOvtClThBJEZoPArGRfUEgR6SA4uKXrqDd0?=
 =?us-ascii?Q?OXqrP+49FOL4YcPHQnBKjMVKSy5qHZcKDbAxgApr5OcKPaHMVURaktNRbCGr?=
 =?us-ascii?Q?Oi3kw9xxoKQ/Jv11KYReeoWHc2XXijSX3wtO7IpJChe2LWJc7zyC5+EzkUxH?=
 =?us-ascii?Q?xvs+UwygvuVvd7GiMcs8wVmXt8WIr7YYlKzE8FAf0niKdsKzpD4bQ++ssYyG?=
 =?us-ascii?Q?Dpq6Y8/5rXeWPOWHPv7bgkiknD5nXeDCA4aYL1Plgosu80o/TIGKytJmyI0X?=
 =?us-ascii?Q?4D+6IimZ+FYUjLzNSXsE2n1m6cJmegBVmmYTY4Fq+sBqOTJmfBXajm4l4eUG?=
 =?us-ascii?Q?SG3jH6gkDOePxFZq77QBZcYcwRAgBmTJ2IEgs5f/l64MQ4HL2QCTRxlJnLrS?=
 =?us-ascii?Q?xhVE0jUVzB5u8mNyGEtxyAVIaSu5dr9fHcFTSALotB2ZKibJP6I54aCOGeM8?=
 =?us-ascii?Q?7tUJP3lQ1wvGhUKQaf/a5p+Jd8h6FlXulXEkgFte+xp0xmkbW6gZP+L3MCFK?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jwQAHL79Ksc6yFsZnFrIu6e/nV13kSfxM7YnIyr8GHIg9I/T63ibGOOpWcux9nSvzGD0vpY5Z/ACEUW9zjHKS2RiH/sKh+nZmAkeXN75ieqjkrzm30LarP04GdRVd3kIp3cZKXxRL5eIA2Fewa3XiUG/hobEMD/2iRkaTRoaV3rUq5FwNQsKxSjpWlds9sBFyZe7TwGHhELI7PIrmh/CcBCJyrr+pWg5PveD132VTVP69gR9s+mHzyNUqdoovB85jfNNHMVtCTJIfgp2RuA0B1vKzCTkN1a+Uq8E9GUm603B+TuHfkfl3LWA6VnfxkkJmuPIyHoNG8PtFc+7/YXP6LoH/D24pEXfOl4L0PrEjbb290Gy07FiImVtss1CxEdZ1KUvrmQ6ZRpZVmDy3Aebyhepdx49qjPBPKTQhCbnQjRqVqKzUcMIgRZakqSbbcKVGsAqOXj1hbmd8LdeToCKp759KiOa1YzpPEqzn+ASDMGcpPuw1sxEQHk++J5ffDFCZdE8yi9oQzBunQ/TQJR/ujr9fNRGd2abqLpzAXDHNxOgp0ExMjKxanZ+tPomiWaaMkCHvhUXPwVkiXiniZeUT1kVdK8UYIj8eYZ5r0X0HzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee22ff30-8ec9-42fc-6af5-08dcc7c87fe3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 01:18:33.3684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0Z/61lhJKTp0RSbQ6vEVLRQv01ibgjPcUa5Oy7+wBVNozgM6iZjN7BkA/2b59dCxuJFX89QgY305NqFojBk61ywkS2Hk58wv2ijbltAfkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_10,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=943
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290008
X-Proofpoint-GUID: H_-hMX7bPsqg1o4C3lZrlZFozPdPRgvW
X-Proofpoint-ORIG-GUID: H_-hMX7bPsqg1o4C3lZrlZFozPdPRgvW


Bao,

> The ufshcd_urgent_bkops() is a wrapper function. It only calls the
> ufshcd_bkops_ctrl(). Remove it to simplify the ufs core driver.
> Replace any references to ufshcd_urgent_bkops() with
> ufshcd_bkops_ctrl().

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
