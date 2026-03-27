Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01E377ECE;
	Fri, 27 Mar 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632099; cv=fail; b=mZx2pVdmTXyOV5EZ42PO2mJk05yAN8WlYN5hrg81yfk71M64eA7LVRxJpFeN0AQDNaYxMQrgsZ20vQW5N2mwF7M0hmaOwlsswNfELt8DuzNmLpkMyaqqomygLk9/uRVXIGY7LJb6+8eG14MYDFc3op+t/XPSzVz2HOkGh+83xwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632099; c=relaxed/simple;
	bh=dX5X7B7s7k9aPrXD/fwZkWR+Zaufg/gH6QATfScccHc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tRjSXqVFs9GMxVfRseFe8woLk4jlTxSGawLqvTAK7qHn/073pC7BTT0mvp+6D3pZjq05RwvKCVI/QY5gRYyT7Z+O/iXv9G4pVl9IoVMP95//bCT6DmwfEw/B1t1T/K22EXIyKpHc6ntTKYoeCBqXoCbMkLtmiCqd1LqE2KrwGIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OUxFSufd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JZsNiNpx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OUxFSufd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JZsNiNpx"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGuCie833679;
	Fri, 27 Mar 2026 17:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cW/+xH1OgdRUBujV0M3P9pJxVf2BofZSv6Jey34UCVc=; b=
	OUxFSufd1G+V11jXP8aT8/BeVMeVZov0YZLTtC43X8nqo0zpQaXehHzmYQj21zin
	uQr9Z4Y1jfPtN8Uy4q/hcQKo9N9BxjkGex91S54Dz6hxLfEYseB6kpdMPRgczPYk
	FjCxxTlqODYoNEwdPxNwb1cDQ6aQZxRw2Yg/Fq6nRF575BOtSC3dsNyji5H67wOQ
	X9UlDel1EmFufZ0Q98qlLOZTVdDMG+PuMudXRpVolbGxnPtaOWyh2fekemjxyF38
	2n9TLvyiofnggBTW8a46EkUr0caw/4H61110bpa8cUxO2yBot4D8dHel9bR1z4Hq
	irLvYcX1QS/lJrNL99dquw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfptcnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 17:21:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RH6TW3028873;
	Fri, 27 Mar 2026 17:21:24 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsepk1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 17:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlOtDlMxAyuKAUQ6jAjpfhwb68hXnQJ4WOECWqUA3o+7IBuDX1AcdDUVcE0i1nUhdeATD+9kiUO+ZQFwA73hQHqjzl79nZK2eq3gsmgy14foSBjlkbLZyqetg7/YBDkEXZWFgYQRxa835cRxoA2fg46KHanOU6wp7syVVgk/fsFgdNacS3NjclWnXy2upK5B7V90GCGhfz2BmkHKXpBPNZqLqMMx+WkvjomjOd22IqInQ9LGA1KkH4RBj1x7UIPGnhxWTpzwT7Ksyf3pK1oWST2rikSWoMSJeRRrvwKV/6YkSm1aXZ/D8OGTW/VZP8uYdzQjhuS+MTUzYYwon6TKlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cW/+xH1OgdRUBujV0M3P9pJxVf2BofZSv6Jey34UCVc=;
 b=ha++INv6Lee26otQKoa1NU/jiBmyzPaVUzdYwKgcGnJGL/SbBQi3yuWfJD9DENIiItxANFZLvjhlU/YVw8byenWXrZUlQi9S4vSG4bZ8BRZSrg62u+HZNlgwYv9OOP0aoDa2raoZuL57DY0p6d/bJ6pvtbufveEy/C6oC+GJBn1qRJaZvV56kFIXK3I1EzbzBw6GgENPwre1c0w+JDws9StZezcnPm+sIevRsNqoyq0azH8S7qgwQa0bSC6YwHIZH/xIhNjOAf39O1xig0LlHWXCg+uveRodwhiZ0JJFodsU2/jJNBkC/lFRvuUaigYDYrX5Cg3ueajKhYF81QW1LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW/+xH1OgdRUBujV0M3P9pJxVf2BofZSv6Jey34UCVc=;
 b=JZsNiNpx631RhcFmEeCs3/WP7XYRR6ybtXoG+QTNwCj9gPiwIz7MKH/dbez4yMqqRqVxI2kjsA92yfY/O15Q7IicL8C5TaVEcbDZW9VLIBvHFQ2IJpZ3R0co7cEiJZqzxTblHWjx5C/UpvxJmxpOPDHaPY9DiFlp9BPqC2m7uIs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA3PR10MB6950.namprd10.prod.outlook.com
 (2603:10b6:806:31d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Fri, 27 Mar
 2026 17:21:20 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 17:21:20 +0000
Message-ID: <6b009c4b-39cb-40e8-a8f6-03cd6c9f922f@oracle.com>
Date: Fri, 27 Mar 2026 17:21:17 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: fix missing put_disk() in sd_probe() error
 path
To: Yang Xiuwei <yangxiuwei@kylinos.cn>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
References: <20260320015817.4080359-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260320015817.4080359-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0246.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 034b7081-b67b-4cd5-645d-08de8c254307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3CJkPxsqPpoiVF+ND2y0uAGgLYrxsVao3CcqGAPNHbsWQ70oM/Zu54kJhQkg/dbjGUp8ZqLLx8aqEn5X31i3b2iGXUxeFoTbcazd2JzS/cngsy4dF2kDE9dwo6QJxSN0RGzBP5On3FpFvGhXts3xu9Cz9NQzGhSCRTMLAgQSMiljzhE9v0D0QPrVSLXh1WfP5/J9LvCbFhNO22w4o6onsB+1mZMi7dJh5GikDQq6kC5S8diLeLlrcV6L1LDI3hbuEIw/0WC9Ls5Cy70LHFfoe+OpCou5bKZwNl/GWp2o1ckwes2prt/3rjJ9Ls5+MF5hMO/mhKSbCgevIxp1qpA7Enm7kNx4dS0toKx+XJw78zJlhxoc0zFYXYvEUTjxlC9j1zjimSIJZ3dJXw9xREMyxTqM7kOUhtJo4j5qxXTTcV/VyKqIgKEEmapbhh622jTd+oiT69WsG7PWOIQYwceMibdeDQn+CHpecjgdBl+Oge9/wWBps5jvXNpf3NHhpkyXexk03Bf+a4D8d0QyE2ScQagZ5klMISjTt7Vvey2u9cK+kDb+9V3qnJhhSpmBETR7FGhBv/P/an0Oxl4Rz9L7gEY+x2TIT4hLWJGo+2XxteQJoNiyvAnEhSfPFkMI4ct7o39xecJkYmQejY3mQvXb6GwmionH4StpTMHkvKy/wZkQCHR7EMfiNWuHPWoXECWLYpobW/x5kwCu/yjrxNuvUYIr3zWcGroJUS9VwPFW8Zo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjZzd1V1U3NnVDB4MGg3VVh1ZFJVb0Y4WFRtNk5weEQxanhZRlpCZCtpUExs?=
 =?utf-8?B?ZERTdmdoZVcvdnZHMGExRTlyc1Zoc0pDTjMzd3Q1NGF2WHVuSzNQa2tMTDJm?=
 =?utf-8?B?UG5hRmhOWktNaWREUFdrL2FUOHQ1dkhCNk44MVJsNW0vTW4wSHJ6bnhWVlV0?=
 =?utf-8?B?R1JBMTJxRFduY0lrTjhXbTRiWXlDbnRJanIwQWZ5dG5mK1JqY2JLUG5YbmhJ?=
 =?utf-8?B?QjVlNnJXZDNOTFVTcTRhd2xXdzM0bDkvMzJNc2gxMjMxM3ZvekFsUTV1UmlL?=
 =?utf-8?B?UEFCSTIwbTh2ZHo2dDJ5RFNxUWRrc0pwcldYdFhBRkJWMk4rbllWa3A1eHM1?=
 =?utf-8?B?cDFYSUYyVmsyanFVZXE3RkNWMnRDMDNkMHh1TFQ5V0ZuRnpYc2hQajRiRjh6?=
 =?utf-8?B?L3ZDVDM4TGlYOVJjTkF2VTBRNG1xT2I2OWZNQXFRWTFoQWhla1lHcWoyRmd5?=
 =?utf-8?B?eUxjNy9uZlM1bSs5MEgzZ200SGtiU0xmMWY1VW5iSUlKMUliM2VJeWQ1a0sv?=
 =?utf-8?B?UHpON0NYT0dyd1RSNDVzMmF3T0JwbG9KVlpKRXFpcDhaYVlmdTNJY3VEQ05M?=
 =?utf-8?B?WCtBV3E2SEZsZjVEWGFEUUpFNkdBcmhURHNzQStubEJNaWg5V0V5eW0wNnJr?=
 =?utf-8?B?Nm1lMEJORHkwLzJNVmxVaXl5NXd0Y1cyZzVUZmpZR1NvWUhGSDEyZUdvRUUw?=
 =?utf-8?B?TE1qZk9EanN5ZEl0WlY2NWs3c29kUU9obDA5Yi83Zm96Zk1Eb1FJSTlrZi8z?=
 =?utf-8?B?OStJRSsvdXYzbTZuSmdiSzNTSGx2eGFLUTMxVS90aHhQcFNRdEJXSFV4cmdn?=
 =?utf-8?B?Y3plYlVHWUE1cjVVRUVTZW1GWTYrVUNzN3JIWlBYZXJiS1krbG1RRmJFVm5y?=
 =?utf-8?B?aDQ4ajhpbXpnZWc2Y0hWUGYvR1ROL0V2dDNnWDFnQm9nZFVVNDdZTDBmVUJG?=
 =?utf-8?B?VWxlQllpUW9JU0syOHhNc1NMbjdqdWZKVlhFRUpvbW5YWllSUWFSYmc0UnNj?=
 =?utf-8?B?V2pmWWYwOXp5d3ZBTVR3YVJOamZ4aUFPYS9sWmx6Nm16QUhRaFZ5WVh6a3ds?=
 =?utf-8?B?SmRPOHZyTVdQcGZvWkZoZW1xSmI5MGduUUpDSmVrTXZldVBqWEpqTCt5V2xn?=
 =?utf-8?B?b2hxazlHUXVaUU5kVXpmbHhmM256c01sMXJWbGE4dXNyb3piejVuUk5GR0J6?=
 =?utf-8?B?RzIyYk0wdTBVSGt3amFzV3dqWUdXNlRpQnhqV2U0MHFIRU5lM3pTNHB2SUdk?=
 =?utf-8?B?MCtTcmd2Z1M3YnVWRlVJTmxVT1FBZGh0MmdpR3prVlhrUWFCcmt1WnlKcTl3?=
 =?utf-8?B?ckpEbTdiQ3U2anFiWHN2U3pyS1FFOGpiNG5SOGFCTGIrSWJURTFoMmc3cUtC?=
 =?utf-8?B?cXpYeG90REE0NVZGcXY1a0JDdmdXcjVwbzBUSVI1cXhLdWxEWGhhRGV6NFhu?=
 =?utf-8?B?cWJ0T1k3ZVFZbDVBWDRSUFErOVRLYjBXNjZzclB4Umhsb3pycE1uaHRXVWdS?=
 =?utf-8?B?UWNZOWV1SHZCeWdFK0FUaDRnRlFNb3o4RDhjdTBCblB6RWVXQk1jY1I3UGRU?=
 =?utf-8?B?bXdXSjNaRldSZ3RUTDhtNVlOcnMrNkFLd255RmF6MHdzYWkyNTk5VzJhbXdI?=
 =?utf-8?B?Z0xvejhMZ1d2OEx2bDBmKy9ZM1I2UUJvSngzbDZ1UUgvYkU0dGxvN0xQR2h3?=
 =?utf-8?B?dXJBeUJWdGp5MFRJTHRpbTJURVBnUm00UkNRUm5kWHNxbzB3Q084WS8vNUpv?=
 =?utf-8?B?b3c4SDBFRjkxWE5YZGZxVko4Wk56U0dEbmxLZ2ZlZjBKK2pHWWhYMUdTeWFI?=
 =?utf-8?B?ejdUeGlFekdoekFqRGtWd3RiVE44NXFXZGhFMmZWMTFaa210V2dicDdSZ016?=
 =?utf-8?B?a3NXNDM1UlAwVGlWb3VDWGFZRGNpd0QvSnF4alVsY3hwNzkxYlF2aG1zOGhD?=
 =?utf-8?B?L2hkUTRBNm5ZSkhDTkRiZDl5YmJjWTV6cmlCcFpWUkc2MWRkVXpkZmN5N1ho?=
 =?utf-8?B?UjRjYzRVOGZqcDcwZW5zNDl4anJ0WXUyV0dEd2pNbFV1aDZpcVZUYTdycFNy?=
 =?utf-8?B?QlRqL1huamtKRE8wM0RYdDZSODRXOUZSdHF1eHRZalEyeGVwVWR1YVBXR05C?=
 =?utf-8?B?aiszZmFDWk5jeGhkZzVPV0VSUTA4VlRFRW1TM2c2RmhNcDN4QXFvTkQ3YnZu?=
 =?utf-8?B?VGx6TWdQVld5aFNtUDlpWW9KN0dsTGk5VGJlcGxmUm94TEJ1b2lVZHZ4aVNM?=
 =?utf-8?B?SGMrTzlaemt3V1RFWStmNWJTS3oreW5ZNnZmbU9hZGFvUi8rdllZOGNVcVhV?=
 =?utf-8?B?THJnSGhMQmdyb2JMWllOWUVDeGsrM2UwMFFzOGJNbnJQdFUxVjJ0UT09?=
X-Exchange-RoutingPolicyChecked:
	VKTqbEU2dD3hegW2BkU9Ibs0WVA8Ik49vXA1x4YXxVhC4RaDfNX1PeyYJ6+tjl9N0EjpaRt+DtKBqDfrgwJffTDApmulMD0LcrzCaRrx7AtU9ZuNeFcA8Yu0Bho8tYi7QpWmMkk2DCk5k2aYlgVU0SN5UrjNKgpo+HOPcqxZab2PyJ/KFYxYliX8sPWAC2V39f5Yqz6nScaumop6tmcCbUUL04QkXFlYY+arH6unO/AQnSgP/i7JnFPykyDnV5mDXgb20iwuzKhM3zsLT3dGfQysOJg+HJgvf/cXctGl2eC0OUli9fekdZLt7gFnZrm9GT2TPwynNj4OLnUr6DXP9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JmbIr/9s72he13ip13CnGnmZBgp6Zild0NT2jV76yOUko5BR5EEHkVen3ogf9pivTu+O+hkA6srI6uZVwElLh6KH81IGhz8aJ3JcuWouMGvrwUZKOoA1JYWqjdy3B4NbCURW+Fzb+juOrRzkwGqYRP9QaMvayD4gQdxfwkZtnMf/bUglYFa2OyHgNz2RaHt8SCXSQPfeppH2HUY/S1WLDKBJrkTZiCQ58vcVrRuE51rBUFzAdfJhbPNvTMS7Dsb53cykaFBpkxG50pv7uUhTC7WElmMbKj35sImMy87UF9thuHbxAa08A4rhGb2+fo16NJFVW5/UgmSot3gyuL6IxH/GYOqO0Q3o5t2g3tWmnYEWx+9SS47LnNTS4sS9r2hIalR7k/xc8P0cuc0Eke/A6kTSyVBs1QGaHGRF4Z/lFft93jWbB3Ao2i1yOU792k3NYTlaEtnlDkp2jWMHshb6IVag9EXCfqfGuKWa1GbZsy8rGAHn+maWPLoCW0cKdcPTqd+mXUoE6KLB00/h+7r2jdHoGX35Df1548Ze30YythfJK4/dv4gVD0ZMSURQPOpIPmPkj9UAeg1KhhKhtZDYcQ9+2vpwilduOZ3+0gOEyDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034b7081-b67b-4cd5-645d-08de8c254307
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 17:21:20.2187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QR+xT9e+cc0w6s8/J8G7CTJLZT+Y+d3WSW0i9ImI7Ys6aUU/12+35tqwhP3Euxl+efAfFSQMr1fVSBLtCDVPIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270120
X-Proofpoint-GUID: 0Rbrp5VFWRNQ0-rQdoUDbQwj5WW2fyc6
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c6bc95 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=4pv-yrbR1MMxuXTRHQQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0Rbrp5VFWRNQ0-rQdoUDbQwj5WW2fyc6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDEyMCBTYWx0ZWRfX5w6L5wIikEQA
 malU9sfIX8PQaQ3Q7fptbBbVTzt4KXfICA5rTsaSZVpSZvXdp9A6faiQ8gxseTR1ps5MOQ55xfu
 OiOKOhAvr80ruKpbGcpY8h6rLAR+lXTedWrXDnHBVW4whGXZKQy8a4tW7WFNp4hDtRE7txJmAMl
 XxRZlaSUrnKOSQRdNbd7B4668T7gN/OIbdEOQOcBGgJOPGi/9jxNIRvbOkJfnJEfZbgwi6Rlu41
 MSPbO/ciFBi2RH6e/o0JbTSkzYiGrg5ttVsOMRnEiTktejseCOoVSZeL9ijxCaoFoHSMRn42XDs
 EWWpKoSUyARVPIcy0vQJB0bP87LybbkdTa12t0jNJNDanU75wvmeJe5Z2/G/K8s2mioic/Z7cBM
 fg0qk55hjYkYKFJfPC/ZUsH57aGizMzjt4lBpaTz92cLNunRFh3IWCx2dkeNhcYKJEe3EPJuTnV
 vq6jh7Dl3OGTd8OMqBg==

On 20/03/2026 01:58, Yang Xiuwei wrote:
> Call put_disk(gd) when device_add(&sdkp->disk_dev) fails in sd_probe()
> to keep error-path cleanup balanced.
> 
> The issue was found while studying the code.

Please don't add such a comment

> 
> Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
 > Cc: stable@vger.kernel.org> Signed-off-by: Yang Xiuwei 
<yangxiuwei@kylinos.cn>

This looks correct to me:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> v2: Update commit message (add Fixes, Cc stable, and how the issue was found).
> 
>   drivers/scsi/sd.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 628a1d0a74ba..aba22060fcd5 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4018,6 +4018,7 @@ static int sd_probe(struct scsi_device *sdp)
>   	error = device_add(&sdkp->disk_dev);
>   	if (error) {
>   		put_device(&sdkp->disk_dev);

this causes scsi_disk_release() to be called, but that does not put the 
gd - that is normally called in sd_remove(), but that would not be 
called in that case as sd_probe() failed.

> +		put_disk(gd);
>   		goto out;
>   	}
>   

