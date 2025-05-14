Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5316619924E;
	Wed, 14 May 2025 08:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209843; cv=fail; b=FQM78/F1iskqEbRA050trX/qHZgASUW/WoKwWq3smNR742Cu5glJ/pjh/MPeVmI6MQ5LIKYM8RXyZvN0a6zMqIV9h8YfxFo+BrobJ52qb7RU939YoGscxK9wDQm4hYPCDHZzfjTGreG2T80TM3ipGkjwuplzcBcN/2wyoC5ovEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209843; c=relaxed/simple;
	bh=MTudBpfBt/ESoMkM2+QMzAvkztIqVXKr3LLSed8c06c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cfkdAOHO17s0ThHVUj5QaxdgeqgKbFDAlJLurWKAfQnTRyw3wSXFAXFsTQxYOiT73cXmfd/uNerfAY4mm6QMURc/peyxFLdYZXAqYWOoHyO7G9JhDgKgZaM4trdeRT+wjZftVVmXPcmdzb6bizADwAsY3eeADj/+ISjEwR6aKnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sjmSIwx1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BDm5afIR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sjmSIwx1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BDm5afIR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0frva020262;
	Wed, 14 May 2025 08:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6aAkWckR3z7x0a2MM30QkPlOMdEyojSw2cDwVvfJJ48=; b=
	sjmSIwx1LmybETa1bYanbUzIy1P83Dn8d8q0fKdJxAXTQwgATn/2uH5fYFlE3Ls7
	oUTfWJCIoGmV45UlqO6jRmtF9tZwfSws9e8miEjvlEwpXytKd70ytbVoJTCoMI8n
	gDbTtyMBj2cDBqCznXEMRzp9+7bIUHZy451GD411vO3tliSYsSLc/20HD2hfCOdG
	CO24Evax//3YUFXzeKgcGSzYQ2nrNlQpLA7Xz4uXf3CBB5Lpvo5BCgF1SlRmVkud
	KzOfmbrYHaQ4WZ8pbII0n9Kf9WrhdSbeIcRiUTtddJlaIan/zMUg1udZ8+qhImFt
	8jiJgseLvtdUWdr6LGe3mw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcds0qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 08:03:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E82vON009043;
	Wed, 14 May 2025 08:03:55 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011029.outbound.protection.outlook.com [40.93.14.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mc6wbkd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 08:03:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYIlilGaMjzuJvW5PcZbncM568JKaIh8uhbIVbagsO4Czixpvq9IgFWeIToJHiKDdP5TxWd5C7NrnR6e2cw1VQbU0um/WXPSU2g2qRF6HLcOOPwyljOv40jKUQhBFaQJs94xqH/o3/hEJv0zeGBLugg0B/WMMCXV488eMMe/nqZsisL8Sgd2h6ciXam1DXxwUzPptwB1SXa57O/r2qQC3hTxozTXav+2TLv/hOKR8j/XKykl8AfpCGgJ3Unr0iqkP9ijFTaa0iXZFL7ypu+p1pZiq1znQ7K7bfpSePwg/zcReWgn6BxVi4/qCib4vjottWcD4FXxAsfDoQXA2ee+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aAkWckR3z7x0a2MM30QkPlOMdEyojSw2cDwVvfJJ48=;
 b=ySrFSb/rXtSgrN3obJaKUz2oSgwYgkZApV1OUFcLH9B5GNozzHxapRfrQ1//osUG6d9ltq+qy66Ttqk3WjotxddMPONyVZrvCLo+U3i+dErZYQyZfu5rKRvQeeeHnEtfVo8vMsb1FyYvhPvSFXmMl+Hcez8huz+7xXcJ3WyQaFsNmwuR6Zuvl4qvPjqq/Axv7dtrFv0gAM5aYvh1jJB18RLrQP9qVRsJI+croE67BU7vTum1DN+lzbp0YX/Rd4IForwXLb+Dz5g/uZjM+aVypVJ9U3dfwMzBc0l4zmbBCyZBwuitLeVWWfLcdAVu2avtqyqwiw1alwCuT7VLFfVzXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aAkWckR3z7x0a2MM30QkPlOMdEyojSw2cDwVvfJJ48=;
 b=BDm5afIR/Nka3p3WkUlsMEtfQ29SK7xLiUub9tZTzCT9lm0Lh9jDF1vU/1iUsfWOMPF647YY/X9kRBsVukWy9PMr+R9MH1+/Xicv4MF0cr58+GNxyRwK6jISsjpZOBbYmKl7olG6xYkHx98u20crT7rYrdhU8S1bMIucV3LQ1cA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Wed, 14 May
 2025 08:03:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 08:03:52 +0000
Message-ID: <8cb17376-8be4-4351-9b17-ac05959f379e@oracle.com>
Date: Wed, 14 May 2025 09:03:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: Remove unnecessary NULL check before
 unregister_sysctl_table()
To: Chen Ni <nichen@iscas.ac.cn>, dgilbert@interlog.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250514032845.2317700-1-nichen@iscas.ac.cn>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514032845.2317700-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0038.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e3b32c0-0ec8-4f73-cd5c-08dd92bdddcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0VQWnI5aFhYQ0hLZVkvUU52SFdhRUk3T1NodzdzMHVoUVdSb0JacURaR1Bx?=
 =?utf-8?B?R0ZqcE5xM3h5cThubHpHTXRrRUlEOWM4N05NdjNpelB4ZktKQ0pQcTMyZngv?=
 =?utf-8?B?aVNwMU1LblBpMG56Y3hseXY0QjRRN05pNTc0UGRKbEV3emVVN1VEUFdORGVO?=
 =?utf-8?B?cmRlYWUramtQWjFIN2xyRHVmc1lSVTZha013amlSaThpMTduaHNtMDIzK0lo?=
 =?utf-8?B?aUFTY3FMOWx2YlVkMGpDajBla2I3cFNyd3ZIc1JpcTgzcUo0QlRwc0lCcDZs?=
 =?utf-8?B?MjNuWHRwa2hwZ04wNzVGY3JHUFFYdG1NcWlnb1lpQVFtVkhPdUNQdzE4a1FH?=
 =?utf-8?B?T09idXFzOHZ3SzdJRzdFYmxPWUpFT0MwbDRubmVmaG44bFFFZE1zQkdBMVNT?=
 =?utf-8?B?NCszVjZ6czFvUGNNNXlaWXVXUEFmZFFraU1OUzJsemZVUHpQemxjYWpPaUFU?=
 =?utf-8?B?Ym9mVkUxWVVRNkh1aVk5cFIwZjFWLzVSK3k3M2ZrdlBJNGtrc2FoRkRENzYw?=
 =?utf-8?B?djVuOFdoVXdpSmxveHkzUUl6WDFsWGViWkdKcjRBNjdLT3M0enB6dTFFQTJT?=
 =?utf-8?B?MGdHRkNMQU50bmh1RDU5Z3A5NnNIbDZYM200OGtZY0ZUdTlqdTBCQU9nMFFr?=
 =?utf-8?B?ZStxR3dUSUo1NVUyZVd5cndyR2xBaXFFOUtiVmlDa01YL1F1WEM5eXpSZ3JQ?=
 =?utf-8?B?cXZOU1FTMWtqSUZzQWRSS3JPZUVwa2RtdWNXR21PWUdiZ1UyK2dBQ0Nqd1Fn?=
 =?utf-8?B?VWI0djgwU2lFVjVFOTc2YTJtUXk4QWl2WHBSdG1EWG1ERElkNjlXcUtJL3oz?=
 =?utf-8?B?dUVCcTVNTHFtTjFVMVpwNGwyb0tXZ1FOQUlCNlVSYURmZHVJREt6NUpFcTdL?=
 =?utf-8?B?V3JtOW1SM2Eza0NGT2o3VHlQTUE5TXdEUkt5am1vTjR6cForSC9TK1hBNEQz?=
 =?utf-8?B?dVhKNG13KzJZK2l3cjBxaklja2RPR3RDUEpubS82WVRVTm54UjlYZTJuL05H?=
 =?utf-8?B?bWlxYk14TlZhSlkxTHV2WW9KVXNHWk4vRmc2bGJldUYxbE1JVndvSVFWcGtx?=
 =?utf-8?B?bWM2SVlzUDNyWTRCUXRsSnRiL0pDclU4dndtaDN4Q1VSMGFUQ0xhZU1GUEp5?=
 =?utf-8?B?TXpSemp6N2h0WStYTUhLN2FDUWt4bXVBS3kwdFBvRHdSRm5GTWRFaFJwMmtC?=
 =?utf-8?B?OFB0bUtGdFZ6cHJqWk50czZrWE9QVDVPTkVrZ0RLek0zN0d5Wkk5MFk3WDk3?=
 =?utf-8?B?UXBTWTlkYmlFR0daTlNDMjM0SkIwQXoxYzl0RS9pblhFNHd2ZTdmUVZ2TlNR?=
 =?utf-8?B?cTcwVzJFT3BUTXFKOFNvem1SYXcyR1VmRWxaQXZRcU1VaTk2NU9EYVpiTFor?=
 =?utf-8?B?VGg3alVDVVczRWd4OHJaOFJXWVJRZmx3cElmYk9RQ04xaVhISGZPNVprcW1k?=
 =?utf-8?B?OVo0cnovaDR3QjNzZ1lzZHd1WHowN0ltbjhKYzNoYzN0V1RMVmdlR2IwMk8v?=
 =?utf-8?B?WUVoMmtXSWZsOG5PanRaUDBSMmVoMk80RWM0K2JyVkltY2tEcHRmaEZQcEhT?=
 =?utf-8?B?NmdMTzdFTFFudWtjRFBWK3ZlQzJ2SWllNlBIWUR4N3l0YXVpU3hkaWlpOTcv?=
 =?utf-8?B?VGxwS2lWZ0VMUHB4YXYwbzFGOU9pUmFEdDlCeWlOMSt5VkJPNy9sVnYwWDRu?=
 =?utf-8?B?QUlKQUw4U1Izb2NuOHl2RkRWMkVQMGE4S09oZnJ0WXQxeFNzLy9lZUZpUWIz?=
 =?utf-8?B?eG03V2ZaTjNqaTJJMUZCVlh5U3BZR0NheFBmMDVLM2R5ckdoa3U5K2N3YXhF?=
 =?utf-8?B?Q01WTS9XQXBVYUV0NTQ3WjNJUmlwRTFnYmJHYkJyMHNCSVMvQ1A0QklWa1Bs?=
 =?utf-8?B?SGUyZTQ2dGYyRFFRQVRCNXBKaGczdTBVbWlJR1Y4SFZ5aTgvYk95TUh5Q3pX?=
 =?utf-8?Q?6Mh0PWeEc34=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2xYbkZqYUlzeURjbUlUYm1Kajk4b0dWdHBDNk9jR21jN1gwMGtaZXMyeUxY?=
 =?utf-8?B?Z2g3eUNZeTBLNGFxTU5DbGZ0c1VBYVowd3lsL2tHaE0vVjQ2TnhWb1hBSTdv?=
 =?utf-8?B?QTJXRnhHcDQ2eHBFWGVGS2tIelVjQ0VIbm5sYW9DOWc4MnByRjYxTDloZ3dC?=
 =?utf-8?B?dkpzMG5MaHd3VW5UWTNveHJVbDBwakpWelpBcXlJTXJhMHpBWDNHMC9lQlFC?=
 =?utf-8?B?aEhzRjZpY3M3SWZWdW9saFNVWUh6NGhQeEFtNkdmdDVCd2NYYmRhcFFzeVVM?=
 =?utf-8?B?eEN0UE9OT1lNNWp0VjVDUHRZZmFOWnF4eXJPeklFMGp0Y3pJTHNmcWc4aGcv?=
 =?utf-8?B?MlVyeHl5WEhTZjdxL2ljY2RlVUpVa0tOci9jNXFMemZNK0tXYTg4cFozUTY1?=
 =?utf-8?B?eUp6VmFvcWxGQ095TE9Hc1VQL2UwWEFEZFFIbnhIQ3hiY2RWTFJIZCtPeGww?=
 =?utf-8?B?OFFiZDZzMkVQWFJzQU5YY0ppL0F0bFcwUU84a3Z0ZllBTTBkaGtRWVNBRTcy?=
 =?utf-8?B?NVhxb2hnUmV4STZwODhuS1NhR3lMYnpwMjByaFh2TmhLWndzUE5ic0FQYlpM?=
 =?utf-8?B?clFKd0x6VWZiVHUyL2xINHROVnJHWXVMbFRENEl4VEUwcFgyWXl2dVFKQngx?=
 =?utf-8?B?akJJeVdoSC9BaEJNTFh4VXhvQlVTZlNDcW8vTGp2cE5nMWxkdVNNdEFFbGwy?=
 =?utf-8?B?RmQ4QkMzeFF6VU50dzZaUzR0VURLOUxuV3dKL1pCcnJKUEhLUkFvQVV2U2RC?=
 =?utf-8?B?YjFGM1Zxb1FvWk4wcGIzcHd5TzdJT3VDYXhDTWRoUUZIOUl6OFdmUEYwNUtr?=
 =?utf-8?B?S2dXK0tTQ0d5R1pmQzI3SzlCZU9QTVJNSmlhaWlFS1pWejVWbkt1QlJlbE01?=
 =?utf-8?B?VzhzY1ZQMzZEZGtuSjdkRlhlNHlLYVIwY2hHOTJiZm95UWhzOEhjTk5FWGdy?=
 =?utf-8?B?VlhJR0Vwa2xKSFZWMmROUVk0dEo3ZkIvcHRZOEZDMndyOWNrd2xwbTlSTGcv?=
 =?utf-8?B?QUFCc2tBT3UwMXg3UGpmRXFWckhoR1ZDeDJHWmN5TkpyNzZuamRZTFU2czRF?=
 =?utf-8?B?VitTTlQ5L3RhK1dJbS9ENHE3ZDU4SXg2anlOb054Ykw1b0ZVZDE3OXBIYWQ2?=
 =?utf-8?B?WVFaNU1OSEpNVHRpT1dvSy9IVmY1Q2FjZDh2NGhUSWJmajNzTDdMekU1SW9n?=
 =?utf-8?B?eTJHaEw1amZEbGNOckFoVDkyWlloakl6eXBPNUJ0ekEwWml5QlQ4OHZHOUR1?=
 =?utf-8?B?K2xHbVBkclZQY3U4OTJuWllWc21pbWI1K01OYnRLWU5Yd0dpVHRseWVkbmFR?=
 =?utf-8?B?eFBLRDhNRXZmSUxsSDQzMXpwY3A2Qm1vWjVGdi9vWnJLdUhHem13ZmJ0MFJQ?=
 =?utf-8?B?bVFaMVZOTW85Q2lJZVIzOHAyWWIyeCtDSytVS2NnOWsySFpCNTJvL0U2Mkgy?=
 =?utf-8?B?WDRBV3ZBOXg5SWFRWDM3TVBuS0o1YTlwcWNtOHdibTZoUUd6NzliRUtRaDFV?=
 =?utf-8?B?N2FPcXNyZlQrTTF4WWNzSDQxd2ZiMkRYaXBibEh1VFRncitPSXo3UXhTU2VV?=
 =?utf-8?B?L0l1RHh2N1NWaUQzb1hKcmJRdXhDUzcvekRuNEZtc3JZYTZPMlRJaFhUeTI3?=
 =?utf-8?B?aTBrZlFFcmlBZndhSTJ2cEhVZnUyVkdyY2hGTkxXZEpLL3RDN2EwajNWTmsx?=
 =?utf-8?B?a05jaXlDbDhWeWIrVkZCWGNRQmhrUndNT0RzaXl3TkMzZHNqL3VRakV3WTNs?=
 =?utf-8?B?LzA2R2RzUHNqNWNnbU1xOCt5VDZmeVAySDVJRDdPV2JFVHNBbjZNa2c0VEdh?=
 =?utf-8?B?L05mcFhCb05QWmRWK3FDMFA4bGJEVHhkeWZEaG1naGZIa0g4bDhmR2gvWXhw?=
 =?utf-8?B?eDBLamMwcXMycVdHM3o4MXo5NUtPc3Z1ZkRQY1A5Qm82U0ZRLzlxeE9wSzVo?=
 =?utf-8?B?Slo2S3dycTIrcFh1Q0wvYkZUckEveXFDaS9Ga0RXTGcxd01IVFFUZFgzNjNZ?=
 =?utf-8?B?SmVZaFJhQTh0dmZmOHhyYnBES21sSzViem1aRWJVd3ByenlmbEpJajFkNDZz?=
 =?utf-8?B?Wm0rOGJOUDRvazRZYjB3RVJGSWpQbkZ2Zmp5Tnk5aS8vaUdzS3dvUFNxZW0r?=
 =?utf-8?Q?oXslBi33i8JDNYmeype9oXRZo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zK0pHoXbtH8Nh4On4AX7A0UV0QvRq/pJiiji3S2HCZUx2I5Ah+tinkDJz5VxX+6XxPkf57mZajyTNEELFUgw9BjstS2KrGTGQtuy8aUyIppFksdj8Wv27kUGU4jUuDsque4b7ZM+mnASHRV6J42COYBMMyQYaW0rdZLFOGPK6FdXe2fyQeosQVXUTdQQxgCrKNL60A1k3399Cd0gy+xqHjCRdQb8ASdFfWGNkMODYvZluskmeP+FDvpG1dulxaO7a8Q+dlClwBwTApjyRMZBbCkUxuIJxO18/GiIhJTpTOx7otmFiVVMMJg2xKVJFQnAb3/B5QjwU+VC/zYZQQztVuGU8KIN3BV6Vg0582XS4bCWV8f1sDlYS3TLaB89SNE0U8fnAVYyhogvDYtP8IjmOLrCLb5DlS5C+y2AXCKWzE6S5ykkPR+9cajVSsYpv8rnTO32bWniMboAjJi/+AnoD8fq/qUDEiLPsOUXJLixEqTgKTIokACVS2leg8n8jLytewE2gFxKrqc7kVklIAg9XcVQWA47glbyJnqR4DuZYiHcBkTCf0mmT+2L3NitXDWGfrdz+/FIL1CZy5yjAdtI+1knCef0P/JDv210JRLFKZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3b32c0-0ec8-4f73-cd5c-08dd92bdddcf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 08:03:52.7021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mKgxXHa21Lx0bBXI4Df8MH22lKABqdBDk0EgVwYqwHehl8pLSMFz5B7/Xmo6BcSw21OgOQf715u3OeMxetmvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_02,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA2OSBTYWx0ZWRfX+fSGc9HEmLFF qnW9Dl2697jQL1Iu/zMRUtiHJ0oJwXzBW9e8ydDc5u3GFe+8lWgXRDuvTTy+u2Ajwk+DFvZhzz7 ITdrtGBlb233pZqqlyHtfxHZECv5S/v+VtL/8HwdEOA3FOeBv12nKymrSl7w7R+mOdodNsK9rbk
 62P9ZKQcAtYoMhjIoJZbzcb/Mr/trDtXxvVBnnoS5IzbWUiICK+Ao3pGPBd+U62ngel17GS69ww //+uCbdVxSP6PjYrvSEACfVTGmB2ZsLfeIwj5hZUKbjqVxy9qrbKzuzdEL7WOT+wN7dOQMPf+tH O4jPqQPqwk/9YZJij/zjlbhw/OAWZkbrDnh5Z1CLb7hEFr84YZZ+CSowne9sL6em50UTWNdnlmn
 X6SMJcc5yYxzAMZPoRbojcMy830iDM1w7Drv5t6dGtwk2zilsDOFVZL8EmXSN53PnZsafPZa
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=68244e6c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UoBXO3_-y8Jir2PnDl8A:9 a=QEXdDO2ut3YA:10 a=6pWzAbgKvXYA:10 a=pFvAdi_5yfWfl9Xqn-nn:22
X-Proofpoint-GUID: x65lwnpoYXMQYPcViKtybF1ObBTdPViK
X-Proofpoint-ORIG-GUID: x65lwnpoYXMQYPcViKtybF1ObBTdPViK

On 14/05/2025 04:28, Chen Ni wrote:
> unregister_sysctl_table() checks for NULL pointers internally.
> Remove unneeded NULL check here.
> 
> Signed-off-by: Chen Ni<nichen@iscas.ac.cn>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
