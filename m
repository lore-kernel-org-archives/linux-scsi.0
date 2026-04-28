Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1173F23C0;
	Tue, 28 Apr 2026 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777375013; cv=fail; b=ixf1lwpDAR86pE89DJFOYvOI1IamBxpLGmgW4/9jY6iT+OinF2J7EAwekSKXPbZt8tqjWc4lDnGy84d+S9HOF1iMPvfMDzcz3GIMFJb+wLCbRo/SsJGgIHfDBoHalOLJdzqgXnUR5FEujs8w72XivV32NyuBt7EtKTgpZOgnW8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777375013; c=relaxed/simple;
	bh=+0yS0om69iPYCM/zZ5IOd1DU6Vk107kF66epr7NQZDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pXEHzWu02eLLISXdxE4l62hdob3wNmVG8vlFiSu0HkzsD9e2Sdjl6n2ABGbRVnuWOXm79+1UFkDGA18BAVebh67xJevS14SHjCJLVtAxHNTBde4R9xcNeQwKdMiuHWgceFrv8FXVnZ8bAyq7ALTX3BpiiROFjkArDQ5VhCRPGfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ByVsAKEu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WCNZMwmk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ByVsAKEu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WCNZMwmk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SB6gov752744;
	Tue, 28 Apr 2026 11:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Y+KnxtgbmVFVDbLEV1y2A0G5D1Y2jg+NEFuu11zZ8ZQ=; b=
	ByVsAKEuzN7hPzkBN43/gPjsxu0hHX9NNKG0MrLpuBa9qRlUctbhQ5FfOOvmpzc1
	qeqsprGba7+Y0Q0gE31CvDQGGtV/V3ZfBQ0RkgdNEgcZfQcBcIlNl/wE1kHXsHX0
	zx47TFJ4Y87xwA4ccgLGfuyd779dU2Vac0Ch69Lra/aabFbq+0HgUlVO4Xx8DD48
	fEySiKxwFE+79BS5ranS6zcRj/Expo0ulp8l7pQatMQUXnvX4RthwZhk2D4i/5UH
	uk0uAznBYMjVB16YFYa7rRTMu3o0iZcOHsxf4GfFjDEB7jHv/hcE9jhSqLQC13Kd
	8qqYHbWMQ1hFHQcg7lX9EA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnefeyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:16:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBGIft037848;
	Tue, 28 Apr 2026 11:16:29 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cu77h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:16:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=px0XAlQGJdJ1zjwrNQaNtQpA9seVODT/0n/dMeVElVlpDQckLH78Tdj+SKzxDm2JnEfX/AheN6ycMUWgaMM13flLfAZHD1/5HExXZ+d9+xIELtTfCdLHNvPRx1Z1mowTtK71hwRKWfTojPogWzKxKRtsWUhhXzHW3bTPVFMdERNyQgt9bOIwPg3x3g79tKwQAdhZfwm3y6tn1ALqFHSrQzt60DSublHmrtFYGAKAz67y9ursc/gF2gkfYnzy75FaY4wKGTUk4a/Z5WeqFhPaLNozhD22uGaTO1J2y0EXKTNNHCi8Yt6si94fcbBU2PaS5isoR/6uxfpo+VjruVtovQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+KnxtgbmVFVDbLEV1y2A0G5D1Y2jg+NEFuu11zZ8ZQ=;
 b=R6hOFBK10Moa7W3w9efNzWD/H97B0ZZfPLV/DNblhz/wNWdQyXnhe/wjqvpzUUshTOGeaigukgbX6nF6ReZvxrZoNhkVwL1/bN/pTzu35pXwK/1CxggMmfu1xVxs97C1MG+husZrCjmRYDaLwRGPF/C11TtKQuhYt+i2kbI93c5ACOGUI/xH++jkGCGvta+csM8Xnxl5NlA2D4f1BwR4AgYh8Hmqhz5NAQPsxVgZ3ktvBxE4AcpUC2+8e9QjPKavje1g4AZSfzY15ugPBQ/pERcpXFQLj/qfw34aLanp0lZjlh7+8hrEuWdum3wPQmkdstIBlQ6yrNzKaJfY2hDPKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+KnxtgbmVFVDbLEV1y2A0G5D1Y2jg+NEFuu11zZ8ZQ=;
 b=WCNZMwmkDoRC1wbMd6ymURQYC7y9mhj0luy8yPuYIvjKLzpPur/QdF6XB246jUV+z6V0GVY2JKcyuQUNKyRcBf8ODk/8Jc7TM8mPO0qTCn7o0BaXExHSjLBlDhXFHuexv1B2PvX+UWBNHEM/vCMGaMNolk/8Bp5T1EXkN/4a0ms=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:24 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 11/18] scsi-multipath: block PR commands
Date: Tue, 28 Apr 2026 11:14:40 +0000
Message-ID: <20260428111447.1779062-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0383.namprd03.prod.outlook.com
 (2603:10b6:610:119::18) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4fc86c-eee1-47ba-7643-08dea5177155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aX3/qRqPa0b/3fLa5UpwX5rU/Wf1oZbnBq1snAP75sUx1Z4cqSQnDW7IQks3n9kuG2eQMxKbK2oGiFSGvB2D6X8QHJKxcu6uMTR29HXDojXzGPY+XOIQpi33sjLC7RqkBgZYiBSgBX6+MRxSPr1egsF4kdSD69Fcynj76s7ZspSOnbu4tZY9ZGeytLrw/HEqMe0BLdrmlQUg7Ub1ABMAizGO13pRmS5v7S3sjBNNXKKvmHihqvhKWgB3x0xZMeUV6uaDCJkq7gMoz6hpXXFA1dvmPjcwSG2a3JODDgBySrNRIhZ5joexlewCmVlWxUo9Svvb9kgj/dbsa7uB8gCjwjWUcEXvblRp1CU93kE3o6BFmCcT9BEnOo7AXYU7AKI9JWHw9dy6qjlDn2fAXKtzE8sqM3JpDM4C/WxZ9Zgu6Iy+wvzcjLWZSsrBf8L4e+1wY7wICOijCc9PHeJkepfUl65uWUNXpSuZE5HYd78Tfk+jwBgeM5P3Z28T0AtSetVvuhEJgIJ3u7iI1R4Yc/AUtz5Ogp3Q3yaB1ZGHXf90Tl5CnSgWvtN99SYVk7aNZmxAv+fEsLbyLftCVE66z0RExG0W9GsNbqnrVdULA/Esin66XwCu5YpCFm/V/Vpip+pSTz84woNtzKk29WeU9SvCYT8dyTM/72AxANp31wfmdbuDbxjkOack13zVKQajWYPA1/NgqFh/HxO9XsaPFSB1JBa8OpvPuiv5zIjmqhz2HnJNJOc5UWa0p6AhTxdF949u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nj3mRd7hZDC4scXuxiDNzcteYRBVP8T92Kb+xcGUmGB0188230V6M0JQ4D/5?=
 =?us-ascii?Q?nh1oi1A14d5W4ghp5LUWAo31ktY7E721eOv8yPqLJFLpshRB4s/gwEGOWacd?=
 =?us-ascii?Q?fGDMvRsamPo9T+emwWvrBhlo5TjDBvsM5ZQpjR2o+XKbzVUItFHj2VUGGYpx?=
 =?us-ascii?Q?sR/kJaZEOLJDoyVo51hvM4fREICYSgAMtXlDrwx1vbxpbu1q6egIgU4TROcT?=
 =?us-ascii?Q?iSdzLmlqogKaJoGykYRHoul7Cnu1tsiAYHpKOZ18V9DzO0AQYWGQVd3DzGq9?=
 =?us-ascii?Q?gK2/fPnfLVhhZZmOCrUfbzqMyDQdETp0y5X3Pb/IW/GWT61SBNb8E9Rt/F6b?=
 =?us-ascii?Q?OoANaa4NEyQBWPiROo1/9J0dSbzB30BIhEzzXyPahcB91KrBULZMGUnEtR6M?=
 =?us-ascii?Q?Bf9HqDIX7r0pWdFYU46VQ/n1E18rYaLBLetDxsE3JXO8/Pwyer5VNpMoAhYi?=
 =?us-ascii?Q?jN9HTXrzzENoaXXQAlE0KkYtkMAZReFqZTURiVWqQVA6tajQBVuj3xAeBJH4?=
 =?us-ascii?Q?2P1d2g9B7BG81bFxUczK0aFsjd6GuZaZQMrkOfl2I6N/sii811pxvUYwrrrx?=
 =?us-ascii?Q?sFdp63m9st9BO5AgB6++tiXO9CNNRK2bFgFSjywyqEuki/oY1dW51PwQGDq+?=
 =?us-ascii?Q?U3P4RIs7jspZawkQLvdWADLjaAveiAmeMry7+ZY6skkVD5OfsYyVXt3sKiOu?=
 =?us-ascii?Q?yW63Q5ufjkW4Hl3T8kUMEuBUB43lVPM7wqzLcVJIc06kAcmCr9NzoI5wIXGj?=
 =?us-ascii?Q?hlYpPHjmhcCqXYA9+DLWMJ9oXVjZ7sr3oImu5UqKytnQ0gaH1iMZBhA/QKV2?=
 =?us-ascii?Q?oyt/TnBtNhbGlbHbCNYrC5wW7eyf5HWobj0q5aybualkvEGgcVxzL8Mv8ay0?=
 =?us-ascii?Q?Js0XMbEF4gaai2yDgEPKDOBFzyYuJ2SOTKep6B8x/8fN0X489kr85EYkJs+3?=
 =?us-ascii?Q?p+7SyfHbFNI+Kb6200DpCbm8VumLTSfxX9oU1qqfhbJpI4PRtXnkFiKa46j1?=
 =?us-ascii?Q?3tyjMCP7GwJIq9Ohnt5jNHmJ9ZBB7E7Bw2trY9LJmj/vgReQu6OxUNUxg5/m?=
 =?us-ascii?Q?2AA9V0QA9jzyQcJvT0j+XXmTazi8izNERD8ptLUm1KCMH2oEVJbJ9MJxfdld?=
 =?us-ascii?Q?URK9ZV3F9uX7Kq/AaighlJvR0UR475FslDcwDA4bTh3IOGAItTRerRU6MMlU?=
 =?us-ascii?Q?SCRYcfkilhZq3SPW7rzhlffaIFobCerJTh8Bur6plLqA8DHkdlMzg00bOs80?=
 =?us-ascii?Q?IOTlffAnnwi7sgAt5gQfkJOt25/NZ78Cf0npaCZi+w/FjApgJJ5xG6rqBWsc?=
 =?us-ascii?Q?PS3vYXss8i2MHREn4zdyCenNYKFXqUgSmjWyrdvhzZgnYn5mK5aDY2+50mJH?=
 =?us-ascii?Q?F6uLKakFsfHi14DUwlMy2kaygNNxCPk8sYFlf5MsLKpAI1DEi7NBwalNVrQi?=
 =?us-ascii?Q?J+icVvu4dzfUyK847dN0JTenuJiMHrHkuIhF/daF3j8Hah3Ph4XuN2pCC7yG?=
 =?us-ascii?Q?G6M1WCltXnSKeVazJpaPno+W/GrSdIVdVZMsgzjvaiCm5RdxOqAYlHkEpmSA?=
 =?us-ascii?Q?Ik7H46+lXr9hsBg51G2ZfzDwKfHvwP4xGr33LahVvrg6/0lp/PV1qux63RRQ?=
 =?us-ascii?Q?X7dMSkgs7WOvdYY4MCZ0L/iTbtAoU5xaIemW1CX6p84fJ+qVDPwPXkiskWqO?=
 =?us-ascii?Q?HWZWdhH4VeUDR5p7x7oH8F2QgbdYuSsNbt/CMt8W+MQFmEPt320eEfv8bEid?=
 =?us-ascii?Q?t6anwlq5HMXwlJyOZUkSnG8cCXS3Duw=3D?=
X-Exchange-RoutingPolicyChecked:
	nT05K20UZi6QNQQTYeHbRL1wW1mNlmPOTf5kyt1Gb0Be+K7zfGtJEjnkgc+XXk798CUS2uAbc1L2/GDSX+IF7LwPG4B7Fuh1OE+ouMrNI9tlg5c6b0Z31al2pMV8h0HVFeqhZq2gjHDV9E3QkMhIf3dcsPMqQxwvDV2DEh5WaQQ36Licyhav6OqSAzFi6Tu9ejrxAtHnwf66CRbYj/2SDF0D6rv20NaXdli7k6Z8EsJDKC+unHD44VWHxlsGlZx51yIL3FySKYhBQWj2kNF25sbIXFpPf4H8m7QyLBzq8r3LglFn9p1CR/15UtOvRaVm37WkXBc9dKc2AnuF0Ul8nA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	54/s0HDO6WjlfUPFYNa8JyARj+RO+o2a+TjVIRqFzygv+bsaIeOiuhaNMld2Rye49vuR0QUnuLOL8m0zNH5iNpELemRkBhvmkTIuaNsM1p+nQluBvpRJYn4TZ2dx2rJdLCie/1rdE7AkRZfa+Jrrrq5ve7sBQrz0GhKL1t6bZ9ZFbUvKIq9xh84HhxhQHZQ1J4FAng3b++KwW9yMBgGyz2h63ujQgtmC+T2Zg0ZxWALOjBG4wut6KWAKKXbOOqzsbtPQnjlF9lRZklyDsaH16Ssg/1ExHvEZ/9wZ1NtFj7LbAPcCogB3rqucsQC01g1MR4t+Nb7g/1i9JJUa/HqrdwKSLd+jGl+W59pnFbt7YdtVi0b1bQpArBg97EyJOu7eR+hkFOf1jFWwhfFFo4nU+KBdg9oUp2xWjpcL/430AzFWrGNen39EeeqTSZ2WweYI2Sz/IFIUcKL1w2S+Eu2H1END1TIms1KuXizWXiyip75JfOmeJpKl1FHi5Qx9AUZLisL8Et+hmLmRyoXpWQ89Ug5O4dFD1xTAAcYbwMPav7zLXZU4Qa40uZ+QXnvTaiFuR1nmTq3GTlMiavOA03QJEeW7B7fqaysc+jETfVUq8yc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4fc86c-eee1-47ba-7643-08dea5177155
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:23.9562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKlg5cV1QEdvKe4t7frDig5sO2XmpcNethqYnhXomXzUnnYTq0An4pMdqZ/jME2xokiZW31ZpdZa1H9Ur7ZUKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280103
X-Proofpoint-GUID: RWUF5bPn4zjiphX4hDdYimyZ3CBPrcs6
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f0970e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=ly_y6h6M0B6UD37WiEMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfX+P6+/T0N2dAd
 LFGMXzI47gr2uL5OdKBCZQYPUaL2uP4yB6nZ5LyadFSaEQC0HsyLN/sgZ8xq8KhoIaS5/gZU9XM
 3fKABTNGqdib2J16MfZ19U6RRZKcdCanSMmQT/YrxL7qgD3TnaeUkbSlKN0DTblTLn5TM5/xLlh
 aKq4bwvg79JC0iQGLCR8C8juXGXeu34+Ef9T2u2b0cCU7X0BrknW9ABtokskWJyVhstjZap0IuE
 b2zoCqniAgHp6KF6L1M+tmLd1gmS//z3S2H/G9dflufyVJK99/qnev9Kju5eHU+NVYjP3GJwxwt
 VdE0pRQtVv7ZoQ6LdPipXu1uwEImK9rzkoG8tWf3FcaeWh0l4zMqu19O03C7nMOYwVrGvx4XJgq
 SB8NtKBxK9VGfC/BL6ffBzVKMmvv1vUFMA0Cq6UDKVAP/OEg50EQLitvjK6eG9AN2g78JfPW8Qu
 m9kC9FG5WrtYYIALbLA==
X-Proofpoint-ORIG-GUID: RWUF5bPn4zjiphX4hDdYimyZ3CBPrcs6

As described by Benjamin in the following link, PR support for SCSI is
quite complicated:
https://lore.kernel.org/linux-scsi/aaHecneNg9Q8EtiS@redhat.com/

For initial scsi-multipath support, just don't support PRs. This means that
we need to intercept PR SCSI commands for passthrough and reject them.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  6 ++++++
 drivers/scsi/scsi_multipath.c | 11 +++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 46ed669c41dc9..c3c6831af97dc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1296,6 +1296,12 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 
+	if (sdev->scsi_mpath_dev) {
+		blk_status_t ret = scsi_mpath_setup_scsi_cmnd(cmd);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Passthrough requests may transfer data, in which case they must
 	 * a bio attached to them.  Or they might contain a SCSI command
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index a2a21793db895..e0670d353e59f 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -242,6 +242,17 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *scmd)
+{
+	switch (scmd->cmnd[0]) {
+	/* Special handling required which is not yet supported */
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		return BLK_STS_NOTSUPP;
+	}
+	return BLK_STS_OK;
+}
+
 static inline void bio_list_add_clone(struct bio_list *bl,
 				struct bio *clone)
 {
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index fdbdb0e5d02e0..52c80b0658d61 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -43,6 +43,7 @@ struct scsi_mpath_device {
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
+blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *);
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
@@ -63,6 +64,10 @@ struct scsi_mpath_head {
 struct scsi_mpath_device {
 };
 
+static inline blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *)
+{
+	return BLK_STS_OK;
+}
 static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

