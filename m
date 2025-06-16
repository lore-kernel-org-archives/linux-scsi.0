Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512228982B;
	Mon, 16 Jun 2025 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750098306; cv=fail; b=DDZfSu2mdcjvooBdbC4wxMadKC3hJ/NdubgEJAmvFJJMkASTC4UWNtLX1WTJ5hLR5LmB8szFduSb18Ppj3gqHQTqh4783yID31hCRBRfN8W0hKN7oHDZde9Xbxzx2o3HFPX4LAQG4tLvYnvYGIUzzH+Df5BBLredY+Se9C9R1M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750098306; c=relaxed/simple;
	bh=wJHD1qKm3ZowqhqhgTmdg2itsNH75U2UuukEkZjENBk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qzMGlHBn/2wLsgoM/F1woV/qtNmFQ8MEGrxU4uYqsyWIfiMbA2TXjckPUZqp/gOrLHONDF688N88k4wOHmjYNwD1KrQzCKJ3odUXhVLwKujkH7yy2X8Ivr8Dp0/CT2zdsMxFB70SHo9LCS6UneSXtgLN6NZO3rMwzfN50WGG1uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SSQQsw7B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vqHm2Wqh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SSQQsw7B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vqHm2Wqh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuWf8006564;
	Mon, 16 Jun 2025 18:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Mh7lF2YSGm0RJhI5RQE8W/icDc5sHz3xrYrHQe30Rok=; b=
	SSQQsw7B5sedDDHrwyDoSd5C7Q++uhgCGG3//MUS78l2bU0DYvc84bS5tGH2xXIh
	VjVyKlLXzbizOjZH6921uv32W5IA44CD1YeDbovK5VfQz+IiEAJQNGsZnvr9NnSC
	F6+XN0VNhkgKdhUTgv11AkaWzjOg5t8sG0B9WxR4ZDe4ZAOmHhh2TFmV2gwWQjcS
	vanQxjxX1bhcbL6KrBZTElcIfxwZSUj8Jb0NmIUfdoIjCWfuOsSR/yAAOh7iAZb9
	+IFvxlURacq2D+xfrl6/LAigmdxxfTf+TD5ukxzh9tzeVO4Lv7fVW9rb0U8eIRC7
	3xcFzYgJqcUIxZb9IRJ/kg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900eug6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 18:25:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHfvTn035170;
	Mon, 16 Jun 2025 18:24:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh81f4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 18:24:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HH0WNeTBk+98zaIZnRPtzt0rbVRtwORpNzCenttqltL52hPl9qFY4kM3OoVbgOCjlHqUVjX07+ApYsVbWbwZyQQA68Dk4x7tvo/69mdgCq3+jYcVYH8RM918NgF3uvpxlesFrPB5bWCAmcz3tAWmjG3xlTirB2/nKc+OEJkwIwSHbgPc/5Is5iCQ+Rp8z+fn9T24wzhsZbnpsW59Q2irJJPVLQyi/lDNUgxhaoi/EJe5arHWkvuyhnqZZ2IZ+UjHNjej9cHtk6nEg7C1uOfoTLn7EYCBinfBSIk47yS1VXHySMRTLiW44+/Tyx0n8zztCbRMdAXMfemicatssb6bCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mh7lF2YSGm0RJhI5RQE8W/icDc5sHz3xrYrHQe30Rok=;
 b=hVjVpm49zHaXEIs6DZbga6Pin6az366aUi4oSDLc7UDiGKyDD8dU3cKC0OmH6ijRzyfOAjF+oVtS7zdc9ffpf0nlvaUdckYFJ6Qn5Qn7mdxuYKLL2C1QvMGhAbeBkB1KsbwZryypNAQUE27XUwkeoIFBVzpTFhNV73XQn1mhxDdTVslqzv0Ux5kN4oO4nUNVA0wygM6OqBtA6f8+h4i7VXBbW/dqECw7vHBEHL8PUDbvdLQX8vKZ/EExx5gP6CJtbMlZWuLFcLvxUjRs6mN+cC7jl343iN/7OyhAP2lR3AR5qotjCxzM6pl7l5mN4WP3PNX3XS1bVxXOGg6COMXmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mh7lF2YSGm0RJhI5RQE8W/icDc5sHz3xrYrHQe30Rok=;
 b=vqHm2WqhfaQ44kk24dxU1zBdABcL6WrFjJrdQLYvG/VpOgQyQM4uytFp2xrbcttZAnqzzvDCsxPGw/RQhZKyW3Ku/Hu76ZwbTav2NNeZooWJMUjli9NKDyZ6WR5tKeXTjqfiLxNu7+br58KRSnUqIMaMQXsr3psXEaPo4iwOnR0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7574.namprd10.prod.outlook.com (2603:10b6:610:180::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Mon, 16 Jun
 2025 18:24:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 18:24:54 +0000
To: =?utf-8?Q?Andr=C3=A9?= Draszik <andre.draszik@linaro.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Peter Griffin
 <peter.griffin@linaro.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: drop unused variable in
 mpt3sas_send_mctp_passthru_req()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250606-mpt3sas-v1-1-906ffe49fb6b@linaro.org>
 (=?utf-8?Q?=22Andr=C3=A9?=
	Draszik"'s message of "Fri, 06 Jun 2025 16:29:43 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qlr1r4j.fsf@ca-mkp.ca.oracle.com>
References: <20250606-mpt3sas-v1-1-906ffe49fb6b@linaro.org>
Date: Mon, 16 Jun 2025 14:24:51 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7574:EE_
X-MS-Office365-Filtering-Correlation-Id: c5dc4706-bdb8-4ac4-b14d-08ddad031743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVFjSnVWbUhXTnRrU2swbHd1eWlnZ2kwMHRXNjBmMXA4bHNabHYyZkZMN2FB?=
 =?utf-8?B?UEhjV2hnUXBmdmhpcjNTd2Y5WnNRSWlPRHZoaCtJSjJ6cHczbFU2a0xZM2NC?=
 =?utf-8?B?NU1hTExXUlkvdUk1dDd2VzBUTHM0RDdSUC9MVmkyd1BtcEttQ1hROEFjaDIz?=
 =?utf-8?B?SWlXdytaZ2tzR2VOdXpxL3lUWkJYUUxnM0NqbnYrY0lGaCtKQ2ZITUhlUGJK?=
 =?utf-8?B?SEZJLzZsQ0M5M1JYNDFMeGUwWStFSkw0dElPS2ZYdmF1eFppYXVzRkFYQzZ6?=
 =?utf-8?B?dWVrSFczSXN0aVdNcE11S0E1OG9zMEZSWi9RcXpqVk11QkNXWVVyUE1nWFg3?=
 =?utf-8?B?cHNpdVFBS1FZNXlEZHI1cDZJUFZmalBvMDhxZzQ0KzZIODBEZ0I4bHZIQjVz?=
 =?utf-8?B?MUNHZExadHRVcGY2T29XOWNRMjBnSmlBWDhwM2RjZXVXZ0EvZWRvT2svUkVI?=
 =?utf-8?B?N0x0dFFmZWVRaUpwajVTYklmZ2hHSUIwR1pDQWsrZGlTbnZ0U0pBazA4R1Vz?=
 =?utf-8?B?Mk5LamErcHRGOEpWaWsrakpHbFFISWYzMzZpZHBSNWRXdHNCRCtwNHZYMVRS?=
 =?utf-8?B?SkRwOWg1dHY1aGJhVE1iWS9RS2ZLaXZRTVc0Q05yR05oRHJvWFFPaE55UjU1?=
 =?utf-8?B?b2szaHR4OG1pZUlpaFdjdktZbHdoNGY5QXYrYTZoMXY2SzRiQ3hpRDJwdE5P?=
 =?utf-8?B?RlpIQnloZlpZM0o1WDZmRXVJdkt4eEpZdXA0RVpFeFBuRjhSRzZkNmtyQXVk?=
 =?utf-8?B?d3dXN2pGdTV5ei9CdE1JaWQ3YmsyOHJNNUtHUkpYMUx0ZlNEWHBmS3VVM3pP?=
 =?utf-8?B?RVlSaHV5NWRtSysvbnMyRnFIMmsvSHZlR1I4T21wWnJycnlZczF4VHZxa0Rw?=
 =?utf-8?B?U044dVdYQVJnSVZlQ25mQXh0VzQyWnhqU0U1eXBYcWMzYXhkcmlKTXM3TnR5?=
 =?utf-8?B?Q2hybkFKRitWZE5uZnhwbVJ4UDdSWGxlSGVjL1dwRGxvaU5DS2RXdGhkaEd6?=
 =?utf-8?B?aWt0MGdkWDhwMk0wZExoalhrSUtmcWJXMXJQKy9qRUFlK2xMU0hkSW9IV0l6?=
 =?utf-8?B?cUc2STJKeEtwc0pHZ2Q3eDd0T2dyZUtYVThtZXVZSmxxcjE2VERDZG9SeHAw?=
 =?utf-8?B?dWk3SWJrdTRydXlQbEtsbEtnajdxQWtmaWRtTnRINVU1OUVQRmtKNFRwQzVL?=
 =?utf-8?B?R0tjM1lrSmtYZGRSY01DRUhTcGxXU25la2pOaGRWK043dTdXbUoycElEVkRh?=
 =?utf-8?B?N0JuSWJZanRUbzRnaHVDQUdGWWRBMEdLb1Z6OFZnaU9Vc2JVRDJIVXlUUENj?=
 =?utf-8?B?OGhzbHZRYlczaXBROHpqWmNleGFyeDM1dWRrNW1DS3ZaREZieTFHeVZWcDlC?=
 =?utf-8?B?SXBQek91dWJHc1E5azZNRjVoelpqcDZmT2VoU0hmTHNaTXdqS0kxK0xUVTll?=
 =?utf-8?B?MkRZNnVFZko4MnlDcnBNQmFzUDFyTmFIN0JPUGF2WGdQL20rWTNWWTlaaHIz?=
 =?utf-8?B?Z2ZjTUROOFIvU1pPSEMzSDVYc3IrNlg3N3A3cDBPZ3hKYjdCSytEbVRBK1JX?=
 =?utf-8?B?WGwvOE9LV1liN2JyOWh4cm90MDFJV2hvQm40cmI0YnFwSlVua3pTMG1ubGc2?=
 =?utf-8?B?dVV3RkxiWFhWc0pGL3k2Rm1DMWxnZDk1YjR1OGhwaW1Cb0N6NlcrT3JvaTZu?=
 =?utf-8?B?UXV6ZjZVQzNDWUtNRXdzcFZCalNrWG1HcENUdFVldTUvaVlVOUZVK0NZY2lJ?=
 =?utf-8?B?bXVqdVhiYW9xUWZvNGxONFl2VVpNbGd3MzRoZE93eDdOSzBkVWdta2wzenZ3?=
 =?utf-8?B?QU5mU0g1WC9neWZBdWVYb2plWjBvaUVidWFDMVM2ZGFORGtQMlZabTJqOVNM?=
 =?utf-8?B?L2s4UkYvNk9vS2oxZk0wbFVLVkZQNEUxejNscUFVRGVJWGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akhydlphczh3dmFFNFpFUFBIRUk5bHRnT2dxU2JvSDNvYkxWNW9tV3dXM0dT?=
 =?utf-8?B?MmxYRzNNT0RjSW1vdGJYL3NmRW5lM0RhNHkrSWcxdWZOSTlrcFRCa1J4Z2w1?=
 =?utf-8?B?ejFmZEFobVJIU21BN2d0ZGxSRXVGRkJETDNvcU4vemluelhVK2M4M2xkK3Y4?=
 =?utf-8?B?MWZxOVRvOThuekgrQ2FwZzNDNndCUkdMUDhydS9FclRFcHpTS0kzOGpQVHBu?=
 =?utf-8?B?ZmFrMURZTnM2eElFTmk2cWQ4WjNzWHJLK2F4SGx4dmVRY2FzY0xIbDlTdnl2?=
 =?utf-8?B?emtnblVoODVKVFI4aGdHMHFxOENDRnRkY29TbnB4TTJWUWpBbWhMTW4weDNR?=
 =?utf-8?B?bzZPQlZFVDRVV3FtUVg4c0xjd0dJQTA0RVdlRFRCRzdVVHJGQ0J1YUMydXo0?=
 =?utf-8?B?aXJ6bHFzcm4rWEVQcVg1ZXpXdzVLMisxVW0xWVdyd0dJa1BFK0NHclp1SW1w?=
 =?utf-8?B?end2SlhPL1llK0F3RUhRZEE0eUZTN09zVlMyT1ZlN0k0bCtOOFNBbVp3Ykhq?=
 =?utf-8?B?cW9JK3p2OWp4Tlc0V0ZiVE5mS1RIMUNuUkl1bERxUzdLRmdQa29ucXNUdEgz?=
 =?utf-8?B?OW9xNlNrQVJXbm9HeDgyR0VrUm1lMXZ3RVZyTTZzVG9JdUdEK2VVTjhjVmM0?=
 =?utf-8?B?Vi8rRFFtbXFMazRBWnhHVW4xQzRUVlZjSzVqZVkvWkVEWTdqRWNJL0hVc0hp?=
 =?utf-8?B?WHRtRkZ2dDg1NUdjdVlrY0NsRUx6bjNjRlZsdVlhQ2RqT3RLYXp2S3BBa0Vr?=
 =?utf-8?B?ZFNWYmlxL3Uycjc5UmZkQndKNDRIRWhDSU5wUXBwMXNnbFhmdGNEUHlJL3ly?=
 =?utf-8?B?MzBsUU1EZUJMdXlKREJHVGN2SlBVeThBcFBJVkEzMmZHbU9EbEZ0ZDhlMjVM?=
 =?utf-8?B?Zk5qSU02eGRneHluWDg0b21ldTFsRFZCNSs3WDF5WDE1MVVXalpVcS9QUzJh?=
 =?utf-8?B?V1FEaVljWmp1UUFDL1M5MjZjQmowcTJoYlR1aWVTY3V4YlZSbDdxZ0RDVWg3?=
 =?utf-8?B?REdVZWE5ZE5YejNjN2o4ZnN4Vmc1aUwzaEorNUptOXgrS0hXdjAxeEticTgz?=
 =?utf-8?B?cmZjZUM4NUJyUnVGbUs3K29SYUQ4cEhJbWhvLytBOFRRK0taVlRxdXVDZDRJ?=
 =?utf-8?B?eEdObXdHalFwWTFSb1QzVmtBUVRmVStIbXdJYnJCenIvRWoxRDlXZlZrTjJT?=
 =?utf-8?B?UTRIc0x3VmdITUtxSHdqSjA5YlYvVFNGdi82ZmJ2TlJySUJIcDJ1dmd3cGRh?=
 =?utf-8?B?dkZTZC80NEs3NEZQL3VtV1RsMGkxYkp6UjdNVUZQMG9VbHdob04rZm84ZGdh?=
 =?utf-8?B?TDVqVnBpbEtXdCtURmVJcG1pQnBkblpiOE9lcDVETTNnS1F4YlFqak91MzVC?=
 =?utf-8?B?YUIyOE82NllOTHlWV0RKWVRpYnpHSXVVRHdYdUVKS3ArdXpDL2w1MEZFY2dN?=
 =?utf-8?B?emsvQ0pqN1NOcTNQanNOVjFra01oemRmNzhuWTFjdWRraUVyM0hUTWJ3MWh5?=
 =?utf-8?B?bTlSeWRCUWYvbi9LZ0UwS2tBQ3B0RWF0RVh2NjNPVzg1TVU5R1lDMklqNVdt?=
 =?utf-8?B?RW52b2hMM2w2cXA1bzlhekcvRm9FaXQ3Vis1MERqMHkzeHZtSHBKZ1M1VGdm?=
 =?utf-8?B?TWlQRHlFOHgvbWZuTU9od3JRbUtVbHViNHJSNThkOHR1ZnRRWHVJNlhKb1RQ?=
 =?utf-8?B?ZjdYcXE3Z3o0bS9rS2FaYUEyeVl5R29EV3pYUWhWTTVUNXhKdFUxNXdnN1d1?=
 =?utf-8?B?ZG9aZ2pCd0Y4RVJESEtpWnBoYUY5MUJqSTgxVWhVMlF1S3M1OEFCZzk0alg3?=
 =?utf-8?B?MERhTE5BNVJzVDh3VzcyZlRQcVhqUDlwcVE1VGRNSUs3Z21ZeEgwc3BXM3F4?=
 =?utf-8?B?NzRyQVlrY3NNanBOOUpleTVXclFEcVJWYnpnSDRJQTlPVDZCQ1U2dkZNZGVo?=
 =?utf-8?B?NFVUakNEanl6ZUJEWjlRTlVNV3pLRlQyd0g5czNZbDhjemZLbGpLc1ZITjhq?=
 =?utf-8?B?NTdKZXNZanVZV3lacTdqcnUvSU5NZkFDdlhhdmJrb0V3bE5tRzFSb0p4V0JS?=
 =?utf-8?B?b0psNm9YTXhsenZmZnVTMEVSQTZZb3dtbXdqem5XOEVvejBJeklFWmx5ZzNM?=
 =?utf-8?B?d3dOdG9KVytvMW9teWI5Qnc1ZndHRHdNS2lGZmUydlZFMy9JQ0VFYWp1cS91?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J41PHwd8L/rozN7U3IA44m3cNMskRPo2hkMeHb9EiEAAGvZBneZ1dhieZ5XdKWfNvqyNrygF728a4vimi6MXzSdQ2yb5Pmj7amIN43dRVqvv39SlA3QSW5zruxhjIorw7YiDnTYMTWngC3Afg6ZBvXP+Z09hRSZqBB4slmb/Gll6ViCFJ8CIYwBi+SW6TRkKPXWbJoAqWB19uCcr5DIDo8UVEC5FWP7909lkGkpIONA4CEJ33vz6CrKOih+lVnrHXPc54XAOtLJM4HwEjM5rMwral5sSk4GO4M28XiCZmgeKrbBEgPLrF6dCZ+r5qV2LEW1cIqNeGLKlvRvDdmf+rejhpn67dMpNWYxYhNDg4GKJB0BNJQkZpwc7Whlr6XtKAIpJzZip2cDZtOwSYbnsyq6ujpcsrT45MOzKPKRIwwPYRS+4NhQyLFWMQKEH7fnZYkqpbtEaequA3o/Q/tsBJ0D+ncE6GhoEF9A3N/qVBGB29ryA1bI9qkyuDRFUzH3EBQFhs+df/74SLvfPK7tUU/zYJhvo5m182rKppO33O5J54Iy7FnmisHcyUZFIyMNW6/Ti/QQy6ItwAbowNdstdNTsanJcRXCZml/UOC9H1+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5dc4706-bdb8-4ac4-b14d-08ddad031743
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 18:24:54.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNwQQrcCXqagoTviwV7ZfE3BowEWcNy8H3tCiU30e9nectn4aOU+AD3C2aPW1gCkmd1sElkUENQjK6OfzjA96fE18sIPWqs7b5K7Qsqxghk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7574
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_09,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=956 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160124
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDEyNCBTYWx0ZWRfX0h3KJiixVXPD qWJg0QJeF1HOG8vDi4BZ+f2PR135Tw8tfJ2O+EmsbXM0011z3FhzO6VFAfHdW55AHK+oBbD9I4a fpOSM6d6xy6nvQT4Cqw4kWpxBA2udbPZ/FDBakKIwpyCNdi2DYRkqBXE7qPcrHLK8ZQK1IpkMP3
 ixWM847wa0q9s8a9e7+ayogvlgeKFh+0kdHfuXKEHY+Lx94psdsTDUBF/szGjxDFSoxbt15QFb8 QPtGJDA8mrcyBMqN2LFJaPQ58FN698R1mp48ufTehbHqQCl7FcRX0/ws+GYXxfzkmB28TEmS+1I LJWIT7Q69iGeSkHcMxODfe9VBooYySX6GIHedsF5aP9MAn68j0Ci1RKxkNwHpFTky9n6OnzkXfl
 Y5C81bREgRs3TrjMVYAPQ8TqOW0pFxcrva8mVsXhdzQyDRCRC2zU3ZJoLHpnBTAe3WYT2zdB
X-Proofpoint-ORIG-GUID: UQDS0iUbFm0V6yyi-Nposg8RbZQOaoDW
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=6850617c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: UQDS0iUbFm0V6yyi-Nposg8RbZQOaoDW


Andr=C3=A9,

> With W=3D1, gcc complains correctly:
>
>     mpt3sas_ctl.c: In function =E2=80=98mpt3sas_send_mctp_passthru_req=E2=
=80=99:
>     mpt3sas_ctl.c:2917:29: error: variable =E2=80=98mpi_reply=E2=80=99 se=
t but not used [-Werror=3Dunused-but-set-variable]
>      2917 |         MPI2DefaultReply_t *mpi_reply;
>           |                             ^~~~~~~~~
>
> Drop the unused assignment and variable.

Applied to 6.17/scsi-staging, thanks!

--=20
Martin K. Petersen
