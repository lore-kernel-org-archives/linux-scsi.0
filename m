Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E89478;
	Wed, 15 Oct 2025 01:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492357; cv=fail; b=SqWw2Mn47KwSUHvTZ501o0WXY3+Io/C3NlGBqOxMtzzzu6Jy2+4fYvHzuAIVA5N8u+1XNtGpv2XAda/SQqm2P6xirGZpY1Xm4gErTW2TbP7nbtV6e1RkImED6M1vXrGGks84puVHzVCCeQ2DLBxNKz1MjzK7yM22hwtNyMbDqYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492357; c=relaxed/simple;
	bh=kLHEfCEEBsXTZSmH/Ox0axBDTg0aqKM6dgzZnK8AWyA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nID3BnLZzzuXi1VgLC+aEiGct7azc/O4hUKIRWtZza4FFLldzNzA1wKkx3mq9oPs2k5KiQKqvooMyH59mexoWSvtNYRyT2pdweVap317PuFqNFX6OuT6hBlYzyv4U3eH3oRFpe18wD45CRHmEcvraWtCzJATWwtXqRldn2H6j2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qgn9blje; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nEjbAU8k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qgn9blje";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nEjbAU8k"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EMwWgB001994;
	Wed, 15 Oct 2025 01:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kLHEfCEEBsXTZSmH/Ox0axBDTg0aqKM6dgzZnK8AWyA=; b=
	qgn9bljeWW6X72DNm7DIob7XXgIdLss8x3f+bLQm+gNr4emh2I/f2Vbji6swKmnI
	3ucStLgtmywF8V/iccQ0jgAehezAqZQT7ZmtmQGg45wBZZYJbUZS4g0+uJE+AcwZ
	uh2CMecJPu8sJ+1Dt90zFHTLCcdFtYAffQD9Z5/IrKg3yl9mC1xNjqhAoI3kzhBG
	Hj8yALnFv5ds8wlUhsEIHRE37iJT7sQ8EuV8QfIgzCacUzLvpw6lLvGw5AK1ASrA
	aDa0N74sSgSHL09en4Vo6CeKE1tR2DeEVtFU0mHsdA9TjRCnLTPtFPnOtlTl6Sjm
	zUl8ul2YtNdc/6A91uoVYg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtynkap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 01:38:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59F0qXj9009889;
	Wed, 15 Oct 2025 01:38:53 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpfpfva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 01:38:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ar/qY+Si88DOV2c16I6bshA9vIJuudXoVCxkhfZ8VGSxVUw60IirwrlClafOfiRJyvLtGQFohVt5FMwXMHv75kZdgsUcFh8qejIw93lTtYt+SpOIObdVum2qtGaNGToVlghj18uHWA32EwFCT1p10oOmkadyG0ZAZUpAhgum907zvuUUpGIyOzJYD37HC/UBA/HH0okLfGIi6EMpihXbqGV9urTGB5lC/F4Y22HrpsORjzbu9SaaBwjTiRvyN+05SLoNYAR146MgSC7orN4jHqi31H44l9tBIRuezTYl6pqRYVPhX0dS9aLVqqjJpbthuEfSzOQ3/mP0nMpVPLEBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLHEfCEEBsXTZSmH/Ox0axBDTg0aqKM6dgzZnK8AWyA=;
 b=PMGRijkBI4CB0zsQ+KgMXAuYPtAV8v1zf9oetP+pv/BB+XwHz+SqEnSMxNGVOW/4JF5SED7JV3OykqVQIIW1DPQm0tWS9wVf6k+6IlehXaGUE3rLieoWK/A9b6gbqpHbN/kUTyw2JITw6nw8A2j/n+A7bT9rMxz//3XOdnL0FKfYjAtRsbRHb1DKECfe5Ju/2DetUPB47VdnEN0ZEoxalBC9e+GikE4xPbIkMoF5/YUlxfLzO/JI/eRvQtLIN8KB/ugbs+431pxlwfewEsOHhj5EF/Rc9yW+uRQUvBIsagUg7ouTtfFsj1cUzCG2JIL/PXxFtnEQbJ3DcARGi4FaYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLHEfCEEBsXTZSmH/Ox0axBDTg0aqKM6dgzZnK8AWyA=;
 b=nEjbAU8kumHfg9jv53rRxY0SrHlikTPrXhtc/jE7HLwGsfOJ04MYuHJSNfBqtuAuzshl+tb19hW4pmv9OIpWZfHYamo0D1I552ZbI0AVLJ1Sc/KzrOJnuW6zw29bQlKRDzRsi+K0OL9UyHG4Z/m6fZ4iyW8Ssbpr3xxzdHUdEwo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6543.namprd10.prod.outlook.com (2603:10b6:806:2bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Wed, 15 Oct
 2025 01:38:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 01:38:49 +0000
To: =?utf-8?Q?Andr=C3=A9?= Draszik <andre.draszik@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring
 <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor
 Dooley <conor+dt@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Will McVicker
 <willmcvicker@google.com>, kernel-team@android.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: dt-bindings: exynos: add power-domains
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
	(=?utf-8?Q?=22Andr=C3=A9?= Draszik"'s message of "Tue, 07 Oct 2025 16:56:28
 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qhdaqqp.fsf@ca-mkp.ca.oracle.com>
References: <20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
Date: Tue, 14 Oct 2025 21:38:47 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0178.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 7721eb97-1710-46cc-eea6-08de0b8b9715
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0NDcmdmbjZTOW9SRDJiYTJQZ0JxSkhNamdmTTh4R3lFWlRqTkxTczZVZmYr?=
 =?utf-8?B?NEpJelp6ZEgwNHFwWURGZzRHNjhjbEpqSHdKTUxsbm5SZTVhNWxnbVM4L05J?=
 =?utf-8?B?QW9xMmM4RHNxWmROcyt4WFVMdlJwZG5pVENsckxsajFsbjhiNnVmL2pZdDRE?=
 =?utf-8?B?NWJrQ3UzbFZBUHE3ZkdvbVBjYVFMNVRqK1NiOWFLNnJYTUVqNDZzSW5qTDF4?=
 =?utf-8?B?ZlM1cEF6MFFOY294Mi9LcTMyV0c0SVlHUWhEczRlVlQzY1JJb3RiRUN4TDZG?=
 =?utf-8?B?bnVNdTd6bXhGTFh6b1QwK2ZVZFg1TjZ6bkttYklyWkdTWkU1c2dDay9Dbktm?=
 =?utf-8?B?blVTM2orTys4ay8rU3J5M1QvQUFTUzZKS01XNzhMMkpTeW1XQjI4bUUrcEVs?=
 =?utf-8?B?aDY1TkF3QmtRd3EzNmI4WXFkanh4TlVKb3Z6c05iRnMraHpKSlp5UXM1WUYv?=
 =?utf-8?B?cDEzOU5GV0hGSzJNSGs2MmNNY2YySXdGL1FHYjhEUDcwUGd4WUFiZmQ0Slho?=
 =?utf-8?B?dld0Rm52bjdiOTlQTXZaYmlGS0RZVHBiUnZGRTRmSGxjSW5OWnNUVVY4aU5q?=
 =?utf-8?B?em5pZ25mYldkQkxKWWdqUWRjLzQ2bEpqdi9ydWxhb3BiVmtkU2JwSUVJWXhr?=
 =?utf-8?B?aHNjdlhtYjF0RER4RjVMa0RtWW82SU5YbHJ0L3RSa1JvZFFLOHZidW80dElW?=
 =?utf-8?B?WnYvcHpEekVIdXJZT213bmptVitTWUE0aEZHMGs2QlJNbWxwalBUOU44aHYz?=
 =?utf-8?B?NEVvUTRpdXB3VG05TTIrOHNyY3daWUN2RklDK2lWMlY5SXdraWZSdHA0eDlu?=
 =?utf-8?B?TVl5cHlveTl5UDBlRDQ3VVR5WjdveDVkM25WNHZKVS81UFF5S2h2YzNxSzVq?=
 =?utf-8?B?QXQyZyttNThvem9meTBNUmtvZ3cyUitlSTIzcEhRQUxBOUJvWjJncUw1QjNZ?=
 =?utf-8?B?N3B5U0swQlZWbDZreGN2dGZuck5kQWNVUjcvSlNsSUlsTzl2WlJSb2JkZlFC?=
 =?utf-8?B?T3cyZHdwaFh6VGhiUjFWNDRBWStJVEdJSU4rZUZtUHg0ZmpDWWFwU3JkeDVQ?=
 =?utf-8?B?bVc4SXhJSWtWdmJRVDJ5TDg1WFpsZnFYRktMRmNNL3laeUVqbHZ1a0d5cUth?=
 =?utf-8?B?S0dxVW1HS3NUUjdpMG5JWjBHcEF1ME9ycUZwY2Qrb3hCTHd1dWFnWUhkMnRN?=
 =?utf-8?B?WG5QaW00RGhwVXVwcjcvR0JaY3RteWZKWXhUOS9ZTExIOFczeklCQkhYcWpr?=
 =?utf-8?B?ZFEzNXl3YWNoZnRqZ21DUUJyMXpubkk2a1o4c0I3LzdLTmZFMmFnOVVESk5P?=
 =?utf-8?B?OGVrdUh2MXRtQTFDNDB6ejhKbWxndmhoTWlqT1RUZlVJSk9CeWRqQWs2ZEtO?=
 =?utf-8?B?cE0vd0QzWGR0Rjhvc2lQOXViYXBEaEE5aDBZQXBMUysvYStvMy8ya3haUDlR?=
 =?utf-8?B?aGczK040cmFOYXpkMHJtTFM4cEJPZnJsM0lWTk5Zb29telF2Mnl4L204SmtK?=
 =?utf-8?B?NGprUldSUTNGYTRBMGNlU1pDUkFtUXVjSUh2T05PeVRQayt1cmJYakoyVTRn?=
 =?utf-8?B?UjJKV1VJQ09pSS9DWDBSZGpPRzhhZUk5d1IyUVRGVmRaa2tkMzB5VjNTUEZl?=
 =?utf-8?B?bFFxbXllSlk1Q1ZqMkhvK29iSGtqWnpYaU5TbGhjZm9lWW5WMWk2RXB1U21L?=
 =?utf-8?B?WmlMWjNGOHB4SjFLa2xTKzlUOFNnbW1kaW5RWlI2blFuWDBaRXl1TmVGbHUy?=
 =?utf-8?B?bkJyVGh6aGNwdHNmKzNiTHEweitMUlpCZUNmaSsrUmg4Ynd4cG43MExTeEpO?=
 =?utf-8?B?dzdKUGc2SWdPK3JxNFpCNms5eWc3UnVKN0lqRE04c3pqejdYY1NtNGRScmVM?=
 =?utf-8?B?NFo2YlpHYjBSQ2cvRGFsR3M4eWswc2xWWUNxVm04TDNuanpUek9nVFZBYzZJ?=
 =?utf-8?Q?b9ZPRCiZRmZo19fdf9obOKoV4l9+WKRi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVJmNXh1b1pWVTk3YjJ3WmtEMVZiT29nVEJXdkNnNG1aTFM5ZjNsU2dYemRY?=
 =?utf-8?B?T3FnRzNVTmw5NnpwTXJpQkZBOHprYUF6bC9SZVBEbjNOTmNpRUFhTHZCVWNx?=
 =?utf-8?B?NTQwdW44UXFuNmV3WG0xbk9raTYyMDlVYTM3dVk5ZDMxdm5SNlRXQys0ZStH?=
 =?utf-8?B?dEY0UExPVEpHakpKZDRJZFlDakdnUUwzTERjRGpPVHhkUFRTR1JOczNrTm9u?=
 =?utf-8?B?S0RyRGQ5cVZGSk9SemRnaVl5a0QzTWFIQ3p6SG9jREpXVEI0M0d1WFlQY0Yr?=
 =?utf-8?B?V0QvMTdZV3BZZ00rV1JVK1hvYjBIVjVWckhCeERueitKa2V1RXJ3UG05dlFt?=
 =?utf-8?B?YXJ3d2tUdUE0Zk54ZVVBMDVmOWlVVnFmZ2x6bXkyamZzK3JhanJYWmQxT0J5?=
 =?utf-8?B?MDkxMms2Nm1vbHc0U1pkUk5GY1VRTEtucFNFdkJPTjlIbzhaTVpBdllRaE5M?=
 =?utf-8?B?Nng5Q1o5TmxDblBvbEpmMTJUYnZzRmxxdExseVBhUFNBUVNEZGVvaDMwd1NU?=
 =?utf-8?B?ZFp4TVB6YW1uRTRkUHpTa0Nhd3dlODhpRzRhWFVoWVQvRHlaMFRBQ3ZpbzVn?=
 =?utf-8?B?NUd6bmpPalN0ZEM4ejBGbDVDYkgycGRZRFFGNkF1b0VSVXo0ZkJyZkhGS2NN?=
 =?utf-8?B?SGdOV1lya3drNWlQamQ1MTdJelpKMGZRZnBuQkd2ZmdiYWl0M0o3bHpzTUdO?=
 =?utf-8?B?Mi9lSi9uTWpuSG9rRGkzVlNuREFwRDBUVVV6ckVWOVNkTURIZjU3MExpUEg4?=
 =?utf-8?B?WjlQTENuRHU4Smc4elljMHVpbURDdWR3Y29nU0NlUmpyNW91dXh0MWpQVys0?=
 =?utf-8?B?OFNCb0h2dTBVdExQQVFFeHdUQm9YOGVTT25KMHJFeFZObjBwNk5zaGI4OGF0?=
 =?utf-8?B?VDJGdDk1L2JUU1NDc2QwUEpTQ1pQNVNHSkZpV012dkdXc1FZc1BjWEZ3cm1y?=
 =?utf-8?B?dVdldmpwTGgyRGphaTM3VGh3ZlBhNGhEYmxBVmlyM1I5T0Jab2pqT1o1QW9U?=
 =?utf-8?B?eDVHTDZtSUV3VzZhQlVBSGlaVUhiWlVjMk5IOFd3Zy9UYkFzQ0RORm5SZE4v?=
 =?utf-8?B?RVM5cFFzWEMxM2xvTlM4MDdjbHptbTN5Yk1lakVlQThHbTk3cS9FelRFVXhr?=
 =?utf-8?B?Q3pSRUJkMVp6cmpaVlMxT1MzMFhkN25iM0pqejdOcytDNENRcC9ISzg1NXBt?=
 =?utf-8?B?ZW9NaVJGRjl5UytkTnl2VTNaUGN3TGJDMWRVZUEvRm0xeSsyQnJPajFkdldS?=
 =?utf-8?B?ZFRDV3Y3eHhDSW92NHFJSGRwRllTQ1loekx0aEMyUEVDSS95VHkyTnRmczYw?=
 =?utf-8?B?SEhYOG50aHVjLzFVZ2pBM0MxU2J6M2FOcldLUytSeDNudXpudnI4VlFnU0Nn?=
 =?utf-8?B?amVBSUZ1VW5xbTkwd3NpcytvdzdwSTlOTFRyaXAybnVGQ25OR3p6MEpHa3JL?=
 =?utf-8?B?QThzUlovVDJxcXYycGtNRlVOeWN6eFhTcjd4b1BNcStpQkZ5VUN1Z0ZOY2J2?=
 =?utf-8?B?NnpmWThZekd6S21GZWFncmRHeUxZZ091bFNML3RJZnZuZmEyS1NKTFJVbWh6?=
 =?utf-8?B?NmdxV01KNGNueFp5cG5EZk9oclNNUkpyVjRPcHpPS2g4U2dIMlVjMTFtNWNE?=
 =?utf-8?B?MTA2OTBtU3F0WVFNUFYyOE15MU1qWU5INEVWRmhuekxITFdUdUkzYlA2S1pJ?=
 =?utf-8?B?TWNGVjlkL2xMbXYvbXZWODIxS1JKYVFtR2FSOGE0OUFKSHdkN0ZSdmwrL00x?=
 =?utf-8?B?cC80NmJNOHJISnkrLzcxMHMrRTlQbDgvL0lrN2FPNXFaekYweUp3MVA0ZXl2?=
 =?utf-8?B?b3NEQWhmNS9YN2lPa1dzVkhOaG1rRHpzWUhVM0F1NytZSHZTZnp0alNjdlB3?=
 =?utf-8?B?Z3RlMnAvb0lMQ0dOZXpqRkRmTG1pcTNUM29FTGtvWlBQMHhhMTB6SEFoUHor?=
 =?utf-8?B?UXg1T2NsRnNjc3E0dW0zU3lTcDBOOVZZaHhMcXJjaWRON1k1QjJaSTlHMWFB?=
 =?utf-8?B?ZEFZcndna1JxR1JWbVdmU0dkMFR3OG0yZDJNRFF0emJXSGVEby9uTnRNQStz?=
 =?utf-8?B?NjhBcXVZd0pHRlhwUE53anRIdHpjVXkvdkNRUDRZOGdHWjBjWTlvZzRBMlpL?=
 =?utf-8?B?a2xpd1hyZXl5VmVmMlhLVUM1a3VHTDhnRXhkS09ra1RDQ3NhdCs2RVpHRWx2?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oobzbr4Qy6d75hCRmc1b5tabr551gc53P0z6yoP2Kh2mEPvbmeKavDj0ZkAPd5BhlpwBB/KHKzMkKr+p+ndHCCRGDY2GbaQfDlvKp/e+bAEuTcAUTbappgCUj2Aputo/PV0pE+A+Nl/t98Vhazx27DVSvimfbWuYIMRBe0W3xfSdYj/eSPFBNiErVKbCseOn2kLefwVVVNs3DTFZS9l57c+cSeAs3VXB+IqqHkTCi7MqqyzDpinHsKJdcMOXj67U7oSGGGB9w1o9Az9r/3JFmHra6iSxXVWJsb7f/8ptv2GLMiuLPAhxPEtV/cRFEpDsV/fiDSbf9fm6TkGunizNPoaX9+f/lhfVLg71u4/gk1C7w0uAOXUY/9iVxrCVbkZgJXtjQr2bDSd/RyDX5OUqwcP8OBo70Hay6DkWXWWox0xe3QV0FrQHo+GZQ0apXxwbUoKE/fQA9t8HvzTkFmtgMsM6wDhPGHpVLULQfU8cqg0b0y+LB3+p7hnh/ZwRbDGm6lIncim6E2Lnc4eqLQsGTGAfB+q7htIjZGfG1xJIJ8KkXMUBKcoholk8BkHxN9nrjbD7UOD9TIA8BTlggn9nts9415Fk7a/igjQak//bByA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7721eb97-1710-46cc-eea6-08de0b8b9715
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 01:38:49.8157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8qUU52sNgys+8elhByAsje/EZ4FlgrVTKsnK5zuwkYqJJHm71K9CJM+unFRDjFmhfEBfvw7+3t98GjShccoIW/R9DdxVn6AGYyveCN3by4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6543
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=844 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510150009
X-Proofpoint-GUID: Yr6DIqceE-wZViDckGDvkgc2IguRjqrr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfXx9inS6R6l4TC
 OBs6mcVdSo+XpOcNgLy7j/L0MSZ+nhqLS/Q0gzA1tBYM87l/dWR3CfrYIiZT00GGLZ5EE7k76T9
 aMCr+4hxQf+saxzQlUrgCphRCHIx2D273a/ztdbyAcgtCxQ4lCvl9dz/SJsuiPOtnnDfgIF/9m6
 7jwcKdbwDvDXEZxz2I15kzQ36tBzFslkJLbnkyxnahxZKU8F7gx26tILm76UFBUcXhlk9LZZQvD
 CNTs7flDxy8ZVDi9j7+fSiu10jlwI9bWZ3RcM77NfXoW+PvC788T6SWTkgrkcMoB8KJJlkgtfpv
 qQZFMVWhWjPSAUJdaT/5BYso0n7Tz4DYHuQPHR86F3RJtQryRMs2+rbTcET7Q6XiUVc5iU6Yqql
 n96yw1hnS+G3oK0y+FE+AbLgVhwiCLorw6WU/x1r3xJH+zf3Upo=
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68eefb2e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=APdTsy1mPjVvL4qEmPYA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: Yr6DIqceE-wZViDckGDvkgc2IguRjqrr


Andr=C3=A9,

> The UFS controller can be part of a power domain, so we need to allow
> the relevant property 'power-domains'.

Applied to 6.19/scsi-staging, thanks!

--=20
Martin K. Petersen
