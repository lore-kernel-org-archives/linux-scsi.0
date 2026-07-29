Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409BC45BD71;
	Wed, 29 Jul 2026 10:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322383; cv=fail; b=IOw+fZ6GQ4KtFZVe7CcZqMieFD1QSYcq64PvtJ4t6z0IJ38MqX3xMo6bqQABDrcmW5hRN/xtqXDTkYqBpfPjb1QSH99t6vUg/SaQZDIc3FaBLyZNtWqPPDMfdceHH48n1/huc32rTm1SUzDzKPhXEgGQWG4+0yZpJSw6tWscYhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322383; c=relaxed/simple;
	bh=FUk6AeGYoaYpIb0RUBbW28P465n2p4a8RHyOQ4ah0qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jteXwvb2+XhWW/Dj18dWE4iD3LG6rw2IpxTfvJFnE1eX7U+ts7T3msKNcBrWRS6W2p8zZMDAv5eDR8yGWnimVNu4FxcD+Sevz5GuhrY5ep0ZhlaJP/7EGabvNLGKmFhTQwbVp4RwoqTAUSGxOvzHbc0dgY6kTXUSrhRFanG/1+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nw+9Gz1o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mHxk7mmk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nw+9Gz1o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mHxk7mmk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T3A1Fu2948194;
	Wed, 29 Jul 2026 10:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N90Snm7+KUWWebcjcxHxbrFPa+5MwcrSsV4giaWWx44=; b=
	Nw+9Gz1o/SKccH2RHFicPWiBlHP0F9eETrYhf0wmNfMefJkdU7Cg/4WkRBoda2mO
	NoxbsKwk7sel0iIjR1016LlwPhrMSglz4o3fRynN1gfthIIIuwSj7v/orh8Wsiu4
	AXqU4fJSHYBqhgvQslV/BFGyoELezPugDvqY2NBlydczpDx4uSG6LCMR5dH+gFak
	mdKq7NHquIbVixtjYRD7dvA6imflZjlJ5L/CGxrCBkh0rAikMEwRaRwwZfX1QfHK
	358njscUCT/J/GcB6RBOr2M7dmfzsKKelVOAFX+Wci2ld4Dy1Gew+GdPNjg7fSIJ
	yN8v13BfXbuX1jroyRbomQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydqgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAoYM4005024;
	Wed, 29 Jul 2026 10:52:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dt9kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PtoF1DNxc8yNZvN4CjDgV9+/EY0j9e3IicYwdBPWzp9b2JIoGQwVG81XzOj8dk+y9mLU14BTxsvIyVwuBO2Yv59MJXlaslTVKZ0uYY7mWGTHqRx0kjsIOraniZqyl7lLmoREeHF1ttoVtTjVTRU35mJgYcw9WBwelnjmoJ5t0+VbZtsny8bAawYjai7gvFSolXkPODhk6LHKDk2DmQe9HV5TTlNtHJjj3ALgtQUvW69MPeF/Zqt+1KDZKS7YP3ePUwsoFeuQmpntB+BdSTKcT/zTS4LirqobE+Y08lo1Pqtv+77jkbIL0yOeS7AZ/lc50NZ/KZwEsXUvO+4a4SDX4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N90Snm7+KUWWebcjcxHxbrFPa+5MwcrSsV4giaWWx44=;
 b=FXuzYQMFvWAtQvaLlTEnhhbYRRmA2w/Q5CFqIIOd9LwUweXBrZ1cmHCc8v+YgHJN7X1l/tSc3+TRP8lxiKPKMtHT3Yzbf7tltCx+1c+4PAk24Ubl8K8iGXXEW1pUV8+/AIujyBhpIaKKwgnvr4BTqVYocU+rFJyENZeN/kVCKBog3bsGGMWWtA/aVkVKz06lXZHkqpeJPGfSFpPnjvLD1Po1YKLrMj+Uf5eMaf89NGVWE4PvfINfCcbg65PVv7TQW4fMeICVR+p0nyrsBA0WBKmsJXn+jfK+PRlxMV17JJmukcAyiO9rie1FXiOdykJjbet7VMEjf0RgLhUWlbFemQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N90Snm7+KUWWebcjcxHxbrFPa+5MwcrSsV4giaWWx44=;
 b=mHxk7mmk3OMyNTfFE3hkeaLp2EiLWne11XnmdQT2vkqTWrZpkkSeV8fwMyedWhvuUqz5k/xFYIuRXUl0e2sdHHl/ziFHufkge++Zmh9Qq0xfVvoa3OO7gTnYyTjfD9ZoiP3gK09Imi28Bt5giY9MD3NEmWT85YRHfP16RojQDA0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:17 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 21/27] scsi-multipath: add delayed disk removal support
Date: Wed, 29 Jul 2026 10:51:01 +0000
Message-ID: <20260729105107.255712-22-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0173.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 1798cdb6-772d-4e1c-8d72-08deed5f74cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f/OJeo8Pz18vmdHXlTsLbyNxy4D+3URtTtUdCVrMp6CJkydLEe4kncO+hbyaM+wbvjNrianGxZ2OJP0CMcwB2YdpBWTDk8ZlHBDYVVjcboQDJiR2+xiaiADz5F7E7vVwg7YjGHmNm+ivW3Rcyh9+rH5gq34DjEijXRYb6SahOslvEjLH3hWuf9zR+QxfIkNXFGYzoI97LnoXXbVhjAMHATYYX0qcMNY38gaKkQcI7WZXUS6U+qPcGCoPMLEnkLtzmViAsJpc/LHYNGo3zuO1Kruny7K3Bb2lut032h2y04lP/U6lBfQ796e80I0/sCKd2C5U7yM5hGLGXLTWxJ6yKVKppNxU6MnnjksPEqcgBEUf/7XIxrRit5F/de35kODRFg3/Lh3UicMeGbpdCu7AV4Km8HmbmIc976V2iM3uRhfT7fdkU1aqdb3EAaGeauK9hWrdSBpvD8VN92XZga/9ee+8WhHwrFLb88UdhF47/FFglayj/KmMW+fVRRq9+sy/jKSCSTJ58SRHZdW1KuNhD9v/3RMSbrqeBC+HmOifImEO8SExqQREnOpcsovAf5RpNmxezJZ/JcsTlR+JgkPDI+5Qm8+So0FqKyMsIMm/U4t1G0hGAH16+jvACQ0n9kG5wv176mW6PC4dG46M6E+IDnB60ZK+Rjgy8d66oPztaXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xry9HFjodEl9FIRfg72BewkOWMQ68n1JMC/jpifr+n/RRZEpXsW9FgNh0P0f?=
 =?us-ascii?Q?w/JyqOVHKr+3QBsNEo3VPN82Vke8z1hlGajwmiLA6uOXZ9c1DCAnfGvzG2De?=
 =?us-ascii?Q?70kfxBvKdGBbNQNZQQzAA43723fy93Y7A6eKePXKsbQ8hzsCf/HZaZQHa3w1?=
 =?us-ascii?Q?COMMlvfQ6JR2Yr6IO+4j6t60Kul4tioGRK0mYC3wsmSLBk7zCE1qWKbUUFsu?=
 =?us-ascii?Q?RgsSOvh4OcPOT98oIbVMAYwIgmMSuKjX7rMshQixHe7BsWMVGm0okrXbsQSO?=
 =?us-ascii?Q?dYSUE1N3qJbZ/+uyp96nGEeBo33N/urlg5diwF7heQtlT7djhcz4l6Fe6Hna?=
 =?us-ascii?Q?sCdTae+cEXXu5gTb+ItSaokuZ0Tgurs+1zom758u2V6fTkxGRKvI8lNEcx3C?=
 =?us-ascii?Q?mjkqP7bvt2U54hUXCA0iEKHa89s9dEmTuy2KaWK35Y7G7/7jS/Mel+CqCu9m?=
 =?us-ascii?Q?qYGm+Hltql3+taHcb18rS6aUx7NBeiiAAJqCYUxAKCmRylStJK9BhQ/jYiho?=
 =?us-ascii?Q?cGExqFmr6aLMqwvXKr0CEiaqzvC4qNb9ELcm+LLXPBFbBwwXX52zbyBv1/Cn?=
 =?us-ascii?Q?BChJ6xW/zbTUn3lALkb/u0Tqc+UmzQoHyp8UA73Taow4i+aI1c03noRs2w+a?=
 =?us-ascii?Q?q6+d9UkRs478t9vuWjAhn29jBCIu0plWI6MozIYMs61v8CQU/b1Y9UUIXF84?=
 =?us-ascii?Q?PBkF6WosFnbd2tbi0vIRegJgXdsjpt267bLitsGzXhN0r96Pcr5Dl+jOFZIc?=
 =?us-ascii?Q?dXCLWErwXNWQUdCqtUhNMFNG9VZNV4FNhANF/mKG3OV7zH+6LV3Xb5XoUtUy?=
 =?us-ascii?Q?Pe37lllOD9q5x4jEiQ1WL4aV/Ue8dBtVVTIDbFoA0m3h5ImY6J6x0rwQ3HfK?=
 =?us-ascii?Q?L4U+g9rCEb6bc0yGtByi3QgLuMgtJLzCzNc7iamAKDmPBEfZNzotsxSzK53T?=
 =?us-ascii?Q?ZOA6n5/1cmMJwzm1Ejkvm/18wCiDy+yDqZe9/Cjig33RN2m5R9gQP4GLOOzp?=
 =?us-ascii?Q?5H40l2TiHUrSoExxdfl3a+kRJ1D1R7q+Ymc6j3rK8oNgG9/zGPaLmaH8oK+9?=
 =?us-ascii?Q?uNm10bG66rESUru/KfHtFOy7r5OQ5Dxr3gIPCgfqqm49uuJNriZVQapeGzwG?=
 =?us-ascii?Q?RpAWUognBFEr1hLG5JqmUCT3U+wGcuaRsEXA8dLD6ArXEmsmV9AC/CH0eERA?=
 =?us-ascii?Q?wU/E1dchDSz9VwkK/RViI5poP5W1qsDPjBYJxr+cESVU1Ao9JA4/8MG7FR/k?=
 =?us-ascii?Q?FA8B/K6kPnTbSGTaQmEwBuDgJVriF7l2hqcJR3QVB8U+FN/vXFevxs3jml9/?=
 =?us-ascii?Q?ilByLLnDM/bH1jFz7eXKYUhmLVYmi5BShqAiWBZ8VhhI3gcdrRdDd7Pq9hXb?=
 =?us-ascii?Q?xpOCFjFP31CYqBCY2tdIh8S15XWmEsLsBGJod+Y5g2rTu6QL9fbx3au2ezie?=
 =?us-ascii?Q?h/lO12uU4XCmDgArEjT1Y1wWUi50w1eF9wuvjZeWm5i6Av7DfX8LqhXshKCk?=
 =?us-ascii?Q?18Ff75Q6BpTNQ9TgAqAulwAQ4VpJ+v+xDFNi6jjcNIvk2R6MmzdY6hyeTJrp?=
 =?us-ascii?Q?yQyttv/ZZMjNRBU0BiVis9X+wfYFV1xvDjbBjM/v1VHDVHv+gzRtJMtOIDcx?=
 =?us-ascii?Q?kcXvFmrM+Z/A9UZ4/3EEqUPhomyitzmMJB7YHt6oXNh2A8X9xZjRTiH3Xs0k?=
 =?us-ascii?Q?8Vyma/fOS6Atri2f3hKBbMBXcM6JpS0i0KQ4AewbljvqlEdlkjbLbjqp777G?=
 =?us-ascii?Q?qSAewvo95g=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	aoZ/Vcpv5CJWFNRU6EiF+dv8xRPsrqGgl80HveLo+0qmbn/nRUQm/RwZFr0yHU6y/N05oNxOOxir86amR4TKzvCQuwdfnC3cy99/qRXqanSRSB4ZrGHnUMjg7qoBE4ODwNkP7O/Br9yx0dhFkpxnmzL0LtTLVpdNxLkQMafz7EfXx6mfn3auRkBUsYsFXGr3O3PBsyf4dtG09g2L0Fe5rqj9a8kh8iFDV7UW0isE4EvlJOf++0F7jaS6bRa8gRmVV2Eeuza9KOmZTKP6BJwVv0IQO2k61VK+uXORS0LqZfRUD3gQ7GJd9hLUPNpWYLKitbdxxpzb5zuBj6aZvsY2Uw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4NBpIlqi09g/+l4p/o/tVjb3AIQG7pvPqlrUXtJABiO32SlLr3Dov8fKO01S3zFrk6TwQu3mx+RGA+L12Ac9u+PRXjMTDMBxYwIpWT0Oy0W0rXopaoVDO3i+j+mTJ30RxQajav2EmNllgci4Nj4LpPw7VPogYs2TDgmtW3Bhfun6kLOrMuNYIALQv4DadIMsOvQL38x7Zv9A1LjRDdrhlQw277/mZ8LcnS6D6ubOf2DvvhtK32hJKqiqTQEqsTwmPwqQoSeBmrIxwXwMhW5pJMC7PdIYVC3Is7cGkaP79kVJKy/lkHmTwb+WLaRmSnOFNH5cpfDFfCtzpWGs+zlZGV1r/xcioIar/7IlM1rWNcfYq6w9FO1SQtOQ5u/WqFBudCUqnwQYfc0wIzYP/OCOyNbJrX2dI0GYkLJn8++tFE37c5hPsMnTPwoKXYVe+M8hR7EyLMEjoqlTn5SvzHXuE3VsqkA3B+HwYiY46vQmY7BTpXgqGgGMNJXmDUU33RCE2bibQWT6yMuI65kmDO0ToTcvm+aOl8tLbm98vglzoSMF2vWZKE9YM22y40p5vIv71h4uAeZV7F/CcCmJBVBBt9DFYmpiXDZtnlaeXosoD00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1798cdb6-772d-4e1c-8d72-08deed5f74cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:17.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1ra7qZT1QOnIdjvvIAlL+0ZgzSuV7f6QUMlC1T4qjtueg4pmyt0T8hSwcrl+XiuVdDWgpD2HdVOh5NRImBNyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX79S7fooIt1fm
 iKifoH8ISBI9HMLyrhIMcrjPZTACaXkZLwEy6CNw1VGaSWQq/TOITtimA6+L/JpE12rGJBHgLtb
 kg7B+CnStlQXS1fH8C/GuUbgkkG3mihrrdtEBZUS+1x3eLrr3+nM
X-Proofpoint-GUID: Sp-SGJG2Ji2ftd8dRd7tR5b3BqTi-wmJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX6bVWvoI017Ub
 FK4SNR7COzyweTd88JtMKju2eibDqXfhkBhBNobdqHEbFhFpsM0z29eHAgHP+2Zy8HkuMLQ43wO
 cYRpbOmyAWcblDnTIFDSksh3FenLODyz8jhU5ThspieDsIqEFWYDAHtmFmP0ScKzW0KF5y/jEqy
 P+zUJggSpgSivivRXSt53M0z5Wbo6lgf5tJXNzBjri2ikKpMpAlrRz0Zqu8O6HXCepXC3FXQK1f
 RKVoleGCEvjO4nkao9RTevoyJ1/WtCi9gAKdGv1xgjb9NwdQ6oCcEW857SXmCPozDyuJvyLQpFK
 /8IH94JNqe9qxXGCChVOi58iZQPgBYtVbSBlG8Ih0Shltpp+FnzQmg2xBc8euDWqT9rsemn9NXE
 ZQjcj5iK7p+ZyA0OV+jCJ/c1BW2hlUuRj9/NTubjbRkQl3TKNJkVc64PITnwZHeRH/5ouuCNV2d
 31oQ2wiW/pF//pt8hkJFPnRNNdZv9FjX1CObPndo=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69db65 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=S0-NFRiyq58gb8qD-mcA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: Sp-SGJG2Ji2ftd8dRd7tR5b3BqTi-wmJ

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 27 +++++++++++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0adc5adb4b234..a42e20d33e422 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -367,7 +367,34 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+
+	/*
+	 * scsi_mpath_remove_head_drv() could drop the final reference to
+	 * scsi_mpath_head, meaning that we pass a free'd pointer further
+	 * drivers - take a reference so that won't happen.
+	 */
+	scsi_mpath_get_head(scsi_mpath_head);
+	bus_for_each_drv(&scsi_bus_type, NULL, scsi_mpath_head,
+		scsi_mpath_remove_head_drv);
+	scsi_mpath_put_head(scsi_mpath_head);
+}
+
 static struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd1..d92b63d357f2a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.7

