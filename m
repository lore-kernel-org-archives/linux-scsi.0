Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B39E55A;
	Thu, 25 Sep 2025 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758764528; cv=fail; b=ddAFk/bf8fpLDsACxrivR8U2daffrYOS7wQVgGFeOV5/1u7vCyGe1GlONT2GSgmBoRPOzqD+3RkfUy5KyXKO8rDf983lLP6Za+5dK8aSnJwOC3NNvwzyeU6LFsaXe6XwxZ/vt2kq6D3NiKZLwf/5Vv6VTAwZkV6dxtEnLKj9C4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758764528; c=relaxed/simple;
	bh=zDFp8uFDwkE6UmmQP4nMjw/1PP+gjh74ncFX4sJMBI0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HW027kv6tQygEjMC1bfTvzikpuadnqEq6TlCmq2kpf5O0i7rWYtW0vwr5cYzOVjPspqRwZjZARKDN6cfWRQvaF0PmXHzlRVopHVTWNcnffsI2ii1zgTn0UxaQfWkHNKUYCxRZbgPcOLxBRYUYKM+P0Q9+2mzFKJFaYVCc3ZNqrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H1B2RBro; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NN1eNBqA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H1B2RBro";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NN1eNBqA"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OIuCHK002028;
	Thu, 25 Sep 2025 01:42:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6caR6AybppnN5ovtCI
	fxic8NCycUfB7SEW71lPQLpeU=; b=H1B2RBrofqJ2XYkhO7jq4HHY0j2AdYke6w
	3ndCsXK80h/eBTI2QOt10H71EgzSpPqEhoN2iqvx1vKPUtyrCmq/fMVKl8cXVnqm
	RsY41h+vKoO/PI5prpzzKV5srE3iViWcvYfM2sz2zIgldDQDMCb1C3bDMtHeeEhk
	DRqrCxAqk9DRiKwgT0QL7T3gNqXvwbGCGkmmcmKei3ZxiKKanBFdh0HqtkFA47tK
	Zgg4dax7LltIxZtWxqvoWXcxlNXbJe7Hd0Xn+TxCPYNuMkDouE0pmHBiZOUyAtMq
	FEwkiHbTwJAtuELxNccFcl8i1PrpUP5hNObGObXtB01Lkb3EnOSg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k6b0xsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:42:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P0NM7H035653;
	Thu, 25 Sep 2025 01:42:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqaqd4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:42:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Leo7+6aaPvwwrVATqNf1aKlP/T90XScq4FerXwUpSKY03DrcWPT5+o09RR6pjwABOSGnhwoOixZzpSeS+7o9Qr5dnWEMR38GZdfCZHYxKmcYVaSTmqhiAlnxHe7YlZiUPYMgdO9GW4YLHHkZMBBiOj5znl/n5VJdL3ha16hFkZHjvWfzts0HP/cUzq7fW0znxu9CnNheXkiX/0rk15Pnn88eLI6HvxuR3VS1vfKBIX6Ymec7OIOAYxM+n9ZtJCUopDXT0J8uFDoQLL9Ejq66YmQHOJX4ss09Kp8KJhMJODn7Ccvsmz9iLee3zuyEHPJhQnALodFgkKr9yUkFUlFNvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6caR6AybppnN5ovtCIfxic8NCycUfB7SEW71lPQLpeU=;
 b=T5dYeFVxME1rZPzUMBZrxLnXxgVvAOz5rN2zioFg80j3fDoC4GmC+Xu7qVlg+O+BY19MQzQ3gGS2P1iuRnV6P0ZAjMqJxgWvGYOVPfD0U9cHnAIxswVKMIGiATcPPAiuw/VrTlhDrUhpBXQDpKu1vJUT8ZFp38u1I1B4V8zGaD3l3NWHscca/92nayS24IR/fxsmm5iQNzlRAVEibs/YZa1FWS/3uCXYZS6OTZ9kQIC1709aA7mrYLZO4YWC3TuoepTWYLALAw7bO9PLbRguyEibCWKvDe2MArylhE/j+aAnS8BjvZuMb3Lv0Ej7V//27CVR9L2Cxm4byKeLCOeqSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6caR6AybppnN5ovtCIfxic8NCycUfB7SEW71lPQLpeU=;
 b=NN1eNBqAHF7w00pICqKmiEJhy2tuRtn0CK02gVWGbbKYIPZdvoxGyJilbA6T2v0Wb8YjdMKOR+7ACV/6AnaQ/zknaNmxF89M/AdGqzKI3caBjaTTxpl1Io+1Z+/j/Y1/11TVPBD9krsw6pbilWM4n9vBpP4BF+ZZt81iPZ8xONk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Thu, 25 Sep
 2025 01:41:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 01:41:57 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: hpsa: Replace kmalloc + copy_from_user
 with memdup_user
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250923171505.1847356-1-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Tue, 23 Sep 2025 19:15:04 +0200")
Organization: Oracle Corporation
Message-ID: <yq15xd7s3zh.fsf@ca-mkp.ca.oracle.com>
References: <20250923171505.1847356-1-thorsten.blum@linux.dev>
Date: Wed, 24 Sep 2025 21:41:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5564:EE_
X-MS-Office365-Filtering-Correlation-Id: b8291fa3-0776-4d02-c207-08ddfbd4b6c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M58g7g/YLrdD3nXM1q7NTfge3p8s5HJ28piAy7Kdmb/714a4YJy1qDcNZVcR?=
 =?us-ascii?Q?/97T298yLxF29sFCuvouiYwgmsqX/CJot+P/aP2+fTUP/2seyvmTacRgH4WH?=
 =?us-ascii?Q?XagMnhLNbmr+LBC/oSMbU+06pL1jMaC4djaeYOxlK8LvI1rarhI/tGzwfnfH?=
 =?us-ascii?Q?IPbkylv1rPG+h1TrSTo4IrUjtudPCdnZdDOqhjNFjqmX62AhRMk/LIkUVWRG?=
 =?us-ascii?Q?ZwfuAFnconVE/yzagEi0VjuDoHHut4WONAGr45VW7ijGf0mxecNBAphXhteJ?=
 =?us-ascii?Q?oMmeEFzWOIPA5Qib000IqWsA9q5C5KrZO1Rn8fKp1nxLlf7oVCJWgjwKKoOQ?=
 =?us-ascii?Q?Z0PCWJHXZpdMN5elBzdN+adL7REAxWtvKKnpkil5Rmi8xlAksymdj39mq9Ke?=
 =?us-ascii?Q?va0x+GfwyVC8CNSciXny5fP52cTnVLbHn+cGi8fQrwHjscRwW2Mjwi+gDvku?=
 =?us-ascii?Q?64qPqC4KcZma3J3waaFMt0ajkVr1frk2vS72pXx4VRd8Ay6ay0ZFhYaqPlvS?=
 =?us-ascii?Q?kOF+n20cqNbHMzo+OJCEdSwCZ+tNy4CjdplByHvgznh0fiiz/sgjNUGsQXO0?=
 =?us-ascii?Q?vAj5X9EGnNuP0G8LAQ9x7feshrRgBVJYcL+NBnd26+fKaxmG2hmzDJWy8WXd?=
 =?us-ascii?Q?qlMDjiNvgdb/VrSHbIGtnGVJqwwNpMKWVkYU4hUWnK1BwXFmwhGjxaDR+wxP?=
 =?us-ascii?Q?04TyOmrnpbbEMdxnM/1Jr8A3k0WQZQn3F3btcb1LwNNedBdbanJWbrtYvxuO?=
 =?us-ascii?Q?ljpx/e3PJPQOWyIPBOimI6vAb1Bs+AB4Jns/Fvyl3SrshZ5eUmXaQbbMj+Ml?=
 =?us-ascii?Q?jGUrl2V+KkQec6nDMM70uACcU9gx2p1ReNjZ+AuSdt4umwPhrKePuLgqXDMH?=
 =?us-ascii?Q?EAwnyZz42qr09BBR6MNh3wp8mgcCWPtgIW4jmEBW/5mmoIGmhw2J+3Wjslcx?=
 =?us-ascii?Q?tkQIPM1cyYKuEBktoVu+72r4m0mn4efVjzYR8vNgYxszFNhN7ouR5395w30l?=
 =?us-ascii?Q?F7pIP+GOAo5FHYnNafZ50GejTuAUS12K6//2NoLFPmPGDGay0RQ+JltZSt4q?=
 =?us-ascii?Q?uuO3+fi67BeIHfhdFX1Lk+C+2Ge6M0hJATSuaePC8SMI2ePkSmRNgyaWc3a0?=
 =?us-ascii?Q?vu9BPif3cTkLSEWniK2sXZxb5+i/t3QKDw5lg9fQN9X/ktrR2ellBAuop55C?=
 =?us-ascii?Q?iRS7Jr+XMJbn0X6j/iJMjE2HLsHuKWn2I5rpgdjfu/PyWfPmRG1Ou3eTXgK/?=
 =?us-ascii?Q?7GuvMcvDsYY9rblFOlURxtrsupVS61v88abrGcQMNCAMG/xGYlVdttwlkB0X?=
 =?us-ascii?Q?SnhDpdMacrpqfcvnkVJQW+RTmyvf3CRLUGSso2LX6P2jCzIeozIjHpXB5UmX?=
 =?us-ascii?Q?pmHB0Ls3gpMYPBYSJRg+iqqIG9qSoWqc+3pk8H0RAfPPZVDm7ZBYbKR2Gb8Y?=
 =?us-ascii?Q?jLLRc0yxriI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lahrrAuf+oTX4MuNBHvV3j3aixdNEDNN7QJj4QMBZP2DidIIK4doUvDU+hxr?=
 =?us-ascii?Q?j39RkokMt06Xt0+dPytzgSzaiAGuOhN3LVAQARaErRTCBXED7gCVooTTW8c8?=
 =?us-ascii?Q?DJhGjQ2GqaLBMnJMyiYd5yYg7WYyZk+oiRNUMxAv6y1EL5/IS3dnbUcqaDVY?=
 =?us-ascii?Q?ukwsnjgbDr3HlKaLPantAwfrUaDdSIS1K8wiIdoCn11HE89OtLfsgDLFEpuB?=
 =?us-ascii?Q?R6t/PYAu+Q1V4huZvdslHT/+vVS9iUYt5MXagk7965OQXMVyEdL0rYSX+8YC?=
 =?us-ascii?Q?Z2QrVR4Pjm2PJLoPWnqSSat6Z9nLtt9V4zyp9i9rIaPyEOwbuQqARhSDVdYJ?=
 =?us-ascii?Q?ZLr4mU7cZF74ZDXHp5PnpfWTsU1i6kBW9+4EAWuEHQZH7K84Ef3yHKvF7sxW?=
 =?us-ascii?Q?gJ/mYiTzlpFQt9TPsk3OUdALr0xhpn0efgZSCHWBxqQniuU3k0UZCl7gDNPQ?=
 =?us-ascii?Q?Zm4aSpJvP0oJhnv0hfxTFbHQYzfp2l+CpxHqL7MUTvLOGEed6OQWXv7xbiYL?=
 =?us-ascii?Q?ek/CNDAJyt9eN7MoHQpukf2HoT5TwIzkj0iaSJxzb4mEPedjnwFrP7Rr2/yR?=
 =?us-ascii?Q?RqKDo8Nd6lZvu5UQmJlKNMw5ahJLy3k22xEUrujQJnBeVmW7CCvwZYkX8Kik?=
 =?us-ascii?Q?dYAkFNC6NcY/sPJSUHRLUqBPJGUkDndHwYO/2DavnHEsdMAemGRPhPIGM8gg?=
 =?us-ascii?Q?krNrYzRpahVB3uT3TACgonljCV+j0UjtbcnHNs1G+YfanDtn+LIVGRMkBQ1D?=
 =?us-ascii?Q?2s5gxVohD9NNt8h+id43rEGfRf8lZ5zL58DxA0bDY4OH76fI8ZfWrk23sn44?=
 =?us-ascii?Q?Sh5FZp37cW620JKYG8/BfxSdDrPTJRR94CAGOOQUdCIV9fH/+4X97dYn6WyD?=
 =?us-ascii?Q?fnZ9sxjIu2hlZbanRqMt3Lwu4n6Fp5Hopr3h5CIkaLt/6FiDsaVZxnvPqL3N?=
 =?us-ascii?Q?PBsGAn9CmE/GO/NHxPJC9EGmmq/RFGoFt5TJchviZsX5FEXhwfIUq6Y6cpOl?=
 =?us-ascii?Q?gZSswv1ajhRIGn5R3Glif2/IqY2ElYF1FIFwBrv80b7blKZWQsKGYgLQeXyD?=
 =?us-ascii?Q?pLdLEZy6p9/mRd/t+zpvGmW4iqY2jaMBWDqM7TKZO1wbgoeM+E/a/S2kXk6W?=
 =?us-ascii?Q?0P1DrJ0njhk/cJSskT7fX0bNpxTy2xoQ/p+WjHGgs7fA8DvMMGDMrL7SGuc5?=
 =?us-ascii?Q?fyq7S4eY3lR4URHgdzDYWd/bjMSYGR25+A7PeXEsSo6yQXXlwDE9IjCgyn/t?=
 =?us-ascii?Q?BGOqXaAbiTlRKkznI7O/6bCo3FgwlExQyLhFWjkLfoUIpnjgq+2XusJ64dpx?=
 =?us-ascii?Q?kMftYkYLREz3R35xLFTAlEgMa06VQIyWFAJStM4oSbMgLQmoS3lCKChhOtt2?=
 =?us-ascii?Q?n593ePPFbVGX04VPmA3Ti6HZswGhGf3Aa5Fk28r02YxjyxFB+Oi9P5VJjrUY?=
 =?us-ascii?Q?I85czM+uQFKnR8m0RHVKzXic3B4ydROvviZMJDjwv3lCDn2mI2Uv4SD/u1SC?=
 =?us-ascii?Q?xl8MgXkS1aaSVyn4pWpL34jamuZhO6Ggr5k1u1LBml110WGytwwOXfC316Vj?=
 =?us-ascii?Q?dS41GZqCxoE5yLUYYDEJ56uljQPOpCC/JaVfvhRqs6F+ZP/XCd0FG6hvM8KE?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kWt7iqKSIjSkcDGiGhfpYnraAI4G5THUg2AMlXiEvfPqMth+8G4x8Cypna9tMnZ+QKH4gYt0fXC3D3Id91v9MT63qh4WGvC4XvGR5ckPVV/XjoDeosTProXulwqUo1/6T78atZeOUweKUpnMz9/quwTRrRZuL9fc9RrpYJbVGIqLC+7LSpzBhWgmwoEvvvMfCilfElrTJapgshLDpOjI8Q6lZQ3QvBuUOzdDw0nssFM01cbB7MReMMRhaduuIm1qiZ4r36CWEkum4UZdIm26IAPX/gQ75nctWUUwpL4XeAHrS0m4UXElTytWEVHKJyttkE2L2FMmUTnzaYlKSPgpTpm5BceYn+vcz09XxQpRiAKXymFhXakCc0ZQ2VI6Y9Fkwm0VeZtMh5yVwc8RU4xlJNSJ1I3OfcAdDQ/ApqZNyAVNDZndADVdwP3bemZB2xISVeKvfhRhGBZz4akKmERpq9GUjteC3BLg2s1TR/o76x8EtemPpXwNFpGdtMNv8MOrjnqOx9/TfQqvlRn5zyRukcGEu8xCjByEyTn81Jjo4vuk/DDsThzrU1oxN3LVezb0BoEqP/hye4InMZBAtveaLMoF7SBWWAw/EDoOZoNBb+s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8291fa3-0776-4d02-c207-08ddfbd4b6c3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 01:41:57.5628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgISBlufMpoIIXOtjsVMLwnzUZytPARMfQ0Sk0ajQyKIrziIsdRfN71aTIgmeM2BlfS//01+EleJOk1TWDm+/qGTlN8V4MO4/hVJECI/0l4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=813
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNyBTYWx0ZWRfXyVSYDpVK/lB0
 5ViPkTBMONsFpJrKstqEsLLAYuGESOs+Ag22w9zk3IgSWd4pMnG8qy1ZHEow3VMyWjSzhCUS5cr
 6ZM0Qbq38sVC9Agiy5UKcVo/+5Ug0+ZYoamR2CrMxD8MbZgrUxOtTPQW71hkHDqmbflGlBwj9OT
 N+xly6CoGxza0SAZDMQRD0GKt4PWJWQFX8SevFrXkyaJmG9lGR0Sqiq2cB6Vl9CCWqM+fRbzHQi
 fZIA0MczrSYadLqSeX59gX9okb3xr31TTYF3R3yqkj1I3BW6nEJAibphdwWn7ahHnObliTzZwZm
 vfwPSDSRqrYNnl90j7uRjBtlrVLuWp6nwq2ZESVVFroG4xgTCyDNbFciAkfKqZlhUMIjX8zA/Gu
 gAi5c2Gw
X-Proofpoint-GUID: StUOstuvOl9yDSyropoGesZ4egyZFxBM
X-Authority-Analysis: v=2.4 cv=E47Npbdl c=1 sm=1 tr=0 ts=68d49deb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-ORIG-GUID: StUOstuvOl9yDSyropoGesZ4egyZFxBM


Thorsten,

> Replace kmalloc() followed by copy_from_user() with memdup_user() to
> improve and simplify hpsa_passthru_ioctl().
>
> Since memdup_user() already allocates memory, use kzalloc() in the
> else branch instead of manually zeroing 'buff' using memset(0).
>
> Return early if an error occurs and remove the 'out_kfree' label.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
