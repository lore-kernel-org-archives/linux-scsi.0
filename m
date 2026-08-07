Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45CC39A807;
	Fri,  7 Aug 2026 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113926; cv=fail; b=DOtcksaCPSW16oj+9b6V5okWa/vHq/EQvjFeRYiX/GpattsGLu/JydEobGj0Cq4iXCzZ+r51ti55iPnCY6AMXbf8gWiPZLk7fdj5rd0uT3QI3cFi5PF7nSzzNRBKM4VudlH90ypB9lyIO3wHMqVPTJ5HGuCkFw1IzSD1v3DDUpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113926; c=relaxed/simple;
	bh=fker+jB8DRM8+TSiezj23cODTJWWlJZrN87kTX3TOIk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OE5fGnUJHRm+PVZkCA/xF13cOitSUBClMxgoPQln6p8+XIc9Dj06AHSgtKDDLpXgc4PgJqN86nw2JOx9wpTLLNekLwZVeuM3K+5wDKgsKawKr1p5UjINPZ7A7Czyd48xtH/GcsvzjQljl1GFTey01wZlrtawxiKFce2wTgssmz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DNoepyT8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d73mrkaM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DNoepyT8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d73mrkaM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677D0cDq1040026;
	Fri, 7 Aug 2026 14:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=M+MiDrZa8s+ZbgIfir
	N2WO1XXIHF773z/mNeT0EV0yk=; b=DNoepyT8oNR4rMeSFJtBBf4j4I+AXK2ZZy
	Q7jlrgOGzqxPkEMiFcb8Olie7WJ/WHp9BJAQmi6xmxs2LnZW+rNDXPbe+hW6qL/o
	Fg6mcO0Jt3FQ8GjRZfBlmURWvJeDdSH8Ddz6Q55lmBPwzUFEItGoZ8B9cO5bOdE4
	pN/qJzHb0k7LmLCd/qdYXTcTw3cKMwCdw1fdTyf+kfq1KR0gBZMxxxZGgTcHMRja
	ikwr0Da9xbrc+ZjWW0FFJD3Zpq9eboQA1mG4zOeCoURMQ/U0uL0YzGDWEEgA+0jC
	hitS9GzlNAdhAdJSyl+cGkohnbg/fljnZuG1RuN6FPrhfkJau5CA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e57xmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Aug 2026 14:45:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 677EUlJf028727;
	Fri, 7 Aug 2026 14:45:10 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78xu2h8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 07 Aug 2026 14:45:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmOkfNCl20OmuYgda2qpG/J+l5ez+U4/Cq8ce4+U9jh3ZXH17ZnwCOD8i1YnCbBFJS6zKQnxk2dLCHxT+zJm5Ah5IEbki3iw8hnFmtUzNjr09O4XIGX2511bJ37pegtBCBi9J/HTpLPWb4AQxzrQfEk3ffXYQlZeEEz82zF1whBUv9a7kREk6jGk5iPyyP+Fg3BS73V5juI4puPn544dcVqV8q1EobnpL9wCDldDDgqVFAJD/LErc9zEy0E6CF8dHIP8azlS4PBhsaYD3sDm2E1POfNJ5EHeY4qOdfFiTQHvfmHZu+ITUX9AecO9KeBfv7IpHQ/y05C7ULjVK2V8WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+MiDrZa8s+ZbgIfirN2WO1XXIHF773z/mNeT0EV0yk=;
 b=cx7OUKG09XYXOetqqAIt8+DYmkhEWbWEd4mQ4pbVrJAcBBBEH+z844H9mYSjiL0o4z/9/filtE6WkCbNlzT6xWSXGQOPJwk0RyNO69FdiI/4REZ/WuLmkHx3NoJyp08bUwH5P2euHLP+atWE6XMrjSslF2+l40Kx9QbQ2HXFNk+VASo9EpbO//HDQs7j2SVdM7kYx9zPJVirI9eY5ZinVNXI57vjVLDkSKnnZmdQJzwoMKiXDWLXwwYin9nKrIOwq3Br/rvio8MAlteYVttI5oUSbJ/eGceiMf2xWB6bmXg39yNYi80FwEWnrlCNECLPxAfTvV0Lqe9GhLTYpUg5FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+MiDrZa8s+ZbgIfirN2WO1XXIHF773z/mNeT0EV0yk=;
 b=d73mrkaMlRGD6mCqCmjmDnutgRS6aZ2MLJk0om9ClQD52+KAHMg8+nwjg5hkgnwBQ2tw4uLWrVSyxtDUAhe16tgZBQTKiITmk7JF8w7TL+Js5v0TtvJN7lPzfoTRra+9A4+sn+XirzmSYHqcubqO6miOF21bdQVSTiHjCEPQmQg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Fri, 7 Aug
 2026 14:45:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0292.019; Fri, 7 Aug 2026
 14:45:06 +0000
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, njavali@marvell.com,
        James.Bottomley@HansenPartnership.com,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        linux-kernel@vger.kernel.org,
        linuxppc-dev
 <linuxppc-dev@lists.ozlabs.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] qla2xxx: Handle the INTx not connected while
 passing through
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <04e92492-8129-4b47-b103-d8954da8ce74@linux.ibm.com> (Shivaprasad
	G. Bhat's message of "Fri, 7 Aug 2026 13:53:01 +0530")
Message-ID: <yq1a4qy3sc1.fsf@ca-mkp.ca.oracle.com>
References: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
	<178508193511.4027291.4543280548195278135.b4-ty@oracle.com>
	<04e92492-8129-4b47-b103-d8954da8ce74@linux.ibm.com>
Date: Fri, 07 Aug 2026 10:45:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0011.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5537:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e722bbd-dde9-45b9-45a1-08def49278ff
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 dhRIrBdEIlg3tumZp1aECHTqkW/Yy9zSVrl6j6H1qKV5FifIVBP6lBBKrFDUN/HlOl8IeMxXtY8N29WG6d4DxJY4KXw4YmUdj5WVksA5dBo2Sj5iK135k4Kq3ledr3aCRCSt6JyziCyynZbYOkvEt8pK7kGHZr1wStWr3N/LQHH0zJniKAh6jn909f8TY/iOHC04eC6u/jdgWnLNWZPL6Ss/w1gQIrUdu/4ULKHvMrSzXk8HYI/CDGTPpCWNG5/rDe6BSpyfq1d5pwkT6VVIcJJF8saioZEDG66RrPwEonCfDJs508QKCbaokdu0Z0PEZ7/L51Z0TMQGGEYwR0Gxcj+qxzfdHfWOpvPAm5du82vQ8ARI+D/MIbuLqQBDEylepeKDcUDvV7Vj6tp1vrU0c5rmFZWGQ25Dgv8Cu8wYvo3qNw/j+iuFToPX1uvc9/NXb4uthYsicQ9N3ccn7y+hpRDzs8+926OrPAwyq8zV0GcTM3g3chOgRTXPbs8hyNOIRCfvzZkECr9afCV/sQASeSVn6ju0QifXnpZ27QHugEb4CRbr93L0Wzf20h7BPPCZHE4n1XpQkS5kr3/zTwljSVYXabfIzk5pNhwJIdAU/9tCYKH6dP2oA3o3jtidwOndUy12IDKAgrjOKe1nJDVUhmIz/0ASwhhilN+uHN76xv4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?hetWrsVYMojUy9PwykZXPp86vCOVlhqxVx+CYjC7gryWnKDHSKYLrHaZGvCd?=
 =?us-ascii?Q?D4pTX1S6yNCrPdVeNurBZtFjVOqtTorS/cnWO71A1ht6kZ1f5SKZYck2lWQ+?=
 =?us-ascii?Q?vrLHjjVKumO7tW3MMxN7h5k4fL9oHnMSVIfBMlo+Tf/hZ/zvX4/OSakdgUA9?=
 =?us-ascii?Q?AImdFqV3KEdbBdg0uOcHDg1rB5lTTAftZrbVjKeNaq1jo3L1M3hpT3OASGKf?=
 =?us-ascii?Q?Xw8EhD0OEsvmITzn20xcPeILCOfJaTtPcCzjaG43fCUOYPOlMC9mpjDoTZlv?=
 =?us-ascii?Q?+hQv5jmbRgH8yhMrXeKeEOLFzXkm8kkNARNVlzgAHZd8j8BBzO08hNCPc0rj?=
 =?us-ascii?Q?XloVPw4Bo98wrTQuau1Gn+K38+/k46N9G92vzx9bwlUVN1gflKvYNxgoc+1y?=
 =?us-ascii?Q?vPkDjtsq2uOFdkWHYpsDADhST+7YjvjnZxBGqd8J0B1dXImbyKe6Z+8LBnjR?=
 =?us-ascii?Q?ECzzLmW8r3dXC+Xin01Jj/SE8kGA9Da1Xwz21B+jTydeC+EaBPThtM/x9ZVe?=
 =?us-ascii?Q?ipTosB9fq+HO+gdRX3zX8d1YOdLLnsDEvVlwMtrX/BvCDkRYpD92JPGDXr+j?=
 =?us-ascii?Q?1PzExKcC3iKZp8eqvxvodpmeVboXAWwqKA9GgQSeYBhquGm8fvJqSAfpBMOu?=
 =?us-ascii?Q?LjnJQPwaUKADGGsFIdMr2ZOdDpbMtKO/650ApjKxAafqDA48McY0OAkKS0NH?=
 =?us-ascii?Q?YTeOZgI/+npOqWgBwpbTmOUB+ftQop7a2Qpnbo5kubi9xNqKtQZjccuL5KyF?=
 =?us-ascii?Q?1sSxTMXafW9ZsHMm2ifp7gKQ8A8GSVjjpmzpmzDhcsWa+ZpYG+f2GvhSDbTc?=
 =?us-ascii?Q?Qq6M0iYQ5qs6B9BBVD4H0wcWDdyOcdoBreY4wVxDlvXZ7EiB6SrT0kmVBzu2?=
 =?us-ascii?Q?lFreuofjLbnaqyFrTLiauFVzuGECa0Fm5eDnzPQqdoocS3zO2BGhpE4p7sKp?=
 =?us-ascii?Q?0XP3uZlk2sa5/vo6tj6JAeUVsGs/cUQwRXRid2CAQyboOZuw6tGyhCfE6k4y?=
 =?us-ascii?Q?Aove+VjscxnwMi++vVlOScIilWUWGEiBNlE+Cd2bHVxE/PGhmSb+1jhN1NSb?=
 =?us-ascii?Q?rQTy0yvxI/bdV8dyyvTFIF1jzEHlCaYBsbFb3hqN06jGSJdoYD0sTzLo0tZv?=
 =?us-ascii?Q?W1/wUQQNTl6FKFm1DndLUCs4FrNSa7DsyplcpAaXdKnWKBwJr4OA0ttMrtHC?=
 =?us-ascii?Q?Gtq1axePDuWZefFliySwkH5GTrp/PMBNwnMsd19Cc5byUxBed0awbNV36pgB?=
 =?us-ascii?Q?tEFY22+yINdv/QAakQOTlR70reEnTK8xCQB7NtYpf2km4qsODo4izEoBExs7?=
 =?us-ascii?Q?32ez3/8CTuY5dLADLCsUsQCMs8cwTVfYOgkwDpDalowHOU9O6x8SOOumDZjQ?=
 =?us-ascii?Q?NKIOjLs0DeVCmTcVAmJCFXFdbKyVfQX64saaBNUmS1zGLbKDW4HegTiWJxm5?=
 =?us-ascii?Q?zfajlxzyvYQ80Z1c1vv/nAwdu5199/Yak/IOe8A/7Inkk4LDhwrBdTyYs1Hp?=
 =?us-ascii?Q?gCfJYczA9yRck4MWj0NdLQ+52pTsIE/tm4DMJ6DU/KMUFL3rTzKL+XvggHGe?=
 =?us-ascii?Q?ee+lbEU5+zTAc/FDMvbe2lp8SrQo6AU5ceIqHqPWlGza0cpB2X0FDBQRRs2w?=
 =?us-ascii?Q?MHIHITPTpJfqv4wfTfsD8hcVIyqKEFxT1C4hOi5ZmIecKN6Ty5F17MseULTR?=
 =?us-ascii?Q?QcfXa4bb4xkietFoU3aWQ370idI4ZjUxKxXdt7/KfkaKGF4MLWif4IIZsNDw?=
 =?us-ascii?Q?k6qEmQKbdsxF5XE5+4ruTGSqmBWHIPs=3D?=
X-Exchange-RoutingPolicyChecked:
	lCJxAYYGs6lZpD9NlgZkA6dC1iAmj/TtObw/b4YlSUZnkgSEMCcINNnKvIrC/pWNS8EQeXWi95QisQTSL1dms2vjJm87+8VNVcrA5/KVd/Ob2umbZ7KRfOi/+P3Fy6BVo7sf3/ybwVc/e0nRahn5evknED/bjuIkH7PiBqQYHIbej5j0mLUXivurTVgzM6xADQMFejes8SgXfL5xCZoAtxGejKakHdaR6Xll+ZyOMjJre9RtDXG1VPpfVoKhj8A0zukqI37saBeSmatcIsb/MqTMjc+ceJXn/H8M36SBfhFwAFcgVwyu0RGOxVEz0kRs8vhU2QxlAXVAM2JJ53tZcg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ScaGBU86rxb8+4hqxYu0batnRKaAAKGJoFK62U6CW7E+A3lgdcttmBC8pXXYqZNimAZ53pL1Tyx2xd/KrCFaDMpUv+iLBXNbM1Ywn8oHOgU0jUgEcOK54T0cUwRhl8I2X7gnLVhEvA4PKNoQyPj7/A6PAeMPPyxsRh35IEcPoFQTW815SnbJBouwplgOshvV/+VF2Lt33F2yrd4CH2nfcLDzpmucGduSpqXIcbyvHN6Asa8kTVGRenrjMr//dL71qPTG06jogWPyjjQm64fVpSo0BFzjtJnGmKOzcMrDSoDNLIomNkcY2pvn1fGiUqEiBkZzif23sURaXXi1tbDMfGNsYHJyOg0iyMQc6r/tZ/0sfHdnNG3h87SjQt8QLdIpcA6xt/F5v3JI/mkYOLf4hmEBTM3rXLYB/r+/ek/jaBXxC5EchBDKyEw8GaxXrGdC4Z4swG7skMpA8bh0/YD/X9q0DrIIEKaUTVoiPaqS9ixB0n49eXneq/Mf2oeUMmjP8YNZTHGlo9+sw6jYTFop4Ug2QkaOAm3O0ryEHU7+rQs7O8klLiVGIayyPvvB5cxAMo+Hmd1f+/tluKmot+uv8AL4w8PNKdJmH6LtQy9gghQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e722bbd-dde9-45b9-45a1-08def49278ff
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 14:45:06.7025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAGhBQpei77PEd7UvHw65JJblb2f9JtXp3eIRlPnugLCqJ/nRfih4r8WTM8BtNJ7psV1Wj3FgiNQV0bHdCyHyeEBxxsJIizjix8D39AmDRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=694 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608070114
X-Proofpoint-ORIG-GUID: ri8_cSJdV3Yyeb8nM82n8Dcb8TzrUi0b
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDExNSBTYWx0ZWRfX4ac2xhpjU5z0
 pLydav4glJiDXobdVJZHfP1oXjqH5iwQWVoNy4Op6whmkOGrGLN9xuumwN2eXjLabRXwhVLhsnU
 1mehFNp1D6xutMC2LVJQdv+h21bdNAcaUAcxple+D8sIlVbdrXlw
X-Proofpoint-GUID: ri8_cSJdV3Yyeb8nM82n8Dcb8TzrUi0b
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a75ef77 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yRR22SEesD3UTZaaJNAA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDExNSBTYWx0ZWRfX+8Bc/mS0+7yP
 UEzoezpPjhOm14TKMhFnaIvMqUqbZDgIHKRHkHRHM/XWXM6Tnl99ogMkRjh/gqfbQeFa5gghRYR
 h9kxAAYa61TrJPcS5l6T56pzlQogxpTa7fXSszSYchTSpXA7tBvGevBfNiX0KPWjBXuuCU1u826
 KUSuoitCrUz/LqcmPAO/WBRz2LUAlDQeynlKLQgFU87YKhVG7ZBqvUcsvYpTx8w7OZLOnWRO7Nb
 PSsRX4OjSATk0eSp6XNLjTyOv7vU86vorqHWxhTT235l+2Pe1rxkPnUAk+mwVFIA7D1bHgsOsJ7
 77XCeeTO9a+jjYLRjRSbg8yCjmc4lrV3TNqbbVPNG9uwcupdtTfmPcT97k6rJf9+QsZ3v6npnEi
 yrjmtJ3xUawG9oja8viJeFZ9J0u4juyQ5sLegcnlcjIy5PzmAJFtOrqYTdtO4cSfy18pAxxfFl3
 zihHWkUP/PoH4QJ2qAozv0kFU24i7MAfo2G4imrY=


Shivaprasad,

> Thanks for pulling the patch. Would it possible to get this fix into
> 7.2 stream as well?

Due to conflicting with the large qla2xxx update this cycle, I deemed it
best to leave it in 7.3. But you can post a stable backport request once
Linus has merged the SCSI tree.

-- 
Martin K. Petersen
