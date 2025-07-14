Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA54262FE3;
	Mon, 14 Jul 2025 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752511550; cv=fail; b=mTQ7BQvMvUjkfBsu75CnUzXYjVzjNz0qbqDPMvImkfL1lseHqlcRT93LGXUHygV4mBJaUwKLclzwNGg6YP7nXo3LzNtXExqEFldEWYENWh251bp7BeVN7mKojNpxxTYQzSfIR7Xy/ApO092H/Lke3m/IhTzI0NtgEPDjVpBTRqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752511550; c=relaxed/simple;
	bh=Hndz1q/a5ksMRntB5LgurIc5hc/nSS9wTODyDt4i5As=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=k3+KyesgemYqmVx9X5cPCbTD9TWdccfxKz8xe6R9S+AYDWQcgx7MOD8zkAnn1+RbM+gZvAR5YPNcm3oi+F23fo/NndqfeKFNwlGpnT0wk06IVpC5yx3ckpv/bIVq8saKdGjOmE5upl76p3i4i6nAyKMuVTyWDTwsEMt+mTPiDIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tdj33sHU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gpBl407B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tdj33sHU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gpBl407B"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGWLD0001302;
	Mon, 14 Jul 2025 16:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zpISdIHRWQbQ8D/6Su
	PfkVB4fbuZF8OJY5GKIJfjf1A=; b=Tdj33sHU4dmNPtWqgJ1v4jQxhmY5uYon+J
	NjnyJAcTBTDKmz4uXLRXfpmdIIc1NfpJ8rJKl0s2urk4dN2X0dtLi6g6F5HAyykd
	jW8h/YSALsB04mfAtIiIQWPHDqjLyciEHLGNGiBb2Y65wdULS26IHg8ekImKoPbq
	pwr7+GItDQsdkYIvXiGcFZ68EprGSOFk6arJO1qY3jtmNs5KxACQNr+ZYVBFZ3VI
	t2NW+YgnpII+4WFhqdoHrTBuahBEywGqnXjNcSgX/xWhKHhnsQ4aDbfzljzeMrun
	ZuIvFSU/kupTC+3JgY/8A9yQqsp23lY8cKp5pbIj6i2JsalsgZLQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk8fvnj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:45:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGHEq0024122;
	Mon, 14 Jul 2025 16:45:38 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012047.outbound.protection.outlook.com [40.93.200.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58rx34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c++0nOAcaXUPsLdEaXM6mIBu1vj/2RMH8NN57O/a9Tl+P5cAgrd2N1P8hFkpg0Q82hgSt2SqPcjlknROzIWfLAUY2pifX18StZbk2+T62SGxtnpX3ZS0gCSLb/4SKaGwACTip57zxXwGpZQcbuWbKIH6ejj3OSesjsMEyt8Uvs9UDqwSjARUpHtJBkV5BMry+tQ6sitajn8y8S6rGf3bDyPjNwhdvST0eUoEWOvSh/p4SP3TjvaJxpFYQ469hW2wqaQGoNZhOeq85gtQt4Bn2g0nBh+5oF70f6MHM3IiacTQo6EmTHRwaWWm8GgTPimAk1QUOnqxcPSUldB2mncbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpISdIHRWQbQ8D/6SuPfkVB4fbuZF8OJY5GKIJfjf1A=;
 b=t2/NHaSKBCvhjX5u2aPM8PpBqKSHJZ9SAaW9XZRi0sz9IYSgMajJ/yELh3txRkNj6V3PxbJf9Ben4OUKZQ5GnDCQImr7zFU5DSmUNl/+lEPZRmWEE8dEGtxIba0g1K5kPgcaf/aLi9HAihHRiZ/TZFsFxLOlk0q/R15MKcR8vcfKUoCv0R4hqe11qk9IZevJJHxtH/wa+Ayz8caNh8Q8vdXxRiT4/j8ZPlIJSlBin5J1NxsIWN9JihQRJRXs2vR8sKjXEfqrlbEagFApKy11LjXZPRxDFpZqFVySUJpF0Z0oGiTRXuIkO/8TKnOk25P1awM7YlYFXJh8P0n5t8284A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpISdIHRWQbQ8D/6SuPfkVB4fbuZF8OJY5GKIJfjf1A=;
 b=gpBl407B2YJybNc3acDSB1VSBCfgc14zb8AAIAYc27zKBOLCmgEcHJIyPgb+JasYRciE/3B3UFB8hTKY0A6YWu0tHkpeTKrB+YtFiq/J1EgkmvMydYtjdSzwYrO4q0mYhZJbDF/lWa6DS5MEwPFWPpAKtqrxEGkYuPyK66CfoOg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB6882.namprd10.prod.outlook.com (2603:10b6:610:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Mon, 14 Jul
 2025 16:45:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 16:45:33 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v4 0/3] libata-eh cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250714005454.35802-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Mon, 14 Jul 2025 09:54:51 +0900")
Organization: Oracle Corporation
Message-ID: <yq1y0sqafhm.fsf@ca-mkp.ca.oracle.com>
References: <20250714005454.35802-1-dlemoal@kernel.org>
Date: Mon, 14 Jul 2025 12:45:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb61a06-df51-4b9d-c40f-08ddc2f5d985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PihntGBTeIQelpn2GEWSNucXvkqXAKYuAt1kt2T1cGXZWpgKw34zuL6EUk9S?=
 =?us-ascii?Q?CXrp89odRrlRRR616VF8wM5WNceOb8UaoA8fujfThMA3fXxs32J0d8FfoVKy?=
 =?us-ascii?Q?TaItaI8yIysAShxZjBG9PxlJcjUPpB+S+NxKb5tIFHVAi4Y0kLxG/erlGAOO?=
 =?us-ascii?Q?1yC1Frn3C1Y1AWeL0R4TiYm2Pjzs/HldcCNBKGy1WByE7nhBUtc7WDzXwBAa?=
 =?us-ascii?Q?lPE7fGXdCnejKTOCUg67j7f3SF0zwXaV3FDHd+W65SvRFzoKvPkiY67MxiTP?=
 =?us-ascii?Q?Q5rVAxDV8uQ3H10pG7uiksIzJz3+4JGPGkrdZjp91bMOkN3KahPGca6ETQU7?=
 =?us-ascii?Q?9ELlXFGCFa23npz9L8ja4u2qCcbjgdmwiwyQ9KR8y7AH3zZGipJl0/mIy75y?=
 =?us-ascii?Q?KnjiZO6nlbG6ZR9fdRSGC2WW36XddqvCga9Lh7vaJKDC7APdSjRue7C5lhrB?=
 =?us-ascii?Q?sgoikuNvpPTT3ggaIx6Z29Ymsjf10rV0TKxPFWKTaG+SHqOpDrdFlyJAuEN3?=
 =?us-ascii?Q?Ne2KqWeBfzOMY+cM9LWE75hfNV69dEYzsLuscxOYUYXJ8jsZ1mfVdCzTfVcd?=
 =?us-ascii?Q?Kym1RA9iISXmhiLZ6KMA1QvT1bUs4NiyimeVdhgJuMLimKliYwojDkRC1iWL?=
 =?us-ascii?Q?AhbaKtc9OifnMhPWplEDAP1gApxh4NxTPnGma14n2xcul5ocflnoCv47k8PQ?=
 =?us-ascii?Q?cUc6IAdqJZfI20O57tKC1ecOD4wexeIFT3OQ5pdGmMDLLvoLF1yHWlKpNk05?=
 =?us-ascii?Q?3nsIaLdGlm9IGsRnJwlzSzt9bQfnJ+DQ2JxFYFJrf/pccZLLwoDydrnwdAOC?=
 =?us-ascii?Q?jBVWLYiDJvXSLtLdA/nMYc0ax0uyKMi4zeIdovJkL94CpRSgD3MGvyQBeL/Y?=
 =?us-ascii?Q?rTHO4tR5nMeVTj0qfl8XmTOdIGV15R05th+6FijxHzgKEYkr1v9yqoiokQ+1?=
 =?us-ascii?Q?ipveQA741Buw7Ntp0oLop8txMXoT5msEg6xrxGrfbxOMv41VPrFoEYfxyKHW?=
 =?us-ascii?Q?gsDhn9ePaZgLpI0rzZERwcQarbuDi791NFkLehyKFQOfVXp80autV9DcO5rJ?=
 =?us-ascii?Q?g7ekkrXqxQFuTUaJ3h6R7n9hepvDgaUZnVUSBr6cnuFxLbdCMh1eIAt0OFI2?=
 =?us-ascii?Q?w2RV55mN3+LgWxqPQ62VbSV2LtblwguEilqM7J3wjJDtluEY/DGq+v4yM2aZ?=
 =?us-ascii?Q?IEqCt6d/vVvdcsmTkFxLE68DQFFPJmS9oe7v7PSWw2m1jjcsKgC6yuo5qUXA?=
 =?us-ascii?Q?VX0mVzyNdXFf7bZd5tNeUnkX+ILOPUf6PH7ZzBUtrVN7k8NgRX79DQJ8k2gx?=
 =?us-ascii?Q?43HdXTQuaJCszv/6CPLE0kGiGWUdk0IaBw51Xd/YJiimqbxcvX3H3knr+uXe?=
 =?us-ascii?Q?f5jEr7F9LPzTkANs4NGgvbsm63BFzUVtIYiToLVzkp84I4I4Jlbzs/hPc4Di?=
 =?us-ascii?Q?WZSaS+/v+O8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H7KAt7CxqhpTcMqTfJxoSAXnXaX30LNpAbmFx5zgvo2pS10UfbHv4AeZiVqX?=
 =?us-ascii?Q?dF5ZgCiOaS2XhM9qG9Umq7HQYH0aAVsWxqM5oMZNik5LPAKX1ec+nKEooMMO?=
 =?us-ascii?Q?0DTdIpD2JgtZ/9MY9MRWojottAMKgkQQuNFmNH/K57Y3HqgSLUvc8Yt1M4xR?=
 =?us-ascii?Q?G9Kwknsnuna7piLNhZwpVGXsGoi2LkU+XrdpIOsGgmbyCTi7TUy1QXLLR+SJ?=
 =?us-ascii?Q?zSi+/+vQn7NSlJQWnHl+FD4uakIaocQVYNhO5TygHo7Snz1zODfGEXvtyxwT?=
 =?us-ascii?Q?7BLqzQQgBpQMFTfY5MMRL0yvwa+SqSOn8Zak2zl6rjwHFi0Ibj8LuTfG3k0g?=
 =?us-ascii?Q?kF5GZGA/xCR/RhBnobvVJwewlTLRqSPC27sepE102VijhsdOar601w9dDlko?=
 =?us-ascii?Q?HJBuP8g7k1odmyN8xWCUVp309G7Z2NfTK59DvP9Bd7fXDvM+mRd5DRVdEEN3?=
 =?us-ascii?Q?CyR8nE0PvomdAXFZcFtFbzdndgBf9ftXxEYTfo+TW/3wH53/pdFyCgcHwdnM?=
 =?us-ascii?Q?ziecT88SLEH4/QkqzbIL9puspHDXvIR1ZWt03QJ31+Z3povWbg6OxNhXyo5H?=
 =?us-ascii?Q?PYPzNDb/UDo6m5o64xTExuBGJTzdauRPteAxdom6dMPE0s3HAi+cPkffcCqh?=
 =?us-ascii?Q?wdmKpTS1jpUK3Cl09sIY+Uq9UN+LKZo0eT5JWbT++dh3hpbs/6tkU00L+N+Z?=
 =?us-ascii?Q?7ieUsAk/S2o0oTTB7G+hrjP/nWcT8VxT5wUUy2S2TqrsdxnxfeXdpLEJLD0L?=
 =?us-ascii?Q?C50e+5jdkrm7NKitOTZODDQDI1ZxBsN0CTMu1F5m9TvhkIoRYZJUOtQ1t1YW?=
 =?us-ascii?Q?N/UGGTlMYEGm55bGDO3KqqeiVzy1D5JNaSb/+LxdYonpW29gKZOs4Tq7PWvh?=
 =?us-ascii?Q?zlZzEuYGUBxTJV39n8ukTqgzpiZRs4a8UzfOP3DwFnwxoV99+WQxqLt5Rv/0?=
 =?us-ascii?Q?/LKVhFacbiNecQeq8X/BYN4jHnRI+czT0ZE8y6X2VYrVqWKOV8Xo9dJAKEXb?=
 =?us-ascii?Q?1zQppZsLQTRuOkSDHZngfwkWd5trgEu1SSa5wVUYOArIOsoWqEtEvpDLD98i?=
 =?us-ascii?Q?FTsqIL5ezJvpq+bYi/0Cc0w7cOn3uCLBEFe5e/k3OWDu5+5POqNpu3sE3pAc?=
 =?us-ascii?Q?M7anUEqqfqYVZKCA7KYpdQ7L7JYwyjrzzHh43TpybMJhujYihFos5tu0Nykz?=
 =?us-ascii?Q?iUTzHJcEMc3SjfgK5mwwNsEz/kWAsf/DYuyNDTAve5ibgYnZkZn/iKBXtR6I?=
 =?us-ascii?Q?Mju+/ZoP04QteEKiF9vQT7ahm8Q8KqdG5aFUQD+ckmSw+rfzJ0qvgwRXjdjn?=
 =?us-ascii?Q?2mNQcMSuza/8qXoSQOpGfoYyEvkyJREwmIqeqO7mOL/jHe7/9nu8jVXOG/st?=
 =?us-ascii?Q?zpy4nppY6VnvAfXIM1LvHIXnbIAvqD7BatVzGzkBtU5nUQrZH3F+/WX+ybYH?=
 =?us-ascii?Q?djOhgxT8GtS/q4dleD5Y83iT6trZedb+RYJO4eRa5Td+roN0FRgoBP52sGEt?=
 =?us-ascii?Q?uioghFJNNwALyEwWRc4sRHjBcITU0oel3yeNMdMToLQp7tjFUsFyDUZRB3/l?=
 =?us-ascii?Q?v/8l4zoT1mSGLM4OA6T80dNd6dhp4HjG9nf5bcgEY2kPAqyCb3817gIpIzgX?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JW0+MVISD+zbOtktkBtVv5r9so+ENEdO71pfvfv+pK+NbrAGnHC6suJosc2zlzK29uagTuPbVvxG42oVafDBlljXkUgW/rbSa+Ew5kBgqTkK2EzE9yFltI1dPF5eNBt35+H31bIo5/SY7TwZvOWYif25HuZjQko0sSYLNTQ5bcfdevar0wj2QSuF9Ov6U8B+10ogjpq1tUEOQz9vIsuZKHhSuFUuIiqswXLJGpM54WD2IKDRdglQNt4KEFOTsdrI9rQnSWfLjYmQdeBTlD8UmUGAnvhNpgcFQS4tzlvX6Z4jAud4D+yj0xQKFnP/TgcZKv2y5RHja7Szxipl83D5j5DNrirlXQ1ba0ANWdbnKXcdZ+sXrKYX5Xynw1ESSQw7opJKjGTZv1i8q0xEyWEvXSDzL71UHMqpv+PdVkZ8PsKPY6HjjXgGir79I6EsVOzaooQiC24qscNPTr8L9Rr7r4W35C8waHOW6onG6znmvsqpE2kVQUmkjNZcSdi6BDh6b696ojivbVG86uLFUkB86TWAFni9l4dHNYgpLg6QRgD0CYKjbseBfaytxi29c3n31JHuUBHgKOicahNFSW905V3CF4c/FE/i3l/KDIy70hk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb61a06-df51-4b9d-c40f-08ddc2f5d985
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 16:45:33.1568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6dUFDKWJGgdc18B7aFStXhHXeT5pG+PzGS0IqlznJ0KcNAuUn41eF8Wpjxy+UCg8TE0chPgm+0uTXVc3Xhz9DbeUPpirimt7vbvTNnc0F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140103
X-Proofpoint-ORIG-GUID: Hm9oA8z3uFfLGT1cESa_CZHsAz1WcuAU
X-Authority-Analysis: v=2.4 cv=Of+YDgTY c=1 sm=1 tr=0 ts=68753433 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=HIqYLi6bH4wSzu-pdpEA:9 a=MTAcVbZMd_8A:10
X-Proofpoint-GUID: Hm9oA8z3uFfLGT1cESa_CZHsAz1WcuAU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwMyBTYWx0ZWRfX5HCZyTZPq13v yY5vdvuqWvrhoZZlSJfkF+xoidqIgpXgnWzbRh+A6jgK/iXXP1CJEuhbPcBpNBI7X5Osj3YFYLt zEErbE1iCkuLJ2F0VwqfspOVcR2zcZMVV/lsYBOx8WXgegsTpPqjVge6zN7eq4i4T15JRomZ9gF
 6K/PffVHY8JzySV/XTavA1sM9wbmrFa9pH9JTuEY0qK8e5rrB+5PJJclu3bIk9i2CkkBpNlUR2l wpgFd/5j3GOZL44aS6Nr4KZTKZ4CrirMgHwxk4g9MReMmt0bBx638r+W5d4fpWdO+54XVsfUc2H EQYnk2gjFPbkdtIJdUMk3BDIKlvTNxTuUDFtGhWRxZvAb6Vdl5UJ4cHnZAoUeg4JjMz0YXSH/Ic
 c+rjYPXGvTd5KlnEgQYpv9dNrANiGhO6YtrX6/BBXyzaKXbompAcUaFEffMcHnuU92wfx3/y


Damien,

> 3 patches to cleanup libata-eh code and its documentation.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
