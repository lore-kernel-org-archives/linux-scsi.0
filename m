Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B75B136351;
	Fri, 20 Jun 2025 02:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388093; cv=fail; b=smKfCsFZSR94FxxCQIWkXcbWKYf5KaWNLulfuQpJBaaOqIiJP977D6zn/2KF6aAGywyYD70yknzvotXxmKY5OqV/XQH+K+fGAZOYRyxOat1xbFVApDYtGxLPlGF9Eo3dI6T7WMv7V+FJlTzsER4VY3DDlDF9cngKfQte91eGUQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388093; c=relaxed/simple;
	bh=lLO/WFwAKGSZapb1PYEG5zWkpvzJFwIjb9JtdevWkhc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PxOE9FVVP8Jv80/e2EScfbVPdPwGhM/4dZpyoO++sX2ILc/4PHz13CnW7ki4g/whi9c23/7mIFDY02BWk4gQTSR35mRQ+t2sDuquPhQFGiekYgS3F8AssbwGgyYH6aQ66cKe8pbG7L39u/vP7eQ+1TKh5nT+dKnQafkZRak1BAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mP8DPMEl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RO5PrlBt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mP8DPMEl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RO5PrlBt"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K0YX2V001140;
	Fri, 20 Jun 2025 02:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LP7Mf/wuIHPYlFee5v
	DWUmY3lfWXgt+KdJYckliLeKI=; b=mP8DPMElJ6HZfFKMiwSHmTU7hdL2nZdQ8v
	E6wmFxRmRVdXyXgYV0GyEKfg9FjO2RZ8t614VTvKjaxdu1gqcvbdIn8mSKB7vnBR
	ENmZgCsdRfKXE1Ek2sZ8fke3MTl0f36zpsU62W8H9y3tl3UvQDTpxbe+FCraWB2u
	9JZlfGBFj2/mvas0Oit8c706NGzN5z3+34aEs9N5YFUp+1xPXwyplRE8eVG8WqSd
	aTfCEQGUznJy9l+Ve/rUOMWAinlGX5pJdoNHGgp1FIYORF3lSvfl4SyFzr1gCqWt
	Y65icIZ/VqMMKZlAiQt1Q+usMZnZPGi13CMdLNJhgUVcIsI9xqpA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4790ydat0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 02:54:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1bwhG018373;
	Fri, 20 Jun 2025 02:54:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yhcesx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 02:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cu5s4vVv5giH1GwgUCjsdC0gewF372vnmbcIufKUKmV+KvLPxKRzaGdZHe+1Xr1oYDKsPQetQ850ufVXodfBSBVp0KSk1+jzMw3I5rmX+/bn0o4X+kCV/kOF8PzcVVi28f01WxfgnO3rh8YJgxTUZshBWzxFY+QQUJBM8XX0sKrZNH4XjGAv8Nb75Q5e0kzvsNOecfhIccdDvmteayHjBpFr+ia+h4oo5ZEgp33foBUrCU1E8wEh8gKBxX5ZTdZAM/CCenWsIFkyVSJq6B/ccr945C2/IQguBGpZawWSRQ42B0W62VPGKeMCUkasKQB30mNQERC52SWWXHkARCS4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LP7Mf/wuIHPYlFee5vDWUmY3lfWXgt+KdJYckliLeKI=;
 b=HfrTeL6rXLOLgwE9V63Ex3GVvifD4jvbtwZoxvRwgBE9Z0xtCGR2Qe/WxidM/PUGsP0lab5vMpQ1gEMuYgrLDu9WTFDW3OlkLmHXFrN5Y217KIA8ND/S95dq1JVQJAlnI+d8qS1IoiiOjh/E3h6ivZVDo0LOf827NXPpRvXIYg7r3gk7URK7LNSSOEAVsWTsFISHJttTPE3ie1m0ihwZHCyEsxGgdlQh8sT8Q3/+6U4wkViTUplD64nQ5f+WqmxNQvFzXwEbwsPMCmC/7vC5rQMZ3g/c1oeP7mFpsztJlf8B0rVuUqwe+ZcTTuwredfTE51jH8QcqwNwFqka62QrZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LP7Mf/wuIHPYlFee5vDWUmY3lfWXgt+KdJYckliLeKI=;
 b=RO5PrlBtknY8ZUbjmJss6lHV5VnNDe0fVzOTuNXhUDihuo3/5bNWj9cLc3RQ7lZE2+CILktkwM7HzbTaZ75X0cyp2TmVYUXzy00ynn4kg1wWxcO7pk4Qc3VyjGikSywmcIWOCc9fvHe0W85c9i7Q+Uzwg12im+jlgiykpXL5hv8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6634.namprd10.prod.outlook.com (2603:10b6:930:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 02:54:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.020; Fri, 20 Jun 2025
 02:54:34 +0000
To: Avri Altman <avri.altman@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250617095611.89229-2-avri.altman@sandisk.com> (Avri Altman's
	message of "Tue, 17 Jun 2025 12:56:10 +0300")
Organization: Oracle Corporation
Message-ID: <yq1o6ujt95s.fsf@ca-mkp.ca.oracle.com>
References: <20250617095611.89229-1-avri.altman@sandisk.com>
	<20250617095611.89229-2-avri.altman@sandisk.com>
Date: Thu, 19 Jun 2025 22:54:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN8PR15CA0037.namprd15.prod.outlook.com
 (2603:10b6:408:80::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a1df718-d717-4283-2c40-08ddafa5c929
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tNOuOasGiNzsmIlyufVeIV21x1ARAtJChJ4/LhbV3JET9zXy/ZxN46vP1OKN?=
 =?us-ascii?Q?mbc2xWlWSq1iZazXSk/VoYeLJPJK2Se3GaJpeqppc6EEKpVMkQmnN5Aa7g9c?=
 =?us-ascii?Q?hhN/e9LnvQ5ik53UobOIavoFfF8u/DHB3T5sGSKJChHnTeX1HkEI9oSK1v4e?=
 =?us-ascii?Q?uvRfHiF2Cl1QJfM6XiXNbYJvPHSaUW0DF7yVA9nC2UNtxKVwiOCV1InPvl59?=
 =?us-ascii?Q?FcSxZAYpqxr9EYfoJxb0j7XnRhFn96oJiP+hri4iQ5DIB2xtF+SFiA0Nl6h0?=
 =?us-ascii?Q?2umsbSEZhujvq8ddE3FtIAH1Vd1O4koJ/0KBZzHVWLYkZPChMGn68jQtJGoC?=
 =?us-ascii?Q?2LEH8Do08lFFTIjbTFPcXQbznzAj9wZ532xGQF8XDq7AoflyZFzXqrWfKem8?=
 =?us-ascii?Q?kiitCS7hw4QEk31zHuwAr7ssMo7Hy75ssxEvJd3FFvZDDXXjWTGYG9hlWL3q?=
 =?us-ascii?Q?yizUvKMexpPvO9nrRXh953gscYqEBA7lLds8ejvL/Xn7dvvNOyknY6FqJ1nB?=
 =?us-ascii?Q?9uRYcQvAgsGUTT2xYtiuQ6+tR/NUlx/c1EWfOxFgz9YNOo5tUz6iGMUDxefC?=
 =?us-ascii?Q?hEviWJRJRegHZlqXjHIjUOzxFtFu+ddrtqEH/zBjBpeT4xBI8t0k6KzVO5kH?=
 =?us-ascii?Q?1jphVD7WYlHIbFp4TBVkNy05miTGeKBBHu+Dw/U12sjIgsk2p/Co7L+xNcRx?=
 =?us-ascii?Q?O+3+cdEgANcvxhHcmagRerB2s2VJouvoLP0mB+AMA9dXm6b5DpMi2cSiK4tW?=
 =?us-ascii?Q?fRxcwmQjiro/ryT2RCCOqeZlVmyCRmHvjKj4/tFMrQOu7c7Gd82U+CdONK1v?=
 =?us-ascii?Q?FFo5T/v9x19rXOHQ+KBj7d80jT4m4Aor14VNTjtYoAoGsq6Ed+a8nTMu2d0u?=
 =?us-ascii?Q?zR83mzZ1oD7y5c1QQrGQlniTrjNBJixi4b5TITGuk7NYmHFup+Z4rHhuTFA+?=
 =?us-ascii?Q?rqt+OtiVDNgMwbN0Tyvq7GbosaPFcDztH9LOcszOncTYU58/ysheL12szfpz?=
 =?us-ascii?Q?Suv2hcevsr4LU6u0naxE8vmhWAI5LCSjulRKQPLOl3lB5pO+SByexK50N1MB?=
 =?us-ascii?Q?TKAYENRwvxAR4BvmhPtFnGqRliw3xcK6gqwvkUAbbpriE+HLw4aHGOONmULB?=
 =?us-ascii?Q?uS2cCsk808SGGMNjTRC6T1NNw2d7+ueycQ0zgU4iZ8d8eNrz6qR9JWev6YVu?=
 =?us-ascii?Q?NnIDgXZSKri9qtXFJ2MHeMMuUpUKBh7wx2Px4QuoNEGmApaK+tXuxzxwsEf0?=
 =?us-ascii?Q?2eclhduNxJLciJ4ydamiQZUFbelRICarZnxqKamMyTj3khDpLaGaKe/3JPdu?=
 =?us-ascii?Q?3A650ly8fODdTJibb7JvvUnPDmrahOQDodPLltRTfrc2lWWvYWUBhNTgo/JK?=
 =?us-ascii?Q?Y3rEdHXV7ojLlvbSSDAWZdCpb1O+PIW6x+rGM07JGOG4j2k9peOXU7vjNTjV?=
 =?us-ascii?Q?nZv9MdWUzFM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gWaUSKRiEj/IDkagXGFFPGmln/KPZ6OYtqr53WGUwLL24EHyAhIMEqCNQY55?=
 =?us-ascii?Q?NNGXX8+PQ8P1iwBRa1MJLTlSv4QCpApdMIsd0J3BLHo2Upi5FECH/2fGf9Zy?=
 =?us-ascii?Q?67/XK9+QfyZ88d3ghJYwzukNJyWa9sJJdjzYcCKQ1me3EE32H5owohBfHXAw?=
 =?us-ascii?Q?HwRot+zxz0hL7KVEqYKwR+GKoMJiQYEhE6bCttdiJZ4BCzXvOibncXmgjg9P?=
 =?us-ascii?Q?nyG0eir2nrMLsmiFEBCwWvl+h/oP1cZis2rYnOxIqbRO2oHAPHgTHti3kppz?=
 =?us-ascii?Q?EM/zqvYKaDm0YaSQoTNbUiNMdMAbGmRbyme7q2oFk6pR4C58meLbqCeJjH9h?=
 =?us-ascii?Q?FoHmk1bjm3pYWMsSqUBfg4gBqAEBnsH1zKNZxlRaYQGjRV/Ud/2yFsAzh5+c?=
 =?us-ascii?Q?Cfu+NgbGTKgmz2kH4zbzEaRATDelPB03EAwsno1YtpU8+PCeBK8kyGdhTEo0?=
 =?us-ascii?Q?1wHgGzlF06to52aXQwriEXZ5qAVKiEkLtYOyv16h20m6in8bv3uQxPSg6gpF?=
 =?us-ascii?Q?HnobroVDV0oEDuza1LUPZ/6hkhgafquSmnkG6+QbLGQn1FCbwz9n9XQQHpxT?=
 =?us-ascii?Q?gbGGij+MkyvZk3QV7rsjnz9TY7lQLGGzwaaqpJKsgS5Uy+JYboI+v5wzj778?=
 =?us-ascii?Q?yPJEHYnr1UwFqdHMYYipcyNci2FYD2266RtzlgHE0Co1NE2wl72TnwnfTgWs?=
 =?us-ascii?Q?5WJL+8NAMPY+ihiVaXETpcwHg0kzScvaFyLLosAb2b9k5EmpxGGC4TtpAl0G?=
 =?us-ascii?Q?eHIAOeml9kFEf0h5C4F6U/QRBHYRm8hXFshM8WUv3+fQpR4zDhps6jotEfeJ?=
 =?us-ascii?Q?szfn3pqYYnubFz6UIBcmrIWhYJxZxqwKpQIgkhX9BUQPKevNPvOq+hA7bJ8M?=
 =?us-ascii?Q?ZpFpk2lgcPM7gTVWTw7mVXRjvrrpfoiDk7ykIbm7QUoRwyd6ugRiUfuOKJCN?=
 =?us-ascii?Q?BSEBtsMGjGtSCyMBmqdAnbf1y1VAQANySvo6TFafpCPEQTcfc6b0YBple2bj?=
 =?us-ascii?Q?hgXd8HP2x4l/zjRphs/GT2jlwb7fSfBsYDe7YuKq4Iov4jvzXPS+qAc26mnt?=
 =?us-ascii?Q?kIvcGqerThcCosPmQF6cQRV67I4CfP+hUNfeZ6VR7SGt/fZwOcXl0svxK/Qc?=
 =?us-ascii?Q?m2YZX+m7fD5jRmSu20r7S1P3GY71LZ7Z3F0b3xE4IpgRU4WvfckHuqrmDa4M?=
 =?us-ascii?Q?8m4EN7AZ92FwSUUhl8Ab0qjlRGJdXtHd2lI3MlJ8QaQEFl2zdh2cUNSZUzan?=
 =?us-ascii?Q?JhpECiXg381YSwsmUwyCr0AWt3W6gSlbYXoh7/xNM9YqxXpOiFZNPsZmcnA1?=
 =?us-ascii?Q?KOcdV7hKsm3dDW14Cc5MWsXHereRxOLHPcUNQQsRQ6PXRJZ2isWtp2zYvnLQ?=
 =?us-ascii?Q?08wc3HZhOQZzg47vFrUTTKoZpO0+AB+eXNDfMk2onXT0YIui3YL2NDC3CQIR?=
 =?us-ascii?Q?2oxPsC3C1DOrVNydGecDCAGVj26HycSQZLwHuV0ylQbNwNlomIBdPcKNJahg?=
 =?us-ascii?Q?m3BhEB0G6zaYrldUVbn9o5JHjoO9IvLCIGsg8zlf3WRCcBKN+BpV/Mp5J21n?=
 =?us-ascii?Q?2e0oNFuVjYTizSaCx5upoUfXNuxlgrbz0KEPR+emytvEBCap6myuad/3eZui?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PLkzg6/sFnSqVALaPfy4AhXPaVI6uwsn4vyEV64fj8GsG8iB5jWNIqqbafVp8doy+CZAOHDOPVdLTEwgupB4SwGgTelJrj5OxqpFshny4GSqoF4KqqmCzdP648LGiv9R9/KHRi3ckiz0vlOtsV2QjiJqM+o83UVUzGhxS/L8YYgIs8b0EVexxThmSIoIDaiZnMU20TBknyaYTckx/2PdCEc/9lkomjQ1+3XJy+tg5efDT0i4HHa8+qskWnM512oPgtB2R+ecfgKNWmLTpv5xMsEwWmmnQWd0zFmY1VIaEoGJJga35YythYpGalMxgAkgP4FbYe74be1Tb5urbKd+yfESpk0ijzbwje0+hDGwr88xVBwYuV6iIAneqHhlOZmquY1X7azENZLryM2aNf0Wuq6KsI3httaSShPJf0u9l0HsMmHZL1rTNbnYFUoMLA1A4sHHpRZC8mkluF63JOE/l7sTFjSZoH4Z3jAqn4oGsWdnelda1vaE3yKsDIDIdOUAL/TDb8gOscVOnURGonvIBWuB8uB9zVe4ClJhrQxU+B+r/hmDPUFCamJS/CjgPbjJp7vl4PD89rPfTRxsuXpC2Rofd3K9B0Lf19oLT5qhxBM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1df718-d717-4283-2c40-08ddafa5c929
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 02:54:33.9034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zubhv0tUg4S34QMbDb1Jrvi9HxXIahWyK4XKhcriaZBNyYZBg6oaHlCme+2DPM6E4D87Hw3Vl30kfUrOpZ4yI80DLU08m5AuEXPjdbnYvMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=965 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506200020
X-Proofpoint-GUID: VlgIKNDknKx1FCWZhsW-TUrBmQcsN8Tr
X-Proofpoint-ORIG-GUID: VlgIKNDknKx1FCWZhsW-TUrBmQcsN8Tr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyMCBTYWx0ZWRfX61XilKCaXivd kOa4CVbL0R4hu/SFYDPlJP9IJDKvN+iuju4g438Fq1DpvFFVCLa4DWfKYPecNbPy8ejExVn/+VK jXq2Sm5zklwr1BL19K1899CFIznO3PMn7w5u0pVuIMGFX36/B32rjaqiUpEihXlTRC65C27w7AR
 tDoqVWYOlWXRScLE/6f/DWgR5LzvuawFsKPMrHvBZPoJ1xOLWWHRPsdwd1SNC5+1evbVOgwRu03 S4LU8bMy/1TM5X6u45KlCM8LVedy9wRQTUQRLN1sozqs3sdz1597oOXB1s0ifSbNw6QUVSK4Rul zTkzWo3CyXCJVG6X4qokNtQft8xzShmGYKB0fSJyEDcDyZIW45kzPPsaQ4QI5Me9A/PUVmNQNOx
 fuwF3OHnO/YQPEO1JnjHGUemV+7qegmQM6EZDqFqX7SBpHvwdNsHm8I+x/wF0IB5kGpoSxsA
X-Authority-Analysis: v=2.4 cv=XZGJzJ55 c=1 sm=1 tr=0 ts=6854cd6d b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9


Avri,

> Previously, the response buffer (ucd_rsp_ptr) was cleared in multiple
> UPIU preparation functions. Do it once.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
