Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8A126F2BF;
	Sat,  8 Nov 2025 17:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762623198; cv=fail; b=Kk6IuKi+rkaixFAkC9Qa2UFOXCbc/Qo3wQ68yVkTaRp2gfZ5ogkWzMd3IIWTeM54ukn0yOgdKGse1aoqOiqep0jFJedNKhA5Oe4xN1i+tTyoyT9zops4uqcudAUHc1VH/5En/v3QcimL00Vnw5yiqjV/YgB64QiNfqbvZarVz4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762623198; c=relaxed/simple;
	bh=1Xi8Zt5sEGYh0/6w9uW5QXUsbU4lsxlwK1BqIEz3OGs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WpqRnPq6buOII1Qd9v9XuN7Q/M1vkgqUEVrYIJKl+eUZzK8cxD3d2qhRB6Ok+4eqWQlYDuGF/6Y/XwUSuqz/UWfgDiuB3ZJmpxjzRTHtNa3TOUtSA27785Oho0Vh0xfZAeziaSwWFQ0uW+/vHEuZr3x5I0PmO19x6LPsr5j6fRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IeG8siCa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GLasJSrh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IeG8siCa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GLasJSrh"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HTBQu028318;
	Sat, 8 Nov 2025 17:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GPoHhEHBlaKDEDe7pE
	zZrVHHSCNo0/AyEGQXxjCMN4g=; b=IeG8siCa3JY2IbNgWsWfR3/B5YNPT7ofs4
	V9xjeuwhgmmiZmQh8FJEcwp/TIHIrynIueAgFhUsi8v9uLjxIiVKC22/juMh/OmJ
	g//qANdnWXqwtEOcHezI7zrm3aEqgxsZodyYe9Gp4WzOfG7CkFDQw+ip/jjkMFb5
	M/CgF5AXy6b1kAWvAfDen2CI0WMBa6z17YfW+J9VBoCMd2LuMXgQGYMAO2wMTMfo
	2euoh/aN7+hRqNxxaWa9/9Kg7OlEHj5fDGFJSm+Ltmk7RCYQgHXLlUJSvjUnoplG
	t3ztuOi6o3jCvhbe9liNwjZvz1kFwa7JQgcX/q55sC4jwRgznTug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9wfrgm78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:33:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8Gl3pI012653;
	Sat, 8 Nov 2025 17:33:05 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaa75sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:33:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtATLznmHW9cm6tFK8BjpQcHQxpJtgbUPNdg+7Jf+kSWIrAvpy73m7+KRpv9fz66rDlNe1xrFlJFmmvNhfy7jb48FBQIGae1LKTpCkt1wJe1cjsWmbS2PiCb0pVcsXo2UcvV2+0jT6qIc3UlfkRrTpzsejFPuVLLZ2YB6pWjFKL/ReW4hfXZijIXxJXfPp9gvsMrwJoLyje77BsdwPqztt4ieaFxFo0bivGMYfA07TH0Q3ow/CFLfPOb6hXOfJfrvoyq1jgM7C+zuBmOrRTEoCsLKTWJl60z62l3701fgd7JhfXqrezWLb2Re1VeqdnLdGC5tl0tkuBbwWWrkf3I2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPoHhEHBlaKDEDe7pEzZrVHHSCNo0/AyEGQXxjCMN4g=;
 b=JGAD+t78DpBNjJ4isRC1Y6XmiV11advA3zWD7bnxphXCuC0JmAbxO2JqKtbDfTTc5LKiFFX8Ex6gT+2s5eix1RgGtdQ7F4TpyXJ2/BV2uB0rGPbhCmNbEm2ZAQymdyPwgtF0Ll8MN315NZkdMaf4xrR2bnVHNTzkRc1A6f4OKJ9yB/VgPKOYd2HG0PTnwX6g0mglMIsTWMKwvwMdMJVomfXjrhj62rNUvKSjrZlWUP7j66YwjRAgurw1nRLgewSbs3ZFM+hrIYazpI4O/6zx9QHLHbtxndohAhscJZq7bsyAZgpyKVH9UoCOVfsU4EQY1Pb49FmvYAgaP0WwTCp32w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPoHhEHBlaKDEDe7pEzZrVHHSCNo0/AyEGQXxjCMN4g=;
 b=GLasJSrh81ea8kPTJYfGIrx1MyNEPGw/Uk/ELXATH0J0CxVMpqPLUVS+LnPkm1jXYFf7M+ZUh4yMiK7fudn5syctWk64cFpPkoPf7m8rpknsn2Va/TJwCY80HBm0uO9757fMXxAJhi0gBMKEv5dLrtra/dpRfqUqd/9pkmal11k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.10; Sat, 8 Nov
 2025 17:33:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:33:02 +0000
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Darshan Rathod <darshanrathod475@gmail.com>,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/arm: Clean up coding style violations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aQ3oWITFc3F6Hwhu@shell.armlinux.org.uk> (Russell King's message
	of "Fri, 7 Nov 2025 12:38:48 +0000")
Organization: Oracle Corporation
Message-ID: <yq1tsz4ig6m.fsf@ca-mkp.ca.oracle.com>
References: <20251107123435.1434-1-darshanrathod475@gmail.com>
	<aQ3oWITFc3F6Hwhu@shell.armlinux.org.uk>
Date: Sat, 08 Nov 2025 12:33:00 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: 19738cd6-8ba9-4feb-a031-08de1eecde54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xI+FMkLB6q13FUUO+CO2gPFxosC0ByjIZs4lnp8BTVbbRr2pUladS3Xt5vMb?=
 =?us-ascii?Q?RvTdIYnGNLTZ2E0zU6btP8XgUCc159eKjyhP0TtYrVUOH4R1ZNg3lH70FlsG?=
 =?us-ascii?Q?ZdWU+6IGlUvoF/+zv8RuW4kVknbR2SDN0T44prQRE3XyrzdBajyZi0PdP0B+?=
 =?us-ascii?Q?C4/KA8jPpWpueP17A8ZxZtOxsXGE74SPBe4lBz3gX1HGIgUvmnnjwF+JTFBw?=
 =?us-ascii?Q?dqrZ9zqI1Vt9GOC9BFTEf5S9NkPi87esMwHjWYCsadkjlBi0OdX0iMhhM0s3?=
 =?us-ascii?Q?P/yLxxHqMg6lhjWoN+FNSwORGVY1pjsmFDwYT/Jlm1U7B1fSTp3o+0u8UVp6?=
 =?us-ascii?Q?7+FdiM1FCdCdRBZX6fcGN2Kn7ESiM5qLj7F5CXDz9boo48MSrbtpqOrZT7OS?=
 =?us-ascii?Q?1FdXAm8sSMQMJ+yrIC5deSPthw4/DEvS6NB1ZOOcX7oE7GHlBJgjJh2n4JfE?=
 =?us-ascii?Q?499rvQg8opmTH3Eyz3p8IdVDu/Hot5Z6dVkY7ddWaIVurBs4zB8PevJDExZZ?=
 =?us-ascii?Q?B3EE5xGh4aa++qhq/QNjJD21ea++Jjuic4XTL6NyNbQrOnqi5peFNkQUPmgg?=
 =?us-ascii?Q?YPGLAFBSa7RdQDI7CfsIPFjZE2eX49ph9o+fieNffxFECfOl1vRW8ssjPlQe?=
 =?us-ascii?Q?TsQe6ipyN4lKBcKtdEo/fSKncxaoXzLi2fTcrSFZTMFudttCa4T2FXbWghMA?=
 =?us-ascii?Q?SGnVZJFpF2WszSFirmMa2XZ1QeYq8+/A7TbghYtq9E2H2vu1Shjeo1ichSjh?=
 =?us-ascii?Q?Z6tVeLFnRGaxp+t4iCU4P95/iU9DX/iYQCZSH5Xiaa+uRPkV+T2xIxnpYPra?=
 =?us-ascii?Q?Bo4tenCOKDbqGteJ92HB/eYvBnlfRRYHu2KVIBPvsAjUg6SrMo5RIWks/RiT?=
 =?us-ascii?Q?ep9oAOn3BIm04uWDFnJj1gL3m7Y+c0i9NtcuuWDPpi6smfwHBFNLvfvR2r8/?=
 =?us-ascii?Q?SSpY0fvRFvyheivV3eU81kyNX8lbmc1p3qELesTL/f+c3D/xRpo2eYMlyDcT?=
 =?us-ascii?Q?QBEXF24zFeXdDi+esRWtK0CkLLW/06q2yZN+3bJ8g8ahC0u0u91ad8LTBN2X?=
 =?us-ascii?Q?EIwj9K5xNhdA7aliGL5WPgb183zjOp95Z3wWrTn8al/56Gq0CUnJhlu5SKpW?=
 =?us-ascii?Q?SZVLYYR5nJ5Kk1DDm8d/C4ak9aDQyVBioXmtaB6b83l11On6dqWjUl32oJ5Q?=
 =?us-ascii?Q?SN7+3zGTurY0kdDHt2xddgwT6wQCTtF5Xw0V8QU2R3jBBpGNdMRmAgEoZTZG?=
 =?us-ascii?Q?sta5XnqmMWQtOEKkUbrSUuIaCQozdgEoG+BvO6k3KT1KCLcuHr/zpTlUmZa6?=
 =?us-ascii?Q?BXo+zFhtJMAYWzf48hWw3T60yBiA7L7cDlzW6kdVVgiPyrAOfzfOgZKhOyAS?=
 =?us-ascii?Q?/2XVN0DaHJVQNSkBa5rpD2H8urNPRZ2mQPK6gbuxl6fBtJQci9RJ1YSPwdxo?=
 =?us-ascii?Q?MuWpVbkD0GmPveEPXS7BFyi9i3q8Rj6k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WVIdkzlNoy0zdNvj/XgTNEjOZLfXFURvWcs+bOx1yivdbQ5hgu31o1h8CAZe?=
 =?us-ascii?Q?XEPGSZb6b7td73QPEKGiSGOAOPyvLtw67n2XPQgLVV0FPSbLa7UiDQzV13sZ?=
 =?us-ascii?Q?4wrZUKvKgig9RO8N4+8RfzUuyIWeUDFWUHpNZ9Y+d/tz7wDZ9sc+pqHJJ+Ri?=
 =?us-ascii?Q?3OYlw2hNBA5WXizcaWIsm6R+HoX4PfiYIDQu6bdabgReE4itNrYw50SougDD?=
 =?us-ascii?Q?EpotYUCy9UX5tzknOHx1qKiKIO0E189/KI7PRa2wHL7m5CDHl1J6a1kiFLyR?=
 =?us-ascii?Q?1T62e5IWOCQ5FVkewex8UVciXrw54WO/tK/NvrnlGkhLR4g9lHa8DagTQ2hD?=
 =?us-ascii?Q?bIG2mwE7yRmYlmZC+ktWjzz/uM4Xaud1gYxnwCAH09bPteH4IYvayXzpzyR1?=
 =?us-ascii?Q?lzEy0NAsz8TLL6+Zwb94sz2cYSRVBDRRSYEcVzSTsA6HceNdFkyUSv+pt9uh?=
 =?us-ascii?Q?Y/VwtSOrN5Ay5VJmwMvY8MDydFjXJP1XzPs2I/Ek3Pr9+N0bGPIOrzpBat1c?=
 =?us-ascii?Q?nOm+cWqsF7lVMQH2ZjMJonMS4RR5AQ/kJPntdA7WFyqzTdbc3I9MublhibaY?=
 =?us-ascii?Q?HO+7PPJ/kpxp8WmzOL75C4LYwSWQk5TAUYk7BEPWQjjmX60I/nA1XGoyRvqs?=
 =?us-ascii?Q?OVvfELLrs5RLJwPRWCM0t+jwO+RNF/QTgrMbq0hRd9G9z3MkEQdzGLjOqj32?=
 =?us-ascii?Q?9HejaNR5HbW6xoZnKZkT37a8fWWh/tfW4jDfDm8Ic4hrSvSXpG9P3Mbp+P/E?=
 =?us-ascii?Q?APGFhPV/r6KgPv/Kym4j56H1AYnsJM0upU2pNvIZG5ck7OxLD/ny9g6b5CpL?=
 =?us-ascii?Q?ORJvnXUb2WjjriYq02BL9r3zRF+NH243CENBOPnblMbed4eFWhra3VtVlqFD?=
 =?us-ascii?Q?wksCe46BSnsPVqCEY7OSHeZicbnlzqRVPfrnUQo0sf+F2jeOSnoMhv2HfcgJ?=
 =?us-ascii?Q?Qpm9QR0LlunIZWN8yZqUb7oEAaEVWFdTbOGJtvoHtONlVxt+QpUPruMn0gk6?=
 =?us-ascii?Q?wqk2hQU8c1YEfa+Npg29YxxI0heXJqqLjsbz4tFOZd0+IG11CF5ksfFTN0wU?=
 =?us-ascii?Q?q3ZqMUldutoDGHnYX81dNnXC9cOTqnMh72ITw9u6Bwf1AXJeCjabIhHEkPso?=
 =?us-ascii?Q?Ocn9bxtv+aR+KXCuXjYoooGtMy+Eo6ougarCS9HHQk9xLEY5HMjllWLf9Ucv?=
 =?us-ascii?Q?pG4YpRu0NNQx/eFBySoKNzv66oEwyK3b/c2gx+ZhNVkoGMQyliV7q010qb3x?=
 =?us-ascii?Q?WNR4qLgq2xZUsnfP030WPFQ1tLxdiig8PO4I06HeOuCzzelnJF4Yv+yL+dDa?=
 =?us-ascii?Q?XLMThzo+ax4zAOxcbBV5srL/YirUsYbeVF9E0BlM1MXhDT6qRzTTcCrd2up6?=
 =?us-ascii?Q?g3Tkbi5kJPgmrwJuTVwjK6fuYY4xSBxIAV+KuArPoqU0RsUj6Xl75mBR/8RV?=
 =?us-ascii?Q?W/wcrQtyagfm4oCEhy/KyhKLR/csNDT7Bj7GIknaWJppa3fVkr869AqQ7zee?=
 =?us-ascii?Q?tV6EMvMQ/6e/TaDf+HLU0KdNTs0s+vbVQOsvI81+emc9GdmfSaVC7pTZybob?=
 =?us-ascii?Q?m3fDw+MQWK0/849Iyw1Rx8reNrB9ahYAMHXtqHD6pd9C5DtXS9+Qa9rIftJB?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sA4RBPpl6N6PsrNkR245AG3JBf9LN3Af6UOuAt3r39bY4qbGtt51tNpmYHXgy0kJJ1YLLwR9xMdzLXw2kqMBawPK4eMF8m8yw9Fa+KYquEp7oRx5JlEG92AoR++LxP6xI6yOIKYCZc48iYL+R4Wokr20oV/h/dbwUVSJ3O+1OMaEKtjdXs+yQZkPsDLJ/BY07rEyintursAsGr6EwqwcoeK+4O2oOm9LzNEGs/SlCYj8a4gBYX0cmBoc5XoBV0mXt9MogzwuPqdmRsDwFnIAXuW0lpW8uTIxvb73RtwuCF6Bu8RMnF51tklyge52G/mIhiekiHcaPuZ6lCWzP9RzlSB0KRhbkDM9c8aoPUzpaedplkX4hD5SW65iqreJexmfgWX/55rWfiqZlfoxkh2Ffhtugfr5S0wk4OOcMy2o64sWjuiNCc6EOnr+xlEuE3UK9TxF2zMGfg1apmgLoXUxOHtQlevVDGVdDTMS0csj+8pkrcJ6Kid/xkSP82FQWqH1iqGg08dv/crK0JU6SOMbTLxqbzeuKu/SpA0+bHvQmwrD9xbMeuC4DgP5u8tsL0vi5rmhqYSexZZRXgbdm8iwKdyo86gVm4ioojbKdz/I4/k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19738cd6-8ba9-4feb-a031-08de1eecde54
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:33:02.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cfgf4VcwXP9c0fZo0YUzCQN5QeH4b5m6plDAvYweJm8A5zSraX9Ds8cELVZMU6pFZQYAhQeDWFrO/EkBGpk4nl8DgX1hG0DJqxTCV1x+aJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=844 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080141
X-Proofpoint-ORIG-GUID: Z8dMNbmndlPcJRIJ683gu5KU_8o3UOqn
X-Authority-Analysis: v=2.4 cv=JbSxbEKV c=1 sm=1 tr=0 ts=690f7ed2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=hKkliGLrCyctOxj1eCkA:9 cc=ntf
 awl=host:12096
X-Proofpoint-GUID: Z8dMNbmndlPcJRIJ683gu5KU_8o3UOqn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX+sBaeQHf0JAn
 le/E3dg7upybT4IjsE0TaV74VYsgnvfUe/oIIo+Qik2svKKwlMxK6NKbIfZkBRXakxjVs7v5kPZ
 2LOv5Qb551bjHa+GzAXqvb2mAF3TrPlBxEOiPruHrJpLQFVg6YoBnGXP5ySntJ3CN7gkni8eSra
 yPDjgl5FWgiOLlFsDuLLlJ0OPZH/3jjBAOIPv0wqzsILuT9dgaWen34OSj8/yHrCbE4laIhLasf
 7nRued6RiJzo3hvRXm9/AsDQcSvQZ8Go9cSlRMiLHBgQ9pawTWhoVDoC3+Y3bh5nIFXkpSh+o0g
 SXlGa4g9UFwVExMUJCftw4VfR6+WdGMQ/v1SjKGmPFsN3rn5++PVKcBcYqlwzAZAD/A42NvIcsb
 4ql30uOHWR0V9Rt4s3im/rODT1+0g9gcydvX4gzxp3XjM+WuKHo=


Russell,

> Up to the SCSI maintainers, but this code pre-dates many of the coding
> style updates, and I believe there is a general policy not to "fix"
> old code for such things. It creates noise and additional churn.

Correct. checkpatch is for validating *new* code.

-- 
Martin K. Petersen
