Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC8B28E0F;
	Mon, 14 Jul 2025 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752531328; cv=fail; b=ZKIfiTa0tyU1qGxDHpoNVdSmYGM9hg8if3DgIs7SKSMtsBe3katSV6zBPa/1us9Mq/lxIY24MUBG/N3QA4Jph5E5IPvi8Ljp7BOAvBkzAeE9b5jZjQgqrF3LWCnFThSpELN3kEYQ9rTfro6TIf3Q2zCh3B74ykv2Qu3HHMW379Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752531328; c=relaxed/simple;
	bh=haEb1hOh8bqcKQepV22I8RyH+fM9QcHBOHQ9HbhpkXQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Bo7wK0ktbfNgL0kskBAlFCNljRGqZQGDTqYNs64tkiJpLa1Atrd+OzaGpeSa2FVO0r3uB3XxzaVeaHzoSE7DMtt8uG7G/ipKmFQBGHE0EZXpJjTMtTqsh5JAwfybw5LkGoWGY88yLU0WkNjy5E7AKgkxTSkAcoY2GvQZNVsTcH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aEMBYf+z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cMV2lLQt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aEMBYf+z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cMV2lLQt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ELZAnu024276;
	Mon, 14 Jul 2025 22:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MXU83Z67QW6oZa5Szb
	uoNUPK5kI4fQCpNuzR0aE6OwU=; b=aEMBYf+zBzqBQtTUNfu59k0rLM+OzaXtS0
	iz/2shfNbC3B7+GeWd9Aby1iLRSIQcxG7ZkWvR8favRcauXsEL9461Il4ir88hdG
	hrHw8wLfZH1cslQ7rsBd4dCKqAesahmlflnNJVjQ3IJ5uGz06LQ7x6DzbxcT3p9s
	ozv8tOdrEg+eJYx71cz1qDOkUipS9LlVR7s+g6gR8TBJyD/nfQ5Eeo0GEck5g44S
	ZqdqQIEkExE+htnTJBrWEUvbk/Z5204RDacIY8kUyKuWD2l6HSaz1f1hxlyTV8my
	NruLHxJ+fsG1PRE9eqg1HxrLC17ZBHIzT935I6YwmkQT2ZsdIBdg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujr0w96r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 22:14:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EK9HO4023944;
	Mon, 14 Jul 2025 22:14:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue595brr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 22:14:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OpJg8+mbckwIRKZ5iKVV4/1q9yFypfEyHCVbL85iUJDomI4Y1hcEucT94PXdA6QXeaF8PusjDGrJZvCdm4bIQUGoHwny6rbrUoG4FPjc2OjWSjLVFIuzOA7w5bcp9WFYM4wFgsQL9cKBHZILcZjZgBKU3wIZhzt+jgmsK1AkRWjLzGr5CDwKLYJ5IBl0XEfQHC0IAtgLVLvqEN2MlDJsmWZF1inAXzj2XNw1LypPN9Zgq/tN6+1L7KTZoewOLuyM/Vma1PQhcQAUfngxBKe8wscTLP05k5gzP+0gXQJFF6UJE9np9hPjaG8eUsT7mGle5eVwZmcxrKEJWNGkFW4Q7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXU83Z67QW6oZa5SzbuoNUPK5kI4fQCpNuzR0aE6OwU=;
 b=TBlAsOs58QnUmAdNc/uYQz0/1b63Shqyl7GXBRL6+7OwLWIzv8JSwfDo5oiYKpg+zgIxzU+OCFhBpPhBp29zyoRuadACVhHl3JRRHa8bboMVzLgSwhwbPNGt2ftYbyXhg+CWH7NwgN4lEUncB01edncDM0cSG7q46uaiExfqJAZe8SaPxFKP/1P2xGCbH3mblSVUZRy5hB4PajEHe4pFwyV/BmFMroF6WTVWdro9SZOSQi9WDkkF8IFyU3nKFIjfhPhGE528dqs52uQHrjcavuHnFdswmK7jnv6ftNuubRDciMiU7bZoCWE+L5J5PStN9rwwDngrGNXZyguzK65Drg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXU83Z67QW6oZa5SzbuoNUPK5kI4fQCpNuzR0aE6OwU=;
 b=cMV2lLQt96ommgYTP5CmbJsmCrfJVYKxFgx0aOIEJT9C3kH+IXueFiKNx4X6Zlpei70zLzMPPjprQ6DSjLkbUCZa2vFk7ohMzY4pE2IklMiPhP6WmC3XXMzt/3sQ6SQY1s1+KHx6O/OVCRZVOxBtwdoWEM/PL2RNH4LoRWtgrbM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB7994.namprd10.prod.outlook.com (2603:10b6:208:50b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 22:14:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 22:14:51 +0000
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Krzysztof Kozlowski
 <krzk@kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: exynos: call phy_notify_pmstate() from
 hibern8 callbacks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <yq11pqiaedd.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
	message of "Mon, 14 Jul 2025 13:09:22 -0400")
Organization: Oracle Corporation
Message-ID: <yq1a556776b.fsf@ca-mkp.ca.oracle.com>
References: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
	<yq11pqiaedd.fsf@ca-mkp.ca.oracle.com>
Date: Mon, 14 Jul 2025 18:14:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH2PEPF0000385D.namprd17.prod.outlook.com
 (2603:10b6:518:1::6b) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB7994:EE_
X-MS-Office365-Filtering-Correlation-Id: f7faf690-5118-4274-41b7-08ddc323da22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?StZsIo+QIE4NFwyqBHXKSbbg3SBE83PE0FKshhh4UWf1X4zyj5MQWc4Zkd8K?=
 =?us-ascii?Q?LaH0sKYP+rygwdAkGmix1oRtIIPB+kkVBEH9C2/ITC0QcZunq6q7gFoZlcdg?=
 =?us-ascii?Q?HatOKoXpzsLxBtkJsK+13D6QbfIjZcai5fgcKczA+ILOg8BYXXio1g09PLhk?=
 =?us-ascii?Q?2QT9Tz7374hXHJUbHv9JFJFJTDFKcPDjfgPsDbriFFLqn3f9v2gccc+P7zBo?=
 =?us-ascii?Q?jX6aOKpRF3KbswNKFH8xDZCCtxGw8KeZga8Vdf/utzObvvqo1qI9mqNmuCCH?=
 =?us-ascii?Q?2XXsunL1OlO20TMVqYe1NxSOqHm+z9cl3fYDRTUIG30YaQ5isyWTWzzhNQXH?=
 =?us-ascii?Q?W5FPx/7luwJg7cCFVwGrKThWN1x/xqeeeJvMlD9ftzIYxcApQsE/PT5MP+e5?=
 =?us-ascii?Q?AI1BPKOFkeZvFnIqR1Xgk+10/41REIrQN+5gNqap2kIAUtb2/xT4xyqXdZN5?=
 =?us-ascii?Q?QpoEvY0UxnfksxHDsvjItsULNCGvjSTtDTRMLcM+N0uBMB2VRze0KIAkRJGy?=
 =?us-ascii?Q?vtnbVltQo+0R3OMIbs+MMqsuBMMA8S5JDd5IP2wlHNcj+tfBapXk/fKdpCqV?=
 =?us-ascii?Q?LfLu4AGYvRbo6MsUDXQ9dZz02Nh7meeo4djp67zItJpOczcIwG/ynrCJjL9E?=
 =?us-ascii?Q?AWqbiEl3GkW45vOWSSDrIey+f7GwI1x0soifsVDaajGVwreoeSIqKw1VGMVy?=
 =?us-ascii?Q?W0r/vb1acRbCXY/PSEvywddoQZE62Xt9amTmk+wqYcvCKVTiPJ88WQHK8gMV?=
 =?us-ascii?Q?jl07Ph2r7XjCvDGJ1HAnKcErEJoFn4mB8GHcD6OEwBGAnP6JCv/ehAClnAZ5?=
 =?us-ascii?Q?kvdf7MS6xpoqXLmBfN3eT5WnLCGFwXGTrE9OW+3bvoaR1QzfxZRs+7LTe4W3?=
 =?us-ascii?Q?vDrqv1AN3z1+PqQm9SQ3sOwUrWNIoHPEx2OuBl06T7vwMugOB6dzNZknNHOH?=
 =?us-ascii?Q?jntt6Qyc2+PKu+Eam63/qoCEFprtJ1+hoNBpOCoAWeOQghb3IT9/G7v7b1Km?=
 =?us-ascii?Q?oPyuWwfCE+RtU/F+klp1LT/MEfIAsvoJPxYxFktrsyCBYQT2zNx5g3Pjk5U2?=
 =?us-ascii?Q?UCRW8R3EtUQxNYW/HgxYVC3pJNJLOYEdtwamw3NdTReoJo5n2T1AIYEIYpV4?=
 =?us-ascii?Q?lLYQf+liNlp7DRecWu3xGneNplysVd2aci7G37+006PmyL5zsumcprZLn5R1?=
 =?us-ascii?Q?a/l6UPtv1s5VCpBVgjy7WTDg86Yp93EC2Kj53DeNiwk9ndyJKyce68QGX/hE?=
 =?us-ascii?Q?FmI3CWmxLvf5FJiQaR06G42/5bYKAnV9yBs3p/kQEvyzDBMBqhcBshlZUdJj?=
 =?us-ascii?Q?mzam85yOzhkHiOb1oTkWNKmtCRBElYKjemRDGfFaQsVoEhcvimwmVeJ61uSK?=
 =?us-ascii?Q?zCary7HzgDNgL+0A8AXdY5Qpg0FdnNdSSfAMtbvnWQaqcnXbn0c1927Scpim?=
 =?us-ascii?Q?YagrSBcmprI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YbCBgh/z1taupSRe1i3KY3YmynloIWuvRJcUvX0AsUUL9G4WBMtJ3UopacIm?=
 =?us-ascii?Q?03yUsdbmxGKQZB5J80FbuXKsnqTgr/6TVCSNq6ggvM6W5X6wBFYpzBr/XJRv?=
 =?us-ascii?Q?1f8dEdxJevduw3NClJDkbcdnAUPnzfcJKxKrnLaxkjHvdXL6XLgs8QF+Tepl?=
 =?us-ascii?Q?koXvQWMv/dVMXuABP+5g556VtSpoS0wR6rX/FXOu/ejGZPtFF7qP2c48zlpj?=
 =?us-ascii?Q?udcd676CkfbdxMFR6s57Q6IpgUndEOr9zJzXS2l7/KqTq5jED66+kChu96ia?=
 =?us-ascii?Q?JRFLWz8uA/oNOUs3ltmwqK3iOix/KtPEMvw5JS81XOfzrkdcgoCKEOSAL05p?=
 =?us-ascii?Q?TanY4buFxUi0hXxWXXc8PrIwic8gHvC5f4bJSpp68NON1FueyGWTm2vFC3AP?=
 =?us-ascii?Q?zD/AK8PuYrANSf7qPeywN1MJb5+euEzCtRF+NJD42mIO6LoyYIHPUd4C0mNZ?=
 =?us-ascii?Q?Bp2nmj1NZsXNTDL+4TV7sStdRjNh4CxaAJ2AUm+rW3AjuNZxl1aJtAClPI2+?=
 =?us-ascii?Q?kw4ul6E2gERbfaHRPf+FurPG4x9PIe5ezw69iWwLOe7lyJC5sh3x3RbbF7z8?=
 =?us-ascii?Q?dC78dNzvzr2tldEE3bg1e2z6cAr8G16LC09lC29wpXiZW8zJ+j3OOoQZw+2e?=
 =?us-ascii?Q?7BO2U3iC+tKbY2AY6l2+41gHcmEVf1uQra4M+CoK2mrjax+uhD2yt79SjdEw?=
 =?us-ascii?Q?pN9Q7hiIKFHsVOV9AMsn5yagJHfBXEZi8oNRkfxNEaEVaNKo4FLAMDHdq0iv?=
 =?us-ascii?Q?HFHNL6Op8FtL3KQOODJkb5B/JyLSUeU6kTw1TosaaVNXxOPE6jDfAWQDuw7T?=
 =?us-ascii?Q?k6KGqJByNPBvTwrXE+V8EwxWPx9QE0G+x6Vf3+SJPJUwcaj+tJDgRWD7UYaI?=
 =?us-ascii?Q?myEB+0ckZDR91zHtF1wXX2KI3h8f6N1XoZKFNe0UY4vTOKlhnQ9UjKcDvcZz?=
 =?us-ascii?Q?aPPKbNytEtGpLlE6vRCzC07+w9DhUBrDEpR0Dw8/ZV9qWgDLi0Bih7bExyTP?=
 =?us-ascii?Q?Q7vzOESzQSFJPTcz7Gj4ZU3lJ9hwq5DFJQKe+zHJEzSd4bxEVJnqntiAIStI?=
 =?us-ascii?Q?Ef13EvvTiu92nlg3LkX97RItyF9aQnbbOYJ2OThVP0Z+YQcJZj7/7qsXthvP?=
 =?us-ascii?Q?7Frq1ucitFTcZGmJFtHW3bLQYvyQR8WruDa5+Iz46sCeqLjfQNTKMCW2dApK?=
 =?us-ascii?Q?H7s957lrpEoJ1i7CiIAdr9TXu5DPZiBDz8Lpf2DKc5wDTkH+t8ktPb0UqN7R?=
 =?us-ascii?Q?f7n3G2lTnEBc0Mgpr+pnKFISIYnrzeIO1+7PWXColIvOV8mip0oEbZ5OHBnu?=
 =?us-ascii?Q?gHEoTXHEW/lDxV9jAOTvQj7I6gw3atbd7g789w7MvWfQrOzSOlE3z9z7bvgT?=
 =?us-ascii?Q?CZXg9i4F21P2h65cVAf119CY/BN90Em9vJBkXdF6wJ+n37GGMXXVHcKa/uOV?=
 =?us-ascii?Q?1yk/+JBNhtXrg6afWiGxwNbb0GKtSooXnBVzuZzJ1+zTB88kQNCvpLbfRBl9?=
 =?us-ascii?Q?wyt6p5q03DwbvzCPa/TS0g4U6/UXd2gxj9R279UdoEuHPq3T7bv1XiPEvWUv?=
 =?us-ascii?Q?9+9H/hJZEcCuYIIAyTwn9oEEJYJzk3yQh/fSjLOScBIDIm5SqW+fij+WG0YA?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zFXJsGAgkERF9mYP+ECTdzoNxpdA6ftAMmMgEa7Z+JechZ9Njdbtui5ETRXxbMLgyohH0irUnEvnj5RZgO2W9Ek4B0Kl4sePymH5Y8drRZyycbf13/WLYHjsibBB+ajAg/M1N3GUmz2cIzQYn9lxevtjdbfdhhB8roBqXk4ghOCuemf27dGVOW1KbKSx+lREvgHX8ciLEsX92MAgb7chJpbx8bP/fD6atAP5tJnXnawcqmRnYkSfG1GtIxRcuaotEsVYqrXgIkpohMGz48yTVAQn9runRAyvV6YqRNrNbsQKvFD+YI0gVToCyxrX1wLE6oJeCbKUkoiWDBdRynBvt5wYHSOooVtdV6/6lILitBITt9gu6eWF+/yoIHu0Mr3oGodmVT/tzXvh+jX+F07XlVHyF8VTM2UNbb79ezCoM/phUexvf2NzOy9SBnZ7vL9BQp9+TpVwFXDwctyLT9gPCCHUvEJBSPJR6qJ0mLmlMZzeg8jm4VVOMjeFsqpX7q/2PPa+cIQ6pmpnNK+etIK0PU6H0qkpV6nrWyaj1XdjghW+mbxeR72tCH4/f/WLSBooW9vEDr/dXIr37WQkDTzk38nhnw71bkQBtbhStDHANwo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7faf690-5118-4274-41b7-08ddc323da22
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:14:51.1470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7v279C37fa7TdcRpEQa2GAxb5MYIKI5WjKB9W8booUe4qqtzI/7vWp7/N0ZvfIxu3f1YD4vv7SCPcVgaJSjPtFCRorsoTpk7jb0oD8mwrdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB7994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_02,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=781 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140154
X-Authority-Analysis: v=2.4 cv=d9T1yQjE c=1 sm=1 tr=0 ts=6875815f b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=QspI5mFgc-7mIq9jeycA:9
X-Proofpoint-ORIG-GUID: qPw9HzAjb_O9OGKKT1rCTnxRkaA1GSnn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDE1MyBTYWx0ZWRfXwSoE1mRDoSoE /a8LIO0KcdNCrmMsIY+xnqCeygmiAI+3/6y06Dl7bhNBmbT5UBdto5zRQLYIGoJ/v/EjH0xKuk0 eSWcJVsNMvo6nHTifQ08bVJHJULJ58g6WlZNMpgkGB3fcsptBbz8AENObUf2ukb9kHHTFqCXC9t
 aXTfyN2kV+i1Q4NdHcwkum18H39+ncY6QnWByMg3DLHzELavTW7F5gQWv73MC2s/vx01Vdwh2+F L1M7+tHK6wle4hpcyteYdT5pE+RVbGiZ3qZnugcSFVDQUzB/3m+l+8Cp5SVvEwZCmMaVWVZnbpK sppXiwPHL4BT2Ef4YDGrhLARzTbX3jrrA1Xz8F85O7h3aRaQhjO+C+7ds+3IFT91TOYjosjRwP2
 TJDKvWPnSGTq6vBjZrbIlv+xIc2jRJyrXhsRwYBsyNTbgboiKbjjaUWvOOc3BYdkT4s9b+rs
X-Proofpoint-GUID: qPw9HzAjb_O9OGKKT1rCTnxRkaA1GSnn


>> Notify the ufs phy of the hibern8 link state so that it can program the
>> appropriate values.
>
> Applied to 6.17/scsi-staging, thanks!

This appears to have a dependency on a patch series aimed at the phy
tree.

-- 
Martin K. Petersen
