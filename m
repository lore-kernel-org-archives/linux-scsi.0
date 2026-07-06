Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02773DDB0E;
	Mon,  6 Jul 2026 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349605; cv=fail; b=D2ElH8C0R3UUkom8owCPlsBwhfyRaCy63QV14pSlngqz9RJmIZOVW4YfPDh53BHtgPRQN6PGMsjgc9kBfWETyb757MtkpzaEbQinoxoqdSc0eUIx2qEnUM8Hu3OYkst/8IdbEiphKzCOpCgFINiUct1bqmcbMY2v5QyIoarFE5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349605; c=relaxed/simple;
	bh=qlis3YLjeEks7uYHeXSSSgZnCjCmEJ3XkXYpo2dd3Oc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SjWTUlsj7m3sbjkxKQnOSB0CTQpZP7fBzTlW23oBKgD/v+0NCp9lJ+MI5SFIOrxZct48Kw0xR5gFExQyvAs3FeaYXKzo68AKHINVbaNHh3WPpih5ssA1Z9TGEYD3kwegsW0CPQMioJo3pmVH2dUPtDBw/G8MvH3ptZ3u/sxBz/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jomjfHRF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dNG6Gp22; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jomjfHRF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dNG6Gp22"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666EjZdx1138933;
	Mon, 6 Jul 2026 14:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cGqFjn2dIHfd/vcbuElGqSNxNFArbeUYXBdSdceYf2o=; b=
	jomjfHRFuXHhI+/QCo9Kbw3ZPwqvJFsSWqOxItlMYs1rgzaPU/2CZBCVL7cBfWLr
	NNrNy74RJaU2/qqTa4FqIu1Ph4CpzPiijVFfXCstBN5/fR0uZWud3F98BM/M/XZb
	hkmtnzyNEjQoXfEg6IAPUQ2pmCwZAOvHHOOLCGJE64hacGjCI3+KmDjS+MfAbnA6
	QjQM6ld3aObPVfj5VaLEJBY2CwcSeKylXTRkDc7ciXEqB2nZUDxrVMnOzcrJczT7
	eF192mLRTJZYeGW4smiNh7eNKGqSRK6rIl+e6OfMR0BBOBXHYe5RtK7guVDkngCY
	6zIOQzyQYzq3dfHtni/iVw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rs1btvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:53:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666EmXwM024070;
	Mon, 6 Jul 2026 14:53:21 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011070.outbound.protection.outlook.com [40.107.208.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmp81sp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:53:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MyyoDm9Qr4zhjcTQ0fApg2P82UPkkfISbm+4QdJLOzNxC/aY9UroWb6NKodguBHwsFkVvTDaKPsHeCHOguvXQn8xJauFbxqPy611qg/QAgOMK6e5KD87vilk8R1gara+C0o0/vDC0t8VnmMCN00yt8y5Ly0kCHoNmzZKRBMfa7Vr+K2Ka45uQwsgabXcNlRnCrjQlSPc5AHUiKsZwq68Ddlg7awKUfmaK7+L4POSs5GyYadKGwsqgrbEflDXO1u7Puqseb2vheA0mL1siCgBFq/vGTcLw7dZt5/aDG/qTdkdrtwP9kWEYqtgxi7eoconbqCyuRpdqzhDB6PsH5ugEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGqFjn2dIHfd/vcbuElGqSNxNFArbeUYXBdSdceYf2o=;
 b=K365vQSSodkL6dWnrhv1vQgwuPMHo1MtOGJ/ZdJIBj1WYtrL66RxWqC3ORUw+2e3wnRoI2AhfrtSamhfK0zjqqDCYP2AllDH/s1jWZLTNdFQkGmDJe+8mgRBJPvEJLzfuonF7T23lnG5a6Pmo94k5HE4bZXMEHI5e4nTR8jI00GLQB4psasxhDxFDgEArHnwvstwQCzaT8Claq7pc0G58y0rY0mpVRpRHGiJ0rE6DT8Hx+A5k0Hz6ufkTZ3eCDxGtFzpmx8TxFzBY0xOAM1gEyV1EqkIpkTFSUbXW9xAqGsVOMZm7L0TMizcJ3qAmwdAso/AHYz7K/vvoafe/u3jtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGqFjn2dIHfd/vcbuElGqSNxNFArbeUYXBdSdceYf2o=;
 b=dNG6Gp22EieAji1epig47ZUM6lRJNg/XY9fccQ8O3oYye7oqvrF4ShrXebqQ0dg+tbpCnsjWO00rLjutlI9JRffv+GD5kHzm72zC++FlCHbjAScA/oyMdhrZ0uPQv5yxRkGWLoSIYSGuQXCWwzINrRClmUSbJYRaZ2VOAOYDMdc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 14:53:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:53:15 +0000
Message-ID: <d08661c2-2f47-47bd-85ce-ac96abfeca24@oracle.com>
Date: Mon, 6 Jul 2026 15:53:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/17] scsi-multipath: clone each bio
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-6-john.g.garry@oracle.com>
 <20260703112603.525E51F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703112603.525E51F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0416.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: 417e054d-94a2-4ea9-bb33-08dedb6e4ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NeSDMYI0vEyfU3Ql85F6nNCCqEJVv2P4Tp9XOuv83bT+tBVoDNSPG3u7q9NtsN8uZNiD1sTjRDZpcHG7Qb2V3yM4/TYJDn/7+wq6A+17GtRpCMp4qcrhs+UdX/yFC7JdR3Ls4o7WsWgrji+ZBe8MdCX/aIKDCnWVL0pCMNjN97pZvP9VMfG6FDzvd1cgZCCw6wZ/1WASDXazjUPr3n8Axiyq7z9dtQ+9FkaiqVcTuy6v44y/+D3gi2qDK141GJGNsAl44gugPfeUCW43KJ+uoCF1+PXA/2UjcsV7ucn5iI2bZjIJdrcpVJ4bhbpGmmZogIr9I3aDBLpzhpbV2K9wRbrFfBL3niu/U+bHO6yMRyuK5CjZZEjIFJ3khTbwjTWlBQHy25XLFG7N8avLOyCpS0tKn23c8uY2kkNCS/N4VdVK+W1KDrrEOE5l27majvFy5wjcGj8yee/UiX++RNn3y3OK1MvQ+bIgb8Gd5tpSFtWLBMgmgKigT8PRsS+/4OoPDubu3KkFasCGKvJL/KiEDUk/TJdXAFrjlr/sBZx1ZnLPffTnuRGkWo/eFylfynaMk3xZ0Lb+zkfWhR1wiIT05v1CN3aeukKLAK3v9V4KyxtMkqc25nad5+79ClLGsYEuJznGFR/p1nUSbew3bRn2q+YrvIKfFQOGLwX+w47E6Pg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDFNbkxlNVlzbkdtaEREd09TY3hPUVozSlEreHdJVmNjQzVoRnFUQVAxcHhF?=
 =?utf-8?B?UE8wZ0UzZ2pVZVVkVWFoQnNFMFAzbXBLWHFnUjh1aTE2SWp0c2VZOTB3aUo0?=
 =?utf-8?B?TlBLVG4zcWpoenQwbjdZcjluODk1akM3NmxoL05yODJOMFF0MkI0aEwyUHdQ?=
 =?utf-8?B?alI3VEdWRktwU1JqZWUzWWRrNlhBQlNiYmgySUtwNWprRHZ1SEk5WGw4bjZi?=
 =?utf-8?B?elYvVnFJVkpMNWlhK3ZadCswODZacExYNGt0cERzWEQrMTNZaUwrekdLbWpQ?=
 =?utf-8?B?aVRzRG5yQnQwNU9RemZMT2hNeWNrakZVYWh6Z3ZZaTZYd21YWVQ1UTRCdVhk?=
 =?utf-8?B?WS9rcHNsSkh0TllsYkEwVFh3bUkxcUV0NkVnZHRvZHhzQjltQ3dGMHRzSEdT?=
 =?utf-8?B?QkhmZWYzZ0hhZjhKUEFlRjY2TkUvYUVwaTZ4TUZkSWxlNlk2ejZNZXIwWTVw?=
 =?utf-8?B?ZUV0MHkzYy9sQ0xHdkNyd2pOQk1sRndvZk9WTHhvMmZyL3dKdGtzNi9lMnNj?=
 =?utf-8?B?ZkxYM0FyajFiVDRDaGlVWXhxSXdTVXRZYnlrekFoNEdvSmVHRVRFQnI0enIz?=
 =?utf-8?B?SUIxc3ZIVSsxdzc3T0JtYXkxSzNkWUNSTjl5bnpyeHo5dTdwYTM3cEcyMytt?=
 =?utf-8?B?SG50OUNQNCtUTEdBWVR6eEtTd3pEMm40Z09XZFk5Um9zU3VNMlY4a2xGYlN1?=
 =?utf-8?B?M2kzRDFlUk5FS1lDL2tsbUVMcVovY3pvWmF3RzhENFZQdmsrVUZPMVFlVzQ4?=
 =?utf-8?B?Yk4vT0RMc1Y1N1pYZldMekF6WmxWUWZrY1VPZnFHV0dwNmoyWG9neEJkdFhO?=
 =?utf-8?B?RzI2U1psK0xrMkV1bTc3c2dlclZ2RitwdDN5UFhTb1Y3cGtURGt2aHZRNEJQ?=
 =?utf-8?B?WnBxRkhNdm5QK0U1MFgrSmdKd2I5VFBGT3dKZFZ2eWxEVTBDaGIyWWpnYzBU?=
 =?utf-8?B?dkcvcUV2RVo2dDNNMGcrVUlycFFJR0ptOVhzVGhIaHNxckhjQTNSWWlabUs4?=
 =?utf-8?B?alM2Ym5ha3lxMlhXOVdHQW1yeEVjOHk2b0l6bE85aU1ZQXJNQnYvVG1FVDN6?=
 =?utf-8?B?Yk9uK0k3ZGNENHl1bWR3Z3RIV2llbXZHdmorV0Q5MzFaU3RMY2JYTDJkNHRl?=
 =?utf-8?B?VW9TUVR3enk2cGJhS29MajNFaVBWZWtCM0JZSzZ2R3F3QVVBclB2bnQ5cVhr?=
 =?utf-8?B?YzNUQmEzRjlBU0RJNWVjTEExL2pIeTdYYTlpc2d6MzVuVXQ4OVZLVWl6UHlm?=
 =?utf-8?B?VlZjNlRQS2JXNTRtS2V1Zm4vSWIyYyt3Y3BzM29OcnNzc2hMK0pxeGlBQ0N3?=
 =?utf-8?B?SXZVUkRFbUREY0J3U2E0NnA1bTRvVzRkbVJsZGd5bURaWlZhSnM2elUwN0VZ?=
 =?utf-8?B?UFp4YXRnSUNzSERrUVMxNlk1VnRlMncwenlRVXlOOTI2TGR5VUtQL0RDMTcr?=
 =?utf-8?B?amt0OTYzSHF5WHV0eDBab2w1aTdRV1JVTm53b2VHRXc0MDFWd0htVTdJbVgr?=
 =?utf-8?B?aFJRSU56OENCaitQZWVkdlF4T2p6b0JIUWV0UVJMaEVISEw1VnoyakZOS1Jz?=
 =?utf-8?B?N1ZRN1BwQ2NDcFZucXJNV1luSi92WGMySkdSUWhBcFZtR3AzdjRZK2U5cDlm?=
 =?utf-8?B?ZjJaOEZYUEkxRkhSWkRTWUdNVFoxY0o4S0dsbE5saXMwcWpYbmRvNXA1NXVD?=
 =?utf-8?B?QUVlUXd3MDRMbnFRZXJPN3UvT096ZVVJaEdXWmkzdmtrR3lhS3h0L3NRejNy?=
 =?utf-8?B?Z3dFQnNZL1c5OWlpT2xyY2F1b0kveG5UUTlvZVhwYUc1YTVIS3htUDNIYnFy?=
 =?utf-8?B?T21vMExjeEhBSjRrSlRyOGJBdXJaNE5LbjBJN0RBeHp3TG1EUnJOa3A3WDJ1?=
 =?utf-8?B?OE83S1Y1S1pYWDBvWkdjL0dsRytuQzh5bDFBMzl2elcyZE92bGNJSVpPR0ZT?=
 =?utf-8?B?ZE84OC96MGMxUHJuTXFKdGFjdTk1Rm43T3lpNncxbUd4NTRyWW4rMVlJYlBk?=
 =?utf-8?B?RVprZ0tqclV6ZGFpU3pUeUF3U0F6Qjlkc2l2UDRRV2g5L3JsMFJwSlB4c28y?=
 =?utf-8?B?ZHp3Q0hXR1ZRaEFpQXk2TDlmMnhtU2FBVk1GN2JxanlCYXJUOXg0UENYcmxx?=
 =?utf-8?B?UERYMElBSTNHVGZDc0lSdGU1Y0U2cGY4UlIzSUNwQUVHOXJtclNwUVc0YjdE?=
 =?utf-8?B?Qi93VlE4TWxCbVBFcEUvdkVBZU9lWXZiNXFHOXZoN3BoVUQvdEcwK1NsOFNs?=
 =?utf-8?B?YWhMREtrUkUreHJHZi9ZaHVoWkhwMW5jdXBGLzRMYUhuV0YvSm1xN1VIbUJ1?=
 =?utf-8?B?cFR1Nk84UDVsZDZscWxsaWdWbk85bmREUFVYTGRMUlBmaSsybnFDLzlnODJw?=
 =?utf-8?Q?iL4In9kMvUSVhJQ8=3D?=
X-Exchange-RoutingPolicyChecked:
	PREBYkUG+Qr9tHB4uwj0D/kiEO76rWiPlSVAOql33xpj3BvFwk6CVKWdQ9CHkgEVLUQBIIEPMBIAhGVaqO6rJrEYe1F4OQCmEB7WM7b4hvQ2MZedK368eD/tg/BeE6mKOEoUr9msdz27UQ2yTya+KVpH3CpVlDzRmB4hxmQc+DcJj54enErqJC/ISJRaaXJnJQeKtn6S7tc8mRUzaHAUQOW5O4UQmPdHk8nqTYljpUEEH2NWOlJjoH+YKgllM/FcschqCroe8qcA9AyQg39EUymuvijcbBkaW7fDVKkGvfhROfm4yEqDyeofA4kERN7/jAWmKAc8KpsWWAIHsI1WLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iMcew33DqP1j48T+1y76As1/hR1/AWdLol8FJHBS0lw9i8Iumyap/qKHj+wlsYpWMI4BhGYgcvGKf72j7NZJeNpATq99RiqJE2695UQqYSAHeE0ZRKXVTdGOCRGbE8c6u9Ka57HheC/Ia8r1SbsLtQRRcaRPyVltRTH3WywqbBfsmlB3lBOsU6vFUm+gSOHcAuS6uMYFXidShxhatxNqReFbZc3KxqBKZ0b2VGi65GmaQ/fXa4+DN5VmzpzJYsf695XhwzMPIma3bdaH4L4y5kTY5y/SAYM7SrQQwHM0VAdwqhOMuW3ebf3OSRBNeCzi3IKK2ofmUR8N60uWlaBUEmIkQv7E/AIxNBYYhjKiudhRcQG6QACcDsw1vZsR9N5WRETv1yJME7QoYdJ+X32zc8cBFj4o+nFjxkYNnhsAqAuMfitawLE+f178IUiF87iKeoW/Byzv9h7gsI6JCr2Wb0kVRHdbxbLPgzaEtCZjcOXfWAM6ScHhbCQoQ7O/x/v6JuHCuATTtbestPp+bKHFOORpqHD+s+iYEQMSBEmDa5UkxK+FMqCHab8CGQfpcdnKns2T3KJ4c1hpQoUJZiS5HTZBhi22MtUZBe0FW7RzUPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 417e054d-94a2-4ea9-bb33-08dedb6e4ef1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:53:15.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AaEhLGNNRiCeGf+sV9kTKm3XNdHQOjE0RShrCp88mYIAjFAktVa249osv2ZtYHu8/Mu6HkZW2Ef8+a8uJW7LOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060151
X-Proofpoint-ORIG-GUID: NuZvz36FHEJUec1VV9FZgoOUv1lA0BCW
X-Proofpoint-GUID: NuZvz36FHEJUec1VV9FZgoOUv1lA0BCW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE1MSBTYWx0ZWRfX0uwh+4R9ozqJ
 JyGBhhyI8C3c2rMquXmRLYa0DZADLHMrUt0/ZLexCNywWtEZcvNILHpTUOMZENvqk+lcQlJfOu8
 XpZCbVGF5kVaf3cn4x9+fIJdNHs3htHqzT6f8Gy8+TWtdmMxunVG5neLzEdpZbSwIrfkNg/g/XZ
 OiXFQJPDS4A24woPlxA8BG+F8qm3ida+FIVRds4x3EbPDIz6Y19ZrruxP3O+VhK9Ia76eBo0gZg
 nd35ZghVNu5h+2SchyShNxIszcsGWbrtYKpB/LRo5OIW+2dcPP7GMwFbbYHlxPHaZds16HivsCy
 PIcW88hLYTycXDoYo1riqrU2ept38OKvhGL4EQ0N7ahjIhd9kObjfNy6honA59P3FTq3dArgvbr
 /qZEQDclvGG9il1gjnovLh2o4qA0nzFedM6Ih40sRGrJu48Qk/211zeEi+L5Tya9UdMjzImkhIb
 eXgpEEekEIHRi7+ibTImZGpTcBkhd4HDtWSyVZHQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE1MSBTYWx0ZWRfX6c9/WYkRCtmj
 1v1G4t9K8YjdquMGsTaydfOGEs+N0MjDhNL4UAwenUiaJ7mQLfTsLUvoAMy2qL5DwlJhHh/pbJF
 392ZzJjtilumFrR9+c6trate25JnSpfybvFhQ38ChGgkzJOQag/K
X-Authority-Analysis: v=2.4 cv=Vu0Txe2n c=1 sm=1 tr=0 ts=6a4bc163 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=i6kypgwOvDI-zuPmVgMA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222

On 03/07/2026 12:26, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Destroying the bio pool before draining inflight IOs during teardown leads to memory corruption.
> - [High] Manual cleanup on the dev_set_name() error path after put_device() causes deterministic double-free and use-after-free vulnerabilities.
> --
> 
> commit 31da3ef05c72ae055a7ebbed278c14967c624ea3
> Author: John Garry<john.g.garry@oracle.com>
> 
> scsi-multipath: clone each bio
> 
> For failover handling, we will take the approach to resubmit each
> bio. Unlike NVMe, for SCSI there is no guarantee that any bio submitted
> is either all or none completed. As such, for failover handling clone
> and submit each bio.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 6159803d4cbb8..ca4ab720c19af 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -96,6 +96,7 @@ static void scsi_mpath_head_release(struct device *dev)
>>   		container_of(dev, struct scsi_mpath_head, dev);
>>   	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>>   
>> +	bioset_exit(&scsi_mpath_head->bio_pool);
> [Severity: High]
> Does destroying the bio pool here before draining inflight IOs lead to memory
> corruption?
> 
> If a device is removed, the final reference to the scsi_mpath_head might be
> dropped before the underlying request queue is frozen.

We remove the gendisk in sd_mpath_remove(), and this must be done prior 
to tidying up the scsi_mpath_head.

> Because the queue is
> not yet drained, inflight cloned bios can still complete after the pool is
> destroyed. When they do, scsi_mpath_clone_end_io() calls bio_put(), which
> will attempt to return the clone to this destroyed bio_pool, causing a
> use-after-free.
> 
>>   	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>>   	mpath_head_uninit(mpath_head);

