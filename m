Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B8B3EDACC;
	Wed, 25 Feb 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033871; cv=fail; b=AEPt30ZMkXw3uvGVkoIU2Vn7fNgZ/77M9rxgfN4nNx0J/piYWA3SVhpgJIIMWMJZbv4PRL2ml1FGDLa3A2jPe4CKdKV72IEcIE3VUtoj3y1rcKz1dtKKQ8gaL4ly6nU5OTmOMqMkO6TQ3e+6Tf8kmBwrPnlPCAdrbAUtWyUl8/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033871; c=relaxed/simple;
	bh=rv8Qw86pLN/DR6tWLExBauZkrk7qe9QKPxwRblkGBy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jBaelUQdGSwFq5uhssAMZJ3yHpcC6dTHGvHQ/F1F180q7wYfN5JOJpBeBneRamJftzFSc9anNH1NiufIlwaI22t7fBnuEzHBS8OWgonwJdkCkwxifuPgSJyuSRQk/ZriLplzHsJpaN6n+HXyKNWQIoVStH9E5XhNnHwr9+LNBmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X5yznmGh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QyPx6TmX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X5yznmGh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QyPx6TmX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAUklw360714;
	Wed, 25 Feb 2026 15:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2dqU2P1nEO6on6MG0lJJzNFOOplvHJr34eyzNkvP1M4=; b=
	X5yznmGhHcY6tydEdpZbbpTcjAYblOZC7ul+gvegQ31qB5zrCmYl2YmLfm3v2A6+
	eh7cxFUVPeXNQ15SWQcaaMQE0dG4UPO8d+HN6hX/Dgkvhmi6h5pgLeVp8OSz2fG7
	EzzglwUP6Xnp5PkQole0Ludcq80XgGcN48Z7atGJkS/C/XZjl7u5kQIu86TqlUfT
	uB5zlelGEv0/WOjVbq6dLFMgVmQfJ8805it5iveQIq161XhUPSPkqbS2Ig9g0xAp
	KtnK1GRUtSylA17d82jdf5Bg1VkrJAWDM5LAwxy240IXErgxqMtn4kD6ItXauyqG
	EiXcE5IDpgE344GJVWCXsw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7xfhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE0UGf028678;
	Wed, 25 Feb 2026 15:37:25 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7j4r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFkYAdySBX3VvvyLzvd1rBLP9+9XIcdPsUZDeYxn7vg8KrHbWiKOMFGDADWrhSI7+5PE6KbHPB+u9WqegoSB3zI3dmvWz3M0yND+NKjpOoFsaa0CqveJXyi7Rj1s2+xxCkx5WrvRwkaoQf6tsuRsLD9tWsV+y5ZOgfRevL3lH1ia9+s5ECPIJcq6WSK55+IRmYwcoOat+aTutYF+8M6AhiadfPwiinrTr9T30g57aH9GqgdWWBO5IT7aO8NuoGJq8f5NE8KdwNJfhVLxaTWtnyGlkpppqRqkzFQbZouRc4kF+1OU9utgoyMHhLg5HYPNSQE26Pu79AGJQRVVOQIIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dqU2P1nEO6on6MG0lJJzNFOOplvHJr34eyzNkvP1M4=;
 b=C1z1Olx6He9eGYWqjuX3vfklZP9BG+bWPVD5ML1vnRZ25NgfjHRPr5JJ5cFqWIjOKQaP6pKYuZOz8SWpcw7kX+aOJQZgh6F/A/xLjYohJ5FFxjIh6btN4iFO4mvrQrwWPbXWtlpENEJ5Gv33sGYMSXLx9wtGQjcg0C1T5Vx3DiRvbt+p4s/tfyejOSOu1duGFy4JQMwczPNYHrQLzFY6iUiUXWm2Grxiqu+ErpWxwAq2ogqI0holGXfRxPTTmfBN4HU/mdUKUQ1uFzNXeIuZZ08di1CYQceF41n83R7IYp7JAFWXucbQq9xCWEYY8kjMMSFF+Z6tjtzSTfMTAVEEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dqU2P1nEO6on6MG0lJJzNFOOplvHJr34eyzNkvP1M4=;
 b=QyPx6TmXuzGr+BlB/7tmMtf58TbnD3SJbZ+2bp8WJZ9e9xcRr2ehS1X/2iv3y+Ul5C6H1XVr30MtS+zPXgzVIdeNmEuDpBP7Rqvhhhl6GGHZHch1m9S973I7cR4C7nx6Rykw/h8dQLWhqwPVFsyvVTdF4zMXm31AZlAxHOFoLwM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:22 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 19/24] scsi: sd: add multipath PR support
Date: Wed, 25 Feb 2026 15:36:22 +0000
Message-ID: <20260225153627.1032500-20-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0053.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc902fb-6f8f-4fc8-819d-08de7483c4c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	SoVD3J6/IctNRNq+klyV5lgFPjDY4Mv+/tN07lTXBHT5ONbSNOuUB1hRItdS2UuksfW3RcpUpOnrJU8uAYHlD5ZNDogofKuHR7m6WzHsRZLI+q+Dqcur9jDhNX6BeZDMeqYeuLjBqOMGMPILr8NtpzoS8Tq/7mkbj4lPOxbrgolGS8AxFCetq7HKeb0b91n1gfIIygHo84x+pwxMxo6BSO/sovFjAm0+gKO64uL72SIxaOgAi7c90ZMDzFjTF5qXPD1usKnSi9mN4Vm7obN5Xf1Qes294Gv2VJjhLJEB446sk16wWyGaABqhmQ2L2xEBOwaFM0Rkuco6tvYJ7h0GBcYaF4NZRaz67o6yCTK7vKfdDDye89b83XmyB2ah3YJ09yhw2DJbBz/vdCVaIdVz07rojg8OFB7zuoEVvzavJk+ruohmWtCpDHvarPY6b6OyftTPmMMryYNDkCfF4ahBN3ofCgHoPBV2aHoUTs1SHT3U+Ja90Yw2/FLKlMYiTDSH4gwzvVyGQWVG7t8pL15SW7HwczlmhxOzeQxaWPbA03lEF6KoLDpPi2TwSjUDTdoHPQm/5pgKQkmHhYFGXq3K+Y8/uLI95v7Ri3I1uFxvFY0WWnL5QFsQ0xTR4SG5XjPLleYif3WUJuo6YReK1KCCLou11nNxsnGn4oB3N9mpGA5IFYANtrsC09LJP1EvZcZ/3+4oDefh22FMXoFI8RvHWScbJtHxVkv/xZsfTkamnLw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?21UlNgITGFb31hPAl1ut7RhK31o+uKz/N9dk73Nz3dVuwfigG9R69DqR8H0c?=
 =?us-ascii?Q?3WYfrJsw07npgwnhnr4boTJz6aSx83LxAfSUalurY3p3GG2LKbxQyfl0HzF5?=
 =?us-ascii?Q?5/ykYLryDZ1OeQh2D05nEG3fz/wn6CkMA6KmSYi2TmdK3hlVclkwa37J3/bP?=
 =?us-ascii?Q?clkOO+AxAbf+5H0cX38OLE97/BZ87tZC0ckkkgQB1MrV1jGU7OyaI9K4A+IU?=
 =?us-ascii?Q?CQCucbjILXL/gaW5nmLwV2F34ol5IQUtvTi/wZuLMhzkpZRbo9RFZbTG8ejJ?=
 =?us-ascii?Q?E5E6v6+HZwZPYCL80mvjWrIdrN4p+5FR0vCY1WgrNUSQvzf576311TozeJXa?=
 =?us-ascii?Q?xgdjVjb6i1du9nLXQ9TEWobltD8CO+8INZwtvaKVwlWg+y46EGPuzKr4d7J6?=
 =?us-ascii?Q?y5hTxtW3Tki2L0xvlmakrJWskYwF+9Xa3FumAJC5/6Vh82JgAmz6xFYOWxos?=
 =?us-ascii?Q?4Rw74oWvhR3Pkj6iVAnuTU8T/auOWlSHe+NfyY9X/T3V5yoJCxkzQCXet9w2?=
 =?us-ascii?Q?FP05Ev5fFWKPBDKMgzHtuLB5Ec6Q7w4Y2a4CU6gw9UYQiBbBL4pIjiUaAFa6?=
 =?us-ascii?Q?ljzg6K6CtqM1uY/uW1J+9HaI2f9Cg/o2V+EXR/CZ9poBFfAnKo4e+QsNsexs?=
 =?us-ascii?Q?LyCUYHEzwg2eaYc1QgbKuCd8xhhde36Mi+XxHyRRMOhjmqkSnix4QsdrGdEA?=
 =?us-ascii?Q?kFFqlSnVufRCIwRtv823U5rcJNFc3pQ/zN7p6Y+/5qqwEd9YCJxeYhbSTugc?=
 =?us-ascii?Q?XBYcoOQMVXxtgwGFrXHxHapB6GvF64z3e+7WF2OI692SMatGBCS0zdpw19r1?=
 =?us-ascii?Q?BS9oOD5ikvBnH4qHr3/qOiT5uyJ7BigINgbmM02J3pLD1AimrRFnQSd7bFz7?=
 =?us-ascii?Q?yN1Me0PilV0jbHJvj5IVjdbmkH+8VBabB32If4oVHkXkVdasmCwveuEDvmTD?=
 =?us-ascii?Q?j7TpjOlvOPXkw3vm7/9KT3wZi7sUVT52FiENMepSHVWyYPVABDt21gcM7AHG?=
 =?us-ascii?Q?LmIsHriBfYCkgQp3jJRHol0g6eqZ7HWJJ5wJHpPoePHdGQhSnmklBJ8XkwXX?=
 =?us-ascii?Q?TvhLg3+3iwcwKhCy9uWLqG+cExoHm4PJ9cWTJ5oMbAuUz8TyPJbpDrz5qErk?=
 =?us-ascii?Q?FLcNXmiScEKDNAasA83GPRTZA0ECskZ/CNly589dm6Walbw/G3DvONPPq8JB?=
 =?us-ascii?Q?qQgpEINnWOCPGKlPXnhScbJN85fnXBDONmMj6RlMiiDNm112oiZ/npToU79m?=
 =?us-ascii?Q?QOIo9Je/J6e/4WeNmJa9pwNLScsbXiVl5rSb0u6Py+AY++yHEcjBVOJ6YBdm?=
 =?us-ascii?Q?7hN9PgS2FDuObrT1MwO5UeXUyl7UQwHRSjRo+R+QILTsNtM5NbFuYna2TsIX?=
 =?us-ascii?Q?0KkZHSzyR3Ft1Z+kv0XpJSWr9xFh2W+OmKg/G7pyQahejnf3iKMcjlVoCbz6?=
 =?us-ascii?Q?5sz9WgysEQGXnep6TZEU2MM/O3q7ViBTEe6ddt/bNaTZ4LxXeb+8WETozY5h?=
 =?us-ascii?Q?4cXypNumbfX1e+pY3LhmS7DhsTRIMQPqJ1ZGDbiQwnJ+7I5PEiv8oupzJsm9?=
 =?us-ascii?Q?IbEVfb0micPG8KyNL4I46Ok9f5+hQ+aO8a2UvsShgfcnHaqqlc9ppL1aw3AQ?=
 =?us-ascii?Q?MKAVJiAVvkUiAgFAlbnSZzFdSFIjKJocDMYmVjzyNMfe9i7pbgG6dVpIsLmX?=
 =?us-ascii?Q?grGwbAuPXcgN1eRvDQKacoTzXMMEfFh/5tWxRfkn0qIuF3gZDPkihi3k8mar?=
 =?us-ascii?Q?vW68lzU/+X/J6mOSK8COktAUW7OpRAs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zY26ic2GMfwuxV1Ap+4+L5gTM2QYZ76WJfDAUEJcLffKNh7J5UBhZAZD9ksAgtYumMFnfciq4huUFXhwyu4tvg5snXA3Uts9HZGtIOD/Wk++ipOFMxLFW0NTbuabWuVlQLM2P6YeBHc0Ltzk7Zs/4Uy6YIgNcUH8LIM9n/GwvmV7fEUnJFxjsr1crLipcQiIMkacnY16Ha2qVoqj/eWbtHbzoeErZkl1pprHa/0fuPOmwBG1YHgPY1VRJ1UlW6iHoWrp0gyriWTWPwZe6lsxhtRlHCkqEyy6g63wwan1uDcVKiHlZDEGN5UDVQK/ozsJuEJqL2b76SQ8K0sieZjuowU4YDBwsPLUuNsyZw+Dj7n/16+64FcmkIpyK0A6UuVEacza1NctHpSeZ+LS0t+PApUSBlVjfhBtdmTeGKG9IMxbWai8xItTJNFGc/IXfQiTmVtuIbIlvMzv+Dvv8h0Wvacw27A5G0ZGX1Lg1RojtvVLENLGqnmxcGsYW8whEJzvTyNg5mDoARCVJHaYFFZ3uefFn/RGEZ8CANVZAm4UJ4YD/dxCvcWIcSOh2owxc0/aiYcFO2W/PzlhyUi6OlO7ThZs9WyClZK+kPghsynSUDk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc902fb-6f8f-4fc8-819d-08de7483c4c5
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:22.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHncYvBkE1yLkvA9XHrRkvj4PI/S/EYdvVqoXGmpw6jGFmtKmXWCMqs5TMiBfYoUm96Ww42vmrTEjl5osD8kMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f1736 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=O1YyqwQlfr7JMOhWvYAA:9
X-Proofpoint-GUID: X4NRj1d5BbANL6MNgveGw1LbLYZDxJoR
X-Proofpoint-ORIG-GUID: X4NRj1d5BbANL6MNgveGw1LbLYZDxJoR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXw7XHJgt8e878
 9o17Mo5hxc8fN6XhxL02db2w9K0qUzMOFdFZgM97IsRPlz2n9lVVlqwyM53sYiB4+JWsP9uTBek
 Off9bPnygfS9OOr9Eo3z2CoAjokgT8tN2oPCeCEgLLwYsvEs5oNlwrp3WYDsEFePoFYA19VzcqE
 Ud2WssDwD5Gmx0aH1RpWXrKEoj4BjVOirehULBeMLj+SuingNTWQjaC+ayylENZs8yUBFAggp3x
 oGM0aiF7MGXX4Cb3bIL00J23j/2HMvUtawaS1rGyZ9ZBvhSCBFZpT7XOEB9bQYQY3FSpVQGz6MH
 iNlzOTPmQH6JuuBlxxyr0fajcKvcTjrM7MFaeSV9dVgMHw0HOchEVlvLjLiosygK0YFsVpcC4bx
 JQMLJ7Flu1lD7qgdgZIvnsc6rIGYq5QW4O2DyX2hkRIrDoJe5xFRUcps4TlHRufM1ZhRHXN4aGj
 2fdKv+rCDMNVa7LOVmg==

Add sd_mpath_pr_ops, which callbacks which call into disk variant of sd PR
ops.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b807452a4bdc3..f94a3b696dcab 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4081,6 +4081,61 @@ static int sd_mpath_ioctl(struct scsi_device *sdp, blk_mode_t mode,
 	return sd_ioctl(bdev, mode, cmd, arg);
 }
 
+static int sd_mpath_pr_register(struct scsi_device *sdp, u64 old_key,
+			u64 new_key, u32 flags)
+{
+	return sd_pr_register_disk(dev_get_drvdata(&sdp->sdev_gendev), old_key,
+			new_key, flags);
+}
+
+static int sd_mpath_pr_reserve(struct scsi_device *sdp, u64 key,
+			enum pr_type type, u32 flags)
+{
+	return sd_pr_reserve_disk(dev_get_drvdata(&sdp->sdev_gendev), key, type,
+			flags);
+}
+
+static int sd_mpath_pr_release(struct scsi_device *sdp, u64 key,
+			enum pr_type type)
+{
+	return sd_pr_release_disk(dev_get_drvdata(&sdp->sdev_gendev), key, type);
+}
+
+static int sd_mpath_pr_preempt(struct scsi_device *sdp, u64 old,
+			u64 new, enum pr_type type, bool abort)
+{
+	return sd_pr_preempt_disk(dev_get_drvdata(&sdp->sdev_gendev), old, new,
+			type, abort);
+}
+
+static int sd_mpath_pr_clear(struct scsi_device *sdp, u64 key)
+{
+	return sd_pr_clear_disk(dev_get_drvdata(&sdp->sdev_gendev), key);
+}
+
+static int sd_mpath_pr_read_keys(struct scsi_device *sdp,
+			struct pr_keys *keys_info)
+{
+	return sd_pr_read_keys_disk(dev_get_drvdata(&sdp->sdev_gendev),
+			keys_info);
+}
+
+static int sd_mpath_pr_read_reservation(struct scsi_device *sdp,
+			struct pr_held_reservation *resv)
+{
+	return sd_pr_read_reservation_disk(dev_get_drvdata(&sdp->sdev_gendev),
+			resv);
+}
+
+static const struct scsi_mpath_pr_ops sd_mpath_pr_ops = {
+	.pr_register	= sd_mpath_pr_register,
+	.pr_reserve	= sd_mpath_pr_reserve,
+	.pr_release	= sd_mpath_pr_release,
+	.pr_preempt	= sd_mpath_pr_preempt,
+	.pr_clear	= sd_mpath_pr_clear,
+	.pr_read_keys	= sd_mpath_pr_read_keys,
+	.pr_read_reservation = sd_mpath_pr_read_reservation,
+};
 #else /* CONFIG_SCSI_MULTIPATH */
 #endif
 /**
@@ -4536,6 +4591,7 @@ static struct scsi_driver sd_template = {
 	.mpath_start_cmd	= sd_mpath_start_command,
 	.mpath_end_cmd		= sd_mpath_end_command,
 	.mpath_ioctl		= sd_mpath_ioctl,
+	.mpath_pr_ops		= &sd_mpath_pr_ops,
 	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
-- 
2.43.5

