Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15908257AD3;
	Tue, 14 Oct 2025 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760480397; cv=fail; b=n6Jb4jpzPY7UQoDwxdxgit+eIu4ratvPuhSUIigQ4o5TNsMTr/ZPNkIQ0zT9v4hQ3qmunGqmiaVFyHv4pCNZ8pXH4ZDjOxvVWE4HkrFDwoanD6GQPuGtToyiHw2jhUVcDcMKhhCUq1OKRneWkNPtq0oAvpooxRIlZtTXZj5F5l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760480397; c=relaxed/simple;
	bh=lr0vpZ9EtaUsWSDewcN1tV84ddYqb6FDjv1BM+C9jPo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HaD7OAdpPRqXXDE5Z4rIA/zegBcjX/OSpGvdP7/794VUTcl9rO5KMCkDA9iHOlAy3sYTBqWSH/jREJa51fvXmzTKYsnw5NUIAryEw+iOhGpmy8Gj7fC/2grwgmmxuri51dMOqs5+L9pnI1g8p4aZBuBdiLdWYJP/rXjjvNx9aM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jb097SBa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uIhxO8V1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jb097SBa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uIhxO8V1"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEf7kn001747;
	Tue, 14 Oct 2025 22:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HLYK9lHhtkx15KqHw5
	5xQs8vftHkNYO/pXskchrKGwQ=; b=Jb097SBa3+LUdmT7mmfCWy+jSPHB4cAH1I
	KTE3s42gk1T0oqSdGKrIf+If/OKDPrJG3nuy7KnxMzsSRHimT2L1EEWgDs4/RlFv
	6nhs/Iterhx8x6iXY51CaEUCVoixtxAtqbEOqoQmjZA+mOBmOfELp8Taxx2IcdQN
	IbsEKkP7mK/DG7pqIpMh4FTCbfJkUthZJjYiNfOzDDe+1dqS6/QR8YTsV+wtRdZk
	pUsBcu17fnDEEBZ5LxlSxc5LjIu+FKYYKXHhKa7aiIkX1jWr2gOyZCzbzi6vWS/9
	G9tT4Y6KwK+q2uG9sGX2ZjXIYAqAS04tpPffMWS7tceGBNTvb2MQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtyne0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 22:19:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EKQCQN037875;
	Tue, 14 Oct 2025 22:19:31 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpfjpxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 22:19:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GG3ydcC77jmE5cdmZblngMY+zYso0RiYRP/Kg6B6lMdQ0K1RJssbriT4A7URepSnOqJhgCFdZbnVrY+XQqYOwz/g6BbCqArI3wrYTqsuciMxo4godD3rBgC2eiLAh4bKX2jUUN+pcvnMIrvdq4OFehRIPdKPHidRWI8eMxqQRDZdBwNAvpLae/EqhPe4PvLpS5oDFansVFaXT0MExGMlOU+nHof1IakN7/NyGr6Bt1eKa0VQMXDmD41qo0wh6jIx2DVMdpPq2sVTARaiIyNi1NmPR40vnS26rNr0p630F+q6RzFkbKtPkSZaFWVWEzqPbUO747t2fRycpu3aj4STmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLYK9lHhtkx15KqHw55xQs8vftHkNYO/pXskchrKGwQ=;
 b=Ij2oA3lUy/QGg4e7WsMsOEakmTHprHHwXEWjOybnC1nrJWCsJnbmVjjX8iQ/RY6I6VfTy6B2Ti7A4aXAhOWDz4m48YkPSyNc1M3N/j4XMQtFCmGmHaG0jddcEmwVRT3p9ahbl0hJnF8QOqobGL8wZ1KCAbHI402bH66z+9XNgs4+vBZrz9xIjt1aTRoHXy0bgmn/sshogX0GnyS9tPEGJ8ztNm/MsdvuXIq6lFqf8yEqe4rqjOQevXZdN90dMMsQQ67RLrAWkdl+eCH2Q6mSZ1fO84diWK3TV07qerRQbBmUeh0eSeC/isW8aZFa7/k2+s2wt7MOcnQ74OgeiuhRAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLYK9lHhtkx15KqHw55xQs8vftHkNYO/pXskchrKGwQ=;
 b=uIhxO8V1gY9HgPkwzbaTEI8vZMEYF09F1YErSD24ZSrB1nFNnpWIwfMzh7t4RU+1kFOfUuARYjvntboMnG651v4Ex5mBu5jl/7SarLioULtqAyvb8WiX2aAl929B2g2gUEWlDPa3KH8z8LXzGN3hHt7eJ5cRvOYn/NFmjrGBtsA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPF6AE862AC6.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Tue, 14 Oct
 2025 22:19:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 22:19:27 +0000
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yihang Li
 <liyihang9@h-partners.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, John
 Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH][next] scsi: hisi_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <0e46139a-bb80-4684-977d-aaacc653840b@embeddedor.com> (Gustavo A.
	R. Silva's message of "Tue, 7 Oct 2025 11:54:23 +0100")
Organization: Oracle Corporation
Message-ID: <yq1frblb09r.fsf@ca-mkp.ca.oracle.com>
References: <aM1J5UemZFgdso3F@kspp>
	<9e0613bf-17ae-407a-a3ab-cbeac09c3a17@embeddedor.com>
	<0e46139a-bb80-4684-977d-aaacc653840b@embeddedor.com>
Date: Tue, 14 Oct 2025 18:19:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPF6AE862AC6:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e72054d-c694-437a-f660-08de0b6fbcad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f+FQAHZDz3wQht3jS79hTUcwKUZpuSK9HcO/w1r7ZSi+vhIUeicCTwunR2Tu?=
 =?us-ascii?Q?jX2O5/M+58X/U/Q5mdKyPx6pl5qg09kD8PndBUUj7p9X67t9q/VFpryvimA6?=
 =?us-ascii?Q?dCs1NihSUdU90H2W+EZaO/HI/49NF5IcxtivS/fJjouHZE4YLhKmdRdobGwU?=
 =?us-ascii?Q?IZFxeTjp1SXLvltkh8m2WfJQl7r3uxuscG96cX/ehpxsv+91RfcvMAUTZdMz?=
 =?us-ascii?Q?spInr8iolqw0Y1PpRGNOgt2vQ+F8wQA9Jf9K1WQcf9KFO1Z2Y4o3d0N77U2T?=
 =?us-ascii?Q?Xv5Fy5I036qqLPN30Ht93DolPD2qVPf+l9sX7JExNbkzrH/jbjF8nMbMYa62?=
 =?us-ascii?Q?TtA0eVz/JV4jFklle3PbrtMUR2JzcbXfdiXnQY8vLIX0Bfpfz1zzJ7N4pJ1d?=
 =?us-ascii?Q?ZWmg4+RBCT4+NsWrAf4x9xtcT2AGvti+sYPPV2aUJWSDLAGcxl2X0Eb/3e79?=
 =?us-ascii?Q?kGRzHFxUVgke2n0xbpKy0QqLLGK7pZt1IXY1tXITqP1x+EEa39+GZQDz0pbS?=
 =?us-ascii?Q?3fW4MUDWi3FPfvzlQJJWOlOVN3lyz7VMjgU+tRN0xD1At3Do5s/IAvhV3HUb?=
 =?us-ascii?Q?x0i5t8UzN2plBW+93So6pCX6VYlpIObS7/za8YhN3YRLHpF7iM5vZdLfhsvb?=
 =?us-ascii?Q?9rx/9KtzwUGb3lHOBXih9Q63bgGTNaGrHqsqOo4izuN2dWM171QW0idzzVAS?=
 =?us-ascii?Q?MiomElUVnLqe3OPl2QRFU4LeliWzp7JLtzLXJLvcPWDt/hmaXa/wxFshWaeo?=
 =?us-ascii?Q?Sd1aVqEJOlpvEk2ZsqMpfZG4Y/J61PpG7/cCOwJ22yIhHCmfmIa095okU+Be?=
 =?us-ascii?Q?ykGYePSqPCveso57L/VKwFw8aLQG5ro9iWL+L5/3cbmpTn/ipWv3X1wttOvJ?=
 =?us-ascii?Q?h+rniIIgQr1c+kVW0dTglM9lvUx644K9zQlmhJr3iUDDXbCHd9mePGABEpP+?=
 =?us-ascii?Q?9rhEthWTWfrGgW3r7y/siIH2I//GVU1YGE8bAFarWMdlrUdbW3WpaVXXQ+q3?=
 =?us-ascii?Q?LRDIxR23A6jV6x5I7S4lKsu2FCkih0XS4eIVI7IqL+nQCtV+biVgN4TiO5BI?=
 =?us-ascii?Q?6/pNycqrj4NmYVGaYckkJYGIk1/Gd1+6Efknb8sPQkVok1Qc7ggdOCVsPs+B?=
 =?us-ascii?Q?UBmQ405cBPk0p+urAon/WQBFHGte6qrAsyoQBrmXzuIJBH2jwh77K6wDNiML?=
 =?us-ascii?Q?XhjQQn5ujLEnPe5p0dk5YKMkGaXk+93dVDuXPOFMKZpKEAYtnTdGECxtFDnY?=
 =?us-ascii?Q?UwQPBW6wesecrUS6oNNLc5QTlwYqc9WVMbHiE3YjmpN7WDnyQExKM6c9gBpV?=
 =?us-ascii?Q?aXZdIPhUUvGVly/or3IIbYGE2ly0aVy5v0DZeBKKz0SdRzvCwyQVh+gUjeOp?=
 =?us-ascii?Q?XpjKFL0KZgbIoiCaqBa6xTwtK/BaXkkLwkV9F97coopM3EHc0I/2UeZfBguK?=
 =?us-ascii?Q?5FpQic64C9z57BokzB+o7HWb5VWi0k3w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lIPc+aiwUg0Hkc7xkU/dbokuDmWHtopKkanz6hSlbMPdLwSN5jjyMB2X/hjD?=
 =?us-ascii?Q?m65aOUbJxxtbmEPAZlvyRlPvwQfEzMd2bNEP+6lrrVu1CLnaTReHvdPVj7EK?=
 =?us-ascii?Q?EnrwLks9AdDRGdAol4cFeVdGPbMH8xSZzfw+C88YfmJDcItqQ8DEB0r+3sV4?=
 =?us-ascii?Q?q4R2xGp6g6fCENZEF75F+1bPEVBzeLiNYEMPOjJjb+GK0+teL7C1O5dqfXsy?=
 =?us-ascii?Q?Tr/YV87eCaTmTCP3kdJaasmulyqlFGTePbw13UPL3yOskS8+QwlYnAkSYhX5?=
 =?us-ascii?Q?wr4WNyM14/zttJBQ0YoeocOsGDgpScRfnBInSIf5pcwR0zSPlycjuCAx+XUG?=
 =?us-ascii?Q?nqMvm2oI6JMHDv4f8O0awtRFvuzPdHwT1hLHgk9wuHtQotyKwg7JNjQj+Lva?=
 =?us-ascii?Q?StIGQ5GbtciqNK/T/51EhoctewCTOcNm3ZgY1mPbvRsFG6FQBShZ+1Np+8LB?=
 =?us-ascii?Q?myo1HZ+ef2sDwJHP8iGIzNib+vzA8SuGP2KVF39bzi+bdLuSvWZFp+iZM9Eb?=
 =?us-ascii?Q?laoLEng/TKR8dfjY7H2jQlACg14l0GXMiHZ1DB1N18m27fcDEUMCQv1VMSss?=
 =?us-ascii?Q?j6gDO6dsGOclIWdotSyzkdA2RlLBEbCz/X4232XTjy+PLd+luR7ahjKIkDi4?=
 =?us-ascii?Q?bIopxUuLX/3hFCaR62s0qTjdT3026GTgX3iZn2BUHpl859HZU2VKtTS85Ja5?=
 =?us-ascii?Q?Fr11sd8nESZnnh8DC+5hqMuQSli3w4V7AGHxnsL/BmofU4TMDIEGEUyPB5Uq?=
 =?us-ascii?Q?UJ1mlu9iGjC6unsK6Hi4/IsLhsBoDwO43dMvY6DT9gNc7d+Pw9mU3LZrlMXx?=
 =?us-ascii?Q?5sfd9NxKv++aOLTHQvkS9bCGCk3d11FivE/FpiXWgOKOArAeaRf+DolAl5y+?=
 =?us-ascii?Q?AF42nVNtsHy1kl5GHfcKQUSj8qzW6zGwCVRQJHwEeNjsZvloYjJgl4LxKmJn?=
 =?us-ascii?Q?QCeAMEmoFavPv8oECSFoxSQxzWpVhJNHTZbbM+DWMZa4q1yAJHLjHAQJiYZZ?=
 =?us-ascii?Q?gvAIYSZGrwH5d40iYp9mRJE/i+/g1SqC2TZZnya2O+WaZJ8omuR7OEOQbaBA?=
 =?us-ascii?Q?1AgkqupEwHIkai34nUm+XRdbsgpdfiO3n+GewJ4RxHrhKlRJ44O/MrEulZ39?=
 =?us-ascii?Q?xv51HZEM6JGVNm2Ra76lxeXqtGC8HPZ7ItNHIhCez5MYzuXR2ZWOg1+XMFiL?=
 =?us-ascii?Q?0VmyhF7iLNqRhtwOLMKPUPZwxnewbVB2oJHXpH+CsXbmROjydDK+9BPq+mNS?=
 =?us-ascii?Q?/uQwL0nezny65+LDBi8bKd9qhf3+ilA9xk4DkjlEUarz3NQV/K2+Vz+xbcD2?=
 =?us-ascii?Q?FjjZ/lCQDmhXB4BBESHvHu7zVIjY37VFJQsKMPYsFjF8DYruTQpPg+GNCO13?=
 =?us-ascii?Q?SF2wlIukeQH7s2nqFWnH20JVZ41vmaYstQAhS3C/fauAwWY5NvQNXFLpiZkD?=
 =?us-ascii?Q?nlQUAX8vBwpi3RFHd01HRtJdhi2eIZOh69dmM5KJ0acxNb+RoXVzOqH+heUZ?=
 =?us-ascii?Q?UZe2rLCXzimUaObEb2hA10BiyDjusy6O8kD0iEBsXW9SHAXySme7iZ2DrDiS?=
 =?us-ascii?Q?Yk4xMvgmLE1xC4mRktp94rnFgzqJs6Kc85hx6FWlFUC0f3DHIV+L68rE9Hsx?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xKis9TbapXhKXS1xBV0X2B4LBNnUp3BFGvpy/NHcMT1T3eO4xvo1pFOEbh3Fox2QnT0zVme10Lc9RpyT5aNYzcwhiPeMryr4cu28xYpSGCeeysX+l+d/e8g/rrtvf4e4Lru3pAS+8yh/4shVQIIkc0ccMcE4FBPA9OcT5oXSfiXbsRilQtSCjE1g+pFQnV83wNEVle4FXiQEn1wacKhLc7EDTu2NpG31FkkD4lTi/WXKui1SRMBzk7mHsR2JiATdqiwgPDYmzSowFh284JcqvSoqwivZnKs2CwEIQyJcxNF7ykH+CZ4lYVWWPaq33Y0EYZdA2SKBsLezwxuByXAnGE2U/Uyb65mEl3+tb9L5vTtJ/V/vUGRpVvDSODOCPz4OceU6/oC7m9pmv5ij1hrMO6EPTKX5hwsBsqrOEd93K4cj5AnhGNqlUvMB+E7R0Oa3iw5GCfBp5+UVetOohsCE5Sa5ns7LhLAhFxC/LJdgvrrXC4b/qWiR8kHQzTLjLnnUAXelgMvEdwTm6UsdX/n2IemqQc658L6gI7wZ3p2TtKi7OAMhT1qXnhgbm8D1s7mx+zLTlzfUN7aZvhlNgA4Y8+qW+GLJcIiwYVBKkTMtglE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e72054d-c694-437a-f660-08de0b6fbcad
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 22:19:26.9783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6USbH2FT17NYR141qidQEKinTM+XtfhL9KlikLM4lQuIBiLtE+zJDmnnOH6y9eKTXMBll+7y9uPfmjbOfvgBlKO6tugHsESa2mYd6Nqlyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF6AE862AC6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=653
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140150
X-Proofpoint-GUID: cxyKPf_YN2plXW43RJyOLiFCR18cWqD-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX5dQDopOi8lYi
 rSZPK4/YlpAw8pzbQSKcMKulcbdoaxrSm9VXXTSUiJMwZB/AU8rxxFVRYkdwFUEhhylguRijEJt
 QvO2ER4T0X9ObUvEV3cproKPGbCLUos/AiRCHuyxgFnJM3amo30ETIKBq1DWxrpSxdUzoNUNmm6
 3hh5Q1CHd2o5BHMuzzwYcLHcrOvZnS+5FREUfEIeg8tFP9eKd8aUVmvqR+dy4zIBgY5lw5LMJ3A
 FhwY6cMmTqrwy6odl5J17u+z1E5xzYwM+FMQvkniZnX5f7iXL2IQoJMxXeajbS30RdO4hUhHfid
 iLR4/7UX6as6s6myHyAtKrmUTS3rsoCfal96wGa+Dhiuout9pZ7HWpUPxGJQffY4YSqts3R0O6D
 bW28RUaH1TLaZ8NEIoZk/8920tMAowwK22MjeHmlnFe89DzuR0g=
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68eecc75 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=dQQz52m_R8ScRV-M_h0A:9
 a=zgiPjhLxNE0A:10 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: cxyKPf_YN2plXW43RJyOLiFCR18cWqD-


Gustavo,

>>>           struct {
>>> -            struct ssp_command_iu task;
>>>               u32 prot[PROT_BUF_SIZE];
>>> +            struct ssp_command_iu task;
>>>           };
>
> Actually, I have a question here:
>
> is u32 prot[PROT_BUF_SIZE]; intended to overlap flex array
> task.add_cdb[] at some point?
>
> if not, this change is just fine. Otherwise, I'd need to update this
> patch to account for the overlap.

I am not familiar with the hisi hardware interface so I don't know
whether the overlap is intentional.

-- 
Martin K. Petersen
