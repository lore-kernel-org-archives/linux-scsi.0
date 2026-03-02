Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E1C1E1A33;
	Mon,  2 Mar 2026 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772453628; cv=fail; b=AAcB+6TcIRwPGRtnR1dVM3mbyckHAC9tNfBRSpyeBJIFYIOgZmS4veJFjcUp1kWTJ6OzOcLQsuT8RSI4BCr94ZvT+rOSS43Behh91qeak13IsgpWY9DaDhhuvD0jarrhSKZolxLK8K6/YMYhCoOCcJgbqi7z73HfdzLsfm+h1GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772453628; c=relaxed/simple;
	bh=AcSDsPzM+7Vfs1V4ub4zIa96uYUbmq+6cbEeCleBySM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jt/Whtmug2Pe/2hhCjIScmzVECm9Hqw0bJbIzkV8uS99Fv1oAel3J25+qXh3jjKEjWzJn2E5wT3PRIL4y+Ad0ePSQ5DLTetQTOD1Nn36qcLEtWTSzfFOB8kIy06VIH6vJiL7bF7dBva9NAphdGSfsy5V4SNbqX92Uwpjo38CXwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q6ddI6bG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gXVL8wwO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q6ddI6bG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gXVL8wwO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622Ax7o8879556;
	Mon, 2 Mar 2026 12:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZGIUoge4Dppt4O8Yu5aNG6l5sJxUDudV+qge+3Pr8zU=; b=
	q6ddI6bGWFCy1kjPHR6U88y4+RxrCPs4FOLk0kj/NGhit+0GP5V483HEP8XaAwvj
	Yt3Paur2vmhYLbrDTNCCmJXVMlAiT84xhlFAtwTFKYTFy76A1tnukwRB8jjwMf/w
	plCjvTrktcAmaoX2bfNGUgl1MioKnsmq3PFCKMNzru0XtNV4gSrz96KiBD/Mu0ju
	vfEyLNMInGRaQijW/srijmRtU6/ysoUhyvQ03dU7X3ciSJzOGJ6UCVgOMfWR+oMi
	A4gt6fAd2l2tDAUVMa3NJW2M4dxYtaP/WHIhlsdavHxU9o+27goApZJQLsI/eifQ
	WtLplGP3+ZN0sVXHkLdNmQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn98v83eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:13:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622AoHal037736;
	Mon, 2 Mar 2026 12:13:26 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011022.outbound.protection.outlook.com [52.101.52.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8khvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H2NX1UkTXDnEkYjvWfCGlIDhTpz6X5X8tQekf/OHQLgKz0VrWwfBnNikjHTIH7Prk8EKPWMO9HXpptbPQjsYChskwIrNdrVedkXX1L2ZiQACh/H5rEdzJZsU6dLOFZyZ51cEyxoxHiF2e0JEzaV6gqH7uwD/L5+lyrhz3zCo33GjbWXdDcfJmmr0Bivgdav1GR2EEqs8xov6oA6c+geksK0Bqj9wVrQVSOj1+VEZjawovxCFfx0rz0kJR5w1RlYa/PBwQ2Apur5NnQMdOkYTBHO+pbbtVm3Xyi7gxsFZkP8pJKMp9lh54NhlfBIVbEg8qhnHrq9+lEA50Gq7ADSn/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGIUoge4Dppt4O8Yu5aNG6l5sJxUDudV+qge+3Pr8zU=;
 b=aOHjrLJ0g2OGqf8JLB7GAtONHpRkC9o4JXVDp3HEIl7WzBLmLvrHeXsBEjrFxLfXbSfO4bb+BdwDpEoGNij9YDzQay6gCtR/7WJL82djC9PO5e3S4Dz24Zkfo1BOdL9h8KgpIxqJOKxazolehq3TePDyqBG7zOPk6+6IVnTZufXQYqIP/i5eGA9pcoTAHfetVCj3zAd3N6cmSEJUoDxPogLbFtEPy1MUWuYTAm8jFeKmBW2V9FF18RYzIU59/9/TIJkJLcnHDQPtfv4T521YkLZR/b4zCvoOci4S+d6XPRRn6wAsApBCdK4TSi0L44wtjjp2DZhfXsFM/dVe0CxV2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGIUoge4Dppt4O8Yu5aNG6l5sJxUDudV+qge+3Pr8zU=;
 b=gXVL8wwO0qFGkYtUeui/za4cq+65q07LEeHoyOpgXX3Pry0KJiCC9Ez6FOko5NtPQgjyWarSpO9L2DGUWsysZ2RaVZXj2nr+nqlOIzb3i/nzhwIHDhT2T/wz5CD8pQOE7Eb+Nn+dPfawMMBAWg4o2iNxZVtUXUIMESHmtpsHKhk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB4883.namprd10.prod.outlook.com
 (2603:10b6:208:334::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Mon, 2 Mar
 2026 12:13:00 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 12:13:00 +0000
Message-ID: <bfe3a30f-50c1-4ede-a424-f342b80bfdcf@oracle.com>
Date: Mon, 2 Mar 2026 12:12:54 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/24] scsi-multipath: clone each bio
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-8-john.g.garry@oracle.com>
 <aaUCR-IoNItKVZCh@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaUCR-IoNItKVZCh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::13) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB4883:EE_
X-MS-Office365-Filtering-Correlation-Id: 336aba1c-18cd-46a5-5dc4-08de78550c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	NWWsjMNItSwMioDavAE5ffnnxA6D5mcpJqct3Ef78DQv4k1uFuVGKrpSYVHRg3MF/TXO+LQdGBqmdVuHSyIXIcR08na3uhjtUDQPKM+ay61135ZLQyT9iXKdzsCQdiCpElOmcPI/K+3+XUiTZdv3+ffLmEwdtrq6WX5GPzyUiTUX47m09cbvcMqPTHH6yUKNklC4Z4UaR54pEFcvA3FPSYk4iLsndFvtQQV3XV+WxQ61xX77VtlD5qIeAy9FZVfTFmboeiyClgriYu2jTlkndR3ZHCW55VHoN0SUQDDmt4wAIVAVHh/zB8jCwX0RUhh/gsk4s6GL6O6Lsly8PVGr7glibVhfI4y6Wk2Ff12tN6/6obSzlq/SA2ifxK9btSnL0ekcrKnj2m8gKXilDOAB84OssUrEM/9S/pi801ECi42r5O6S0Df44y6dGuDUi0KIED0u8qHrkVdJJOwaIIyVnROfNMJ6EIUEistqcg9bSmNDGbOeZ45XdoN9pLCEwVVuFLs1Zw3zoo95ob8M/g3CErWaWYL+kPS1Ih+gzYJxS6+u6hwad+1h2QtLA3fHPN3435YLtVELApT5zsPNQAYPdNLQv6upa38HuRxLK5HCpAeq2z11PY+17E2ws+QOYQs6Sw79luOpNw8Cwo16+29CRrArWFZ+Pe7DzIMzLYhbLUxBK/PNhnoWC4VwvSrYzA9GqawYstsfDrNKaXzgmCX32ykgQZPafZjzkxG1cqOPZPA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWp5TExSRlJnWnp3ZEo0VERTT1RINk1XOThJSzQ2dDArbTRhZzN2eVNuV3FZ?=
 =?utf-8?B?SlFHK0Vuci8zL2RaZ2l2MVhiaXMzUm1HS2hwK2tzUUtxSEpUdmlhUEdkOEdM?=
 =?utf-8?B?WUs1S0x4Ykl0azNlRlhDL3BlQ004T2hQY0tlY2xoNFBJSmpVMEMrTUJYOFpx?=
 =?utf-8?B?OEVvYkxSQzM0dkxRZFdyMHpaSFhHazRpVitmRW9kYWpwQjFXREVRN2cvNmFV?=
 =?utf-8?B?cVlkTGdKZ290T0c5UnEzbHhmZWlUVUVHWGxraTBTSWxJSXByb1Y0bWQrTU1R?=
 =?utf-8?B?S3NSYUF0WjVPMjFBck9RYnFUN3JlSnkwUHNzNHF3SjRDRGRBNlhIbCtiaVFv?=
 =?utf-8?B?Ym1ET3huUmtFaFhuWGFrQ0QzUmEvbTFPVVdQZmRBV2pIRFJDTTNFQmtuRldp?=
 =?utf-8?B?UDZ4VTVyLzdsVjMwaDFOTzh2d2E3ZC9jQ0MweUxSOU5iTDR1N0ZjaUNhcHNW?=
 =?utf-8?B?RlhtaWl4bnE5MkpGSTZIQy9LdXM4YWR6NDcvdjRoTXlYK0pVSzVSb1FQc0Nh?=
 =?utf-8?B?M0Z4ajNwS01EYUlzMm9lVE5DTFllYURES0w5dWJyVmpXakVpTmt5S1pJT1hU?=
 =?utf-8?B?RjFrczlEd21VNzd2VlZtYnZWU2RvUXhQUjNUQzZwd0EzUFAxYmRnMUUzWWIy?=
 =?utf-8?B?alQvQzYyV3dwWTdCWktTWlI2TktHaW1OUGphSnZHd1dHSGVCMW1mc21LTjds?=
 =?utf-8?B?MEpPeVUwZmxnV3BwclNZWms5T1JpTXNjdlpOQ0JwdHJXWmVzYVM0NHVkSGl1?=
 =?utf-8?B?WWNob2RsYXN5aFR5bGpxQnhHNTlDSWl2VlNtUFZyQk40L0VMUXBHMVhKVzRX?=
 =?utf-8?B?R0Q0a29DYmJjZG9kSmhTaU5mYW9xSVdpSnNEaFBvYmVDSTRoS3RSY2E4TXpS?=
 =?utf-8?B?TW92TEQ1eU0xTjVxRXNBZ2l3blRDRXRJeUNudUdIRkZ3VXpjbTJobXptMFpl?=
 =?utf-8?B?dklkc292UEhQRWgzTmxob1RySlpMQkh0U0tOcWQwU2REbDZNVmxpb1FxdmJm?=
 =?utf-8?B?WFdkdDhXMTl3Z3hkR0orMEh0WjQ4QWlZYWNmQVI2Y2FiWERCNFFzL3pFLzdY?=
 =?utf-8?B?SDd3WXFRNXlweDYvOWFZKys3UTdLeDlBbGZEVnFnb3ZvQ1B4T1h6c0g2bGtq?=
 =?utf-8?B?ZytkMEZEemhkVHM5Q0ZweFhUcjQwVTYzVEtQWlg2Wnd0WUhzSDVJc0JaTzdk?=
 =?utf-8?B?dnRnN3FRbEVxTjZOV2xaM0VxMEo2NFArb3ZzZGxSUStkcVNici8yVkx1aHl3?=
 =?utf-8?B?WWlFMTliM3BWYk5NS1lQVjg5a3Nubllza250WXArZHhGckh6RHhqUjFNMEJ2?=
 =?utf-8?B?MFI3dGtsTmpNcS9QejFhL3NrU2lVQ2V6Z2o5V0txUTBMVDNKejlyMjZiUXdN?=
 =?utf-8?B?MmhyTmZVbU0vc3FpVWNHaDh3aUJSOFRQbHZNVDl3QXBBa1p2UXB1UlphK2lw?=
 =?utf-8?B?YXpCYXdiNHlaZUowVG03Z2s2Wms2bHR5c2JpWS91bnBLZmsyOFFxeTBBSmsv?=
 =?utf-8?B?a0VENmhYd0x6MDFyUExBZHMwYTRZUTg0bEpKejA1clBIbEJBUWFsSEtjOHVE?=
 =?utf-8?B?QkZQQVN4M3VZL2JMaWxteitCaWNLbE14QjB5R1JsVEw5K3BnUzhwWmR6TFVl?=
 =?utf-8?B?dlJjQ2J1WFZUQUsrejJjbG9yWXdkMXIxcFdjeXJKWFU0U1lWZ05TallqUndl?=
 =?utf-8?B?S0NNdDMvYWw0aGJmTm1NdG9sUGErUTZibXVVK0NNWTkrUldpbWQzWUN6bE5w?=
 =?utf-8?B?Z1BWZTBmN3gvSFZDOGZkT2NxanFTUWRKei9DbUc5Y2U2R1NJeFlwV056NUJu?=
 =?utf-8?B?ODJOaTE3ZHQraHZEbWhXb2hyYlRBVmdSWlZGcS9ub0M2NDdxNEp2aEFMNDMy?=
 =?utf-8?B?VXBMSkdBR3BQanhVMEFnQUtqZDlIV1dRZFJxZFZ3MGRmQzE0OFEzVlFXVWlS?=
 =?utf-8?B?eHpGTTJrRVVCWmR0WXM0K09vQzZqaEV1Y2x1MTFNWVZzZ2pVZDQrSzR0Umhz?=
 =?utf-8?B?U0hqWFNScjZBVnoxYkJwUXhHV3pkZ0RXaytYeUxlWEFZQXl4d3lqY3NjUVlx?=
 =?utf-8?B?TWxjcWw2amhubzBMcURrVGNsZVMyeFFmcnRJYXRweTFxNXF0SEY4S0NkQ1Jt?=
 =?utf-8?B?L0FQeDlGTi9pekw2S05sZStvN0ppQkhXZlZYd1BEV29EbElRWnhsODhqT1k1?=
 =?utf-8?B?dmV3ZlR4WlZHNE9SdzVpdTNxbHJpeUg1OGd3Y2NRT0JDbW1yS3pDZ3lHNEl3?=
 =?utf-8?B?YXNNSVJaWXE2WjhSL3lQWmZLZEIyb3ZWMTFZSVhUeWs2Z2VPeWxwVk1KaGV4?=
 =?utf-8?B?UWEzUjE0SXdUUWUydnMzNGNybVVXNHJuM2xDT3pzMER4T1lKWVhhZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mWq+8Xfbs52i767flrwkAZmxnG6k6Lp0IwyJ9ezHPCGdEueSOSSGqcZcNlzpOed1VVSVtMZdoHgiIRX7XDwd+mrXz7jlIZqWZuFNMNgOWVVOpkTyRsMM7Q2jnW9V4OEQycTYF9qjgRA7rjL1lE1QSFK3ehjG+jxMnXh121ME6Mn9fDAZuFktx9gknLv01tcmdG+nbnfp/M6mp13OjlM0v+ErBQhYI5qfha3P35DVxgaUA6NHAvlb5Z/xdgASGBJk337PAKSXkmQWxVpuzk3O/no7A2FuQAXOR+j6fc/CJ5uAFD9WmiaosoPSGTSG/PkacDcgWv5f+wxrariR5nMtfOgBKKHUhw1PzA9Hn+r9l+4TtAJ+MUuIWUCKWzoYhuROhbrNsjWIaqTtPEKpTndvl2u5sO1ClplgSWD8E2Ylxr2FcJXUY5XGH57iwJ1WT/KRCTFAYWKGIezloWC3GMuRKASqu1pVMK0BUpgC54Y6iJta610zp6hAzyq/Zi8D9REjdmAzBuP2lABHeEJHtkp7CvSNayZuHy8Rlnj1wuFOZ1sVUys9/vr41BrrY1pQl4QC/2mLGY4bA59FCJ4Vt9BdOQOkJ0xNuwFO3zQOfrfHSew=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336aba1c-18cd-46a5-5dc4-08de78550c11
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:13:00.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qd5PXtAQNG7W92PFYwP1crp/hb3Mg4H61IovzRnucj2FClRg9N7SBzykKw7fwBYS7/lzViktjMRmrO8i1lgZaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMSBTYWx0ZWRfX3HQvuCh9FgQh
 0BhzqC7f6o/0u8RXHDCIx46tkkX33yFLol8nUrrFU/HDIhmhf7C7bucFsYQfTH2nOGuu/p4+lVH
 Oqc3DEjGUObOs2z5yYxkwTeG9fph3jElWWPA5NPQ3oZ8zYdGB+hh2SDlk798myeee6ZJ6GL2gEE
 p6avS2wAIeLSg2FGSIN66ua6JjjjdFLu29RkX8h0DVe4LMN/ZDz6ckyGFa4K1iqdaU2qF61gjRL
 SaLRp4UCT/Xj8UD2hg23E88a9IpVyVRywQ3UDW6cFG5AKL2vAUSN9pBq6QlrNpPTfFv8IK2wStr
 1Gclvl6+xD0aUC+D/vMDvxN/sHa9dreA9XBiyNZJEiBbFTLxsxVQwTLRugo/yJZgokM8Ln1NgLP
 RRmNHJbmJF2jwVfHkIhYd4V60pUNo/46nuNf+am8P/hrKomiGRgBjDgIJN6KON7B19K4d6j0l+Z
 DCbbLpBf5DFGAQdwSpw==
X-Authority-Analysis: v=2.4 cv=TY+bdBQh c=1 sm=1 tr=0 ts=69a57ee7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=2wtX2lSxOv9MnxaKdmIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 3aMMZ_UI_zNVHq6pgdA8VpXgW9W-BB03
X-Proofpoint-GUID: 3aMMZ_UI_zNVHq6pgdA8VpXgW9W-BB03

On 02/03/2026 03:21, Benjamin Marzinski wrote:
> On Wed, Feb 25, 2026 at 03:36:10PM +0000, John Garry wrote:
>> For failover handling, we must resubmit each bio.
>>
>> However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
>> is either all or none completed.
>>
>> As such, for SCSI, for failover handling we will take the approach to
>> just re-submit the original bio. For this clone and submit each bio.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/scsi_multipath.c | 51 ++++++++++++++++++++++++++++++++++-
>>   include/scsi/scsi_multipath.h |  1 +
>>   2 files changed, 51 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 4b7984e7e74ba..d79a92ec0cf6c 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -89,6 +89,14 @@ module_param_call(iopolicy, scsi_set_iopolicy, scsi_get_iopolicy,
>>   MODULE_PARM_DESC(iopolicy,
>>   	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
>>   
>> +struct scsi_mpath_clone_bio {
>> +	struct bio		*master_bio;
>> +	struct bio		clone;
>> +};
> 
> If the only extra information you need for your clone bios is a pointer
> to the original bio, I think you can just store that in bi_private. So
> you shouldn't actually need to allocate any front pad for your bioset.

Yes, seems a decent idea

> 
>> +
>> +#define scsi_mpath_to_master_bio(clone) \
>> +		container_of(clone, struct scsi_mpath_clone_bio, clone)
>> +
>>   static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
>>   {
>>   	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
> 
>> @@ -260,6 +269,39 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static void scsi_mpath_clone_end_io(struct bio *clone)
>> +{
>> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio =
>> +			scsi_mpath_to_master_bio(clone);
>> +	struct bio *master_bio = scsi_mpath_clone_bio->master_bio;
>> +
>> +	master_bio->bi_status = clone->bi_status;
>> +	bio_put(clone);
>> +	bio_endio(master_bio);
>> +}
>> +
>> +static struct bio *scsi_mpath_clone_bio(struct bio *bio)
>> +{
>> +	struct mpath_disk *mpath_disk = bio->bi_bdev->bd_disk->private_data;
>> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
>> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
>> +	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
>> +	struct bio *clone;
>> +
>> +	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOWAIT,
>> +				&scsi_mpath_head->bio_pool);
> 
> Why use GFP_NOWAIT? It's more likely to fail than GFP_NOIO. If the bio
> has REQ_NOWAIT set, I can see where you would need this, but otherwise,
> I don't see why GFP_NOIO wouldn't be better here.

Seems reasonable to try GFP_NOIO. Furthermore, we really can't tolerate 
the clone to fail. So, if it does, we should return an error pointer 
here and mpath_bdev_submit_bio() should error the original bio.

> 
>> +	if (!clone)
>> +		return NULL;
>> +
>> +	clone->bi_end_io = scsi_mpath_clone_end_io;
>> +
>> +	scsi_mpath_clone_bio = container_of(clone,
>> +					struct scsi_mpath_clone_bio, clone);
>> +	scsi_mpath_clone_bio->master_bio = bio;
>> +
>> +	return clone;
>> +}
>> +
>>   static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_head)
>>   {
>>   	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
>> @@ -269,6 +311,7 @@ static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_he
>>   
>>   struct mpath_head_template smpdt_pr = {
>>   	.get_iopolicy = scsi_mpath_get_iopolicy,
>> +	.clone_bio = scsi_mpath_clone_bio,
>>   };
>>   
>>   static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>> @@ -283,9 +326,13 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>>   	ida_init(&scsi_mpath_head->ida);
>>   	mutex_init(&scsi_mpath_head->lock);
>>   
>> +	if (bioset_init(&scsi_mpath_head->bio_pool, SCSI_MAX_QUEUE_DEPTH,
>> +			offsetof(struct scsi_mpath_clone_bio, clone),
>> +			BIOSET_NEED_BVECS|BIOSET_PERCPU_CACHE))
> 
> You don't need 4096 cached bios to guarantee forward progress. I don't
> see why BIO_POOL_SIZE won't work fine here. 

Every bio which we are sent is cloned. And SCSI_MAX_QUEUE_DEPTH is used 
as the cached bio size - wouldn't it make sense to cache more than 2 bios?

> Also, since you are cloning
> bios, they are sharing the original bio's iovecs, so you don't need
> BIOSET_NEED_BVECS.
> 

ok

thanks!
