Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FB72D839D;
	Thu, 25 Sep 2025 01:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758764647; cv=fail; b=X2pCx8a2GS00rsDUYh1CN10vtUHXt2pZmT4UpLJ2CCzRtZ3C4l1etGE+wEluhhvevrtKZxSA7t8wrS7ycn73lE+neBsMVODH4xmYBRH/EywBUpQmwryLgU/iL4sq60nnc8cVc91tTHnp5ndol2fF2a+t5Z1jvc6sR66ALppGbD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758764647; c=relaxed/simple;
	bh=D2Xe1kB51IuLuMqsuqI6CcMDheplyMyM7+vv0UDtl+M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HqxZHNAJHViuNscJKN0uKtKZ0CYr65HAYG+TM3BpmUc8gMzCRuTMGfxhsJW68vSvwm0/I7o05rxFQWt5q8FjJWKv4V1KvaHCdCiSUB45PamaFrkjvtbD0PNk2TFwR0vcscv2SPgVLOnz0iZ9W9D9G/Qa7DRP41BJZ9Wky3S60x0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kG/wC9hV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZTNA8I18; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kG/wC9hV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZTNA8I18"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItsR9020553;
	Thu, 25 Sep 2025 01:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/2J2TAstoLoqLHA0Q3
	W6RNORMvGGcsb07o9nbbiK41Q=; b=kG/wC9hVCUI3OsmsrE8SKhgkkjlMsuWsoG
	4RMIZgZuhBvZiNOhp8VMEgMDBZwn+a1NpUw9mtfw1FOAX9U3DL7yYZPGPQYAA/sD
	Kjegy1vHL8pihCk3wjdQc7Hf0W4zVsoi1NOEokpXKN1K3wNeeT19SOHOuQv7d+Kf
	JpgdkAe66+bjUAJPqRyGmi3CIp2HVEYWC8mxNKkga8H7ACoGz7XXj5+CV+AOw4YL
	ijU/HsPwJsLP+lC+SqkyP6pU/Mk/wCNgAUQym+q8GqIsdX/RN1x/BF98nhQiPagB
	hn+GA2JA4FhcA6uvQLyA4nEVPYxkaM8G6yE4M4n9w2VwBS/sx/Tg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mad92pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:43:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P0IRlL035550;
	Thu, 25 Sep 2025 01:43:33 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqaqe1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:43:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vu/rrjSpUyMgIB3mCYSjcwIa0OZ1dBJ9SWKk+EgJrBybfovVLvrwTCyG8GSqjR/MM5mlsrQkQYWTHR+LWovzYzAxoaGhJ5+rzqpauDV47vVbsomwcIm1xIJsrCiBTocsMP8EmvaZVLt/RookOZaRJFfkagWwf2PJIDf/2kA5mAftvZwjjknUKiA5SEh1k7qL1f2XbmmXWxiJtMPe53y5Ac9Iio/Sf5n8vg6wawQrQ/FFl2QbAHa0OyvnHO1+Eeoq4vWVWckguxBhRFAwtwKxbD5N5FE8PxvImuEVWLh6pxB2itj7qy2+ZevkY1Oe16H7TUuoT14W1NWuznWR/s/xyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/2J2TAstoLoqLHA0Q3W6RNORMvGGcsb07o9nbbiK41Q=;
 b=ht/w8Jjav8mexWqgLzF8CyOlku/NAUCjD29f97s94yGQ7ZMb6FlL/xqwT6Zt9uxqaK4llrU38d7Z5aMh5Zkq2UrKVfKhG6CU+PumimuzzUWKV+68aDGDpAB58vkmA/GZFuOQTeFEDkQbTjuWDgSW5AUGLHtFUjXkluMKTe0o2OeJ/0/udOhKscaEijhAkKpp49fPG3KGsKgWPVprbbCVtUve9xCA+Txk8gPHPFikO/PTK8vo1tVycmvL2XzHE8VTGxgxtfcRqWCNQufQlXtf5orOgG7CymHRuWY6IKWNOpP9k8TguW1V9uMw7i1/7LTI5nOBV5T4yJ1banC9I7Pb1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2J2TAstoLoqLHA0Q3W6RNORMvGGcsb07o9nbbiK41Q=;
 b=ZTNA8I18SKTI1TA+t8mxwsSIaR5zAErtnJKpnIcpJ45upD0iHd53HHoB44y+VyD6M0nVln/rVsnQsFUtdhvrNIjvCg4UaGOSkVSTpdZxW+9nC5LlF+x58LjGrK87BtE5/G6VCT9QtePTyULdwFHstvJAGvtfgm2Q11Fz6b3OFoQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Thu, 25 Sep
 2025 01:43:30 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 01:43:29 +0000
To: John Meneghini <jmeneghi@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, axboe@kernel.dk, Bryan Gurney <bgurney@redhat.com>,
        james.smart@broadcom.com, njavali@marvell.com,
        linux-scsi@vger.kernel.org, hare@suse.de,
        linux-hardening@vger.kernel.org, kees@kernel.org,
        gustavoars@kernel.org, emilne@redhat.com
Subject: Re: (subset) [PATCH v9 0/8] nvme-fc: FPIN link integrity handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <513ae24d-fe17-4dd1-a226-4c699e94c0e3@redhat.com> (John
	Meneghini's message of "Tue, 23 Sep 2025 15:21:27 -0400")
Organization: Oracle Corporation
Message-ID: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
References: <20250813200744.17975-1-bgurney@redhat.com>
	<175613417235.1984137.13827666752970522478.b4-ty@oracle.com>
	<513ae24d-fe17-4dd1-a226-4c699e94c0e3@redhat.com>
Date: Wed, 24 Sep 2025 21:43:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0341.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5564:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aec36e8-7c5e-4313-c975-08ddfbd4edcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oDSDhOAkhrkA27oviTkdLnnEpKqSmv5kzhWaggk2jntJxIUhWh08lchBSDfn?=
 =?us-ascii?Q?PTiB537PAMWODQNCyphjo/88JTOsofgq7E6/pIJjgv/u/xqX64Cj/3vCmPOb?=
 =?us-ascii?Q?2jrbbxq6ExxIhtW4M9UulXExD6jaaWo6+tShOGyCtRh5nCWawOtY7jc8GkCC?=
 =?us-ascii?Q?QQlgvrdTkYQJBiEfTyM826IkZg2/gQODAfIaZz09hK1sSHo+f2DLuiIPElaP?=
 =?us-ascii?Q?Nu6YrKddwasVJOeoZoKOe/gfCSOOzoe3yhlVRfRlE/nq246cxj0as1J07yD0?=
 =?us-ascii?Q?vmlRyxfQNG/Ck+U7RbU0b1wvsYXjE3QuoAlKAp87Pq3jYKnNC3+1KSHhGvf4?=
 =?us-ascii?Q?2zB1nNn5tfWiYY3sh0e4CLc2V9XBUi05OCNSJp+1aWASq/Wui/HJbW6a+4Hs?=
 =?us-ascii?Q?ddSlOylFLX3DB3XOQ7GYVC5smipd7LpANsfPtuActm9qoVNmLMlo2m4sFmL7?=
 =?us-ascii?Q?QtqB116iz/D/Adj/NyMCdBzpRkjZm92wWX88YpAIOpG5BD2AvCAByTSt5S1y?=
 =?us-ascii?Q?s+DKNQBdP0Ecvdi1pCAZGMwBp2R8JYkikveh77H/pm5Gdyc/G4qEkm2/1wdq?=
 =?us-ascii?Q?B+8SkEVwIeD+ESlnNOY4/Z7p3SZu2by+HamMWcNwapSoJ6rOJb+0Z+iZZgGM?=
 =?us-ascii?Q?MvXX4f7M6N9lc+fSNiY2hQrs937QU5DAOBLgdQGs/VyUlfcWHPAnHMU+dczb?=
 =?us-ascii?Q?72Zo0RT5KdWK2+RSTAH8nxv1HkKt7muP59ZlUegUwnTS5zX2vOQnkUxZgrRc?=
 =?us-ascii?Q?f5S85Mp+1kjbsgjxEH0xXkv5BQp/Igp+RtbO+s8YyeB+YWADFz0+/E5gJtiX?=
 =?us-ascii?Q?2RX4UzI/xZLaHnJxDGZQMTuRGqq18NOVuIY8WGF84xbNoC0ACqW8YjTDfgj3?=
 =?us-ascii?Q?mPZE/0VMtOy+EHfVCYsHD9On7xHNap2CJTd4Airv8C3OJpqQtdHdwuj1CkLc?=
 =?us-ascii?Q?pPGUFKgX0zIqMCpvuG3Ci1XnWa5yNH2ahspC1IF5+/0hyjCAUsM1kvqxxls0?=
 =?us-ascii?Q?J2ND3FYQxCV9xi/zydRyuSrydYi6ktgmSVi37iHqzxt7tFs4zGoeoD99+kfZ?=
 =?us-ascii?Q?XASsqf61Ps5GEM5neoZEP8+LFWUhrr0vwLcVol3hinTq0a/0QHGtHMGuHEM6?=
 =?us-ascii?Q?LTLToMB/xROa7WEdsgHsgvNpFpyw0K/+L3X8IDLhiEKji0DkhcnEn6t+/Qq+?=
 =?us-ascii?Q?/MLCCZU9SWAkTG1RBy5PYL9Tceyrc1d7i9pbCn9By8LwIx6z/VNCXQFmrDhB?=
 =?us-ascii?Q?bvLbK3KbXL0AfGUS5yBIN555sBl/S05N1+Llg0TWwbzdhX5MqPO7C7JwyQD1?=
 =?us-ascii?Q?8HRnJ1TMPstbxO3DPPFX5p7B3Bq99BONACi6EQJ+mHN1BG3n++pFo7nnGD8b?=
 =?us-ascii?Q?m//Wh1ZNkd/J2+np19RmmdeV9AsFn6Cx/9FCHYhIQgrOlfNXEh6wOAnex7an?=
 =?us-ascii?Q?1+50bJ+WCz4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q7dTS2RrpnlO3///b6XnGrWDsXlUhFDOlahgQga8m/Wylf14Zfko9YILCJFX?=
 =?us-ascii?Q?BgqI+I4g433xWEDJTlRSdIAn2qfe+8gcq9kPNWFrtE9Vja0rqpg3uiHj657L?=
 =?us-ascii?Q?caPhwPCqCc6q+OQM/S8ruJPRiysYTvhZUfT9FHk59J/sWWgyVJyFTEBVALfc?=
 =?us-ascii?Q?e1gkgvYuzcS1uJsPRZD4u4QprOug/bUn3hUsPDeARScgDYCyNEmumn6E4dY2?=
 =?us-ascii?Q?9aoAvhjwpbYk0nWNJx6sU7Wz7aKCsSbsMx1t/CzVzQzR8W/ULEsbepcKjJHr?=
 =?us-ascii?Q?asyU86qVct2j9/hyYao+cywlM0enS6tJ218cK2OWPmF4iZXs8vJ+ic3G3sU7?=
 =?us-ascii?Q?QFLqnNhsciuUo/nonqPKhWjUnOYGyM5eUC1BRCykmDPeqZGw/h7A4/t356um?=
 =?us-ascii?Q?jbOtfl/HQvljPcl2tgVbN/JmIVktSNYcyFg1TQ78IPBqhWlBZhBoy2tSvby+?=
 =?us-ascii?Q?J01J5Bj+5ylTCRUoTZxl+p9mIYGog/sW46/yGbTN1mipX5eXgW152J1Sifi4?=
 =?us-ascii?Q?iv3Oij/y0AIkof/2cjCtJ4sLKnUj5K5yxIrf6tlE23z6Uv9W7SDwkWEw6bV9?=
 =?us-ascii?Q?3ZaCilKbyqO0CEwRehYdX7Sli74K+KhVwRIPz9iT/xmqkZsnrgWSNGx++p2m?=
 =?us-ascii?Q?6tQ7N2KpqJZIhZKoMlhNFDx7e3MvlIqF5AgSS0H9yMU4UOVgpdAZnGMuIus6?=
 =?us-ascii?Q?3Z2vztc5w0hmb+Kkkr9SOA5tgWfJS1JD3Hp+9fhxwIV3OXRqKT1uLNNnbvOz?=
 =?us-ascii?Q?OQfd4y1MRDRgtA15suiApuI7psv3mbG6HUXM+cwv1geuLe6NBpJVtPL3aS8V?=
 =?us-ascii?Q?6UA6V1obwKaOzlu9+p19gu/8O4bXifmY8hcdJHikGbx+x6JVcXewSwbVCZOt?=
 =?us-ascii?Q?Zj8gIuoU3DDhEaybKAPpHSz1XIVaj8EH4bkIkopIwch7EcOGA2YfFYwsNOsV?=
 =?us-ascii?Q?aEymlnipuXs3myeqQp6z98MXgNNYIjXxioZkrpJLVo5I8zXJFmHgYRs3Ga4W?=
 =?us-ascii?Q?1zd6mfHI9DlrtNB2KXFK4s3hJtaIof89ZiwPjzdsEIR1T2voTwF5vcHuOubn?=
 =?us-ascii?Q?RlU/Ij9n5pqaCpcS5ag1JeVg/xDrQP+KLShTUNcvoRF1V/gPu5zWTV3X7PNK?=
 =?us-ascii?Q?ISoUoDqAzDtik+uSZ0hzlirOrG0KHA8KtNN3mtUKbkztmaRCYMpyx0Y8D/mo?=
 =?us-ascii?Q?PefFKzvsu5YjIAwBaVgNEd6IZ0cYojM1Ifp2yU50WnKrZrcwQMPQyTSPW3JW?=
 =?us-ascii?Q?3G2rDeeUoMt87PXHRfwyQw3aYrzW+n+F9OBacO5G29IeWiWhnJy7fINFCFLk?=
 =?us-ascii?Q?/RtNrRMyLe1DKbbTsmmvk0Pf6nuHDDzpn3H01IIZZYQcPLFdut7tqnZLvPp4?=
 =?us-ascii?Q?s6FDJ9O32kpoQUCgcI0UFoare9Ip5Y7G6XH1Ormzed/pzXDPRX22affSRfVl?=
 =?us-ascii?Q?IgSVrngR56v4i3Ijvi+hv87wpEM40PKOImCTddPbYnT0JojXPWB+jP9zEDxg?=
 =?us-ascii?Q?Yeft7oDiYtyJMYSIFmJQeZAV0UqzcALbRlzbfYukTUIQpPw+WcG1kxJ9VGtA?=
 =?us-ascii?Q?1xD9XPanOTJ/BRvDFqVh05C3fKpUI1/FjwaJObGW5Gxg4oIRZf1dK/QvUNn7?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JDLzq51ePANd0xwj6ixG2zqHpPfmv1Nhv9Z7dJ7hGJLnAsPxuN/Yu9RnXQgd5iql+QuR+UlNjHI+e/9GAKjXiXD1euF0+LmR59DKRw+8r2TTDnI0gErMRqfebcYqlUlE/9e35W4gRt/lh39wIz3IDqyPTMP03mHWOGGOe7QL9aGQv6pBwnp7GlIT96o4MGJ71254vmtw0r5B7ltN0Jj9b6SgnldTdcXovcrVqCEb7KjpM8bQPsg0veUs4xPIP4CeAzXFNzVzNkxLA8zNihOk+L/0es6D3+WHXjhitjkiJ8/aO6ZxQTNTA1K06Tp9Fpax0Ad+61q0apjngnn1qDiY7X6kZ/dEzOTJVU9rJMEix4TK5G/PxX+wF5/+efp4dsaDS1lWihLPl+T2VEyKK5CaVSPZVAgGs7Lju0fyGJKJY8Pzz1/yuF0ikkUya50cWhWT4xJN3t7wtGe4ZkiqPBOafBeyrCIis5HDldl4rplDlF+IxsoN0mT7okq+C7sFzMQAA4ufz2YDPy8ffpcrPNQl8sihgLHWAovTOQJKvoiU0jJy/pIYzMWSaJMRlEcv31IDXhBs9MUQXAow5aJg6SX6LIalUziE8DKDPvY3eyaMWmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aec36e8-7c5e-4313-c975-08ddfbd4edcb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 01:43:29.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iN9OuoM0atdOrnU/OT3V5hAp3bN514RQYqSzeM/OZj3TY3I55KtnLwcXRaqowJMlhO9DTExEzsaDcF5m11MxKlxEUyQGuo2MUc2s3ESfwJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250014
X-Proofpoint-ORIG-GUID: IQDBfA-dowJRfweRjU8IExXXEossvWyH
X-Proofpoint-GUID: IQDBfA-dowJRfweRjU8IExXXEossvWyH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyOSBTYWx0ZWRfX/7VUhkFGkun2
 awpNGcOwMcPPwVdJFde+T2OeC2YgsFLwxhaANTnL2l4UCfrzG6Y0E6SpjyqYvXqvyWKvtlkcMvx
 2NbPKgjRZvcxI4S2c3csD5R6gZ9XA6LodR/vSWIEJTUC9TlDMuAIgEHLsJgnPg3CnNxY2fYPCSB
 bZLiwwC7BXYESKYMcurZnu1GZfdZUridTK63l6G1dlAaTWs86QWWAm5DoPhnI4Q8tad/z/9uK7o
 PF8OP+wBSEtVCFV2BwrJhJXkcql4HUE3kzTU6giEd7tv7AYrNIcyEMyOyOMWT1AypHLUEwRdhay
 ELk4RQKCnT9wjrx7cv3p8Q1ZEAdTCpohqtaJfKkNa2JD9wp0bqDOySIt6EXUt47bfzfFtUM3hMf
 WM1Cwyj5
X-Authority-Analysis: v=2.4 cv=Vfv3PEp9 c=1 sm=1 tr=0 ts=68d49e46 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=3wYnIcOAaRluBGr6YacA:9


John,

> We've been testing this patch and it turns out there is a significant
> bug here.
>
> This bug causes a call trace and a driver hang.
>
> I suggest you remove this from scsi-queue and let us fix it.

I am not rebasing the tree at this point. Please submit a revert with a
problem description.

Thanks!

-- 
Martin K. Petersen
