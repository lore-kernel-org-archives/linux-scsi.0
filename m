Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5A017B506;
	Fri, 15 May 2026 02:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810516; cv=fail; b=embSnvrCJ2EnA6tv0QrwH4A8OckLRrhLg4adyVeDke3QjMA7zzKqYnsMxheuxBztCa98QLMuvmvj/xLWosPQT1cHrvU/Kytwdr7v9KKAWrtK/pE+qAsPjr2CGVrgXN+tFPWh3gvm+2LS/BsIK6cJISIyjXeQzOtRpHVkeSzH3Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810516; c=relaxed/simple;
	bh=Gj2kjfjC5fe7fdueHbLZ9K/V+OUX3slghiDLlMh0e6Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XENHJ0ZNgUxx1zchQ3E9A+eLShgEB5hlgaN//9cq5lTn8TDx/lY7n3GnFpwOSB6qBgHoOt+VLQZaTE/DiK8p1VN1XexIJEjQ8ITo1KGyDB483sZ1tKZ99S3IsdNhOv31cz4LMB4wqFy1UT2DA0mVDnb4rLSDDFPJX0y8pzipGqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V4R1JR9I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gBHMO5cK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4R1JR9I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gBHMO5cK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0T7q01504351;
	Fri, 15 May 2026 02:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eY7iwitkrGrVY7IMPr
	68NaBTEt9OjYGmcZTHu/phy7o=; b=V4R1JR9I5DmgJNz3svORkbaCMreTwBqZb3
	kMNRggPyT6Vegkv5cl5TlQNG10q2ScsRFnjVlLPpQFsLbP/q+xAAN6zJq9x7N/m1
	efFZEJKlBoRzA8xqa5ipIqvemlu8PAo1tF3+VEl6hbsX3V0qvuv33FMhNJqshPxu
	cUFAxku8QU6dNynDC73INCpshyg8tkuiCgr34CftG0SiXb0rmYH3Z+TpxSJIwem0
	j7lDBbcMMRxK1rIZBt9o6XcU0Na/ZgFIQ0vpReL478F4ohQZWBixve9MzWmD9+cI
	Fyqhb33tWADGubX+eX1J8Mafzi6o6l3a1HujvxwDhtl0z57pKmlA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rrdgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:01:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F1nf8n006733;
	Fri, 15 May 2026 02:01:43 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw0cgv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:01:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rol0lW6rSz3K8KEEDUf5qvfZ76hs/ydZhu7vxGdEHDAXcFDnEArhlnYEcbcF6FcnQLP2zVF00ENBdJsI+cPT05VYH+zRIywJy4wpV5Dn7CbnVgiC48XUW8MYP9AJs+ucd/NaxBDQyrNyHpD+sPsWU7NWn4tgX0pLAdH0puafxzQNQTIapIf+q62kKlqaGdWNtSlsCaLTRorMwmNhs0LAIYHcMsMLJ827SuPJpBkqTPPVslg2DkW1F+5bakREjwJWUotGsMd70aJUKV1/JQbnJJZlfLs8C4ibTI8Y17u9AAEpwJE7uhc+zD20U6xboolrIfwnfIHj0j6xmWpCmOtGsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eY7iwitkrGrVY7IMPr68NaBTEt9OjYGmcZTHu/phy7o=;
 b=Ah0WqdzwuifrLLy1bxswhrmhxhSSZWt79a2O+fhwyBjM2wX/ExB9OAbXBLI8Uq1bOJKbZ5wR8155hNT0GdxqpMX1WeGsbF+ra+3u2FRk2BB7QMJfJ7/92bk42zaLCQbsS2AJJz99pnQiwTI6i063WAiJfTtL7kUhNH567RMra5nVDychGrEWSK3F0UA9YyMA/L6QKjxGWZ42P6lckmAnKRKDStwVIcnN+yu8rLU86/27RktaN7A1Z+KnUaYciSMomzjg2B46HIJvidk/RuRnI4N6CD0O3KYtZg16OnbUDmXz+xjwVfvQ6Nt2tigcbuN9F9afn/m/YavQf1EgmK6IIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eY7iwitkrGrVY7IMPr68NaBTEt9OjYGmcZTHu/phy7o=;
 b=gBHMO5cKoBiU/sqL5vB13ROvkKyAarDMFkWBp8t2T90I+13Z69a19xu1MiSEAuQokSnFubR7E/OqbomXRFWpm+PTKbinQqyNd/BVi/u9Gcx3+Tp4aCRG6pnDPffOoYsYRviZftwtyz7BDyOEYX3ucNIN9pd6fwvFJVSxiTR9xis=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:01:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:01:36 +0000
To: Wang Yan <wangyan01@kylinos.cn>
Cc: <lduncan@suse.com>, <cleech@redhat.com>, <michael.christie@oracle.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: libiscsi: fix spelling and format errors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260511093030.63542-1-wangyan01@kylinos.cn> (Wang Yan's message
	of "Mon, 11 May 2026 17:30:30 +0800")
Organization: Oracle Corporation
Message-ID: <yq1v7cp5t3c.fsf@ca-mkp.ca.oracle.com>
References: <20260511093030.63542-1-wangyan01@kylinos.cn>
Date: Thu, 14 May 2026 22:01:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0098.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: a56b9f1d-b1dd-4a95-8309-08deb225e544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	a2QR6tJk/oXiD0NuHz9ZqGYxSoWv1fJG3KS5gj/9sKKM7jTpLfzGYIjSgev0tFC9R1nrpq1dAI9Vz9XdJrIx2byYehPZxm92MG5YqGD0SMaOP/af0hg9sKkXkDCg9ExYPZP4pf8WUreo1U2EJxpilaVlH7dXGRv5Aj7Z9ZdxzumxcmfDmU5U15zGVOXRX60d3EX7nVg19GRBmNfHFfcDpd3YVn57ShAoIbfVmZV5W3pqF0Q9Tfw5YwsHQ2w7qmO71yT4RMtwyszLK+v+uokxQi/dnxDC0/oDsT3UgqR+K7Fiy4wGqjo9MWbkHmxhIBVMVIzrcsOZAfo/scyypFt4IKpccMmX0HyRjlCWCW/3Gv1dtLt8IsQZZ52HZ6Fc3mlPpOzeHK8YeEEASxCMrcCQfhup6xsRc/QgwO4x14M0tUJrIehxwqQgDC3iQyFQko/AgTNPZGtYn+6oV1YLxg/vZyTjaepv7dismjyDP0UxcAGpsOjeQ3h/JdLyKdG9Z+nbkV/sOEbLY2rKenhX1fLdPOX5EhoUTDQH2THpFuyW9b5SY9aWnQIUn+wyGjPjnmL/T9T82bl6c+9dCbNXlzh7Pbfx+BVVLPJNUO+pmzF+T40uLo4tf9GdE+JOz7Cnun45pTSzXFgguOdJHVkVJll3yPWXPK0N4evbxHfSdydHcZdSKxkfqZ7B1vMGmEwLsqKP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g2Pod9DN4EETtv1op6XKfl9sPFLipyaXkHllaSUu90xcOqChisTa8wxsCkrL?=
 =?us-ascii?Q?KKwRdIfq/ZgVXhui5C2ppvujsqf3maVLp4KgnvNZI2hsoFQDOuLvpskyq5nj?=
 =?us-ascii?Q?gCJ9brph40HT6Gf/wtg1W062Wo6+ONHBnygYe0z/QA7wWZgOAGo1yNtYWtHv?=
 =?us-ascii?Q?HNNB9gLwztcL+dMTPLev1jAxMa73pQb+wnsHFxOOgJ9LLDnZ+SsV9PEvoi4O?=
 =?us-ascii?Q?jKMnfhB/SF0Zs1cJR9jD0zZTLJNV2Ap1vfWNmxAm5dbfhSrGNklPDey7YkKv?=
 =?us-ascii?Q?IMyHjQSGpnaJXfbKdW5XypqsSKwJyIOwsPztRzjaAuZYS5FKFu6Dr9DPvqTZ?=
 =?us-ascii?Q?8AVOZAqw48zn9LxZGjjHdi9tbAwJ2Du9Ql+4G4mLOZTVeSxBF8HyBeSraiY+?=
 =?us-ascii?Q?ywVgHVetUKONMeVXNfklSy3ZdAZhSkY7BjtPDA6PQ3bfeyJdLRaac0L1FciS?=
 =?us-ascii?Q?qNH+PESMnKqE67YxTmUN6NzmWZ44wGXd9l47rTw3Gch4TZL4PInMN17D3Qe1?=
 =?us-ascii?Q?myQgmz5lMWIRb6ZgBiDSOLJtP2AD9sUrVzry+kbydafCTxhlvVORsqpumKLM?=
 =?us-ascii?Q?07KojPNwI94cmRvl8rRdnK/qL0GHxW+ynIKQyfF2iLR5PWMttm0w7fA6Uwmb?=
 =?us-ascii?Q?cZ63XwCgsmVbKd6AHHG01f0iHAUwHNUTmtjm4lJ5KUpde7yqgByvb7oeOreW?=
 =?us-ascii?Q?E9ax4TX+NJ7anF8zxbnjwd9PSJiDgpx2pkwfIsktBay+RDbQHpDIn3igtxXM?=
 =?us-ascii?Q?5MplB3JE9LYDZDh/rHDBU2gpjIfZjjUoL/hWHFSbUBrVqvC8rrVVlkoRKsxH?=
 =?us-ascii?Q?b/C6/yhe7kkTK/WTPAqTimh4sHhPglnOmE3QDImvmgEtnz3P+hRrmn/5t8p+?=
 =?us-ascii?Q?UrSVxzFKyoFCiy0aTHOCabvjrlehQ9SHWK+eK5qPlveK/u18gMN2XEZOXuIL?=
 =?us-ascii?Q?UtzY70tB3fXTqPNAEeMEHfhELI3B7beF1XsEdLqVQTljSWWsaVbj1jqfyLz7?=
 =?us-ascii?Q?ykXpuR6bzUU6tIA8yPGn8/XSvEGczAAELyHmpwV8RHbRpuZtNEjw8+LdVw4E?=
 =?us-ascii?Q?KiQc7K98YStouOEQ+uC6TAjql2GUCcD6EYbVTEy9UvjI9nQX3yERyiHj2RfB?=
 =?us-ascii?Q?AMxXTaqMEpz65RtyL8C5Kr8D4OdWwqLhhBWY/mKP4CGmxt7E7rtRkxMsS0zs?=
 =?us-ascii?Q?ag7aP626ITETxHJWa6GdLNQ2RvHGg59jgFjjf2zrP7fFDkg8n2s+v8dV4Bcu?=
 =?us-ascii?Q?zDqWPobGKGgk+KsWp50ji7W8e0uDnt1AwpLuFnGQnosaacQ0Z3OmxoiO3+sw?=
 =?us-ascii?Q?wy2b27dWAzlFnV9x5cgDNj5H1IJwZ+NiDu3VWnBge56wwcZke9eOP0lmEJqn?=
 =?us-ascii?Q?+K5buA3Us1xo6UYwKhmemf3J0J1J38QDs+/e4q0ONfeP1c7HMpPYq8wvdZoE?=
 =?us-ascii?Q?KqyRzmPRBhs6mj1KZEWNcL9UuimU2vL0THlZGvvGxfGih7VQ2I9GJ+0AuFAf?=
 =?us-ascii?Q?PkF97BGZ2UFy50wee4n4jqFiUAWlYBDFpXXbF/0u13xYxYCaDZjCA+htE2kd?=
 =?us-ascii?Q?dcwOGILWvr2YyyLlftiemqPr5ljuHbxC1lH7sJ3TcMrEJY/Be2rYcVWQPGL8?=
 =?us-ascii?Q?Qkis0ZrrrXcXdFhUFO69dMLcAYuYdpnyQJComIB76077LH2abye/DoJQxDxN?=
 =?us-ascii?Q?6wW7xHUqAMttbKhzyPFVb9BoS3DGKDKsECMuA1m2qkQwlH0p9Ge+vY7FcGDc?=
 =?us-ascii?Q?Zh5VjQuD3cjZIWvRVAzFdXRVwQXPfxY=3D?=
X-Exchange-RoutingPolicyChecked:
	Z0zoTYACqNEnp/Z6rKKIkAUGOsNvj3jxqPk5QdRJXLgDlQNsHn7yUGTHfMpP0xEMdy/g3/c3kBnnVsng6MaQdtjaklIy33SuuRa+QPHlMNIbJw+TXvGlCftQL1pkcscHAZTWH0QFTLHiZLfbYWxyF3k9LcbpiY1RUHXW5RUPmgP9Kr0UNd7KijL79lN2vi2iysz0uocdM/nB7fAbD9VBXOVIa+BmmDBrmkyb6Qe6VdVDTWYlcgQDTwLpVGRf4B1T3JvxeRRzASlN5BOTxv5mBo3/6e2Wu/W1m27pHG/h/6XEKPuUj8D1+xoX+FGP0JHZBMs6OihGu1r4OibY/aV1IA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wHAyaJPzB3XbqW92L/p0Axrtky1BOxjl9iEvjto0toz2kVyFQ8oJYKhRqLoJrjv8oCbENkAEc9ZjBTC0S2tKEuvKuVfVxMXGG6U5R+FKBZ66K4cvvkI8rIxE1JS9t2e982255qc9VSOhVj6A0IWuAwUFafNKXSwnQoOBaPHP3bfzaDt+xvOeNOud/Oax0F0Uf0zBg0Ag9f4gEQkmIDO34RtPgBmDTUGn4/GlRJnlLk8VLZ9CfwxraIYrpsKJ//ySOP4cmnYInJbVXjtmhasZ3CwvB83HIiBjMMCGamkIzoEqgRltrW1e3zT5qC+jP6wPWT0f86JXtXd1JY5PEhdNs1S4258DyVMuDxjeJSTpshJzbVLyUCcQNbuiMxmfmP73H14K7XwgszX2c6EMcY9Zsnz3Zchg91M0esbbnUfPghoa6/PZH2nf2UihKQOeb8TUuHgadp4a0cDavVmUx7nYkQ8TPSWmW81qnkJLrynW1BpuCADq7eZY7RMzkBykpf82jk/JsEarh5heMd7edHEx0TBDQPK5HxZcDVcr5qY9osqQ13hZy7NMN+b0WmD74dsruq+GL8i0j0LoIJNKw5TQv1BFUSbEjEWF5pJxWfzz6f4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56b9f1d-b1dd-4a95-8309-08deb225e544
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:01:36.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k7oX3y4wPKY8l/oDqQNoG7dexPR2HEkYQYs+vmD/cU9dmpjlA6Ec3SdN787ep1t1texRKakJysin+IDMRpb424lqX+E0TB/Ri764y7ZKs/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=961 suspectscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605150016
X-Proofpoint-ORIG-GUID: 2iHHqHe3o2QS6dYmkPC10XSDJFR4q_HA
X-Authority-Analysis: v=2.4 cv=OvJ/DS/t c=1 sm=1 tr=0 ts=6a067e88 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=JSJInehYNmFdeB84KBgA:9
X-Proofpoint-GUID: 2iHHqHe3o2QS6dYmkPC10XSDJFR4q_HA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOCBTYWx0ZWRfXzn5ojcipqOW4
 mgdfBHnXPhJtwusTT+h+uNhMP91kegeL7wMmgBP37ax/xzdgCEW5FliJM6PLKiyYF9eaypSG2M6
 qBXTQAHlOht/VbrL+6qS3sSAleadce2qB3YQZjJZEU3l1nYvx3NNib1UzumAHjrDyyNWz6McuwH
 mIrNx//mjHFyrWlMMdVoZ9+MgZdYcoeYTlZ/rxntjkJZfh1IfgC0xI3WD12KcTcOyjp4owutJNe
 c8kJM4KQ9UmsL6oCCRyj2nXmpPgMkDxzY81e+xs9dWYK0/bD8TfczAJxUKNVyOhCH3Sl3ZwMfEJ
 b/NMy7AApBtpyvjWCvG/lGF3dZMPuMTkrpTwGunWZXQaqHrmxoBfgjZaex6DLdGHsczETT2ieR1
 lEDzQSJNV8EffdMdLov5BHV1jZkvPsmT5KhCV7LbLKh1udZtv4a6Ydq0WQzkPO43GHhpQKvgWdx
 tDVgekCY2jlDApksNsA==


Wang,

> Fix two issues in libiscsi.c:
> - Correct typo "numer" to "number" in iscsi_session_setup() comment
> - Fix format string "seconds\n." to "seconds.\n" in recv timeout warning

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
