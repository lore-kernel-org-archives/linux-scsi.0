Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84633DDDC4;
	Fri,  3 Jul 2026 10:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074767; cv=fail; b=MCf1E6vWcfdUV04J3D7wUvDwuRs1Rkc8tHNk7gCvgOyacGyW8Qp57c/91ZZLBW6tH+2Sctao1RMkRPrwDX1c9f+tdBPpQkFujhkMw3G8chI20ZI38KqxaD5KAhJlJO99L7ohbA93b4Dpn/2krZ0AUHDbG1poR1ET4fB69gD2AQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074767; c=relaxed/simple;
	bh=nUIYtTfG8SS33YNnSgjQBRZeOHyEXH6eHFO7INGt+uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pz7LPzZTfR3RSzAOmBd+G9OdVcq3JzcQH3t4lz2mAMdWzXJ23qIBYzT+BmzJJYSVLH8WsiW6nFNUSvNLArg2BTJKAOWFEK6D5gOUxcNVSOiaH8b+ZHSy5tNrZgAvbjFLa4ox8QGleQdI1SpXQ2JNonhD4KPdmeKmQ1UVrdlEar4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gc5cqClB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nCIK4tVe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gc5cqClB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nCIK4tVe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tiw13112789;
	Fri, 3 Jul 2026 10:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fhKueYuRga8AMhIOJ6TUR7UxVNfVYfGgi1Zo87LHU/I=; b=
	gc5cqClBYomrsljSHfoAkGE1kyC+iXjJGbgGyFbvn3MwQNQpiWvyPSERXtpZ1l/L
	ZrP1VQnFHEY0VnitpLRtMtWqvDPcUmEgno+uc1fOBdhk4w6/t7W7DuqGonLjIIz3
	nws6OYLWBUiir2mpJb+46UWwnwjGlbZgftfMJuMOTp1oSggsNDnAazmADk3YMuQh
	Hc0i6MhcQ/4wXfGtTigiEARIYBMZXSNyVunG7ACE9kQHkPv3kk15xTiYSHogvBqC
	UZuAVx8Xu5vY3sXB071U6nkTkNOmrwjTvKHANDU2OX4a6epWITgA01hjodH2EjS1
	nnbzvRgeb+b3tqcKuoBVhw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfjemp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7gC013121;
	Fri, 3 Jul 2026 10:32:22 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvrrk-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uae5q3dEOocY97wRBpM4pZYa2ucVk/wSQhWoSoRcgSt0NngWkhRWGKTpxHSjsQHvYzrxb3wCZQVRt19XNQJS9zs0zagQQJG9gGsQIsDPAVbAFJB1PTyRG3yYbNpkFywtLpTkuGBwy6CEC6eTEDif8i6y/67OQkYMMFA0LU5QskLV8DeeipjBhVINyY0K+cmu1XjNZNtS9IvPhUTEYBK/G5aIfTRbn8a8pRxI9E3qxy1uSQxN1JVP3tsym6rpWv7z992iy0wvL2FocX9QjrSsG/K7gYtlmTfcOVoytayEexTu5njSu9jP+lY49+lkgPQU5FEQTH3EqcK2pRokbYMXtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhKueYuRga8AMhIOJ6TUR7UxVNfVYfGgi1Zo87LHU/I=;
 b=c9sSlioMcmihI2mwoVSdbIbMenWpY2PXOeEGSQ7WLI9xN8cfuUogCggtZ9xnnxWRlx6CQPQV9Gt7y6l/mkUnqcjx0ObgbzTxc+U/+TImgQq3en0GF0xddNHLJlLVbcwZ7dOoFXfud+3y9YgXYE8tNiO1UMS5aH7cD/43Ojg9SKj4AXmfCBQmfh7BAUWHBQ9OXAIfoV1PjPaTSFIretrQoSgKYXST3nuQwMOMPu1UAZOsznfNleWlylD8lWKXziwk/c5Ou/U1kpqhmEs9WkTRZDOlWG5hO0/iddkGC5WcuhZKP2xVibflwW0M3UxSC9SDvNYsSjoXcc64L3Tp4xjr9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhKueYuRga8AMhIOJ6TUR7UxVNfVYfGgi1Zo87LHU/I=;
 b=nCIK4tVe9YeyymW/6hWz2/ZdgT6LHyDqHd5Wta6ciP4Mr+oWo7E0HzG1o5eSLb7kXjT8gRZVwr+NhkS4obWaQhjVmHDfzQRMf28I2YDcTdeTCQYXRq1XFEE3dJlv3jf/lHAIgI025VSaYjU0RHnOa9RiB89UTEPQciVM5m3WSfA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:18 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 03/10] nvme-multipath: add nvme_mpath_{add, remove}_cdev()
Date: Fri,  3 Jul 2026 10:31:57 +0000
Message-ID: <20260703103204.3724406-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:8:456::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 3498660d-adab-4d94-7bb1-08ded8ee5b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	JYv8AXKBGNGoW4aiiHQrBiyR2mgUBqsshhdHU85eRhQDM1lKo344TU8SUGNV9TlZdpbhUOQ1sjfOZAnedQOYROLM3S3iUOp1n0nbhKFpcip9OodTmT9NOmkDPDyVLM4e1RZ4uljvJgbagFmVTzKzDr4AgFCMuYk7zxkF1C1ZiA57a0IDx7qknFlfql7Pd8qTu/Z3mOPJmeWnm05mGuwc8pFbTt+5OnW4fHLMsL/5IztZSLuqEFCQqIa1PQd+FT8TqDUuX5xl1gImTht9jBNq+lGDfHhvfiEUfKcY5UyqASsEkQrQeCxDLMsH+ujEN3ZQUqaGFg023U/TVcMYQXIQYL9AlqtrUQyD3YDf4/YzWQ0Kb6mpCmy0LS7/5b2uijpJN9dNq+mDjhBGy0vGvLfapgTq9VTSQ1T4y97w04nj+FRHApfxlYeZzrt+us+Wr/IVElJKW6PUpR1A3nXJHST0nN4Xw95XBEsmJp4KlzRHIZEhsHqOIuKdP9pzfR+HZHBNzAPsR7rieO0bzK/RCvisWcqI9NjeQ0jtB+ECY2R6fnyDRY1YNL/ad48dXwiToGUo4wziJc6YZczSzDSq+YrAphlJusV3Ez2r0DfMn72FG3ZYjpj+k3wAotATfFWvL/HqLHmPpd19rQsulf8O0dZ2bBMEtyG/0bre+J7R774k8hE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fi71jF2JtDZwIYF1umRawaZMNPujBSVSFO9Z9TLA5p7HpVtCBqGasB0Umcgn?=
 =?us-ascii?Q?MUqhB3Q8cXoleTmm0gP+mqBGlx7rWkDKnZi5L8L0MZccX8+nXJa28hAhEXT2?=
 =?us-ascii?Q?dBmaL2RyxrMGuVf/x6YYEusjtdc+suvWfJoo6cEl9XHKRuypDTS1uRF8PWPO?=
 =?us-ascii?Q?3zNih5QOwLC+CM19UQlptz/5g8Kt7yajWFZGim4LJKWl1o5kvUc7rKIZb67x?=
 =?us-ascii?Q?3igiGj1EWGrQP+blwXoj52qkWy1GQN4DxqJBWumgBHQHmNQVnYm+Cpnc3Ngw?=
 =?us-ascii?Q?HnmBN5/5BjqiWZeuNoi/UpUotXbSaEij0MhdaRcfw/HOx3XPrQmX2gS5XWf9?=
 =?us-ascii?Q?2lAaA1crzUrhyVfWD0xzb6AK9GWAMtNaiudISwg9YeU0G53pecpwmO5kbJoR?=
 =?us-ascii?Q?N6AM/Tg63TWDDrKzh4IqQNnr7NXsofXd0GoGvuuHLKY2kS/TLE7herPI4f9p?=
 =?us-ascii?Q?JzryxzNb5/al8j4NwzoADDEZlXKdIZpZyX/rsVPR1lcSox/ibXAOsfqmbWhB?=
 =?us-ascii?Q?Nyto1Cqx5kTgUTqL84cCtooha/4UHWqmAlyyuIe1r/OqjRtthXH0YbYWRBpV?=
 =?us-ascii?Q?tvxSRwDl3thmzXY6rtO40qkUVBNFPzV59r5iKxUoa3ITbkhkVkMb8tTYKmTx?=
 =?us-ascii?Q?LTF6Vr9wD7Q/6YsG6qLl63GDkEFeAVZvw8Bh3OsE4RNQZ1U4LTOct7fPRDOf?=
 =?us-ascii?Q?J88oklXT1yriMIy0xWZS7gzaqv5PgYkbuyX/978rQ3opjssPmDkYyCP4BWcW?=
 =?us-ascii?Q?npq7SJFnKHhUbwHAjzjrSSqk5cZSDj6qjk7bowBe3wzCK3U9PNwIW5CFyO5d?=
 =?us-ascii?Q?Tdp4ROozsb67IMWIRJQ6tbK1noXg8ZxIQ7uscAEG9NhWFDRhOosqY3XV3wo7?=
 =?us-ascii?Q?ZW67DPvph4Gw6Et3fPaC6S2Iq6nb7s83ZpAGbsYDfcj1C4rYmEQRSZReZ5pQ?=
 =?us-ascii?Q?jppTchzza77+MWL7dBLTnCObarLWmxvtiYdQkKV/RaNoCDo1lJzMGmB+0+ah?=
 =?us-ascii?Q?OFvwLoeL3U6JtrIzobki33YqIUxyArtEj3jfs/WgKGulNG9W4yC7DOTt9Cvp?=
 =?us-ascii?Q?45vnZgWikSaFclwyj8gA3vmG7ZycR3RMtxEbsDN3ZfBwyDKBM+T5o+gIE5iI?=
 =?us-ascii?Q?vGdsWqdlD0689v+NApDstwXXAidMzlwRpbQnQUBG3QRFCe/XLmJhSBJ2OLwa?=
 =?us-ascii?Q?Zddhnd1pqk5tJpQu1i9lj6vfuiob7X5CvSLqdNb1mgqgvLvF4grXpQTKwfgO?=
 =?us-ascii?Q?MsjB+Y/1xSdG+pz5oFQvodxQf+EwmCCu1vteSvFzVTlqqmNvYXDHNlKzuBNO?=
 =?us-ascii?Q?wIety+VPVDszRKcqmwzDVuMelnRvpzKtXO069yMrln11rEPb6U08hRxQbDnJ?=
 =?us-ascii?Q?/Uk8GtO5SxIVEXlEqApRrexebPi5vbq6fggBOWn7K/Fh4EMNJebszKaLOqK3?=
 =?us-ascii?Q?HidUIAUuIIulmvdODgHQ2jWc3VD4jBxJ2M7RUFGyjtWCAG1KpOx1gpljstXo?=
 =?us-ascii?Q?kDMKcTOGs7YOmCe6FSXcXCcK5IeOjHGF+kKRqWxC4dZxP5tVirJtxn94U2Gx?=
 =?us-ascii?Q?+0ug0Tr68hbGNoe2uWM7cnl80/lE4kjyd5Mzbqt/m6UkLXcDIN/kYF8Uf0Rw?=
 =?us-ascii?Q?cyndQPwIS02G7KgYS79i2i8DGOEQuXH1K9sHMKyKfPOJ98FrdJZML7EYs6+7?=
 =?us-ascii?Q?UV22y5nTTO4QxhwIiLTaPZ31MIG+8U0rIn/DAeVPgIEv1N1dC8NUnZXYmmVz?=
 =?us-ascii?Q?+1X4OoEdwKi4XJpvT4mThOcGWtoNahE=3D?=
X-Exchange-RoutingPolicyChecked:
	S2aq17FqSgEdWMzpRmhpQ8a7o96H7QC7xDLS6+IfKheasmoMdcMGMddjeGBcfQZrKOTKfYU7zEUrb0gB7np76Q+3z/uYLm+dx7JG0EiSXj9WgzLrcLDrDY1N9hut+htWaWSzU2ZOzqK4Q1MgTgs1pUgEbXJOjHK5W2hiwuNj7unuS6e/3iL+XWJBXGr6+XvGU2Ft9ShKjaTyigJqy+FjZyls/aXWMKSJsjNdk5hb48IU4NpAhMFIwqA5HogIiUHzzUaIehLqmk6cycDqEWxYYYmdXLQNbK7G80Cp8uXJdZXUfeyICrdaGIYMkYExr1S93JuoNvOhE+NIqougJY+28A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DsKZL3PyevDnkdF3ZAtwHDToplNw69P8C6xMh0UWp9Zvysip0XCKNmczxsySgyO+Qjs1fJvP/CErFADcgO+5jWD2fGed3daL1ZZcPcAFIY0QVrp+RIN+gkOq3C+I5LC+9YgDYJC7nQUb0vF/bletVtokBbCFVy+mwExEuYVyOjWuXxXoRJYfAfc0+SjCsE9No2cga0lHijYmIcxmH27G3UvvgkpgXt39i4NsAeTZvYWRU5M0MejkxBQTTBB4Z7i/fZpjuVjLrrt/vllJFCddWpN7Waktzma9gtRx1uEL7tEaO3lZJZWgUJOcN54WvVSvtAoqRZaqV7+0W1hyTjkZVEb7yJyJhKqn5r1KgZkxoOWkGYK8FS206i+g8PbUUlzxzyY9oqSigwf/hXzyq4ZfAhb7BxBF5M2NzwHq0AOvR6nazOYbwEXfnLmQ+qtmTL1eyRaiwVMieN2GhJpeiHWqMn04PqhuXes9k1xUVVDYikxnXg1R7J01j3c/KoNYpAMVEmatlOTQsAoeMbaRp6rOdDQdeU2M92gVsGTQq+OSQmlKmrhg3Q2eAjkap10a9dQoWumDHs8yjbCYl1KKuV0ukXkT6B+740RTVn6sWcG0rJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3498660d-adab-4d94-7bb1-08ded8ee5b1f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:17.8350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1NyqmoLwHaNCtYbE5kuAEnA2Yqlmx7Z126TSoJtTCx7kHsyYO8Zu9AzG79yI+2H6gCQANg8ylc9lz3sG0j3ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX1kUdpJkSnpxT
 B4EvGwOPS4FTp4KzWQJysAuOqBzSjyNqj50HOVEtrh2SYgHrPm2+EbzeqO2TJxgW82+73F+ImeJ
 dAJNwfrmZJXoFRmneyOldTjFxoRJ7U6VpDdXepDnyNjDtD35iGaQ
X-Proofpoint-ORIG-GUID: qE51UgK-qSjaXyJ9phBGxeRQr7vVZRKk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4MqZ+aE1jtXd
 n70HxBJGZe+fJqX+ZrrtcsU0cTf2K2qOp6AyUBGmZ+ZbgO9NhiLHpUgnJnb4JwcjJX/hxcx87ZB
 jva/s1X6g9GiwBshX0LE8fLvfxz0P2YwxRTnXdKsVD9UZm4nkbFu1DGUn+gYUQM8EXa+KKDfYVQ
 PSDZ5nXDOmaey/ymed3sieHg9uN7jlsyy47VVLoZ9RCo3TnSCJgsTZqnvLr/2I3Ype6hzwJK1Vj
 pJj5zgJwMKijsjPD8ogOpd8Zab7MEr09iWAHzmZj+uqNo9uJ3Jqu96T7t7MmgQrH66G476c+g+D
 4+JHwkI9TtqX1wn1x8DRSVuCmFKAoD+4BVdkxPCMKiAtvrYMX/afehARGSWECSMKB7XDULMZkJh
 BSeSypd5MOikVeb5Q6q7lPy4izeKS3bJ6ZMs57hf8JWazpWQ4DhM0AE7oyve00s1uZYLqbNbAfH
 qYBlnCkSR3LownbgxCA==
X-Proofpoint-GUID: qE51UgK-qSjaXyJ9phBGxeRQr7vVZRKk
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a478fb7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=EAMheBPNnCmY8Nf3qIMA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

These are for mpath_head_template.add_cdev+del_cdev callbacks.

Currently the same functionality is in nvme_add_ns_head_cdev() and
nvme_cdev_del().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 14c4370f7303f..e0573ca71ec60 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -630,6 +630,24 @@ const struct block_device_operations nvme_ns_head_ops = {
 	.pr_ops		= &nvme_pr_ops,
 };
 
+static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
+{
+	struct nvme_ns_head *head = nvme_mpath_to_ns_head(mpath_head);
+	char name[32];
+
+	head->cdev_device.parent = &head->subsys->dev;
+	snprintf(name, sizeof(name), "ng%dn%d", head->subsys->instance,
+		 head->instance);
+
+	return nvme_cdev_add(name, &mpath_head->cdev, &mpath_head->cdev_device,
+			&mpath_chr_fops, THIS_MODULE);
+}
+
+static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
+{
+	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
+}
+
 static inline struct nvme_ns_head *cdev_to_ns_head(struct cdev *cdev)
 {
 	return container_of(cdev, struct nvme_ns_head, cdev);
@@ -1519,4 +1537,6 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 __maybe_unused
 static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
+	.add_cdev = nvme_mpath_add_cdev,
+	.del_cdev = nvme_mpath_del_cdev,
 };
-- 
2.43.7

