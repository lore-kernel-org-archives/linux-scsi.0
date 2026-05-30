Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE62E7394;
	Sat, 30 May 2026 05:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780118640; cv=fail; b=nPADQ29/HwT6ZscQvn2NTGQqw4wRRdjMrIotI+lMoSxtojft/R1Z6kJ4XX8eeAEZxku4TB5STse7kcD0BL3JHI+s3ZZunn8MRv+swx7tb/fAmYTBoqxwJEgjpxUK99n2+Si/oqWJsZ363/KwNvTTzPdhwb14PBP/4e27lL8lGEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780118640; c=relaxed/simple;
	bh=iTA0uLyu9r4h3KxxRVlRYXQhJw9vOVLvHbiSRkv+JEA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MqfjP+APdZWcuwS2nNqXst/dvTjBaBuZKJqKecwzQDbMs4XogE8aAIIB7zEFeLUqphhDq0ZOPeGVIstxdF2i3Vg65BOeS+/tdwdtJts+42Sk7q2/u8+j/0pH/AdJpsvZZjh8FNS4ib1FFH1AF/hVObv7fuhRPw2cbr4urZ6BqSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=meD+xuFQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qpV9sSc7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="meD+xuFQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qpV9sSc7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64U50OZQ3200922;
	Sat, 30 May 2026 05:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=cWiX26sMWgQX1Dkl
	J4Df96v8d/JKhjLHPjE9tFFBQOg=; b=meD+xuFQHVTMKLMkQxf1MjryCuGG525z
	TmyTze9Ci+HD0wXfumdE/LevQM85tCjfSRAIKKOWP6s1JPTA2JPLm0KlaU8qhtej
	EspQ69rWehISkd1IUDhoSj3ML4Rmntaq9bq375WQ0IxJ2Vamr7Dz8m+JlBVJU80y
	w0j2iwgSrmel7CkRWVFF8heNsSlGqt5wNHWLRgeBfjRbfM3w8EkK66MXYLj7PhT2
	BELEBIJ1T19Wb6iwRzkehH42FyIwFbakP3D+mTg4/EzGf6VyQx2kSsCxRKzZhGTn
	SMknqUdtEazKfmvndkKBKZ5AqX9yX8rf4etHbDetAT8OtLQnc748iw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpaar4se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 30 May 2026 05:23:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64U5Jqhw017980;
	Sat, 30 May 2026 05:23:56 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpba3v44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 30 May 2026 05:23:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZz+S0jew1TASKCEctfIrMhiouZj+eBaJ+WWBJDFMxoDeE0HDdndsxoJa8WL0ZzK7Qzfj4UMCeq1GoNA86G9TeM2NKSM2GDRU/mpDOGTj2zZevBgDjSusmnrsnW555MGyMa5rkps1kOosFk0yzfPlECXqCaHLU7nuJUIXbvcA8By1xapKiB5KCVm8Kppl9WzI/jbS0u6t4XXITr21LRwAQ5LUaV+ZuANpM386SPwyDS5+RKqiGzJwmr8OQBlScE9Bm8WTgdBiEq5vEfBzb7Cz+fHda4r29DkZRnbs/ubvtqzcLPy1T+l0VkQqZQ0xU+Xn1a4Ar6N+CZG91XTvEozsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWiX26sMWgQX1DklJ4Df96v8d/JKhjLHPjE9tFFBQOg=;
 b=rO6QuJOKU7Mw3yqYbA7xKqqrh0xixCTvXyK0/vnSn7xEkfG8xXeB8oUPZUEMs8vIV8QVYub7zGHxBpcu5GWPZU0JW0N/ckHPY+ok2IAz3+maYKzNiRozJPcOCmmFhMtJ9sv6zP7oQjoxp46HvAVQu52lm0eUd3dVMvKemPzcZQbKncr/atAWkoAVSxKLUFhA7rSrJvaKi64fYkiIH7nNvXlpJ+FZkzQUz0TmCsKe176eZWLFiNDsYHxyF2wZf/7BUUA7FQft8sqggo0deJdVf4MJFY1vAE1KETGJh4OUOuydfB3E/C31VjYxK3X8SJtyw3H9jmfSqQUFmoflVFCO8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWiX26sMWgQX1DklJ4Df96v8d/JKhjLHPjE9tFFBQOg=;
 b=qpV9sSc7LAfHPz2hbvqfzHZV38mSSIgzVFILxtL41cQLTS0/puzOh6sfm+Qzo+hSfZ2hZwtzMo7qhLd210dnB2bC7Ru6oSiAHVWpsKLpcIG0P/oXKBhe91+AoaeFtmPjpa4ZD9+rVqc95gcuy/b98JMQViAihWGArrMb5K5VIqc=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CH3PR10MB7575.namprd10.prod.outlook.com
 (2603:10b6:610:167::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Sat, 30 May
 2026 05:23:51 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%4]) with mapi id 15.21.0071.011; Sat, 30 May 2026
 05:23:51 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: josef@toxicpanda.com, Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: target: Remove tcm_loop target reset handling
Date: Sat, 30 May 2026 00:23:47 -0500
Message-ID: <20260530052349.5134-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::23) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CH3PR10MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d98f508-a4b4-4637-0097-08debe0ba279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|3023799007|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	BtLHt0FxcJiXUpwO7sTENFJTerL2N2nsjReIDmob/Zid2Jpu1Q7m6GwYqJcB+ZVtwJvRlDKmPAyt5Gnvi6DOlghUMxjBxTOZ6c/zro7nB0p6+Pc2TtO+lhpWjB3q6Ac3MaXFgnudIrmXTvtC2gqDjrA0YjsTrHIgXg582IPLrSmTvEW78a+3IaEEVPwR+CHhbeTUTfaOuw8EbnaQBFqREktGIjAuh+Ckz0MD43uruG4aPf3h96fJ8DrBIX8ZOwRCUTYEW8LGRnbFBs9NKmoRRyTuN/gaWgMVrYMpmdRJso9BUkgJIFvvEzKwvl1jjIGAzsg/ZJIa0Ofr3XwGfRZ2Jk/c/DAZbFCQt7cztLKa/To0cXoM0pvLub/FgAZAgIabQNE2nw8RGJbMi9QvjKHb09d+pBbL4Gh6nFTNU5wpK4+QsxQbpHiUnRVVBJY+a3YxI5QPINAfdGMtqCry5b5i3nYUKpJouuQmyTyIISQvocpJYBNu3AguH0tEC8gcYCFrfQ9ZhI9HuERVltHpr37GWQvg26gH7Pqqarw+gJtG80Iob3HsLvzF2pqjcCgmyw4qs7HSp6uU9dYBpOu6JQLZsEgfM+fZnYZMJD4WA0GfuhBJb1mjpVh175URFlyHffr3kV+bJzDVfc+gkL50uk2ZeHk+u5Uu8ibkpV0f8nC0KpkZMlqzffmGNYmVrdVsnQQM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(3023799007)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWFNTUMySkZ5MU5sbGdMWFVkWkhSNU5PVU5QRTVLaFR3TVhyeEtlY1VsdnFW?=
 =?utf-8?B?N1FBaDRwZFJITmd3R2dUMlppRFRmQ1d4Y1ZJUVBhcjdwRC9nRGxZNWtuSlBo?=
 =?utf-8?B?bkhzSVZmL3ZUdmhucVRlak1WaDhvWXVYQ2lRVjJyMkhzYi85NXNnNDdjb0l5?=
 =?utf-8?B?VzJ5ckNZL1Z2RzFTVnc1d1E4emJHSHpLZzdCN1N5b2VGbVdIV2tSSlA2OWZU?=
 =?utf-8?B?VUlPN1Z1dE5tYmcrcnRPckhkRFljWEF2ZWQvZXdEZDZrVVRkYnZoeWlYN291?=
 =?utf-8?B?R0M1bVpvWWl1ZVpwbnM2NDRQaytKUExCY0pFVkVpZnhQaEdBcTdweVg0ZnhC?=
 =?utf-8?B?cHE2elRiUXUzZXB5UWF0NTZLc2l0TUU2UjhYdHhJTWlWK1R5QXpmM1NuaGFX?=
 =?utf-8?B?R3I5bE9LS2g5TDJjMTVVZEZFV1cxeEZZcGpoM1YxMDRLdUtyQ2IzZ0s0RzUv?=
 =?utf-8?B?ZDBiQTlnSXdCbmcxTWhQdWkrM2xQWXZxUE5BcnVGZkl2MkJQMFAxYXlTMDdz?=
 =?utf-8?B?RjVEaU5DRXc3aEpOZGdXa0lyK2F1SXhlU2hiYUhWandRQ3ovY3BVYjF5MW1z?=
 =?utf-8?B?UEtsMlp4a0JEUUxkOHVyQTQwdmpmbmxwTWl1UEJza1hYbDJXaGY3TzU3bTFB?=
 =?utf-8?B?UlFqL1BSUHdwbDBOK2pOWUNaRXkwSFZGYlBIcTlNR01saUNuRVEzU0NCTHIr?=
 =?utf-8?B?YzJJOVlNZkMvUGs2WEJETUk4emEvQ1pPdDJ5eFh3SHdhRjkxaFpBOXhxbURj?=
 =?utf-8?B?TTYvOGlBMkVHUWM2aG5VcVlJNDI0T1E0bHNGV1luSTY0OFBxQyszMHhxeTJP?=
 =?utf-8?B?Y0wzazQ3VTVJU00zSUFlemVhZkQ4ajBIeVFVSFY3T2pOUVplRDVsdTR2b1Y2?=
 =?utf-8?B?R1ZDdURaUWxkM1cvOXIveGpkU2dsT1UrWHB4TXhwdk8zcEFvenFPYTVVc3l1?=
 =?utf-8?B?THhDeWhnK1Y3S1pSMkhqekdQMERmYW1IVzRhWmJDZk1zeFBJTjgxdjc0Zms2?=
 =?utf-8?B?MjJLazhOclBRQ3dnTHRZbDA3NDNQTC90YitTRjRHN0VKSHJrSC9QZkZhKytO?=
 =?utf-8?B?WFRNWXR5L2JrNVI4UVZJazJ3OGFaNWpmanEzRlBHd3FCbjVMeElHQnJzWlEw?=
 =?utf-8?B?aHkvR1lwTjMyQUIrNVA4aUhpOUhSUU1sa2JwYTE0c2s0T3ZxeSt3WFhjVENv?=
 =?utf-8?B?Z2o2S2E0Z0QwRDlYWXZ4WE5vUGprRitwbXdEOTZZWG82bUdmRVFrMTFjd0lt?=
 =?utf-8?B?aFVsek01QThoYy9LNWJ5Y3FVQWlnM0Q4MTByV1FDczVaT1d5Qy9Yc291Mm12?=
 =?utf-8?B?bjZoQ0ZEZE8zSnBPbWU2bFd2TW9wZlpmcFJyZWNDemZZekZzUkZOZG9OTWpT?=
 =?utf-8?B?N0RYR1R4S1d0NHNDTXQxc0hvek1wVWluRk5LUHJ5dXMzaWhPQ2oxN2JiQkpK?=
 =?utf-8?B?TW82RjViWG12MnYzMi9qOVVvVklnVTJML01hdlZScitualVDSXJGTS91Nnl4?=
 =?utf-8?B?RnRBdWFMYmV3NjNKVitYQ3VXcCtvTkhPMHM3WUltV2UwYmhkbkFHVS96V3NT?=
 =?utf-8?B?MVQ0OUUxYWlQbnBHYlcybXR2cFRxZDRXWXlqUUlzeWpBVzN5OExzbmQ2Vzln?=
 =?utf-8?B?bzYvNE5XT1JRaThKNFZaalJIbGxpQ1BUT2JrY0ZteWZoQm4zTXJOc2hKeVl2?=
 =?utf-8?B?eHYrOTI2QlhCWmlxcndUZWFSdHY5QXJPeFVnQ1NmTFBGVGhtRUZNNmd4N0h3?=
 =?utf-8?B?Q0hnMHdqblRBdmEvZXg0TWRTaE9WTFovd3A4M2NlMURrOVVzdy9yR09CV1Nv?=
 =?utf-8?B?MnE5MVA4MGQyREVWbklkUEdqKzdCTElDMTJPYkxLbWFjazhkL0FSV3N0MmJm?=
 =?utf-8?B?MCtjbWlQMURpSkJ3RWxHNFM3eFRXc0ZTTzlkZ3Vpb1pPb2swYXB5cmg2SEJ3?=
 =?utf-8?B?Y3EybktTNlFOZ3lzaFd3cE5MZERDQy9jMmxId1haUk9nMGt0MHhtNUs2bSt0?=
 =?utf-8?B?R0VDMG9TMFNndmpjWnlSb0lUMVlERnNBWVdpNkE0RXdRTW5INitERnhWNld1?=
 =?utf-8?B?MTMrZHJZRmpZNm9lV2NmZXFzQ29IV015TmdVZ3FzUlVFaHhoNGoyQzhIaGhZ?=
 =?utf-8?B?TlBCTU5UOURvSEMybDg5bVYxdllza3BFNHoraG5STUV5R3FrcXJDU29uUUlv?=
 =?utf-8?B?ZFZ5M3ZYYWhwNkZjRUZiRjZ5TTRzem5GU21xbzNoeUw2eHp5Z3FnRjVDZE5Y?=
 =?utf-8?B?OFp0ajR0RFdYQWE2NEQvL2NTaGpacDJLd0lHRVBCQjd6L3c4Qkd4SGtKV3lx?=
 =?utf-8?B?emNtTVpmRTFRT2FYa2JVRDV3bk1RdktiVkJZU1NnaUtyVU1vZmxlbERxbGhT?=
 =?utf-8?Q?ZLeg0G9M74ae1TWU=3D?=
X-Exchange-RoutingPolicyChecked:
	MSaCLXC/X+YdSRmsj3mNMgeKPSIWj8b1VrcsieAA7Rfz+XoXSPboOlgnvVrmBlaKsB16TYlyBt7fnhT+m3fPaXiqmJ03EFA2Tp+sRyUKjSWGo/sL/76Rip8q+U5qOefDhSfwf+eO7CjZUHW5CCeyYiy9CB3GkRYhUnaDuJl4yUsxncGu8TzJvcYINkrMAZLSc586jZKrvF79MoniLHBqgfxY6r/hKkXVSxMd9kDlPmx3XFo4DgYjsI6pxuETThDviavkBj+tfAI5yeV1oCn6zCMcrjgyrnzApnJN/ldL6HQDrok03mceK2CN9/htZNpiEMcihJpNpaIyaHKd4vZ0IA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IvyWlccEYMAFdr6W3saXHmVBJJPaBIxKjEYqbql6ClsdU8K0uGHdJ/i3hXXITqXU6z9Q6KCQOlah4scyLb7xt9FJxUZHPvSYpfH4kobdexeTXWaCb2XMSZxVy6Kq2zV/mSBtl5wZXLTpSlqA+NXraWo8z4JHBwzCwmqGuKZGdPgJSzOnLBOYYGWQHyl1w6oWxX7GPNaUB0mBdET4YEEU0YOCkDE4zfGUsLh0VU3+TdEnxMl3oCOe609oSO4QiMAfytjb7xEvmd8HUQAu46/7FSujgiCOb/Ett35VjssTotksWidok/g/jhWHz+tMXqMXO3I8U04xqGkReJc2tV/zoTCbhEtpXYVQNty/iSVRh7AeKFjk+GO8UGuva4xK7pgFCt+HfeESlIO0qE4S1MDPn6cBeUeNRSx/Vl8USCBuXTnp1gxnKAmrjsG/YBaChjO0x6crC6P17upXQv/izUIRl8NAOTk6JSD27qZIl03B0oI0Xv5a8929PvgRbk3Ilpt/kR6ppYnxGEvrmND0KCsN/opTBPeO+bBju6Cqx5EobAISVsPwcEc2da3AUryuAXthsZbxeLweaJSih6y8dhtZGWS81sf1JsOBcyPskc6J0A4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d98f508-a4b4-4637-0097-08debe0ba279
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2026 05:23:51.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsJnjUD+sQn//vcMU90Ync5Jm6JnrfUsWvYu9xD4yTt2EEh+Wzfs3md5r9e+CJKCOBPVYzP5k6sdWjZSIre5o6/z0X9eodDg6zQ5yjHeC3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-30_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605300054
X-Authority-Analysis: v=2.4 cv=T/S8ifKQ c=1 sm=1 tr=0 ts=6a1a746d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=UOtj-npU4s0j0UP2hVwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: UIItn3W7Y5HmxjtmCn1ZaAfSUPrJDOsK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMwMDA1NSBTYWx0ZWRfX3cMOiI29BHWB
 F0RDG6VZ7kO5zonxN2gLxOiddWHUMxDg9Fbh3s+V6Xsa9QySRIm98dmVxqGKkDrtKbz3l34CG8a
 6ayd76Rtd828pUQWhmSjiVJvEiXH4eRN1xWrPq11jpKRUfAcXq2WHG7+xI8riJmbEZtK3FkirHD
 xLJjA7d7JxZaxO5KxygX9XPOaptEUmzi4HI5+WtT6tnSS6KQ1fw1lhP46YK9PEnG7aetv2Y9YCB
 Bc+bv6VzQ0pBvXuWDzFv7rJkIcRQq6j8yfARpRKvWG6dbMOAMq7IP/ErHO1Do0ifzv1ePts+kgF
 odG7bu1wK02bSdNbnNl2b0/J1g10LnNKNrVTZR186fagTjgC4IDKeGp+/ssDBfxFptkAxpA8MT9
 hABD5AxEWiyrxmsFX1QfXyvd/KghR+BhpkexkFMX3nV3bH+hZqYz/TfCj4PnxFOqDfola/YKG/f
 DP1nSFVlqsuqF3oCYTw==
X-Proofpoint-GUID: UIItn3W7Y5HmxjtmCn1ZaAfSUPrJDOsK

tcm_loop_target_reset is supposed to handle all the LUNs on a target
but it's only doing a TMR_LUN_RESET so only that one LUN is handled.
This will cause us to return early while IOs to other LUNs are still
hung in lower layers. This just removes the target reset handler for
the driver because LIO doesn't support target resets and for the
common case where this is run from the scsi-ml error hamdler we have
already tried an abort and lun reset so waiting again is most likely
useless.

Fixes: 1333eee56cdf ("scsi: target: tcm_loop: Drain commands in target_reset handler")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 64 ------------------------------
 1 file changed, 64 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 110297345751..d29830b951f7 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -270,69 +270,6 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-static bool tcm_loop_flush_work_iter(struct request *rq, void *data)
-{
-	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(rq);
-	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
-	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
-
-	flush_work(&se_cmd->work);
-	return true;
-}
-
-static int tcm_loop_target_reset(struct scsi_cmnd *sc)
-{
-	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_tpg *tl_tpg;
-	struct Scsi_Host *sh = sc->device->host;
-	int ret;
-
-	/*
-	 * Locate the tcm_loop_hba_t pointer
-	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sh);
-	if (!tl_hba) {
-		pr_err("Unable to perform device reset without active I_T Nexus\n");
-		return FAILED;
-	}
-	/*
-	 * Locate the tl_tpg pointer from TargetID in sc->device->id
-	 */
-	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	if (!tl_tpg)
-		return FAILED;
-
-	/*
-	 * Issue a LUN_RESET to drain all commands that the target core
-	 * knows about.  This handles commands not yet marked CMD_T_COMPLETE.
-	 */
-	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun, 0, TMR_LUN_RESET);
-	if (ret != TMR_FUNCTION_COMPLETE)
-		return FAILED;
-
-	/*
-	 * Flush any deferred target core completion work that may still be
-	 * queued.  Commands that already had CMD_T_COMPLETE set before the TMR
-	 * are skipped by the TMR drain, but their async completion work
-	 * (transport_lun_remove_cmd → percpu_ref_put, release_cmd → scsi_done)
-	 * may still be pending in target_completion_wq.
-	 *
-	 * The SCSI EH will reuse in-flight scsi_cmnd structures for recovery
-	 * commands (e.g. TUR) immediately after this handler returns SUCCESS —
-	 * if deferred work is still pending, the memset in queuecommand would
-	 * zero the se_cmd while the work accesses it, leaking the LUN
-	 * percpu_ref and hanging configfs unlink forever.
-	 *
-	 * Use blk_mq_tagset_busy_iter() to find all started requests and
-	 * flush_work() on each — the same pattern used by mpi3mr, scsi_debug,
-	 * and other SCSI drivers to drain outstanding commands during reset.
-	 */
-	blk_mq_tagset_busy_iter(&sh->tag_set, tcm_loop_flush_work_iter, NULL);
-
-	tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
-	return SUCCESS;
-}
-
 static const struct scsi_host_template tcm_loop_driver_template = {
 	.show_info		= tcm_loop_show_info,
 	.proc_name		= "tcm_loopback",
@@ -341,7 +278,6 @@ static const struct scsi_host_template tcm_loop_driver_template = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
-	.eh_target_reset_handler = tcm_loop_target_reset,
 	.this_id		= -1,
 	.sg_tablesize		= 256,
 	.max_sectors		= 0xFFFF,
-- 
2.47.1

