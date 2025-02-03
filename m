Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3006D213245;
	Mon,  3 Feb 2025 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738623947; cv=fail; b=fjCf8ivOIWJRmPNEv+/XTKuIL5f13XB/z2QGXh4t17Gyi0I5jtY/oW3Ovm9+DE3Qmjz3t3ToZexZ8Byh/eWs8U9RFLpTF5RbmRckziWuMkCzher8142+XcImkqPsrabcKV/sPN3VqAfIB4u355IR1UWYp6IC3qe7BW2fM1CmX6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738623947; c=relaxed/simple;
	bh=3/jhr0uIcxLzcuXa8PMj0zd+S3Js4GD7JMVG7fX0c7Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pBritjEruPtvOA0akK5WubV227yQN/7oJ/Dp7JdUdSr8sOA9/SH7cexsNhCkCg6IemcUAm6kp394C4LdXVIGWO5tOHZTVq3ALUit6TpMKdeeq3f7KNZcz4fi6iNEqxi+zUkjSzMH+j/ckXFVq77LCjYhTNXCAaLQffoddbLrTs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UFOCJ9+X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a/V7fk5w; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UFOCJ9+X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a/V7fk5w"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMt9W001035;
	Mon, 3 Feb 2025 23:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=J1LPqlviTIyJM9PV4B
	s8OfiN3MWfnfVv+LZbZ5QpK0Q=; b=UFOCJ9+XFarlZNB34oz0gd1mSMxlCW2v75
	5GkD32x5idJnBqG/ePK2l3E20Bu6hDRDD6zNTdKZyq2ptVnbNY8SHDxTwvlMXab1
	+k7Hd7AL2WA5PSGkfBWCzKaZM3p93WN1MjRp+wCLL42YeeL2IaUgbq/rHSAjNcW1
	w4emjf6PLF1WrsvM73thEuA/noOj4KKOoBg6GhGNILfGnGuEtoaxwQkRoMBb2TNH
	oSUXJkKxe3n6vTHruiy6mWs7+OcaSUcmRzp4BpP8Nm1L/kNUeoCbmx+ZCUCAbN6n
	c7YLD8dONUeZlaN69SBMTcZn51gF9KmI2le61d5/MMwjLSrcjZrw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhjtur57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 23:05:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513LP9C0030945;
	Mon, 3 Feb 2025 23:05:35 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8dkhhdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 23:05:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3UUycILIinXU4wcIg2xuaqIcT9rQa42HwZNO/K2Z9HVp7Z1JRBQBNwTUJtfUc97r9s0TnIi7Lq+4UPbTet5cjG5eFjTuPq2cBcH6IQEMXKayda1T/+Ji+b+ddjGgAa0zbNQsUEFF6reQHrCeeS3uTaYOf/j5EYz7Q0gOclYIaeHtxUqLEm0c95DFPIwdSQP6KWchDOHdaUx8rOmId3v0oVKwBb3KLGMq+NXGwDLNeXF1tD9uMB8zPbxrpGjW7y5+2SjRr20nH6Au3iCC1soFSWFuHAa4MmimRau6kev8i/CKD0iCoHEOxW3FMuZAPK8j5ttnBavI3QZuzpfr0labw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1LPqlviTIyJM9PV4Bs8OfiN3MWfnfVv+LZbZ5QpK0Q=;
 b=n3D0UkSk/7MtDT+mXn64BArcpHu4OkwMzK1waiUZlvIVJemB95utSFr9JVG91n3EfZGK5V6f2GkVxiM5kuAxYbPhRTObfN0tKwEXh43xesd6AlyaKkNSSjVwxDpLd8f92Gb6nMEisr4HLFRH0VjySNEM/ZIiEZg4wqxW5dImKWJFMxUNlqX3Khl0jteNlB62oWjZuMHGuHSqdKMHlPAzVyJKSaltn5ly944zpDp1f/KNFF4BFca0vANBsbF4VPUr6yUb3cbnjT6cUcCLjHVXi3IrHHhHrZl8wDgNQz63Aba13vTTioALVxqLyVmKJkeWr3GC/nQmZ6N3/NGFVK/6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1LPqlviTIyJM9PV4Bs8OfiN3MWfnfVv+LZbZ5QpK0Q=;
 b=a/V7fk5w8c7lfwM7ij0HliLLk5D+JJBVWOjBVdxvHjBR9hZWOjLN9NZcNrlw8YYvovgN5Z8oC866DrME66hjt+TDRB6xXLihHSHJOOvUdPBZgYJBMZyXW+yT8PYb2H+cjQ8bKYOqOCPzxyToWQfCrxhIN3PXKyfMeC3txAEcMXU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.23; Mon, 3 Feb
 2025 23:05:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 23:05:33 +0000
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com,
        ukrishn@linux.ibm.com, clombard@linux.ibm.com, vaibhav@linux.ibm.com
Subject: Re: [PATCH v2 1/2] cxlflash: Remove driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250203072801.365551-2-ajd@linux.ibm.com> (Andrew Donnellan's
	message of "Mon, 3 Feb 2025 18:27:59 +1100")
Organization: Oracle Corporation
Message-ID: <yq1y0ymfx3v.fsf@ca-mkp.ca.oracle.com>
References: <20250203072801.365551-1-ajd@linux.ibm.com>
	<20250203072801.365551-2-ajd@linux.ibm.com>
Date: Mon, 03 Feb 2025 18:05:31 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:408:ac::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW6PR10MB7660:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e6e79f5-a107-4e28-fa46-08dd44a742db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?inlS0OW+uOJGNUOqZy21govqcoEaIuka/79rZ70XPtMk2vFDuvjILddnQuf/?=
 =?us-ascii?Q?cfzsBya0lm/XPL3FvFqROEpL63dDjgZxbl7IDsIhmrxvpaDnG6SzRbm2ykJQ?=
 =?us-ascii?Q?w9jVRVQFwm0TWtZXNR/q4HN8ENlsPdubkDVER7GoYrX88+82PWjQJmm/tIOD?=
 =?us-ascii?Q?h127QIP8ouxmvX+BLLBouIO3ec2ZdSZSCm1XRJ+oVvfnMc+ipeB0s04KD9Pg?=
 =?us-ascii?Q?tIx5X2o1GdcpKhIOhI53E6ntCIIeAoQ2a9CXgL0ySLBdHpCHztggMsWlJsJv?=
 =?us-ascii?Q?5f2y+M5IW3GQz4G8v3K0zxFgcXKATFn4fynkdpVhKDy4pA4G/UfNPUTtpoGR?=
 =?us-ascii?Q?M5AEIWXjVWaHKlSyAkUSssq7rkIYK4edg3FcIM/uCjVaQA3AvZQy3AIFBC2a?=
 =?us-ascii?Q?XM4ueTJ9Z2dQUZvGq/HvjlgwG+SmYSAMhzih4fnQiPIRMVEKtUWFp6YDKWpF?=
 =?us-ascii?Q?FruLQOrKoZSlxE7bS9OfRPcyJGC1XT55vyDSvQBsDe7AxGR3YkysSeWQFe1o?=
 =?us-ascii?Q?YsM/Oft5qevXkzytSltUiA/IIj3suqw6W0qKmYY0qnWZznQhfMmbxb/vAEzE?=
 =?us-ascii?Q?J3wLjTcG/iWoN+bxpkTVVPSb3UZyjiMJVITLCUZpjk2MVihXOaVbSWkrmlag?=
 =?us-ascii?Q?C9V5NpCbW7AnjLwcrm+9OZPFEOrtok+y1idNPv1pc3VREw7F8EVbzB1l5sbj?=
 =?us-ascii?Q?uTRI0z1Q+fMhu84pyFJr89CF32UMyUSKNesHXiyR8rv0mc7NH9oIQodR5A8z?=
 =?us-ascii?Q?LVMJBBYK29fVty8HMV0Z1Bj6mNxvWbli3F8mhNBamp+ZVIjTtC5zXYdroA9e?=
 =?us-ascii?Q?Afxzl0kBD10a/rh5+N58diffCXd4L7iWOMmgVTrur7QfQX63tt0glVbC1bAF?=
 =?us-ascii?Q?uRVQzLs68lth0D89ZoXPjVJMNJHzSJ0cfZkTlleEcKfMp1FBOcKYle7Q4L/B?=
 =?us-ascii?Q?QZljpTbmydmYEmEkTMOuWIkXdSMie1CEsUImDCv2TAWmPPru3gM0Qn/TsEYS?=
 =?us-ascii?Q?bbbr92gK8JOK74wGncglIisovuQGT8hb4cdfUGGpG8q7mc9TxU8ak+D1ZDbY?=
 =?us-ascii?Q?h8IbsjOdJVXdpqSRWu5FHmeJ1F6ViMQMaA5NA+u5yWmlI2BbOmfrkPr2OZ2F?=
 =?us-ascii?Q?9AUoXcFW7fOajGjb498Jb1YJzS+c7SFHxpojFW3/yMIi6NQ8mXT0wox+vWy0?=
 =?us-ascii?Q?EargiJyEvS9zpFwdzvSimregTZSVyzIBMgbIK1kcssbIPWaRhOL3HBf0qEJX?=
 =?us-ascii?Q?uVKRE6tls4evyqijUEludEWiNhCzxbZv4S2DBJY/aThYYzviCpCRDG+U+ilF?=
 =?us-ascii?Q?5vKU5+lekmOz5+7rCwiIoy2vkQXAtNpzYG3LfacNaCZy09xQxSW5mHvhFBjd?=
 =?us-ascii?Q?shvVIvjp1ruFag+Iw36V083D2SFN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BRf1kZwCHaL/3UTUxlItHT6GDbTZMUpqGJWrF9AAKJJ6zgJJFNKw2XsnNzmX?=
 =?us-ascii?Q?9ohU1XnHO99YmK9n8veA3Az0ZTmzYld7n8Xk1F+dhTSnr8cv0j0IkX4CQQzX?=
 =?us-ascii?Q?xtGLwZY5fZfwuE6pPHpnBZu+yW4fz4HFMW6mbuRylNWk1ToYAT4aQsCJTXKt?=
 =?us-ascii?Q?LQs3rgoLM8mOR2nEQOPioQo4nDgcwrMlN0rNX5SygctDGVt7RVuiNc9SK9js?=
 =?us-ascii?Q?oiiogE1ZwR0J56jWAfNRtO9usFnhUd/d7VmLbAuTsa0P9KYXXuv44qf3aRJK?=
 =?us-ascii?Q?spadc06iD0rLvzCT7S2CdMjGCGnXSjnEBF8EY+Gc2sU6niKnUI/SD2xQNhSE?=
 =?us-ascii?Q?3Vr5Er+hjPdcuqxZp2xcAZqQsmc+SV2IZU8KCnFbrWOjsUuy9y7ShsVqk2BZ?=
 =?us-ascii?Q?qsB3mWD4cLoqVjO9QX+SseoDx29tzuS2LT0HieAwQ2A52zDh7tkFCtbrUmLk?=
 =?us-ascii?Q?cAUGyvrBUi574NtW88QRgE1dGl0+H4piEMB9tYiybU1dIAMJ1p9xXgC5GRRD?=
 =?us-ascii?Q?zlox/0kw69BI8lNBBIpLdD4lyVtfG9BH3CA7qzlQmaS4cBLOLsIEzK9PTm3E?=
 =?us-ascii?Q?512tMg9dPuoAvfNEA6MF//dQZXU1Lw9zIDszHTYIJtS7oEdNzZrz4uQhDEvD?=
 =?us-ascii?Q?925jzMfcVsjH7RVOd709wTYZzuGRkDtA064L8xuBObNFyOio/CDE9TaPb8Wp?=
 =?us-ascii?Q?o2z6jgC00AkbUscf+vlA9JtS3PuAs7jCYfuBm6yAKcuhc6ePeXBSG8O59u3e?=
 =?us-ascii?Q?yxmqhWjR6IsejlDz0xokN3eHCYg2NrBJ6yEB/SxTKvAxj3OtMhWc5NZCJZoh?=
 =?us-ascii?Q?69i7ZKoau9kRJymOsNuv6WMf+W04SPn+w+Nk3ZbCGTEh15AEU5fNxKDIa2Uv?=
 =?us-ascii?Q?XCy3Jfj1POZOHuPgljI7n0eeVIBqklDLCGF8M9MZJ4UG+QhSV8nPQ/rm5kvk?=
 =?us-ascii?Q?ydkb2jV0ty2oNPlk/SSCzcBCgujBFolOyFgL6VFGrvrXpdXRZRju+FENZ2Qd?=
 =?us-ascii?Q?mDu4WoqE6cTJ+5I7zPSZ+oxWmEw05Rja9xcLA3h3YWH1Q2teVbXQpNiDkLzW?=
 =?us-ascii?Q?+OaCf2UpSuXYzQeq4oowGmUQLgl/eL6aOj9haQphpcmcY5CvRElrfHftOSu2?=
 =?us-ascii?Q?QltVzbboygiNpg6WNJr06ixU//1o/ZrW0TrfyDe5u4tGtOeC/OYWLiAkJlRW?=
 =?us-ascii?Q?ebg/RUCdnOtOmadhpxIAUsBTE+TrKWDVnAtK42GWLGJoI7zIMPW9d4nRi0S1?=
 =?us-ascii?Q?Hj5h88S61Jwv1XTJ3nSmOizQoLOeWZgTK2x6nFedoummz4VThkUwhsj8dQ0H?=
 =?us-ascii?Q?B9ixX7INZwhkC8prTkN7WU74rtg+R0Am2gbIL/VEFH32Wo7DEGBRrsLxXFHJ?=
 =?us-ascii?Q?iP9kJePvz1jRrtrfpVYbDsxtP28CCk09yPmBlHDOoZGoEscziwusbnOLR58l?=
 =?us-ascii?Q?hDnAwL25/vrVdKa7XPrxPBChajAk2sc+wuPkxYUI3VU3WYSozPjPGZXMzfFP?=
 =?us-ascii?Q?fx90tXXlCleJXlIs35ttn/mg4874EbNRM0tkKscE3V7YHsGBzoKGSvZwd5bD?=
 =?us-ascii?Q?oSOIum+mTBi/0hOeGxzyNR49FYtG2D+pGOVvAmWy+HZS3oPAkhs1bz6lhUeK?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TK7pifimodD6kxKgWEzx/tg7NeTVRy6aNuG1/q2dEOLHHkdIg/xUKrWvoycFht77XI/JpnsG7iYishyOF+im1EOMFUbDhdbTsFpYBJw6Fxcx4b7yj8jKnjfV0lJTOJqMfHBl9bCvsu2nwkwUCC2XhZsZVQS2fzrRQXJI0hnCx3HT8HddOp+qO5r/dLXVRj5Rlmr0Gm2fKekg1V2SE2Bfp0nbWj/ZdOuAfUsDu8MtIBGL9WgyPVsU8FjMdi+vX8bXT5LxUC9DVigNrzost39c4DksGEs71sN/vd4kql7ubLi/Wwa4x4omMOehFiM7y9pZ2Zs+N5JaG3uwtQS2mIhvoHgas3WKvtR5AQD81SiEzW0/OEEZU6h9pfrzQvOy6ET6zE6m6w1l5+rOyOVyQAp7sqPxo/eQ8E9i98L6rJDn1aUCt64tQx2jOBX4y1ofjmkM9UDjAWXNfxAoVJOVkA2uVdsMVAfdNZ7aLMxw9DNTIG169Bx/QeWGR1TowXjuKDKtt4wcbLXTlJfHoF3Durr7j1yYZ3eHhR70/pTBDkOkuRS9S4tWJ4ktvZf9urtO+6VBhqRUz8RPFVvOd49drKfeX5PASMwTPSfwfXRje4tGTlI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6e79f5-a107-4e28-fa46-08dd44a742db
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 23:05:32.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00KAzh0N7yKTyHyPKtVUU793ocFP3ZXNR7vd2EFY+Ux5uhq2QbkmOP+hNSTVxYz3Hm9WwywEOc9SJcLXmxJJw76Q9YpsCCibQO115G2MLsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_10,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=683 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030168
X-Proofpoint-GUID: Cp2QkDmn6atkBn8YiBChDjfn7V4itPjm
X-Proofpoint-ORIG-GUID: Cp2QkDmn6atkBn8YiBChDjfn7V4itPjm


Andrew,

> Remove the cxlflash driver for IBM CAPI Flash devices.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
