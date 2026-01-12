Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DAB23C506;
	Mon, 12 Jan 2026 18:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244178; cv=fail; b=fVv4rO6wR2MDF7+FmkiTPgq4AIhvp0a/cSagoDi3yCIMcGHsaoznIzvNTqmf3KpNo5g8d/ZGQTdVGS5Sa07J1lhsQ6fourFbu2E0TMgNlsk1uk7dqCz0AefNsNhYIMyP7+5kkrcI10Kh9PdRodkSSE+K0ROWzEQ/+OR+cSy13ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244178; c=relaxed/simple;
	bh=vlv7lR25G50oKUTapu47G8MYHLluEP1yipvT83bQ3Jw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p78UQ12A9kS6HjEs2k/3p53xpLsU8hYEm0EquZDKMDfeuq/7d/TUxLnbUl4pnR7XX/hIllP9G//xxeIunw7/veTmxqScUerMAzEgZ649EagREPRt+voEok+LegPM4aUTx4CQN7Pm20l7DKVZJkzw2tc0I6xCJJg27fkZkWtcRmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KEspvGa9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MXvqtsSW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KEspvGa9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MXvqtsSW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60CFGCx7148494;
	Mon, 12 Jan 2026 18:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=odhMQVAK6p1gMb48c8ZEwxX3uCVbBZ1pzenj2Yh8DrM=; b=
	KEspvGa9QbnuH9qetoE1yI3VFYRk0dY7z1zX2bss1oi6p/koX10OXNIrNWI2BG1o
	+dTMJDBMLw/yPwRpYO7HHMtuaiaroEZxdqtlwL9zTY7WcCwMRw55+dwffVFnI1fK
	UP9PyiBqCp5U4jLSNnHAz7enSAo631c3JUtJ5yTY/D/ko7fSBqXDSrdTCI1PBOrm
	7/Oc084kOHQ9AfT12QMDXGyz8yaJNq5y6d+peJHuJ39DDxosGAGOgzaTWwqTsq2x
	XRC2GKCYsx4QQ0qT/Z3LdLdROrlzo/2ZBxDSnTuBYch/1u5LFtJxwsHdNMtYX6EK
	kmSZ6PRX/58yv4aqJqnyTQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb280v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 18:56:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60CGpudf005627;
	Mon, 12 Jan 2026 18:56:10 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd77hd6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 18:56:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qg8woaUasDDCxmIfqEKUtjWG/eCoTVUNMN0jbjUjSv2bZva8LrRdUFFWMoZMkYzboBFB1Itqi2y4c3nIGv2tAC0Qdqi0S8ObUnrq7DwiVRboXdGhGvhPXlVzmdlE+R2iYCmtnsZLnYOuwJLlvDqeiwrIoOZGxtJYOxdBqxzOBhusQUq8kV9uzw9slaJjlGU1SYZFT4ZwrEVTTLLDoxozCw9/HREh4EnBHeaWwEK0oDOwSsbZkZlM8TgFVUvEQcU5IaaN5sRYCkVSFjtUkRvlswpRKjBshOtevxISlmBx5WGcSYhR0G5aAeWTbE+EXvXcjIVkoEcHxi+FJmSnOmiBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odhMQVAK6p1gMb48c8ZEwxX3uCVbBZ1pzenj2Yh8DrM=;
 b=IVRtFeIa8evDDDiCsk+tDCETzKqdKW3CU6Ypvrb9yvTLgUtJ6ursE+k9r1HTZMH6lwJC2XeIcxQwJSW8FGbAIYe3ugLAqgiELKV5Ej48z5DepozJ0v95q+uwtbWtk9ykqW+mWPueGx7kNFDyY3GVudwenpmOqoPHVJHLrAJ1SlzomJlJnMDz5PwMIUBgu26ndvNfgQoN50ThLCCmifI+gaynnn6RZPTVZIMOtnRWkYIvY5NcNsAumRWx/DC4NFMURgTChxDKi1gKNqIxXwcNHYZwkcUlY+8jIMa3eWfIRyUhnoElNK7+0iAJF3Dzv5C0b7Vs/seM/FVBYk9WaVlUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odhMQVAK6p1gMb48c8ZEwxX3uCVbBZ1pzenj2Yh8DrM=;
 b=MXvqtsSW2IS1JFUuasmB5ikSKxbrNiqteqVADSF76MRa4HEqCOVzVCJLPIONt1RkMR5+IRdCEbdbFKI6Afw9aOeT3JMDcThDnvO81trZ9W3zDtaLFye0l1Q1qwL61HlZCXwhmrezlg7oQYMKM2413xvhXHHnLUp3gAXeoItEQFs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 18:56:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::4b43:8603:b9fb:695c]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::4b43:8603:b9fb:695c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 18:56:07 +0000
Message-ID: <f8b0326f-6a88-45df-a36d-ce7d6b001ed5@oracle.com>
Date: Mon, 12 Jan 2026 12:56:06 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: target: iscsi: fix use-after-free in
 iscsit_dec_conn_usage_count()
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20260112165352.138606-1-mlombard@redhat.com>
 <20260112165352.138606-2-mlombard@redhat.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260112165352.138606-2-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0038.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: 1be474f3-f12b-4486-de9d-08de520c3e8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3RlUkJBdllXZTZwTjFjMDZ6WE1udkQ2dC9ET2lFdmNITWdDOFM0Wm1rVTEv?=
 =?utf-8?B?THNiNGFSMVFJT3JGK1Y1Sk5VUXZ1VjhXTzFqN0pFUWU0Z0gwblVMTWRpWkIw?=
 =?utf-8?B?djB1WEo4VFR0VUtwLzkzUDVsNnFVUGRRL0pIeEZCSHRBblRVVU9WYkp3cEll?=
 =?utf-8?B?TWxVdUtQdkpsbm5qcTRueUZHMGZqMW9qU0NqYzBtN29FQmpOZWJXdmNHYnV3?=
 =?utf-8?B?M2JqbU5HeDR6SVFCM3cxUWJPZ3BMOTQzeGIwZHErV05jL2M4cGVRRTFKREsv?=
 =?utf-8?B?WHhkNnpqRjlvaXBERHFMdzFMOU13MFhjaFgrRk9XcHNBc1lHWGZwNnM5Vi9T?=
 =?utf-8?B?S2xnanY0M0xpN05NVzcvYk9CT3I2eEFWcVRWWjU0MXFkQTdkVnVCM2NVMy9u?=
 =?utf-8?B?MnozTk8yaWdBZkpOcHgxc1dzeXpoUk5HSER2TERhSEhUVmlsZlZQUE1VSWdF?=
 =?utf-8?B?MzA1WW5RUlNnQkNiL1FFSHIwRlV5ZHRaSXhLR1RIT1FIejhnbi9MN0dGRHE1?=
 =?utf-8?B?enB6OFVEbndMdzNCdFhDT1Y4cHdWcCtSc3NoYlEvUXBoa0NrV0tzNGcvZjJD?=
 =?utf-8?B?WlpSSDZPZTAxZUpPU3UvOVRPaUREWC9Kc1VjTkp6dWYrdHZLd0k3K0lnemxS?=
 =?utf-8?B?TnNWcEE3TFRZbWlyVDJrYjZkTXB1bDJxVjFUbFFLVFcvaVF4dXNSVmJCeVZY?=
 =?utf-8?B?QkZuTkpacW9Hb3VTZDVseHZreVNRMEt3VVhwTU9kMU5XWkJ4K2lqV000UzlJ?=
 =?utf-8?B?dDRGRHhsdTFaSmRrRGxSamRnc2RpaWZFWGpNTHNDSjlQMEtaZUh5c0x3R0Va?=
 =?utf-8?B?U2d0b3BXdXkyUnBYNFk4VVlzMk1TV0J2RXNTcG5CTWpIN1ZPTkxBQ3EyU3Zj?=
 =?utf-8?B?VVg3NDRXZGhOUVJxMFNuRUhCQjdjU1cxOTNaMnZNeW45dFJaVFlucjBOQjNw?=
 =?utf-8?B?Z0lDdVhYWTFGek1xV3A2UnRSZW11RnhuK0pWYjBpbGZBS1RZdERVTi92WWFQ?=
 =?utf-8?B?NlkzdU9PaVhEMExIb0NmQmZCdUt4a2NBRXArcDJHS3RFSHNtTGszNy9DL1A4?=
 =?utf-8?B?eVNjT2NFRk1lMkRaUGhVL0drcmVRcjBPQ3lCbHVpd1p4V3lZSlNmWmZENVZO?=
 =?utf-8?B?dFhXWitHTk1CT3NMSnhTcjI4YTM4NG1teWR4Q2dPRm5VN1VPWDNMN2JVayty?=
 =?utf-8?B?bnkxTlJUTjZzWXFwc0hSNlo5SDFZVnBYT3ZYcXRHTDBsTWF2dzIrUGJHd1dq?=
 =?utf-8?B?UVN6Tk05Y0poSGduMThwbUJyUlJVZy95NUpJQ1lqOVY1YjNSd1BZY3RPMkxJ?=
 =?utf-8?B?L0tnR05TYk9PZEcwSVBjNGcxU1JtZ0xBOUZRVW9BYWppMm44cjU5T2I2Rmp5?=
 =?utf-8?B?aFNYUndQclh0emdKTU9ydE8wNXdnSjVTcGdOMWdRbEFKZlVBZDZsQjhoTytI?=
 =?utf-8?B?SjdHRkpKb3UzVUtPa3p6UlVhVnpPRlVldjgvWmhRbE40VDhZbVFJUEprNnhp?=
 =?utf-8?B?Q1Nib3pOMWR6Z2svYldXRDMwKzl5aUVzRkJBOVVWd1E1OWlzMTlLZWU2eEsr?=
 =?utf-8?B?TFRGTE1BVEJkOElrcUI4M3dBTmtxazZmYVExcW9iQXhabkViWmNTamwyenZu?=
 =?utf-8?B?VHd3aWllOGo5cDJPNVU3RUVhMTcxQThIdURidHBCbmUyL0c0aHdTaDRpb3Fz?=
 =?utf-8?B?VndWbW4zV0gvK3c2NUIwdS9SbFdDeXZwcXBWYkprWFhubFRGY21WanpIem9R?=
 =?utf-8?B?bTg1eDF4RzBrbXh5K093Syt5b2didnVQMUtwSUVWcTlRVE9YS1dIa1JnQ1hi?=
 =?utf-8?B?NnBTWUJ1eU9EeFpINGpmQi9icE8xNjVXNXc2NFRMQWM5QTlYK1J5aUowM2to?=
 =?utf-8?B?QlBBUjdXRW1CRytjeU9aaGJxSDBaNzdrZzhGbjFrNFRqVDRwVVp1eStsZGw3?=
 =?utf-8?Q?zzYrQwyvlWPZz1nUFbI48OcezpqQoz4F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXBGSFVrWi96eFJINUxmd3dzcGRCOWs0NnBudzN2M1FKT1dUQ0ZPd1BOSHB2?=
 =?utf-8?B?QkpXQUg0TmdjZmowMnl2RVRzVzRtNEJkR1ZYTENzM1ErTzB4ZUppVm4zS21Q?=
 =?utf-8?B?ZVNFU0c0SnFrSXM2UkRUdkJXeUs3Z1FSZDVIWVJWd09Ycys0U01JUWZGOWk1?=
 =?utf-8?B?WGlzY2tyZ0p5Q2gzaThuVnB5S1NGVzNicVNIUEo4S0FseXZleGZ4ZjJObzAr?=
 =?utf-8?B?eTJMdVpEVkhyc3ZxOHJuczZyRVJDV0tvcm93V29lUnB0NDV4ZFd5MFg1dkc5?=
 =?utf-8?B?NUV6K0lTbmRKcFBTU085aGVoWnpDWWUwQTRyOVJKR1BhOS9wSU53RXByM0li?=
 =?utf-8?B?Q0U5Z3B6c0pRTEI3N3h0aG1MSFFhcGE3eWRDaHpwZVYraHdqWVRnR3lQQ1Q0?=
 =?utf-8?B?YkJha2ZVNzZBRlMrOEZoY1Y1K2lhUk1yWGpXRndRckE2MTRNVWw5T0YzTnNP?=
 =?utf-8?B?NFFnOUJoczM2NUdNYUloU01LYzh0T1Q2NEtBbWNUZEhWRHBlcUVtZFJLLzh4?=
 =?utf-8?B?a3A5V1hZTHpEbk9XOXhaRXRyTWp3SlczMGNwWS9rd0NNeGYvbWVyMzV3UnMr?=
 =?utf-8?B?c2ErYkdpeWY0NmlIQW5hZHVlZzdsMVlrUWlNdlIraStVRzkrWC8zOFhYbVFQ?=
 =?utf-8?B?Nys4a205WHlGcEhacXhKR0VWSm9XeW8yUSttNE1PTTVZTkoxMlBwZTJPMkt3?=
 =?utf-8?B?UlNqK3N4a016bW11TmJUUFRyK1RtcC9KcDY2OTVra1pqWkFwWnVwOGFJaUE5?=
 =?utf-8?B?elJma3QvTTRLVGUxcGpKYnhGQndubFZ6dzJ0M2JqN1dQV3F1d3o0VGYzRlRm?=
 =?utf-8?B?bU5hbDNkQkdXeHJOb1lIVHptQ0YyU0hFdVlyc1ZEbUR2V01JNnhYMGh0NmlJ?=
 =?utf-8?B?STBSbTgvWFl2aXFkaVlmajlpYUlOdFIwZ0pRSUl4K25XeGhPTWdTNDlIWmFw?=
 =?utf-8?B?Z1dlcExUUXIzL3N1RlpvZFpNTGtwUVAyTTZNK0dXSkswTmkvaE00QU95MHlG?=
 =?utf-8?B?TEx6ckFSRmJrN0NTWE1oTHNTRkkrSTNDUzNFWXhIM2c2OWgySzRYb2ZyQW9K?=
 =?utf-8?B?dXVoZkhpVDk4TlJObWNOYTR2cmVwVTJTYlhPcm40cDBFUDc3NnozVHlyYVpn?=
 =?utf-8?B?elYyR085aTVOKzB5amNwa2ZicXo3b2x5QTczNTdxd3F4QVZZTmxiSG9aNThv?=
 =?utf-8?B?UEYwMTVBMC9TdHhKSUhESUVqRFkzN3FCaTFuTDUzbnhzem9kU2FIK0t6NWtM?=
 =?utf-8?B?TmtFVENscU5GUXduRkI4YVhDeXYrUklDZklWbStjMzBDTEszZ1lUbW42RlAx?=
 =?utf-8?B?K3dIWEJJTThOalhpdGJSZnBpTk9HZHliWWxEQ3FWL1BmT0p0aHV5KzVOWXdR?=
 =?utf-8?B?SDRnclRmODF1VGNNQ3hvQzQza2tCU3FpeXFnZVlXZ1FyRG9jbE1EajgyRTlQ?=
 =?utf-8?B?Uko5Zi9ycU5YSTZ6N2tpUVYxakNEZU5yK0dnZWJRYjk5a2VCbVE4cjRDK3Zj?=
 =?utf-8?B?aVpGYWVremdhdGxhM3FSTmdDeWhzRmRVRUpNQ2h3aytjTlJmSzA1MlNudnha?=
 =?utf-8?B?Q2ovbkZnd005aE9VcUh6aTdVYTNEVTN1MWdYQkhVS3Y1aHFOVk9yZmNtWmtT?=
 =?utf-8?B?Nk5pTGpSTzFLaGNZNkNpdnM1dHVUR0hldFBGUnhXQ2E4RTVsdGc5bVFRQ2dB?=
 =?utf-8?B?aFYwNk01azBTNU4vWi9CSS9PRHdwMGlZUCtyVVB0SFo5WmdkaDR3OGlSRWZy?=
 =?utf-8?B?QzM2c2J4Rnh3VXVFOWZtamlDVTFTdlpkSC9zSEpwOEladitSY3NRT01JdTdW?=
 =?utf-8?B?RkNHK01RYUNFbGwzVFcxY0F5ZXVUZDNpREY2bFJDamFlNlVPZkVVWUxyOWVX?=
 =?utf-8?B?WSs3dGdFUndmUVp4V3BUYUFCL3hzMG9oTVFYek5EL1I3ekRhdWJLNjV5Ymd0?=
 =?utf-8?B?WU5UaHNpR0c5bHBGM2lXT3VYekhUdVVsSExvdzBXZUgvc2ZrTnpyTCtMVFha?=
 =?utf-8?B?R2xUVXNoSEpyZ3AyeW15SWZBOUtsU1RnVHhPQkJkbHBMR0ROWTg4ZGhPRklz?=
 =?utf-8?B?Vjgrb3ZWQjVGU1k0SGlaMm5wNCtCb0tHY2xpWW1aWXNpRS8zdzl3Z3ZPazll?=
 =?utf-8?B?dWNrd2FQeTA2a21EMHJmakUrTmEvZkFxc1o0UVI2bGpqMG5vY3gwVEIrRi9z?=
 =?utf-8?B?alZOZXd1OVZTcjJxZG9IZzl0ci9kTjA2aXE1WStKTjEwWCtvb3YvVndxVEFl?=
 =?utf-8?B?d1ZLOUkra0krRXJkdzVTQjM3REo4T1A0SzQxYWlXTDJZZzVkYTQxNjJxV0Vv?=
 =?utf-8?B?REJDbnhQelFaMnlFRDBScEtYbzgwRHlnVXFPNlBVK1BQblYvTHB1eWsyZEty?=
 =?utf-8?Q?i+4iAIsh2osywxEE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	julM0pFIkMUr8Q3wthAwBBPm6xmF3BLuVEcGOZKRUp5OzmukRe5uqJajudv7/G/QIZyR20N1tIb3dNwR5Ej+dMHtoLkav30lbJaudovpcNszyC4BGN3MJTzEEXgUzHMnjgOPuKIO1jrjPmTfkm6swV7FvwNjNQY3JaXh7A3rgXjKKrJyumfhT7z0DL4uFiMZ8FwUjpsZfAdJxB2PMo3WQvxGYf2ORuX9/0QXljLTaZ4lw4O0zR0madP2wAMJKWKhTsJ6YpyB7lJa+SP1wXQlpzMxfmbzn9vnUkeRRWFZkKr6CG5Gnc1DL0z7iLp+d13jBUx1dv9RmEL9jrPLdIoXRq6Atjvv/Xh+sSJ4OGDomGPztd5J9tyL1eb48NhMaVPFBc8g4iwSp3D6e5iEk2TGjuNK2Ij3tqqy2MSblaBVVrLS5wERut8P4ASyrFHrPHDX6pegIfnAyCDVJIoTGDK8xLd+RJQl6KXaPzDsGkAYKlnv7DIYXHfYheGJZESC4j6BqLRBD/9GB016d5DJsDMvgjD1811i62xxhTOBSRkhsNe4wyNCBKPBb9D9GQA2RTIqjUymHrjoggeU7nrzS2vlaIlkg4qSyVYh+nnBwQnezEE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be474f3-f12b-4486-de9d-08de520c3e8f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 18:56:07.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CY2qi/y0YdxgrzJGxgpQXfj1inizOnelguI8RPXqijH90obAFYI604tSwYhxtJlRhnsaDVnyLp80B6P9+3dgn4XiIH0PwSCRmY99bQo0iAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_05,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601120156
X-Proofpoint-GUID: oKZx4fQdVEMyn-U8AWEm9RGFeA74kADs
X-Proofpoint-ORIG-GUID: oKZx4fQdVEMyn-U8AWEm9RGFeA74kADs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDE1NyBTYWx0ZWRfX5ajd6//iAwgD
 MoqCI7Io3+wdY/gbqgbQ4Ruzssi9+FzKSXPwsVvgZHLWhtRrnB1PJ8WDbLkimWdKP7a09aiUFXl
 th2hTSu2WmnR82fA3AzuNgQwgAdl+UyUWiNrx0jAzSXYLXF3Qm50so0K+nV4y0mPEi2XvGHf/53
 MUoFaZqvwwi3UZpTdibLXHB3DHVCyUHXPRzHBjDpY1G9nLmBMpDX0oBy0d5ldFaDVW5rAxZ+ALg
 AZhNDFAQKlwiXz/WnHXIo6Yl7o7L0wSWwWJLfZYtD4QWZsMlMRkR7C2A1zls58mz0VV1JW5FvZ8
 AYc14c11AJ1/hZ3DT34VxfSBMtr6UzR6LilILQKVMB+bMQreSfdKJ8uPKb534TID0ixJ928O1xi
 il5Hj1VKBrc7L/6UA4QALnTDOl4v4wa6POMq2y4Wff5Qc70fVYTr6Htz+ebsmj89FQgdDcIyFEe
 M3QoNLX55kmRk8kzc4A==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696543cb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=r6EoUW_mFUNXmIsRS84A:9 a=QEXdDO2ut3YA:10

On 1/12/26 10:53 AM, Maurizio Lombardi wrote:
> In iscsit_dec_conn_usage_count(), the function calls complete() while
> holding the conn->conn_usage_lock. As soon as complete() is invoked,
> the waiter (such as iscsit_close_connection) may wake up and proceed
> to free the iscsit_conn structure.
> 
> If the waiter frees the memory before the current thread reaches
> spin_unlock_bh(), it results in a KASAN slab-use-after-free as the
> function attempts to release a lock within the already-freed
> connection structure.
> 
> Fix this by releasing the spinlock before calling complete().
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> Reported-by: Zhaojuan Guo <zguo@redhat.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
