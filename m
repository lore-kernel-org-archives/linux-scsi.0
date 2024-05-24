Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF712E1CD;
	Fri, 24 May 2024 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716567266; cv=fail; b=NQAKAxogvTLf0uA78e2QdNnGPMyikd0MnjiOlFY/80x3hYB6n73hWAYSgrLQjVTdR/Dhbk1Q9MheOPCe2xGIpiX4FUCR4XcEB0Rn+WU8at4y8ccQkKs5B8gWIGl9nEv6yxzL3nCIPnPm5bGpFE1BYNO8xfRugK0V/87AOpehWOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716567266; c=relaxed/simple;
	bh=ZHdZCwn6JrwVGgRi3dKzZVkgnAnw2GqStBVZAHlSdFo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j4hL8nY/gakNYTLAlraxClix/pTzIv67diTTTIrFZpDt6mkMvoI0zDQUUwR4NERUoM+UOHWiKf04TgTARtJH9O0lmtUXN/jaT6/GgV8PM0dmgnOitECA0IvSe9dQAzJHDGwQEUNpy7e1RqOQhDf3X3IGfEkavu1Cnpz4gktwWoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kQf3IeWN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ebVMDZdJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kQf3IeWN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ebVMDZdJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44OFxK5t023611;
	Fri, 24 May 2024 16:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=2ulSJwlp1GFZL5zJwaMNqLMxnXFmsEKspc8LaC30Uw4=;
 b=kQf3IeWNsGd8F/Wc/t60Jsnd8lS6o3dY5Y2kI489qHh0i6IJpa2ESfc7R6jmHSuCNkQH
 0VfEM7Im0XRq/tx9k7wFZvfwbggWQwo0EnMgz0UvB4jXcneNvDF9DPCuq+7WXnmUgvwI
 5wgxZligsjuOiCPJO5BingIsXjjt4NzzyX4oDuZWnXJxWzDi9gSDqHjSJCm9rHnD9f33
 ad41+nIHw4TLZ16DuiQ/hrzj0usbV4tJNoZGYT62yOq4IXWA6Gu/GF34J/I4pWyxadgA
 /v1rJ7F944B/J95s/iYeS+Fnis6MgOfc+h2M3HrNPciJbf5xvxox+RAsIezKx7GRRrAs Ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2mqu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 16:14:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44OFHiXK036054;
	Fri, 24 May 2024 16:14:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsc1v43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 16:14:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MS6aC7igPetE6iqyKVDXkoiHzdEjcpC9Cs5ErlHqvKcgyy4y+mjHJu4SfDtJ4xWEgSjgXxZjiX3gHuUDWV/N2rOT3fz53fj+TsWfbPQksHojN71Wv6YMyjTw5bOYSWvelPQ7r6LpXltZ48dwybdxSpgG3XPHzam09PkmJt136DAjSBya7QsKEdlhPj0kS9NHRh7ZLe0M9uAn38uN9X9pgsvOAyA39v3IwL0oJkAXoQpw7Al+BwHKzga5Ybn2mdb1WGlmsHXHu0zjYSLI6JM3Kl1eJKGia6Qlfe3lcgHlda771Bj350OHjEaZBBuqhVWIMIaYTSd5dl28YaNQj46OfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ulSJwlp1GFZL5zJwaMNqLMxnXFmsEKspc8LaC30Uw4=;
 b=HPqlRbEwkXxEtv2JHyw1yMjeam9CpD5GSASAod19KYKknG4vJ3o4V2G0gXmSrNg2WIwphQIIx7REzab32uE80ESI9CXBQDyJgX1tr5gVL2y82WXAWS69S08/Y98N8/H8C/xFZbXAGM6gNS76BPRWaP6TDeWzmoPwGv6rb9RH28qyoMpGhVVh3VaZ0C6Vq/5HIktZPcpi52mXVR7jwGcmyBngzHmHNmywyp3gyKqVhKm+VqjBt2ArGpKpuMfALcjVv1gAHbJuNuUHV+7TlnmDZg57WL3bWaKbhnERYWTUQgZUfEf0Q/TbgY7UCnbcDnF+sLlOhCXPEaW1DvJ1pmmVKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ulSJwlp1GFZL5zJwaMNqLMxnXFmsEKspc8LaC30Uw4=;
 b=ebVMDZdJz1Sqp3jxl9VO1wgfhkNa1rfzQHliaY45pfLwr09NsHElLE85OpjC/JsJGbIXUh9UHye5XTClLjDARDnBH0lhK5z6XlrdW8f/LltpC2VlPNi8aGUwcXA/Cp7oj2jnvyPypSi5GPpFU6cbuC47D2s1hmxMdPYLHx3ueII=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB6400.namprd10.prod.outlook.com (2603:10b6:a03:44c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Fri, 24 May
 2024 16:14:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 16:14:08 +0000
Message-ID: <d28c71c6-6f39-40c7-9ded-c0bcd11f89fb@oracle.com>
Date: Fri, 24 May 2024 11:14:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] libiscsi: disallow binding an already-bound
 connection
To: Khazhismel Kumykov <khazhy@chromium.org>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
References: <20240523222128.786137-1-khazhy@google.com>
 <20240523222128.786137-2-khazhy@google.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240523222128.786137-2-khazhy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0216.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::11) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c4a04e-607a-4403-add6-08dc7c0c8a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?emJqZmpoOERmQXRyRW5uQzhBRE1zUVdLSlNHbkdlTFZtMUZWRU5SaFR3bDNU?=
 =?utf-8?B?b0JFZkVPWXNCK2Z1QnJmTG9sN1hjNkdUejdCVTUva3NrVThPdnlCRjJFMVh6?=
 =?utf-8?B?dWMxK1RreWlBenZIUzRjUHJvSTc5OENsWFlnS2VyVHJEdFh1U0xJbWV0M2xW?=
 =?utf-8?B?ampjOFZ3djNad3duYUd1S3M0OTFqNWR6YzU3T1VnU3VMNkQyYVRhcGVSazlo?=
 =?utf-8?B?ZzhLQXoySGppdXRSR2s5U1NZVC85RDZBazR0bms3MDZyaEl0cnhlVWpWb0lo?=
 =?utf-8?B?NjdXV0F3WUxhWU12NmNmRm1qNXY5SjhlSG4xY1QxcmRPSDNIZTdyT1VNTU9X?=
 =?utf-8?B?Q1c0MXBjb0txUnpXd205Umc1SDhjeXNrRUw4amNrV2dnSE52TXVXUnVKcElh?=
 =?utf-8?B?QUw1empCN2FkZVZTaFVJbFY2TTBscDBQZFV0VHVBUmZyVE1sMWw0eXNhN1B0?=
 =?utf-8?B?Qk9GSWxaMGpKV2krcThpRDY3L1FrMXNkSGVTemxveFhmU2VIa0hCZWVBVXBC?=
 =?utf-8?B?SXZMZ2FRb1pMSTlIUm0vdHhNNTQ4bW5MM0RMMXQyUEVtVFptK09kYjJnTURD?=
 =?utf-8?B?bC9MU1VFTi9kYTJUbTZmT05udkppUk9XbHI3QWtkWDBYcUlIZitBMXFTaDhn?=
 =?utf-8?B?bkU0S1YxaTNGZHZzaXo2M3ZscGs4OGNaTzIrNEtoLzBGWFQ2RVRXWmJhb0hS?=
 =?utf-8?B?ZmkyVXBHL3J2aFR6NzFaejFvTUxLNFlnR0xkWXVWNThRSlpSRmZvK09tbGpS?=
 =?utf-8?B?WXR3cEFwdVZCdjJRS0RXWm95UmxpYUExZ3RwNWhNNVR1akhKS1p0dTBGY01U?=
 =?utf-8?B?L0JudmFVV3k4UHN0SXRIVlhraytGTm92YjNjSStDSFJmcDdqMjlIWUNHeHdF?=
 =?utf-8?B?NkdZZGZlR3FrWVp5WWxINWNsYldFSW53Mlp1YkoyL0pma2tOVFJSVzNTVjNW?=
 =?utf-8?B?NXV5a0IzanVsVVRPb0RVN1k1UWdqbzJXR0ZNV0V5c24zVXMrbjg2bTFEOXRo?=
 =?utf-8?B?d3ZHY1FWK2FaMVZGVHk4ME16MDVYNFcxVHpjK20wYzFqSVlBMlpOR1daQnA1?=
 =?utf-8?B?eHhGZkFQd3BvbVc2RTFUamxsTzMwaVF3ZnNIcTVST2tpOFYycWU3WDlRZFls?=
 =?utf-8?B?aURUaFFKcUxuY2ZLcktDZ0Vobm9XSnI0c0c0cit0SDJ3RmNJQ3YrTE44UzA1?=
 =?utf-8?B?VDE0WHVZNEVXUGdhbWc4L2RaMXd4ZnlkSkFoN1cwTmpjYWo2VjNOdiszUkxl?=
 =?utf-8?B?eDZZSmJxTG1jeVhYL05UVlArQVdSYmUwY1BTRHIvZ1VpcVFPeHhJRUJ3dUZD?=
 =?utf-8?B?RmlhcklaNWEzek9NYnpxSFFtT0tEQ1JDZWlqTTRscXVZajkzM1Y1cDZpdmJs?=
 =?utf-8?B?V25LZG1iMUdmaXBGVmFiYURRSm9HK25pUEh4a3hETDJoRXRvS3MzZDlaZjVr?=
 =?utf-8?B?ZFJjcDZvbGc0Ujgybk5SVkQrQkYyb29rS2ExY3ZlYkFHRWVlaUdWM3lsTHFQ?=
 =?utf-8?B?SlEwbzFFSENicHpWQUdKS3BkR1hueE42elY4RXZuSkdWUzdQZTJ3Q1ZDdmhp?=
 =?utf-8?B?dmprazBVN3ZkYVZySHRDRVVZelVsNWRuZUZtWU4vdndCYk5GaWRWRGlocnl1?=
 =?utf-8?B?Ly9KYWFDY0NhdnN4SEtiaC9Wak4zUHFiWWhxSDV4b2xxbVR3ZWNtMEgvT2Iz?=
 =?utf-8?B?T2Q2VUpoRHdWNjgzM3dYNkZiQ284SlJiSUN0bG80eDhlTDFGTTBSN1pRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?djczUEJRNE5XdE8yR3d5SE13TDk4ZWF3SVJHdkpsZUIzSEJ4bElWb0d2SVJI?=
 =?utf-8?B?QUJvZm1La3MyZWkrVEdqZ0JwNmNZZGhYN1RSZGhrYmJXSVcrMDQ1ZnRUd2hr?=
 =?utf-8?B?Mk1pLzlQVVlVN0c1eUNHZHRQY29hc1huc0p0RG5abm5IWVErK2N3ZWZWSEt4?=
 =?utf-8?B?SmQ4UWlpNnd0djljTHF0U3FuOFN2ODVQTFl4M2VwTWYycXN3NEdvbnh6Umk3?=
 =?utf-8?B?N3FydEpqdjV2UFRJSHgyZjBFbHBtN1NLSUx6WTZZaE1KZm1Wa2xMV0VpWGd3?=
 =?utf-8?B?bnVHQnZ5N29vWTVVWG1KVmRIdHlOMi80dGJ1VlduYnZPcFIwaTFPZG50U3Bp?=
 =?utf-8?B?bWJweGZmOEt4V094WC9OMVUzOXp4a1JNMFBhaVlvRGFNN0dlTmF0L3htY1p4?=
 =?utf-8?B?N1gzNExkUkdlQ2dJc0RkTkJ3ZFl0Q1BVWDVINmZ2V1JHZVZpUmo5U043UVlP?=
 =?utf-8?B?VE10eG96VnNSaXdPT2tsYnBiSWFGUDRRT282b0JsRDhQc0JDLzhRL3RwaG50?=
 =?utf-8?B?KzVheVBMeEJndXE3bmdpcDJkK2FtY2QxYnR0YTVUanV3ZE1QWmpmUzhFZU5V?=
 =?utf-8?B?cDJNOTJvNzZIL1FCVWQ2ZzFuc2hiZTNXUElabDAxelExa3NOMGlUUUJRQ1N6?=
 =?utf-8?B?YTlWcll4ckp1MW9paTFHV1VuSW5BNjkwRTZBaTBqVTdBY0tTUUNISWxGcW9D?=
 =?utf-8?B?WGNiL1p0blNGUDFOblVTalVYOXFINkxTRUx2dGdHT2hwaUduSjkydVN3MWVt?=
 =?utf-8?B?OE1QZFNsM0RSNGhGbUZFdCtqUFg1M2NVUHVRVm82YmZlSnhVazY5bHEzSDNF?=
 =?utf-8?B?SlE1WjE1MFo4VmNzc29ncXc3a3NWWS9qeEhnOC95MWtzMVFPR0RYQk1UZGVp?=
 =?utf-8?B?MnFiVmxWVi80YzdyZEhEeTdYUFZkaGkzanIrUGhsTUYxZE4yL25aWTVRTUxG?=
 =?utf-8?B?dFZZYzg1NUZFdVl3QkRrcVVnN1VtUTF0TDZIaENaVlg0anZibkdWcWZhc0pC?=
 =?utf-8?B?TUROQTNJWFFiNHQ3YmFjU1BXSkp0OVR0NVphSjBIU0c5Z0VVdlJXVDFZUmFt?=
 =?utf-8?B?dldZK3VCSmlpMUpvUTNHTXNaSXRmM0xTWG8wMmpGV3Y4ZTJTY0hiODRIWkVP?=
 =?utf-8?B?NGJSWk9CMEhXSnM1MGxGeUZpb1hJOUxoaTlEaXNhb0xMNm9JYVZ6U09IWHFZ?=
 =?utf-8?B?VkZjOEllVmZWeHBNZWpLUVFvNzFUd21JM0I3ci96dXVTaVpLaG5vS0J0QkVh?=
 =?utf-8?B?MDJkUTdpWDZQMGI4dWZ0eHhFbkR5RTFzWEswVCsrelhDdDZSWFRxVmczdEdR?=
 =?utf-8?B?ellIa0dtVHhBaW1Oa01MaFRsMEJiUU8xK0VBdG9USC9kYVBGWGhkRmhJUy9h?=
 =?utf-8?B?b3k5RWRUd0FGM2VVcWMxMVV2Sk9aUzBPbCtCZFFGcUZOMEdxRHB4cUNPQXFv?=
 =?utf-8?B?TytwcmhmVzl1OXZ5SmsxUEUxUUtTV2pyaTE1NmowMkhrNHo4SklIbUdjYkFC?=
 =?utf-8?B?VEJKZjFsT1lEaVRDWTZJZjRYOHc3YmZoQUxNM05RNzNlall3WklVVW1XdTNX?=
 =?utf-8?B?WFlxMHNsR1VsSk9FRUlyQ0RScFBYUVNyaEljYlRKOURQMi81cEFUREdrYnV2?=
 =?utf-8?B?QmxtTlU0R1YrODE0WEFDdHpaR3FUc05KSVpxaGtkMzZnNncxbU9Eck5ndzBy?=
 =?utf-8?B?L3ZidUlEdi9iMFJ3ZTJVL2hXUmVWL011TEFsT0oxaXh0MjlhUm5pOTMzZGVD?=
 =?utf-8?B?Qk9VS2hHYmhIVHhNVXNUMUVsMFJBR0hScmFOamJ6YmRhdmRqYjROSzh2S09j?=
 =?utf-8?B?RmFnczJYaEpnR3gzcTdVQjlpTW0yd09LN04xYVc5MkJzT0g5eDFnNWZnRDV0?=
 =?utf-8?B?OVlkeFFOSWhYcUlpMU95clN5cFdyZFlrRnNqMTBjUkdyeVhnSVdMVHc4b2RT?=
 =?utf-8?B?aUpzS1Zzd1JTVDR6VnhibHY1SXBzQW1NUnErbDE4UERZdkl4NUI1WEJ1VkI2?=
 =?utf-8?B?NVpWYUliNVFpOFUrYmhZL0o5ZnZIUmpld2pyRjBjVzB3OG5uWGk4aUdXYm85?=
 =?utf-8?B?cS9udmw0NlVXZnpaMUorYVlvMmFTQnV3WGtQMndDemhIS0xmOUM4Ky9lcE43?=
 =?utf-8?B?S1NiV3U1ci9KZUdjQ3ZVWHBjNGwram8zbDlhODNPY0VXSFpDRWgwZFVyU1k2?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	R0fZjTuiSw2TmwCAEa8p9wKdN3firqRZebdpGtRb4kVlc5FxGzoMkSdVCA76KQq9dH4YPif5qqpDXO2DbQOeDPlEOadPCZE6SGPwvkkQi/dq8NhAzJ23/tn1hadsLVtHr1V36mmW0o/649dFrcZ7LuUVyAljRhekMNCpls9AW12yElB3Tn+Lp33G2JUTHp7ZzqBRHAslGGIOxqb/CvyFg6mFeyxIsKet4FaPVwIbrnFsgxATSPPS/HOH4eYLdZF4RTv+YjkAV5itvlbhvgFwcxtgEsS4K6VKhGDaP8YsT50If1tD9eooGcBHwrWdhoVyEX5sqMXhVDuTEcPF1IEv6lOswmYjpx1peCorFI1hxywo41bAIzz6auLWzqPZpRluKclV0MQ0hHG0VY2N7kIZykieUdaX2Kc281kxjQyhoh5RLkeXpaRIdudl+AmE3fN4os4pRi9R/oCk+ktDOAMMC36/zye1nE3BWn2eli+GPnsSO0TOCjPOoSV7gdNH+AGUNHfNOxlFkwMKCJYLjop241OVWA+8otoRigBOM0fZUXkHEZnMHVLfnjOllfSQFuSGu13FwHzLDm1Qzd1TWr6PqnFKlvwuNF8b25lYMScxZqM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c4a04e-607a-4403-add6-08dc7c0c8a9d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 16:14:08.8133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gP4y9riW2khLhwhDDAchiOjItcsv+xxAPDRsF03nRK54S0nsGnBwsrJW8pwLwCKci2dbytlzRGNty+WMUUjlTdk2SKSJo/JWz8nAH/jTaC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6400
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_04,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405240113
X-Proofpoint-GUID: ak9OaVYwnilBcICZdmdPa_hRxypRhQBq
X-Proofpoint-ORIG-GUID: ak9OaVYwnilBcICZdmdPa_hRxypRhQBq

On 5/23/24 5:21 PM, Khazhismel Kumykov wrote:
> This fixes issue where misbehaving userspace initiator could bind the
> same connection multiple times, which would leak the old connection
> socket without cleaning it up.
> 
> For iscsi_tcp, it calls iscsi_suspend_tx directly in stop_conn. Update
> this to iscsi_conn_unbind, which matches the lifecycle of other drivers,
> and clears the CONN_FLAG_BOUND.
> 
> Suggested-by: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 2 +-
>  drivers/scsi/libiscsi.c  | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index deb9252e02e6..1d93404515ae 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -696,7 +696,7 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
>  	wake_up_interruptible(sk_sleep(sock->sk));
>  
>  	/* stop xmit side */
> -	iscsi_suspend_tx(conn);
> +	iscsi_conn_unbind(cls_conn, true);
>  
>  	/* stop recv side and release socket */
>  	iscsi_sw_tcp_release_conn(conn);
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0fda8905eabd..0fb98eb53584 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3453,6 +3453,12 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  	struct iscsi_conn *conn = cls_conn->dd_data;
>  
>  	spin_lock_bh(&session->frwd_lock);
> +	if (test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags)) {
> +		spin_unlock_bh(&session->frwd_lock);
> +		return -EBUSY;
> +	}
> +

If some of the driver's bind_conn callout fails then it could leave the
ISCSI_CONN_FLAG_BOUND bit set, and this will fail on a retry.

It's ok to call iscsi_conn_bind at the end of the bind_conn callout
like how iscsi_tcp and cxgbi* do. So for iscsi_iser.c, be_iscsi.c,
bnx2i_iscsi.c, and qedi_iscsi.c you need to move their iscsi_conn_bind
to the end of their bind_conn callout.

You could also keep the the existing flow but add unwind/goto error
handling to those drivers, but I think just moving the iscsi_conn_bind
call to the end of the function is easier and it syncs all the drivers
behavior which is nice. 
