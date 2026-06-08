Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB75E31F9AA;
	Mon,  8 Jun 2026 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780931534; cv=fail; b=EEZ1ua9sM4G3a5SpDbu/JmpvnluqhNM5R1R3ky4HnBMC9+g9NChm4DXr7B6etYhCCL08nrQSH5CtiC8kbjYsBfBftXC7sSDKsfAGrnJFZIH2BY4yfdun159IPGSzHvkUTizWeT7yvB9W17a3WymSkhO6cJ/OWjdQBJH9Zku8BN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780931534; c=relaxed/simple;
	bh=lnbTafCFpluVq3FcfIvVLM6WPDfKcZjmKCXUI+G6J5k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jp0DGOdzT3+vQVR/mK9d3og1QnIxFhVuMBJUEQ8mU/lbUbjK6kIp1Tn1dXjwsMoWCocEiyeC0DaWvRHIm7OLWQiB+keonOoqV/ePInA1r/P72XqWR805zV7SC20DPOXrPQBHYGYdKOwofv3D4kjSw+idFZyZBk1QuXf2qZr/UeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sXy79HbL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I0TBWD/2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sXy79HbL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I0TBWD/2"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6588MXgc588012;
	Mon, 8 Jun 2026 15:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pRjSxiRXUyoEDoC6E5FH6BfMULgLflpkmnqinlIhKk0=; b=
	sXy79HbLgnkZWfO9UNVcbIgqOLP42fLELD2grfmqoTu4sMy14F/aGkRgswY0OnJE
	EjIkaTymjBeBGDGibezM05cuyTJzzI15X8d0i54+XRqSnR8SvNuY8KrLqOfvdUqZ
	pu9LBPt8/TGXFf/SnjurVw8qSBeQPyYDkh6TOHf5w9cU6H45/zNoDhHVhpzAEzsR
	OKOrf0NJYURSxKvoix+HWBG1kHwL6Snv6b2NjjEAULGW0BuGVnjEesG97Bi+VLtY
	ul5qbwskmap8eLtrkkP35SWCiKVXTG308ZaMXqATkNv6xtgTpXenDXki0DyoePPA
	zelPcll5vnX1TRUevpqKkQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emb5stpk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 15:12:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658F9IDQ009456;
	Mon, 8 Jun 2026 15:12:08 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0nx4e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 15:12:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrAmOm4EEiUwM5zej8pOLFFGbc0zwiezzwOMcl6tSY8NAmdNsaAfLAT+6/vRnvlu7/W+QMCv/ixoqb49b2bkF1O4aDfVA8jGhM2NGrdg1qLN70Wg20B4c234zPSb26xGZZ0h8XQRbfCaPzMJeidtfXgFsYs5vvvAF9Wrci0Jq6ulK5HgpU4V3I2Ov/cM1x2Y/EBoiu2XIDrjFu0SjOINMFZuAskvdL0qzSC10kbUtKHWN53rdQOvi8c8aVlDjsu6mD9zQ0kH3bPdO7RtqRzS0ZyTowvzyB7mQ92hlZFWdinFFFuD56XHbNBcCcfK9hWU5bhd2VUPP82V5WqGvcG8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRjSxiRXUyoEDoC6E5FH6BfMULgLflpkmnqinlIhKk0=;
 b=Om3yaOLfo8uaKjCsJblnS8C62+pGULKCwHEd0ljsn4JLfcy87J95iNgHpjpdRA6qh7clT6/keAhEVwTm39Jgr1yT4HFaw4u8N8+RaIR5t9JvwQK/S4L269ekk4F1hxyXQyWFXKp29wo+Nx/hmD0Lh+0etC3ihSxjtR6zgxuzUs0+sERQxOF7OYclhkvfPXSbHz7YKf8X8k65MyTSGyJ66RrmIKE+vca3NT0vu0bZzsPn7JbetoN6xtODaCcv1KvcWsz7pVJu3ytiHglXG8OKasDsBG1UhBGW2ZiRwW+Jlg8Nc2/FN5lOAOAj6rl8GSELGsQC3gM/a46D8WJFp3xgaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRjSxiRXUyoEDoC6E5FH6BfMULgLflpkmnqinlIhKk0=;
 b=I0TBWD/2WCmvwU65hGgvlk9/9gs9Uf9BbATvDzX7WvOjahMza28h8JT5KfHtmsy250FE/tm4aw39t7IEXxPRosr2vvy3GcNFmMWMyWMQpl67FVw1z3sPYlDtByVp47Rh61vELZsbWMKf+nfsNTt8hrIbS9WpV/phkPIMR75xmgc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB997780.namprd10.prod.outlook.com
 (2603:10b6:510:3b1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 15:12:04 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 15:12:03 +0000
Message-ID: <e14cb77b-a253-4091-9311-da6ee5397410@oracle.com>
Date: Mon, 8 Jun 2026 16:12:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: target: fix hexadecimal CHAP_I handling
To: David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
References: <20260605122019.24146-1-ddiss@suse.de>
 <20260605122019.24146-2-ddiss@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260605122019.24146-2-ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB997780:EE_
X-MS-Office365-Filtering-Correlation-Id: f7064c1d-0bfa-4464-34eb-08dec5704c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TnQLwKQo1oPH6YHHN/x0ZApmoweEkPKy+7a/KyW4VgT+3vI0jjJbzQr66rgWz78sUOu40iKLAFuaFNvDUF3u0FsY+wpcjYBO9wafJLhUVx+ZRvwVGMOECTgSWv5srkJoQDVMq6DJtVb5RAw73oEcVQvGcFLHZ4eQzK5JCUpca+J++w9UuZM3n3UjryaiI/DumYAfpOinzn5RcA9PShNc20UE/Z//GBoaP6X+q+I0XfIEa6AuR8vD6N1tF4Q3O3QguA+iAavLT7jEhc/RaveazLfk80bcls8wGfpWWOav3BpK0aKUqemB3Z//za8D1YyNxK1mifkUXMSYkeUKDJI2fjpH3UFzlssP4MQXEk4K75nvZq8VB9ebdkOghlF6tmYviENZ0Y1AlPWKztfq2v5rh3hV+OkKNS2BI1ceCxiTgSxI87N1bIK65mbg6hSKHOjxD8aOjsTr5olRThWujDXStf/QLKNykIC6nyCdRmLANs6cpXO7W2Mofqndn12GDoKRHm32glKTAgeEG78gKq56SDX2q0wLAimMAf5QCCD6O0faObcs4IlvLqf17Xh85qrlaeozhIoKgmWKLHSdEVGu7MMS4wcql7vYXeDfJdWJHHRjHWfgEZvfYNKwfLfZMPEFMBDtuE114n3Hj2CygsTCJD5a0jg1lIZXq2xDdNXxGsypj9V5bRjwarqZuQN9+mPS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHY1dkxTTmp4U25tdDFmK0sxZG1YdUJ3ZzhRN3pmdGdPWmlmc2tTU2Ftam5t?=
 =?utf-8?B?WmxkRWdDTGgyZE5YSENzdExnQld6QlA1dC9VaUhhazNVeEhvVEtmMHh5K3dr?=
 =?utf-8?B?WkZYMWUvcWU4clB6QU1iaHpNdXExYTd3TmpuYkQyZUczNlZ1Ui9hL3dGMkJP?=
 =?utf-8?B?b1JVVENla2ZaVVpEVDJnMElYVll1c3Y2dGpoT2pubFJDTkplMm9tVEtEdzUv?=
 =?utf-8?B?N0hUVGlGaVlYUzkwRGRyV0pXdXpJVkF4Q3ZaQjlzSWFDL293NnFpN3VxT1V4?=
 =?utf-8?B?OFRnTVR0ZnBON0dWRHVsWTl5ejBPY2F4b1ZnTURMdm45RnRVeitWQWs4cE5N?=
 =?utf-8?B?NTZrM3hURENWclVEcStNNDJIVU1iU3BBK2QvN1FWZEloVENoaDJ6Nyt1QUVY?=
 =?utf-8?B?T1o3OWwzSUd4QXV2Rk9mVVJ2a0E0a296eDN5ZjBkV3d1L1NUa1RaSFBjemlh?=
 =?utf-8?B?RGJFMmtTOEtURXQzU1NDcWgwRytEQTBGeGxqL0tPUUI1VXZReUNoVUlabzhK?=
 =?utf-8?B?aytwemxGbkE3MzVoVnN4VlhoQnBlbFg1ejUvTlJKQkZKMTArYWNrZjEyQ29s?=
 =?utf-8?B?MUhsMW5jRE9LZDlILzE3OXoySlUvYk9zT1N1SnJEWERzSmVyZy9PaG13RFQz?=
 =?utf-8?B?MlEyWENpeHQvN0w5ZzZKZFU2NXQvenRGUTYyekgyYm9ucXg0R0JaMlhON0x4?=
 =?utf-8?B?elNwUHA4OUxRWFROSU1PZGJKM3RkNkdYLzRoTjlMUTV5Mm9acHk2ZUpZSjFt?=
 =?utf-8?B?T3hjU1dmQ0QxZWtXanVOVVg5TkZWTnhHV1RUZWsyUGh2c0tlYldxNkQ5dzZv?=
 =?utf-8?B?QloxckpmM0lRQTdvZGh1TmhuRjdvV2k5NGFDQnJuQ0hwY3ByTkZIeUNPS01t?=
 =?utf-8?B?Y2drUDVGRE9sNkp2Z3FKdlc0Mnh4cDFpZWR1WHpUcGIxNVhKRFdMcE5MZWZx?=
 =?utf-8?B?dVJGZXZFNlNwS3hCdGNibjM1Z0JZclRxMEw2eWJKUUNYcEdWdkphc3U3MVcr?=
 =?utf-8?B?SG8yQ1BHVGhveWpWZzNIUGdhU3RkR0tKYTlFM1ROM3RTN3dQRHEwRTFuRHcv?=
 =?utf-8?B?eElYaUlZTU9zOUIxRXIvUTZkZVBEWTBjRWZ2eHRnUGJRTWJmUC80UUlhZ05S?=
 =?utf-8?B?eFU1REFGYWZaZGl5UVFCaFJxMEl5K3lGNWhkajlhSlpDK3o0ejFNdnkzK2tN?=
 =?utf-8?B?eXJsSmF3N01tbXBva3pNTVJSQ1JCM04xMEh4NVRXREhtcHJNbC9nMmkyRDc4?=
 =?utf-8?B?WlMyME9WdFpXOVd4NHRVTldhYzFhNUEyaVFaTkZ6WHZMalhtMm5FNXdpbDEv?=
 =?utf-8?B?TjJmMjNTZWUzVk5VMEJkNTFveDgvaU9XelJRMlFHQnNsTTR3UldhMDJPeEha?=
 =?utf-8?B?dWlBSnB2VFRyTjI0WWxxK3JyR1BGc3hxZ3JFV2VOSlFBeERyR1JYZlAxd1dK?=
 =?utf-8?B?V2MvZDBlMXBpYTlxVDdOTE54UWhzS1JSZ0J6MnB3bXRESzQ3aXpxajBld2NV?=
 =?utf-8?B?MkptbUdGVUlJVnZSKzhHbElvQnFpOHI5ZzViazdNUlA0Qnd3NVduZlQ0WlhJ?=
 =?utf-8?B?K09FVzljL2MzQUpMVUp6aHlCUmFGL2srSCsrTDM3RUE2WnlZVDdVb1p0Z0Ni?=
 =?utf-8?B?NTJRVWp4YkxtTGxHL2pxV0dOaTFEaGU4RnJSQmt4d0RXZHZnZm4zZmpPdWEx?=
 =?utf-8?B?Y0VpMEtyKzVBempRaktXOFBtSzV2bXFGWkNxSVVBbDgwN3UzWEZzTW0rTE1w?=
 =?utf-8?B?TzNZWmthNVZZQ1pqa1hlV09GbUpHMERoM3hiakpMYzNPYy90MDQvY21yTCtv?=
 =?utf-8?B?VkdJMnB0eVdkcFkvbE5MNGxTVVczVXJFWEo2SG5Vbmtra0RlcEUrM0hidEU4?=
 =?utf-8?B?dzVRbVJzQmdlV3RraDhJVk91ZTVWN3dqa3pYVGlQc0ZoQmh4TVpWSWY4N3o1?=
 =?utf-8?B?cmxsbnQ5Q1JGOWs3RTZKaFcySEJXN3ZnNzdhbW5QY1RzZXFSUm0xZHpZcXps?=
 =?utf-8?B?a3Z5WExoelgybmY1VmlHWXZxYitMR09NMHVYVk9EUlZ0VzRSY1VZaWhwTkRv?=
 =?utf-8?B?dG15d2RZSEF3N1JJSlFTZUR2YXlPaUxNRjZETFo3K3I0VHJOSGtRREdvcTNh?=
 =?utf-8?B?RWtLOEp3cFg0SWUyK1lWTDhzTVNMcTgvQXlWamtUNTZDUW5mVjB6Z0VKQjVj?=
 =?utf-8?B?cXJCVHRlR0IrTHVCM1JuaVdFNnU0RTI1NkVXdGJ6UW8zaU0wTGErN3VOWG5U?=
 =?utf-8?B?dE9iMGdRSXBwRFhOcWFxalErZ3dadjVKZlZNNE81NHpIcFhyZUI0MnBSWmpM?=
 =?utf-8?B?eFBmcnNEZlExWXRlUUlDOVE4TUs1OGhFemxJem90SlZ2Y0ZzdTBIQT09?=
X-Exchange-RoutingPolicyChecked:
	oJC65vk7K0C4WEPy0WvwIKO0zU2pcByyuZUE91rPtwilwSSFR/mfsF0srsYrYYxT3Bib/CkM57lHGscfV+7qoTjFczq99U3gvToHP02mt0UWHq/D9iuZfkbZqDsBefxP7m4Mq2zzn7gOHe5oQoCX8fcJOt6K+GL7Wkb8HLPJPi03E/CzppewHg+HYvF1OkbRzXeUkDOm8NYwbHrKXJ1fQeG3eGCz84/qP7T1naiPUgx4BTExa8AY0vBJCDfJG72ilo4imL/kJrE2FVodX1/k3LWNauUuaEk2/mXQ3/MCxMx3yA4B8V2zIr3IUzIIaP4otISnZNqhVAgxA1NFAAhQ4g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gdOic1fnmKxyJWD528NRKKUw2XD/zGdSbtnTeTHLduZR9iZHfqEIEfopMZjnrRHg0Rh2IeVh9ZntBofLIrPazLWWVKCQ23m904oke3lGclQDHAoVsVCZSjiJZcrvuCxQiVXvceVD70p0KPL4qmklcTD6nR2aUekJAUDBZZ/Gzdy1Cu3kKoeDjYBKOvpOs4UtaLrX1jBB1ZOOX6spV40UXLIr3wZeYDjfYptLxrHCfsWLaCyhweo9XwlPeI63/GwRJW/PPVJtUable5LY23NPkuCNazGTU+ZNBuLC6+VebJm7TbiHa9tSbWHxSLHzIJan5ZnAS6uXC8iCe4a6e0ewgUams68hcjRVn+dVQxhVZbZ1DutoI9jAuxQWDU+tStPoyDTiqy00xOqHvhM7hD8oqTUsnO9xSCN3UABF6rx9jBj94Yfj08hO7TajiS+c8It2STOIgHehgzWGVur6iR92HwDptP7Uzpmo4CskAahZ2WTGzT3hgwOGjLVDOHMtIn/nehy8YjRphJWrU0m+jJr4xaM16wiJ7R/BONGXR97Scpw3rFXqo9KDJcxqd8VZXDT2KrVLnIu7uyjS7DlS6F1njMpwTIl8PDeIuEA7oAY8TJY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7064c1d-0bfa-4464-34eb-08dec5704c22
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 15:12:03.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vY+z+i1B21pi84BUB2wi6d1kWAY5EOd19DpgNbqUmXta3pe6kvgud3KR9+b8t8KrlPeloK2ReTETuIQJgWmf0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606080144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE0NCBTYWx0ZWRfXzju7+tWNNNag
 1NwI0xqxtPRCzAGCDKFfP7SbiC2d6hBW55HRClVQ/8hSW3bj3HApHnYYE/nwYaYCHybrngCw1hX
 ntZTuzHeiyLX34AxvNKHZPyvbRiBNpdXK023GWBsx1IM/tjoBnZQyh2YWll4yycr+P/KEuPm2Ft
 TBhq/mxHQm2ATkMEZZXbQ1stn6yXDoMgZGKMp/+OUMVvSN/sg9hCrPrQUOOIQpemysUk1VZB+8I
 hX/eVtXMWGxLA5IAxXhS2KtLFnpjQvquByiNkcr3E2VZW6Qh/qmF0VG2E/jWP4Q8Xk0/0TDvB5h
 y7aYLyAgN1o5of+/Krosp0xDzHgXIkGb4ZRuqzVLyi8KqvowPho22GTvyJqhuawJ1nqbpE/lodw
 UPthKch3a/fsaTKthtsrkdjQ0NFMUzjFDuj+QgGLqcfRD5ZR69cPsBqFfdGvCL+FNjNrQp/1SfJ
 XfXoMgPU7OF6VsaUBYuPCs94K7+B2+ZFbsFumQUQ=
X-Authority-Analysis: v=2.4 cv=XeC5Co55 c=1 sm=1 tr=0 ts=6a26dbc9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=h0vacfb_PHSd1ONryJ8A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-ORIG-GUID: c5Rq1GcNWBvjUnfr5GzqpZE2rSdpn83h
X-Proofpoint-GUID: c5Rq1GcNWBvjUnfr5GzqpZE2rSdpn83h

> ---
>   drivers/target/iscsi/iscsi_target_auth.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
> index a3ad2d244dbee..5858cc3089796 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -438,9 +438,11 @@ static int chap_server_compute_hash(
>   	}
>   
>   	if (type == HEX)
> -		ret = kstrtoul(&identifier[2], 0, &id);
> +		ret = kstrtoul(identifier, 16, &id);
> +	else if (type == DECIMAL)
> +		ret = kstrtoul(identifier, 10, &id);
>   	else
> -		ret = kstrtoul(identifier, 0, &id);
> +		ret = -EINVAL;

Only hex for decimal are supported, so I am not sure if much point in 
this check.

Regardless of that:

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   
>   	if (ret < 0) {
>   		pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret);

