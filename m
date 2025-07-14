Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8DD2AD20;
	Mon, 14 Jul 2025 17:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752512734; cv=fail; b=Qd3TVqbYyJG4IftltP9XCA2WdC80HC+QihZ31MLcqs6Wno0Wp1okET2gRE2XvSlqnJcHqlPQnnqJRYPLCqntLjqcfzlepFoD+qba780GPXZ+8bNP8r28pNHh4Y0rj3s1I+i8pobyANu+JqFU7QvXRYvjVd0H3QDG5b8uLNS8rpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752512734; c=relaxed/simple;
	bh=/EioSfzLJVttYX49C4e0AaXbKmnatArGJnuClU9oi18=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=f8ELelK5PjteYwUX5TLmId0EkAkxevacTVlquvuXx1KcAph+zn6gir+ESRT34a3kwvxvI2sEr9acLL+hONodjnzcpoFwUTiQllV44QIU3qA2D2AAMTAq7SQBNfos3ityN8pqE2o2HhLwJefpqwIk3E2GTz0ayXPrzLv11k/Zqh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FtLGWPEK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CpF5Fhk1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FtLGWPEK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CpF5Fhk1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGwisJ001213;
	Mon, 14 Jul 2025 17:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TRsAtIvnB2uuEeFWZ2
	uuWpx9rWmImqhJJbLsIrSoQa8=; b=FtLGWPEKirMg6hy+mtHg+NY3q9OreFssxi
	a8rbrmIo8G1Swkq1Fi1vrmrnCp7ehylONJN5I3eFhne8Zk5O9pJ1rdxoX3LFswVE
	+qlTnluKvUsK62osMUDBlTk4aUMIIypmR3eDju2XMjLateaJy7IHt1+vizlLW5Qz
	90RAQYyL09tYNvu/i7VNA+Jw6HfTSUQ/LZDDDXFvoFlWAjMcO0riPLOB60qkMXbk
	/bQ4L26bnwbavg+gFFpDOEAHX5S5vJOdbPey0C9F8XOJ430Ckl9evirsYR00C9qX
	q428OM/Gc+cpc0HYdIV2yJihFsgLJfnGcV6Zgf4t5rOSFiRWB0lg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk8fvpwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:03:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGtPJl013842;
	Mon, 14 Jul 2025 17:03:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58a03t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7zIKXR5SUZSAk8OYNA1DrfvCeaqZ7a552kBOO978bDpZO0p1EOAf3TlqnwiR1kp3l63xbQdfZH6w/H2gQYkD14wRliUQw61SrRhhgQLFU+PUA5VxXhdATOpAJKApl7XnCo5WmlzCOkUniE1C6ro4tcNKIjIIMqC4zjvld3I83nilLeNRCX/H1RNUPIQE2OaoWfg2VTkuV6Mvv8u2q0xX0ZQKMdpzp/V6Y4pbe47MzzmJdRCEAFUJ74nFPo430EKcMO2eCmhaBt/7rio1B/KqbDze4+6+gI59T2ELaRj56SRNHK+UxHOAhU2nSwEW08KoQz4NDPsoORX16eloSvP5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRsAtIvnB2uuEeFWZ2uuWpx9rWmImqhJJbLsIrSoQa8=;
 b=LnlhrFHjXKAxPLB+WHKu2EVMCOliGfMKLB6BLqB7P5zOJM6crw7s3SXTJaigKa71S0Q72Q48CMwcgY+s7lXpymEHZb31WtfdSXyxVxJujGMDUQQ8d8eyfq46/fqm1lIM96acDE7UFpN6+/p8RiTXAygbn3O+6vh5CJefdKUZHnOV/iVAa8envv6voT1oWc040cQbaDA4LLIlC4Hi5RVZ2J960p1sCsmAQixhZxfD2pIgx5/cDVc7Hql7xqt4GCp1z8LzdZYk8spE9WPaBosfpFS/y6g7fN+8rv6X03rI+n7xqu5L+qu8n8WANChgnMPgRlAyAwlyBgJ9MHFdc4k+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRsAtIvnB2uuEeFWZ2uuWpx9rWmImqhJJbLsIrSoQa8=;
 b=CpF5Fhk1dQgkyMwxZEsM5K2w8wDOMtZSVVx/rRgasNI05eUfn2hTHF2dlhkxpVV7ha6Lr4AA+UyREti/Z87zqEP/AV5gDfv19ct9HwQmGth1+42TeP+42I9ZKGi81xeDyzbbYEv3zRmGZivN34hi5ub6CpOeBVvR7PNF3VQ716Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6123.namprd10.prod.outlook.com (2603:10b6:208:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Mon, 14 Jul
 2025 17:02:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:02:59 +0000
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Steven Royer <seroyer@linux.vnet.ibm.com>,
        "Bryant G. Ly"
 <bryantly@linux.vnet.ibm.com>,
        Michael Cyr <mikecyr@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmvscsis: Fix dma_unmap_sg() nents value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250630111803.94389-2-fourier.thomas@gmail.com> (Thomas
	Fourier's message of "Mon, 30 Jun 2025 13:18:02 +0200")
Organization: Oracle Corporation
Message-ID: <yq1cya2aeo5.fsf@ca-mkp.ca.oracle.com>
References: <20250630111803.94389-2-fourier.thomas@gmail.com>
Date: Mon, 14 Jul 2025 13:02:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0010.namprd17.prod.outlook.com
 (2603:10b6:510:324::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e1a9031-1b41-4988-1e9c-08ddc2f8496e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lbT3ftKcHoo94ZCoaPCN5phygVK2bzoUn1Q65GTuPTOnCUTmJxHG2tnzEj8V?=
 =?us-ascii?Q?R69nngRfJubbFbKTjuoCh0rzwZzuosc6F2lyD5UqalUh2xqGaHwekVeftk/e?=
 =?us-ascii?Q?H9eNScEsiP3KmvfjgPQrvx9LAPgBhaXvc7smYJagda2ny/geG0LPjm5PiYzm?=
 =?us-ascii?Q?dycFvHMG/P8ee69bqcdgfZiHS6J3GJODVmdkE0KHQS1vTTfa/8CWlijYcpvJ?=
 =?us-ascii?Q?WJTGXfPWsKs3oHUnH9TdNlOnVqcu2VuAu326R7pfNcGGAhHU/irodKV3BwUC?=
 =?us-ascii?Q?iylfnHLli0HexV8QoZTOaDLpiK2tOmABh8UfUpkusU9g2AD4S5i039lBbL7A?=
 =?us-ascii?Q?F9HgdbzSPEfTXpYux15DtKOrGYUOChbxjgf50xg4YqbDciCk2b+aDfEi+pjE?=
 =?us-ascii?Q?u09D3PAPcPfN27jUzjbfBIgxQl1WFtp9rgRPUM6wTwud+dMxCdZ5VqXrnwU+?=
 =?us-ascii?Q?ou6iqFAekqwpwPuLT0rc9XVVdFpx/+iMnfHyCYLbNbxz+g3lgh2TNWSn1d2l?=
 =?us-ascii?Q?7RqBwghYg2UkD/AqqKbCPKMvetkbPOlPZAz1U3K/mYEmmx3KT0HLEfsBGhU+?=
 =?us-ascii?Q?0MOrDb6mafW57Vo7kxBh5DsSD8mv4NixSDMQPzUmUzx7wU++6XKV1gsvRo+4?=
 =?us-ascii?Q?NmT/YpFVKUvVsSdEsRFTJFPTdzhj7RE0BkIjVKk81XnF5QVmItRJ4u0CYntm?=
 =?us-ascii?Q?GEUPCzu4FvwBMw3O9qiYPbhLRQEZfS9bn2CwCfrhEngUG+AW6m6d/Rs2knxX?=
 =?us-ascii?Q?HzbVhXTGzi8gUbfgvLgDYANTa5O9Amg4461n84VPeBnMC1+jp9nqOM4XoVg9?=
 =?us-ascii?Q?+bT2KErp9c+T8GUImC0XUvXYGLikzAQVYv0wJFlrk7MgYjXPV+Edq7ldCJ4p?=
 =?us-ascii?Q?NSf9bfs22U0WDGJlJXRmMKYwA2HxTSNEL4q+fvtTcEGYp09ZBklz65xb4bjn?=
 =?us-ascii?Q?ZRufjAZH2AkUQG6BQ9zdxCguKDVsTy80oNWm16NvO3GcA1Ong1q8TjdYAYaJ?=
 =?us-ascii?Q?uR3SMvFJchBgneGxs1/dgu9tw/Iq0bfyPaR/Tod6zx1U74Xt4LfAti7zNXXp?=
 =?us-ascii?Q?rbzHxP81OUYhHpUG9gQrhJD69hfI8Yo2wQEhXnVWXtx3m7NTaz+M27kCstiM?=
 =?us-ascii?Q?JLNuDgpI8sF5EMWq7R8ldorRbSbU9A79HH2dVunTIxTqC8Xk2/Mq8jeUiQWM?=
 =?us-ascii?Q?jUdmK0VAvnIwR/NYaVq/HMSCebIMAw9euj007LU0hpqa7S9mUXU4m8v5QW0I?=
 =?us-ascii?Q?SHsFByYvfltq+1l/7ryQ8qLssSon0BoL2jn3VFaayn5DpaGuiOdT3L0PzMdE?=
 =?us-ascii?Q?GhE6L4STOyK7ktq5Six03KzvLUIPgOVLQkMC3PX5+7bRKFtSU/RTP89unwj1?=
 =?us-ascii?Q?AQVTa0Iy8IUEZzfZwt4Eb5vOvNe80Oh5sYKbhfYGTMAy2pH5hA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OMfkT094RW/s1Ou/a31hEtCfpfS6nrnesddmV9worobLR5SOwgndvXV0L5l2?=
 =?us-ascii?Q?VHAEcVMlaoFd5ORbmnhX7Qhdlv/ps9MHWOvG9DLDm9OLUT6cQplysV9w/sE1?=
 =?us-ascii?Q?Pfc8R1a1jN3bRKcIjASJWGeHmk1sWvh0kFHRqG0UYNL2BRZBgVojOVe5qQuy?=
 =?us-ascii?Q?j/yvhk59GEAONcjkVZBzefAR+KU4rG4qMCbyyq1yX1YU2GsfSvoiEvMVL5v1?=
 =?us-ascii?Q?/4+VWTCOCJzANWpaoWSagAV5Eid0fy+T4O5lzGct1RQFBw2ED+SaJcEjg+54?=
 =?us-ascii?Q?tBol6hrIUq5ifdLPw98uy0uHe5N6+13NZaNUEdW0o+88BI3K8rTVhlPaCHe2?=
 =?us-ascii?Q?BhAp4AqpuKuSbvQA7VoZiUYCbCGOa1QyAAB8PETf6TpQ8ZOuhZYo19xuGSOC?=
 =?us-ascii?Q?SbzuEPzdwGcR4dYE9264aOS3wJVi8rHtspbDP1eJLTm07cVJoPD5LhsdITQs?=
 =?us-ascii?Q?lGZfor/HAm11/YrQsHFJwuaNOWmeESe184zAPCEM8SVnity0agiQcZKdJCJQ?=
 =?us-ascii?Q?OuAY2/2JeDMyajod4y9nG8tKBO5jRBpjadOfIptoWW2o3kJdKQqq84jl4T0j?=
 =?us-ascii?Q?30USTbseRzGnYyLj00UsZ2cm9qXphGZA66qHvVB0gxu+83YdEqIGYB0/7O2M?=
 =?us-ascii?Q?P0QKOFbVVoG/fLz1PbhJGrCXSanm8iRmiQOa/OIiXdmiFGhsQ7e3Awi5iEes?=
 =?us-ascii?Q?95Y9DJLSV1SZCVNkX/8M9adUokiEUPhuGh/96LejV6/BuEy9Bz6aJrtecH9i?=
 =?us-ascii?Q?PLcNsekhgez6voR9RAsaaUBIvYffH3A8WPDS00HQkLETdODLR0fVATPvBqD1?=
 =?us-ascii?Q?VLVo12OaPLYtGnnc8WZcZFZvCR8YH56CaVwLqyL3pHy7HU7QyFxdfRbs/i/w?=
 =?us-ascii?Q?unDoHBvohk7Nei3tXZ27GeJFWdeepGJ8C9SPIXgpEaWb/QhxKQwWQ8oZ10DN?=
 =?us-ascii?Q?vqUAcaBQ/r+E+1gCyyXWMsCunnZXE/OlPqanLz9WpkS52RCe85TGF0RGAv0n?=
 =?us-ascii?Q?+DKJZaiVuEbCH4cg2Ox0weuHuLr2JPMrfC0smPWyXXgu+2cIRjCki89hjtBs?=
 =?us-ascii?Q?Dl8eVs9slhOyDU0EaNO1kazB3UyxDlwhYgwMMd42Y93xf6R6lthGG5A4uaHS?=
 =?us-ascii?Q?J6aEXR5QNBB8Z3Bsn13EhrIsm617zLVozHWwszkcZc66i2lI7JQZ05Z4bVX7?=
 =?us-ascii?Q?KkMvdeE2GQ3GW3UBcewktYVZ9MJlrR9OmHMBSwi2Oqw0jsMMaf75IVz6TTWY?=
 =?us-ascii?Q?rwC7qBDOKGayhZ0ePPxJ4/l3kq74H+76mW7AKDSZfvJgNTP+qNyFMYqcQKAb?=
 =?us-ascii?Q?Jt+DFr1/1DebEB4rA9LX0ehL42escy4Qk07Is22uhzyFQVTcDWyC8aGRlSFg?=
 =?us-ascii?Q?B013gD+xajEBPz3myU8AOcO/fhKu3X7OBkh+Ot9ounSKH1oHkO1d7wIBO1k3?=
 =?us-ascii?Q?TkNLolSHCs4+ptqk2OHhhga6d+p4TIvNNyYTeUTpY+uzwT1ltfc8eFCRbMtP?=
 =?us-ascii?Q?+HJSo0QxWyvgIZFdbNptSUly1jegMfY2szLE614hUG3y6Ph2J9dEBB+Evkjo?=
 =?us-ascii?Q?AwYaZ033KpBgVRcYRIitppE5oZcIrhqf0P3u7fK8t5lsI54fbRodV+aYNiUZ?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	POa/33ctivO9G44ROXPaieqmZQVUfeTOqC9vIdXYrpRAczYIib787AzwiItX0eggWeDFVdzcmOzb/ecc4OOmgY9dYDQnUhpjMeqWhotsbEUldXUVz49R0HXknu/zB8g7L4MKpWx3k4axP91n1K7fZ30O/jIJzHEy8b8A5ZVdOLl3h84Nk4p5zUWAgAtb5GqbZPumLlB5IVENZaJ9NsyrL/NpSoE5iit5U1LB2vAB9cxSo24rbTTwujFqrFJi5+zjCrgjdfDVfa1Nc3qy83amGQBihksJJX/yfyS8ul6b7PnNkkuBm53GTbGNVe+W6SdB122EdHCuQS4LxzvxepGM0LBYW9Uvc/KyJy5qPrn1e7BR3tdpYRiM7cApaYyCOuvOQWS1qsoAtqxV/+3lbSsNOlFCctxeB6HFl2HjlhQ4Df/5AG1JpEhpTMR2M6FQsgbWNiTJalvAlbsd5t3vX6iKJ44LrWA1SbEeszPWjJBI/Yv3Y9PIZq5odGD/Msuyv+e+ZaxQhPEd4oJwe9RSqxLFNACTZ/r4S0v1rWx0eU2rhrMoJ9FLauuAV1kok5XLo8TkwpnHuaB3/QenVAIuQH3TpMIhZa7OXQer1WommwfaVeA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1a9031-1b41-4988-1e9c-08ddc2f8496e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:02:59.7519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BHhfbZc7KfBujxutBOcSDZCJ/lC0VlqFtQzFyHn5nZrDVvQTw230ONF0xDzsXR/+HNK6aF1HPTmPCqo+DdjT4WOvqz/flsrZ4EUhLsgsCAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=663 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140106
X-Proofpoint-ORIG-GUID: 7AJBpRRJGUwIEv_Z_yaH0YQpkf8FFwfX
X-Authority-Analysis: v=2.4 cv=Of+YDgTY c=1 sm=1 tr=0 ts=68753860 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cm9y5QnUeDfAKpJ_UQ8A:9 cc=ntf awl=host:12061
X-Proofpoint-GUID: 7AJBpRRJGUwIEv_Z_yaH0YQpkf8FFwfX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwNiBTYWx0ZWRfXzaGSmf1Q+U5n Comm3BU5mUBHKoBT2Km9SE9VDoOA4oeVGr6WA9VXfD9uyVsv5iY0jG7Yy50mTpzKEQi3s0H0GtD iO7ZdE7z7AgqF1R7RZiTEYp94yRZInmfhEQT2Xfb0OpiTX8L6yMrU7eA6/5lruxXMDKiTUOkYm8
 77MTUS77cAV/muUyZZ1TUXqosxDBp1jJh99iQoCpeNUNSFQ4C31qndOdHbS1M8EuXEtWru/cLvj JuufuyOUIULtAUBqHRdH8TCSMCAihuvQy92tkggCwO5dmlRjCerTbMWmgCYu8VCz9ZU6FM+B9/E 45kYkM7eJtoNcJKckQm6fP5FTfgyknMgECxlbcKz52nezGqTCvUPJ9emv2fLx+lRn+qFnnu06XL
 Q4Ppb7InXtH7SsgcTCnjHl+Dm4WM1Vqj4dWz7GXIpseOS2HZHwDoFXgv0evah2vlFWsgIk9K


Thomas,

> The dma_unmap_sg() functions should be called with the same nents as
> the dma_map_sg(), not the value the map function returned.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
