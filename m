Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54AD3C4559;
	Mon, 23 Mar 2026 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289265; cv=fail; b=uOuQutPHyxH02XyMfiPWLYo4vS7fBPpcKoJ399nap/bH66O7jheMnbakvTl/ihNGPHP//R7ew7y9AAExpB0jkBmrTDJnyK05Xp/XWwAyxqRs3Vjx+NNGQ6R+tQqiB+a1PTm2KQmmOUdFWk8juecaFUiZup3BzKEQTDpv3wUb/1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289265; c=relaxed/simple;
	bh=KK/V0s6JJhf/OIwrS3ViTAqH903zD5GVmA1fDfP5+Uw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F67uIR1lO6hVgxtPaza4EwXwsDPoRz1TMOIRvV4LE0b0EljR4fP7P7ZYjCP+A3YdJR32B2r7ovQm7AgZxToPlVSDH1tIOL2n68HWJiGfnKN0LZ9RQ63+2Q3tSia98pacOr/ITJzOXM20DJQABTi7e/qYi8cgcYPIiYvSROC203U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B/7wPQ9F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QBVLZYrc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B/7wPQ9F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QBVLZYrc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NHNgTT2137740;
	Mon, 23 Mar 2026 18:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8Tsgq6MKOOAzW3jvCtXknhClHQ+BAa7JVwLKuJJHK/4=; b=
	B/7wPQ9F0qOb9GX+82G4v8AevtkUUcOm73Bq3UKmRbJQPrRYT7kp15zpxPktrRwp
	FPBGvQ55b0S/WRzZMX5/NHQnTZxC/HXGQaaRGw6i/XWrPJexePH4544pSxFD6z4h
	mA0apQUPxPPD2S7j/GFlnilQpq/iWOQiQhNB5h8LRZh10Qm8JkOg6A0TDOg06kVY
	KyeXzeoMZ/nNw2dcFEtmilI2jSxsnyd3NfG2d9xjSLprF4J72YyA3BUMFA1A+hZU
	cUQ8IGWKk7MXfKjRt7pJpO4K3xTPLXSrkfEFmt/CwZVyhvq1b1xvhQEXcdlDlNDM
	HRgVRj+dTwFLOvuNOH+a8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kj2atnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 18:07:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NGYEZx012339;
	Mon, 23 Mar 2026 18:07:30 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hseup07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 18:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jNwDsuUaDYQKKWquxZP/eaMxzHsnqzYLBUhHekIMsfXlqG1qhwU7g6OZvqR5C9Wwo48zZUXidCaxXDiH9P8r8cUFG8/BkW35Y7geyvblk0U7GwWWK4b1gL4SSjus2GrsTAMjYlvDaC6ZrYxKLihJqCd4bUw8wSbhGAYPYBpbk3eZDUubNvLSKg3fKuRqIlGzA6AtSwOwq0YM2ARMWLIQ7fs52W0066UuwU3+bdSPxyfCGM0GLyRTJJjKjYe0MLbdk3q12fp9780dTkjaOuhSfSxwTGGOWo4PP8EzqbwrYm7+e/3uq0IDF6B6PYtyO9RUG5+O0Vu/q/NCQdtaT6lWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Tsgq6MKOOAzW3jvCtXknhClHQ+BAa7JVwLKuJJHK/4=;
 b=Gp3fhFIv0/VM63ar8OOnTVpG3aUGi8s8k0zhVSaRd1wK1p5zbK6heWHcx9RcO2cNpVCLmUSVxyA9sQxEvLyauPqi1MHZH8OidCoBdybTEOcsbcN/SZ4PKDPTHLlFTc+w9aTPH4Ih2oyD+t02l0RxC7eNYMrJi5EILSWiVhd7GsWsdGDmc3CE3kjovntJMm9GKGfem3LYMjA+x14Skapn/ksAo+SbgkqP9jIB4G9vUsAdsAyCKokZDsiTK5LfIZAq/a6NUSEXz2ZSebLEpuZQisjc3JDYhXKkTPCD9utbx96daMll+K7qDBJwhSEXvSTtPW4xhAfnseRAnkvqN6sJYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Tsgq6MKOOAzW3jvCtXknhClHQ+BAa7JVwLKuJJHK/4=;
 b=QBVLZYrcxAn9BgDAMJCtVcc/HH96MLdhK7xgNIvvBnw1UAD0rGqptz9waOvALgymWkMIATel8AM/3JR/gx2BNHdG8M95FBSMhlA2GHpt/dhROTBMtz/cW7HzBlxlzbqKiDpdOIVIqaqgtYtiSq2/s4p9ua26a8vpi8ln4mIym2s=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA3PR10MB8467.namprd10.prod.outlook.com
 (2603:10b6:208:582::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 18:07:25 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 18:07:25 +0000
Message-ID: <7d7b443e-212d-4573-aa31-608d9e505683@oracle.com>
Date: Mon, 23 Mar 2026 18:07:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] scsi: scsi_dh_alua: Delete alua_port_group
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-2-john.g.garry@oracle.com>
 <acCEmFgVgxr8qx39@redhat.com>
 <470edb84-1621-41e4-b172-91f9388a813b@oracle.com>
 <acFnDlO6b4SzFq90@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acFnDlO6b4SzFq90@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA3PR10MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad35466-9620-4a7f-cc9f-08de89070968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	uwR7ScoZ3vnxMa+Q6/C8uuyVaL/7eLUyd0UDpZ9RG4mVICuOj0Qbx18Yd8blNnEY0Mwsh/gp34YVCCL5J0Ke+LLRfNXDsh7umk9pe6OLbl2Vco9ucfh8RQz27ott3MXl8gSt1Oxb3afTtt5VwpArEZ8dXpxiJj2BqoryqSMta7Kv+hy8wG2fmNRxg2pO36KsZgHn+zSfBmX6G2CLtzK3dhvNmzSa6SjpBXBbk1ETYIOLW+6oaiBHwQWUQYZjf+V69bJz3nuUIOpFKdX/IXl6eki6Khu/XLlRafPiwJS+cRQ7UULU1qSTWhL2Y0hww0FQ1/WokZgSyJb09dmA+x5dxq1ZcbXIYuKm13++D7nXF61tH7JIFd4v6OoW/f74SEePYwZdTpWOHKiIz+v3C1luj3ktQNAHI1uv/tOxbmGTSsWL6aY+3uiY2Sb2DRDUa6MjLCKM7QuBtZ2ijiPyFwAjAlyrWOR9xks3NsUeBBO+tjZCYh8P/wEKnjgPZ1z/lf2szTU2QTS8u9RtHWerMSVC+dsARsrQtFBsiaqfrgLvOMND0yrVWS/DfvSVfTwEjxvyhg7CBhZP7haFjOsQQ04n8y401SZf1AUu4Iw2d3WuIG4JRZLGwA8fqYXaHFd7QTwcFrxd4cs+1IFxbb/pfCSp1csm7r5c7aKW5MYvIbuAWAAQVmGleAShfRG78acXiYKht2d11yi7IcrceVZXHgXIznuLOBSM4V9GOGQBa0ct4tY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Kzd6RGN0Y1pNY1lVMTUvMXpWTVFrMlBOa2luN2U4cGlJanhHN1dpaEZOVndu?=
 =?utf-8?B?TFZGcTZlaklDZU9icm5aV3FDTS9GMzlwRVZUMnVjUGJkT1M5eFRhMDdXbFBB?=
 =?utf-8?B?WW9MaDNFRXYwMS94OTdHdXRFZk4wUHJRSkI3T3NqdzBZRDkxTzRRbUhScytl?=
 =?utf-8?B?ZW9lcXBOempLSzNIWkYwMDhwanpzWWxianZjUUQraXlVRHI3alp5SzBvYkFi?=
 =?utf-8?B?SDJQS2tUYXZFdTUrQnpRN1hUNVlsRVB0VjRMaEt2QXJMclZiRzlpVUZ6V1Rq?=
 =?utf-8?B?VVB1dVlndUhYMU1CVnFZdFIvbGZEUkVmK3pOMU9Kc00xU0pXR1RSMENEQkw0?=
 =?utf-8?B?cVlSYUxWWWZhL2wwNTF0U2ZXNnh0U1gzN2xzS2F0OUwrRTB0czZ2ZThIVFcv?=
 =?utf-8?B?eDFhSlIvcDUwVkl1NGNHM09sLzVqNEFkbHUvUnJmblhmczMyazIxejNTYTlJ?=
 =?utf-8?B?bnVVb2pKU3lZeUg2MGxGT0RxYnlyKzcxNkhobGtJclFQcXNkc1hOMCtSSFN3?=
 =?utf-8?B?T1p2RUNCdGNUQ0phUjNHVkZGT2xjdjRJYlBkM0UydUpwTEZXNHRtWFVtZ253?=
 =?utf-8?B?YkxVdm1xS254azhMWHJLNndlVDJieXpieDQ3TTRIN2N5N3YyUUxkU1RTT3Nw?=
 =?utf-8?B?L3NWSitrQkxXN283OFpUaVg1aXRuaW96VzR4YVFIZC9RWGJWait6d3BRcnRu?=
 =?utf-8?B?REVoUXlQbnVMN2UxaGZxUHRwdk9VOU01U2VUL1J2NGRPNzZaTFlrSkJkdjhz?=
 =?utf-8?B?TSttd2UrVXM5bHZGcTJkSHdNTGplcU00TmgzZVU3TnFtbWxacGd6RlVDQ0gx?=
 =?utf-8?B?SkptMitYaEE0RTFva3daZnNCS2JvYjUrWCtreVhiMTZPbCtSeFlhKzUySjhB?=
 =?utf-8?B?UzdaeHEyaVJMOXRJTi9NTFNkUTBXZHQrTUpMN1FWdmZNbTYrK2sxNlZoM3ZG?=
 =?utf-8?B?a0tJaUhhNWJRL2ZETlNCSE0rZFRXc0YwMTJIV3FORGVMWVBPUmZBVDNqTlkv?=
 =?utf-8?B?SDRvSHRmemZ3RUJtYW01YU1tQzdTZU1uTk9wdTJKaTgzWXpNSDFFMjNWRXFG?=
 =?utf-8?B?UlUzOExHQUFxeXdyaDB0UHU4Y1dwZzBOU1YxSU9iaStkOHQyV0RKcnpGZTNL?=
 =?utf-8?B?SW1RMVd2YzhVaFRWMi93VG1zZUNMZlBkU2RxWVppbUIwc2ZNc1R6VWtRdU1q?=
 =?utf-8?B?c21qQkZGWWl6RU15QjcybVlqblFvNVNYRGM0eFRMUktJY2E4eUhNck5TeFN1?=
 =?utf-8?B?VWtOYVlTSEZnY1BObUw2MDFDck5oMCtpUVpubkZMeUNXZWxDcE04QVpoaFlQ?=
 =?utf-8?B?Z3IzSHI5V2NzbHFKUGtnTVFmYnZTclZINkNZYkRxZE9rbU9CWGVGV2t0YVVD?=
 =?utf-8?B?Nko1SmdiRitXTHZqUDlvZkF3dHRLdERHZmlvRHJVeGR0R2c2T0xSdnVEVGJF?=
 =?utf-8?B?SUFMa3ZtRXhUcGMwTXJFMXRJeUhSZVpZS0tDaGdPRzRDeVc5S0xpNGtqYUpr?=
 =?utf-8?B?cTJWV1BqSm44SHFHTzNYTloybEdSbldKN0RVTVZZY2ZaR0RXQnZhUjFvbXRi?=
 =?utf-8?B?cXB3YUVSQkdKQXJxSzJibkFBV1dDMTlKaEhqZU9mMU1HeXNVQkJkYXIvUjI3?=
 =?utf-8?B?M2RTa0tMc2NQbC9iYUJBOUw4anhHcVNuRnZhVlRIemlxdHVoaVdOMjZRRkl4?=
 =?utf-8?B?S3lmS0x2aHhIZk9mdE5UaVhka2xYRW5ZK0JzZDNlYUlwMVc0TjFkZUF4UHZS?=
 =?utf-8?B?U2c2VlJWc3ZYVHBDeU9aVVMrdjQ4UmpSdFVDYmxCY3FpK1JFRGFOMlVDczFY?=
 =?utf-8?B?d3JBc2xvMFBIQUNxUjAyUUR4NElEdCsyOTlVS1JSWUxrRjNtNEt0UDNhSklM?=
 =?utf-8?B?YXZhUVZLc24rSXBlTzRXYnlza21aNmNjemh3WFQwSWVkMmtlWWpzL21zaURM?=
 =?utf-8?B?VUtlZDNWVVM0c1RlbERKRDN4MEU1Vld6TlkyRTVoZkJLUTNFa3hWVXBwQTZ6?=
 =?utf-8?B?Ulcxd0Y5WG0zQ2U3OXJ1TlNsVE9TOWFaV3o3N1hZek40Qmk3cHBGejZUZUZR?=
 =?utf-8?B?UFo3djQrY3EwejdFR3ZNVm11TjdvbndpdkVwU0E4L29BdGtLWWpaMXFGZDky?=
 =?utf-8?B?d3BNV3Q0a21jTVVEalM0WlB5ZW9kNDMzTG5UWWtHeisySHBma2kwa1ZEVXFL?=
 =?utf-8?B?R0RHTWdKVEJJTFB0NjRXdUdFYWZJN2QvQTNJYTJSMXk0eUxkQ3Noa2FlRzFl?=
 =?utf-8?B?aEV2VmF3YS9qQ0R0Ritnb2IxendCNDZkYnJhaUdHUjY1YWlLT0FPODBoUlYr?=
 =?utf-8?B?WmhreHNscnlROFMxVWZXRWxwZ0NQekkvUUJqUkdkWXpCMDZMc3d6VXBrSjk2?=
 =?utf-8?Q?NG8yc4/ygeUAdEPI=3D?=
X-Exchange-RoutingPolicyChecked:
	HRgIH7SO/XCx67hku9WTLVGnGSSz/gwedCxaNizgo79GG5slAfHodo/sMHgI/72tW8ZXz/SE8rX4aEVyU6REIlw8Q+Ty2aHoxJ1sm4+3F7HanlTKpt07fDKLxbaArK/vH4+hc6ndJGLtm2HjUL4B7M1+a/Mh//7f0i4SGv7Bbu2LweNkzZRUzvaJcOczzY7a2vK3TaSoHSJpnXWhEyrwCHQ8bqobzzVdSRg0zRtr4sCr2BJmr6ngbalHqJ669KVAzTs7zL+6kzz/uw347sT8pWrW1M5h0eykPGXiyvovzW7wk10HPP5pqOYvrzdWritglOayLSQRbzJE2yBzUGu3mQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ov5Lid7t6Ud607SPCVyo6/yKydgP5gvxby/STRlLYnPDC8OEUr9WSnFxlVn9Kgekc5f2Qnebu+p06f9gLLBXQ/4DrvVkmeGkHyC1Li5lt6nYIwu/l5LwaIqZ1HuysniIJstA/hOBLeUO5rJPez0aMGL6SLee/dXbj26BEXDD4eZhoVw1xKrjpwkD7fQvHUaISTDipQ0Moe3llbFDnr4VtLmTV6UambHtbrNuhP6yCHWHMpYipEJIkADlkWFb1DX+QeWfKesYWNBMVdwcP8KWzoI8yf2PpENww4irPj0BczuB3NMOIZ9SPptCwwqwWN02nBbmO6zOm2nD4elK94kV4I41e+vAECuPidA5NudWjzZkjNYBzdveEbqanRhz8KJ5UdZ+NxDTzcNXyOiqPoEDamR3aRnuJqq5SNPa63pihmIxrbJP/84krRlDCI6RGQMPETLO6cIQcYEWkCFgI2IUfKubqw4eF7kW5hXkFE0C+VhJtH9Zx3Hf/nZwGAx+64M7YjYXo/O1PkzG6PNsJ6sxx4kqsmtEAC4e/7rnwpdzli602VrP8gKuzfbLgEhR9/9ZX0lfjTDhCmCzv7P3Vr8HKTCNmFWkde90nSIniyNvz9o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad35466-9620-4a7f-cc9f-08de89070968
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 18:07:25.1775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1obTgeamTttlHDAMemUBx1Mk5qQZknEPgWBirHoRYdyQzspzJnLasaZWJzhaK9jk0G+4tipWHbxH8K18+6Bc9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230133
X-Proofpoint-ORIG-GUID: CIv-tK-3RdTJFgb03_c0rAhl9e2RPXvk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEzMyBTYWx0ZWRfX0jaDSmfJOFWL
 crWh4PVHTUiPxFtwKAzxV/nFPlI2lBwek5oWfm3EfnatFeEv51My6yBqaA6hAI/QPEpFACrJbuo
 wUEEfNQMI09OfCj51X06jpWMki27T48FlFbD1hc7ir3bOPJmwRcKpC0LnUTWsL0EA3l1deItn2t
 DmAzLmEhck8p7lKuSDrv1c204T5ZcgNxUrYwNQcWLhkJ2bH1ZuxApIfmcRT4vsnb1ZLTHtN7OBg
 VP6FSQtbKj3Zv3ejrtXvYBVftoBL845+pNS7NocXkSkeCcfa5VRl478dYRc4o1wcg5s7s66YuT3
 k5fxJ3aUVCyA1DGa9K1ItQNZR2RRP6mjgbggn/icyv3MQCgQXbiST8IAyKU2RhjVPAbA1Bs1YGW
 ZjFEkX9swxkWHGXr1v7hL47go8CNOAwsgLMEkbMoTEMlJJkgEtoWzZHTUPOMhlssXsWCjXyYxaD
 PCpK7ki1X7VpFIT3OPz/InMpiXbGMVXjO6CMZ9B8=
X-Proofpoint-GUID: CIv-tK-3RdTJFgb03_c0rAhl9e2RPXvk
X-Authority-Analysis: v=2.4 cv=KtJAGGWN c=1 sm=1 tr=0 ts=69c18163 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=fKCGBpcpSMtpEBhqBEIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272

On 23/03/2026 16:15, Benjamin Marzinski wrote:
>>>>    		}
>>>> -		err = alua_rtpg(sdev, pg);
>>>> -		spin_lock_irqsave(&pg->lock, flags);
>>>> +		err = alua_rtpg(sdev);
>>>> +		spin_lock_irqsave(&h->lock, flags);
>>>> -		/* If RTPG failed on the current device, try using another */
>>>> -		if (err == SCSI_DH_RES_TEMP_UNAVAIL &&
>>>> -		    (prev_sdev = alua_rtpg_select_sdev(pg)))
>>>> -			err = SCSI_DH_IMM_RETRY;
>>> Previously, if the rtpg failed on a device, another device would be
>>> tried, and the unusable device's alua state would get updated, along
>>> with all the other device's states.
>> Where specifically are you referring to here please?
> The removed code above here calls alua_rtpg_select_sdev() to select a
> new device to retry the rtpg on, and returns with SCSI_DH_IMM_RETRY, to
> retrigger the rtpg on that device. If the rtpg completed on any device,
> it would update the state on all the devices. But if we are depending
> each device issuing its own rtp to update its state, what happens to
> the devices that can't complete the rtpg? I assume the correct answer is
> to give them some failed state.
>   

Yes, I am relying for each scsi device to issue the RTPG. If they cannot 
each run it, then they should indeed give failed state and be offlined.

Thanks,
John
