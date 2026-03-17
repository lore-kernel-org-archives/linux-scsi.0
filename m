Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7076C3BADA1;
	Tue, 17 Mar 2026 12:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749268; cv=fail; b=PgtudRKi68UH9fdfSiN0Q8RB2Qsx9iY+EbNqULtGV1qILnP4jzkB1CvGrezgcHcOknb6YzO4r3dyUssLupyg4WkSaaHqqGAqZAfgCPvx6MESS/quq56YfTV5Y+mQTV9AyJXZ01mt3vQUld60PhcQqraxXrgZP+EKYB3cFuPlHuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749268; c=relaxed/simple;
	bh=+gcM/UOi70IG+eDdpgz+EFoSmnLicSXPhgHaUJ/1fDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d4CkYo6CjEPFal3GuVfQpR5moYyOJnmx35yhMZh6TWOuQDCBXlRYXEAg/zbBHIb6yRuvHLudF6PG5NvDrdq19ltkWcLpWOtZ0QG2prQFUn1frfLI1VcX98mzlt9vL0OWisKSUgE0g5mZw3eVU4OqRuxR0HHeUBHVWuS7+uWy5IU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RqNyV7g1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KtfnG4US; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RqNyV7g1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KtfnG4US"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GNRb9w2962140;
	Tue, 17 Mar 2026 12:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SP273bkHhfssUKZ/gCYGisnfZjj2tpPhZluOqMp1MwI=; b=
	RqNyV7g1ZbQUSNWlX3vcRRS3JQoaGPz6F/X9nieRZpOcHL/GU8nDbcxn7GQYrCcF
	D0MFkwnlqqHZPF2N7E+7YErIuwiZSGZ877qBkSVRTy3DVX3MWdzxoseZ32I5cwMk
	ba5TIdUSt6OfQfq0SSlQsJPbyMAi8kYPzwLTERBkbRkYaGYsF/R4y32jxH7hiBGx
	owcxuLcyRjwgu/h9ALcJ8K9P2igM6neIi6s0T/l/axTZzwLn0X+rmURRPILR1kAe
	dQd9MBIvd8PC3WUZwUAU21mpl4WtswcINv8HTAoTBs+XWOyFTDS56rOeT8yzfWgA
	py4ALgPPW4UWZMSqajO5gQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbuy6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HBPCbB002699;
	Tue, 17 Mar 2026 12:07:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011035.outbound.protection.outlook.com [40.107.208.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4m7tkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dR9Dsc0QllyiSth+HJR0epwIqT0V8tP8vWcQauKNQS/7INNqCWSprErxkyfZtnM5ThwSaDh0xVL7XCH9Cn4e/uaBa22WSEEBlsQIJaWtoOprigRCfCWbSI2gR1h0lOpgMBt+keKOSUe9DK7STmg/quMCoxgzsPN/RIeDcJHlcXSoE+HJP8gpNYnMfODIhE7JthHf+6J987fbWRtKtR3xMeqWc2IONtiSN3Q/fCTtmB9z/gc7UhgE3Qp5b4NAdQPtZO+CE4i/Do7VsKlZ9sOXNg0gcewKzZITxiowPHgy0WQJFV8+NVJKmvd5ikTblDEBMugzQgdmncn59hwwGnweQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SP273bkHhfssUKZ/gCYGisnfZjj2tpPhZluOqMp1MwI=;
 b=XSbLnWeKEsIfnVc3MkNXN91fG1HMeBSzqQAZXwv5psrG7CB9VGIvwx8K5IhZ7aw1aydXHcHp/7k5HBJowFQLNZu8iJTNbDReFTpxHnaqDPaCCIS+gv2ZloqwDZ1R1JYd5dB9Qi3JsmmtpnWQSN8us46MKP7Ima+CQPDBTYL0siE3w0pyE63zy4Hbt2glLlvRMJEGmkO+8FJeOGwm/KKNLay3InTWWFAg71l1KPpxKuW9K+FhV5ryJZh8pm8JzCXc2wTkt4r5aFKmjd3YY8BTrYywyMC6dKSPT2c4gV5h5ePGYLwISUCyZkgTPi1Fw4TqNmLRPrZWVq+xy+72hT7AWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SP273bkHhfssUKZ/gCYGisnfZjj2tpPhZluOqMp1MwI=;
 b=KtfnG4US02qWftocELsE9arzUgqjCpU7UjLZWXAsQ/993E9Hh2Z7f0Z39DFEEhKCz9zr+zV/XEpJ17RfEmHlAJ+Z+pwu9PP9S98Si3lbUOgSF3e1323ccgrfBEpKFhJ+uw+ZNoe3N+5J6RtZXyBGRoeRH/5eJ8e3bESiR7BYpjk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:30 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 07/13] scsi: alua: Add scsi_alua_stpg_run()
Date: Tue, 17 Mar 2026 12:06:57 +0000
Message-ID: <20260317120703.3702387-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0172.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::33) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b599e9e-2fa2-4630-bc5f-08de841dc355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YexhWCCvzIDuITHfLTh0UKmTQXTEn5PR1E2fH1uzUEuakGQsOGYoODsTalzGMeUYIWiU3YUVn95aSExcOYQU9nsnzKfITXHOhWbopDFLz/WKkwpfBDPXkY6fJDTdMINxDEbqjp7ysqSDySMUfks5Lq2HbQie6sYnSj2UY7+lpZh9+Z9NiisqtpOK14nSTrZkliHQN2lTLYMpsEHhEEJCRlULkbxOszr/+ZN4iAS00cPhgnaSrujEzBCxYLobcWB+vB+tcTjEGofGt2DP+dh+aO6TCWEeF8vwXk8hFqhRDhSyRo4UTXIt2slSEmc299wZBQbXARQn8QZdXtwemamR2b1n37rbZKyY5IV0IABhAIVxJlq5chuUqE/+xNSgNd2CnL/kCbOduhE3Ra4GOxVa6SwhqHx58gx9IYZm4wANpJRITqkNHXQk/hagQF0uR+MJQhD8V4hCzmJpLppYPr3X67XFqJoor9tMphvm4ixcxI03yPGcB9sxr3c5yrzwojvKIs+CnbNSmmmOZuzKNPXpyBZvzKi8+Ovrrmu/NZHJtrAA/65JK1DM5A2nlhhb7b0laEwTUrvVOtlW8YN8DWndhE5gfD2Rh5OdcStgYt0Hej/vBRHQd2WN8Dvg1ukABkRCk1UK6C6oZDBbJXvx8F9w0EfzTRaDXoTyCGFKDAK5RZdcZ1y5oOhPAecwIdzMn6mjNBtPBM+3m2o/vbdCkgmWChu98a/KfRNVqvJJnEA+e5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jz7KSRk7sGE7B5CeYi6kooW7jFxI25qZJgTPZqSJx/InvCLk1NKeiaNkw2KQ?=
 =?us-ascii?Q?0zzMw2m8+bsROViV9ZrSxJMIBOULZBkB6j05nn6H/3MNSSs3uQ9Y0RxUxNBM?=
 =?us-ascii?Q?9BydtC/siH+jo9VKOAOOfXM3Nqe1qwl+FXf1QpOzuhfaCQVPhMR6GbfLqvyp?=
 =?us-ascii?Q?x3vx3cUuLdNTg9xsEi5XeLif39OrByr89B+cMGqdItYv8Pfa3Fku0Ev9Djf1?=
 =?us-ascii?Q?jVV6ejeJJxprYd4DoRbJMU5RrrPGvZ9RkQwfqElbggJx279lFd7LaxbqBYMF?=
 =?us-ascii?Q?fjS8ahnZ8aFkeQkjvYKt1R9O072NhiyRoZ/91YWaXCRcDZRN3+7Ri4zBl2Ua?=
 =?us-ascii?Q?L6sB4wU7+g5eIqfdjslsDRdWC9QfasWLwoDiUrNCWPJBFCTyCSbk09/hCzmd?=
 =?us-ascii?Q?WkJOZfSzqkT+Iaxn5k0fJU5wwSyh8ROjGmlpVoUM06D1dBw1zc6+tf3vxm/j?=
 =?us-ascii?Q?x4VRt/xxGmkMg/VyuxY+T5vEeM/H9GrchetoQN3Rosnu/RgFQ5mnSi8zhMaT?=
 =?us-ascii?Q?y0k9REP+trkC2i2te2JtLBJKzRKpO0qL/UZ+Lo/BRe0T9gGxhxSEBywvcKtI?=
 =?us-ascii?Q?uNHJAPsAtuwlW1nAFsCSgNHDJlZ9zcOozNl14jQbs6fuWm+thbOi78wk6rUP?=
 =?us-ascii?Q?ir05vI0S9c+60XkZZgazT1gMLd/qbnN3GJIf99DdSB8hh+IjoJLWWBXw5PhW?=
 =?us-ascii?Q?bhzexh0+8wai0Vx3QiP7rG1ucldY7yfhheg4dcJUi0biSCf5nmWAuFKGQr7/?=
 =?us-ascii?Q?yRYKF1C7ETJLF0IzWObPJEyWWZ67LCyM5xgDJqn+Sgh/nJ57/EDay8/kmocr?=
 =?us-ascii?Q?NAHtmuT51yR3Y5QQPiOQueHkw6LzZ1DddeKAJ8Ci8D6CXgY4hJB3i9Nl2cSZ?=
 =?us-ascii?Q?ElZi1/0aXptFhDCo2t4UGuy/nCVTunVUy03Lk0vCrT+vGZXHT77H3r6I5uJm?=
 =?us-ascii?Q?hhIml7C/j1mmTgFyBsBpLdXSeFx+qXoWkb6u2zPMJk99tIkAWZy/FZ529Ld4?=
 =?us-ascii?Q?0EL5aos3M5K25DvdoYtXGBsvw0i59KB/+Wf8O8Nu45NM6PJJCPJHdBN48Hiy?=
 =?us-ascii?Q?336Dda+yEOtht0zwt+YFoBFStPIMlQefH4H1Ug5P4ip80LObEP4f42IX0vvv?=
 =?us-ascii?Q?qqKDLt9cTcX8YIlpCqpbG7jCdzmYqQp2y+al33inKI4M+ynJQzfIjoDlSM5t?=
 =?us-ascii?Q?h3wBRK49YTe3y3NE2231oX5fxF9wTQQr5bjsR3ibAU15eLTxFCfA48aBx9Jx?=
 =?us-ascii?Q?cJDICiR3FSLxrsu76K1nGqgPNihwO48fJlV8MCWJsHSEfZDmi/Wvn2tbYjEa?=
 =?us-ascii?Q?69nPdQ9pgWtwJqVyvYE8zRMBRCB7I2xfYI8MjuMUBYR8PHRSmi1UpbtiMvAl?=
 =?us-ascii?Q?mQnx+lE9F1AXrQb1ZCFdKPKu0L4d66mWVXSMmq5RdXfRGbWKbmlNRzkxofFg?=
 =?us-ascii?Q?4vmFKEbB5rCiJK3YjeAqNMtCzZOtOGs45whuxYt7TfvqlMbavjF4xMW6lk/a?=
 =?us-ascii?Q?V5TptltOPZGM/fdi8OGszjvJjHGINz7/7hLQc4ZlVcNdnFxMrV+izON6E4qT?=
 =?us-ascii?Q?RkJsvPxkNgw+eCDdhBoB73u22KUdmXWI9INf+M7A33cpe7yk+Y93tAz/vM87?=
 =?us-ascii?Q?/6bvXl3uM0fz6HeV+l0kuP1UxXwoslLeHjXUEyGrqED/KqSzdAJ9A6VdmHXt?=
 =?us-ascii?Q?Cl5exorgfaZ539FtMQonYAgyu1RFgNA7c6l/0Gf4GwmakCQrg1Iv88zZRTvH?=
 =?us-ascii?Q?ZFEAIooJzPb5asZes5YDXEOk+1YQev0=3D?=
X-Exchange-RoutingPolicyChecked:
	R1r5GnxhiK2CLCqchc51wn8ajPxJr0dI+JWfmZuWagYz7PNx9Hfbv0DHXWy84dS83Plmt1jT/mkhkW1bplWN2mOtcWrcoglGiBnyeoF5mYVV0KaE17kkHga8b8+Y71yHnXbJ0hJKSoyzR3uvIu2XVG8T1wUI7Cqwn5rXv9Kdn+lKUrebVFQoAqH3Q2bAIIzK0CZn/dIOIT/Oc36T4QP+oaf7qaPfDFdMEVc09Xj+Ps42sAeB8LfYjDI9gQ96bJ834DOj7Xjx8AchvGA24C/oLga1fG4+bJyAJKHu7Ruyccwn96lMmuWZSdsxuOqy/8syXtNbyn4rYWwnAUK52dhJNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Qwg8X0v+1168BjBUJA96jWXfFElGHk9xza4rRpomvEPu+ZC5jJtxCSgvrmJ9Lntb08lsKkXi18W7/oPvnsokH8jHiANhOZ7cDYlnrXAmRaHqRBwzyXFpUbhjfYWox0z1ZNPUYXc6uoymWXMuWxiLpE371NL/J/2+TwnR9CHydbsFlW6GU0T6o0adaq3xvfNP/FQ3VsPJtpWtZE9CNUNN+1fTcPP+OLqTYsOOeW3CuaXLqoPILNYzEcgadCZrrsw8dPG/ab1lX0wP/pR97MJryF/founnhPQzuUzGlCCqopGPo3XuQ0IdACxxS5ufpvKHVywgYUoic4RK+VlCU5X9Fy2HYvlN9QfZWUQkWeO/IOh/6zZrb9NQPpkThYC/9/3hZSnduNB7lZgYWepvL4dN1e7uDmCMKf3TfmYiZSuJMQki0+5/2D0Rzm+K2D4FuFNMCVQSUG01llL3OKj/G3Lpd0fN8NeT6Pbi2I91GloueVh6wo+dCNJTEsfluIk/p9zUTo5OU4URBf8dC6S46lPQ+GJUkR2xpoDsbT+BLU6Jv864TK83X/QA0qRsnZETAk5yCAuJGri804p+cp/7BDkSRvFTrauh7j118mfKg3MBr9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b599e9e-2fa2-4630-bc5f-08de841dc355
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:30.0502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQxhkN/juOx9zJJalx5fEgkGWr/l0roprhRYP143hLGeSjjP8WJrHwVBznKU8Ivno/1yUlu+ZQNbMwhr9jL5Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603170107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX42w+Ddth8Waj
 xQY+YE5nGK4WLjns3RckYlnx3BKyUU1uBY+EtmymM0IlTxjVqGR2fUYxHun4LtWGQFsSfxW2w/3
 ox/mimDxNqbu3fYN0Ru8M0Fn8PuBBTCCOu1ixPZ91Wec3WfeRAj8orBgj4t8/2MlNylhAXyT3cb
 cotYml4gwVwMw3gYbCCZxf/3dGdKY6WWHBlaJ7GkSfoHkEjUP6jleGdguPka5aaUP7txM6eMOvl
 cLW0KE1o0wACrzJB7cqJsBASwWFhzT5d1RDurMi3XBZ9la75HIn3IhxcR6njILtesK5JLA2A7Iq
 Uf1dfZ+2GGOFL827AiLG34UWo70ya/sB9rJuPU/mZfFixDAuHmZwG7PH5+vD7YcJAHl90vJa4aK
 jmmtpvLIvG6vPQ7KFtjYyJnAoJGGU5K65ghjgW01ai0Yuv8TheUnV8OtE2RzW7C+ByVsIgX+SkE
 OyJ7BRsjBqJSDe9bc4npp3Wp+S02RGrlA43bRDdc=
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b9440a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=JoSIP8vjq7l9lMBlepkA:9 cc=ntf
 awl=host:12272
X-Proofpoint-GUID: tBN2SswFGaPL5a4sJ7kMF1_lfuZLOhKZ
X-Proofpoint-ORIG-GUID: tBN2SswFGaPL5a4sJ7kMF1_lfuZLOhKZ

Add a function to run stpg and handle error codes - it does equivalent
handling as in alua_rtpg_work() from scsi_dh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 20 +++++++++++++++++++-
 include/scsi/scsi_alua.h |  5 +++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index e4cb43ba645fa..4e20a537a4ad6 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -428,7 +428,6 @@ EXPORT_SYMBOL_GPL(scsi_alua_rtpg_run);
  * a re-evaluation of the target group state or SCSI_DH_OK
  * if no further action needs to be taken.
  */
-__maybe_unused
 static int scsi_alua_stpg(struct scsi_device *sdev, bool optimize)
 {
 	struct alua_data *alua = sdev->alua;
@@ -480,6 +479,25 @@ static int scsi_alua_stpg(struct scsi_device *sdev, bool optimize)
 	return -EAGAIN;//SCSI_DH_RETRY;
 }
 
+int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
+{
+	struct alua_data *alua = sdev->alua;
+	unsigned long flags;
+	int err;
+
+	err = scsi_alua_stpg(sdev, optimize);
+	spin_lock_irqsave(&alua->lock, flags);
+	if (err == EAGAIN) {
+		alua->interval = 0;
+		spin_unlock_irqrestore(&alua->lock, flags);
+		return -EAGAIN;
+	}
+	spin_unlock_irqrestore(&alua->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_alua_stpg_run);
+
 int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	int rel_port, ret, tpgs;
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 1eb5481f40bd4..6e4f262bbfbc0 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -31,6 +31,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev);
 void scsi_alua_sdev_exit(struct scsi_device *sdev);
 
 int scsi_alua_rtpg_run(struct scsi_device *sdev);
+int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
 
 int scsi_alua_init(void);
 void scsi_exit_alua(void);
@@ -40,6 +41,10 @@ static inline int scsi_alua_rtpg_run(struct scsi_device *sdev)
 {
 	return 0;
 }
+static inline int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
+{
+	return 0;
+}
 static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

