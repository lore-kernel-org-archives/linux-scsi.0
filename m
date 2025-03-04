Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DA833D8;
	Tue,  4 Mar 2025 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057746; cv=fail; b=VcZ7Gu5XOI5uTG9CV6iSZnJcQiRKOZV4vUekU9JgJv7V8E/RWNwAfjmLhjnLVXIyYLTy8JkzIAHxXBCuEd1ag1opD0okY1jJwN8ayEEhFlZwuFkbhk8DHnDfS68ia9c3WzStDBqM2P1Er2X+Ru1RCJDVAxD11vxddzoIWYI/CJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057746; c=relaxed/simple;
	bh=n4Do7EoyxaoD/vwkzMpx8i5uZk842dJCp/BzJzhGNVU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=d455sxJbnww4zUnqUT64k6N9FFR/PErsJ+CS2u5KnD2J+ZULaKrmNwXaEtYcVM13N9lBqmGHvU19UCn2kgF796IEO6v2dKQCg5xTIUv85+F54Lv2Ogm9DVKta3Qd/lbxpOA5sqRG4Ap9WZPhgBy4K0VJnAFEEf9MF1iC5CJp0/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gDslqQnI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ldBjObFy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gDslqQnI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ldBjObFy"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NHX6018918;
	Tue, 4 Mar 2025 03:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=lOLk7cmbBtL1ohxzZ3
	KJAGuDL6EdjFRzoC5L2HFtn+I=; b=gDslqQnIRk9t1VjvT461Oh26/KIN0/q9p4
	qN3f0rRm5Lsx4AuN0jAQUS+UGBiXnqB0qn5/xMrwfbAphgmFOkonTTuVQ2ZzKWDa
	oVXTNDS4dBcWN5X/QiFIkRtrT0PyiobZIsw7nuQtyW9g2nUFcrZi41tA/PwPn9Hq
	QjOGCqkbbxzHH3PS8TETtA0Ee1zTTO+CdzqTYI/C5ReX4WD43MUxlTik/NF2z2HM
	cl8AwhP4rYQ07dC2GS1GkA3d8EopoGBATvUtDPgJlLTNyzpx4xr1sKbebd3maj4a
	Ry8j8dp4bdEhWka2K992GdVuKu7g83+1LA0q1AGd3pLz9r82jb0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u81v384-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:09:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52411Ol3021902;
	Tue, 4 Mar 2025 03:09:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rwuajkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbWSUve3KeYBr6cwfAVaSvxRHmMDTBX0Wo7rk23fKqOMx1hI4ROHMNwy+bM6OVYJ0CXP3D8AGmokOdB5xH87cHS2Tpewz6Zzq/ZAKWh7bhAdnKV1Tar9Y6Wxh/xnQEmsmSGnhT5NUAwSQilyBjP05g1Ww/Q4Sh2qWzpd4tx/hmQuR82dmz7TOzcTTibA+qVYrwdHXPKRw11dcUmhkqrIxcKza6N8DVpkQROPH+WvYZoWEX0LTqAKx+JOy/rkmv2Jh+pk3mSXbbozpabNtTPqfiBAUKqX/NSFyR6M924Bg/Ykgoe6aX/8XGpQB1Fo5cSE754r6GHrEOspcDmbjINf2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOLk7cmbBtL1ohxzZ3KJAGuDL6EdjFRzoC5L2HFtn+I=;
 b=Iu4LP0OyRiP3qerzuHUwl53/yOHpRr70FOh5NrxB1wEHnuQ0f1tKdIsCuW0NvAwkG6W0gm3nl+QYMfLVbKcrYxQQtUqKeVWS0Uir6MuBeD5XweeNYEX19YvuALZW2nSaKpgELvmU4hMXjUslpdWz/vCZElCsiw2kg+5G5+s+hDmHMCX6IFRw0JAJJLa0npRG++239CcTLLaLsUgqekKBi+nE+u8eKbKuDkul9rqvKoy6znmcFC7DqimnBsVJOe6M0RTrcp2fvNrQeLZFnTw0CptqJ7nhDWRtDBil9lpqzr7MMJtxhonBD5ITx2kIr3S/+7+WCgFx1KMGMYskaz5WFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOLk7cmbBtL1ohxzZ3KJAGuDL6EdjFRzoC5L2HFtn+I=;
 b=ldBjObFyrrL2/tVyklKf5bORrfN1Vq8aK8Z75SeOK0YZQum2YbuHnAdGGVTaBcHpB1pvNOzDIId8ICQFBR5aO4ANP8W0pNi6oUHULFfM9YvL3u4aZZ7dVshMePJtkAYWtc9YwtvBHQHeQ5tFEEQ396snKaI0t92U1iXovvER/yI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5634.namprd10.prod.outlook.com (2603:10b6:303:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 4 Mar
 2025 03:08:57 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 03:08:56 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter
 <dan.carpenter@linaro.org>
Subject: Re: [PATCH v2 1/2] scsi: fnic: Replace fnic->lock_flags with local
 flags
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250301013712.3115-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Fri, 28 Feb 2025 17:37:11 -0800")
Organization: Oracle Corporation
Message-ID: <yq1sentsda7.fsf@ca-mkp.ca.oracle.com>
References: <20250301013712.3115-1-kartilak@cisco.com>
Date: Mon, 03 Mar 2025 22:08:54 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:332::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: d391d481-73cf-4a2e-8002-08dd5ac9e6ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tHlVvAyIzG5cwehxfFCyLoC0bMc+YWPm5rfWXWdKki/cUQghNJ3ZwsVw4XVB?=
 =?us-ascii?Q?wK5eXu+gcD8EXeocK8v7m0YNEpKYHqOd4Tbk2YK0MfHIolAC6B1Jk35Q8NMF?=
 =?us-ascii?Q?saFdmeRoYiWiS+PQAXXOEJJNs0XTAmrEpTKdl2FNDGXPyUkJLRSXqVC6wLzh?=
 =?us-ascii?Q?Al1euJc9g5fT9E4KcFtT/zE/htPfBBhob9yJxT/CFkfYMF8F2f5b+xm+i2v2?=
 =?us-ascii?Q?Qg4+W7wW89Q+4N0NwS36WMLqzjSrt9zngEwO18sMBcuIPABsoliSEFaBMh0F?=
 =?us-ascii?Q?Mmxv8usTC80iB+KsPo9vozRdqf6qi3Wulx2AvBpHQjhxeI++xUHL7tCZf4MT?=
 =?us-ascii?Q?hedRsFjF63IPuv4vDkKWaT6+C1dXS7OZz8BVn9txyqecdYsdAZCyYlMW+x5a?=
 =?us-ascii?Q?K0ZZ/vs9FBqmMUzz2KAJp05kh4BCtOeE60fp/im5DI1RBXx6hoLKCv1LiYSe?=
 =?us-ascii?Q?MLWCz7Qqrwoqm5yWqloLeDEai9qjBp7Z7iRNYA1kVIaMC++KTDC9axfFWAdg?=
 =?us-ascii?Q?WW1jGAvazWQWLDlwjUlbEhVX2c+NNtduNaqboN52O12IAFHSwO1LfETDeDEz?=
 =?us-ascii?Q?d9VJ/MDpZgUyStboudHKGmUzbOz2+3KHYsyZ189goR7lKTg0n0ypg7nfn6yr?=
 =?us-ascii?Q?V2fmecgoKGTkHgYkLYPavsE0aE3bv/gGTkNb098ve2CYnrlH+aRdW3o6QdoK?=
 =?us-ascii?Q?NoKBbFBwZMT9L0HUwE05S4bnNz2gOdkDZcSR0JfmAcHnTJJsqL/MjrnylpmO?=
 =?us-ascii?Q?Ny2QWQDveB8AbAbN93H1DFQORYJqwyakTOE2x+7rD2AOtPuS9Zpz9p2dRnLV?=
 =?us-ascii?Q?GzBYk/E8DC6TFi+gp3NyYENivMEKaCxCU4wYng9FocazcQ2i4JE2J+lu0iQu?=
 =?us-ascii?Q?z56h1b9VRkHlC1kCCaEHCbPEJixJAWoAJ32vT3HvBil3D4qreCWfL+vZS1XM?=
 =?us-ascii?Q?tj+x/fWE7O8FbXXlKLtaX25abG+xrnjL4cenKvuFv43sZBOjiDhbjvfNNGqZ?=
 =?us-ascii?Q?OGGx2wfpbGxnOPNjnfWg0hx2dhupxnwOttRIYls9vNvZBC/dqB6l5Oel0ouT?=
 =?us-ascii?Q?yGBQadvV+/JFkmji6KGY1C+VyOgA7NguCertn3wta9lTST+XNIBe/mxpVNdC?=
 =?us-ascii?Q?X8vdM8ydpxQaRb8v1snb4Wnkf1m12f4UUI4zdyq/KeQTQTMPwlZ1mLzhGKg/?=
 =?us-ascii?Q?PxrijPxHpLpqcku4uhxlTnZ4XbxItNLoMrV+9tU3y31O4RHPqPnijfWznpc3?=
 =?us-ascii?Q?iC8I75VNYjobj6KXLvouPpdvpgf5TGmwre1TshtwjGVVIiCCIwhzHtjkiGNY?=
 =?us-ascii?Q?7OEVxpa1pwX4C/EC4t7Z40h9nZr/W0WZ57wbUzJ8aT+brbd8VliIEieNKBs4?=
 =?us-ascii?Q?qsheMAq8NwFTcWylvGD9bYAdjkGf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4sK9Cw1bOHwY20MK+OasGspLOZxbDbV+DdoHVOh/KLj2V5RX3+7Slx8J9B6c?=
 =?us-ascii?Q?Sx725pJJLwWCBSEJJVvP6kA3lKP10miuQi04mU0ND0WiurCck1gTQ6CS9Yco?=
 =?us-ascii?Q?CBwjFT9uFP3TX0wf9NPw16k1zKpSbFRq6nBTz0R584RXfyituRKk+wOrkYGw?=
 =?us-ascii?Q?nBmWK3jtRsSMRQm4ma0bA6KwbkjrNElWw4LQEpnEaaeZSlxhLb97b3ulA4jb?=
 =?us-ascii?Q?55QOe/kkr89T496t90N7/KEa1QOUl3QjroQPl4iW+uD3Gl/jfbSs/eLFU+PM?=
 =?us-ascii?Q?kVnBocq42bNIFk2gRgk4eiPp2PlpdmHWvq1e9dVkKVJWh3eRjwoMX4wctQVX?=
 =?us-ascii?Q?Emyl2MSqMUgordS2l94tL8n0Khvj5RX2Mm9bgDriQTWBg4uhIxOqy/dcaCet?=
 =?us-ascii?Q?5DZrD7YghBlbZIlXx87Vdm8PRDnASakyfH4wSn1Ju7xaFJKMzvAMTQwS3exu?=
 =?us-ascii?Q?WfC3KVZjkzhsLlm6LmxL9zlTPRisG1nYX7ywXBWePDzXbEdPB0r3hrMn3o/J?=
 =?us-ascii?Q?r7WqzzQ3hyPsL/2DcB+GZfEjjKSl92dff+pqbm7nx9OGzduTBP2SVwGopBq9?=
 =?us-ascii?Q?5xPeB8Mk5DCr2/z+6GnHKj/6WVkS9z2J2lsmc465L0d9LavfLQ73Ww8F2KeG?=
 =?us-ascii?Q?6jLkkaibgw3Wlk6+6r4SYTjkkYzRdZ9+4/F7mt7BOOGPOjV2trIu+5Z3V8kJ?=
 =?us-ascii?Q?t+2US4A9JyhC2v61FGTkWUmhwI+s9FRbVWnsFmJbRcpLHHIzObVRk0DieL3S?=
 =?us-ascii?Q?uNaSr+AXJrxDYpnr8HsOX+ari8Th19qqIM9A99oCORVChv+U8kUXlLHNWwNG?=
 =?us-ascii?Q?7jXUTOx1uAtqWkMbJ/XUJzqgCmpewwjmHTsZmrAirZKUY3/aVOOtQ0kV46Es?=
 =?us-ascii?Q?PIulzJtom5T2FRIFfd65art9Bgu/XzXT3zWKb7MfUEKFH380GaGIKq2gAr6n?=
 =?us-ascii?Q?2VKqhiIcgo2U639+T9/NELnXhBiFFVMK4onY4ZXM/TyAft3LddPsL4LRluRY?=
 =?us-ascii?Q?gerWFrG5JiTJgyTOF3+dUdK8q+hQ7uE7HsXwMdyHAMYAx2m6dU2UhYbmwGqc?=
 =?us-ascii?Q?EvojjzFlBgXPrGE3RV9PKIRwyR913kpk12kxZTbcw4S2LxfR8ZMJIgCU8pLA?=
 =?us-ascii?Q?E4P8LnEl6wh1LQMalL4wgUeEbnpJFhYQ6+vQHHiXZe4SuhGzd/DSH1GuCBR4?=
 =?us-ascii?Q?g4QpKKspIiYICG3nHfSWYGXRqQsIT41ksLtPCt1Ycg0C+S5BjOqa9WcgtIhq?=
 =?us-ascii?Q?dbM6J79uxbG1BSCn/n1A8FJaRBcCOffgdtNioPd5Z6neG+wqncjd+k/JWnaU?=
 =?us-ascii?Q?LK0hEh5qcstx8A+SJh7y+ryC6aHoj/e6Wcv3bvW31s5ukhPDyhJbFBHmA/b6?=
 =?us-ascii?Q?6ErXq+q5TYwagMTXGjgeXDFYvCeEBADHUbYLn68iHmM0dBr0RKkJFoiaFP2o?=
 =?us-ascii?Q?fOL0Tidr7ocdfrey9tskxr9Vtg47PKShkeqCtNKVvXNuLML1gQpgYjIFLB81?=
 =?us-ascii?Q?GZXt5cpFdzbUK25E0ghagBHqW3JPrudm3ywD3LQOuGeByAdzSYp5vXoqMXId?=
 =?us-ascii?Q?fk0b/pVkiOJ1uqkoywYRR/IKD4/5NBjh+dl4O/ZGd1HRqDcIXcpEoa/Lj8E8?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wrWkdYt11hzx54/fNzVAdY9rEYeWRDsf8TO2WS/pJeVe0599VZX3Voip3Y50SZNKDDXyg2levFpfu7KYWGd3oO7w8Hgm+ZYPjupEhfiRFE27gN7+ukwzCoWHhs7c8LGPFd7sx/YuVtpgc/kWO9s4OCgk7yYODvl5ugzPYIM19QQRIAdyCGvjaMzCfS9p7g/Id05ejbaJqsdbg9bdv0sxo1n4IlFAineQ6dUHloO0OnmD8e0s/Ab7OxVgq8quRncBppPdRwP90sA87icahP8f8iSW8/er8y289dJUBAmJI50UqxHsR+0sMGQj3stDORNgbx96S3N0hCE5iQo6CiRd97wXhOODjpZFrqUit2g9Mo36UEC8cgo1GW+jMkkkwPd+xJuINjdb722Ki3jHtXJIkdwxqSkMYKQJNz5Prmy6nq0qIGTZjX+rqKv7fhfiSEMPO0Hag13C9KyYpVPN5T7mgv1BuxwK90+7kQvs+sHHk+Z7rW/iR4PAb0f8FprdFGwvbZRTtkKr0Lafkk0e5XzZ4ojWzTit+LQjHJMj2ZuAN0AWyGN9W+JxjLMvK/bHBB718uaZDfO54Z9L2oQIzW9tMpvuQY6EEGN2tVqaioyWOnQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d391d481-73cf-4a2e-8002-08dd5ac9e6ff
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 03:08:56.9053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6P4sQnuQlNxfa3goRXwNK7wankD5HqG/dkq0ytODo8p0hEVPniTCmy8xFFoDGfkNUf30T6MR8Lftb412D+7mjkA8rENT9CI3oDIe0X1Rpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=800 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503040023
X-Proofpoint-GUID: Z1bl6klXqdGDQA8ndcHGeQNObpUEQuYu
X-Proofpoint-ORIG-GUID: Z1bl6klXqdGDQA8ndcHGeQNObpUEQuYu


Karan,

> Replace fnic->lock_flags with local variable for usage with spinlocks
> in fdls_schedule_oxid_free_retry_work.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
