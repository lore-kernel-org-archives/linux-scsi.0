Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72515A8;
	Tue, 29 Jul 2025 04:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753764261; cv=fail; b=HdO6Hx0UdGvsHd7CjPJC2XPqkFOo064fLYUJ06sfd3qpvOMPTsLS86IlWihdsiiEbrdYzNsskr//iaY+jgJL8ZF9wKM7sFtGdK5ALW7STV77NOSL5wOQAvADtKnXE4xQ/4PPA4Ox6pl/rlpAhVX/EncpVs1FaDPLBAQABa0eCZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753764261; c=relaxed/simple;
	bh=+OcJD60fvuwlD9Vh2FEBt96fua2IlJpVNGqhSTgXgjc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TiG+uOiwCboatsUGLb534eVPXaVJQPkI40iSR9EdVGqFQZPTmxsFRebqv0cothUJWGQ0didIRjMNYG2cmd9nMhK64AdCTZ6U3sdJ3j8t69KZURMn5ms0WfdAUcbh/V15pozaFywsCsacqNMX5x0YLRpdowoh3jAF9PZqdOj3CgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=onXerfgR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ugUSM1oY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="onXerfgR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ugUSM1oY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfrkl012597;
	Tue, 29 Jul 2025 04:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/3lnK62yoL2yZ0ih40eYAsrvthxhiUmEgWL1Sd4vMOQ=; b=
	onXerfgRS5isPDfBMLSnv30H+zK44mqxCAViWi2rR9ms4nEsgkv1tq8hEWlcINiW
	KnQ+h92N5a3fpMbXZs0sxgfPTgOnJfE1O8YVLVHWpdqL+8ny7Qh8wupz65CwGMe+
	B7GnMevQcxQjm4/q77sZco5zFIkrWs3GpcSQ+TxivoL/zCii7VIuABiamzXeahT+
	kjjbh8it0DPjWjGvvpz2J2V6FzPDI8atwAAvK0FDVj5lHmrEa0FHA+MOev7BPTJ8
	F5jaL5+Lz07KqN8pArBjCT5i82+oIanUrPMDzG3DXPHN2gGALJcLRTucYb2c9QPI
	3FHAe5ChSpePuoRAqsckhg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2dy03g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 04:44:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T3I4LD034413;
	Tue, 29 Jul 2025 04:44:12 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf9nwke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 04:44:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i9d318n1y/fexUwEBWGJendn951nng77LHUG2F5tVRmAW9GFYEMkQALoW1bx7oTSwqI3Aj52yIaKBvclK6GBFOprrC5dF/UvrQyp0V8xTxmWL09d97FsIKIJ3gJm4VF684AZJnno2V6DdrOiFzIg+a+Yh+JgvQRNkyxXdxDrA1tTDQjxXKq8QKpKQNBZxRf/JSy6lqibJqHmARTP36jxrK8+eAYJsPeNmOmg8eyDYgWuyKXpFbWJR/Lh/WIoc00wiIFNPiZYuPiBQHhvF1ioJPKMPC4y4qYrwyRQLpzKB1MvknfZyIZHbogzqPG4IlKJzYX7tu5P3OwkrLUAUk0K2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3lnK62yoL2yZ0ih40eYAsrvthxhiUmEgWL1Sd4vMOQ=;
 b=opPxH1uvAmuhmTT6ySzWMLsmUVtaowNcB2ph/IFRjrcD2z/c69VekyslbcIwykSeKW+riejP+tQtLPIgz2KoNO7xsxodcELhUZVv6Q6278YsACEyyHiLaufQXQiMnxt2tQMOAZoaH17zh0k8Pek7qvmSQ74Rg/LwHtwDbjg1lLFDrMRZ9c1TXIXLgW+cVpNos0XGXWRt7m8oNKFbJKUwZR8/ocU1IapAa10kQsFrDyr55i+nngoS+C6c5tPfPHTaaf9oJlDjsNw/XN+A659htq/j7uP8RDMNGbGp/ZbU76XpA90DrlpakHEMIBmfvz+XmaOznMgGac1CCvQRSlA+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3lnK62yoL2yZ0ih40eYAsrvthxhiUmEgWL1Sd4vMOQ=;
 b=ugUSM1oYBjtdRmE8OzxmfJM4ZhDVE8xLGLLXwtmz2ZGt59V7Xd4VADUO8DNqXTpXeLHoxfk//jwtYpA5+zB5Q10u6n6d5Uk/YYnK9YsgaCPK8k1aYObiCt2k+pVp1lvgO1CoG5rA9xMlK5imvQ7f49vFIrcfF4PC+9fZg9EcaB4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6367.namprd10.prod.outlook.com (2603:10b6:806:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 04:44:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 04:44:09 +0000
To: =?utf-8?Q?Csord=C3=A1s?= Hunor <csordas.hunor@gmail.com>
Cc: Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: Improper io_opt setting for md raid5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 (=?utf-8?Q?=22Csord=C3=A1s?=
	Hunor"'s message of "Sun, 27 Jul 2025 12:50:48 +0200")
Organization: Oracle Corporation
Message-ID: <yq1seiflj0m.fsf@ca-mkp.ca.oracle.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
	<bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
Date: Tue, 29 Jul 2025 00:44:07 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PH1PEPF000132E6.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 53cb8fc6-752f-4ab6-86b7-08ddce5a8eca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RU02b1lmL2g0eVY2c1pnTFdXODUxUDUxM2hWWWE5WE9yVjJQMmZ3L0JnSlpD?=
 =?utf-8?B?WWRiSW5vMnJPaGlLdC81UDRXZ2k3NXNLcU9odWprTTJZOXh3YzVTYmJXVkJD?=
 =?utf-8?B?RUw0aTlvakozOVpGRWdlSHFobU1nLzhDYm41Z2Nod2NTZkRKU0ZUblE5c0RU?=
 =?utf-8?B?NW5DT1pYY1VWWlp1K2x6RnhRTFpsVUpvVXBVRERURWJhdWpPOCtMaW1qUXV4?=
 =?utf-8?B?SGFMNkhTa0FadGRGYUhPcVl1eERBSWFHTHpha1d5SUdjRzk5c3Q1cE5DcnNN?=
 =?utf-8?B?RVNBMCtwZzdPeDlrTVp4M1F2T1UrMDZkR3RnMjIwMmk5My9tNUYxWTRYVGcw?=
 =?utf-8?B?Lyt5Umc5a0lIU0JIck93cHl2OE5ndm1wYUZrdm51WHRDbWwxUlVFSCtzMDdL?=
 =?utf-8?B?MTNJNXBVUFdEbEs0d3dFN2d1NFlsdGwzZnRlYTB2d3ZNMmpvMTVqQ2ZCSGJO?=
 =?utf-8?B?SjUzZnZ3N3h4dEswSDRhb3FBNXdJNjFIMGdydnU3RWVYdmRpMVJnV0VTS05N?=
 =?utf-8?B?M2R0UWcybWlaQ2J2eXRSWG80WjdBZVRBbElHK1dTNjA1T05PVWtQaHdFaURz?=
 =?utf-8?B?RWh0TEY4M2pMaVF0UFFlM1BIejdjK0lwZ0dEUWZZUTRxUUZRMXZ6eG5GUlZw?=
 =?utf-8?B?bmx2aDhaQ09EV0wwWS9tRXRDK3QzWTRudURtQzhpbmZsUWxoaUlaVGp3YUNr?=
 =?utf-8?B?SVdRVzlmalR1NDRBOFh0eFUyc1ZPU3k3RkZNK05rb0xzeENVZTZ1UWdsVFVG?=
 =?utf-8?B?RklSNE1YejVpRmtPbGhRTU5QN01XVE9nalNPZ0FJZ0R6VkRhNncwM3MxQjRT?=
 =?utf-8?B?dERaWjJTcTFoMDBSNEFoanFVekF1MjFrbzRhTHd3aWtsaU9sNENua0hTa0d2?=
 =?utf-8?B?NURHVFptWFQvNEErdk5XRERCR3VSLy9UejZ2R1BXdHVWdjlwZGo4MVUzR3or?=
 =?utf-8?B?aWthbS9objRTcHBSN1NWMUl3VzdXYVNsWDZvTmt6NTJacU0zbEdmdWhFVlRm?=
 =?utf-8?B?WVI5eDNnczFPZ0l2LzJSS0ZlUnQzcE9TWTQrUDdVRDVRb3pBTWNnWHZ1dmtN?=
 =?utf-8?B?SHljN0RXVmRtS2RuSHRNMVpKcEVMbXlBNTdIVUh2dUVWYlB4UTBIdHRCdi94?=
 =?utf-8?B?SThpdjBmbzFkQkdjc3g2ZjUxVFI4R1NBR1ZLcXVnV1M2VGpFOTdCVFZMVjdi?=
 =?utf-8?B?dlB3U3FLcURKUHdxWUJ5UTRTcm9HTkZ1YU1uQTNnRmFGTDhLOEpoWW9FWGhQ?=
 =?utf-8?B?TDNtWmpDczFMWlYrTU03ejVzeURnNmRJeUZpMVFWY1A4WVFhbDlES3Ayb3U1?=
 =?utf-8?B?Umx2OEtINy8xcXUvNS82TW5GbERpSjYyMmwwbU1zdTBNQ0laSGdEQWJlcEEx?=
 =?utf-8?B?dWxwV3JOckovL2Q3c2NlbVE5ckErYkJYdWVmWlVFT0M2UUhDUnIzemtGZmtL?=
 =?utf-8?B?eEF2Vy9ydDRPd2pDWjVvZCtNQzlJemQ3TVNXWDRBTkNlbjg2RWl3MXZpOURy?=
 =?utf-8?B?bjBGS0xOTnlaTDdxK2toZktZUVFFenQvS3RPaDVROWdiVkt5cWZHQW1NL2dw?=
 =?utf-8?B?UTFGRWJTc0tyRmxxcVV4cUhTU2tZeld2YTkvWFVtdldQQWwvei9ubmhUN2FJ?=
 =?utf-8?B?QVBmOFJ0Y1pKVlRZUHpRUVVORjhtYXRMamUvUlVIREpjNzVHKzhTSlRLVk0v?=
 =?utf-8?B?UzVGV21xVUxUMUU4cWdSQy9obUVNbThNdnB3dURQRXRxa2I5bkk2K3VVdVZP?=
 =?utf-8?B?MzNrd0hBbG4rYVpsc1JkTzJoLzJiVzNnbWVpMldaQlI1U1hhdGRoem1OdFFC?=
 =?utf-8?B?Rmk0SmMyS0FYaGkvbDg0NEN3UElHaVlzaWluVFhoZkIvbzZ2Y3gzYytVdHpS?=
 =?utf-8?B?R0hBMTFPaVgyOVY1S3V3UHlKaGU4dDI0SmlsRGRPQkEyOTVleXBGamh0TmFQ?=
 =?utf-8?Q?qoLvLfetS/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHhRTzAzdVRuMmhtdVlkenpNMnFNc1dZT3BHeWl0Qk5hZEs3UDhkeGFlTEh4?=
 =?utf-8?B?dzArK2dKekNIbm9iWm54ZFJ2MERKaWhGU1hvblVKQWpkblNkUzdoekRsSmY3?=
 =?utf-8?B?eTlFSng0UE8vUFA3S1F3UXp4RVk0c0NBMmZyRkxQejJYY0ZpeEpTaG4zSzNE?=
 =?utf-8?B?cThjQ1AzVUtJYk1ManlBZzNTQzlCT0hQb2F3SnE5MDVMWUlFREt0bFJkOUlK?=
 =?utf-8?B?QjM2bnJ5K05Hem1kQzhtd3JtclRQbzN5emRoRE01Yzg1VHczVW9OQS9OdUg0?=
 =?utf-8?B?K3dWMTdjTDVZRmJtK1FzcFBRUmVVQ2EwV2JIdGc0eXJzMXZ3OVpQdkxtbzh2?=
 =?utf-8?B?eVk5NEhFdkJiRXZMVDQrQVJwZzhGSzBReVlmS3NBRlIvWm1LM0R3TFNDZ0l0?=
 =?utf-8?B?SUdINjNjSjJiZUh2N2dJRFo3eWh2S3RiOFdoTVZCOFhwUlBHNncvQTBvWkdx?=
 =?utf-8?B?d0xrMVlvWGhidUdGNDlQS2F5UzJQY2hwY3ZTL3hGTXdmRlVIMk9QeVZudWsw?=
 =?utf-8?B?cXQxdDlsR0RVVHhoRVJiNE1aWFBkOGRwZzB0Mi9VSjQ0bjJXMWplVUtSeGpN?=
 =?utf-8?B?aTFGWkU1SThaSlRsNm9PMERsUlpLVnl5SitnYlhvYTM1dFJENjZHc0JaelVC?=
 =?utf-8?B?eDV5czcwYzE2M2ZvZStKWjJybXFPZWJaZTUrcFpuRys2ZkgzOEhWTGtJWUdK?=
 =?utf-8?B?Qi9Kekk2UFhDb2pnZXN1RG1rYWVpNmNKTUUvRVVqZ3VGNDFMVVc4WFc1dU5Y?=
 =?utf-8?B?ZDVsN3VjUXBWVEY2SmdWMUdEWTJNS0l5WW8wa00xVTYwUE1JT2ZZMzFGWklQ?=
 =?utf-8?B?OHNlWWlFTGdHdHEzZUl6c3M5KzA2QUVQM3lhTTdkQjNWZGpydVBsbVJPWWpM?=
 =?utf-8?B?Z2FMbkFTQklmWXNxMHpIb3ZlaDNlaXF4ektSNUdYUjVscmErWmdWc1FBbzNW?=
 =?utf-8?B?U1JmVy9jcnBqdzMvZU02QXBRYkhRSHdzbmtzNE5nK24xOTNXWUFyNFE3cnpu?=
 =?utf-8?B?dVlEeWNTQWF4MWRneGQ1dm9aV2FReFRvR21KRmMwK3BicEQyN01oRW0xTkoz?=
 =?utf-8?B?Q05pWEsrcjdtZkdISTlIQTk4WUE0a0lzWlBVREQxcUVmQTczOXJMWjdPbHpG?=
 =?utf-8?B?cDhZUU5QTFhnVkZQcE9GdWlwS3h0Tk9vOGhudVRrVUJBTzVkeUdnSXN6cjBQ?=
 =?utf-8?B?QUdYc2R0Ymg2dWx5NVRUYmhCLzEyM0pBWlAvRHZ6Tk5Dcnk5L2hzNFUvenFI?=
 =?utf-8?B?cEk5QlE1WUpObnVXSVVuL0NjaGZNMDRTa29VbkkvcmRkZWhYSjlHa1pRVlBM?=
 =?utf-8?B?QlErZzQ5VURnY0k3OUdmR0ppQWNWM2ttQjZCUlRFNmcrWjF1dU40SiszN01M?=
 =?utf-8?B?MFJwYWJQdC9oanhjN3pWcklsZ015N1N4WDhRc1NNMS8ydkhPaXdIRVZIZ3NJ?=
 =?utf-8?B?dUlkOXZnVGFiMVlrcmJ5Nm1USnBwTmNzWngrSDdXUStYNHBKUEtyUXluRU5I?=
 =?utf-8?B?YnFNMmlVK0dDRG12Z3A4YXBFZ096K3RNT1I4UUNnRmFpdWhLdXBTOVRuWUdl?=
 =?utf-8?B?YnRhdVpIMUg2dEFKYUVqblEzZFk5SnJmcEo3Z1R0cGJyRjRZSllWcXVZdEZ5?=
 =?utf-8?B?TkRuNGFDbko1Z09SdW5lMVFVQXRyeExvTG81WjNFL2tWTzBCTmhYTERjOEky?=
 =?utf-8?B?WlNvbjIvZjVQazVucEQrQkFJT1BFRlEyaHl0MEJiNWpqTUpZNjhwQW1wWktu?=
 =?utf-8?B?MmtpV2VXQUk5UkFiUnZRajZoUzV3cXB6Vzc5aUVTaWQ5YVduQ01HTjFtdG1k?=
 =?utf-8?B?QmpGWi9EYzQ4QUltSmw4c0duLytmUklDbTllVTRudWt5VWVramxLaDFSbkFK?=
 =?utf-8?B?aHVBUUtDVXFkaEZsY3QrWjNBZ1phM2VvNVZaekZNUDd5bVNsMngySXBkalBm?=
 =?utf-8?B?V2Vtc3RwTkQ1RGlwREh0d1BoRmlkVm9uNFc2ckpvRVdoeWlzS3lOL2oxL0hz?=
 =?utf-8?B?dFhRYmpGcnJudTI2K2FnM1hmK2M1NzBMdnJ4RHBnYkFrZzFxdjc5b3E3cjRC?=
 =?utf-8?B?eDBhU25SMWdGU3pyZkdMY0VadjB0Nk5KWjRGSkpQYUticVRrV1I5UHp2cVd0?=
 =?utf-8?B?RmRPZTFOSHNqVVBHWGlYWjg4djV4UEhqYmFPVUZUdjhiZUZGZnBWbEU3Vkl5?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NHMe7XdPpetWOEgddMPYoxrGyUn97PXs355Q5CxXWVWriyUFDGqV7sLU5j0CdVlGnPoXkIy2gStxGf5KKDRk/kQHKI+occY65gFvHegBziAvipgjnQbcvZtAGyYNY3J+TaQ1mtGZ03dDRnSqhTMfR+Wk5IcKXBZ3kmufgyVWvIaP3L9WIdNFocXI5YpkIMSUqFZt90IMRtFz6jdI8k8GeVBT8fEVdt4HNtjJhhw67lVW6AgTxyzwqBNYRtSNq9cYKhS954up6Wu2rid83iXWDvT9EjEghQ+1ioP6TXmSoaig/QjfuFHWOlrYI7QRW4WK9sh/6+uuXGJjVz+Q0n2oVGQf2AgtOLav0FpMxatpX3N4te+bH0oE5PqSRjtHj3jHtpdTxok9VWnhwUp5hMNZq7QhhJ29oVhj9AjIHM4LbNN7VNnWR3jVJCXtyJwdrfizNCZhvJR3KzLMt95WVFM9N51yx0gk7RoWa7iprBkbhVdZoVCoQ5hV5rxUXM1hs+Y97XEBWCRbgZrZjw3aTeCvhjk9sCs6L9TTQGljPahFYf5j/8b8R/lGgivPrGSP+1th7/e19jK4qhne29ovbeSBOnSkdAwjN3d73jtfGFsCqRU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53cb8fc6-752f-4ab6-86b7-08ddce5a8eca
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 04:44:09.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rz1mvp25qgphz0C45VMbQwDABOTOoRkiQf6L54kSS3lSyFL1xnqKT1N5QNaBzpsTftTkCmcIM9zmt9peuAsDnlFrPuvdQyWkReBFMfxqbJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6367
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290033
X-Proofpoint-GUID: 65eVEEBZxLJsj2oJycrJLEsOasXg2YBv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzMiBTYWx0ZWRfX2BYFZfqaU2E/
 vQUnvLMy/4fKnxKGsbEQmccXCnIJBGd4pzgxvm+s50GDqFkjEZIZvDPev+BaIvY6G/ITJ6VLUzW
 Tsvak12nQxZvKj/eypezgmemtboJLVvEXxNvjLcCXX9TRbCni7TH0GqFTlhdIGq24Ela5KjV++C
 t4p1VvG3HQ1GvwBIfG93lpHEQyN5kTDsnE1jXEH+EIgsJL1cHWUGHWjaJr/LYJ+ivHCeRN7dfWN
 DMtAbc5nNU2i2g2ovvoZmXZkn4vB7ueH+8O4eZ0jWW35/lcjGNv7ZFTDbipyiifhpaabrUVmdfo
 eCDzjHIHoNEuuPi5ZzQ05UQHYGejUwxBM0zBdTZ2Wdjmkx55WcLAPWiIjcW20OMLsQrizVW8b9T
 eDXz/SgyQy2nz3B5b71mopxe3DAPlmzl0QtGKx9stW0Hc7FH8EjfOvdZFwePQeHvfRs/ZY1J
X-Proofpoint-ORIG-GUID: 65eVEEBZxLJsj2oJycrJLEsOasXg2YBv
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=6888519d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=kThdcLObp-MR_yZEdAEA:9
 a=QEXdDO2ut3YA:10


Csord=C3=A1s,

I basically agree with everything in your analysis.

>> Then in drivers/scsi/sd.c, inside sd_revalidate_disk() from the followin=
g coce,
>> 3785         /*
>> 3786          * Limit default to SCSI host optimal sector limit if set. =
There may be
>> 3787          * an impact on performance for when the size of a request =
exceeds this
>> 3788          * host limit.
>> 3789          */
>> 3790         lim.io_opt =3D sdp->host->opt_sectors << SECTOR_SHIFT;
>> 3791         if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
>> 3792                 lim.io_opt =3D min_not_zero(lim.io_opt,
>> 3793                                 logical_to_bytes(sdp, sdkp->opt_xfe=
r_blocks));
>> 3794         }
>>=20
>> lim.io_opt of all my sata disks attached to mpt3sas HBA are all 32767 se=
ctors,
>> because the above code block.

shost->opt_sectors was originally used to seed rw_max and not io_opt, I
think that is the appropriate thing to do.

A SCSI host driver reporting some ludicrous limit is not necessarily
representative of a "good" I/O size as far as neither disk drive, nor
the Linux I/O stack is concerned.

shost->opt_sectors should clearly set an upper bound for max_sectors.
But I don't think we should ever increase any queue limit based on what
is reported in opt_sectors.

--=20
Martin K. Petersen
