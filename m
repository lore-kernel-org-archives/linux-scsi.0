Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64A8EBB;
	Mon,  6 May 2024 20:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715028743; cv=fail; b=YOr2doY5Qsq2ywkQkoISuFM13l6udWElooBem85Px5VrpaHvI2Zva5U6aAprkm+oTgHVrRGTh1J4baYXs5hIa/eiNg3ZoD3YMbSdxCLz3J4SarHB3sQOK0HEcCRb34dicFVVJ416RPjwETPAFavZU7lzrevY5yRmuGrmkJCYFn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715028743; c=relaxed/simple;
	bh=C+Rh7mshvdx8dA7GONbhYgIkujhk+iM+XPYc1eenTjs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YszLmPk3MMRV8MRPUCtgXnxYNYTImX+I9ciFQdhX1WQHtDTgtPJAFkzHQ2QmuZ1W/xpenpgcEpW6HSY/otVH3WdjB7FW15ad+77AMrDtIfo+RvqfnaKhk3pq8H3dRVqmimpHvJorpNwHeaj/vhhI47zMCbKB1x5xPz8zW6QZS1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m5Y5G/TX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tOa6KQii; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m5Y5G/TX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tOa6KQii"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446IMvme031886;
	Mon, 6 May 2024 20:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=IgkKeLf86a+AfmQ4kD2MXpw+4XCY1FGMq4qH2tnlc8M=;
 b=m5Y5G/TXo+GXPL0ezaqFXVDNdhjXDmLK3oCL/gjD+U986EDo/m2jI//TNsS9N4dyEXKf
 Vu02qtlhmdNheZkBHOwGZwZfJ4gC334gXaoU8HYpjcrYvUU40jsSodPo1zRMV6Od3cn0
 NQjvfRwn8F2IKIk5qfegSZ7CLx+w4wpSUyxRQgzoNh/xGSqlfpZoV1FEAawNMnLE2fPH
 82jRbMzjTpeyhyA2T/WkVpLvhiwNWne7ZRmrwe9WLiCRq5TCkMDcPcqYZ/CJcfs0nyzW
 zIZ6bS4Lj0JVxE2O07eOF5CfZcGog32JkBhgQytU1zlZqfN5tCb9cLpemYi4yaZ3Nvhm UA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbt53jej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 20:52:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446K0BU3029247;
	Mon, 6 May 2024 20:52:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfccmw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 20:52:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vja7DmS99QT57fTH9u0mqKnALFSka80F3U6ZjuMKPUKhMt0tbPjP48b4aA8sq878vsR4FMPasYcoWt3/HfqVpnm6erJmk/7LEwPjInGZpv1cpjjwZCOryTjC9ZCMJXnd6bx2woUiESKYoCtiXr1+2+u8Oi+7N0HuVjKz265nBHljio7NCvCjDdJwlyC47lMMTltpSgqmziAeAO2B9tafSOC2k+xAuyg9ylKIRrVpNeN+2CqrvE3RGS5rgeS+XSDMN8J1GV0SH9B0Z7uJw+NediU5Wt2mwhUr0ooP7HbILMs1nFcU+SzNiWPPTafbt5m5e70w1dSffUsW0nkwSURKSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgkKeLf86a+AfmQ4kD2MXpw+4XCY1FGMq4qH2tnlc8M=;
 b=j5aMlni5vXSgOtRJyRS1WLY7jnlP8ZIkN7nHsWJVzf57fUT2d1eEICtfpHKx+0Leu1sgkbRlBLW/N4jC5Yw6YPIHDx8tBO/Edj2/fPtUTof6UKkt3Y2u6Pehf7QS9AgzweXbWtw8/+JAk9vhfK/f4ffxEjKjVM8yGa2IodfsdNLo6Kpq+XuzpoTb9a2DzLKJzF8YVGVwwkG7GdzA+UzqDA7TU28LHMnjMQplVndFRDsLTRokHOKfeGtTEmt0bUPfXrcpDGgqE5hU8ei1PSdq9bpHsWEs064dvdGEOt0A9eCbwjzxMTMr3K4gUIFeTzFg03aboC771wr6mBR/VzRSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgkKeLf86a+AfmQ4kD2MXpw+4XCY1FGMq4qH2tnlc8M=;
 b=tOa6KQiisHl9qxOz3IDMMdmCMQFd/v52Mc270bmJ9luDopmd8iXP41oyK5qwBdXXrJ+/RcVV3w0nHBE0kx4j+gJoaPKrlgAXghwfMvd/BVaf1EgdRNDA3LKfg9D6opiwRRSM9cUep5os55KgXD35fC85cdDMvtVYYdxWU7s5Tyk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7128.namprd10.prod.outlook.com (2603:10b6:8:dd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.41; Mon, 6 May 2024 20:52:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 20:52:14 +0000
Message-ID: <e1b142bc-50e4-4117-945a-7d74dad763d8@oracle.com>
Date: Mon, 6 May 2024 15:52:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi:iscsi: Remove unused list 'connlist_err'
To: linux@treblig.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
References: <20240503232309.152320-1-linux@treblig.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240503232309.152320-1-linux@treblig.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:610:59::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7128:EE_
X-MS-Office365-Filtering-Correlation-Id: cde35632-a8fa-404a-c7b7-08dc6e0e684e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?c1VKSDd3bGpLU3FPY0N2OVB5aDBLcFJYQThtcXBqN3RpQld5SlluVXg5YUk5?=
 =?utf-8?B?UnhUTmdMekoveStNK05DcUYxNDFlRjJPdnFONTBUWFJDeURaRjA3U2JVL1FI?=
 =?utf-8?B?bDM1aTJVNWZtUCtFR0NYazRFWkdlRDJwR1lVcy8vcTIrTzRmdmk4elo1QTJV?=
 =?utf-8?B?SDRVckFrUER3R3hKN1lNQ0dzM0RLUEtueDhuY21ncFZWSHlhRnJSVUVGZVd5?=
 =?utf-8?B?Y29GS0JCWGJ4QXEvWFYvdWRGdUk0WGE3UkM3SVZBWDRnemxablQrVSt2Nmk5?=
 =?utf-8?B?azkzMTNubDhXNys5bjIwbXE3a2xpa3E2czFuK3IydlFBVnFFRjRPYld5Slgw?=
 =?utf-8?B?OHhxY3U2ZTJPNVVucktIYTM5bEJtaFhaZk5CelM0YlV6RElFUUgrZHg0SWdM?=
 =?utf-8?B?bmhhZ1Rhemt5aGFGSzcrVm5XMUt3WitpK3pMT0NIZi9oVFZTM1VMT3pUVjBH?=
 =?utf-8?B?TVNmc1NaTU04cFp2RE9DNzlGU1picXlGU1RGbEM3ai9BcHNtZyt6N21nV3lG?=
 =?utf-8?B?NXdUOFBtMmJCaXkxandJcStsQm1BU2tiQXNPMk9QQk55R1ZkN1JJbjNGQk45?=
 =?utf-8?B?WmlLRDdxa0drbVFJc0hEZTE2WUk4ZlVCdExzUDZMdXd3dWFKUytSdlJJNDdl?=
 =?utf-8?B?ZFZNTER1bjlveW42T3dhQkIzblZqeTRCTkhxazJXcjBTL0RJZjcwQXV3Q1o4?=
 =?utf-8?B?djRsK3BTaDdQLytqY2pOL1hrUE0zUm5DWVNKQjhRZU9nckoyZFZtK1llZ0c3?=
 =?utf-8?B?QW1iYklyRHYzVUQwNytYSkpNYWNrMUhJTU9zUDhjU09kN2pYZkgvTXVsQTM1?=
 =?utf-8?B?MTN3MXBQVzhadHFQbmhYR0VYSXBwRWdNOE1jaXB3NEE4SnJ2akg3YTlLWkZS?=
 =?utf-8?B?cERDeFhWTnB2UWtXRkxBSTMvdEw4dWNqYXdRUHEvOExtWnZjbFhJaklHUzMx?=
 =?utf-8?B?T1NGS3ZaQ0xwSGhhWWk0dkZadkE2SEpPY1ltWE9sWjg2bGZsMFFmZFdGUnBj?=
 =?utf-8?B?Q013RG5PSXFTWWZsWjF6aXRiZDVYWVRHWDlBT1VSYTJ0ajQvaHpZWFkxTG5F?=
 =?utf-8?B?MkJjTG8vYXpLeXhyaS81SU5yUExsdlJOYW96ckFubGpKNWdKOEczYjBNRTJC?=
 =?utf-8?B?ZElGQVBUMTZFRmJjd3hRMVppWlQ3Nit5OFp5NGR4VmM1MVNUVXJQaHh0MllI?=
 =?utf-8?B?dUdjazhlVkd5Ym5TclhVZytxZUF4MWFVa1lxUHRUbWZzd0hsLzFmR0hpNW1U?=
 =?utf-8?B?U2JlUmJQbmlEK1pqeWtkQm1IaU1LbXQxanJQU0FqMDFkTzMyMkpDNlFpSzRo?=
 =?utf-8?B?MUdTeVBFWndBRDlPZDZ4bGRERVpTU1RhQ1VTQUpiMlZEdG0zd3NwZHJEYmpD?=
 =?utf-8?B?dmZYbEtEWnp2anlqOWFWQmtCSTMxZDhsZ1lmT0dUZytvS2VyR1M1NGJGMk1j?=
 =?utf-8?B?WENKUW9WUzZhWSs2cUgvRVRVWjZ3MFFzUDlqelZ2TE5OWDNqWlJ0aWJBdTFs?=
 =?utf-8?B?clBZVzQvRXVNazBJSXM5Sk10L2xGUXVHQU5lSHJreEkvZHk1Y3RKcldvcE9H?=
 =?utf-8?B?dklxSGZzdUJTcXJyNmRZYkxGaGlLdENJNjFxdWdnVjRsUXhwTTU4Q3JxRHNU?=
 =?utf-8?B?VXdRYXpXOEk4SHIxVThIRzJxcTRLbFp5d3k4aVR6YlRRbEQ5MFo0R0FHVCtj?=
 =?utf-8?B?MWIxbjdDM1c5bllvc2hwOXU0RjRvZTZQdk92ZjkzVTE5M20vYVA1S09nPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L0ZRS0k2QmlrYXl3Q1FIQnduamVmc2hDNG5mY01wdk5RTXNhcGpiWDY0d3Bs?=
 =?utf-8?B?b2xxdHVpR216aXNzTnhJNU03MWY1STlZL05pbmg2V3Y1R0tnQk1wOTNpTkZ1?=
 =?utf-8?B?VldHYXR5YzkxQmgvVGkxQmhZbDkxbTZIK2pjb3BXSFVOeWxCZGtBVEgzbTJS?=
 =?utf-8?B?Uk04RFhFUjBnMEZocjdkeEVJM3NmN0xYaXRTREIxZ1ptdEx4S25kbGVUbmoz?=
 =?utf-8?B?NkErcXJrM01FdmRTVU0rdlpnL2g2R25CL2ZNd3BybXBDMEVCcHZVNnJLejBJ?=
 =?utf-8?B?TmdoVUs5YTNNL1phaXhVQktKRFJPaWp1NWN2eDdQZ3FmUUMxbnBvZHpyL1hi?=
 =?utf-8?B?bXl3WFdCcG54RjhTT3Ivc0loYnpPTGUzSHh3NHlWMXV6ZXhIU2Jpb2JpY3Uw?=
 =?utf-8?B?VERzNVZ6RTFJRXFCOXgrTEpReHc4VnY2YUl5K3JNOENRTGI4VUFPYTF4Zisv?=
 =?utf-8?B?ZHZscmF6anZiQlI1YStiUUx3aW9BQnRSS3pkOWVRZXppMW56K3Fody9wbDYv?=
 =?utf-8?B?MFN0ekZCV3RIYms0bXlybE9WYXVWVGJrQVQwMlVuQVVZTE9MMUJBMW1lTW42?=
 =?utf-8?B?dkpvMm5Dc0ZvV3pxQkF3RlpyQ0NvdzdTalJseGlFYzFsclluV0dsK05pdnRN?=
 =?utf-8?B?RkYvVGgyK0VqNkN2dGNOY2wvbXgvdnB4NUR4aUVBUm9YL3B2UTV1OEppSzZN?=
 =?utf-8?B?ZU5JdzM3QlQ3QXdnaXhYeVZLZnRnYTFVeE1oWTNMeElGM2RyNElqNzQ2MGJq?=
 =?utf-8?B?ZmJxNCt1V2VMUW5jWDJJK0xCYlN1NzhES3lxc0U5d29sOGdkRitJZjlBVDBy?=
 =?utf-8?B?Qm9iSXhZamtYOU9zcHQ3bjBkekNzRHF1S2E1OTNCYmJCYkVaRmF3S2NKSVpI?=
 =?utf-8?B?dnpyWFc4OTF3dDZKMmkxdENkenl3RHlleTIwUXJaZGNxWk8vU3Y5cmVoMHl4?=
 =?utf-8?B?SXdqbkhLS2ZrNzlZMkpieE5wWVhKRUFvcU9ZZi8zekV0cGg0QWwxNDhncVRI?=
 =?utf-8?B?c0I2MW9RS1BteHJudXZTSXlPOWpFalp4VmVoazVLbTJ3ak5yZ1FkNGptamtV?=
 =?utf-8?B?U2lkWmRWbTZGak1MVE1kZmluS0NuVmxOTUVkT2szY0kva3N3QlRNYy9pWUtt?=
 =?utf-8?B?RVlKSlh0TlpZaTJFbnFTSjRodFZSVElpZk9VYlRjL1lKZGhMV2o1RTRhc3JH?=
 =?utf-8?B?VDdCMVMvTnJwQVAycXJWWSs0Q1I0ZFBTenZwZzczTFZmSUV0dy85aWpTMTBD?=
 =?utf-8?B?S09hY3VBTTFHTzhQeS9XaGxzZ2lTK0JyR29GN1NBVUxyb2RubWY5SlRUanZt?=
 =?utf-8?B?bmNmY3JuRmMvYlJoRjdaRnpDQWJCM3R4YVFqcmRoMC9ZOUgxaDFSRlV1MGp4?=
 =?utf-8?B?ZVdSSk1UZmJWN042WWV0a1RleXpmU0J1Ymd2QXRWaDE2bU9BM2J6bnZ4MkdF?=
 =?utf-8?B?WWFNR0JpaDZ2YlVrNERhNWc2UnpuN0JaSEdXeUMrRTBNa1djcHUvLzV0QThm?=
 =?utf-8?B?SXVDMmVya29wd0RmMnZ1MUhGN3VQaEFmOTJsSnZ4WExiM2s4K284MGpNbFdv?=
 =?utf-8?B?SjdBOGRhSVZ2MlpKTDl6STFFOWNnNDh0UEdWWDdXcHgrMjlTbGFtSlZ6U1hw?=
 =?utf-8?B?WmtMWjZxOEJlV09NajBpQy9LKzBjdGdPYVRxQ3JlY00yV3V3Y3R6amxDWmZn?=
 =?utf-8?B?UUkzRCtqcjVzTFJKNVo0djBWMnVac3NHQThlbGF3K0o1bGtubzRDWE4xbUlj?=
 =?utf-8?B?K2l0VmdiaEZnemR5Nmd1eHg1aHd5V1RtUldQYm4xUDJQYXQ4Q1NPK2J6OWdP?=
 =?utf-8?B?S2MrZTE3MitJd01NbzdyTWlmeGdKcjdlakt4eHZkN2lPUEU2N3gxVWxJQW1Z?=
 =?utf-8?B?SkV6bkcySDlWaThZTk5tbHVjTCtsU1NkdXRzN3hNS0Via09TOWVYb2pmcHFY?=
 =?utf-8?B?a2JpQWhQZWtHdm1ocVA3dG5vdmxjRE5PYlFGcVgrTUdaSXhVeVhER2kwODlz?=
 =?utf-8?B?TTN6QXJ0TjZwbHVRL1BuZnozeDVzSU4zc3BlZmxQeDFYVFZMSWNCbXBkaFgw?=
 =?utf-8?B?K0VwQTcwNGlvajZKMzA0YTRoRUZDV1R1S1BMTnNncUx2NFJJbHlXZVkrVDkw?=
 =?utf-8?B?U0RVNVg2Nk5nMmRWdEhmL2Y5NExmYjhEcTJFRVdHaUFnWVF2cVpJclAyaVZH?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TWjIKUWyoX5km9E5QWKa5ENJyoeMtg4a3RQCHQI7ORzni6J6T2Z49AnoOf0ZMHVLEpTBZFbP88Z8dreRlCm08Dp/pmEX3UPZrQ1IQvr5tQHFutnAemWV1v/CVL9F9PmwrcbyWPbuOIPhQ2Ngf8FBlf4D32iAFExlxOPodmzR0mgCUWg0O0SgpfaRCiSXgRILMeDMEO1TYgwIfD2mO/JVZLoOZk9mLdASxJzHyjNVHKudqmpJSGQvjXCtX/qkjrQWl52/UR5j/6/p3aSUDePzk+6bjN8F8Mh7d/ra7Rz4kbbx81kN4cVfmFFZPNEX02ZNngDyDjYTW+MFC/FeqjrSJ1GEs8OAi3HKzh6gXrWp0kV97YvBXD7Dr/z7T2n1Fe/zTARG6KsDPqwkhcyR+CVrEPDN8b12xQ1nIuZnVrqv4vNFPK67gUCfyVQcv/GTwQEjJm/X8DxyNWIlVawoS8Si6Ua6xCELxjfk10GfFZ4+4u0HJNPjj+Xj/wwsvXiP7pRs3LEapx0RN95DXLz7Lwi0oK7h489bg0A3lqFk7EWSoMulvrf8XMgSofi/vZtzKj77Ya1tZZGRcdC/OEbM413MNj4PzwUzJSYQa7bGODi6FE8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde35632-a8fa-404a-c7b7-08dc6e0e684e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 20:52:13.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNVdNNDPm1XNACqhQFOGMs1wkuh7fvwiLCaDYTnMzqtgmzSs7msbvx1CEIxOTnpm1GzVUwLYI+WXFHS9dKf80Owu6EUg/i6NdhWqPMcw+GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_15,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060151
X-Proofpoint-GUID: KLAy3FmqToG25Q-CddewcH3x_cHZahxy
X-Proofpoint-ORIG-GUID: KLAy3FmqToG25Q-CddewcH3x_cHZahxy

On 5/3/24 6:23 PM, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> I think the last use of this list was removed by
>   commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure
> handling").
> 
> Build tested only.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index af3ac6346796b..123b861d2a9fb 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1603,7 +1603,6 @@ static DEFINE_MUTEX(rx_queue_mutex);
>  static LIST_HEAD(sesslist);
>  static DEFINE_SPINLOCK(sesslock);
>  static LIST_HEAD(connlist);
> -static LIST_HEAD(connlist_err);
>  static DEFINE_SPINLOCK(connlock);
>  
>  static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)

Reviewed-by: Mike Christie <michael.christie@oracle.com>
