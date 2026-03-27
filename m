Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536E937D13B;
	Fri, 27 Mar 2026 20:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643617; cv=fail; b=hRjxQ4ykzUJLwR/cRaRfh/JF/mtpRgLoELTCydoBYYzjCIvNbJu0wxs2gxfm/Fs2J4vY9AzskKMDH9eMKLHrDlVWkluOjySFsAX5jp9ydVB+MaTlArUYwC30ZFX3BCApqByYhlgaRJ1bZyPwE/o+Io//0bpV6GtrF1CR8ISLi/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643617; c=relaxed/simple;
	bh=1ddmRqyM1AlYqfbzwDfTxM+W/4CMXN+3HBfW+0vO53A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VU1JTOsGtlH2jRzbibpTOQd4d9B3HKfz9IQVHWXFND62vHJGNZakqnLyF5DTK4UbKMwe0mRWihIO6JCq6HhomCkapzg1y7A8OjbkIfdKEMIvFjy+nNqazJlAmhwNVbZ6xOpVWLa+11liNU9YyrPB7zYoffkCZdDoFIb032aVFzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JXTvffhq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bnqK2ptJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JXTvffhq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bnqK2ptJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGu4Yg833449;
	Fri, 27 Mar 2026 20:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lgWza2LR4PVv01cohB
	v0P6zseeX5adwWlmPV+DhG8bQ=; b=JXTvffhqVZbv8gnekiKT1EcBx914XukzuA
	7kzP71Fn6p2+s6CoMnbmcVIuY22rdE5/eX6GVdfOJUtjL43r74aEJ96szKi9FZor
	badkgo6ubZ3JUTu4kXEl8/mSXAqKCWiUn+sJydThRhF6AZHxOfR5YFhHZRpBCu7b
	1h2MYAw0IG5J0oDub4qQMoKa/fFvED0aIyKtOHEmNewZjyseqMJdqqs0bXQfHAVh
	yHmNlDctbiEhuZhcW7Uta1Y9OyzVBJkKwTYFkRWFzIxYyLFCivO1AmdTLU9Ftqxp
	MCuCtF9Fa/w3BTmz1KqtvG6ZhgQqziQVZDpFu4LEqhi2CqrR/+CQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfptp7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:33:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RJLN4n038602;
	Fri, 27 Mar 2026 20:33:32 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d26xujgsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqKHappf511K/yjCgJ/711hodqRS0D7lyJDmKRV26IL/Mtn/oBPFCo2PN+inI+BL/h4Qd8dTheMaa2L2ADqTTpJ/cEsnHRenC0itIK1tLABXDq08H0PU5Iul0Xvfc3Yy9XDF96M88h//eExEq9qfpPnUlLkSp/V+dWLUUtYKNS7oDE8Yg/CT252BuRGcR9t2kLTURp8EREgIyG40YDH6Nd3jgnSyWg0M8+BTA3DMktcVMQEh13jKATrUp24d9ztm4Vo9PNfyqS/3ti2jK594mBj3P/3JIW4I9V/XZT6ppMkyo2nfi9fNrsanpWdoSO87CXsXDSTv65xcSpelUkSM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgWza2LR4PVv01cohBv0P6zseeX5adwWlmPV+DhG8bQ=;
 b=r+swE/dLTZFHpvf+rmmVBAzTowAyiDU/Hz9fOR1//O3FvudwKRJhx1+W3GMvRPM3KrJfCL00c2t/j4YQYR/nUM3mRXCrSHmQ4JB3b1QjNHYv8JSdnCb8mc/PHR2CxEuM+BWIRpaVL9ldE/sqHP8zv3+6TIkuAurh0VnKeFsOiYiQ9cHiNJ1nX9YuzqeENNlAzP/XWsArqFA1eBEnnsjod1EW5zCOL4UV+1wp1IVTHoW6WcHXXaho0WkO8ATXT/eXZb8/it5TXsyLvsY/v5k2OkQEh4FEYIYbt8Rknovv/3zML0+ZUj4p4fsWn9XYXtsJLdtCdhC6xcntT++auxk53A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgWza2LR4PVv01cohBv0P6zseeX5adwWlmPV+DhG8bQ=;
 b=bnqK2ptJLZiBtluPmvWXZuSHiQFQ4LGzTzVTy1SiG4Wx0bpcPdToXwY2ChbqRWwLeWfPEltS+3kkjHfl5ahlTOKQSJlhzSjxCQwmghAKMbk7FGrq+KpcX0mUA7Q4ZrwlVKq7fWHM8asrU73piYpWyHahXwSPFUfGtz3GbzMdnNg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7902.namprd10.prod.outlook.com (2603:10b6:8:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 27 Mar
 2026 20:33:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 20:33:17 +0000
To: Kees Cook <kees@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Replace strncpy() with strscpy() in VPD
 dump functions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260323171311.work.101-kees@kernel.org> (Kees Cook's message of
	"Mon, 23 Mar 2026 10:13:15 -0700")
Organization: Oracle Corporation
Message-ID: <yq17bqx9fnn.fsf@ca-mkp.ca.oracle.com>
References: <20260323171311.work.101-kees@kernel.org>
Date: Fri, 27 Mar 2026 16:33:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:610:b1::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: c085aaa1-9e69-4556-283e-08de8c4013e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	t4KWNJdiYMxTkrpS8tiPTz6bP7bdCog5WYIJD2/XHeond/ezfyTVO6DV+GRi+AOCRSyNBtrfqDxzoYfUKpmMb+O3V69wO5jnXz7RVpiNsVnZdpIflSFvx7wqtaEueQE5SDZ4FRkO06pRuRjy+QgSiBj38g0VxaUew8I2/dE+Qx3/JcnF7s/OKfqTzSw6QV2b3G4hIlgeAzgqbq8odfkJdyk8x3/FlIa8dU9FcdGTkmBp1MCwDpgf0Nc6S6ExsQ9Ks0UleOD8nyObsfph809KrVQEcg+d/3kVt7vNg3moHpJMCCAm3q4GjjmsuLmzEtUFI1/OjNE7ORcNWFV6jcWu7+4gtWfzNbdnmChdKca7UytKN6C25JgHvCAcNxp/0cM4qmhzJT6A1mvQfNK80Afz6gN36xgiHqVdcNiVn9SVcN70gfDWuRCHxpF0e5FVNH3TadqOS8qBAdm3Ef6QzmsPElqoiKwz/Yd8p7kVFuxHApdHHMsKfWlyEGz3JciK6+262GVvoKm4sgyrY0ECEFA4mBrXsLcQMX/r/VxH4CXLrBwkZpKSmWAY6Zp4wG0M0XJX+Psmoox2nEaK6m5tXvkIlLuCf3q+i9FO1qM7O4LxL2Ji3Fgzi+Vhy3EEZ8aIKXdLy2NhR15t9VGO8QjpO5BUkRvLIX9fwPNBEpp+0hMLYsC6OodXTsuP03wv1lcrer+ZRabRB0r+HAINc5zJr97z7iPZH1qRRf3oo/Q7Waijg7Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h87JxJiUt/1Raym9a9v/Oo6LWXb4zm1rTCYCvC3jbxTvFGn/1NNW+ObcBMu7?=
 =?us-ascii?Q?jKQ7ld4ephcBqdp5TlxoHojA/dpNIyfDPhY8NSwip8bphAcQywTuWnK1uK63?=
 =?us-ascii?Q?yH5SEsFmEPt0PwTtfRaB12g9ZNCtZERxw25YHc42xfw88GJDoplyQ/AJAKkX?=
 =?us-ascii?Q?pBfQybxQPb9fLDe+Uy8t4oKLJfZiihK4KEFTG8VmPuId3fumtLDD8yKNpq/9?=
 =?us-ascii?Q?qg/8bIOTU3Ljzj5ULl9k8x0sagKM5NKqnETeHnOieqeAOTUSYDxDTBR53hQu?=
 =?us-ascii?Q?fV5KJdNNqY67JkdjpNPwt27ga3zuqWYGsQpidk9YMLgXO2AX96wLO0O8aQ0C?=
 =?us-ascii?Q?lzXHQsO7iy91f9l6Ie8uL3ZwVzD0ZHmTiANjSVgoXxO2PF5k7ZBv93ix6j1M?=
 =?us-ascii?Q?pd2+grDX0AVfUxbR7U/IUoBQf2oBah7G4Kz0JxjESCFoh412qq532hAdqwaa?=
 =?us-ascii?Q?riXIQRdAhegnUEjappiwTf0uJlnoSgWvVg1V2PFqNi4iWzLYO/w1di00wAL5?=
 =?us-ascii?Q?kJwr7ml0I3h/5qaQq8D92ToKbxS7GVtKGROf1lfn2lRy8kJTbQoeEPmdgYMf?=
 =?us-ascii?Q?K2VulvunQS8P17Noi5J8skTpsRbUPHuT5EAT+OVW+FdWMnMbsA2v6DNUdBl2?=
 =?us-ascii?Q?yJPOlys7b2+Ljyd0rHgZ6jttQ948cXeLKUIH946WSFbdw/PLXpeLaaAEAN9t?=
 =?us-ascii?Q?8g6Ox7Isd1puR0gU8fAbpUv/J91Nbh4u5DM1UtBRQjYfa2yamJhMhu9hBvpD?=
 =?us-ascii?Q?eqH0lMUb9wZvwHq/NK+0N87qUlzKXp2g2siE8Zg4hU1BXcI31RKHUQb8iwvi?=
 =?us-ascii?Q?0Fv5QUdYoz09JOASmJfYIkAPAvpvXRwpGaeshHjk0mv+Wa5HN6aLwq8d+0k6?=
 =?us-ascii?Q?cLHb1pGC4acHeCe/xWWlrdxavRd1rmrKmHBKyW1ODrIbIPhRitANcFoZ2vS3?=
 =?us-ascii?Q?nNUQviyi86Iu4M8aEMjpLJYRDSYlLJ3qxfAElxoS2qf9Mz1M5oQPtBgkTQh9?=
 =?us-ascii?Q?3vZDONfWi4un6K5f5ertqBeZ2AyKFtkNG+rsZ/l52QT8rCunsHTgWUzrMNZj?=
 =?us-ascii?Q?WqwbrZMH8fYuUF9oFTIwdyq1sf8BzAtAqxQVjUfEWWVyG+gvD9LqyqbvHAqp?=
 =?us-ascii?Q?O99s/iYgULMASrhvyVZj3Uxj3DDmZDrND1dyXjQ4oPR2OQ2OBybTVXEsQzLo?=
 =?us-ascii?Q?3c5iSYA8LaFA2eNSZxechwBKlAVhE8j0ixEiLrkI5SXVRWPd6Z766nxVXl/7?=
 =?us-ascii?Q?TR8Hi1Nyvg4CPCDYEAi6bvtfAoHK4fV+SJcCtuXa/pdGyfA5rf8Ji6aU1QDG?=
 =?us-ascii?Q?1Nl2DaE9/d61LZiAI1kK7ahj0MQOojjxf9myFQ/wH0yu32PnbE+bNDUgHEMS?=
 =?us-ascii?Q?0VpgRsI8+7Po6z+402YwfeUvmJEb8bd10zB43mEaTeF0qucgzqulvCxqKMJS?=
 =?us-ascii?Q?E7XgDOAUKEFTpPBpdmBkCTYACWEcMq+gHM1FtPLN/ERpc9iyMzs96p5VbQyr?=
 =?us-ascii?Q?IBPfy1Tx3LHqDBTtPCYrZhRWIilahtODaQtfmlgztLjf0tJ3P3hbZNuIna1x?=
 =?us-ascii?Q?AbQjwLET24BxnzEAOhlqFiYB1b6B59Dl3t9tPZjskCusI8ZKjIfhL59Iw+6L?=
 =?us-ascii?Q?uUfDeaKi3/pRGe4zzwbu8hQat7jqFHk5ojO11OKLoPAEtX+39oGHzq86Merg?=
 =?us-ascii?Q?kpA1zX7uJTZLjV/b6KbwZGZG3Ya3wsAP82EcR4EjSMUOsEkdiVHl5fxWFfrA?=
 =?us-ascii?Q?puBa6KFC0wx4zP5ZIhPiXGF/E/0zVr8=3D?=
X-Exchange-RoutingPolicyChecked:
	gkxOuzVDCA6CKFL7IZKXkeOkoFJNOWchP8Ztky+Vzu38JgI2UzGM25vNH4vvYUjeplIklVBfazny29fcQ/K5ntFfDG8HuJIwWpMeCdqaEVKlOBJadlYwEOpyWh5q2sZbfPP/KuvwXVasGwN1LxBUhT1TQeDN0nFESXxMrPdWJoD61EGMTC6RMR+2lZN5G9YtR6FFM6IwDudyFlc6HNwyfhh/OLeJrm0vre5J4ApeKCEaoZKN2lOqtoJUkquEvyLQiw87NvluNyEf65fFzyACtAsGXsRtqjTE/YWT82AMMrgUkiIGzKnGKvlsgFklkzgavZ/zEVwIc4TMIgDdhIVl6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZCBR6MTRLLvFVZKsVmrEmCR3qZU/d/qvyG1u6PbbjoqVOzsOnczXqp6cf3MHVYVHMsQBffL83qpzBjzjfYhgEhdM/1IidTF5LDJWJnKv+r/0Au6s9pftYpI6+q+Qu8jPUN7ELGyxDTD4UIWJMXZ4L/HsUxQ7HeDbiwX7JUIP7erQWvI+XW4CrQntv9JSknnxSmWhEKPVm0Bw7JBeJ9ps3MFurHbssIzZJm6f8VMUxhTcgfzvK8GSEG6kqaoutUR7SYB4zFzwSlg+DUkA7Z3cIekwGXaqhTZvehtMvBPj0975gimUQ72cjkIiR0G9yjsLlVFHD6XCERITX/RQqF4Ad61qaYHrY/TxL0JOhjaqDjFSP6UxJ5vPtZj17XDJ6ujf+stVssMeBGCru2gkrp5GMCmzgP5KI6ZRH01Ec6o2DzsuJCXJYM7o1pD8u2BowI8g4s9Xx4Y/ddNHPC8QM7h2cD2rAUc/zCD7432hkSlTjx1iVpbTrI+VNsb9ApIwhzf1XiQk2Qlecnc5A/28zRPD3K9QkF3ifk44X2NWaix5SsJ58BTFlKAFULqlGBYDKsXlkyNvOcDcsQ6iT6vDhK3FLJ5Pr0GVwzsLZr+oiDV7XRw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c085aaa1-9e69-4556-283e-08de8c4013e4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 20:33:17.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3It+3gm6D4LppUW4yfpgtA8L9Ntib8r3E6V5H1FganMTNP84KA1k7SW/mapXi6tznhvO4/oe7VsQ67vPBXwPczreI0WnZl85mhxo3y3saE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7902
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=994 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270144
X-Proofpoint-GUID: LX1njVyxG_FKOCgi-riFh9j0myapQGeq
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c6e99d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=IjsuMUMHWyZjy4QRg0EA:9 cc=ntf awl=host:12276
X-Proofpoint-ORIG-GUID: LX1njVyxG_FKOCgi-riFh9j0myapQGeq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE0MyBTYWx0ZWRfX1Vz4BuDRdXEl
 QwsaAECbkFKT5OTd41QzfDpMDAvWh+1KC5DPtUXhrUNWpZT7fsAJ2Y0tmptJfGD1oburSA8WEb4
 0ycRZA7Mc+65cwk6figah0QlXo/RFS6RE5VK3ZANy3YSirK+3jYNis+b1719qCgVBrcK+tMujF9
 n6duJqfAxV3WxKlF+LuTgtzWJVr5XfwWll7/HSpdJgXiv9OKWj4xMcoP5+OD9DVdCGj3MDsJEuW
 azcGMh7++VttxXZW/fCNfhE8Cmsk5ytn/yZ6y3kWP2mn46lEEqDzEmwP8P6wUVhjgksVrTtZvol
 O/Yue80MBPpXpYasv/8aQASQckJfKRLEhcczHH00BVQk7DYlsgqy+RZE20JzJYFLmYHnVdhk5KN
 UQsG87xJXv9ZLngGWWLpoi+15wmI1r3sAnQzSvBQQsLGyjlAiZjbGsK4paV4GQEqOV+QnOcGeI/
 NHItQ5qMCaAOpC6rvakym+8uIoJnDoSyV1KVA++4=


Kees,

> Replace the deprecated[1] strncpy() with strscpy() in
> transport_dump_vpd_proto_id(), transport_dump_vpd_assoc(),
> transport_dump_vpd_ident_type(), and transport_dump_vpd_ident().

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
