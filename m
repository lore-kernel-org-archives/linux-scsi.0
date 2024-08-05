Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B648174E;
	Mon,  5 Aug 2024 11:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722857622; cv=fail; b=UR/X92QSWe/BYd5E4Z30oLejFz+b2DZhYZPUgNa7t/4AgC1uPEFilamQjCfWnjQEi/0vPCCwEfCMQ9BXIOJY+dnlQ09BsCR/xv5PYEZLRqhtyTk9VWmLBTZGXuF4bZ+YhbvVpNFCTKmefGL5fqFndTVijEXcAbLzG1eip1nZRdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722857622; c=relaxed/simple;
	bh=O3lt6qHLOqebzwCPBUAJGsc9kDcd8iW64RtTNueBdl0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=o1N8Kf+nBtJu0zfKdhd1/GtNCazZdREP7FkLh+/9+TpAPvK11XnmHB6ic9zcOAm/X1035DxTDyOlD8Uvd4boyohi9gFYC88Kd2Wpxv9sij1EpsLcGYf0d4JYPMlVC8lL54BJdzWLKSJHMK5va/KV14Gx4D1e5AQM2v3UVMTQhjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PIZ9wG36; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bxrYH+XU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PIZ9wG36";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bxrYH+XU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4758fblO027498;
	Mon, 5 Aug 2024 11:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=fU/ctZlLxFw4P8
	xY+d033HmL774aUpLbSV9GKYK/wlU=; b=PIZ9wG36TqT/ykb7j0HnSBafN/87nU
	ZitKdBHhZeapPOI+q0yAPJWpQZTO8SitQQoA/zpt6OxUb9oHN0IVlzk5+LY33RKW
	s5YV2EOxdQJ7jlzT/d4cWo274lfk3uj7YbRFRMMNMHhkzXtbEa1ksLyXsEOdOPY9
	Wg6m7OEEDLLb7UexmQUL3K+w8CNfLXTshxgu0Ffrd3NK8s1IEr8k3MjU9b9lKVq9
	ig2voL4E54jcEJuqwpRxDrdnX+Tqc0iCnkWQgAfBSq9WKxR54yWlwLFjaQksmN81
	PW4lX+Mzd/wjePaQGL36hEZF9NGQUT85WWOXz+j5JAj8HniIRwJkNXPw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbfajen7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 11:33:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4759Qt7u018352;
	Mon, 5 Aug 2024 11:33:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb075e5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 11:33:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eS16DtVLTaaVhSdSBRRRjEaxmITkgAzZ5DZaZBbR7Ov1e1V3nKLa/sRVpLaXP2TgO/Fz0DgLmTqNKxCC7foigF9MRClvcwKJ6abFWZuqa3NhWXqNeVckJa3Cly0aE41j4paqe8sx8UmQL0BQeIw3zMjZslXyBUSyqBHe3Sy6lBu7s3IaYTGgyFQjfjsJWnfXbK75MlzDqsAJyG00fNnm88ui+ZhXMKzCRlkyjw/CX7DHt9RRdPXJy8yOZGQHy4+vIjqdvNRAZC9duAbHPjTfDwjh0TTVovUosI8ZJA4fp96iDBQ5BygGhSqGD8V7Tbb8Tw3KdcAcJoWyhfVDMZa/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fU/ctZlLxFw4P8xY+d033HmL774aUpLbSV9GKYK/wlU=;
 b=JeEF5l+5X71XWvxSfS3smAxulGqFEWAoQV6JGfZLR1G5eTAdMTKKF7rn2TmwGrlw6FO1ltYs0Wvn60ZizpAtrvXWrzyOkcamJfIQCdhBjlfWzHZcNGDROOv2dh4jw77eAu8SHzA5cw5m9Ptszjz3VXQZbLOSl+bNLSYrF1wJp0tgKKERpcmmSheDrt6yPVWORK+NwG4JudvQLIdqkue0hnloB/uYF58RCzNZQcN77oRRta68/o086tY+AWWe3ENQ2YYMeREqyw5T0chvO77KHHnGfWqlE0vFuyeNOHseEH8DTtx3kBEwsxU2+CsNaT8CCgj0nd9MAErMpz/UUIu9jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fU/ctZlLxFw4P8xY+d033HmL774aUpLbSV9GKYK/wlU=;
 b=bxrYH+XU6+P4RYSkibmysPsjuwcGXcUl9cYLsM4IAP+8W6AIVDsSZgMflP/3f+H/5NZEayulJzLZqPwb4sSu/dtcGp4HwQZcaJ3PT0Td9/tv1Vvw5Q/ydRrsr+EB5eCts+rRHZViJHvgVrOoKWg1+w1j+tDl05jSFLfLUJvbEXk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Mon, 5 Aug
 2024 11:33:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 11:33:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] block atomic writes tidy-ups/fix
Date: Mon,  5 Aug 2024 11:33:13 +0000
Message-Id: <20240805113315.1048591-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0254.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: e12d5d35-4146-4504-6140-08dcb5426eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hs8l1c4AqIE3/4gPfFwt4eCMmys9ZoWYs1EVQJvepzdsA76NGDQl4cfiQIqV?=
 =?us-ascii?Q?Bqkb5tpwgaKiFdzA7wPTF9ptcBjXATJqvoLhHvCsUrhZ+KmoqM8BcJAtrRug?=
 =?us-ascii?Q?oYf7dr8Ic6mWA3dUkcjAfcj1bqRUqt0LqCWWjtmHUUE5MTTEeVJDjAoEr+Ck?=
 =?us-ascii?Q?AyErZkkZ6gfwU8zJxZOjeqhtukc0AKMbdI9a+IkaxorKUwDkg3qRjWcs81If?=
 =?us-ascii?Q?2uIgk23OoId+8Ik5+XscqghHO6DZyCO4diYQ7nN0sAFX8YEmHTT+Rp+4yEBo?=
 =?us-ascii?Q?unh/EFyj9j+FoQR1E4LbXuwY96rNz0GCN9A7kODZ32udDTm2e1K3x5sa4AYp?=
 =?us-ascii?Q?m58WdpbibcNW/EY4Ym0TvG2FKdOdHv3S8CiCtlgBQ0NbS+g6WlNBNZjvqjdb?=
 =?us-ascii?Q?Xws8/KgMVriLUKnE4NlaFhKez37CwWB59UKOFtKHRra85RKOhMJs2qpksuNx?=
 =?us-ascii?Q?+j2pA9LHAa6Wy4/LMtbpwChQj5RHMcgmlqIRnk7fAiBJfAcCRuHoLMWbURdv?=
 =?us-ascii?Q?2Jlk4RzXiuOrK4D3C2w/h5c1xyAgPjZMsIBw8iU/iddWS1lZBOvEl6iS+L+w?=
 =?us-ascii?Q?3cEImMK9fEujWCo5iRNU+XXvUzQOYbWTGC9IK+vec2oGXL6FqPql+iNkYIcS?=
 =?us-ascii?Q?W6B9AeGAaxc0K1sS7Yf9cASYEdKSV6wlyGcmzOWjUtxlkqv/BWnQhVFv34vI?=
 =?us-ascii?Q?bWp1pLSGFjlVkCEdNgGdhZUeMvmWkS8OItKe3T543GZ94jnHV6qfB2MEb6Yf?=
 =?us-ascii?Q?PFxaimC+2+Y7qj5WFNzSx4l2ycqjfhY2k9J+J5HHEDEyDwUYIQDJShH7bm3E?=
 =?us-ascii?Q?45Xl1u018MugB3/OmA6U7+Fd3kUchx8usZ4O0+Xb6mNFfxbQ4CtfYw4ywROj?=
 =?us-ascii?Q?ojlyk3FvCPFncwEU/HneveM7kWFXVWgRurkowZXJr0EfEMmY+XsX6nqNlyhV?=
 =?us-ascii?Q?PYKPqN1w8LWyAmGmlBeGkckQ0/zlNJZy2exl3ImMyXCtsnoYwz6LvhR9Ba0v?=
 =?us-ascii?Q?tF8L00PQT/mBbuONwDRoHeLGCj2uMfitJOq5xkHxyJot8yzRZV0NBmkxAdkM?=
 =?us-ascii?Q?eUI0FetxmDo5Z2Fvr5ef7p7WDT0O7O5zDSXUPNcSw0AIRdBCXw1G27hUeU5C?=
 =?us-ascii?Q?rNb5OOwYwAIRXh0HZX+NH/IwFIENdum/llQ+CGhoSDTXJ4bx+xXGSlp6EV3b?=
 =?us-ascii?Q?1EvxtMdeW6Z0/5UytYt345GeNx+9GaV+I44eH+fMNkKjeVqeJ/AEFDRkrLN8?=
 =?us-ascii?Q?nwFM5pgYZOW/pXFzVSwj4bl4Herau1lkcB+zASA+MelVrB1qDbb9wyD7mvMB?=
 =?us-ascii?Q?YqSxbS7a6xpIWS5SvDw0ud6nbLMexs8XE30xJ/o4f9lkXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mAhDiLuSywo0/kSJWlqnfcab0jnA4rchdim5rxxc3zW0hwE1ntgO/jLC4nhM?=
 =?us-ascii?Q?YBLPLOomCkXVYzWSOUa7PZmE/nbTuG40iegaYefaFckqxlDS4qpeEL7Kl8Yb?=
 =?us-ascii?Q?BiSERfhpQa1wGruKd8OxULSJYHB4VKSqxd4pN0V3E5wuvbTtffXhPxSTth1X?=
 =?us-ascii?Q?fSf+dXculJZz7F3MEhv3ikACQWegCjBWkq9/XyLGeOimjL1+nRKXBntG4ij8?=
 =?us-ascii?Q?w2kOgoi9WhaaTntYi1H3jLsRUAt6F6rOdgYAIdZEoeOE0O2TrtkZK/lBkQwM?=
 =?us-ascii?Q?uSD67EhGo08T5SXLCUzdC6XT4VB5ORI4yuZqB05WETIe3M31a6+TZQ1WEZFd?=
 =?us-ascii?Q?bY2SYtqZ56Tozkel22qXKbNRjq0IbK49UAhLuRQGgGkm9k98OEpYlJcfO5hV?=
 =?us-ascii?Q?W32Sj0YnhZsuxKdIxUEnBMoVzxYU538RxIf0qMUPQD4NPil14DH8MEdct6g5?=
 =?us-ascii?Q?vsxImC8Yc9hB1IaR7zzcj9w+ZEvXUiPXNvOhmxI+oJAZ2b5EPeY7Xi66UF2z?=
 =?us-ascii?Q?tt4tJcToOUvv7VFoFrv8tuihA/mvTXWC8GaATxweXrQIa+9uXGO6ntWDyPU4?=
 =?us-ascii?Q?3W0Ko8wfNew9xOevJNbQApJB2zFUuibkZI3XkSqb12qhw2Q4sbpGUt2NER9N?=
 =?us-ascii?Q?Qa62oaB4tqNUt0DP//eedeZ7CT9j9tFOLeHZzgzI1Q8cc/3fVT3oEH5zKvkA?=
 =?us-ascii?Q?aAki242zrhpF3oBEl912+lpzbOfuikwganvx4FE0wID5sXfoyjmeGFsIdl51?=
 =?us-ascii?Q?rFQ1oSrSWziTl/s2tpCbKCzGf/veohfpUdglfqrvEf42JBufVGWaeYWoyVbl?=
 =?us-ascii?Q?3M4TeHQRC/3wWOjoQ7/0V+EQEyyDvP1Zj6eAm4FUe+YJ+VW7dhy8SoBQvGWw?=
 =?us-ascii?Q?53hgj8EBqQywj+V9FMThbzjrJKvLar4DKK44ECss17ytr9MxT0y75Vm/bTj2?=
 =?us-ascii?Q?Be+7YQIiG3PVsZD7zde77ry2PLnhNXlZGN6WuOyKYkQTUbdhCBUZSEj+2yN2?=
 =?us-ascii?Q?1BQsTd+T4p0d1GDUhZxmpsH7QWETOWmkndc0i7hSgN6ugjzO94bEKmhTT/kt?=
 =?us-ascii?Q?yjVywJ4upS5kIXxmy345Ecr5+NWC/3RsGhjf877ulAVm4GTG6PvbbesTRtGH?=
 =?us-ascii?Q?zoY1tVLbavUXfnTm8wNS1kWWRH8hHZFnjVNE2/xV1D0+uCPzlLXoCxAuKGCr?=
 =?us-ascii?Q?z70t5ydRzV0Rk6lQGUO1EgSQk3Wd8Gsg76/DF0pRmKS6RgSoPq3BPz6eRmb4?=
 =?us-ascii?Q?7PpXVnG0MP0qyZQShQ9c/azsdsZWvikCliIuD7Xz/25d9yilItvV8hUNEHLS?=
 =?us-ascii?Q?mmyVtGIDahJ8aRV0PZHoHq7K9jIlky/wLSldeZWXYpDU7Bu7xs9stPIA1E7q?=
 =?us-ascii?Q?wJnENO03VsXz8QhSl8kLOXR7n/U1eWFmeNo3O5MOMECV8MkeSxVc/0WGKfvg?=
 =?us-ascii?Q?RxZOJ32ZaC02vp9uiDfVwoguEdC4ZZzCizKANPJTRqqlk1vyId2teScayllI?=
 =?us-ascii?Q?p2yiZoyPA7ENQMY3vTSD48ajXg/YTAT+VmtEcPeA+blC5VnseWJkJj9d7V5p?=
 =?us-ascii?Q?kX8GwGvdgSRyhFNSyr8cBWIzOqrrdueztNHv6OQJkYcvylB0JZJPDVl97EQW?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ewaoVwNE0QBqeoF+9tCvJ0W4GgQJaMIVINX4kk6ZmfIfmFAHoUzVJ6ObkGnX9G5eAUPOeGDuLITJho7Ba0N3247LfG27/tMCmYb8PPodqvZAJ/xCPA50LdmSioDofhsNRIrMFXOQamhAqZNhlWLncaine3Yat2MjVIl5HLLyqOgCjKn0UsuwNkfWSNjYTbzhQSsKNIRYTNPOr1Z6dYMaveOJB4pDzyQTUe9iNmxxIeDdO9TLzkWtAgKQyPfJURPZVoHxnzMzEvnH4gWhhTQMTLOGqqnusyG9VR8zknZ6tgGLuEc774UmiujfX/zlkmZkpBZrTK5Rq0T0QppbLwS1WOhdisGLkNnaED7IrP+rd6N2zRVO+7RBTVv7MsxjaC/dvnMUsft1mrW7N1zEZIbcJu/pGLZy7WpUUsAjt94eKpGFKbhZ6LUZXZKIqmJplgl5/nh1pAZ6n36K/n64/K71rpg83eL2WPZrzluorynhS8WomV8NZ83rwwCwVs07McoXNyUF7Viyau0l7rRZPwfpQhJhbrJhB8SUlOXmfvF3fTejPbgHhj6irUq8U6zceb+S0TqArtBW7TzMvEiANeUrzuWbpLi1GP6edDoZod8+6sI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12d5d35-4146-4504-6140-08dcb5426eff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 11:33:31.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqxoIvlLbQ1SRETqJss1DXY7BsVVD0A7xDK4MNnVLxX9W0l/vlN0QPD2DIyWmBUneIw5X2US68jV1wbeipwYhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-04_14,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050083
X-Proofpoint-GUID: ZVIRDTvgLctKo3dNE5BH_1dABb1GTwk2
X-Proofpoint-ORIG-GUID: ZVIRDTvgLctKo3dNE5BH_1dABb1GTwk2

These two minor patches are tidy-ups for atomic write support.

Both are related to ignoring that REQ_ATOMIC can only be set for writes.

The block change could be considered a fix, as we are needlessly
checking for REQ_ATOMIC in fastpath.

Both changes can be picked up independently.

Thanks!

John Garry (2):
  scsi: sd: Don't check if a write for REQ_ATOMIC
  block: Don't check REQ_ATOMIC for reads

 block/blk-core.c  | 1 +
 drivers/scsi/sd.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.31.1

