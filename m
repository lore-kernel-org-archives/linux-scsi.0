Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F7478E57;
	Wed,  5 Aug 2026 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962566; cv=fail; b=IzbRbibDrjB+ZAqFcxwj42JNM8k/E645jaNZj4NHX5rTm5mFyP2SzLMm20AYQ/k5n/JgVpksBEi44Ya4mQA92apLS5sWamlOY7SRV7TLrgf8SRCnN0+7783ilFXkswhq7wKjyiO0tvQ+DdSRYm+BzcY09GoKLfs+EPyE+uRR12A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962566; c=relaxed/simple;
	bh=C2O/0WGgRP7aUMM2tYrnouvPZ8RG7av04E23TAhMLPU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=GhE8QnJPgA8VM0MhkGZs8RFmaB5w3ExQj6OXLoTsXLOZ5JvmwIWNR2bTbaJDzT+Ip5nDnf9UNVXvR8flBhiHygU4pyCgILYBiPB5GpR8TaQTwM3+PhlsVtcVRuE5AlXDOwC5QdrrkgQH/FdGEoUJ528KIXaWxPYxQJJiOSb3O5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E3i9lJNI; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ob1qTazX reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E3i9lJNI";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ob1qTazX"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Ja8tA185266;
	Wed, 5 Aug 2026 20:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=idCDCfnzE6uWAmR6+dS4fXD+qaDIfxIBB98hBqvlONM=; b=
	E3i9lJNI+V6F0hyO14SVxUDFgqWxPLb1kZAoPH+tPZiLfDXuijt8kYdqWQr/99Gs
	YBRb/gKYyFqbsma4XZBkZSZydtZV4Q8bGUBoZqCTLuWtbL1T/A/5gsLbgfZEQgTm
	98cwGa1L1CuVtxO/ngENCFuC7GxpgrnedyxzbPtyXIwdRyFja53jWcC2dLVesSnm
	geA+CP83a/r4kA1uYNE3bBZ3s5TaeeL+3/SVFP6ZNN+n8evriVQx5ESvuODl/hmQ
	hm8TcUIEs6vkf5yjWmuGs/5IpvgG14YgGFlzFtyGB4ypTd2cBeD3b8+xCoNy0PAc
	2nLIvpD8WitdVfSnitTPoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p99v37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Aug 2026 20:42:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 675KZ8Ua014651;
	Wed, 5 Aug 2026 20:42:35 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftpyu189s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 05 Aug 2026 20:42:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DTJ4BKAESPHT/xjDsO4Rr5I900vVbgFtee8HBNeqRhNqKXGMXYgCjGS1DcK5IIDeoqYatJQGXisYVOGGeujv6SMgLRnI2kG+Gy9hLfO74nYLU/pE1HUcDDevRJoYZFjEkbLDfq6Zk8MsqLv1t8G25WnhmuFqqdU149aF6HcdrHLetMsWo9UDolMsxlNyoTyB2uQL0Gi3tbdh/bGetGBHAn8dYXXEohjp2lEV0sUGsRbmy16jLfGPz190h1cDhFvcVjA1zQkEpThIbqBD0zBjB5sItbZIe7sczIDENjI7Sde4cmwTyiGwKYlOeIRkXcOsA477ITK45GVVvMykZWXeHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDmcnJZeNKnud2PqBun9zyVrutbtdUYIHByQsGpaXX8=;
 b=HGLpNFJdftVb4aY+4yAn6Fb41v+R+3O4VpAE4q3eDpnOJ5ka6znnTmVFbiG+2G/MsJ+CXNPpyeJcY/oJMSvOditRSICFLhp6ODZUD+sBx6uJ2ZkqmtP/RRq3EF8CvOy3hnjmgTR8+afeiKR6epivDHSs0WxFd9TBbDWgk8RC8mYPznUQQG36CmMT7jziAey3nTs/Fwzu5c3MrXPCNMQEV/A++OKYPVSHne7J26EUwHrSHQyJkLnzw+xbCovya7D4UQiLZM/dYrqY0xepWNmZii+lh1PfUUSDtNzLTQCiPz08Q6H4IV2Bj5nvS/dtfDOImWBiPcg2IhovpbyCmLP4wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDmcnJZeNKnud2PqBun9zyVrutbtdUYIHByQsGpaXX8=;
 b=ob1qTazXghaa1LP7grX1t3OKaW7ZfvTChhdBANo/Qks+u19YuVu21qOt7sgW9cd5UmaFa+50XHPE/D6dAgvoM4jt9FNZKDox90e5g9Rp8ZTMgoY1EUrZyHW+45l/p4wHm5afWCjdiAK60JD+9fKflslZaXkFsKScN7BKg47RQUA=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CYXPR10MB7973.namprd10.prod.outlook.com
 (2603:10b6:930:dd::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 20:42:31 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 20:42:31 +0000
Message-ID: <630db8ca-1126-4790-8ca6-2bb8e5e7dbe2@oracle.com>
Date: Wed, 5 Aug 2026 15:42:30 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: iscsi_tcp: Fix null-pointer dereference in
 iscsi_sw_tcp_conn_restore_callbacks
To: Jiayuan Liang <ljykernel@gmail.com>, lduncan@suse.com, cleech@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260805065326.1952-1-ljykernel@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260805065326.1952-1-ljykernel@gmail.com>
X-ClientProxiedBy: DS7PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::15) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CYXPR10MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e8229d-b931-44aa-3e38-08def3321222
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|56012099006|4133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ve6i+yMWxP7yLDslcYz25WUil5mZ0NS0McF06fvocdqfCsz/asesIWYlCo46VRSDwPNOujeFwpOdoyo6JoYWEmUvQB3hA3U9u7t9Im8QfquD5y/iVEu+UvbHfdym2kNUZn7ema4Haol9HEaGMSe+1oup9WahD1MKLJgrA9Bbo9aPJs6vE/2wZs2FBNlvbAlXDkC4ppmD+3Rs9IRuTS6Wt8oHPctlDlY28dd9H2AoTFwbevxWn2CIGiEIiOEDskXjeuhy4Bq6dKxHq5YXH0m0bpquf/8sZMQHonqV6KiNMqbaxdAXMhrLLIvm5viDTM3LZ2TyHVCwJ/ovS/8whFzTvO7o4KUUX1lytiIq3iBHcEHGDQLDjiaeu74OLaE50e7Gp2BsEFbtkGF2WYYhS7xL9//+8ZcS9Y5YHvm803D9uke1jBeU/mhp1Qcd/WlEfBvTdV3LQPaEqP46e8Fab4XEWclckRqbLqGEMzgkqeNIWHaKN7efM9+Liaf+3BxBNTj3UJ/5NSUC/aFvF5hXUI0+3HMcsq6pkaCKGruRWPXJgzqGuESb7HnIe6jb2HmZhh80aVPDPMaRf9b6MKLTFrX0lM4hurE4V9UbIqXn9EwhfXMOH6aIb7q1h/tGgzlI4xt2ghsZ/gYNt2pgygXWQzpokxPyPM9E7gzQN3ylud6fUBs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(4133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1U4VERkZ0RsdTMwRXQ5R2tWWldqY0VLRFpqL1Q1dmFBV2F6Z0poZDZYanA2?=
 =?utf-8?B?M0oxVkppZHZaNHdmWHFFNnYxNmVrNE9BVDdrQWEvVEZURW9zVjRGbEl3RG9V?=
 =?utf-8?B?S1IwdkQ1eWk0L1ByU1hkcVo4RE1ZQjdvTzJEZStuMHYwSmNiL0psZG8yeFQy?=
 =?utf-8?B?REZadkdtUENvTEpWL011Y0Vud0FMang4MWJjamxaY2sxQ0NhNkRHZ281Zklh?=
 =?utf-8?B?M2dOb2lSYTd4UTlLUXcvREd6ME1ZZGx5ekk1UjJoN3IrdlBOcU1CMTd1NDRK?=
 =?utf-8?B?T0xZbFdEM3QzUTkxVGpkSXo4OTdrY01HS3lTYTJ4V3JxYVBzcG5vUzZUd2xE?=
 =?utf-8?B?SElOd0NieEZleld2TWNOd1NSTWR1cjNPWVE0b2NuWkFUdFVKeWdXd1gvamNH?=
 =?utf-8?B?TFZLZkxvMDFHN01tNmZWUzExL0JpaExVaHVuZWpiWnZtOUZoQ3YxSHZFSFBB?=
 =?utf-8?B?VXh1cWxDcE9acXp1NnhEZlM5RUFhcHhtVVpEeXlGVVNBZDU3RVovdzJsL2NQ?=
 =?utf-8?B?UWdYMldvMkdsVHJpei9BZlVScjZZODZEUC9BeVdidVlUZ0ZlQTZ2UTlzQ1Y4?=
 =?utf-8?B?Z2NHalVoZ0VwcGdRcHRUQlBzeEJqSVE1TlErOFNPVXRpL3RxaWFtZEhqL0Vr?=
 =?utf-8?B?cHozOGhLbWRiL3BFdnMyeVBzRWJGZUdGclZDV0krVkFVcGgwbFVxd04rWDBL?=
 =?utf-8?B?WHpYWTRvbElYZFMxRTFkM2krRjIrSmJIVFh5ZEVmM3hqYit4cVczTFVPQ01Q?=
 =?utf-8?B?emlpTkptZWJ5TU80ZHV4Mi9kcmZ1WURzckt5WmM2MElIamFka2ovbTVtOUZk?=
 =?utf-8?B?c2NPdzN3WVNFQnduTk1LNEVqazJBd3FTRSt0eFBFNDN2UWxiek1Qd3FudmtR?=
 =?utf-8?B?eCtPY1lzakJZaW1HanU2K0duZ3BqelFIbjZMb2FkVGJFT2FNL2tCUEFDVWhD?=
 =?utf-8?B?Z1M2bDRkSmJDT3VFL05hUzhMTHYrenRTdndLRVhVZHdkQUM0TUVsVldJNVpY?=
 =?utf-8?B?WS9FSUg5bXF3Q3V5TE9OQVJiNmhWWkQ1aXJQT0Q3bW1sNE95a0w5TThmeWtm?=
 =?utf-8?B?VGl1ZjliWUNjZ1R2QXhKWWtualpqb0JpUHlvcDJKZVBWUVVlcVZiaFVUUmo2?=
 =?utf-8?B?YU5jWlU0WHFkZUwxdFZzN1QwYkc2NU9PVW9vRzhpZXdTYVNWT3d5b3JjTkk5?=
 =?utf-8?B?SXlwK3grSHI2NytPd2hNNmFkSFVPUFl3V0swM3IxaEtLTmxENnlUY3BuT1ds?=
 =?utf-8?B?SnVRWVpCa0ZFdEtiTVlwZXNnVG53VktSOStoWm56WHhSK2tKUm9ua1Y2dDJ5?=
 =?utf-8?B?dHlLUjAzQ1RndFZXcXVtZkNhNDhZYnY3N2xRTUQxUjBqVVVGd2lGbFhZanJq?=
 =?utf-8?B?QnowUUloSEUxOUdnTFJMVkQ3YVBZemMrQW1LSlNpOTc1c2JGbkpRRFk5VUVI?=
 =?utf-8?B?OW1nN1pLdnBLUVhkb2RLVnhIWDFoZTJhbmpnVUpqR0FpOG1FVFhsMHo5Ri9D?=
 =?utf-8?B?QnlZNGxDWU5XeGhXWW5naWYrZDVva1pOZlltcWFrVWp4L2FNK01NcjF0UUhx?=
 =?utf-8?B?dmREOEMzREYzRDFocmlYVFR5dEZRYXlkQUd4VkJ1VE11UnUvNFhNbFRFdHNF?=
 =?utf-8?B?em05TDByM3ZMdGh5MnNycW10T0lLN3prV3A3UWswMHNBQ2dLWmVpdDZSbXY1?=
 =?utf-8?B?c0hxb3hTdm5nWWVXRU1WWktqVjUzMDJiMnNXNHlPQzBreG9EZEx2UE9Cdnpt?=
 =?utf-8?B?Y1p1c2xvRGtVSG9ObnowaXdWUTIzMzNzS0pBaEcyb3RzNzJyZUU2ZUNlemg4?=
 =?utf-8?B?UTZDbVZOd3FLUFJscnVrQ1NCbU9GSU05aWNwMXlrRmc4SjRnNmZOUGRsZUtl?=
 =?utf-8?B?RjZiUDB0ais3UkIzY0FyS2VPZVpGM0ZBd1VObmQ2aW81dU5sbFg1OXlkeFdO?=
 =?utf-8?B?bUIwZklBT0c5OC9lMFRLS1ZiTG11VGFXdzFiQ0JLbEVWRjcwRTcvY2o3QUZm?=
 =?utf-8?B?d1dlS3FtVUNpSnd2SXRmZzhYbDZ4U0NjeWJjWDBjSDZVUFpvQjk3akloc0Ir?=
 =?utf-8?B?dkh4VGJjNHFPcHZpeXNoWG00OGVlMVFTaktQWHVIV1FuMGxXRGVXVDVIcVIv?=
 =?utf-8?B?dzZ2RFRsRUdOcUxRUkZ1RVdUZnpQZkQ5SUpzYkwxR1NHOGlDcC9MQW5PbElR?=
 =?utf-8?B?by95WWsrZFo3ZHo3ZjhUR2dpR2VjRnpqVDZoOUZDTVZVS0dFakZaQ3lZREtJ?=
 =?utf-8?B?eGRaT3lSUmJZeG1GNTBvUzFwdXlMVnFWL2FTU3BQcS85ZDl3TU5yanVaTFZ0?=
 =?utf-8?B?ckdSc05KNVFZcTdMNk03YVdNRlkrR2RYOW1zQnN3a2hKQzRSM2hBN0p5T1Zl?=
 =?utf-8?Q?iz05ZPVvKdwJXJes=3D?=
X-Exchange-RoutingPolicyChecked:
	mn0ZjMdzW7qFhwLJSk8z8z4oFWxx9KerYLEnXBuim369ORkl1Qvb2F9/C2KtSDUcLb7cPGRsEwDfcx4DslOinfwSON5UMMTCUbwz22Ay5w+QbXh2qqjxWoxNS6R62q6mwqoWvv95JhNGen4EGiJ7y14oNPwsmQ/t3w7VCtb6ZdsF4vzogtPxnLYe8cPvgW3DuqbkR3WXm13fltbnucwVfTZwnCm5Cdg7e4c/Y8vpXI2pxjJdA43SFH40K/TNIVQ+FoWTky7WEuq0eokIDHdcrOtMqRvW1xwBmrms/SgC3bPAn3rLZvUbGsQFrLo/8YpEDxNvRGHrRqWDmwGTLzX9Rw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HMbYY/CkElqrwh8h3Xk3IxZSTX4EF0fX4zL0fZHX5hXNhGCGGY5MzRWYmFhNesLPZFacePfWudS2IQd20CHBl84QuCIkoEC4JK4fAovER83z8bhzyKJMD4rgxvaibt9XaqQE74STPwpl/J1rRhP7xZA0thY5hF8afvLORb5YS/qBCEyY6aw0PSxvYLWNagUTQhGvqO3EV25r8D9AUg28Qi79q9EXv6QzyFsPHPgJ1o/8IO8E+EpmC7ioZAaMG0fHKapTiKxiJrDU8GWOuQeHHmyfX1Rd8AlhU/N5d+ciX0dsdYvoyod5PiNVq75QfVxp9HeTeWOIdCEYP+yZZLFLEdRQxbpCTgHM6FtHbSZnVVWPFJ8DZKGh1IZg1qEPPJ613dZqBDERBJshpH7AqaqNdLVr3o/XdwyzZ1jAdL4JCng7j23NugetBOLPCVm2MPV6z4l/e8VsJrDkrQhEDdcG/SoyWwEjJyefm1Xzj9vtSMsMPDLi0AjIIvy7Wvk92JCqzRBivFe+5vIP/fINz4vw4oIHYjpkxAIrH4QePsBfbJ11I45PdjBoVnqi55FpyoBAQFNhn0IJJ7biWO+ppjfRMAXnrdXC4d5v2Tg5TibKjgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e8229d-b931-44aa-3e38-08def3321222
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 20:42:31.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43kuy+f0C6K4avSPzYW4Vp91DsqK5Cy4Ob0M488mxvWsZHvE9+JIlQ5ALe32ZEzzVvI5400iUhXVxN8U7qEro7ckzwllDf3BTXvvB213Cpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7973
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=961 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608050169
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDE2OSBTYWx0ZWRfXx/RX97cFvk6c
 R/AX1F3NV+6cri1EtGmuoJpgs7MWtluGuwli1vRBkITSQ5cQGy81O5j+xUR2xDVAyORIA+BUVhu
 c79o9o4AoG7M5FcOR7MRjDPfRJ9Sqt6Xts7acvgs8UtJ4T4+OEp4
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a73a03c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=RpNjiQI2AAAA:8
 a=79aDfuaDcFVvOdvj6eIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ncscIb5EcCHN8-WPjJ6jxIgD1ThRea--
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDE2OSBTYWx0ZWRfX7XrAPbcPahf6
 Sz2TgTFzVgmTc7zqbpPj6E1KWFWcn8odw7eoiDDTgPvfYvAAQJBHwn12mJtVZVFNr7uvhTDTYrg
 Rmb8UMs6Zw23QRvaRxdTXR0VryFY8ZRSrwadtQRwAZ8qoBIKJKw6MOKa+kx+h5BliMyHewAnLHx
 xBkiw6R0W1pr3GhFFUh5P2yj9Us8zFcd8UDYz+44+GjXAD8jA1puPrjULVufk+Bypq/Bwe+ExIG
 IzkPkeBlbCYk4QyMrlbcXabEqyWaqB/pHWYI4roo/kfz5gOZ+xJZFpTOX8Ud7EH1gFjjq8T8tew
 fKC2eGb0qfWZGPQfPJJetTlcB0oilU6S9FRmzZ455HkRdodOAGGiOjwMc7UIM+PInr0LNmTiOLo
 XqQXLsXu9eB7cUXAYgYEAAy/6qAxBmg5xAWAzMwGsZGyg3LjBBrGvIUYxKjC9dH+bDoW3LWYZnn
 8/fqaRdrd+ts8TVUgVQ==
X-Proofpoint-ORIG-GUID: ncscIb5EcCHN8-WPjJ6jxIgD1ThRea--

On 8/5/26 1:53 AM, Jiayuan Liang wrote:
> A null-pointer dereference can occur in iscsi_sw_tcp_conn_restore_callbac=
ks() due to a race condition leading to concurrent/re-entrant invocations o=
f iscsi_sw_tcp_release_conn(). Specifically, the re-entrancy can be trigger=
ed under the following
>=20
>=20
> A null-pointer dereference can occur in
> iscsi_sw_tcp_conn_restore_callbacks() due to a race condition
> leading to concurrent/re-entrant invocations of
> iscsi_sw_tcp_release_conn().
>=20
> Specifically, the re-entrancy can be triggered under the
> following scenario:
>=20
> 1. The iSCSI client initiates a logout, actively stopping the
>    connection via:
>    iscsi_if_stop_conn()
>      -> iscsi_stop_conn(..., STOP_CONN_TERM)
>           -> cancel_work_sync(&conn->cleanup_work)
>           -> iscsi_sw_tcp_release_conn()
>=20
> 2. Simultaneously, a server disconnect triggers a heartbeat
>    timeout on the client side, executing the timeout path:
>    iscsi_check_transport_timeouts()
>      -> iscsi_conn_failure()
>           -> iscsi_conn_error_event()
>                -> queue_work(..., &conn->cleanup_work)
>=20
>    This schedules iscsi_cleanup_conn_work_fn(), which calls:
>    iscsi_cleanup_conn_work_fn()
>      -> iscsi_stop_conn(..., STOP_CONN_RECOVER)
>           -> iscsi_sw_tcp_release_conn()
>=20
> If these two paths execute concurrently, iscsi_sw_tcp_release_conn()
> is re-entered. Since the first invocation releases the socket and
> sets tcp_sw_conn->sock to NULL, the subsequent re-entrant
> invocation in iscsi_sw_tcp_conn_restore_callbacks() attempts to
> dereference the NULL pointer at `tcp_sw_conn->sock->sk`, resulting
> in a kernel panic (Oops):
>=20
We don't want to allow iscsi_cleanup_conn_work_fn to run after a
termination and we don't want to allow iscsi_cleanup_conn_work_fn
and iscsi_if_stop_conn to run concurrently.

Can we have iscsi_if_stop_conn hold the conn->ep_mutex when calling
iscsi_stop_conn. iscsi_cleanup_conn_work_fn would then have a check
for for if the conn->state was ISCSI_CONN_DOWN and if so not call
iscsi_stop_conn.

I think iscsi_if_stop_conn could also call cancel_work_sync
after calling iscsi_stop_conn for both the STOP_CONN_TERM and
STOP_CONN_RECOVER cases instead of calling it for the
STOP_CONN_TERM before calling iscsi_stop_conn.

