Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D668479;
	Fri, 13 Sep 2024 01:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192441; cv=fail; b=JYIYL/IUggy+nS0BdEY4AMvuZDN0R7iuH/qOxYBJKrsG17Q2Wwlc1DjCiSB4BGv1GaXZCM0gJEl5Rbx7sju1QgdjgaVWWhqxoemJC4kFCRzvLBbO2HeZTiFje/MHENbLFljHfKG2j2vgjbb++CeNEpferg1WcEc68WRqp6+NE4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192441; c=relaxed/simple;
	bh=bs4ZivlEwl5XqxB1RWdclRnH5TGXRnlRswhPmLfn0bg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=O1BXMVNTc7x4Tzm4PzjiNtT7RVmqel7KCMotLbr8Y9PYu2hxoygPaurroTq/LI1wNcNh5bnsIKRCy/mcnZhCOMyBxVulu3mOCGwpEvfJAPI+t0wUchMazEZOAFqDLRSZYETjOIKWvMjshK7s5VKTEMWyhCMNXEq+PXyfivY4Nag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j2kFPo3N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sfdBcGtQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j2kFPo3N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sfdBcGtQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBZJ1023309;
	Fri, 13 Sep 2024 01:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=j6XypMlI1Pd4zJ
	YQ+ez9D2Cd+BLTkoMO6/JIXlzf1O0=; b=j2kFPo3NnH6ZEyp+tr1Nnm1lDJ5/zk
	13UINg9oVfoqJIDQn8w5wxlXDhx9n7QaDECa+ItbnjOgaWteKdveuuYmnhnfP7OA
	ymg1gK6icmYQ2SUwyGXDqXRCHthWLdiQKxloxOE2YvBbATvph5sebr1Wu97vF7h1
	Jtu0w78Jb15A05gV6i8377HF+X++RhHtqnkVfnTFBhxAuxPgw9L+DcqnYG1qb8rz
	AWKsR2sGakhmJnP4qpq/rxybBTgOxqNn0HMdASgsZsOkxmyEHCtgQxxFkIAa/n6L
	Pmxj8MW0z5FF2lLVn/r/6dzXIoIGqb03fRfC3SYWAPQjcSFxAd/Fke6g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d452g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:53:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D10ULE033533;
	Fri, 13 Sep 2024 01:53:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c267x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I3Kw92jyjJ7rLsri+ZSl+ncNj9rXQW+SrrQ4MifgpoqgU/2M2Hir3qK7GS1oPcPQR0dvF2xELdjbvhnBM5V0Ww1fasPqRW6qxT8G4182EZUienRBNzNQsGdQUcFQ1oCUeT0vRjoZHXt7a0lnZn+s5YOuLQMDUNnW4qKuoP7erG0pw1uVRfQtdovOphvHfl4uikSFx6mpLWvvWvx+RIhzHOZWywaIpQLaiwAwSoX5WfyEVRo2MD62rvIfTGmvQ0lNyEw3khJq2YE4FWhl1403zH0W4A05NsT9f15xIsE+dapGMB22B9SH7HL4+R8retuF0Rh/HxSniix/PpmMNnMvQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6XypMlI1Pd4zJYQ+ez9D2Cd+BLTkoMO6/JIXlzf1O0=;
 b=D2DXqtn0Lv9UyBkKeb+b+iwH8wGZQhY4iHYqbmqwZ6cWyU8/J9RoJkp9e6pkLsj4gPtIVcO82Ygsv42tJeTMhAua2B7i0dve0TVLNK551zSUISVDEcmx+Ff3VlkCTR9rQ+0pwlfiEJU+pLP8F6BYCYhdUv4TLsIo8j0wJD6a62EsXz8/xP5gFrQId9zW4KObpXdJnHRff2HwKoHORkbe2SkINmL4sMhMbG/lK13gHSztbCd/NM9/kkveU6NK53CbS/SI1u1d0fm+vz8eKa6UkxXSp7nOqj0GThuZ7oJPK1oushSkd6D25EX1KJFURD1hwSmjObukuLCd9fPgbkd5xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6XypMlI1Pd4zJYQ+ez9D2Cd+BLTkoMO6/JIXlzf1O0=;
 b=sfdBcGtQn+vQSU+nk3pgqnTwbPIBXMJSVGO8CpTIjuEYIfUp+LoAbeADUXuAPopqTtQtxtHvwGTclCVqjpHiWMfY8r0op7jrBCAKeHz9tl/IxA2spj4iYthZ++OO8kqMeMILAtxckwEN6Nr2fhoYRcaCTO3vmBaGZHrVqkxTo94=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7361.namprd10.prod.outlook.com (2603:10b6:8:f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.14; Fri, 13 Sep
 2024 01:53:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:53:42 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>,
        Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCHv4 07/10] scsi: use request helper to get integrity segments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240911201240.3982856-8-kbusch@meta.com> (Keith Busch's message
	of "Wed, 11 Sep 2024 13:12:37 -0700")
Organization: Oracle Corporation
Message-ID: <yq1wmjgtj58.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-8-kbusch@meta.com>
Date: Thu, 12 Sep 2024 21:53:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:208:239::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 869e98cc-31c5-4142-ee5a-08dcd396e526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kY9TJx5QJdBx3Ek93begQ+vwzN8FWqk3y3xyplTh36c7EmcaRAnK26mN5pZz?=
 =?us-ascii?Q?K9hcWSccEeeCqfGFeinwz6fKcOO2eY4EKjlymq8MVZNI1n8MA5Eqq1qjIJc+?=
 =?us-ascii?Q?rouE4NBTBW3dS5vWwfw4MEzptfwwJmQxK3fL4kk580S4Ea2KSleyOfXttRbk?=
 =?us-ascii?Q?QWqNJ25CLxKqeZAUqR8lyyqMy5h9e30TsWiFetuWSu7MMrFT/4Q+zzswXaei?=
 =?us-ascii?Q?Nc2ZMifxbZAgIcOaBSZde5ovxFYUhibYl/Dx/iSLsgYEjFZ/BwsTSZEBlGjl?=
 =?us-ascii?Q?yAVMcSo+JdARD/UtEH5B3KZgH7b9BjOxzf3JLb+eyPs+7y2Ry58yde1E4bP+?=
 =?us-ascii?Q?yOAW8m7fiyDFsO1GOTmIf6hfdJoSDsWBG5ilw+urwi7yHMhL3/EG5Vk3alkx?=
 =?us-ascii?Q?yzdj++989Rewbp2jaaC+04CYLo+iGD3gMEAQkHPnq8mhU+4e3Z9WckX2Uwus?=
 =?us-ascii?Q?s4fFuZso/+VHRaWQur+KVi5q1F2ow2ofTUUmTXQFrdSnzIDlNRrCDHgSen+m?=
 =?us-ascii?Q?FUA1FE5bsyRremwAZqylfHEY4LA2PX++icssyGcHzvZ4J4DXul3mrq3ZfFe5?=
 =?us-ascii?Q?iaQZkVit0pBGDMrx5lINXMiudhM59rfURHZpVOz3NEKWUvOnALsgtbc217my?=
 =?us-ascii?Q?RR1XtT8BtPY5RRWmrgAX30fJFphmasWBgYNYjCubPufZCNbo3V4H+eaqCFtj?=
 =?us-ascii?Q?G3m3RRlXCTI226zKDpqOMsX3UKCHzO5ygWFHxKa4VmU9iTL8yjtTc3fT0r38?=
 =?us-ascii?Q?tVpy/B9yArZwNv8aKoxLQaZdtK2YnbUeEFZff7lxfmOgD3enbThF0v3y3iPy?=
 =?us-ascii?Q?t0rgaECICVlAtDpOen1sd/b1M/jbvsCdQRr5vaD+G6+a8VxQ5nsCRdsy7Fjk?=
 =?us-ascii?Q?fT8+M7SaO1en7iFPS523aSvdEleg7r4PuseQT1THhVL2clM5Ed0TTd7mGxxo?=
 =?us-ascii?Q?g/H0c6AXNcWsX/X/7WYHobQbx8mAEE/PRUprRPAeOAdAo24JtLIxaesCbNCy?=
 =?us-ascii?Q?K99D5XHLyu0h1n6CtYoRoL/eik6FMZsC3SFQYdPvYBGEWZufpVC3rfaROPKu?=
 =?us-ascii?Q?Mf6lMTrT0gK1/i1560CeEiK5Nk+6c7bnMHqd5qk3dSZNchxuh7ziQpntGI+B?=
 =?us-ascii?Q?iHrF8DOHD0eNGdYNHDnoYU1Li41SMvevyJEQo2OfWkAjTliLA/LAvgJGj8SQ?=
 =?us-ascii?Q?f4b0G+fo25Ix8u+5DJk81vySfFLH5wh2rOMXnTmevSvIHU/Ar3RSvaEpK1K+?=
 =?us-ascii?Q?uvXnkHNCtu25aAwnKN97uHD/fQpCHo5c1BH2XmT49wCuC1cIUkNRnHsd8QZF?=
 =?us-ascii?Q?A7HlzxDsABc997x5P+4psIG96UW3phytndC57W219tsv1g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3mNGIIM08cm/Vdhmzp4kVGFTcNPxsJjpzKnlCqMoI3HYeuVCvkE3TGpp+jK+?=
 =?us-ascii?Q?Iyjgu5JGEIvpMwVy8UN5A75XJjbfpVQEL2Mfz5xap875uUOTZc7gEnwwJ+vA?=
 =?us-ascii?Q?6d404g5yVcIxmdohLLetHN0N63Ww5T5LAhtT2LiSCOqQJj0uQ6TmBQfIKUA7?=
 =?us-ascii?Q?Dnna/ORllnNhzB+M0AUKut3mS9ZITHjzG0Ww6PlviDD/JG6RfSkmvZJjOmk1?=
 =?us-ascii?Q?dJRyfQAWIj/5CQhMgAgbli9JnuSj/kUtWOQbciLi0vTv87IhVW0zi6KKhS8v?=
 =?us-ascii?Q?VTs8ljqAJx6c2XQF95sdU4oQ5NN24xxj5ZE2m5GKz/fEsxV6OiaxxMHUHakT?=
 =?us-ascii?Q?1Mt7gfqz0k2nB42Pbph5GuWsalXxg+/Sip8cnxENfaYyiapmILoLot1KTYVN?=
 =?us-ascii?Q?9N1h/l1LzYpJjQE4ukw5SrdSMwHraQSgV7KJoLV3RN5+LFCdR8rDRyatRBnS?=
 =?us-ascii?Q?jMAn1CXf1eQY5J2ter8XNVd93CXwgKfIzLcaQnRV0gSCjTLAusGIVt2vRKuW?=
 =?us-ascii?Q?mY8qmCIoogxIUaWa+ozpBqTD7z4yYXi46fPw4ZzniQHuMNG5VLYRfn1pzp8w?=
 =?us-ascii?Q?tO1Xp5I2nwE6OFl2J9ri7bLlCW6Oni9HHdBGDmeRTwGXnV7VCVLQffMjnTaE?=
 =?us-ascii?Q?8fVZZLdKUH5plmDvUunuCkylr896twtBLNblzXDiqWUeJFcyggrdQUp+GyPB?=
 =?us-ascii?Q?ZK6m2+IxUJeH7pOCxFGX2NwMYucmOyzExdWjQ9yimhPG+pZ9kDhKDIkygmy/?=
 =?us-ascii?Q?oJsPl3s5c+25O3AQ0/MgVVRcWR4VDNZEwjN2IGWbbtZr9N87ybmEOW7S+/pO?=
 =?us-ascii?Q?HVlpA4/H27It5jf1l2snmZmK+ee3Mg/rJeVqoHdi7XIKjqY47Q7y9/zwNvEc?=
 =?us-ascii?Q?9MlS2ekhKg51rbVXFVccVpA9jQS7QlL3EaoDf7u4NN5Nb11UMAv+fXhDekgT?=
 =?us-ascii?Q?GqhuOu3c0u1W6W3T/YX2ghn7WvwxKoEFgl5c9hKyGsyXskTWdKa//lcewpY7?=
 =?us-ascii?Q?rQqQREiMScw+DMlnJfIGJ66GsZMUANUa3nrUEealBnqWpZUlLJVKHPfIIt+O?=
 =?us-ascii?Q?3+2GhQhE+zdTmYNS6azb4NWgTfc012YDLkAHxJyN7AnO87Z35nwBeKH7rscL?=
 =?us-ascii?Q?Rvfq4wd8UPymzdCisBlCvGpgUluryf8I+L7eAMr37tTX3F71CsJozw9cE3ud?=
 =?us-ascii?Q?cbWuty7YMI1p5XQtE2dfaUDS5jFig8+adWTnhzbmLeVX5rfdFcTBlaR/pgoW?=
 =?us-ascii?Q?AOb33BwByLSO52Ikl2TgzNLff8ouoows8039Z26DRK+tDvIbpVEP5LKih0d7?=
 =?us-ascii?Q?38T35sQLA+HRuwynHhKkNCwiG+inhBuIaP3gSlowOU4YPpLtSs/YH0CDuYt7?=
 =?us-ascii?Q?berEpIdnsLOAwOhQxjA2aTTFBEpZmB7GUlUp5dll8yd9qg+o+bshMyOBBcV8?=
 =?us-ascii?Q?kMgT6r/asQSWNdPWaiow/gr/VcqVqP3RD/JYuWP7vKXZ39VZ+KMnLdkirQMU?=
 =?us-ascii?Q?aEO5s069SZrPl/i5o7y477pLYvKcl8Pd9Cl2I/4FdcwyAdxGVjIOeBM9+eIm?=
 =?us-ascii?Q?qhuzKUa0ykyDu6T6FmLT1DmVH+5k6KJ1TPKytwOACc+/N6OO+aTVSLnGWvxa?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0hgNNpmbjn2fza2frFh2PdRuc4Ne4oTV79O1+s8f03nVT2o8n/SzXQOodETz3xkUzTZGad/qfaNEdVRTzt+T/S4dyx4A2y1hAIPZ+g0noHMo+7/aer9MvHiFwQDgN1HE3phsruH2Q6kdvJqFU8xIjQ38OsXicGqcpbV+15CeW/EbPTDG22psTnYoTQbnX8IEE79McD5E2iZBvQRR8uKZ15awkTLjpXxexCqB1EpiSlrS0Afcga+WDg82vkodZTse9p33wqThL/130ieyA4iANasCHmiHQP+Qg2BeVwXKXeVfKbCkbS94iz18bZXQ7K4lfNifMR02t9SkRFKp6dbnb7WkvbcgSM/CItOqf0iCaAut/n4eOSmw9aZyxq4M8DKIdl52kU9heqwu1p9T0xp/PUl25HfyidR0u41wSF+6uuA/0EqyFd91iF3AeUzxFaHXa5auAr2ZaJcHTAi+epHkAuk4UspZacXZFYCRQXpTBtSDhtmYLBvcvXwZt06DjY15FZlwNn2/cXpQ+gqHOwiLJ9Bdd+1r+zm94AHyz/eYkbnBrMJiJyj7JIM3Obb2ot1sT9PNCbfi0dBNhkf5k4097lz62qe/SYdRZ9B1SKxq9s0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869e98cc-31c5-4142-ee5a-08dcd396e526
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:53:42.4026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCbc4mtKfEkQC/OSu2haytPbbuYGTkKo6DsXDZa8L7VB03cqwsnRnq9T3HDZMyo8nyQQc7aFoXXSQT1WLnQK3JTw6SBNQzgJwIcBMFPYN0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130013
X-Proofpoint-ORIG-GUID: shqOD0fZz6d5AZRvhrgwfteWMToStIOl
X-Proofpoint-GUID: shqOD0fZz6d5AZRvhrgwfteWMToStIOl


Keith,

> The request tracks the integrity segments already, so no need to recount
> the segements again.

s/segements/segments/

I'm fine with accessing nr_integrity_segments directly or through the
wrapper.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
