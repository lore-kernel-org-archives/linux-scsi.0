Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F29AAD2C;
	Mon, 16 Mar 2026 01:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625743; cv=fail; b=Rl6u4TfXNtp3Ag5CvhC/avxz/ECKNCMKCThpVENHtruT5R6Yr0X7jJosPp5WzIa+WprW+sYPpl8DbgfZalQ4627Xlu6l4d4+bH21Vv4NP3n0+ejIuH1c9aSzIpCD0G7QrrFWWvyuYaTc71iq7XX1qOiCAHLW7ivIdYMlDElP9uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625743; c=relaxed/simple;
	bh=jBBAltNN9X8Y0unae3BDu0Ze2C99IV11zh9DkoFVBUc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=knXP1lr2wFxGvIFGxrCmpcETR77ZNr792BnZy+Wr1IDm0dITctxHG0YZU0oiSZDeQMMmgUmSTZK7Gw6eT8YnpzPCIMokDEtqND3+ca/pgnN/Mt3bND8vml9dWN2eOaiDYVOoOD543+DoUaSih62Q38uLzHyMKWyAtwlMj1Hn74g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cLQYCyOx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ml0oUX+y; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cLQYCyOx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ml0oUX+y"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0AMiS1864782;
	Mon, 16 Mar 2026 01:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kFKo0cwXmXyBL0O1Pk
	DaOf6gL0xUdOetOjSp9ecPDW0=; b=cLQYCyOxgNuxKtsB4xe9aluTBROX/ONL/V
	cRej+ddX1Y5JCHzF7iAgMoHnW4OYO+1/LiDeIkioXzn/DaNZkrv8N/Cvr1dcf4Qd
	BwO+18INtAfaHuPEvpBxuYYB+C/RQCJBSl/Br8HRIvtdmVidLaHhoiJ179Bwjnt4
	ORS5T8KW1iU5EoPWkTg9jAm6/eco65EjT4NEQhz+rfI8sf9GJllVqaOaOolNdryv
	fqtZwsHn5kweVrEjZBArdf0qB0QWR/cHtn5sorWDXlJBD+MedfhpMKIlXgE+82Uo
	iVpVhtJtDM8368h4HWSbobWyV5eD2pstMigulmcW+oYZAv5zs94w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxf41bnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:48:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FMPC8q014079;
	Mon, 16 Mar 2026 01:48:46 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010052.outbound.protection.outlook.com [52.101.46.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4807js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ub+Leh9G/uSRCyfKJfjccLir3dLuN8sTrwsoYhpB43ACG+PFVeeTStoSKSYOeLrupX2L97eJ4kF5aymzh5wvNHOfVNG0aoriqBkAlKWeJKJdqPSxZB7f31+mSedjT6pqx5uWqQCWEMoNCVhe12cNC55UsXsytCfnNc/Ndea/yFdkLIMzNgigjwT0pWSnZIIaaDiB3grz7MkLy+od4xmJHakJfcDhqS37/WHbsYYP6Pnw1RdN0iYQXI/2wvPA1gcmNxMWoXjTwdLHC7cB1KYgcqTrJTNos3D6fb112liphMtACLeF3uSlkMHW2izOOgFmKvn+OOjK67aGfV+UMZeclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFKo0cwXmXyBL0O1PkDaOf6gL0xUdOetOjSp9ecPDW0=;
 b=wwQTUa9IK+Q9eFfL3NuMC/oQ8YrmTSm/NCNPKZf4FplkXelBWLtTAQIRWeZLrMggl/QOJny02PFfoNNSSfOa98o72TH3pnMzDvm6P36e3/PkSQ4mLQIdbc4sDTYgYTus37ZVlwdKnFQuislcJUcbhC+1Mv3xXpR5/BEFusV1fpgR7K3FjrG5qCusPPL3m1hstjehXbgVYEPmn7x52ecs6KVHMjsN5f6z7J2QOtsudMsNzcrfKz4V6xzcja2uAdB1bVRKF4pAZZd9It+K1raMNuFJGMw2Jgd0I+lI+G+aPve5ZryYYGFv83XD8bDu+cRFMP7qZuXjYeo07vIv4PsLcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFKo0cwXmXyBL0O1PkDaOf6gL0xUdOetOjSp9ecPDW0=;
 b=Ml0oUX+yS1k4drhXNyPqm79Ex/VXttRIQeTb6fGlBZHUEenKtYDVYzZYtLWwb1bkh/oVfO1m6d9dzP+kuFPOg2plk+QpNBJZTUFqU605Fonvf6Xf5v1MqY1tC/sAj0kOnwGxXcbHWy1B9kDBc6hFMzKwr9xVMX0zgBOsurmK7YU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5660.namprd10.prod.outlook.com (2603:10b6:510:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Mon, 16 Mar
 2026 01:48:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9700.020; Mon, 16 Mar 2026
 01:48:38 +0000
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Heiko Stuebner
 <heiko@sntech.de>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring
 <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor
 Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] scsi: ufs: rockchip,rk3576-ufshc: dt-bindings: Add
 new mphy reset item
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1773368467-109650-1-git-send-email-shawn.lin@rock-chips.com>
	(Shawn Lin's message of "Fri, 13 Mar 2026 10:21:07 +0800")
Organization: Oracle Corporation
Message-ID: <yq1h5qgr1cn.fsf@ca-mkp.ca.oracle.com>
References: <1773368467-109650-1-git-send-email-shawn.lin@rock-chips.com>
Date: Sun, 15 Mar 2026 21:48:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0264.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5660:EE_
X-MS-Office365-Filtering-Correlation-Id: bbe926f7-3fe0-4c68-af7e-08de82fe24b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	M4y6CSIMGGkEo6CJ4bwvTd1e6mUvoA4BH7TuJTlc7Q1O9ge8CJZgLHzn2XG7wYF1J/TnJO2wIC8Wbil7cfpybAAn13c9BaLJvKa5Q4h5TL7seIO7RP8xcgPGwXCAyanxqe2jjzm5xOWcK6hK115Wt2A/0vTe0Xu/sHMi9fqnQg5ZMn1kkybsOeVfw/NK9BvVf+iZYoZWd3apUR5SKoPe+6NTA7jJaej7fE+ZA9DhC77nOtSil5oTFh27I5bqXCRU59iI0vugNV6G9EtCpok6Zhjvcyf852NUebY+RUWfhQcpMLNwWeWUhzRNkW8ajMmozqzKRcAfJWb1C4zBgVX/uqjaGd18o9siII3mUArLD9Z+YMUsgIKQTYkoDJHAjFqAwzJ2W8N+KEqu0MoxAYv+n5y0zCM8SuCj2lsIs0Yvb+dB1p3obIUXxZT4iGvvOxpqaPoUfbV4DQQ3sXpRz3jrDVgab7qjdQ6gcfOiKymC1hWmvbos//ngoJZj/pNVr/4b9/iBoHs8v3wPh8Va+lQcqCsXuMkXSdybpkjDQOPoCxl/MkowwBcATYr6yOEgq5cApAL57eyDmCAsbtINquGbPvAkzVVGefBn4JUiZZFdw0unoCHhodgwuQBYJ7nurEjjie6EK5qSaRnGeTS7S7TGekqtgYwmip8/e5lFLEteDF5dgUBqY9shTfH7F3+uZP91GS94EoYlM7IKX20ZKkAr4vrV+C0TQ5EYCCBzS/C5YUA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iCRSUJhJmTH9cUSy0cqp5Lteklcvso3YoUaCe7KAN2p/Xtr4ajVjDbJvYi4W?=
 =?us-ascii?Q?9w5q/6NppkclzsN9ElRwverLrbg7cxhIGfMYUGvrcKpX1uuyfSYcp0jqLjPj?=
 =?us-ascii?Q?4gL+5eZAgOXjY6/cfYk5uYWHr5psKnwGlx4oz9qCQfUQXUplq9aoxZn3LfyQ?=
 =?us-ascii?Q?gXyClGnzxXOa7WLBtmAW6s6iFXw0qBVMHJfzW8yuSnqxPDt1FO1y1Mqx75vm?=
 =?us-ascii?Q?hn3v3lHeWm9GgoNxklYOZXpb0yK3FoMZQxyxBfuZ383Q+osyEGg61Gi6z4up?=
 =?us-ascii?Q?XrxVA64gW3AJne++ADgNbYMmxFy1ZqWpPPeJaoVCfOUXfm7IrGdD9Ww0LHS6?=
 =?us-ascii?Q?6lnH2bUCV3gfee6ZeOuCweTFxdPLtcrJAxbLJNowttUJIIoZQjXpemPjVRAM?=
 =?us-ascii?Q?XCKxriJbPpCSBRC/JmnRjbGiwuHxNdUqF0P22d1aPH/RPuWn9KRRXf+ehkX+?=
 =?us-ascii?Q?HLCNiKal0f0jWR8eGXdhEvovF6lpQV1AAtXHVZX0L3pkyculs2+R9gmPVntr?=
 =?us-ascii?Q?zM0QQV7oqvaps9I5xMZ36xYI9rDHOvz3C23lRgooAxCprqYq+M4zwdZFSSUK?=
 =?us-ascii?Q?K6Nq6PZEmqSkJtmvP35o9EtKKSDnVX2N4hMXJjdaKZiRzPTPJvzD06XU3qca?=
 =?us-ascii?Q?csZg0jA+H/VcLArTz8p3PepMrBMfbrX6tLKmS4zqN6+MdL6HKkbu8UZVdJOc?=
 =?us-ascii?Q?KitsELSOck3kz3+TjiOVTFOQ4ceGYGp99eVlebD8LLXtDjBelRs1po4s8xRJ?=
 =?us-ascii?Q?PK/qt4xuRxwdUIDyuV2fBhkRcGpwotI6K9jFKCLb28ZbHpnMR+eimkOz3fIb?=
 =?us-ascii?Q?boRjo4P8TBP1YPCYJSqddTu9dXG2bLW0lq5aJ7SCfQ0EqYtBV4XDgCKPglp1?=
 =?us-ascii?Q?c+gId1FLKPBvFFxIAH7/MrYUcplEGjt1I5cfr0c4tz9IDW/iuwnkbpRtjpB6?=
 =?us-ascii?Q?2bs3d0XZM2AeysggQX5P8iQocgnhl+3RZz3p8hJlB3zGnZq/3JrGhHBVDi61?=
 =?us-ascii?Q?rZQ8jtcwREPvM6gZApVuQ3wz+LxhOoCNK/641Hqzny00y5PEApRbxabGQ1gZ?=
 =?us-ascii?Q?9ayN3Y33mwpTwlKh6sfVL14+bPDgYoKcabGgetNMqrnCSBGKFlqmoxDBlURt?=
 =?us-ascii?Q?Zz0a377udw8zBJovKvLgBOZUK2EQ1++0Pe+YpIeQlJCWV8sKLoOGpEz5z35h?=
 =?us-ascii?Q?erQUFn/xvWZ8ids87WtpAmUmb15nSl24ZYRsKafjeqRtjn1JqA1osexSz/7P?=
 =?us-ascii?Q?MUxJP33dluev2WvLk7tUZGk76NnBh9nzEQJGdfzEcr7Qi3OI/KCWVj4CUeb4?=
 =?us-ascii?Q?dV4wmxDgCwDs1iQ0KowtRUOdc9DeStgEOy0Zk7oXgCByc0T7jlurIo8uSGOq?=
 =?us-ascii?Q?PAS+xbBCiTXVxww6LMW57riVIwSnOkCiMSYtvFzV73zlrFey0OanMcs8RHSb?=
 =?us-ascii?Q?C24ijvZLWEvqkJIGaACcV4ErWpYFGax/o2L8SItDaDB5YrjpCNTiV1hY1g8j?=
 =?us-ascii?Q?414VUwZEmf2sUYX0FLDEs1sz6fO9SWaRsFrBDuU4GK6KVs1V+q/qUeRWXrq6?=
 =?us-ascii?Q?tZHJ/vVxkbeLG6R4huzqOsn2I9LGSqa+bwdQ+7o9RaLn2VmPYFkmxYLaVmx4?=
 =?us-ascii?Q?8nZLf7UsXshg+ngzsHRmNDNTwfwn9HZkZqhLzz/ckGJ8BY/QsrfJ/0JrTGy3?=
 =?us-ascii?Q?lLpgDRUbsh7N2zbCvVthnzdKdQCFcsnefDzCEMAhgCH5Znt1XowrGXTy0hHy?=
 =?us-ascii?Q?3hBHoG6NVuyi1VDbHOQ87uq7tKUyujI=3D?=
X-Exchange-RoutingPolicyChecked:
	J9fyA9M2mJCRg4P3wU9bt5qIbrnpRT0e6DCFIcIzxqHI9X0L1vFoVdq+5+tVDN7Ebqh3qXgKRXsZi5SmxaHD3Lw8w0Ros3tXQdbEY1pSFq8MdxMUqKyNISIRR6K8yqqSkbO2SbI0lTV6eYWXXBxUmQCFIU2nuMfKebHx3IjkChvtKKZP9PnoRhl3ZZuIeauONeX+V+g+aUw2YMfuv4lX5BHWVG/Ff+SIfbH8KFjtsSKTSH4NegyIyxl0Um41COBiz0p1spEl2pMkQRzYm9BXY5AN/NfgE0uZ8QmZsBhYz0KE9ajxa58AgryvNsufy5wwhpO9KZ4l4ktHmh3GnWddUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vbkzCjFcJxARFO8/7WG8x5w1YKllQ1o0EYY7o9p4e1m3lrpXkNf8IaXDUvBc+ex8E7WmJHcVhM5tl/79a1r/r0EfkBUb23/J42WzWxcFDdLNclgB40iTwUtLqPnMNxsrLO40gLZq3VOmPMlRWcqcNmu4HsIFeGCpExKxWERsYSVPn0Hx04rg8kfcbIe6H6Ljs3giJljri2BEqXjkVD6aVbNYRVaBZUgU3gbo4Y/+Oy+bKzxYe90bRnpbFdMXBR+1PeuqlMcZA2DGIgWEFwTeWtgXcccRK3RHk5lLZnSwtfPKnmQ/oVbOYT8vBK6naUcNXmgvJVMWTfjibi/kHisavMlKxtkM2wshPpp/gCDETg/uQAJCLrNCXEtfW6VRzZl267K89p7hRX0w60o9kA3Jz3jqGM9k5KBTr+CwDyFqncu2dPX1fiJZL6fMCnj97j5vz9P57e/AtH+ZQiTbJj6zRmx45UZsmwdDi2q0HQ8Wt40QpuH1RemIpdrp1OANRfxI5DvRGdSiJCoIWHndwPfqLyb+lMKhQ4ymGUCBLF2BXSOo0hgxV1aeK6Iya0KZOWNULjuFq9PJwr2cfJRxsrPg7JaUWLkM494nmOZ8ZBXRFcg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe926f7-3fe0-4c68-af7e-08de82fe24b4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 01:48:38.3670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJnNCRhCsNpBEt+toNLo1PoOnMAAno0gLkhtjS4kTbJ2NlHd7zjP/Ko9+tavlJp74norRB0iz5jPBYStyuF9PVHhTbxSLOgATJSShY94fao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160013
X-Authority-Analysis: v=2.4 cv=ftrRpV4f c=1 sm=1 tr=0 ts=69b7617f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=JBNebbC9HC7U5k7cQ9AA:9
X-Proofpoint-GUID: g70Vk7ht053W26IQebFPtVt4PVzywskF
X-Proofpoint-ORIG-GUID: g70Vk7ht053W26IQebFPtVt4PVzywskF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMyBTYWx0ZWRfX4DK0C152z+ng
 fq4d2bpQQm3vjp+wBsGu6CElQMAzDdSp/j5WD1+wSQ+KKgeNTNSFNvF0IzdJVsm1DNwSAbH3+xY
 TYP6kTDbuzWy5xG5pDEVwLvh5iXbpgX4rPEAhHVIra/go+jDpLsAojYpewjkgJM9eKy+5+ngnRf
 ptX2Dz3JFPB0vx8fev6LbfmcqIUoJR6ZOmRPnuC6BQqMkgcCVi3R49l2j/dbD/QbKSwnb8EF7vS
 7IcyRH+waE3lXg5PdtF1an4cIWXfDXGKKEsMgL5sWg5GwoMd+l0CIctpDRq/cay3xH4URgb6B/J
 WjcbpHOpAI4l/l+ThYnq+B2w2tMP63IW1WyQHbiPrQ5JWklilsY29Dt3jjF73jEQEY2H2GoSHNv
 vnRacqKGuodNwH8yDVVjJ/3U+xHy/r6aLpVHisYm7/s6yXvGOdfFPwZH2Gu9WWekweIW44/3Wt8
 cL3G+jrV8poHDJ7Y/0g==


Shawn,

> Add the mphy reset property to the devicetree bindings for the
> Rockchip RK3576 UFS host controller. The mphy reset signal is used to
> reset the physical adapter. Resetting other components while leaving
> the mphy unreset may occasionally prevent the UFS controller from
> successfully linking up with the device.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
