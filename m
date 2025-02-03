Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC561D5CD4;
	Mon,  3 Feb 2025 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738623433; cv=fail; b=Jw8x9RBHelTMFm4INgao7/0Z925Tkb1Da43deXmcq9c5siy/KSYeAvh3UKzBIXorDgabyLH8VyXMp68RiB0R/sORlodeV3z26YTtxnZX5zN5EAt1xZpdcBlNv90S0Dmu4uETXV8Jt/MzG/ds3xW70/aApiHM2TxQOSGtKrPj7mY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738623433; c=relaxed/simple;
	bh=dZhgzqfE9f9t98k3mk/zCxBVAWNp2GWZz5xyvxvgsO4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PGOh1t869qFi/oAWA5ygqS/CfhiSVspHghUSBPUv2DQtAEhtn3Rpl0WUkv/Jzo1MBj50HxDKHmRpeav+UfwiCEwA7QT6IES8vb6gl1pfEvt5Ktt6Fuzhq9Ny+zZ7xOziAwWLzYE3ryiEwGJm9fgtPbk/z1Nt3sCv5Bfy1VrybjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PXmPFFpD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WU5CWmOe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PXmPFFpD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WU5CWmOe"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMvNK024983;
	Mon, 3 Feb 2025 22:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=t8lhRXTBrywptG9snb
	66Iy877vmwJyrHleYHsEQVFEo=; b=PXmPFFpD4QQwIC9/kfHYSSMCK5TIiCQOcj
	0PHCaFjGsL7PBwJgx5M014ZRWLqhDjun487UFCw0NkNz5l31BkPyKE0eg8Yd5Mcz
	e/uZeZ0eqnRt3NFgmjHJslMkCgBxnTCeuVF2nzsMqj92B5shfnxupe47Di/bpMLy
	yleu/3gTuKDh9OlOByxMGo0034GmWLkPeiy92PHuOboie74i4a0/vetHPLoHxRoa
	MAgPVs61koBd06ByogYeFBppFh6wCIX1iBjBlVq1EnQ1bAwKJHoXV8CCNJmYEQKH
	QZburAmEGASAv/IX2cV1tB0t4Zz3IBFEscTH5QX/cNOjgG8+Y1bQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy83qte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:56:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513LtjjK029074;
	Mon, 3 Feb 2025 22:56:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p29145-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:56:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fBVR3vRkTJwYsEw1TqOAV+RSFiZkZ1NfjiUwVoBWxfKpGw9cXfTp6SK9hrgMbBWCu0fCFhjJDPLq1x8oYLEXe73thQ5X+oxguUDL0xgelThEvdRiwG2lrR6mIJs8kV4XXVoEOX9oMXVsv6LmATq/srk+6aLuSjWcVbIAsXDfzApUSKEde0IugwgXFhhsVr5JHg931SxVMk4Ft1Ar9/fxp+ljA0w6oTGn4I8rfABhtgWDPufHM4FbCTXXy6AQGn/9I4e1507r4JzYJ9+GrGS9X0QzCxPVtdlK+71G+nLNpCJw6CX5qgXY+S1M8HYpwJKAmpcD3yzTzSid0N+PcSUElA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8lhRXTBrywptG9snb66Iy877vmwJyrHleYHsEQVFEo=;
 b=noyTFSwmrFNkEv6kBNgbmYDDcIAjcv726wvP8tM7kBFBy6hRkaRvdv+hMn1+5ZOK8Cc6ouE1CyZyTHn0MJ46bBFtZBmCuzqSv2WmxnYMQEcOnw44AFhDhbkZfA0QW1FE12DqibbjIrz0d3NISTHdMNOw1xSSS1F5UtUtGtM3CsftzVNBgehCY3NW1QnJvzmK8zAoizoWlbIGV0U0/D6j10O5RWiAHgaguFAQem/orbRUpRizgnD5S1/4wgARetMNtwoEx4+PxMGIa2rp4AFv0uGdOuLwtxnsV+al3ef0/cSF6KdgEMhOT8GOy5NGjxgqf5M18szbUI2JJBy0QnjRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8lhRXTBrywptG9snb66Iy877vmwJyrHleYHsEQVFEo=;
 b=WU5CWmOe8EgFMJv0eC7PRU8EvakzaRzt3ZDXlUjzjwTP7dqNCilXY0C/cqZfXeHdhYVqlrv4ghPEMcvw9/I4Z1Zs2cyTSYevcdaH2sjbzB1MF7rO9odaenNjE6fmkXMhKH/y8HYVD8p+wJRNVqp/5tXRV37WZkDnuEwKe2Y/1q8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Mon, 3 Feb
 2025 22:56:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 22:56:05 +0000
To: linux@treblig.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: remove unused mvs_phys_reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250127002601.113555-1-linux@treblig.org> (linux@treblig.org's
	message of "Mon, 27 Jan 2025 00:26:01 +0000")
Organization: Oracle Corporation
Message-ID: <yq1frkuhc3n.fsf@ca-mkp.ca.oracle.com>
References: <20250127002601.113555-1-linux@treblig.org>
Date: Mon, 03 Feb 2025 17:56:03 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN6PR17CA0043.namprd17.prod.outlook.com
 (2603:10b6:405:75::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 169c46b9-1dce-4e4f-3c27-08dd44a5f081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tw4PsA2izoFMsTsuVCek9UOvgBVg/qW1fs8ThRLRQyDW3/SjQ2Ynpuuijhrc?=
 =?us-ascii?Q?WKZPhx7KVEur+u5bSQV1XNYIum87T74iGFrtnt8GWmC65yytFgUDa5y5KBwg?=
 =?us-ascii?Q?Xw+wkdKgFWxqtcCoJwySXj90W15WMZpL710yD7ZzaYpTPvSI7JFZzoSXegAo?=
 =?us-ascii?Q?wGIp0/49younJmZXXJwjSvhESIHMSl0Ta6AFu/iqkXz3B15/f94jPKyfbBoS?=
 =?us-ascii?Q?f5eb0Sd1W2pVdL1/0EuHBBOh34FQWZAzc7qlqZzxSDYO2GP10LFLzTsZu/f7?=
 =?us-ascii?Q?Boqh2Yfnh5J9QSjJSBSxHOKkONhWdxYc3WREE6/PiF9qVx36GjnH15QtTl+r?=
 =?us-ascii?Q?0hBLGnAGTpFEaxAtjsfvmbZP703Ps6uzg9EoXfRA6VC9wln3hFf+m4zVNVcJ?=
 =?us-ascii?Q?9EP9JwxpdRiDP2vKqWZe9zedUmLb5RbwX7zlDp4mHRI1IwRNBuMfpc5WIwxa?=
 =?us-ascii?Q?AYClYhxxi4gprqPYhR8Voe+bnrgQK9C2ijqGD6ZPCHs2EHKAbt7jvOdkcbq4?=
 =?us-ascii?Q?Q0CBq9oBVd6fZZWPoCyW7FmKEu4DAHMizvaen4+jfEhbnKMFHUvZl8A9Pnyo?=
 =?us-ascii?Q?yJUJMkncU+BNXh88I81yUVTiZcTHupn3rHsrYDzWJ0diANJgvqt9mEjDuiFG?=
 =?us-ascii?Q?rklDA2SR8qMsu//ph44S0KgQlSCgkrlNo4bnrNZgzzou4MCmbFL7kNhCJkBZ?=
 =?us-ascii?Q?RBA2U+McqYQHhUf23FWD6lsjd5O2oza4j+X0iU+KtGdqwqB4bZjG0AUQBgNK?=
 =?us-ascii?Q?X4za1wFjdF0+8FNKVh8ZUFKkqpcuduFmYlzWHO9e9/NHOF5EwxpUccWL7wJu?=
 =?us-ascii?Q?pJOFUiiPpOStMBKr3OKLFoXztEzRmBDk1s5mfJa4k93K2Ws4WUwURuazAg9M?=
 =?us-ascii?Q?tHTKeV7xeI7jL5FHKnzOIXvo6oQNeUqcjeSXqmMC/iGhUVkLoLM9KXFIzlCA?=
 =?us-ascii?Q?9okV736hh2cjmK6gIEBXos3djDuOMXxnAf4dBNo01EWKETv/x0UtgTsLrkoz?=
 =?us-ascii?Q?C3T0ATEkEWSMKl3qDyrIfTubssateokhPefH6WcNI4zfg/twkQnnl996KkVf?=
 =?us-ascii?Q?3wAeIQZHxn+aLF7zpt4ByDgjKAHJYe6aeEmigejcwzMXAuJ9C3kHgpLmux6/?=
 =?us-ascii?Q?HoBz0yO9zKL8oExpntMFma6wFumbmPK7dd28nqIMcMNL+DmBsW+YWb8cw96s?=
 =?us-ascii?Q?nRF3ojSGUM1n3TFyfeT5wfxhypod4z8SdURiMh0jOky/kt7+8hPVrXKoIv7K?=
 =?us-ascii?Q?FnV/TdqYO4l8+pstCKGJHwmIt6tT3OblLwF2yk+21iBGakZae5kGxuDoEpJ3?=
 =?us-ascii?Q?8beYgj4c+1xI4fXmWNR8pm4pfo9BdWolucLOTPPne5Aub5l42aTyFxPOSQ2b?=
 =?us-ascii?Q?0r6hU1Apdxx5+48avKyBzV51NSTy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ld8fWUZFWoxMSOW7y8s7I24HZME4ljMxUjmnlNK5NTrmmSC/RBsAyhFl6ot6?=
 =?us-ascii?Q?3kWHAjQ1BlLMQ2GvaHyi6KYfSjMFfXlfHOhZXUp79yLPSz5hxMRh63ID/JWH?=
 =?us-ascii?Q?qI6rENtUdQ4cMDg/rXadBb+qsa7FqhKUI9GgJV6PjjdUgbbdfn1+/rnkX5kX?=
 =?us-ascii?Q?FJAzgt8bOTZrYmfabWwXSIT87Y9IgqwllP8lB7JgpV1oM7LsSmwaJnE1UfPH?=
 =?us-ascii?Q?+dQOYSbFuEuXAZdHy8mEMa3TsGby6nbenUhvBTsTCldoN1Dq8m6/Shw8q0A8?=
 =?us-ascii?Q?b9BcV2QjPNrKfilNv8c3ujNcy01TzD1VnhP+OWozy/Vd5+9axDaW3DYPHkUe?=
 =?us-ascii?Q?/ge9uVuL4fl1uKNVLOuXjTIyy79CVpruQvQ6MTvH4D2BS7i5h6h3DRBjbk48?=
 =?us-ascii?Q?7Y9M8yE8YaIrlUBqKm/lwIj64N3mLi+m2RExvS2L9PquuOrjLGrxqM0omhUg?=
 =?us-ascii?Q?3rvzSK6h1JwSVhrh/w9/ZDHrLxCWJ0JJKk3LbPd/lji7VkSWXI4qYvbTFgiB?=
 =?us-ascii?Q?WhMaAEf+keeX0x3lIMmdCyzKgm4EAUIc/4CO+h3c1nj7OiyNbE5k87KKofdY?=
 =?us-ascii?Q?S4Rk6u1HIIFHYGj+VfHDv3ttnI9cg4BM7EyqSA3yryhk4vSyoC4oLNlVwT1r?=
 =?us-ascii?Q?hjmAaJKOKohmbreaHPchTFjzHgexzOtPp77Va+9aysHj2INTnuIkDeECgfYV?=
 =?us-ascii?Q?i6Hgab1ZBM6cH72KkJUyF+nZPgHvnaayTrpKhb39wfK0hM3qdxxEr1tQo0tx?=
 =?us-ascii?Q?w80E+sSnvaaQQ8OdimYk0jQpFE3sEM1BFMqJaYMws5l4Y/4m2LXuMdcy+6fd?=
 =?us-ascii?Q?vNIv2zPTMxKsy2Sv0RUeo5JoSR2NRyx5w4LMSSafIR8ytDNjtsPGi9IWI3L8?=
 =?us-ascii?Q?9Hxk0O5rvpinlkcnQNvuj4aCb0QjNCVtC3j1lwG3bXtjIh+DdyGbB6UwqCuf?=
 =?us-ascii?Q?vgLEvrh1W0i1IHL/g9UYoyoQn2Lf/qO9EfME9f1zQ7sdgYyTSXNSCdaGt/Jb?=
 =?us-ascii?Q?YlP80pKW5vW1U5kxVTkzBSRx9tqCgI3SSaFVjw0ucyHOjlvkZLRZu5QUahL2?=
 =?us-ascii?Q?A/mRAWHqTPxu/hgCZMt+40BLRH5crvxhKQSXTaWzucZP46ui96s4oy5V1CZ5?=
 =?us-ascii?Q?4TXvqTbRQLGLA6g3/dYD5ulo0jrJmtIkGLSz75uHICdEPHWsKKBSQQ9iC2im?=
 =?us-ascii?Q?cMl8Bpt50Q7ToJsk8UiMajLaXUCJBq4D6YXe73MC9Ug48n7JnBMXlP+8j3oI?=
 =?us-ascii?Q?L5kUb0C7yIzxadHEkWOwuzBxCC33wAeDjDQSzHDc9jqhD7nDwMU4YRScNVPX?=
 =?us-ascii?Q?UfpIjs5D/mdnZ15xAfV4qHMuPccSDJPIyL+VVOMZdIlRR1MzwqJvycfSMXhx?=
 =?us-ascii?Q?cQ5A7tDrZitIAlpPXPc5uMLeACQeLBaqdDGazgPmMibPl2Qg7Tnl3o1hQOAX?=
 =?us-ascii?Q?0+pNQJJHPWcXRGTJDMRtNBe1XxyRuN/r3xpcRuL6JJ/BE9P7TxFAqvbIkt5n?=
 =?us-ascii?Q?qSymuF4OHw+U372obzZw6jwsJIOyrpcwPI5MGv5p8BUZko3b7Q0bUQHpFxua?=
 =?us-ascii?Q?xaHmVyIlIEkrgIb/V96pIoiaDUMwnhLT05jlAaScOwbNdeb38onhpU4T+Xke?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gTeS5DsBIkTwsOl3KguN1QyL/iwdaGha/9bMVmT//qsR3F9JW0vD64EpK6kBuvKCZV26sxqNRGmSo4LurEO3hmCfBD9nouuUdt2RfuhWVKyUwqOEyjTFp/qHi3P+eFsisqttPq19xexzSMtwXTnR8EdEuC0c8Ef8PZl6oMQ9q2WxE35B+fn+EQ0Z2QqXVG6JzxMDWlQ/7O8XSkxkDrZAMQtIRNSyu7pFuDz2sdt79ZAHHgnQviQ/82tyoS5nwVQ0c0AGPFieBoXF0INsfn9++fwPT2mRYspe5piFwtVC787Dl3d3c8NPrcTPZiAJVIoq8IE8PV+JEDBIYP/MlVW9Rp+YFZ6O4+eqGITBOg28+fBYK+DmEt7/CXEkEZ9XHEz6FYvMDQZ638JYOXVPkcVAB9AXp+Iz6rBTEv01jlQK+a7bE2RRR0TyynUUu9/Ty2qLuYYq2jsohcBrCptGLMLTx5vjjvjE/gNs/DOppAiilt9pA5PwYyRihQzZLp6j3QfMquvCpbV3m2rwcLkCof2v207lJinqgYKw9OUMN7ekezxfPZMtPAaPpYIJLgk4CVdl0GyvRi4mACna7CKKYkDh6fvIazfxhdT9ERTU66OGDSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169c46b9-1dce-4e4f-3c27-08dd44a5f081
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 22:56:05.2791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kru9U93xmwErLxpf1D0v2K1L8apTECRHUHHN+VIVTe4oC6npfJ1fJ57x80SC3udlBKJc2mksvPUFVvH4jeooo+t461SPift5TJusfnPvwxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_10,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=895
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030167
X-Proofpoint-GUID: 6G65Fdj4utUYU3csvsYvV_0Qn7LmoOdq
X-Proofpoint-ORIG-GUID: 6G65Fdj4utUYU3csvsYvV_0Qn7LmoOdq


> mvs_phys_reset() was added in 2009's
> commit 20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change;
> bug fixes")
> but hasn't been used.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
