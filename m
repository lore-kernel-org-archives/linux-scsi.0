Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07CC1C3039;
	Wed, 14 May 2025 11:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747221123; cv=fail; b=gUcwI95W393WEZOJbcaEQOHNviWib284Nj8/nuZMXZULqRvMgbzY/86ohAJVQDN7EOeorZsmSA1uzjkE5LUws+fw1B9SSatolXUelx2XW3kPmIxmC9NhCT6plCIjO7fN8xHLiYsVA2mr3CRg+a6kuN92BKkmIxPZqIi0TOSNOI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747221123; c=relaxed/simple;
	bh=dYndijV0ZZBJAYi0zahfXT93MLrh87l20b4xkp7vsow=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qduOVizjzlYaJiZUn2pcwtAtLNWnSp4rouGtyu6MIid83HZXNH1/8ufpRgHi1tO4Xgj5EtHM0D6qH5odISnE9O9v2wlOpkzQfHzNmUttZiz7aTmpdi+Jb26ogI2wO2/PoerYhbDRuiAdMVOLBp8D7S0fGlhQ801b4KywOtALt7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sZSe0izI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vN56L5PK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sZSe0izI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vN56L5PK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0frKm020048;
	Wed, 14 May 2025 11:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=41+AiOEzac1DaIYXFWZpvEIT5/S3rp8SKlPjvrdORbU=; b=
	sZSe0izIt/M3+60shvT56w4qAaixfCrTXi+Vxn/siAY/C0l3u8a/IKC+oAGUcozr
	9npT9pj+/GCYrqbMltfgzPjiwO7V7EHQOLN35Lc+S7tVnTZCMGEUHuYy0ws5fpT2
	ZD/A0IXBPsowqumyVV+hDFTwzGfY1dMk3V2IUqP9mUqLHmS/cVBSOpZZupuDUcnb
	XcbMR4lH80Mowe6uv0lCXKz63i8e98HW2omK1S/ZyEfo82ESGkXxMdjoJOlHTCA6
	22rc0lEC7Fk+xHdcBf9p4DjhE+rE22LsTedQ0E5Tw+YINHEyjh0qvbhQHbyFFTS7
	1B5rmbvbMN4lc+GNPYRXig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcgsayw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 11:12:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EAb5MC033281;
	Wed, 14 May 2025 11:11:59 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010003.outbound.protection.outlook.com [40.93.13.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbs92bj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 11:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KykpIT+8+K210Gq5sHycCVvE7UxZkvOhf4rMA0htxGwd/vjMWYIq3yvxoS0KZC7xGlHEnoAmK7ZOEhSCdNdVKn3BTKmy5dqRT7zeFAb3G5FOE0T1AsG70CpPh8Xh2jIFgrJqr6kvBlKEq8T+919hP5fF6ahPDbx/b9EU3yTVqWXZMbngo4jQ4o1Kj74Md4XQfHs3saTRlq0niDnH8VRymx9n5971DF1LJVD1eLIDguZQGT7mqsclIFlAN1D3p5sWKYpJHHYxHXiCkZAh20BtbVG6/VTqZGPS+Zh/La/mhCcJyKqXRYVUzHKJFXgpCH0OzzhpI8OF8Y1pNEMQieht4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41+AiOEzac1DaIYXFWZpvEIT5/S3rp8SKlPjvrdORbU=;
 b=SytDS5Qet9DCpU0qcYvWhoInPhUHwpLBZX5dDTzhYGAzxAO4Kt7HaKTDNRDId0WEnqXIbcziebLqlK+/+vGGSOdCvK6/IbqYFWVvhJ1suZRGwVyz6S0wAlhYGAht684TpnHGY6mAdKe8zrlZrb5uz0l0HdAH0J06n6nXAgZ+o23SF+Ch4r/om5knXlS/WAhsLYDKR3hckv5lNFKvfJ0aCWUjxlxkbKu2L/PASjJBmbwTYw8xfeVkGBRyyuQlM1ec6aFQpKabYF0u0q/Klsd6S8bwoTsfoUToY79KT4dxWHDINWvsCeOGISTSHoZaIvABn8Hgvqywy6L3wvbPlDBHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41+AiOEzac1DaIYXFWZpvEIT5/S3rp8SKlPjvrdORbU=;
 b=vN56L5PKFz2jSqu61Gn9dgoAtgiWj/EvcOzUw3C5JSOJO4b/3IYuKDzpopAtGFZHZsvnGGw9aG3ZvFXo7EpIS6TLawjE4BFETaR8mjlcHvy2dZobbKOoMroPL4Jk+Ps0clxBnBspChGoFdYSNJUUTtbQlaNsKzdfnfnDru34Aao=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA4PR10MB8352.namprd10.prod.outlook.com (2603:10b6:208:568::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 14 May
 2025 11:11:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 11:11:57 +0000
Message-ID: <2b02b3bf-3408-4cfd-b09b-de8fc01d9bee@oracle.com>
Date: Wed, 14 May 2025 12:11:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: target: Rename
 target_configure_unmap_from_queue
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-2-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241008020437.78788-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P192CA0025.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA4PR10MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: 36c48e9b-51c7-49c7-1d9f-08dd92d82408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmZJZiswazEreVZ1Z2VIcXVvR1Z5L1hmM01sZ1dDZXZkelB3SldQeFhITmh5?=
 =?utf-8?B?T2FrMHR5Mkw2Y0FXbXJXVnZhbG5tcS9KM2kzaVhraytNZ0xWb2JaRlljdDJF?=
 =?utf-8?B?UzRjU0IyUkpzRUVRVGVFV204SnF2a0ZQbjBPY0pHRHIyd3c3VEhiazExZnlE?=
 =?utf-8?B?ZlJpa0lRVlJ4YWVvVHl1aEVtcmw5NGovOUl0R2dIVDFrcStSaTM2bWxoQzd0?=
 =?utf-8?B?YnFMbjZpRWhlY3VockYrc2VONlpZS3gvcDhaUEd1dEtDSU1BOGw2NmZTNXd0?=
 =?utf-8?B?QUFXcThaZkFxTWdTSk9CSlJ4U1JhUjJNZmozdWJ0MDd1UlVsYVBTZGNEWG8v?=
 =?utf-8?B?RHNhelhFTXRMSXVheTBqNEZVM0dGYW5JWXJTTUd1cXFLeW9veXF1bUd3WFZr?=
 =?utf-8?B?UlRRTWhJNGZKY2Z0SE4xWEVnK0hQQjBLcXFMT1VBY3o4ODg3TkM3RFMvemgz?=
 =?utf-8?B?M2o0Y09vSndycW5ZN1MwRDlvbHE3aEgxTEpSVFZBcUtobkRsaVd5VTJPcXJT?=
 =?utf-8?B?N1BTZGNVUncyZ1FwS3d5VkkvZFIzb0d3SWhhTVo0UlNmSzNLemhHaWVLaVhj?=
 =?utf-8?B?U3hqMnVuclhFbnhOcGEyMXR2c3A5aUMyMU9oZnQxS3hOWkJnYWxYeXkzaWtJ?=
 =?utf-8?B?bjd0TmZReTdIOE85bDBrTWdnRm5WZFhCbnhhMDYxc3F2bGRVd1loeTcwSW5P?=
 =?utf-8?B?dzVzM0UwM011ZEk5VEJZYUpPSHhyTXpKeUpWMVVHeDFLbVh0Y3labnRCTHFM?=
 =?utf-8?B?UTRYMmJMWUF0RHVqS3JYdGZ0QnhTQWhkeTlQd2FjMTJpT3plOGhsTGZKck80?=
 =?utf-8?B?TU5CRXlEMHJSeHQrRlZiYWtTMzhjbXZoSTdZQXplNysxR0ZGODVhbExyazJ2?=
 =?utf-8?B?elVaZVBScTRHYU9lTmZhY0RFelZMQW42S1NmWjYvQy81TG1CZjI2UTF3Wnpu?=
 =?utf-8?B?cmUzdm13MUg2VUltSURGYlRWWFFyd2ZpUFdPZnBFQzdhZXd1bjFBb1NUajU0?=
 =?utf-8?B?bEZvMEpRbjkydlZ6QzJyYUN5eWlva2xnTGRNYUxVN1cwVHJsOXZMWmVwUVRp?=
 =?utf-8?B?d2Y4bVc0bk9haDlaUmtweGc0NXIrVGxYRmNNMmpDZzUwNXJMeiswK1k2WFdu?=
 =?utf-8?B?cEd1UkFpbnVDMmtBemxmK2VWZ2djWGtEemgwSWRUdmgrT3A5VkxIVmZlK0s1?=
 =?utf-8?B?Nm9qaC9KZUJUZWNRRDhOclhDaCs5a3dZUVV4WkQ1SnJRUjYvbnpSUUxYZmRq?=
 =?utf-8?B?WitRTDk2UVhUNVdKSThxQ0xTU056ejFhckpYRTVkODd2bFFKZVFjWmsvOGJp?=
 =?utf-8?B?a3hUZDVIUkZFTEs0dHpGSENncEtuelRJdS9pYVZ2V1FVejFqK2ZLM3o4dDQz?=
 =?utf-8?B?ajlaSm1Wd0l5SVU0dEkrRlRQTjBKNVEyTjdvTFNPclZJejJIYndpM1NMcEVD?=
 =?utf-8?B?SDhmYVFtVTEwQnVPSnFTc2o2VlpOUE9sQTVkRUYzZGovcnB6MGxsd2I5TzE3?=
 =?utf-8?B?eUpVY1lTa3F4SDRva25LQlROSVhIbWVyYm92cmtZVjYwZjZ6V0JXMXhXYW9x?=
 =?utf-8?B?R2JtV3FTOEJyTk9ubVJNSWZ6K0lRa1dGQllLZkl6VzV2ZHhCdVJ0WVNoNVNt?=
 =?utf-8?B?NkZYUDVhQXA1N01icmpKUkJtRzRLaTd0MDQ2RmQ1UHpoNUVIdUVSMWZydUlk?=
 =?utf-8?B?STRYU0FHN1NaaUNIMVU2alB2RWRtZ3N5OVpWT0ZCWE51aDBTekszS3Q1dEpx?=
 =?utf-8?B?MWVKOUpsQ0ZGVUQ2dHZObzFlNEhiYm5tSi9LY0tXRGd6QnkxcFJ6ZVFuZ2cr?=
 =?utf-8?B?QUtTSEgrcTVrb2R6MmJWcXF0RXN1U2VEUVhoSTNaSnYvU1Vja1pJMTVBbmlo?=
 =?utf-8?B?dTBtanJxSW5QVzVPU0UxSzlEN1F6dnkxMk9LeStodjdGVXRBTGV5RlBhMStT?=
 =?utf-8?Q?qFMk/+LxSk4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3hoL281NU5weG40UUdNc1BrQjdCNGYrL0djVS9LUlJRRFZUdGRxK1NGamlo?=
 =?utf-8?B?dzBHOGdCUEFVSEFQN2Jub1JGb0swQTVoMXdmaitnb01jbVhnK1c2SUhFTmlT?=
 =?utf-8?B?L3ViZWphNDlnRm5lL2VOZkZoWFZFaURYais5MHJwckpGZVM0eVNDZ2Uxa1hO?=
 =?utf-8?B?OVVhK1BDWG9veFN4MmpHTWRscmhseDUwcy9vcEtpM1hvOUcxd1ZmM1ZMZkRu?=
 =?utf-8?B?ejhyc3NsZG9SNC9PWHFwUmpmQWliV1FOT2FLSzhZNEl5SnduSHdaY3h3Zngy?=
 =?utf-8?B?RkpQSzR3Ris1MTA0dWp1UGFnTTc1ZGhiemFzK1dqSDBUSXFRNUxQeDhKU1Rq?=
 =?utf-8?B?MU96SFErWXp0MHJzSkhuWWhRYmh4OVl0WnNGdVM5VHVZYU04bWQrQXlTUWhT?=
 =?utf-8?B?bGx3L1FwZDExLzBpeHNHWDI0MEZMMVNWTlIwdEVHWXBlMnozN3RzcGRKQVk3?=
 =?utf-8?B?SXJhT3ZwUHNhS0R4UTRiTjkrVS85SHJPQSsydHVSd3JiWnRuTXpZWGNodGhy?=
 =?utf-8?B?Mjk1dUd0RXNoaVhvVXNsY1JRZG5ZeHg0Rnp4cjFpbG0vVGJJYTJVQUtOdWU2?=
 =?utf-8?B?QkFrK1dvdkhiQ0RBNlRudHYwbzJieE1RUVArbGJGakFWSzlJeUtSVWFja0lx?=
 =?utf-8?B?emRBMms3K3Z5aGFwTDM1UVFLckhDSnBVRTV0djdMQUZEeXJ3U0d5em9NMmE5?=
 =?utf-8?B?RmhDT2MwM0d3dVFoNDEvY2MwQnpXVjZ3Y3JjeVZZZWY4REZiWHR6NjI1aUpx?=
 =?utf-8?B?TVZ3WkI5eU5RN2tnY093UmVFSjhXcWdCcDBMZG94clN1K1R0eFkydnhLSVpt?=
 =?utf-8?B?KytIN3dTVklEUXRpMzJBVHlSQUZWQUtGWHh0MTc4Z1hOdTVmMmpTWGNzcnJZ?=
 =?utf-8?B?ZHZPUy9BenN5T2ZyNzBNUjhBa3hEY3pBdVZHcVgrekFHbjBIY016UEovaksy?=
 =?utf-8?B?dVhXNkJEV3I2ZEIyTy9GbzdBOUtGZDhHYlErU1k0VzIydlUzQ0c5Nldmb3JB?=
 =?utf-8?B?d3V6cUxtTTBKQkhqMDI1TE9QSXRUZSsvZkZrMmtVdDV6TytJVjVFTldtZlZy?=
 =?utf-8?B?eHk4RXR0T2tkc25RWVlXVXcwMXZIN1pwMDU4RGVYRHRVS0lOUVE0WTF4V2Fq?=
 =?utf-8?B?S1g3SW52cEE0V21BUVVvenhzL2Vxb2NZRkE2Z0kvV3MvZEYrRTJDY2p0MEZY?=
 =?utf-8?B?VEpZbXBiMkkzYkJ3bnRwQnFoYVpJVCtRUGNwLzZoZDE4d2w4cUtFZzJUWktH?=
 =?utf-8?B?UGJIVmQ1LytJcEVBQUphdmxJcnpkeUFLNy93aUVuSEdnc0JPb25sRUJ5elJy?=
 =?utf-8?B?Y3RvM3pCeHRYYlExOXZ1U3NUSmpIckw0R3o2aHc4U3VpdGJtcm95Rmd3eGVh?=
 =?utf-8?B?bEpMZWZxbE13OHVIbTJrSG40VnU2Y2x4bWhCZmhwR2tjdk1IUDNwTmZlU1Zu?=
 =?utf-8?B?dkFaWUduWDBjNkNmOEIwSEZSOTlleDVQKzF6Wld6czYvZC9ndXNxRjZOeEFp?=
 =?utf-8?B?M29uR0JsMy9SWlBhSGxzN3kyNFBPa0VIZGNnMlVQUUM1R2dsbE5hSkRNTFIz?=
 =?utf-8?B?aHBudHh0Q0luaC9kOUJ1ZHZsSSt3eVY5WUNDTzJya2FNSFNTWUoxOG0vdkIz?=
 =?utf-8?B?bERWSFlaRjJKdVdRZjZJVU9jS3ZlOUQ0UmJFSXQrU3R6WXRDVEx3eFZxd3Yx?=
 =?utf-8?B?Q0NOWW5FbjJ2RnFjdlpmSnJPVUM3SEovaUVEanZ3NS9obE1tK0o2cm5TUTVK?=
 =?utf-8?B?bU52V0ZkekpTY3UrN2NsK2NaWlozU2NjZDV4SjlNNS95VFFib2dzVjYxMFJQ?=
 =?utf-8?B?YXdYem1iNkEzN3U4M1J3clhIMmJmejczbXBVVWUxMUtpdll4TVBuSWtzdGEz?=
 =?utf-8?B?bHNJWGdGMjc1UVAyb3hsT1FvTEgwUllXVWlnc05aV2ZReWIrNTJGTktYc2c1?=
 =?utf-8?B?aTg1MU96ZmozNG9hY1BQSXdTWXR6OVA2bGhXK3g5bEdRS1JDYlhmQVpUQWZo?=
 =?utf-8?B?K0pkY0pkYnpLQjVjbmYvVExjbmNyMjBIY3BYYVBPeUU2cTIzNDFBOERVNjhQ?=
 =?utf-8?B?bi9oUGFDbXlJN092NzZhaGtTTWx5YXhpYjFKNzRHTXJuOGJLWVUyMG5YSHFt?=
 =?utf-8?B?UjdTclBHUUFsVVVrbEVmYi9kMFBYQmJQTkRBUW5XckJlRWtJaXkvTGdneE1D?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MQrplVl5ToSpkLngEeTLSvgptQO1gl98Ybw75cpa2ijTsBP2L8t4CcYITyzmLGZvrXUj0qeDet8Xi8lXSvYr6CdaU5Gvx5OgJO8fXUc/z2LxBznPlKBsISMjl1sD2AnzK0msd80Ba9G6LHwy1gqz2FGpBhjU+s0Kmbk04JDpe8DeMotgdrqR825JAh8r+pSzHwb1rCa3t0xmr+Uae/6X1gAcUGoZrWrLxu+iOklrsosPMKOoNqlLR5X/ANwAP67KY/70wZWt9yXZ4Bjtebtf30lg7FU9iZ3VhZV7R5zD8Gg761kWmJpXyoiyzB1pObT6vrYa8yQhotqHKLIXc2p8N1FTlqjqVrf47I594nRjrC8jSRPYnksfmeap8oMe6Hdq9ORcaz+U8pNwOEOsgmks9AbXhZubMFG6rW4vJ+laPVpLkeurPyaRpBNK6h0D+O1vwuPLFx/Er+Trz1B2zTfmu1/iTXqsyWZ/Bqfp0X13LcZRcyi5tEsSHJxh/Z9l530PsNFD0kGfqZIM2SyE+TJdSkas17CX4i5vF2RahDKbAre0aDxzDzkXPGW64ZuW6xLWgrzcE+/4FtH+FjPQa8FM8gtVKCTq/figRgoCWPdBgns=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c48e9b-51c7-49c7-1d9f-08dd92d82408
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 11:11:57.4379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXvRLn7quToQwfdefUoA19wso2qPSPXwSorh7SF9OFPPrqu5UOEb+yZ9zODrGAg4ZrwQnh29HRqZr/6jfMkqxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8352
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_03,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA5OCBTYWx0ZWRfX/AG14zONCcRf 5B4K3qSRzLbJy0WdYHySpc3Uss5ii6g8tE/YSgRJUX5tOROuJ41OQM2Y99Sk77i54T09dG0PTzz JdKnkjKt0K3JmEfGxRCEsw1SJRqmINxF1eZS1QkFOA9LAOqGY8zgewJrfWJIDIslXnV4q09w9Hi
 JRmwkfsiBlyLV+jzzy+qvg+WerPshz0mGM/j5G6P+ZLLfAMpsMDn13CLBc22F8rRUhj8AmGzsGn /Y+KyyTKlZLhHu1uRDwG060BrDtToyOje+uqGuEC2j8gxZQnLdFKE5uQ3lvmPVKJM3sxBWXaKsU 18ZK0H70UDTpLAVmgyQbYO8BgJLSxZvAe9c5l8Ml6X8AwMak/W/zjhyeFvzvhGwu9tNrw02GEpo
 DRdOSerXMyLxCgDk/hT/6/an2KZ1QffyXrvrSil+vCYN5KAcJjtM6uga4xAlQpDE2gKEYOp7
X-Proofpoint-GUID: VSPrcBgG521QSjZ3kfemnjwuagWcp92A
X-Authority-Analysis: v=2.4 cv=fvDcZE4f c=1 sm=1 tr=0 ts=68247a80 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=xIQGj7NHZ64fYb9qIXUA:9 a=QEXdDO2ut3YA:10 a=3LduDf9ZifgA:10 cc=ntf awl=host:13185
X-Proofpoint-ORIG-GUID: VSPrcBgG521QSjZ3kfemnjwuagWcp92A

On 08/10/2024 03:03, Mike Christie wrote:
> Rename target_configure_unmap_from_queue to
> target_configure_unmap_from_bdev since it now takes a bdev.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
