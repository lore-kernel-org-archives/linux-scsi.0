Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4D2441D;
	Tue,  7 May 2024 01:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715046092; cv=fail; b=RQ9nyEoBhq0mPjGRcipQAq4DD54BafqUEpySEN0PvMHaOb9TW4XATR2ICQrJKxv3sk8EOVk0uBk3dgO2LWSY+a6HEknK/xatDiXzH5l6VKm6kfQbxFWsw/9PZhbv0jqy/PM69JUzJ7qamAYVAHKme6G5ycVAgPzuJJ0wluPjgIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715046092; c=relaxed/simple;
	bh=CoqO0UEyQxo43wlj4sxtF9NpLlGTIT9Og+NosliHlRc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=r1x/vnu8odg/NHDf0QFHxOnj0DlsNGvd72xzCVWY601vcco2lJpYzg5r77n42C+egCNuWETuRaoomnKarLuo7F8+QqG3vrfySTyWLYRTah+/xTzubjMSR7Ck2vCi3T8iQz/LHzpxBDJ+QTeNirKM9Ej+o2c/dw90uNWApvgjvdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SgBhmGN2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MmNTKSod; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SgBhmGN2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MmNTKSod"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Mqk6s007081;
	Tue, 7 May 2024 01:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=i6c3oXUyzUfV7h8HaI/ikg5IGx2FCe/PTGntHAOxHEE=;
 b=SgBhmGN2O3fcB/G95uCoLCxf8swbEJKZizUzVERTW9UJqYVQ1Bs7klahKS1saa5MsF1M
 kyDfJcWfL3WL0nAw+UaguTMj2MuRvCkCHr9GtdXv4fRYElc2NmzKA/m1wcuTLnif+28n
 MbvxcbCzywv5ggxd0FUbF1biEeWEbGV0VBTwGqYZ0mWdjMF54oQMavburQT077NatNM/
 JM8uuBF3HrHo46wBn7qH8Pbae/RFHM3NGbtQd7zblh4j7BaU2vtFpKEQMEPHqbUz/JjF
 xQZNipV5twFYcYAuUUhi0xmUx+kOPkhupDWhJm0eYvzf2SXe9hfHMJruiA8EJT6oMbBi UQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbm5kwtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:41:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4470g5Gh029247;
	Tue, 7 May 2024 01:41:26 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfckv0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:41:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUehoAvU1lCfImtcUSTFqzY7ThnSIAIZUADyuV1VIPDaS8l6lY1XD+KG/+gdD2xeQrdhua1wZ2rWigRYflJJKz80vPmDk3xalH5Emcla8RMK13si+3DENbKoZBlVrib6TuLyPPk82xvzhx+X3qTQuZKLO+/TShZhFRXxvXsx1Oj8sl4jpAImso3WqXH22t9sbx0+THfV9/Eef790BB5h7frdM2+1ZXUfzLUkS4dZnLSaCM1T5262asBLRvPfrh5BTsZcg/ewy1TaLJsgOKmEGBlp8AeNF2q+30LTW7cGXrQlWn3KY+mMFLp/YrM66yZUuMMnbTyppVr4xpB8a0p7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6c3oXUyzUfV7h8HaI/ikg5IGx2FCe/PTGntHAOxHEE=;
 b=MjkSeuii+rQ95cPW9PW5fV9JM0HSCjv4AQeGdaUAaTjeWPRn4ndeIrm9twweB0nFReE3yJQlk2OmeCmn3rdw6Xdfq0FNa/MQTswBh2gQrXovNhUsaVAY4mMxV3mRp1Jt3LIcS9DONRYI4wCDxomYnit4VfR4y3927kPErkXmfwaeFAuyRyPuToSkK1bVqvhAs+pFMvQ7QxpsOyfMQ+p4GSiAQqurm/Xx2VMkZjQVjWXLQ51+ZE3FMBvyJuE32xbLhjWIUfbDh0oEbSYQChGHfEosJdfZPuAk+ltV9PhuaRnVlmEbLptKHBTu9qxTgMAwqXzLvUKAZifw3ie+/IrpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6c3oXUyzUfV7h8HaI/ikg5IGx2FCe/PTGntHAOxHEE=;
 b=MmNTKSodFUfqt4z3jXLhlPezPsOPVnGwY8lw7DC2UvVeWm58HO6RycM8aZFBmSw0ijYlqbJP6DmHWAz/qVLX0bUxCn6qy8XlnjgCWOIhtK9Q2U6jp2pEcnCttgc/aMVoC7vUE7uFDH34gRNIRZF+NKr0R63AcDYAlwtHJTt8Eo4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 01:41:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 01:41:24 +0000
To: linux@treblig.org
Cc: martin.petersen@oracle.com, michael.christie@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: Remove unused list 'device_list'
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240503234419.171823-1-linux@treblig.org> (linux@treblig.org's
	message of "Sat, 4 May 2024 00:44:19 +0100")
Organization: Oracle Corporation
Message-ID: <yq1cypyxutz.fsf@ca-mkp.ca.oracle.com>
References: <20240503234419.171823-1-linux@treblig.org>
Date: Mon, 06 May 2024 21:41:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:c0::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: 618775d9-3784-4c06-c442-08dc6e36ce15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?tGS8zpUPrKBe3PyBvt1gTLgVryJqepU2ADuVWrVGkNPaSJmdEy0PcwHJ211N?=
 =?us-ascii?Q?DrAENyXTHWkxT7XZ8OAcM14iF+h8sqG2DaxtfNs5qVgY+rv2jCZu+Pbnm1a7?=
 =?us-ascii?Q?vF7dTBO2klyPGXsuIRSR02+sik7qwFlycOndB9EYSba8cM9wV0bb7Y1SjH6w?=
 =?us-ascii?Q?AWCA9H86H1Ivr9OkARqEEqFqaVV7AKxu56j0fs9b5HDU36qYSdsiYSJXiZHc?=
 =?us-ascii?Q?G4ExrLT7cJFHkVqWNGTbX2ohErgaFu47AwtD5CQIPvgC+6sqPtJI6KjjHaFo?=
 =?us-ascii?Q?pXTeGQdGwW4wbcLHVMnuEwVDMoZC7eB+8Z+1nKmTBSf+iVy+LUna8Bn0atDh?=
 =?us-ascii?Q?kJ74+AFelQTjehXqNPExxYqofRONGBgImyiTdk9LhDTRY4aotyEPaYTyB9Rr?=
 =?us-ascii?Q?VSgLDInwbDbeXCuklJdBeTJayRkHg62uzuleXpgIFd74oAjtpbanmbOYgaBa?=
 =?us-ascii?Q?XmtN7h7IbOA7/YM8fvmVXp5sG4wmOlik9mNf0dMq8L8lGfUopzRxnSknJGuq?=
 =?us-ascii?Q?qZtY+nl9fhfBxRxOOLdjD95ZG6Ki1Qpd3ZKtn6iquFSdojxUizdYFKdY00Rr?=
 =?us-ascii?Q?zLQbl8IA0ny8KxpfUQWpAiUrfNFwRTMkjWebLRYFulugdQSjDP36o8Qc4zns?=
 =?us-ascii?Q?F95nlU4IRvDfloqu+2m7ZB0WzkUFj6+bHzC0c+Mdy8mEIy5wapaVJloReE69?=
 =?us-ascii?Q?y3PgxQwFu0FFuBTXQ3QAmQeXuyU2LtNESn+b+Hxs4TNcla0kCdrteXKBKMYa?=
 =?us-ascii?Q?AyqowGqwGLHpSsCBbXgF+CyhrBBPeG6S75mwZBUYYeeOtBwRRk7YpPSNGwDy?=
 =?us-ascii?Q?KRmxLKhJ3ssQhkXCjSm5jE03sBaCbup8F6K5XqBfr4SX5BE0PNWL/kd9vuOQ?=
 =?us-ascii?Q?1Vwka9HsPTmBiZlitHMaiq7a5Kr1ZRbEChixVJnU2ZVYCw65gy0IdCWYFnkt?=
 =?us-ascii?Q?kDn/Fzxz1KQKWhoD9gJXjjLqj32bvrqxmt2P/4pSi6j98m2LH/On6mFqd2+x?=
 =?us-ascii?Q?dRd0fZTmRwaXC6pXtccB7576OJlTjfUyIyqvV9BKoUwc/zyLR5EFF7ssygcj?=
 =?us-ascii?Q?5Ii93Je0bjRXYKhsfuNXA++QfTcWh+b2ntvhCFnzQG73q1CCDErTn4sU6KWm?=
 =?us-ascii?Q?XOMX1RfS9LdJrD/4ADQfJK0pQhjko2hxDBcGwqT0UxsX5x+0q+vOXiOksQEI?=
 =?us-ascii?Q?f3v4MOPPnstM30Y/TdnxSPQej7VlStzSvh/6eS/fZAHHJHPN7olen7swCIgQ?=
 =?us-ascii?Q?euoRI2HHWp1fVev2EFaplFt6KkqsMyyl6fQPDAAzQg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3GVlJzjYgWUxBeHSlsf4l718hr3MwYbeVYXfIU6zjk1G74DrlsgG1QSjWgA9?=
 =?us-ascii?Q?/a9JLUEH5U8kV+ceKGgu8W/Au9rkunLxUNhAw1Gn+ZZ7HOdTPKgYMbnz9T9g?=
 =?us-ascii?Q?Tp+qaEp6p19qhWxTIU1pE/p3BrHy2Fv469RDHlwZe+FOxur8cuRgMhUd3FPW?=
 =?us-ascii?Q?thp0X28N0MInDhOBr3NGxq2jxIukl+M8T+sN9WJK497WVjGDuA7eGKYtMMt4?=
 =?us-ascii?Q?MUj/Em6Zp/FjAiQa0cn/l8VHSloCQC4QHWeMok3vnghFh2Q3+5Zd4nhMiahH?=
 =?us-ascii?Q?nDOWIDCxSv9331/aqrhe9LGgrMb8/z/wXQPbZ2R7ApGqGMh4/FNPGHJd3yRq?=
 =?us-ascii?Q?3g10XbooqoK9b3zE03A0/xugRjxDPbdzPSw0vmaHHjn63h2CzyTBWZWn2UFa?=
 =?us-ascii?Q?DVOogiJYoyI3x5YVW9DFzkAP8peXURe8OVK6KU144hZC9pxsHHfA7ZjGzehM?=
 =?us-ascii?Q?PNhcFJ9nILOv9jSWsc2ggmaXzxMWveNcul0DgTHNymVGNS6gim1vP0rfeqwO?=
 =?us-ascii?Q?zmtmsdbIPlfGC4E0usVhN7XK4G5MNUgslR81bKnEGxum0/C83KbQGOTP9k35?=
 =?us-ascii?Q?bLza1QvoYRn21+sic0uo/sQ/PXAM3EmIO6dbPq6P+0r1OGwdR6ChpdgsMJVe?=
 =?us-ascii?Q?9GcFipOwghNC5eA6urPO9SdxACCl97RgcHgpLeRwBMh5dC6uOX2EPXtlOWre?=
 =?us-ascii?Q?j8UPSxjfjk2TDH2HOTooIgwkyZhOAj30J+L14q64B2sMHrUeFJ+GHJobibh+?=
 =?us-ascii?Q?WcNMKVdGakDkVR4cRdgT0nIv7JYLTVqrOIvOcpT6TCaUVJuWePf6DhIPQ3PA?=
 =?us-ascii?Q?VTqR21NVcZrMMyHF6dd7dOcaRyUNrM60WzqFiI8P0OGp9VQ1z9orTxZU1Ca6?=
 =?us-ascii?Q?hIKH2cvqfvl8SurxHIhRWdm6a+H5AHRBy1JiVczSjJMA1M3H5dGUBynAngo8?=
 =?us-ascii?Q?PyI46jYDYPt/Bf3rln2n52tsbqjjfgfzUUX7qMS4ihgOxvCfoGRZW1/RudGR?=
 =?us-ascii?Q?l+wJoeu4IteH1MUmf0nucLF7bfqF8gi4CgKsgxnQ9UTvsOgGJkvVNnrXcrLM?=
 =?us-ascii?Q?2+Getoariku+PKXJbVpuln6NVc/ry64a0x+RrKX+hqk+Fq6u9OezQmV62rzs?=
 =?us-ascii?Q?SBIlRywYSMNym+917Ln4N1DRYunqsdcMOoFePnOWI9RBElk4P8I1j+F6ZN1u?=
 =?us-ascii?Q?MRedhuypYXT0ex4LejDJgGzvWF/TAsO+cto2ScEduEbNJxmTs0y3VRXKBbmh?=
 =?us-ascii?Q?Y/3iP2E/UruOp5EGQHAGYSx1OwEMKF9HmOsWoqMjYiug0FfVaakyEkPMLi+9?=
 =?us-ascii?Q?Cam+wFS5ktACHG2iTcsiMzZpYVt+Eb+lpRaNJL3XybW/g0kzWH7vbS44Q/V4?=
 =?us-ascii?Q?0dF1d9+TetfjgoiR3ubfERsQMcKv7gTTZo1xQfQUuWGPbmQsQPJNFMi9ernp?=
 =?us-ascii?Q?bNOtoPJeRFTRbtM0lGsSn1Vb84Vn9JIckAol0dMtR+tx8Y71YErwwe32ZYd3?=
 =?us-ascii?Q?zjcfw0OWmy85TtX8cuzcsxjElUcEbgZun0/YwQ3K0XmYd9OdEYYNXR2fwjfL?=
 =?us-ascii?Q?vZE5+NvzDqH9tZoAVYHWJhCfFse6WVvUcf1hbnu5XIV2Ar+kFU3b8MutprLW?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kU46af5Hib2Lz5fo3hO9HMYPIc3RSbHiKWYRnixgeZlCk6dntQO3bj5VxBSBZs/3K9RgCb7XPyD5xHV4urNT1iiXRwTXaQwL7cTPznFsxX56NpEMTTvMPKvYLML1Te6nV7KJl3s3F4Yu268eqnZWh9DmpCsBZ4ffVppJXwfDZrcc6Ojyx5IMFpwbCd5l/VOrlxZIKcj5qgRhBA/gCwy5ZHRmOfbjRg9wxUG2clpOrbIQiznxQvwgnzp2tdGNxTIoGZI1YGeSvR6F71JiXdB5kjPxd3TegfOwUuBNZVmC+LCeLosVjngxX6j2F9+rlZEe2JuF3iq27Fa7jzf08wPCTBd6zQTlLVYRdPtn7TBex6uZlLlwGCKPSQe+L2jk6Nd34AqBSRhN1OIj14+2q1gT0JnOUhJCqUkjfXDHR1lqiJGjxbgc4ZnfLBoKUQp+jlO8dZeYRyAOZuhraH+HMjKTEGboyXYWgTGubLOmW4tWp/N0i/ud4Pi1gh4J0Iv/kUCcgx4didAlFbs+el0V76KXiqOU17oRQSvL/idkLo2NkjztoxyXCkVecufIMAc6gIcefcD8htsJeZeMLOuBpEKq+WFvbh6GG2hnNT4kp90IOtU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618775d9-3784-4c06-c442-08dc6e36ce15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 01:41:24.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phHzQcvwDhp+aJyDwPVak4bibzVtlGt2Pi57KmJAwaooxQpz3xfbvRGY4n0ZxmXkIridz4Twi2U3ADtHIwcdR51nVQY5iiL1zNa+8DJ3w04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=753 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070011
X-Proofpoint-GUID: i78jKI8H1XE1ZEc1ALBhMmgqfdKTFFY6
X-Proofpoint-ORIG-GUID: i78jKI8H1XE1ZEc1ALBhMmgqfdKTFFY6


> Commit be50f538e9a5 ("target: remove g_device_list") made
> 'g_device_list' local as 'device_list' but also removed the last use
> of it, the code that added the device to it.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
