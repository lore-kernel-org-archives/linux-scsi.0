Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DC33EF;
	Tue, 21 Apr 2026 07:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776757805; cv=fail; b=a/AFbvBh1L+j+8pGWf9Rs6cG0YyvxsHkm5XSXSl6uY/5XgCw8DseBUwxD7jnczPBVadvjtlm/FSXPYxW20OWOme7uhZ5RQ8H0dQcI2nU01XO7Zd8uf1WZNaTV07SWwHEhVZ0B3GeAYg61PR8M+rcSuGdjzJWMz7QlVCT7ekMwQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776757805; c=relaxed/simple;
	bh=O6XOb7wncdTbmcGEGGeDsPVIZOwjbPBZgk7gqYyZB28=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JSPCl1jrhT+Jv128BF1qVK0ghX4qr+3+EMh+IUD8SH9rteL37XKhsZA7lBEcs23fWBkl4iK/quo9gO7yiYfVxoxvQsFeP9W9lddZjFMFDNPQXPIPYtJ3HO+Nrb/7xtupRZeRaPFVI6P+cB6RiASxM+fRDtrgj/pBdFS///sfGb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mUloY3+q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uHPN1d64; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mUloY3+q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uHPN1d64"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLtm48089785;
	Tue, 21 Apr 2026 07:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NqeBb/XTUv58czRjehvvP5KR+XkQFZ/tB598FQQJokU=; b=
	mUloY3+q5N3suwFpEs4CZsyeS6iNnOylQ5RWhSq1fz3P3UKYVmpDbuUVPF/tx3zs
	nwa+aOhzxo3LfpjPZy51EviNiIp5tMPbpyu1tb1SKTuYaY9rHyPGLogi0q+ARq1U
	VJsh0QDLGvAirPi/BJmeq+X9hwL37XXU+muHSnwykAA/ac+02ML0XZHlx7vbFSDk
	T6xpR/fJe1RP+ULope1uKmecAt+NyqIfdngcrN0jjN5+Qogzhcvbi4mpWlMAbOkJ
	X06ZLCCyo5SttCSv0WSzIdQPaErkVGwBS74lgr8fXwaMy3sdZVa5nkk3zpybRCas
	zxElliM9ru2jSK/XadGSgg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2cew2ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 07:49:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L7kAxV002962;
	Tue, 21 Apr 2026 07:49:48 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1afqgfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 07:49:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEGhAVeqCNogAfQM2R0C3J9DNwbuHuXzSSa7Hp5L4IgUTkgfEFD0ytjPzuXsaIme79LUwHlfhGCIQcvp9NtEbY4YTFSyI4wxEKRLUCXHTZN/zxARVWTj+n3QCWDWi9hlKYTfwotb0pjOeGmzmxZei3qXfOaKIyOWI7USQBucngu8MzpqmSUA5774Pu1gitjQMLJ+v6WlsXK3TyDcTRfeFtXfnmQhRHY4ohjLBR83SkhB20Ph9NrIYBEdM5ZVo18yjQrS0+voSqrfuIRM/oC13fJcKyjrSwTpQt7J6QQdS2UpT4aCgDVugCBxqDJSXn7gG5VUox8apknYEiKzAtIQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqeBb/XTUv58czRjehvvP5KR+XkQFZ/tB598FQQJokU=;
 b=zM9CoBRVyaOE5fAat8p3HLaE8O3HL66TUmwKmhMw2IHmCavsskTxdYP8oQS03ivlCBxiy7LSy06HBg23647J2zUJjtMe5PTX3ddmRUdjvDSF/EpHHxa23IODkIU1rjH42L2FOBkNSNgA0FJZlXOdOvgyql9NFQtGPA03WTbc1aPSFf4Nl9kpyZAatOVvaeaU0oo7k8vCnXmaqDkABY5bkCW0M+GwK+0eO273bQv28HAS2xYmp47pXi9JWwDl5kjHCXKp4SRVI8kwqy1PGErCijfcdq5d4JutWrbB1XOoC++KLBg+OEkO9XhI2WRmxtWD3doaKET7wjSTQrJEKfdAnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqeBb/XTUv58czRjehvvP5KR+XkQFZ/tB598FQQJokU=;
 b=uHPN1d64rcW7hQl6xdf4LayjZcOOXQCSjiJdCwANko4d1zWjHnYxghbujQ3UpauIDfbN51wz8WgWyEO5Ct/0+9/+Q0PR1m/YhQfN9ignMHOzBiNbvi+ZiNn1/NjAnsrInvAM4HC+5VRf6VfLc+V9NJSux9npoc+G86SqCSZWqRU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BY5PR10MB4163.namprd10.prod.outlook.com
 (2603:10b6:a03:20f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 07:49:42 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Tue, 21 Apr 2026
 07:49:42 +0000
Message-ID: <e9c34e71-e5bf-40f3-9997-ee08c6204431@oracle.com>
Date: Tue, 21 Apr 2026 08:49:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>,
        =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
        Jordan Richards <jordanrichards@google.com>,
        Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
        "Lombardi, Maurizio" <mlombard@redhat.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260420152608.6244-1-djeffery@redhat.com>
 <20260420152608.6244-4-djeffery@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260420152608.6244-4-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0052.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BY5PR10MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: 00807e1d-05af-4499-8122-08de9f7a8c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rtFEqEavN5LkzuqjdeLBkRChlCgQK9/14SzoU6xxePQTR0wJgXLYBhNGr1PJpeXzRwLaJEU5dRdvlvwjCcf535y3w0OOVgHunmL9cZ6pBljcNF8YyaZHFPMvg7PAL6lDqIr5MlKW3WDjs9k+Mq+coX9JUFPMx1ldVTQbv6+1gvdWYd1csvS2sFNWCNFUE85VxJBvN7dK39aRnZUbHa+RrLQBv/AhopkhoLsFstDDkWjrl9OyMBU1vXcC9Z8bO7TV3+LdPum2Eshn0G5wvK9r/F8FK5YjG6u4zh87dmQjFK1462S+IwufVO9B1T/7wgpa4uJ5XkczFCUt/HcoyPUvcsr3viK+9vRqdIYtD9AD8Sg7PEoYSCARJlRq8y9FOKDKgMxyNeGJjtT/4GA2uoD+3L5xVuH8aZA1YptPIlsKepD0SsnBgO4YjQ+pmfrFmwSgifj/TpZqYe/cZMbGfsgdomnmdruc3oiuhmeLU2xI+pGWUi0mNfOhe+PFJgvGKo8r+oT5e6dI9hWBPtV761ojYs9+UzahLLD5X/XWFWpu41Er7LeQpYESZfw1NvVXT/bF00PUIFg31HU35itbAujwlEmBCUV0EHVeG4jwXKHE9inQg2j7GlN7jsvKwyAr4R/bwJ+DcPaDCI0CvnbPj9CmJ94qwuJ3oFvTouSxhLak4qKwwUSVdjJjfpsBGQAsAJIFeQNqrj2//yDmRfnluFLFM/VOXmH42FfvLML9aw1GRbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RURZOFZ3U1hLcGZEUWhCUGwzZzNDcFBscTBibEgycVQzbTIwc05lZWdOS21h?=
 =?utf-8?B?YnhoRys0dkxFYzQyZzZWSTI2dmFiczd0WEN2a2pibEpLU3VOZFNiNUwzM0Nq?=
 =?utf-8?B?cUU5WktnVk9zU2NzUzlrZ3MyS0hoS0xZNUFiVlRZcXlRVFZLVWdHam9wRThU?=
 =?utf-8?B?andKTUJXOGE0a2QwV0ZFV1Zhcko4a0VmZFcvOFNTT3BOOTN2RGR4MjJSSllm?=
 =?utf-8?B?aWpYaktwSnhPdHhnMmhUQktXTEp0NjFwNzlkUzVUQk1PSEl6MlMrODlmMStY?=
 =?utf-8?B?M1N6dk5IV3RHMlI4SXNzOVArMGNIV1h1WDRaeDFxcCtadWgwZ3dxbGgxZy9V?=
 =?utf-8?B?UjYxQ2o5VjY1d05HZWVPM0xSS21qU3NGaUNPUEJaKzB3UExyL3dUcmo3TURv?=
 =?utf-8?B?RzFEWTlaa0NxalFXOE9SczBFdzRYUHFzRVBmQ1JFQjRqQmhjWlE5bkF2WEpW?=
 =?utf-8?B?RmU0ZGs3L2RTS0wvMzNsT1Y4QTJvWTF0S1lsc0l5WFVwalo3QTR5RUgzSjIr?=
 =?utf-8?B?STNRVFZTWVc0ckxFdE9ubzFhajVCN1VETmh1bnNYN3dTK21raThSU2tHUEJQ?=
 =?utf-8?B?VFpWcXV1YmZJNDYwbzhqeDUrV0t4Qnh6NkFhUXUxaXdpMjB5VGh5VnJxQ2h3?=
 =?utf-8?B?S1d1WEJoU0VSUVJJZ3k2ZE9lMDlpSkowSjg1MkJWTUNSVFROOHFzUmdnWmdJ?=
 =?utf-8?B?cHUraGV5NStTY2JTSFc2UlcyTVBNNnM0N01aRXpWUGUrbFlmejZBWi9WajVu?=
 =?utf-8?B?YWkzWk04U29IQncrVE1Dd2NiTURRRWJiYlZUTnFvSDRCZ1ZJcHVTM2YwS2Uw?=
 =?utf-8?B?d1A1WGFBR0p3MmJVd0p0WEJVNlQ4TVgvb2hSSXpESzROaTZEcWJqc3dtaDRr?=
 =?utf-8?B?cW44MzZTRWN1L1lSZHFDY2ZPb1ZwQmptdis1SFphSVlOdmFyR2wrRUEydWZ4?=
 =?utf-8?B?aEFTUlMzcDRycUp5VWF6dlRGaXB3cXlhSmcvMDUvbnA4Rk1YUjAyTjhOL2Zu?=
 =?utf-8?B?UzZUN0FGcEwvVFB0YVlYWlFmaEZrL0Z1WDA0R1k0V1dIUG90eWEvRGRDdTdJ?=
 =?utf-8?B?bkw2b1RzMndkRnNFR1BZcWRrSEszU002TS9VTlpUMWsxcXJuQXVWVy9iRG9L?=
 =?utf-8?B?b0ZFdlpSK3IzWVRncFp1NU5ycFpWWG5WSE9WNGowaUltcVV6ejQyOEtpb0Rw?=
 =?utf-8?B?VHJzd013bEhWMStNWHV1RFN1OWJIeGlGQ1JRRkw0Y2hUcDlFREplYUJlOTQz?=
 =?utf-8?B?YU5oV1BudW4weVJ2b3NPa3EwWnZMWFArTGpzYVFZMHBCNUs1eEFxYlFFTWlp?=
 =?utf-8?B?eURmVTN1RE5vWW9oWjM5dzFuUzJ4ZlNIbmpxQzk4Tm90VUpwT3dwQjY2WG5t?=
 =?utf-8?B?UDJ1SlBDUG5ZMHBZcmxBdnBZV2dOaGpSVHFWZzR0K0NPQ2RFSUJBNWZpT2hW?=
 =?utf-8?B?YXpEaUNOU0NPdG5abDN3QUhJeUdML3RTVXd0d3ZVbTRLM0F6Tm1BWk1la0RL?=
 =?utf-8?B?NEJySGtMLzJ0TEZSOVFFSUtjNXJkK3piODlqSlFLZTVUaHo1bGRabWlvNlY0?=
 =?utf-8?B?QSs4MWlmczJzV3kyVCtEd1NHWlpuQVZHSmJKZkVXOGQ2QlRXTldvdE9FS3lt?=
 =?utf-8?B?eCt6NFFlWWpSMjlPVTlyYVRwUERoWUxwSit5U0tTUTZtMlBhdFBwYkhteU5a?=
 =?utf-8?B?MUYxZDZnTkZvQmdGQjkzWUxEdDhSejM5MXJOWmZnTVBQWTdlVjZSQWQyRXNP?=
 =?utf-8?B?SWJKWk5VT3krV0xwUlpMYzY2SHB4S2ZoeTlmUDZ6dm5IME9WOHF6T0NlQ3ls?=
 =?utf-8?B?cmZMSC9NSFh2TGVqRXA3MnJiNzJ2SnUvNlB1VFY5VTFOUjlva2JmdUFJd0x0?=
 =?utf-8?B?NE5NaitUU01zbCs0cDZhWGx3KzVubUFmbUFkV3pkQWVscXUvNkNRUlNSVWxL?=
 =?utf-8?B?bTRnTXJUUkJKVERlQ2NySERReDFLbFA2SExMUmZuQlNkUEpKRDN6M2NXZllt?=
 =?utf-8?B?NFZZZTJRTnlza1ArZGd6d0lxYVVEODIzOThNUXdwM0JGT1FCYkRZaExzRElV?=
 =?utf-8?B?SUdZZnRnZjJhc3UvYmorMDdrT1YvcTFkZjRGWC95bFdKUFZwMERjLy9zK2F3?=
 =?utf-8?B?QVk1U2FaWFJJTlJTMm9YTi9QTjJ3MTJ1WFZWSTlvUlFwcVJGbjJ6dWJyZ3pB?=
 =?utf-8?B?NjVCVmtyUG93WlVSTUVyNU9talBTMDZPdmlSV0Frd2tNRStHTGJucCtBUnRy?=
 =?utf-8?B?dE0wZkY5c1RPSWxFdDloU1BTVzJMMHNIR1FLcVVzYnI0RnJ5U3ArUFh0WVRx?=
 =?utf-8?B?dzRRbktaTGpXWlFiVXlWYmhGTkR5dVc1cUMwcm9UWG05S2JDWkc3UT09?=
X-Exchange-RoutingPolicyChecked:
	cTmYjmAZ/sWFemHRX4nzVRx+8utxPhxoNLqg+egywqEb29/qtRco1tYul6FX5II1lsrF2MeEp/oocgBsiaVPFIq7w9Co0c3vNvuj3fbit64kYpuGTtLgamsFQTOFq6UmIDjVf50kgD/mQEqsQHg17cz/DzswxWCMQDHm5DOKrKWGgjtfXfNUKdAuLXSL9rrFGfhJuuG1xVnTe892LY0ZzDCv/HmDaRrnTt7LZU0UWg8GmNCfCd31AnmURjDQWrG/+wLKpTpIHIeFv6Otxx8vVZK2KE3T6udRLphQTH1IUWfyI80b14M7+SAIlYLUuUhlmkbYuLiGRT/X24e/FYb6tQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	13FGEjn8fn1rMCkovYd1kX7McAkNS96H3dQPXgJWh0m8749WPdd6A+MoK2WkSwAmHpBl7d44RqLNibBkljtWPGxLtrY45I+XFiopDazDM9VBttNkHQnsh+q8Jnw+j9ZWPxAAkWT5s7NSbx4yiGb+/LwShkwc8iE0maRiLSaGJ1OZ/VOFyx1mt6KTWlbG2Z96Su9kMLUIWmL2Lfsq+ryETeOOlv+w9FKd5mXyBx67Wxl0jxbvCi4Ouxbed4I75GLBDCZjYQXTXVGiplnMNRCrnaxGxkC3FS1/v9JvgOgAdD+t4RVOe8Jr42we0gfUBnc4+2Ig715FPf/Zc0mmT3jNaH1ezvDWLUCpCkBH6TV6dU4pecGV3Fev9jMWqPPYYqRMkUS0tG1Md8Kyvyq/ZakOa/X0QRwxX1Ug/wZOhwM0fJ70WLBR61vB+MlPgBRZMaViFRPzt73mmt0/9ZF3wohyec+/ipNqKLhInVGdrH2zGNIbSUyOUmprekZ9QjDzd3hQju8rdHhD020AyYH0/IfC0+RMMC6h6xGcCPBx/nEw9dkn0/3pLvHOlzab8OLcipN4fWO2lp/rxmVzAYb97TNW9VimHOjHCPtFClyLyUdzZO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00807e1d-05af-4499-8122-08de9f7a8c66
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 07:49:42.6322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qF0Fs2D9yyOSA7PIUcuXWV+ij6sTHtEyicoH2MyaVMN8OLchli7sfZalpObk8V9hHbZUH4JMhpeOxXguY735w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210075
X-Authority-Analysis: v=2.4 cv=BaPoFLt2 c=1 sm=1 tr=0 ts=69e72c1d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=tWt2ZYBU24D6VKqBG1gA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rN6BPHYOYJW981-gqNR_CUlPEutAyZs1
X-Proofpoint-GUID: rN6BPHYOYJW981-gqNR_CUlPEutAyZs1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA3NSBTYWx0ZWRfX6JZXykrGLaxs
 1M1/6B5NbgNXAX/izIYofr1nQ0GIXnUP2KNKBK4aF2nUr8neR4dKeplvcrj3uG936Y/yPTO6vi9
 y0MnaKD2rGUQ6GfqQiik9/6Lh1IotEZIJ0fOSnGn8n7ajNNQJ9ryh7NdcS3S70JuseB1Qo3LS31
 zz0ZhNTfuUONQ58p+g9c/JJFx+35uyiRlVKC9P4RumsJ7JHoWvtdLW0pFsPXqB2dQEvkH0k7T4b
 mtZKOKtOeWrYK50bvOQDE6937hfgfFjTJJfnnWxaY35el3rh9JPtPCSNz6T4KeADxoT9FYeDYDw
 BwH4nGBcDSN2vqwJa2fQov1GYTYosJ6Vgmfx5CAqkrQA90it/aYnNHPrZHIcoxe2ykQL9YFq3QA
 8DZViuZQpHgALOp+sOSbDoF8OTsksgGH9iuybw/iawO7ljUrHK/GnAECTvtBdEA4pf/rpH0sYAD
 oujgqDuvczCXUk4MRWg==

On 20/04/2026 16:26, David Jeffery wrote:
> +static inline bool device_async_shutdown_enabled(struct device *dev)
> +{
> +	return !!dev->async_shutdown;
> +}

nit: async_shutdown is already a bool, so no need for !!. Furthermore, 
since this function returns a bool, that conversion is automatic.
