Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67FC3D648F;
	Wed, 25 Feb 2026 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033962; cv=fail; b=q32DVSZ3BcU95VKIJUaxml+SCNtBNM1cYmX6VSGwpz4WKvY531NeXRPomykIZkZ22faYVWPo8H4NZ16XwjgHq3pZuA9lJWPe7aAEILktvrhddyF8CiEqjGl9YuKDQ49ohkSPSXPDbraj3LAKW0ELucEZaZxGeP1Sy1be29r232c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033962; c=relaxed/simple;
	bh=UcS/hL5v9Y6MWWPpr3U99FBjtLbHDmzhOudRde7sgoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WGglH/tLwl6/r0mMJNmTzTkUJRUMV+15324DblHM6bJSOdmFBnawBTW270rA7IjxuhvRconIj/XTy7Qztrb/x23h/NtAcwosgn8dDEhUvvEqdRi/bUQ1vXRt0tFOuAy8KbqKq2jivzo0t6DIqXTgG0Co21KgMDyL5kD578p0VUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kNbLRUaX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S7laML8X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kNbLRUaX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S7laML8X"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9pPXU3928883;
	Wed, 25 Feb 2026 15:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WWxpUCFsWgEEbbc7FDQnNOP4yzwPy+O9BxXyp0IeHaw=; b=
	kNbLRUaXh/df0xca+M5wbJwa0BTF0/DPBrHeP/ublF99YszAtc4IHqPULhSotb9+
	exy9YuSY1ynBL0aRN8yEk/lBa88c+0ChZZJ3uWsMwdaeh600o3UtnEnYMdIRmwrc
	D6veK9fW20V3TlvHQFdAOdEbd6m8jPqVEqGTaHmoasKTLAPvaJVzPLJfDGgLT2vh
	veqgX5QT/FaC/bgTcPdhGqLfYRSOOwbjBRG5HQ+Yi1GvsDjZG+DkXDbV+xOOd0nC
	GIfhQtunrbIh9EARuSM/1MnJEK+nMG+t7lO85+NDdmpxbNQYP53Ha9Z+Etvw7paR
	at9z8a3Zmn1PN7abhtGN2Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qee0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PDo7Th012482;
	Wed, 25 Feb 2026 15:37:38 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg0sx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7NRoVGWVmmDhh/g/Nw6dMS/q2knZakKJFHZ0zEurqXqnxpvKlNuj6OSf2jcqaF75WWn7ir7sNxtzXRtP9NENKBgQeA+IRKAlm3cmpAVihVCMOTKmxqzz6MIiC7hDJ9+uenrlneCJgggvelEGLfBb2cYDhX7DVjBrJWjl0U6QQErbhHZP6lm65oG/MXyth9xddN8jtJwraMIAv2TvCOi+uV6i4leOGUKPG815DlphaEF/Czi3fa4m8tzAz3rLTf7KGHLl6IxnbSMCfzbX/ZPIS+FEQYIlp/yEnVrtN0nFBKuwyCL0K2g5qdEtDJsvICd7cow39gqYBjoXSZz7PgPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWxpUCFsWgEEbbc7FDQnNOP4yzwPy+O9BxXyp0IeHaw=;
 b=cAbN83ZVukn15Edfs/POvrOkUf7IyF00p1vEAD98P/WUMmC+MrPVdB8IZbeEwjMkfVz+oWxk+hv1q1esIclH0gxQDLRBwvu1J152lEW89kWrFh8dXdsutTo7NMee5AmGzVe/aKqFrRlkIRcMbUp6mxNMd5myW3i7iIGm0WtD+tetxwb7nDQHgWs1juj1T1D9zU6SlBv2konJvG+soKizz9cgTu3EMQL699zudNKHGU2In9BSU6ptexiR5OAO/+Qh3Msc18NN5q8BsabV3J52mhxmfEOy6/5YjjBCglZOmHyW70xTpQhPIqnH9Z7BvI2o6Go+7ET2oyJfwNFehea0wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWxpUCFsWgEEbbc7FDQnNOP4yzwPy+O9BxXyp0IeHaw=;
 b=S7laML8X+h8DBCK2EhUul7OfC98od8mNMUUfcqBRHZ87MmuhA4KCtAGCiuV5H545qbwnDy+I+IlHzzThM7i6SPRQnVn5Sw04YavLA497mC4KEgPJLZnSmjO3/fOu9xYVUxcee2rrjyDhqjeGugE+d825IYCKJihGF8Uc0Y4sVNM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7956.namprd10.prod.outlook.com
 (2603:10b6:8:1bb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:34 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 24/24] scsi: sd: add mpath_queue_depth dev attribute
Date: Wed, 25 Feb 2026 15:36:27 +0000
Message-ID: <20260225153627.1032500-25-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:510:33d::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c3a135-75a0-4eb1-f3f6-08de7483cae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	nzReQfswA1nc2KiI1cavZJqEhAjRQXgh5BwRqNf/40INACjsfx7PRfiqvdOKTJ8JktFxSGraWIOy/O+wSFUFYkEuKZeOwCeWDKSOwVmj596G7SP2pWm326dDjAwJuWX1S+YDTh9Zzdgg62kfI0OjCVpsLMv5m3NM1tyOKWMTBFWBM6MaumqT/hLfIjq+3N1yFsQ/Outkip1h8Xf/v0Qz+tqu9hTqdtqp8JmS4oghB66R8oJyKfBEY9h9rLvgYRXwXsKVziXnMrn4pZsCm9J/S2r0sPZPPAd64aKEFHL5DhLoNQ/7wDvVaoZGrWmz0mMUPG2h4DLCmKjWWDemxGzjnwiFEedFl7PSUNBX1wIwoksRuzqf/wmdNVe7lRxphAhcGeSH1DxwLd7Kww/FAmH5yxENTz7Ex2e7vd/VvNTIWo9LEQmLqK2AZ5ZaJc10IPYKyFtM2mcH0oNQ1eFsNdzmyY8WNegeYtW8hyJQaq1MyNmWLGz2kmvQXtSDUNjR3nEf0YXoaKeoWFscuSc026f+TinFMS1JWS9Z2tUZuikQzXkp6zsdCQzxN14AV/DTZ9oRHBWbk8wRwUpUtKSOxmUBDfFnM0wnxaUz/WGGkkLNWBrApGLY9GpIOHp9XI+7Xkag+JuICs6IhdTESDqo9hwD7b95IkL+U9HhGvioL/9SyQ/7jJUNJ4se8b8pGgrdaSJqX4T/6jLsG79aeblfMKE3gQhKmn8tQ51A1uFzuxKTERU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dF3hmz1ghvxcich6S5Ips7HMDxjIAmzEj6ersy/e6cxRxSRH8TXVFHimOBT9?=
 =?us-ascii?Q?zJsfjGfcezPsmoHsdcJQ+InT42Q40g9VhjBC8HWlNSpaCJPNTxUIfUksvN3H?=
 =?us-ascii?Q?uvsrxNhYaPmUbm4xtYoXGzW4ov37OYDrHaIJy3xb0fsyBNsg868wSKHZCtg2?=
 =?us-ascii?Q?Z/9Q3EVK5RCxzk1FEi03Km/qo0+TQ9rBoaQQGzcgQq/UShdVF+WLRiT5gVOe?=
 =?us-ascii?Q?YQ0iwRUBuIMGubLnJvPJAIWjs6BZVJVKziDRvVNLSuTQZTsTaNzj/yXNQYPi?=
 =?us-ascii?Q?yW2S/+uf/aEJEOpuQ3bM/TSWNOjkgo5BdqzA+CfyAMsTGy7Q9BWjviIrgPjl?=
 =?us-ascii?Q?YBEqpm1HQljzi4ViBRMSz/WO4rG4yCuWpaPie8HnlXt0lyvXI5BLs22WhmZb?=
 =?us-ascii?Q?vxKv1rs0MY7jSK6+5kEJSW820zgjxZdYOGzdDdADIsdlOhiMMQHU3LueWJpK?=
 =?us-ascii?Q?nIr/h+ZJH1U6nzqCF+VQddEEBWCI5m627RKyFVZmVAgEVSIq6GjUuqW13Vm5?=
 =?us-ascii?Q?Zq4skKzT2RbdRBcWFPoXrAjIfuxS0Lw8NxERIj88H1Y6RRgCzDQmCIS8ilii?=
 =?us-ascii?Q?ARP9VY6FOnEVLnGSb26eWF6+9JoR8YotvS/crLk2zNsMEd/YQHzGtaFV4EV0?=
 =?us-ascii?Q?zfslHpjtrA0i3jABuRRclfjUH/RWsYKEGM/Vx9UmmXtgLwPXu7wSCrsJsCdV?=
 =?us-ascii?Q?MB32R7P9G7McBejQ9pzBDGE/oh4AQaiag0qnd8vx/Ky5knK96ntXw9M2/vsy?=
 =?us-ascii?Q?SaG7OmJM/8X9sQNxqPgDITAbZK2Tv+yYZEU0+G8fYccrVKUsz8wHZaaMgG6f?=
 =?us-ascii?Q?yIqz8IZ45NXk+IfRjXjw1gmOxXdRfkpuuX6kibvhcE1uASHNawA+FM2SfXw+?=
 =?us-ascii?Q?dTIJA/C5q9skXqrUmiwGkpJP+9RqFAVXtayWF+VY4K9PVs5HLwLnFzdQhgMV?=
 =?us-ascii?Q?9hbe2fmWa0kKbVva7dGqCio8eTcgFJiWz/49ZrAyhGMEq3gS/SSG26HqKwkE?=
 =?us-ascii?Q?+UjJe+g59san7kaSm6p798SwZsLpAOonAzhumLavJd8fQofw4l1SCOIWpfgR?=
 =?us-ascii?Q?1i2U40jD0gRULA2feyTO+DwsmXqnZhvyKfchKeJpjgp9xgC9eM3wjrlAasVr?=
 =?us-ascii?Q?Ui3YQu9fe9kbgNkd10lyKYM3zwiu4Rdd0CpKyzcDYpmhKMbdYyXwyyC9raJe?=
 =?us-ascii?Q?cYP5nVYQgB1rv0JEY0MADwftfMj5EEUVSX4Jx4bt9Ex/f8zgPRBN5xPlpb88?=
 =?us-ascii?Q?vtp7F5yFb1M1ScVopq5moICUDsDVbWKlrRLyizZuQv4EpcSFuN3hsIAHNiPp?=
 =?us-ascii?Q?Bale3nnQdr54VicrfaMCle4x/yTf6FlURKo+24ddNbXu+Y2xFSXdWo89RTY6?=
 =?us-ascii?Q?p8+i7+UJcQ23FyQsvTug9HOL4Yjkg+3gdrLFQpGKH6ZaPBbKkqiIOmEH2Frf?=
 =?us-ascii?Q?fdHzDrFhk6NZ8Y6PAarkkZQWr0MklBnH6DTsAiAlMrn4DkfppDrMjZsYAt8y?=
 =?us-ascii?Q?BYq2J+dEsL7eVYtdMgnnUnbzxURWpnNmsQfA1QFc9miu07M8FbZveVZa0ZSA?=
 =?us-ascii?Q?eWbK478/I/o57r/4v0mKMfmI5JvIU/UahM1xagUSeTFU7S0hBxb+9sW9eWUF?=
 =?us-ascii?Q?IYFuZbbNSK5GeRgbqUdYE/kp3jjxEKm8My511HV8YcqUBJxuWoEgFSJWtlFb?=
 =?us-ascii?Q?hCH0JWyRktFGknajV9uUCos87siWitbhQsJcOSoF7N/VShkaGqZblzWsScQo?=
 =?us-ascii?Q?GoeVDLVdS3I/mV5X5joHSXl9cXf58ko=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s0xUW6dFuHcJuuzRJd5MOcLlBV7GJNPO8EPmr+STGoGjRM5OIjP+qeK2LP72Pb/UPMR7sTTqFge03dM+CxlfGPLSg5Zhb4z/RwS/EQAiJEgBVyabnvrNF72X/YOYd1rnO6h1xGdmJKHWRqW8XuI07wNyrCG3haRHa5UILg9NGUKd5eG0WulJ0fwqt1axD4j04yNCaS2PZr69feccipLIYe6d/tMS6jBLKhqC3ObTOrzkvpTk+lEaF8Db+4WhXR35fGBKlydkJMxzQWeKkoV0wUiy2PRtk4PlRaDO5ZRPRKrb27Okp8uYdR7ROzj/94K+i3kjHFnBdttj0wnWL2kg+rpoy3nDxty0Ifld3EdNKYAuGeW7WfDevhaYYeYsFLb5s9QTknA0usCQSUmR7FVpnmPbU1AWO8HtUvps7eTcb31od9WIlL7TzYybFO98YxNH25F1s7oXv21nsTv4GqzPVSZ4biKBgQTgna0W9EW7y01pl/lmOAHwdZ/BtaBs0q0Tk4Qkbn64wrx7ivkJQs82TqsHEz/a0Q7EGOYXQgVstCT4Zq+SwvAeOMbLZntgzVToSZcbT4eOV9kB25mENU/+GaQ3rClVZjJlTn1l4V0SF6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c3a135-75a0-4eb1-f3f6-08de7483cae3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:32.7966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxV0Z5SHmIHrRLJjnFYJ0gZb4KD3VH0vnS+r52EeQSU0btSwpG0T+aiWTlE7yxpEWHFIqu7uJTdNg5PmFJCEqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXxgEZklGFkvzI
 FXkJW/FkzfuT4l8B1svJzMI2+V3e0w66R64RtQ/q+kwyIMMZctLq9AcZXZtZXLS0wz6RMKnQO8w
 URymmAb3bw2FoGn7ljGkCgUB3aw1fsLfEUcceLhaXVMtIOIDDEMjPN3rUYCPmDH+suwksz4SYc1
 NXG1/CapSQ3YR0PGYGn/z0TdgAApbzyXINGhDbG8ECaqNmMdo6SQ13dRu6ocxRZUVHHZ9bGVarv
 DObNVLk/9eyGvyaCb7bpRz5gSLLzoTPOPw0rXu1u6AZJ1tnXG2Y8hdS8nOkcVGKmDQhn4/nRM7J
 IOqu/nQ/Y7NKBr6+EwLc+bNsQSlLCm180Pj1sIXEgWKp6e3fnJVFUwZsZiuI5QToPoFtfZaVyrA
 s3WZQtO2sBvrm+323i61JX4s8l8j/REgmDTUUq0g5E7uLU+TZay6D1Wf3jytdmgZ1OLTLe6//P/
 ALGZKG2InWBK6mPv89RCmUAyCo07ue7xjQY8Quyw=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f1744 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=bA5FzAUjrTEoIiOIIUIA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: L5WfHXMIQnk18jXo1Y61zFSEmsC-XYGK
X-Proofpoint-GUID: L5WfHXMIQnk18jXo1Y61zFSEmsC-XYGK

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 52d9bc34bd666..27f64560335a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4232,9 +4232,30 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_device->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&mpath_device->nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.5

