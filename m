Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1409C3FE343;
	Tue, 28 Apr 2026 11:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374808; cv=fail; b=Hrk3AuzGhi5jLJpkLhA33mv8FGjVkG/29sjRV/bQeCvoiWNJeCjCFTkN4MFQRj0ZF+KX/vzVErgcMuZ1/aJTZhBRbJfkTCg3CKzwQkkSge2xn9VzdfMQOrw2p+nePuaZDKWE+BuoVWk90DBcd9fpiRrgqhyUgPTMEaZYwMgjXUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374808; c=relaxed/simple;
	bh=ZL26Q6SDTdE0ilBFXXYJCj2ag/SWenr3ooL0d8xLsws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bIRuyGEvpG7m5dA8j6VzbMe+lSzyU9ru2TrVNBZ64u4KJAkUHXz4nEhmqz+Rvb6D6M+lgIjv6YPakuWVq0P53Htw5bLC8hnnT/nggjraZ3yaaSddsuWq4bcs+BY7StEePtWaGbmNxWDZEjT4AsXPY6XicpueKAbhMBLfI2nXepY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i75fCh/e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i0gAzUoc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i75fCh/e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i0gAzUoc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SASLeb3055306;
	Tue, 28 Apr 2026 11:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O48Kxx+EXhjKmVye8W3BQMnbUeunGyKF5mimDdcrEb8=; b=
	i75fCh/e4fXc7NuCnAKqTX9LmmYJmuTJYALs7IhJFK9dpEqQ0M/ESUKWQNMGjx2u
	uncj6GNRpUFvKrI9rMhyPH01vTgaPjXRKmFK6Bfx3Iih0yBic1rkpkHVeQ0WF+GS
	nYl04zRQw0F4372PANDbK4c6tTvDq878aHQO3yd8+PIcxDNqjjJxKnTJDbTPB26h
	uauO93SPIeF8Tox1M7jxna7dPHXrDx+886XrgCy8uqZgYt2O9zQme+FXYySMUBLK
	srEbUHA5nHgZqupPmjWJQ7WxWSWt/eNViuw6k6mvCFbcA3zM9SCxL1d/S3vxLruu
	CDjOj+0rTp1+uDghhOVTxA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5yc01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCQ69025730;
	Tue, 28 Apr 2026 11:13:08 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ckht3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x84aHJJeGHevzT+5bH7kM2FfQNXDtebjvowfORHY50XosgOL1RIJrcp8HV/f8ugyYbQsFN6bilbIqLs8aMgnzUiSCZIJ2waX0yW7TpZHkzUOphRcsAtcZbVsHgDt2BtJsc7DWBzEa6wb2MnIKB/C3+AV75BmuxLzK0umispoG7wYDOKAqU5EXWOfSWSpMSO0Lq+ULhStIIKfbIFPoF8taX8fBtX9ao0KYngrTwz8BlsuQbTlkv70qdaTMvxlTNb8U/F1rO8qV96rzALGX/mDgKkMFiU24YiTgczQGRnzjpNvIGsHda0AtcJrkEzZVj6p21HBij5w/zxCQWSlRppZRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O48Kxx+EXhjKmVye8W3BQMnbUeunGyKF5mimDdcrEb8=;
 b=hwEts+/yrIv0lYbxT69TA9b7dXbbvBLHp4pbNZYelnndGmHVk71IUP20mYZlvTVz2UweBgXxHO4JXQCfHTU61IwCNQBNNCniDjIw0ol2si5D6N4ZW9N24yZvh0L04+B/VGZrPA7uvGz2prCE5TgOZdKxc8+a9xcMr1E3XdVN9lpSQAvPfp843F2Tjop6m0nMyKEHFtC4HWrWBn6Dd1MwWLQ/rhoglBwJ/QUi5OyLrBAjCP8+MpXsCjF5SiJxHZF95pccFrBt2aj4YJPA2i3mklKIA5ccVLJ+dWpXsKrAsGyjhHGfgKjg9ZMUKs7OaDt7S/stpZYvnIz+f9ee2iSp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O48Kxx+EXhjKmVye8W3BQMnbUeunGyKF5mimDdcrEb8=;
 b=i0gAzUocrRbeYZEJaWW4nTf9XxWvyQryrWPbYw5cdyq8DZn68+VFSyWd6KqYLzHUaeqZv08f4qLhxxsMsShknFDRHaztld6d2+3Ql/shdpvWQWSTQfUNuOakLGCXngBs9VP9qegbECOYnyFTie4jE76k8NtVa+yF1cPsuoWOCR8=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:05 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:04 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 01/13] nvme-multipath: pass NS head to nvme_mpath_revalidate_paths()
Date: Tue, 28 Apr 2026 11:12:44 +0000
Message-ID: <20260428111256.1778475-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:510:23c::19) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 01c2ffdc-fd9c-4b42-58bf-08dea5171e6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xi6mvr5vyVvO/exDGthrVHyOpPUPoq0B0W0R1NtmPu24o8D6IFH8hsuICMWopUks9NkrL8cwHnW2SGgUdZs+wkl0StqeH9ENHO9t0aSPfTHJ+0frravDm9ZNKGueAjbNdUh6EXjGdXfiWn+EccC4MEiK4rLIt+UU7X8Pi6ndt7SjwAkgiQrUXtPWR6aCE3R5FCfy8LlRfZCRk4BYVTFIcOg39jLkkW8TPTGiOteIFwkYPqw7fwoVdWmlrnKryD897xjEfzb0u25OORs+H7O3X2E/ofySofodgtjaAYecX0V4G16lte0UDLkWAVzXyoF2OfEowCQOvUDBXQ8Y05c/9jIC68RnkIO+naq96BDK0vgnrOJttJegqiMxGCXzbo8Ilwb7T0AetIVzWWFUF7NLI5rtiOEtSUVeH81ulV+qlf4OjtNijmb3BTiJHG53CNn7QJi5xDmwkZKq8CQ+btRrKKnd2IORL0fjZgN10nvApouL8glKlPGnz0P1YPqgNTGtal58X2O11lDrnXa9BLzq7byeEZ/50zvOSNqH1LfmKO+sk/Yl+0vly/IYiB/OU5k7AE16d/Kf08eHkFIR6aYJkA/4x/TCL2qjYKep7sG8yHFt23rpg71G5h4cqFFrcHgmXe4d5av0pTVwOnRBsJuaN4SWAGy3YHfPwN9DjTRlw+oRrqk5MIBgM4Gj6DXGqpBmm8YcFc+pfCVhNfmFcxmS4JamFg0SvdFPQ77vApmgNaI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wNSpV7py0OrD9ULuFu+XFgeGAFjOJVVhv6PCPLeniJH5n1O11L85bZM2GMwf?=
 =?us-ascii?Q?6oJ/p/M0penoTdmFq6yXVBB6l3RZD108JiKdGMlvhcLTpBiLmr+Z+XGIeBfn?=
 =?us-ascii?Q?7nw7ClgesZH7gIW94A80z17AWTlcuId3qdRU5CjkLXm2yKRWAk6ZnnVnY7kS?=
 =?us-ascii?Q?4kM5eQCW0BcsAJGoV0AzFhDNfaFJxzCV3hhE0FSoBjZXopDxTg4clK94kIcx?=
 =?us-ascii?Q?kcsYXZxPdXxYfU9JVUy9TtTn1kXqYHt0wZbicKhy0SuF14PvF/1hEENW+PE3?=
 =?us-ascii?Q?tp/YSTn5kSR0yHBExXBqFmx1rYf/txGelgeCHknJyaUg5P347ztWMC1R7xoj?=
 =?us-ascii?Q?j+3dr13jX3lMRJPQaWZEwkTqsIqXRG7BMI71Lu8iloRX+D7mXD+AY4Gc1c+C?=
 =?us-ascii?Q?t5kunobay4Z2jYjqc/gjr2Q8t5nX6uCBdJS516fgS347KwTQqas455FFUx6O?=
 =?us-ascii?Q?pghnLRg4+fcAj9jKNzeEEu+NBidfi6EbbXgWeWSwz5eL4nHkHMv1TCHkUk9q?=
 =?us-ascii?Q?hljjvHV9qamRg/IoKvIdWx04Ti5nrDN9lGt/pdwjb1tVuG+rXOjk0Y//GG/T?=
 =?us-ascii?Q?7v7dLlaP+IzzRtDYiQWVGv5gLSCOvtRhAhIoQNZMUPLKF+kAycJ5hsHOhiIl?=
 =?us-ascii?Q?pYMH0mFwwBtJlD0JF5H+8tRkB9Mb6TDi/rX3uTm74b0PRSc7QJqSVZCVv5h9?=
 =?us-ascii?Q?Ld7rElwjSrwwh+4SC/8aQxiJOI3egllC8ciYxop1U3s9rw16NM/2zKxPcYtG?=
 =?us-ascii?Q?oluHUQrdzdpvlfxYjqEpxChH4TzTHRn0DbhFCTyvlrf3sE/Pt7zCGu15dBEt?=
 =?us-ascii?Q?hOjo0LpXl8fU3Ako+kkrc8QqItKomGzkQRvTDyIGJW5znxGVxVfaDqn/lrGu?=
 =?us-ascii?Q?F3EnaCxeyluFu4ynRuk9MrILfSy6G4Yw6HLoWFcYrSCFJiee9Z1CqFbV1wwa?=
 =?us-ascii?Q?QuafMqytWd12Cgf5538MltE0OUCNM7b5RvLskfC5BpFbNBJschpwVnpgv16N?=
 =?us-ascii?Q?teqUDPI87jrY7j57FyTNpJoOTCFglMCceq+o0B6XHKXir1NazI9ckASeNx9R?=
 =?us-ascii?Q?CrzJ0cKcvnHt1PvoS1pm5/xD09AL/tS4xHxzUDHCBckc1rHQTFpDB9QMTJbp?=
 =?us-ascii?Q?jlAYPvgrK3ZjoUua3O7skFfJQFy1UASA4YfCb1PUbzg8jdZJ0OyLYrn0os9i?=
 =?us-ascii?Q?IVIhK77EfzjCushxRIPj/F7YnljCzsyK5sBZNcy4SKiwwBEHAzn3bJfHdjDT?=
 =?us-ascii?Q?sTB9wqSB854wtvO0jBbHdlnDdUu3bAJcFsJtoc7rFyGY/cjm5qYkw83p2Qap?=
 =?us-ascii?Q?Bsb7disceYe4tOE1QDwms0AFjdnGsSyIserpune+awfGJdhEmbDrJ9mALkVg?=
 =?us-ascii?Q?XJIgu4T1s9dY0kqRhkRjaItYz73gMlRNVQ2rOxktcbMLIRnMnpTOM+ibJj37?=
 =?us-ascii?Q?+qhJjfQ/431c/6XkIazs9IMYZqrzgR/IxyF83JYoAr7UFyVQUJ3UA8L1knKi?=
 =?us-ascii?Q?5tZ01ZD2/QJt3iuQTwjj6g7L4hXkq9Qi2VdXljVJso9LgkXv6B9SCfyeuYZ/?=
 =?us-ascii?Q?fkMlQcrE9xtLGYojhoIJ5bDrvPClonUCmZqW1ghk09+DelRnUzJWfOrCRb+S?=
 =?us-ascii?Q?CjAUtXh/C06p27gxSlhqL1Lijg3ytr7qB39fKNH4tkfl9sRtyOnXMuF8ud0W?=
 =?us-ascii?Q?ktPUFlzzMYKAwXhZmfq9vzXJ0WRogoYY3bsemLnU9ZBLHql5CoIQgZer7crS?=
 =?us-ascii?Q?0MGLTPJbEc2LiE4Ygt6pjL+tJNOKzFU=3D?=
X-Exchange-RoutingPolicyChecked:
	uhBbBg9kvd4+Ol8H0lKMnHkR1HctD6QuLtq/PxstH+v7vowK4gkQ3bZJpZIAhP+OR/+1O4MFECKAz5h3Dwf/mxXqZpsc4+CiNtzgAkSrPAonsdReufWikNJjg+sHVPm65hefaSxN1LDt7dqmeEAU8zne7JTcLQVDpdsEWV7Xpe2ZTRsbynzso1NYs7RY8lJvCFkslNIAOyCDogAfKEAD78PUy2ACIgjpc57GL+LtVjlnO7HbR7mKo3ksDL7a1ebyb1TKZia5e95AJ5ndavhdmrPHFKbKsLju9PaFY8bKskOdCUUvsD72bep9a2mVxdhew/mnEs7lOK0TSdnbit5M1w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WV5VOvpmMl+vT0yM3Fe7uLlQQQnGCdn5z0YiS94wEWsejlNEeoBr/6rft0h9l45JD20NQaicakA44xIH7P96f4T7ar/uI8Q+1v8faWUjt7jN/uXFk5D532PNTilLwyxfYZHQXBvYcpdlS2zfIDCqY9Pvhlrvx0B9B52qr2LdISGd07Z1r51gKBkkS/stfH78WcrhIlg9Fuqx3hV6Akyn4b237SOxjYzSeavKo1ocNW2hkDAa8vLwi6MikOWAK5WsGYov1FJeEd87jU5QfsyIqHGMFEE8cpr7wIC1wRrzGO73/btv7MD13LiEzzPtT7PYjGNkAR7dno6+VRSDDevj0cZS0eIlkAmRJ+kBFN+xGzJ9hDJwpyaNyfDnVOeuUAPK6Q42Uv4p3nNIQgjzJl27VGdU8kmWkKBNYCp1v6JXGYnhsPfsUkZ7cnE/TXz3xWGrwZ+hhPOhrk8IHFCT71GzEp5W/+azDJvF0LKT3UDo1ZOGpqNS94qIYlls3bAI0uQ1H+Ijb5HCjBSurzAqWNIKJ8xi/G0FhO1LbqkDPGLi97kZALpuw7/AVnV+64FR1RC39qcD4o8Q6H4wBQT5dh/dk4H9V1EJ4gIOsbrl5BUTzFM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c2ffdc-fd9c-4b42-58bf-08dea5171e6f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:04.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufFGgfWLLdVMJrsfDE518wTU/U6D+ZuLwNFa2e617M0cOPEtOkvvfruCFHwr636KBwx/BQC22mjNtGN13dP7FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=858
 spamscore=0 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f09645 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=pRep3gAyX0dtP_3rn2kA:9
X-Proofpoint-GUID: SMgUgYudUrcdUo_mzXJF_Khz66Vk3fL1
X-Proofpoint-ORIG-GUID: SMgUgYudUrcdUo_mzXJF_Khz66Vk3fL1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX/qYsC/PP6NnN
 KT9nxRNmBVVPiQi2jRZIlBZR5vIRKPEtNZNT4giVXWpHF/W9+9+GRpFjrQuIVZ+E1qz08nSEkoi
 1VeZrgcZq1UE15v1ry6t4uRR1jKINskQF0PKlWPPumM0L/RFuu5f3evBfHUXYEujCTBotwvFZKK
 11ExlvJnkCoHv2objedBePMmE+yi1k7gTIpaaZNawHe9hWef40QOpEwwL0vYeHE6dTprG1wPI+f
 3XJtFVtHLFbhWROWCeJNjJSfUS+8SesW4CdUje3l+U9l6MzgeZ69UhPPb2KbD5W7nkZq0Fsn0i7
 vUNACmrznle6PRCA0HPpXxNVqmJuyjxpC9pZmEPHL+D/JwYPZwuxqZ6HRQDiY3kbvOHinB2ctfs
 ZA5be/3PebHAStQvrLhYTE+UsxI/Zs6ek3L6vG7aJonuvw1G6ATrN9RQ7auS6/N91cskw4dJ8az
 vTw58fojyN88OkXS0bA==

In nvme_mpath_revalidate_paths(), we are passed a NS pointer and use that
to lookup the NS head and then as a iter variable.

It makes more sense pass the NS head and use a local variable for the NS
iter.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c      | 2 +-
 drivers/nvme/host/multipath.c | 4 ++--
 drivers/nvme/host/nvme.h      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d62adebfdc68a..bb687295c2c67 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2559,7 +2559,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 
 		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
 		set_disk_ro(ns->head->disk, nvme_ns_is_readonly(ns, info));
-		nvme_mpath_revalidate_paths(ns);
+		nvme_mpath_revalidate_paths(ns->head);
 
 		blk_mq_unfreeze_queue(ns->head->disk->queue, memflags);
 	}
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 263161cb8ac06..e00e2842df307 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -254,10 +254,10 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
 
-void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
+void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
 {
-	struct nvme_ns_head *head = ns->head;
 	sector_t capacity = get_capacity(head->disk);
+	struct nvme_ns *ns;
 	int node;
 	int srcu_idx;
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ccd5e05dac98f..5de06c016b622 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1041,7 +1041,7 @@ void nvme_mpath_update(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
-void nvme_mpath_revalidate_paths(struct nvme_ns *ns);
+void nvme_mpath_revalidate_paths(struct nvme_ns_head *head);
 void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
@@ -1106,7 +1106,7 @@ static inline bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
 {
 	return false;
 }
-static inline void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
+static inline void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
 {
 }
 static inline void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
-- 
2.43.5

