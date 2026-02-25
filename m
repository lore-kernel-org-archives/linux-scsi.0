Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1103D6674;
	Wed, 25 Feb 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033604; cv=fail; b=LfjZa4vIkGcs7jq2ImwwHxWI+p/kiKFN0YW5J1RkU2wlzNRRtdpib/Kr0ecnucX7VA+P2FEP8TZ3ZeC397EptGw5FbS5Fdw+Cb5MDpFYFefjn+vqKvVD8Z/sAbx3BxKBK5vIZFEDRL0URNQ0iAgWENOyd60X1BFU749qBGQ1g/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033604; c=relaxed/simple;
	bh=INJ3kdbK+s7+8lI1uAkr4p7poDpRdyNuxG3DfN7wxjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T4SNS+AWCY8dJ6Tk8Gd4q+x2fkj0lDjOB+qicmEq5jVfI3Pp3nCqGX+CQbk+HQa/Rs7jo6mSSSw5SdOV0HlllrM+4/pgoEkYREv9GfAf6JQjOF9D3MeqCGMRbIFLR5Jj/yQBua9liRJ82MZdRq7Zjzy0Rp+lUfXhesGPHL9RBT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZX6YBnYp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mJQbyNYp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZX6YBnYp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mJQbyNYp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAcmcj1959698;
	Wed, 25 Feb 2026 15:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ec4PlDAX8BzOpRhlddcLE3sP2gnftn8suce2dX9KwyQ=; b=
	ZX6YBnYpxZzY7OpkyA7RKQS8det0mBcNXINYVuzdwlP8q3WGAFr3y5D4vVzRInx+
	MwyAsmlkVfbpExnsOJlnDx1Rq9oJxFo3wO/qEXw6DBmR63oRCrBXr3B4wm+PpLxL
	pRUeEbbBtfHS4IytLyjolaHB4XgGFPifKIAzS5dfW/51DOE44V4pOurUfJ6UjCuy
	yK6UYCfEvKVOSSkHeaTRYo+jmBYqE2uiKrWdiQLbqGNwR37a0d2L6BaYOJkNqbys
	labDoJfvx1Y/w2zeSk8qhWkNnW3LkBkwQNzExYGtwSej4dQjpiBa9wFVdCnarUJt
	l8Q4DsutP7fwfenZK550Lg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbeg98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEXUdm013310;
	Wed, 25 Feb 2026 15:33:01 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ffugs-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PShZ0POS2QAmIhAmwGbAdHrNK4dW5TEdSstiOwMNParZ8+zhwQ63Hk8IridmZZNJbC2pD2JDLc87Uhi9lN+uYqN+YOogrwkKY3uXactS/SeNZaFR2epxuQmZeNpzMGB7u+C/harC2rn7cMRuriNxbnZAClEP8526uLMD/HSY+HrGI5c+eSadq5Ha1R5gFpkcrttkT787+EC3YgvZwQHZWgcTKIyvJ4SL/WIj3Z/vFZuwPL1FiuMsnablTZxZD7ajKLz1+pAVCmvq8107TRCDHbpWJ4cgySBRitodHZdm487S3lVrK305EI/R3by36m2Fmz4hMOb/wpDqf6F9YaNCxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ec4PlDAX8BzOpRhlddcLE3sP2gnftn8suce2dX9KwyQ=;
 b=neKQpnAlAlNi6C6u+ybEKlzV6EFCLNgnjBk0RMS/r/bEoKBj8sHw7sIv+ckhYVFnIl4wL9kHWtk61Nn1WiDkeSEv5ObIT9yMzTIcp9KHtMjnpmNR7YlrV9LYHMopNfNNHxkbY+7QDeTU9dgp/AaM/hwcb9i9RUcyAMT5LVC4ZB47NrriNchUnmldMiipIX6VjyR1bzBhvdkairbsZbP+yp63yNFwnzu4bfSiXXa8LHc8oZLpg/zZoDqhzlRDYIokq9HUwVYowbJX8vrq9kYGxL5qVn2y7xmUujMxy448clj4y1iizmYhG1v7rQOyyYAPX2Nfgk+mvBlfwDMNDAXdRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ec4PlDAX8BzOpRhlddcLE3sP2gnftn8suce2dX9KwyQ=;
 b=mJQbyNYpUph8toYvrKSLcRlsRXUyNbqpnPP/C1EtCSlJ3quc8/EL3Lc/f1XJ1hbH0Q+S17B2Rnw19usFUBs251SGm0RoX59SgIdIsgevpgS8HbuQztYrpMg8Wvc4LETrmSi5Q/QEacT89HXYznxKvZAZkMpir2N9/iEh7uU81zw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:32:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:32:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 03/13] libmultipath: Add path selection support
Date: Wed, 25 Feb 2026 15:32:15 +0000
Message-ID: <20260225153225.1031169-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: a78dc4a8-5828-414a-eee2-08de7483269e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	1/QA8m3amW+RQR/+TXVXEcPjCZ8q9QVk/pUattHUxF8TKk8MpEqK+LE+NNwdoxw1iiwfJENaipSPv+P6bpgQEnZkkpRQzbm1njtYghZjKhyUSL1lNy8ka7Zkzh4K/6D29X3l+S4L+D4C6KF45pAPMfiyY1dtCMZr6QmQhQl1G7R3QWBV0Qv1ziZtqv9na/rXvFMJn9R7af3/WmmNYl4J5GS0w8Z6Kg5niMrtTB7cCjjH0jYmMbZdgZBi1jwhgdCY2FNz3QdYDaxNC04pntPQllhAz150XT70ATmH1QKZeKEzDPD0AsKqDdkhMevpgUVeawbhBoMYF5xgWpC7zMaWJTUyBxc5N6S+kaH7WxCP35eoMvS1aX82y7z68Qa5MX3ouLttg9F86SXLDAmi1/7KQCkVTbzpQb3fkchoDP0D8/hJN2tGVlwFprbupdzKFyqSjDppTtPFKHQRq93jdoqAEouUgP2aO4m0WxxaMNOsitLjur2zFHOCqIWuFnUrmwGLiGqy4V+LqQAJYQGCkS/Mn/jntyK85Q/E7xLcDiydIbcK+Qs2PlTB+g3MQB1WA/seD9ZPyJCTkNfIVQKnoI5EfOuecCQV+3CIqy/jKVsUWLXEqugeoXoHical2Ab+CGbkkf62vqOl2ptQXmbMGdycR6cAq7zRaIhZgU9FsFgKw4yQWicA/rzU+VQ8FwdL4ByCPNk+MpR4Cu5y5jtWhrogUvaVsrNm3WqvT6QVuuR+NOs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?urAxkaet3tQihvNqm4GvQNZI7qfy22xIgeWFN9yUVGiQfJno9QWQ5R+g7DsA?=
 =?us-ascii?Q?TzvbbGnCh06Y1NvolAoLxrCCjFhScZ6F5woUgpM8tUkFjBLsPYo8HLU+TqA3?=
 =?us-ascii?Q?i18Sz6HvqTsQpea+Nri4Fg71vVp4oAdemRlsaMOyFZxErDQt09TTCrCET5E5?=
 =?us-ascii?Q?NNg/34KleLp/QllV+Djom9VPaNYLmNxrahWr5N8O6+qGMBMroZQGJUDWpsym?=
 =?us-ascii?Q?j2aL7or73h0i2MwK7pzlIBIo0Cb2YyoA1BQd7nNIfojxq7ncTdlCcM2bSe3F?=
 =?us-ascii?Q?frsT4MwSxyWtx+mJdKToQsP8Oa09+NhWktliXuaiZ4wORzpRGZZLXfC9Hhw5?=
 =?us-ascii?Q?9lXXYXtfelF5fipMHEOdegbnq3BUajkr/SAXqWVnb07ocLEZ4TW9KHbDhUje?=
 =?us-ascii?Q?pyAl6IHrGPof1jw0OmW9msirph3JusASvb0rwGqxVlI06vcmTgtsR5WQTbIt?=
 =?us-ascii?Q?XhgTNYXuJfbEb3oO5Ka3OeFaE/AMaJQB/o5idBvSucUcxr7QYjtCP4nAXRoF?=
 =?us-ascii?Q?VPEzGJngr8vJKMUiaEELHCEPN5EWFkNwBGu3ZBQW/RMwZ2ChEMIPdCPWD6cT?=
 =?us-ascii?Q?1hxNB88kXeEgig08YFn3nxdIl5ennlPFvCDo5sqSLIsxpmyro19vgwVEI6qT?=
 =?us-ascii?Q?0jCi0qXNYiUu7KrATwhaLqZykvrgKII5E6BJcYLMg4sJyoinSJWM/1paoe82?=
 =?us-ascii?Q?XMxbvICJ4PuGOQyscpPiVcjk5onGbawTCf1eWO/StnxrkhXgNXR46y8TjIGQ?=
 =?us-ascii?Q?gMUWUCr+unInsIojYNm9uMl1BnLrFz3Z+UhvA//nP1dHEX/czeu2sD4YpMm1?=
 =?us-ascii?Q?CGjNWbz5reaFLcvfodDspJQlPDzTgY/ZtYk9ALJDTms+5QDR4BhT4WDLsdS1?=
 =?us-ascii?Q?WuJkJfvY+2784CxGUGPn+auXY00tT9stWgSBX6wRO7hNNUDLpS+NXz1sBdsd?=
 =?us-ascii?Q?LTQBCHXwSwimlt/a1SmA/yZ3zoE14lvCwyYhE6/+7MGI7kC4ieXs0Bntacq7?=
 =?us-ascii?Q?Yk5Di274MuYobn3AZX+joIHHOT0A92mEOKdOXJER1hGgYI2Wqq21T9sTmVGW?=
 =?us-ascii?Q?6uVwzp/0mscqWDhsM3SKDeDqakAYjq5Gh0HtyAurRItUVqnAZ+RbqqgQTDnM?=
 =?us-ascii?Q?M7jbywO06bhiKwQF8EkMAaKQotvbgO0ogVZBc3MsC83d5jt/aTMxXrhVjzQ8?=
 =?us-ascii?Q?DLC7L81yOlanWjs+xffNje/KbhfzKjqk4x0ZZEldHZKk12TJQ0YllCutjXjC?=
 =?us-ascii?Q?Q8MXPqbC0zJwdf+JHC9grbPKhh+FUOLnIJOzEHq4sTIPoCpGn+y8CMnhNP7h?=
 =?us-ascii?Q?iuy+ThHIZ26h9kvs9nFw0XYAix9Rh+FIkpfqeVwm3vYSty9wxlZ9iWo3aFJs?=
 =?us-ascii?Q?O6w56eAXV7q/kAiuZfzD2PUOjNHfXtD2al+dE3wbsjzIZne3NEDKFVPP1E/6?=
 =?us-ascii?Q?lqEQTNrJlvyyAz1uQ4j2ac5hHrWL4/K3pwkxbPhMHVYq4xi3VNC0e5WRWlSR?=
 =?us-ascii?Q?TneRTrfQsfjBpfRK6WAda4aSNbIgMqvyZwboz5GpkU+E4LC8XZ+SDKTh/vtH?=
 =?us-ascii?Q?R2Yi7eeZz57FKgSHyDM9AbGoK8rigGtUjWPh0hvG7tukHrZFo+JzrpWTLURT?=
 =?us-ascii?Q?2kJ0gnljY7clhyUTxe0P4y7CJTZ2qfE/OIGGnUgfWCh51m5i6DQEoxGTUMSP?=
 =?us-ascii?Q?26H4/gpvvGFbxZbAXGOR7zwUUNbP1HbECe6l45J+WoLmKMFythO85hyvCM5W?=
 =?us-ascii?Q?jMc7zUBwXcMakfdcspgo4b3ljeJozxo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CRRwHvBsK5Iq+xg3qDPUJq9BivYqpe5kkX/509OkWNQ/kENzAwWpK61jsDkUAWNk+baJZOEPjFUpjsBiphIUba/En8bjCk6/8FLrzDijxKcSrSH5ScIMd/1q1mfCWO1uy0EK/TPjOQAqq5coLBKs4mqgnVwlIIEREvKscd9GXqrp1tTT0NORu4VqWnlvpPasA8nvccNVjPOmmEOAYNHcAp5cKihi6/VXIBk2EoLl0MjFlEX5y3l8i8EuwrLh5Hns7VN6S1VagGgjXnepAUSf4VR5G72dX8Fhq34ByRulySr0nLc5sV4Ypmh9lFGci+NKWNWwWoGc4OIC6WPW0FUyU12yjarQ7/risaz4a6KuEEJMXED2y48c7MGbBw61STgXXLsa8k6lb43zmNUIZxttFlhJOiHHUeeZDpogLpv9Jg0a9muEN3xvwqCuw43fBpsnXiOJUZoRNDh/0KSob1oZfgDMYOlnxsRqzfJuffJCuTiBiLzba8WPoVEO+Af7SSkLZOe7yib/k800lCUHHRWrTFTcX2ztNqTcC+U6QdA6aACnvzrxvZl4hcsI03af9AEquWNdslzzWDF//Q3VkflqDtGVhR1ZGPUYskIAsyh3Zok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78dc4a8-5828-414a-eee2-08de7483269e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:32:57.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nP85FuVviJ/FAurIUCIBld+nGyoVo3ESlSG/HX2yoI+gaovTYghy2Fxq5QGqUI1L8keKXZT70Tj4OTRFEW0JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX+mIJa4p5mgT4
 IXww9FaAh/mAC/AGMFdXWmit6ccxtJBhwfos9woGkTKbCDBzxW4fSr+NMPtNTcLyBuMgt3otTmL
 +a+vcVCuGHM9Yd9EwT6yuPTwYoy47Q4eW3IyRToz5r6iLnbhf0MMcUFS/Yxc8KHQBuwgXa14FR7
 5as1x3/OCGuBcfkrDVooLJdfnqSFIA0Gb3EBvXov2Tg6NQqOrNx+j2ByOdsujvEUWAxa2YAVPik
 RpmnQOOhRdTV+GM7lD52Htc57SSaRx8hKzyok93efMsfPRajCmGSwZKI9Dq649A0lE0aEoxiWaT
 OiP9PluXzvUwckuKD6iO2bDQ08IaB0WoNgkIQ2F/CwwbaDLCcjV62kvSzserVOtmTOJnOH2HM97
 7CG5comyZOd8HETJ2DY4PAXhJwQznCp0b2dj36nKC311Nd6yBiatMW/jhfyLstdgIIB4FcrpcUj
 2kjwXp9j6fKuVILhIfLcJ41a42T6oAGDpU6M9fTc=
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f162e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=Lb5UtHSxAhypNmDEWQsA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: BmClKgwBr-_L9DsxvAYiD1BesDut1yNX
X-Proofpoint-GUID: BmClKgwBr-_L9DsxvAYiD1BesDut1yNX

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
.get_access_state are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

A separate mpath_iopolicy structure is introduced. There is no iopolicy
member included in the mpath_head structure as it may not suit NVMe, where
iopolicy is per-subsystem and not per namespace.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  36 ++++++
 lib/multipath.c           | 251 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 287 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index be9dd9fb83345..c964a1aba9c42 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,6 +7,22 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+struct mpath_iopolicy {
+	enum mpath_iopolicy_e	iopolicy;
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_ACTIVE,
+	MPATH_STATE_INVALID	= 0xFF
+};
+
 struct mpath_disk {
 	struct gendisk		*disk;
 	struct kref		ref;
@@ -18,10 +34,16 @@ struct mpath_disk {
 
 struct mpath_device {
 	struct list_head	siblings;
+	atomic_t		nr_active;
 	struct gendisk		*disk;
+	int			numa_node;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	enum mpath_access_state (*get_access_state)(struct mpath_device *);
+	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
 	const struct attribute_group **device_groups;
 };
 
@@ -50,6 +72,14 @@ static inline struct mpath_disk *mpath_gendisk_to_disk(struct gendisk *disk)
 	return mpath_bd_device_to_disk(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_iopolicy *mpath_iopolicy)
+{
+	return READ_ONCE(mpath_iopolicy->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *val, int *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 struct mpath_head *mpath_alloc_head(void);
@@ -66,4 +96,10 @@ static inline bool is_mpath_head(struct gendisk *disk)
 {
 	return disk->fops == &mpath_ops;
 }
+
+static inline bool mpath_qd_iopolicy(struct mpath_iopolicy *mpath_iopolicy)
+{
+	return mpath_read_iopolicy(mpath_iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 88efb0ae16acb..65a0d2d2bf524 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,8 +6,243 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char *mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+int mpath_set_iopolicy(const char *val, int *iopolicy)
+{
+	if (!val)
+		return -EINVAL;
+	if (!strncmp(val, "numa", 4))
+		*iopolicy = MPATH_IOPOLICY_NUMA;
+	else if (!strncmp(val, "round-robin", 11))
+		*iopolicy = MPATH_IOPOLICY_RR;
+	else if (!strncmp(val, "queue-depth", 11))
+		*iopolicy = MPATH_IOPOLICY_QD;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+			enum mpath_iopolicy_e iopolicy, int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *mpath_dev_found, *mpath_dev_fallback,
+			*mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (iopolicy == MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node, mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_head->mpdt->get_access_state(mpath_device)) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    mpath_dev_found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_ACTIVE:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    mpath_dev_fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!mpath_dev_found)
+		mpath_dev_found = mpath_dev_fallback;
+
+	if (mpath_dev_found)
+		rcu_assign_pointer(mpath_head->current_path[node],
+			mpath_dev_found);
+
+	return mpath_dev_found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head,
+				enum mpath_iopolicy_e iopolicy)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, iopolicy, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+		enum mpath_access_state access_state;
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		access_state = mpath_head->mpdt->get_access_state(mpath_device);
+		if (access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (access_state == MPATH_STATE_ACTIVE)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = mpath_head->mpdt->get_access_state(old);
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_ACTIVE)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = atomic_read(&mpath_device->nr_active);
+
+		switch (mpath_head->mpdt->get_access_state(mpath_device)) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_ACTIVE:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+					struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head,
+					enum mpath_iopolicy_e iopolicy)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, iopolicy, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, iopolicy, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy =
+			mpath_head->mpdt->get_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head, iopolicy);
+	default:
+		return mpath_numa_path(mpath_head, iopolicy);
+	}
+}
+
 static void mpath_free_head(struct kref *ref)
 {
 	struct mpath_head *mpath_head =
@@ -99,6 +334,7 @@ void mpath_remove_disk(struct mpath_disk *mpath_disk)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_disk->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -158,6 +394,21 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
 		}
 		queue_work(mpath_wq, &mpath_disk->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head,
+				mpath_head->mpdt->get_iopolicy(mpath_head),
+				node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.5

