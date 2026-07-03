Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FFB3DC4A8;
	Fri,  3 Jul 2026 10:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074765; cv=fail; b=Me4Lo0jKHCmJYtDDRaG6TfciECUu2lxe8QJyXi6ZOAcjjG2d5DCmnuDbjmaNdU3EC5kU6hN9EcKqF93kRwMQTXKYqoQOkJHP/iwyVyGMJX1WhLHy/a3f1rGTwu7FFdI9oFtdiQ3CXiMHtnhed2B2EpwiD39rrgCLEpLlDbShQJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074765; c=relaxed/simple;
	bh=UKS31OMd4IK/1wzMxrC98CdC61gt+o8gxNVAimgX9KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lZAX8EsU4mC4mj73c30+tmpHQXOHdhnXYdBqMVfJEBEWCaB7qpoOsl7QB/o3ESJwvpqTIUhHSG/89fU8EGCh+LXlqKn/KmqaZI278bFkrtSabRe8/Tvjz2u6dgj0mrm5LK+K+7lKcOKGwkQgYncD9Q15NIrDvvM6TzUXkW0v3zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V954Py6p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fk0gm+HC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V954Py6p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fk0gm+HC"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tmn63112855;
	Fri, 3 Jul 2026 10:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PnQWFqZmx8M0cmY4SmAqUv4nIV85umQAceVCd0rYo+4=; b=
	V954Py6pzZtTP6EvsPGOMorTV0O845bfnk7XJsZDdL0/m5hTe36oVP9sxfZa4+Gg
	egikYTNXDqzl6om+tFFZH60X+pvvEXdBG3uiFuCpNsgPiczlOtkAdD3bU3ppp0j/
	Hm+LgDmt582pyqZB6kEfty5RxUsHLsyu8JJn37POvP8YVdr4ibNGrKyCZMXhq7ve
	/6qNJ6cXs7jaI7iieL9OJbnco3wPFqXVnzHYnmg+99yXdeSck+Er0EyZo7J2ztrW
	XrmxGmfx3THFR1pfhwBgq492qiKUyJGjOTpxMFY15hujaBhk7WvJA1h7KDt3qgFF
	/UZPgphhYsTzL52uHBo6xw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfjemv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7gD013121;
	Fri, 3 Jul 2026 10:32:23 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvrrk-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gLCyI2tjcUScdfumHV5yuYe4YWY7wMAPacMzjgyTBdxjHNfMTnrdgjvLRd4aKUp4bPdyPfDEuBYstpYOVwDGLX+gMDLJoymqXm6mZflcFi41vTk+zKFbYYBDkpxPVzg2jwLu9ibL79Gr7utgHurDw98MnGdXpxrDTATJaA8YvMkVDw5/HpKa4A4umWC9UW/zp3bKg6++hzvH+fkb9zae0v+kAx8M02zfsNThbOjr32th1N/Imr5hHp+fBwqMt7rXqCvMPFcUJXalzuYfAVsp24HQtnIL9EDY/GsPh3C36LcAsVEGpaCBe/WsWkzeHIAAmJTyCVECYtpbYqodoGGDHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnQWFqZmx8M0cmY4SmAqUv4nIV85umQAceVCd0rYo+4=;
 b=QxjzPP769wUKAwJGSDdX7eNld+GYoZKGTU2LhCsGqNNfL3FEklkDsMEStj6AvDdU2bHyGzLP4iMHq1CejFk4uYoRkerw1oFcwiNmqvSaNtHdQn82DKaQDDoyPf3MNpSH2pvZQJry6HjJy94/X2B8/x5KKwOtdypTKGhhe3kMpqwiHsaG/PjhvVDhyyGSOWhmoNtnh+8lUsqZcJyqvo25yZI6YFeenaO2iFov3j9Jq7oB34fElYWci2ETDNR7B5gNQqPPCl1ABOIW8ANJqHJ552onZUZz9bHJOleqlF416k5IqU6vf8w74eUg2PVtWk3+WmhWXyHsEJUwSXNoy3lteA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnQWFqZmx8M0cmY4SmAqUv4nIV85umQAceVCd0rYo+4=;
 b=fk0gm+HCRwP+OHYShU3k/BtDhIVed32PwX3iE6mI3qEHUjO/Pk1YDgIDm3OeeNnIoyERoJl4jChUVq2hoiSQ7W1fRdJF4dHLEPWb74mXgidfoNlxnnlnBq2QotDcZmnDFUqLWM5eOy6H7GTYQfx3pExMhuc5NlKIo47q7YhRPbY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 04/10] nvme-multipath: add nvme_mpath_is_{disabled, optimised}
Date: Fri,  3 Jul 2026 10:31:58 +0000
Message-ID: <20260703103204.3724406-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:8:458::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 20409801-3226-4a73-142b-08ded8ee5c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Ws8XrnpJX6U2sEhgbaT9R+hQ+63O+UtQoaR80U2ZnO9jlWxCm3+fYB3IumOVPGlGdREq+DkCGNq7WwajIjtfALviU0Ev/+cYyPtoxIBrxFQKbjl1w1RcYMS8nB6RbCPN+BEHqxDhc2z70vHBo9E+gvmm6+JZmczdqRfUPmNFkyhZFOgXnVbuhmbl9i6iE6pcJ5AVNvYxdAe93wCFxVOwrRL/N10qKNLqjlhtp8yuaEn2mahOvQ5yiPC072PMYv8StPKsGrVrjOxSV/+N7MwumtCToWqsd0oXCQJC6qKN1Ut0rrS7Kqgei4+wtCLEvt3aD/jB1heyz380wGWBqMEydiIdAUoqXELsphP/fNDFPo1Z0RY5VM1FOYQe+iVAHFAswzJDHHaozE4ZsjJ/STaKqoS0QBuKOtL8n8XM6PB3oiN+G25krcMNNoCox5hzQbMFDzf7BNB/d2WnlIM4l55g5rMtG+rrulZmX3U4MPkRcSjsNdDphu1isJp5gK+v+MVjKHs2/DmNHXi7ctzlF/524yjvF4IBoX0ID6eXwiwBITa4v28CeT9IOl+B1TwqjzYjt1mpo59IBJMpJbdY5rBqx3XBklNdyBLpb6lOWln2CFCAi7q2NTcxlw0Qbd13RgyhFRFPUQrM8XOd1WKIKGBj10JzgtrrrARrDR2NLXg5tjw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6ajbZtK3qpDb5/k0gZqqjLZUkvKKIJ2stEE/v6a22Kiqkc+7DtVCmiu/v93I?=
 =?us-ascii?Q?njW0SuTru44mxhOxYzXOL2U9//fYgM7ItoWKNy+iugBYlmWj1Nla7xcCfVQg?=
 =?us-ascii?Q?N9kLdFqwh38IfKqRUXj0+Rxp+YH+N3LoeR15YCHF1jrz2b7Fp6Y1tDHP/ynL?=
 =?us-ascii?Q?xVeHfz7ldvRbjA2wgib3SvWZlFmIak9/2b8jXuy9F9bpqQ+NqeG3d+IcdSCK?=
 =?us-ascii?Q?rn0jTPtpv0JVGcK1Nx52XjjhBrgxTTBfmjYQeKSrUOg42xppKjVGRkbl4hTi?=
 =?us-ascii?Q?Tw4xJEiXgMIh2cNs8BaENVUwKa4vNOEO619oL5QNrve/VUDBGEqtpVsp64+t?=
 =?us-ascii?Q?bONDb/w97+uleOEayuR01STcyQPh2fZAAeufwTUMzH5JAfG7b7nyGH+AsALd?=
 =?us-ascii?Q?rFifUlOxB4syjCg2bjDnvBc0IOpiekxo5q5ECyCLNOCkc17SnyTGoRSXed1f?=
 =?us-ascii?Q?Yvly71Cr0ITPKbIxCQ6AYRD0Jh3uHas35Q8Nk37diJnlE6oqpdBh56YRhGeW?=
 =?us-ascii?Q?ziNoCKTneCPKDf1RpXkVmkytON/MeCFmJ4peOykAyEd9TlhzguWWni/tvw0L?=
 =?us-ascii?Q?mt6+A4nIMF4AtXC5yZWcIraSblYtC6JgwALr6jWujrN16lcU6ffacJ9KYRDC?=
 =?us-ascii?Q?AuhFBrpM0bk0c9RptN/dB9YmdjS0qQ97zlDaMF/aJnstukxlbr7HhKsP8OdS?=
 =?us-ascii?Q?G0C3Zs4iudqyWJRwlBWS55rMAHJuLGEVhzRH41+r7Kh/yh7IsqZPDg66/Xhm?=
 =?us-ascii?Q?k9+/qNM1KNYGug9Nnxt6c+0PUgQ73w0LCTqqq6LRliFO+ACyWkYqxLojSA1o?=
 =?us-ascii?Q?zVObmopbbGaKBJAiaZ0UXodYxsAL18IF7rrseJtU/IrpnTf1L5Hk5imbvh3O?=
 =?us-ascii?Q?egaDavMb3JNG8QbVUD9urT15wg0JL/X4vP6QnMA08ff8iSxdJPxGxWt9LlMf?=
 =?us-ascii?Q?wBsb8g3JcLguFMWv5zUqgc02vVGRZN3906H1zqA3mfE7Iomqjdkcr2CJXMJg?=
 =?us-ascii?Q?FlDuHzrBXZ6zLRptUSnIb4zSysL9D0GCR+j30PN1WUtrL9JRaqG5P1xKsJ5S?=
 =?us-ascii?Q?u1mCw1Q2Vw3C5eFjCLVuHj9TNAJJwiPk0G69tX3ZU1ZDYhADBpSozyMR2Ea3?=
 =?us-ascii?Q?S9cB+8QGnzcLOj3fLieEgzBkwwucAQ6l570KEcVoM8B4GcTCGx4MXhTgLyy5?=
 =?us-ascii?Q?VYHbQe1++0OjFHLWnmXOjFveVQ3xfxIzSt2q0y85y2cf0m4+AQqXQKFks8mR?=
 =?us-ascii?Q?pXRixqvRQwypdVJ+EjVEVaC6Z6r8OhD7AmlrLnbuAMALTvtBgiuZ1UTzMN8h?=
 =?us-ascii?Q?loDOGxEZ+3R+29gzsEs//eF1UpYXk6pjKZx1jjcNhPfCWVk0GEv36u8ZrGoM?=
 =?us-ascii?Q?aTQC7PeX4xx+OCdbgJ5/1j7u3TUvUznxbboawjYQdI+FCOmDlno3VjNI53os?=
 =?us-ascii?Q?Q5fKqy7lANgxdw7h8HJiFN+NLfDlwS3yOdWpzrYFogfOig7IdVIEvV8odklL?=
 =?us-ascii?Q?GlsE6Ik3/G9mxvxd5G34RGowfVZB8/SwpfaXgVTIpuL8MQWXqtYjrRIHfLA7?=
 =?us-ascii?Q?ZYnYb+OIZHFXh/h2Uxc3XvWuZFpK9Qk3L73YsjyE5w7GQwDwIooqwCaVYQmC?=
 =?us-ascii?Q?hOlYsHR69jmjjq0Az9moykXnDB/1oxYDzTm/TGQ38x97v/caJ0wjf170pedp?=
 =?us-ascii?Q?ui4kxfAEhgd6sFQnqSlrb1j6lYypm/KPnkIcIwNxgb6wLPzrRYPHvJywpo0i?=
 =?us-ascii?Q?7NOI1f7bklzwIoRYaYFDczJwySB287w=3D?=
X-Exchange-RoutingPolicyChecked:
	ZtFIdRXT6NEyKLAVMwi/j9ExCb1YKIyWkzUHFN/r/AZo9eyBn8+oOfaSJbIfpE9AMJr84/XQjvksz6qIWhy4Go1eGJ11Memebm3/4YBpiwFqPeuFUOFpsU20yRz1VY4EkFzAJ2pHpmelgdOyumNdjhzoUPh/ldZ3ZPy3BFv+97Js8dZ+BY7Nr3a0a3BhL9TbFbgxEX+POEoi/ocw77ZMWNVMvI5v3B9rRpnsaSn7AAUyGtzfobi+8YX0aCtPMDN4GkuZmf3/2GwDBIzhCPkdYuWxRn1oEBZ+Yylk+GamkaZrFglyqkfFhbQlhLD1tt06azadftO3mdz1QtNnq1Zrpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lKhOEjiJXAWQHsOZwWOe6DjIGN0/VAK9N6zaD3iygdUIleXKs038wYDLqWg50EJ8F5kaRsD8Gt0X8bhDTWK4KrySw9bZxHbo9t7/wO/724LJ0E+ePOJFcbOfxeBjJDGhbUbmLi3EAte8KuPFwCdVT/TZfm7IVS04oLsPK95bn2mbPNRWKSzL3+XaMJe1SINLPLtU7g9YJjfb9GrSYW7LrK8uQq8+Lkk77YDTzoVTpC5z9kw3uYczlBYR8Zu4xrFJ2T7+Jic/ds7LSnRgp/JDlGpeBcrpt50vfg4A5xf578fjR9TP4kRzZIVgJ3QqHsMgNf4D0Eo5NYuhtLuvWelY6uRBRZhoIFZLeb5o+6jLylJ90AIKVGaoFY/i79CGHrvkXIa4+bVsAe/J8fCL1zt0TRM0TV2tKMeAKjmm0n8l85VHk9pwn1wsg8xMB/b/m5v1kJ85xIhwTm7SCDvzsb9Hy+2HGEwbka/FemPCoPiKMBsvKi69z/dxGeMoifsLmrVdIjrxKt+59+rxNTbY/e+jwjhxoHT017kvEyNfatnRth2BtAArS9E6dae37elawii0m+BJmjMlaneLAerckswbI/W0xUYyMnBIRSJXVP4Be4I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20409801-3226-4a73-142b-08ded8ee5c12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:19.4204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goz6svArJdIKRhI7yytKN41oY67DLGWOHbeI0tkiDgGYL+37/UoEb2WOlu0fpUcufTeUD+6wlu5TSdo9tn57mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5rZOUFG5RhNC
 5A5pzSU4RhdqNH01dWT6Oc04N5uOUedekgUBhtGA4bay+9eCNaExCc+B/YEvMuuta0oqPvL7ISz
 PR/GlkptVE45E5uKTQws4R2ps3fcmI5Hi/mOBPE5GA7gl67Hwo/H
X-Proofpoint-ORIG-GUID: AB61TPu-4HYsIgER-yrLQzIuaUnVZr8J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX44VdD9vSjD08
 UsKjoqtCXjYLOr24jNbdiVh75E+qwMhb4NTGVuVgaMj4ppOJLcvpPh9cU0aU4S+gz6bEN01okle
 80GsAOIcN3LPywc6k9K/rJcUIkUZ4v19goq4GCDsqd8E69/8qtKZZJvdCu+T/5E+zNNA9DSf3qy
 Wk7ruD9UDfVZTgMOSqlpse44Wh8E6bO+911eFma27+Q9V+3cGxGfeDyHbRSMsTRr/BtJfErucrm
 Pgm/DuwPwTCR5lAHzEQLw9KebNaQqEqcaK4k33gTsUJjGMiKxc+QJSCWDVfvpKeorvjGZLNtlH9
 GenJGdy/T6TZkCE4g9+VAIpURT7U88tGOBI70IHGZB+FFOpnv+Yt2K1OZklxGuPTjG299rsPmwc
 Sbl++ETKvF2QVaKfgFo6pvm4kiSgK7V5x204Lmthy5QsvaOKQgS7QeKEG5B1YYoih00WDa4PPW5
 rjEMcjwH0uh2lbXNkig==
X-Proofpoint-GUID: AB61TPu-4HYsIgER-yrLQzIuaUnVZr8J
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a478fb8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=QNd2FcQEdVqeu-mTEKYA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

These are for mpath_head_template.is_{disabled, optimized} callbacks, and
just call into nvme_path_is_disabled() and nvme_path_is_optimized(),
respectively.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e0573ca71ec60..6d3df1775dbeb 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -305,6 +305,11 @@ static bool nvme_path_is_disabled(struct nvme_ns *ns)
 	return false;
 }
 
+static bool nvme_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	return nvme_path_is_disabled(nvme_mpath_to_ns(mpath_device));
+}
+
 static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 {
 	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
@@ -447,6 +452,11 @@ static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 		ns->ana_state == NVME_ANA_OPTIMIZED;
 }
 
+static bool nvme_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	return nvme_path_is_optimized(nvme_mpath_to_ns(mpath_device));
+}
+
 static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
 {
 	int node = numa_node_id();
@@ -1539,4 +1549,6 @@ static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
 	.add_cdev = nvme_mpath_add_cdev,
 	.del_cdev = nvme_mpath_del_cdev,
+	.is_disabled = nvme_mpath_is_disabled,
+	.is_optimized = nvme_mpath_is_optimized,
 };
-- 
2.43.7

