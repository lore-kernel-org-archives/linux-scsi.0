Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E5B4CB5B;
	Wed, 18 Feb 2026 02:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771381865; cv=fail; b=KmpcIlhCuoBN6HkheNe7yUwV6qqEJVtFJTJvPiJBVa5+Ui47DVHObUGwBH3nfk1kj+zcwgsBh0AhL1qtLZJagxIYDnRpRBiLUDV13nIT2eiI3WHk9UJGpVrU+q2vTxkNKx5Hf64wn43v2Bi/RAyYu7UyQRrv/Sr33v8rro6Eai4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771381865; c=relaxed/simple;
	bh=YC2sBL9C8kltaBnX+rT1iEfmgjnL4xANhhkP0DUiPN8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FFtAEBmvxgjwHsSDXsf/6geR4y+wIcbB2NWIMKtf7DPWd55JuokAwbDUSsgbVZzhygnNpx3L+zoy6H3Qwkc6siippPZHqWkUlIuMjqkKBl2PddZD/NBOS59Qbo35GFgMkzkr9tDZhGDYOvaJM3cxzNB6NFeMfiaFwI/o9EC5OLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sXOmvaDy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SZcBABqN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sXOmvaDy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SZcBABqN"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNSJo3675776;
	Wed, 18 Feb 2026 02:30:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8rFEKKJC94ZEKmNVtd
	BdKH8vX0myDjH0YLguekd/MRo=; b=sXOmvaDy1cXkS/nEvwfdUjKQgQvRDwiBWt
	Pm4LQrzc71FyWJLUcq26UQ3lfKvqbIMWJ7d00PJuHpXaOhPnhC36I3eNetCAbPoQ
	C/Amdpdd8xjGydG0a7Kd+TvRKkYgD0g7gbLHSE/PYrYTZ4J/+gO867y0LqlVwCsD
	XhmDHP6aTyWGWf2ae26IzATk2lmnaruXtB7C+9q0qQGJRfszDf+z37Pw+Ni9vg3N
	fuFQksmi9Ifl3N8mgdqhjnaN+/vZzzGTMRuu3PxLdyxWqqB7glX8wzgxNzpEVrEf
	bOXsUS1a44KffRwUOV75M9QR5ETa9AaFvIYzjJzxtWts+T46cDUQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0avspc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:30:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I2AEHc037247;
	Wed, 18 Feb 2026 02:30:50 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012035.outbound.protection.outlook.com [52.101.48.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb281csf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:30:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ub2eMw1POkU/BjfNiUlcHNTomxsUKNIkSobwLllwMgJlbbxVylLK5l5GLb24FSwNmBhnFwecBkD+bdggj6/O3MNojU7Io+7tHFnG/dDkwsbwAWVYkzzZCKlRERmFER+N/t24hQzQmsRQQ7IFBLXU1IHjNTZ7yMAWLhGa/Ni+zETFV1GkysgZ7xn8dWdTZ3eMgao7U2rYUYV/frcrjg3wqIji7mvp3V56UPMDIBmb0X5u6j4PiOPqr+zWX76Bytd0pQqnRlWr0JFuPCkT1dmB2VXa5IjAN4NtZDdk94G6vtUdw2nYkVsckl/L/7Pnf3Sw/JEgITpRjxC9BrVdITsdFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rFEKKJC94ZEKmNVtdBdKH8vX0myDjH0YLguekd/MRo=;
 b=X0kC2pw56yOj5CmiwD6cnX0iGH3LjmhFTjc3cIInXYfRV8LecaCpc0kMRr1Rq+e+3C81iRUPC2dUw0jyLV8LAvFV96i7KJR6ytI3CY1V2UTBX8+vKZLGv3NJ8xX+OaBSD5ihSM/UcfSCkrDOzsAqZGyUhDB7eSSUUcAbpYEmdjlLqhGd4oD3UdAvVo82xhTdC/9HVF065oGFsnNDtp7cErL3kyNmj4Gi6A3cbZ/XxzzaaXmp6lVVIFx2eOfII5OdhnFZ8zK9mZqB5ioqsE6nGCjno3aWvkIMN0XMXIanFZ4fqZCpnv6jQfvJMEVfq/Bk2Vt62HgMd0dQCV4zpE9CUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rFEKKJC94ZEKmNVtdBdKH8vX0myDjH0YLguekd/MRo=;
 b=SZcBABqNbzbezeJfjXj1vBTEP94LsXMnyfryvvRiCJQsHdlbtcmZkPvleFJ3iJ1J6u6okq0NeddyzvZj8jfR8D/GdgARHRhjew+4/WcFWVMpiZAjWru8DZoMX75rplDHb7r/1nLj8SVuBEymlTlZ0V8j7y+LCimnxAQuPk5wnUE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6286.namprd10.prod.outlook.com (2603:10b6:806:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Wed, 18 Feb
 2026 02:30:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:30:45 +0000
To: Won Jung <wone.jung@samsung.com>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com"
 <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>,
        "peter.wang@mediatek.com"
 <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jinyoung
 Choi <j-young.choi@samsung.com>,
        Jeuk Kim <jeuk20.kim@samsung.com>
Subject: Re: [PATCH] scsi: ufs: core: Reset urgent_bkops_lvl to allow
 runtime PM power mode
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1891546521.01770806581968.JavaMail.epsvc@epcpadp2new> (Won
	Jung's message of "Wed, 11 Feb 2026 15:01:05 +0900")
Organization: Oracle Corporation
Message-ID: <yq1ldgqeqba.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260211060105epcms2p6631646c964afae761c5d8b93db5a476d@epcms2p6>
	<1891546521.01770806581968.JavaMail.epsvc@epcpadp2new>
Date: Tue, 17 Feb 2026 21:30:43 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0041.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: b7eba601-3c5e-463e-f764-08de6e95b7e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gEfnk7mfgdNqYqeFMwBUtJML9pTHHjNRoH35IHfjyz8iatHl/MDIxWpJ+9CC?=
 =?us-ascii?Q?M0q1u1TdiImcD1YcjsVbf6oELFtHDalBzYlnZk48Zqk6LZ7TofI6xgJjMJtO?=
 =?us-ascii?Q?7oQByJ84dudkKwGSCSyJntxU0Y96FB56dt5+D4Yk6agAQkrCY9xJd1ZUO3Ix?=
 =?us-ascii?Q?kxmxF757Toauq9rZJXG0Wfg7wBDHqWE7dSL/A8AcE6jYRIlxjQ8FaFoLEhVN?=
 =?us-ascii?Q?aBenhKC5mvM33nbymny7w2iDTMLOMxrrrASRP7qZC8TOcY+Wcw0KM5UDEQj7?=
 =?us-ascii?Q?fEx0o9mZfU0PCMC1ka6pQAE+CvMNEIYEbT6dwbZ9UfAiqTZMx9nwD7Bu84vp?=
 =?us-ascii?Q?7E2mztZOWg12z7c6OUqDcM7aQJvZ0zMs8w5A8d1YY6P0oF2PpdzPIjnElCug?=
 =?us-ascii?Q?R9VyQv5h26qmx57dWt3bvjr++7WoUJpxCSNk3fAuDbQBCO3qqTGz5wE8dJeU?=
 =?us-ascii?Q?2EZopSwYIF5MyS3RN0NUHtKWy0c77x++ZDpdvydZWvty01fSRfDnFDnLilTu?=
 =?us-ascii?Q?EgfLdcHcJpULLGObKKWwWckxzRSXJTz9fbci3BLWEubOtvcVVcLPAAT/bTCG?=
 =?us-ascii?Q?KUaX3DzFip6tYZuQ0h5JbxvJsJhjzaxXKHHZrEq2BBNoE9tuqSQDUy+s/imH?=
 =?us-ascii?Q?52UplBTMm6CBycicU3YGEa5U0sj4Xg1nerlnHllBi3WKdTeMGYZ+ZSWJ1ng8?=
 =?us-ascii?Q?pKeh1mM+meg+WLTSCFsoaPRrDqtDg6f6PFFg4xvA8Yn6C0aliToxQ2DcR/wu?=
 =?us-ascii?Q?6ttOaZp49saY+kKLYb4xytbYayyrcRjgEgW+vFxtG8hhuEbtTqk3LVWU7oC3?=
 =?us-ascii?Q?yW46iPME2Yfo0GZ45P4jDUwlVsuMeUosQPT7Q2rfdzPsqUvSKLyfivM5SY7l?=
 =?us-ascii?Q?YTJK/E1180bekceqoV7D9yVE2LYwRmb6822qCPZeood7J7RI1bxFgssrIdsv?=
 =?us-ascii?Q?jsRLSdlLY+nTyT9eYHVT3GPyMfvAR8kBfVfbTJqFEAFLsa2wrmKj/+xXyZLU?=
 =?us-ascii?Q?Q9A9gRNKQRosw0bjwkBA8oNrRWYkQAd0BVZLEiLjsYyPHcah4fRN++Lbpyui?=
 =?us-ascii?Q?wzDXKeyvZrPljlGizAVylGwQf1FGeYpas8ecIqt96X9Sbcque5Gx+5y3VXbM?=
 =?us-ascii?Q?8y8Wg8CXGMGIlcNBw0om5aTnIgybjhoG12v4wJc5bp6hTN50qCo4YEYsxD1O?=
 =?us-ascii?Q?8SFhVXKmrjeyIb3wmUfk0TOofE3i0KZR3lSW5Jl8R4aI5zXnptrVmn890HVo?=
 =?us-ascii?Q?nJZn6zDDH0doZLf+6aNSUKCJPsPajdLYzMhU+PBDQ9K5i1qYCF5YisIJaGIi?=
 =?us-ascii?Q?lY+TqNqIgoQw2h44XOlWFJNdNyjINCCWUKuC8aMIF86hwpJHsdEMUHdINnkQ?=
 =?us-ascii?Q?4LgRCdFHOShQK96oW41LK3aEeYJb0X/5GukwrCox6Ikq2vHJb3pIWMeExmoJ?=
 =?us-ascii?Q?R3c5HohA08kGinexr9FYag0fwm3nIMrT1VDA9PYJpEMaPerA3oSbssmfFD/b?=
 =?us-ascii?Q?J+qQUkxRVIOlL8yWbCHSVjUM1T/Ufx2yAw/wNhsyjmWnQXqCp91scA+W/omT?=
 =?us-ascii?Q?ZZaRO1Q0Vx6oujZeQd4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qTTq304Worz/jkmK+nyDVOvrI73PMxJGLZEPQhvFa4SXLn9hoH27fkeltB/a?=
 =?us-ascii?Q?g0Tqs5ZXAcUXHlJcWv0KYqJW8uOhLWua6HavO5jtUf7dRUz0vB3u5mwcTypH?=
 =?us-ascii?Q?SHfj8SipWDnbjLVme4fIjFp7GsjAvlWva+9+NbMIiI3zJwhwAaZtzyUa5WYK?=
 =?us-ascii?Q?GSgYhDKYGmyp8U9Flk4/STakQ4C+VJtLWqvhkOHgqlTf3Yx2WTALIlMbWAcF?=
 =?us-ascii?Q?PJMG2jp924mjYq1M+DflXgm8qaF+7Ewrm34DpfMhs0zpUVieJoKPzKx4u90o?=
 =?us-ascii?Q?XOSrUoXeHO4kVwFtGLqubqycagNO0konguUcbKJLQetkJcifqasG9WEwp5Rp?=
 =?us-ascii?Q?0WJB4fFJutWa0y9bx17LBYIyaWSbyorbV4OTIHE4Y134StxDtRmLPx9o9MlZ?=
 =?us-ascii?Q?Vdm+40n33MO1gIi9/MAy/IyMo18pl9Y2KuKNwKVN37nPKz9ZGindanZxOEyT?=
 =?us-ascii?Q?gauUx86Oa7TneQ7r6RofcWI/mRU+8zbp826LJyCshubukqi6Fxq+T85bSgfz?=
 =?us-ascii?Q?vnrjQGXK8e9MxK5W8504CyHWSphYEoH/SHX85RU8ii58BYl1QzoVULBP47N6?=
 =?us-ascii?Q?zLGCEeWy4DVskRU6rvDR0vZYHjltTy2y1KOiL4fiXGEDELoyshLj4wR4YSoV?=
 =?us-ascii?Q?+6MWcK99KIOUWjF6lLVFfdZnDTuzpVNy61vAF1s3g0STFpas9Ghz8/LJh2La?=
 =?us-ascii?Q?siqC6ZGZ/CF3K1vYvtWs/ymMAFeqxYY0t+jmHEnUj4U+lzNamFPahEqIjS0h?=
 =?us-ascii?Q?PzfmBQILei2AJVT0P9ol4LLquNn5iaFAkLHAZchL8pRSJNff3o5MsAOivZTu?=
 =?us-ascii?Q?VtFQ3tyESbXv2ratDac9z/3ttgw9qxOm9/w/tKIQ7eItzvKnKNF8iSnGCYpl?=
 =?us-ascii?Q?j+FpfKb+He3z7Rro+oh9DYT/AY1ZfBPByQS0YIpzWqZ2wIuFSXIYMfX000yU?=
 =?us-ascii?Q?xiRm4NLmpQz/ai+D5ClcempL9K0u3Ixo5k9b/mxn+ECGk5XIpvmGojQYptWB?=
 =?us-ascii?Q?IcpdKOiD3X8erFpoMj43+8pjPoyK6zCRcylaPQsAHBo+kUUXQ3Ipn6WZGsb0?=
 =?us-ascii?Q?8+IX7Zy1hSiyT/XduxpBVTtWuLoLtgTiNE7hFNCUm2bjS9czZimkTc9EiliN?=
 =?us-ascii?Q?8bY7xJCNjecWOQUMJ1Ke3/2By7Tz4q/Jhw3sfGvpKoomgV0uAJslxWn7Ph9s?=
 =?us-ascii?Q?472VlNxwbFRZJfKTpGVF2vwEl1GX0OB7hSO/lE1yPBJH+AUU7vlS5hE2EwNF?=
 =?us-ascii?Q?6Be81U6LD3pusXbQT9PMs/psXyy9BCk84BqZdlxan5ys3u9c0cXShSCo5DoX?=
 =?us-ascii?Q?BDk3ulVQeThoRKpxqYRBJl7PGmyIwPYDO6D8aDmEy65JX+D0WegM6zYERka+?=
 =?us-ascii?Q?+ORLDurwgewz1po6EyzTj2cNwfbDbBReDaJrzjBnkPv4fFS+SO25GLnwIiGx?=
 =?us-ascii?Q?GfqrCD6ORDg7e+8hxIgJA4LmZCFaSTdWG99uG4nCCjbx8LgSlVQHhKnzU+3/?=
 =?us-ascii?Q?iwu2mxL2+6rvdxBjMP9+aTcxNCYxOef8Ke0r9wc32bszwYU9+pecWsFocbSX?=
 =?us-ascii?Q?SQDgGgpx2Tswx6WdMUNYqKziaC38ePEVzSbfiBe/7j+RJ+VnMMMA5QM9Yz/R?=
 =?us-ascii?Q?oAx5ASeNpdu+cwsSqvmP/nsqdyGUufHC4Lbh/V7FxfkiTqXmodLEOj0sFrvg?=
 =?us-ascii?Q?KrOYeoThbeWlOuj/LHiuAat3lOZlDQojB44DAuoLZZwDkM9JkOruLu5GYhkx?=
 =?us-ascii?Q?XLsLeJM/UkXDsXiR8Ebp0XTot0V0+3w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kkwaEmt/ZFBtYkjXSVtggWTkd3p9OQhSTPOn1AM5yZ1E0tn+8uO8IJNuqU7QbKhLqBGpndGmh6pDb1iJ0l5C7XEXtXIAZTce2Px3+SdaF2mK5vdlCNpHn6SXfQKXI2Lect/5ebUTMp4c8MCBJSWNWSj+evNuEb8fWXtDFP0OjMsWn+Bjr7xSBCeFkb+sElBVPDZ9f2eEhXzTHBkA1wMAEl2y1Sd3DmFRY3jjfQ9pmaj3EubaWZQfW3kgLllx15MCRUilw/WsalYIAvqnCeDe0DDeYYFjF9jmnVbujt0uKfJ/XuAATT9Dy1YNmjbXCMQZGmHE7+bz+F2yc6TR5vx3Hb+UZKvsxYFA5QtlJsQ7AfAVBkfz7LjTnMlNEcqMBQRM5MJTGrcGG+cGL4Op6q4s6mislwoTMOAs5//uwG01Oh1gI7+R9V53petN20tPL+vSV4B38CLQgJKxyZ/Sp7PqDCUNMbU73pAol8BPzQsWh5LpTEbbrD35I/wmsMAwsCfO3srP0GxAQuF4nQfArQ3BN56L1TAUZwAa/tVgzU5XqQ22TBedGfU+rJU0UukMDXJY3OldTfYsEC076FvyCAJ3u0H8b2og1GkUaEonyIT133g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7eba601-3c5e-463e-f764-08de6e95b7e9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:30:44.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SiVbet33MJXlIib/14Vkjaa/6J0NUfhtKSlSOAASyXBFaIc6VDIxIdfLIWSPPMSIGmJ504Wjw0Fbzrz5zSo5rNPtRTaRcdr7TFQwVVVla+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180020
X-Proofpoint-GUID: ZH3uzMWn6bpKbnh1uOWCvGwVVKDv18qZ
X-Proofpoint-ORIG-GUID: ZH3uzMWn6bpKbnh1uOWCvGwVVKDv18qZ
X-Authority-Analysis: v=2.4 cv=UsVu9uwB c=1 sm=1 tr=0 ts=6995245c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=9YxFjD-CDUihG_kQDZMA:9 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12253
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAyMCBTYWx0ZWRfX0TqSLxKIIEJG
 stfyvh/sciAqPG5kG8ECPxE2Du8M2Si0+l0MV9aOHXQwdv7eGLdN9+gQFQFzYyrkw+kT3Oc20i8
 yH9ZQcE7LMkHNJMZaEV89Ka2u5h76svRMxkbktpatj+G9wc6Npu7kz3yeQj/5gBtkytktIWKlBb
 Myx6Qj2hg4lh64OmfjizoBy08IKDQSvAJmTzalQ20KkxqtxnFKMXN3/fsxYIwNrAKliJDrrjAKg
 j92fiH7Axhn4vEbep7xhRZwHJbmn1cNZuFNbjSHwt2k6ABx4SXmBUq30GgXE9cOqi5mJ9IhHfc0
 7Qweiqr0Td6WCXJ0ayb9Q1MvUQe2dSlhQsGQ2i4dCnr+uNW99OW/MrE5xwM6bLpUIaxXTneSK4z
 aCUD5Kq//hDhGVApCBOXxxx2HBnIVHU2Wbzo27oxn+1fQtVUnDcXv7jBPtr2wf6AYctxjhqt51T
 GAkDbY9O0YosFFhGxsm1O6zFaISyV5T0iIr/ItE0=


Won,

> This patch ensures that UFS Runtime PM can achieve power saving after
> System PM suspend by resetting hba->urgent_bkops_lvl. It also modifies
> ufshcd_bkops_exception_event_handler to avoid setting urgent_bkops_lvl
> when status is 0, which helps maintain optimal power management.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
