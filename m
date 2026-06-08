Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B23176EF;
	Mon,  8 Jun 2026 14:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929925; cv=fail; b=IXQ8NUAPGYlas6p8lOs4Y+IHVTCnr8YCpgz+4FZtN7BeJ66CGkBl9e9slJJG0jAy8kMn9juSUcavTa/Rd/aNhVf8tQHZ7SZCPdx3rpV7JShEF8xkIcgrWSUXnR03NEbQO5N1ZU8UTgqg057MQLQDHI4KQsAdx2ScX8HWQ7cNlOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929925; c=relaxed/simple;
	bh=UHoUQzHESsuPJIn9sY8ORu2HxU7tlWp4wy3AtEzv1tI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LV8dEXuGKAZTCD4S0FOTzFrHHfraFjTdLXSD2tHzCJxGA/M0FWNttFM2XT5iDmpX8vgqmff6uusklhmLb0szW8e6ywZDvPw6H1+HRqeZSIR+tnyj6KZg0cv1w5MiMxL5y8M4i2G09uC+2mTqTWb0kNw4PjJEdR3I7fhq4jHxuZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JEJgaSX9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MRCuJyP8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JEJgaSX9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MRCuJyP8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6588Or7t3034841;
	Mon, 8 Jun 2026 14:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y86Z2+/Ft4rqcUsJ30j4N9H+Ww4aiqQbKTJInf+dCVE=; b=
	JEJgaSX996AHnBeh5mc8qTuddiOv2wPsJvKjinanYsgu+HfEqN7ir1/8pfItQn+k
	gasSclUsHEJGrNeAx7dV6+GrQC0+29SJWjky13fPSEkIkLvxEG4ZhwrBBx0XwkLW
	lnANF6ZBiwWE/k8H59xT52aEpCvWD/YjpwWbjuN3k8v4B4vb5xYSca9NDFmEBvFI
	3dw9+5S+itSg260yMtacg1zVtUpJ/wLshWXgS7agF0kwC8EzIZyWFMX4tBD6KEYb
	2B7ilfPigdAIuMgNNztUUdQaBmurqR4KezTNBTB0oH3raRpRSCLMnCVbFkexYeRb
	eCraGDioGx/uktq7nBbigg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embkjamgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 14:45:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658Eh9Dd007121;
	Mon, 8 Jun 2026 14:45:05 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0df65t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 14:45:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EENU5ChwiboocWBCHK57QebKu1/HIkw9g1DnCSFCav1OiCSBW6gBQE086maXI/Rd2DVTMG1BDoLTAodpmI0KweaO+Y4hkRvTwpRgXrhJbGbYlojxnQjBVUiZHdmZKig0pCdQC5s7s+ayWX/1rqrb73Y2DZda8tp8GWI1NDY2elxKQOasupCGAKyc96Fe8xrEq4jHQ15FoAkwWZNj+b0wD9r+Sq+n17DbtL/NWmN2LTlhCcr/HX/ulbL4BpcfwTrJ7/VSt1wcyOmkuh60Mep1DJUmKrKNf6vtCxKgSkhyTIDQcawM0xkqfdFGeEh2iuwhtvv/NXiiIW5ggKPMAnWMwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y86Z2+/Ft4rqcUsJ30j4N9H+Ww4aiqQbKTJInf+dCVE=;
 b=mSFKrUEVJvNa8JL8oKbj/8S5JsQ3EeRueTb8RjqdFG456nh32HfDHXpJqh2MnpgJ4Cd1VI8/lOCJ0XM+JphzXwFA+f9WGxK371ceah/qBRRPE/9sYG4rtl32Yg4lt5IzFalvzt6TaiTvRMLYgK/FBE0q1WflkuBzRSHXyTx4aucsGgGBxcX5FKHDHi2FqgUrwMKxy6AhKMtMH++AdL5dYrviQIXwaHl/Hok0quCvXggfac2dW5Upec4V74F2pqYM+6A+vAiCsnBcO0IjNav37SfkVr+tNg9d3ZqjpTrVt+DnS6k9o/9KjmVj4xIZ1Y2I/AGwSfryIzz9fND6EISKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y86Z2+/Ft4rqcUsJ30j4N9H+Ww4aiqQbKTJInf+dCVE=;
 b=MRCuJyP8ZMaTPAi9UIoCbLsD4BeDSTA7XzcIbLCqX+2jY9YJWzfPxrSp/PBdBI7vNywDR2rQU97pHz5gWCgVN1asVPGPqAIWgdQ5TVk9GVt34+7lgvYogdR8kmUL/YbUGXfIvODTdzzhenaGql1tGrc3tl4abzD8wbkmji4A7/k=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by LV3PR10MB7867.namprd10.prod.outlook.com
 (2603:10b6:408:1b0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 14:45:02 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 14:45:01 +0000
Message-ID: <43ed2b6f-5b84-4a3d-b185-4275c9bb69f0@oracle.com>
Date: Mon, 8 Jun 2026 15:44:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: copy iSCSI ISID before unmapping the PR OUT
 buffer
To: Bryam Vargas <hexlabsecurity@proton.me>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260606015359.181724-1-hexlabsecurity@proton.me>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260606015359.181724-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0017.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|LV3PR10MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 02896290-9143-43fc-3a7d-08dec56c84dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|6133799003|22082099003|18002099003|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	OVn253V4ueVt3NwefvZ8JymQ1IY9s7/asjpUNpDqYpwXEyIOt8UlXpAJHi8QJ//wXmX04j1H7L1te/XjFojLMb2W34vHzMJVt0qDei/SHiGqa+CtPYqViCSEK+DDWXhYUkCgeEZfQD3mnc+/C7yjEjaI0ju7sjDomQQWvTJMgy749ubYOClAtVS+cbcPkwsqMLIemfhWNRlLzfZpa4Axs8WMCy5Tl6gHMmKT/PM1iCAGMu7YRGdJZyACcIo5kvNGBLFuS7nYKE0PkFWuWlLFDKgh+sSXS6rsshhwf3CZUhtmuzWrQl2GiZ1aCYP2SA1ryZgjzhX6UGT+RqAzUga/SMsNkLMTnUBQP0uqW89DbnZxKtzmMIO2+WMd2At9RkDGVsrvSVcrE5zRWU3KjZeQfZGoEppld03EG3yB7+wuRIPUtR6dP6phOa4Tt4zwwPJLSGszPX9gg63yNSN2hLrg8GtEPq74ERO+JTgic/FNnI78sFDNQl5Efd9gujxq2WMRn7ykfuBJsLDiR9sPp0ZkWgtEphvDzxh1B+SBRCFm6D8F2GHHqCjXPdADhs87vziZwerP1SKxlk3ZTIDsWik4m8hXLy19So8n8HJzAkwrSbUr8FI3v6BTIpATvwpE20cLCZIpf2JD3GSK4HVyvz0el+RQQ6kRL+Ow7lChQrj6oTotQp+FwJFNodL0gVsDBtBw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUJIaHIzRW54UmJnRTBFNmFEaXZQYUhVbmVWT2JLYm9GNStzSkMxWjNLUnJD?=
 =?utf-8?B?YXhCOUFkMmlHQTBzTzEzRTI3Ky8rZmtjWmJQMlMrRGFLb3krYzR1ODN2aVow?=
 =?utf-8?B?cjRrbzI4MDl0eGl0b1NteFFMR3A4SEVMbmtWUHlnUWFzRitCV2sydC9ON2du?=
 =?utf-8?B?dDFVYnJEU0FGbWN5MENWNUFrR0FpTDZ2bG9QNWRhVGR6NXhWU2FKNGhBdFpr?=
 =?utf-8?B?d0M0SnVwbjBuelhzTEJBdXJjaEdzMGNBMlI1bUQ2cXA3ZnozK0JIZkt1VHIr?=
 =?utf-8?B?TGtZOHJYQjNRb3hQWm9JYUl3TThVVUtOUWJxNnZrNGNzNmVwd2RVN01hTG1S?=
 =?utf-8?B?TDAvYmRSekpqMklVbmJNOUp2RWJZQThCZ3VBcHRWZE9yRmlCVHYwMWxTTmsy?=
 =?utf-8?B?U2ZKdmd5Zk9sQ3RTL0E3YU44NzFTMEhhTEROR2xFVmFTdG5OVXNZcFlUYTFw?=
 =?utf-8?B?ZUxzenNYRFhPamJyeDRuS2VvZkVDeWwzNEpUTmJ2UDRwcnlnUWFnMG8rbERs?=
 =?utf-8?B?ZkEzVDM2RWlaazNpVU5jZ1RUZ2tyNjMwSjJldHJ2MkY1cXRmek5YYW9vSGZv?=
 =?utf-8?B?WngwQ0g5VERYeTRQVmsrbUxQZ0hjclJVZHBhd0JMSVVkN1hiUzN4b0hRVVhN?=
 =?utf-8?B?R3lOWTVHdDRhYUpnbXN2N2hKbmFLbklrU0NOZjhqRmVzQWtDa0VNQWFWSTVN?=
 =?utf-8?B?UUhrd0U4Z1BJZlgwTktGeGpVZVlrWVdOcCtVN0hqWm12b1JHU3BHV1NpaGQw?=
 =?utf-8?B?bUVjemtMUWlnZHVCNDhGZFNhQ0o4UjZCVWQ5WExqRzUwbzFneFkxeUM4VFFx?=
 =?utf-8?B?UGFoTXE4cG1ENVpGOGVnVmZtMUtKc3ZCVndSalRBMVU4ck9MeXNidFNPNS9q?=
 =?utf-8?B?bFJzZ1Q5c3drWUR0VDZoOEZCNFk5VHhlSXdpbE9TMG1BWnlPcE11dWdNVkVx?=
 =?utf-8?B?QkpsTnhjVHdjUi8rem1qVzc0bHFkS0lQUEZyditobjZXSGRZcm95WHltR0w5?=
 =?utf-8?B?NXBhcENUV3lWT3VGdDF5RSs4Tkk3SHRCWStqMTJ1dUpIbVZ4UkQ0QlM0RVBJ?=
 =?utf-8?B?SFBONUpVZ1FvcEVyei91eWhWcnNrUFpKbGcvekpBV0NlMHRtcWt1ZVdyVEV5?=
 =?utf-8?B?dVdMRjNPWnkzMW0yVHYvMjgyY2g3eXhjazR6anBvNkVUeWV6MWs4V2lqbkt3?=
 =?utf-8?B?Snp6V2FidU50SlZqaWVIQm1tU2svN29lVXRFL2JCcEg0WUptdHl2RGloUERs?=
 =?utf-8?B?eUdmN1FzaTU5T0hLbkVtQTAxMkV2N2p2OW1OMVZoY1p6SU4wak1hMGV2YjZF?=
 =?utf-8?B?bHZHZ0hQNXlCR0NrYjR5THYxdm11Uk1EQnpER2Rob0RqQ0QxckJPaUlrYnh2?=
 =?utf-8?B?SzRrR0dmWDlaTGw4WFlENk4zWUEzMUdwc0ZZcWh6eUZaQ25QTFRLUElhclcw?=
 =?utf-8?B?Tjh2VS9VMWJTbDVBWmxlRGpGR0F6UXlxWHI1Q3I2NnVHNFFjNmRWZUtQWmdk?=
 =?utf-8?B?YURSUXF0NGp2TzQyWHhBMTFUMDRzK3YyR2o1dWwzNFRFVEVRQjF1NURYTDdp?=
 =?utf-8?B?WUpRenNNcElsMTFGTzAwWDZ5SWJ3dVROQnBuVStBc0w0UTdQQkVHOXBpRmxq?=
 =?utf-8?B?SDVXUGVLZ1UraTVwSUl5bGt5VGY5M2hIdUUzTmhJUSs4cDgraWd4TlFLSjJS?=
 =?utf-8?B?NVBDV0czQ0ZiZEkxUjVaT2krTEFCT2F6VWF3bmhqQ1hZdGEzaVF4dHZ5dktE?=
 =?utf-8?B?dEs0MDIxYXN4eHEzaGhjL2dBYkh0akoxOGtMR2pYT0cyNTk2bTl0MExsb1V1?=
 =?utf-8?B?UVJWUStmNjBOUFV3ZnpMQlA3SEtsWmcvOVRtc1paZHgzTHhlSnZQQUtNcXpT?=
 =?utf-8?B?UFZCcHdNcjc1b3B4YnUwbVFtcFF2NmRVTUZMZ3YwV0lNVUJJZ3pVRnRNQ1pW?=
 =?utf-8?B?bFZINE9aN3FJNjk2NVdBMFoySkMxcnBQQ3V2MDd1VVVEUFVwUkZrbWNINHFj?=
 =?utf-8?B?UWpqRUkwTHJ2eGgvd2RIb3p3cGRIVHd1WDV0dEZsQ3k0MVo4NlhWZHAxVHpX?=
 =?utf-8?B?ZGd4c0kzYkRheDVIbHppSGFGWVNmZW9QaFlhR2JoblJ4RllTR1ZudlczbVNs?=
 =?utf-8?B?TWppZmViMHh5U2VlRnVERGZaYjdmTzRGMWs1ZzN0RzN6U0ZLNjBUUS9OeXM5?=
 =?utf-8?B?M1VoL01neWNjU3JrUnNqVXpBSWRaa2dUaG9zdldINzl1dng1S1B6aUxlVkxp?=
 =?utf-8?B?WTYxaVNuMWZhY0xHUzd6aXNkRlI1Wndmb0YvNTRiVFRNL0NUb1VUWEFWcFZq?=
 =?utf-8?B?d25VNEcxaEZZTERGVTZpNUd2NlV3MitvelpvR2htNmpCcnhSRVZjQT09?=
X-Exchange-RoutingPolicyChecked:
	j/pkJIetNyto1TxqQIpEE23sUu78O2a70hmX1q8x2UHL+VDtvbef5H91qUuGiUlysSNMnTSPuoril4XLpURHVymgL4l7f4nPc8tGn61ISFaXsFCepZDIKjCn8eDC2Ym+QrFZBIGETqgKBnCzX+fYE6jxTaSaPWXlJGyBBnURY9AM8GrkxLlbzCo5k52rdADXz/Q8A9P47A/aNt8lBSFphBGo1JPgyXpNuwPN/uiY9fk+FG7wEMAc5Ku4zZ6YynwWZQVwvH1BhdbmfoP43AjIt4SxfRfI3es4EHUnq6ZathC/ap7IRHPg18mkFBytJoKvUHYEMZdbicW2PqnmSER0xw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i0N2wB2WQsL/6NBjeGCC2EwpCiQq2s2YYs9MSug7+E9vUp19Lds5yYyZyexUZeZILCqZrB2NLv5Ci7JpEiH44Gwt6L/afyOY3MgjWiDb8n6oNw+QjyUAHyMNLpFFp1sQ3CZSOLFENdFnaqFsBDsrQyc91Ew3z38M8qYyOdToji5vLTv7Q6ohpxMoyIvTZeYFxudKeGkv5xPVhLiZEkcthVy6Jo2oe+x8fDuMyQtb6mgYSyg5T5fKoZkAhq7jygrUXZCOCW4pXSiiWqUf8nk9gJ0SY149r4HgsvdcXlwoyfmkewzNFnieeWzgeQsJrEQKiycLmsypkn5XJf3Xnw5pyJXXo8SBdLi8i6TLiRys0hDk+t+MEvv1NV2F6qvtObcH59kTMYxGXBJMkbWuRQyz4jRSbx0cUNIRjrVtUhZK4Y23ojI/oV3FLsEE3GPKaog4XHXJ6WLIPVs54hDiWRaWmw7BGfTokibpZKJd9hnyhFvJHbVHE6Go2gTjaBYDdb/1Lc806g8yE3SKxwhpLL1mgQGfd/1mW6KwWnDTjh8ni0S9hHryAVJiU7LATDo/FbzWt/u3313yExRWh695uMeSx+Bw4ZkGWAZZDx/Job2kcZ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02896290-9143-43fc-3a7d-08dec56c84dc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 14:45:01.3430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlqEDyWaN0KGwlI9I26PbksAjBZdgyr6WCw+v4c5dPjCfirwZ2r45Gz8IV5k8x6DQL6y+Oz87uaS6JlZmzI1KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE0MCBTYWx0ZWRfX1mo2V7QRSJKi
 lUw2hFQJ5lxyaprBePOro8zZaFaaClzizjMfMbqGF8aW1XsSsjWRMMyWItqaUEEK/gKCKfklomc
 gsROyVEKoOC5gQxrPrMDkZBqxOhVLZyRTU0fj2N2G5zoQbeBjL2RaxtJNi/WFd33HmpG+CLjZh4
 FkniZPUd2rZ6Ikg99GOlpYP7QjffI6N1e96EqS+H9ae2oqRcyKTIuVO1ZBkuVX/wWWWv4JpGCo4
 lvj6ju3OxC6W7xmDdO0ljC3mV6Rk6sjXlNKegabx7t8jKtYPcpv1O5dJ8ppg/G6C67hypm1Xo66
 I9BjxPgC9z1No2yYnMNlWvsvv44FzGT1C+viPgOtsukDkRqdUNXa9tQWYO0R0EugGKJcfqL1sbn
 5uzL/8gwUJh2/xdySqBlNyTZenzLgjI6oy2n+sPQ92LIA97of4YICn1L6NR9hbepfTVAYf+CiXC
 olJ5d4FmapFmasp+Vtw==
X-Authority-Analysis: v=2.4 cv=ROSD2Yi+ c=1 sm=1 tr=0 ts=6a26d572 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=vBJafk9WNCWuRMAzGgkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0p7vl2SDRrAFXZWw8RiVQPmCgr1r6D23
X-Proofpoint-ORIG-GUID: 0p7vl2SDRrAFXZWw8RiVQPmCgr1r6D23

On 06/06/2026 02:54, Bryam Vargas wrote:
> core_scsi3_emulate_pro_register_and_move() maps the PERSISTENT RESERVE OUT
> parameter list with transport_kmap_data_sg() and parses the destination
> TransportID with target_parse_pr_out_transport_id(). For an iSCSI
> TransportID (FORMAT CODE 01b) iscsi_parse_pr_out_transport_id() returns
> iport_ptr as a raw pointer into that mapped buffer (the ISID following the
> ",i,0x" separator).
> 
> The function then unmaps the buffer with transport_kunmap_data_sg() before
> dereferencing iport_ptr in strcmp(), __core_scsi3_locate_pr_reg() and
> core_scsi3_alloc_registration() (the last reads 8 bytes via
> get_unaligned_be64() and copies the string with snprintf()). When the
> parameter list spans more than one page (PARAMETER LIST LENGTH > 4096),
> transport_kmap_data_sg() uses vmap() and transport_kunmap_data_sg() does
> vunmap(), so the kernel virtual address backing iport_ptr is torn down on
> all architectures and every subsequent dereference is a use-after-free of
> the unmapped region.
> 
> initiator_str does not have this problem because the parser strscpy()s it
> into a caller-owned buffer; iport_ptr is the only output left as a borrowed
> alias. core_scsi3_decode_spec_i_port() consumes the same alias safely
> because it unmaps only after all uses.
> 
> Copy the ISID into a caller-owned stack buffer while the mapping is still
> live and repoint iport_ptr at it, mirroring the existing initiator_str
> handling. strscpy_pad() NUL-terminates and zero-fills the tail so the fixed
> 8-byte get_unaligned_be64() read stays in-bounds and deterministic even for
> an ISID shorter than 8 bytes. The NULL (device-format / non-iSCSI) case is
> preserved by copying only when iport_ptr is non-NULL.
> 
> Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
> Everything below the --- is dropped by git am.
> 
> Class / impact: CWE-416 use-after-free (use-after-vunmap) in the LIO SCSI
> target. Triggerable by an authenticated iSCSI initiator that is a current
> Persistent Reservation registrant on the LUN: it sends PERSISTENT RESERVE
> OUT / REGISTER AND MOVE with an iSCSI (FORMAT CODE 01b) TransportID and a
> PARAMETER LIST LENGTH > 4096 so the parameter list spans >1 page and is
> mapped with vmap(). After transport_kunmap_data_sg() vunmap()s that region,
> the retained iport_ptr is dereferenced -> kernel read of an unmapped
> vmalloc address (oops / DoS; memory-safety corruption confirmed by KASAN).
> Primarily a remotely-reachable authenticated denial of service.
> 
> Affected: all maintained trees -- the bug predates the git history reachable
> here; it became a destructive dangling dereference with 4949314c7283 (v3.3,
> 2012), which introduced the multi-page vmap() path. Verified present at
> mainline v7.1-rc6 and stable v6.12.92.
> 
> Reproducer (authenticated iSCSI initiator, current PR reservation holder):
>    1. PERSISTENT RESERVE OUT / REGISTER a key from the iSCSI nexus.
>    2. PERSISTENT RESERVE OUT / REGISTER AND MOVE, FORMAT CODE 01b TransportID
>       (IQN + ",i,0x" + 12-char ISID), RELATIVE TARGET PORT IDENTIFIER of an
>       existing target port, with PARAMETER LIST LENGTH = 8192 (two pages ->
>       vmap()/vunmap()), the inner ADDITIONAL LENGTH set so tid_len + 24 ==
>       data_length, the remainder zero padding.
> 
> A/B verification (CONFIG_KASAN_VMALLOC=y, kasan.fault=report, x86-64,
> 6.12.90; reproduced with both a 64-bit and a 32-bit initiator):
>    - Without this patch (8192-byte, two-page request):
>        BUG: KASAN: vmalloc-out-of-bounds in strcmp+0xa7/0xb0
>          strcmp
>          core_scsi3_emulate_pro_register_and_move [target_core]
>          ? remove_vm_area
>          target_scsi3_emulate_pr_out [target_core]
>          __target_execute_cmd / iscsit_execute_cmd / iscsi_target_rx_thread
>        The buggy address belongs to a vmalloc virtual mapping
>        BUG: unable to handle page fault for address ... (PTE 0)
>    - Control (56/128-byte, single-page request): no report (kunmap is a
>      no-op on 64-bit !HIGHMEM, so the alias stays valid) -- confirming the
>      multi-page vmap()/vunmap() path is what makes iport_ptr dangle.
>    - With this patch (same 8192-byte request): no report, command completes.
> 
>   drivers/target/target_core_pr.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 11790f2c5d80..b102f5f67793 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3160,6 +3160,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>   	unsigned char *buf;
>   	unsigned char initiator_str[TRANSPORT_IQN_LEN];
>   	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
> +	char isid_buf[PR_REG_ISID_LEN] = { };
>   	u32 tid_len, tmp_tid_len;
>   	int new_reg = 0, type, scope, matching_iname;
>   	sense_reason_t ret;
> @@ -3293,6 +3294,22 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>   		goto out;
>   	}
> 
> +	/*
> +	 * For an iSCSI TransportID, iport_ptr aliases directly into the data
> +	 * buffer mapped above.  When that buffer spans more than one page it is
> +	 * a vmap() region that transport_kunmap_data_sg() is about to vunmap(),
> +	 * tearing down the kernel mapping and leaving iport_ptr dangling for
> +	 * every consumer below.  Copy the ISID into caller-owned storage now,
> +	 * while the mapping is still live.  strscpy_pad() NUL-terminates and
> +	 * zero-fills the tail so the later 8-byte get_unaligned_be64() read in
> +	 * __core_scsi3_do_alloc_registration() stays in-bounds and deterministic
> +	 * even for an ISID shorter than 8 bytes.
> +	 */
> +	if (iport_ptr) {
> +		strscpy_pad(isid_buf, iport_ptr, sizeof(isid_buf));
> +		iport_ptr = isid_buf;

It's not so nice to re-assign the pointer like this or have it even 
pointing at a local array.

Is it really messy for iscsi_parse_pr_out_transport_id() to do something 
like kstrdup and then the caller has the job of later free'ing it?

Thanks,
John

