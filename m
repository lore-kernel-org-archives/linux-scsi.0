Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99950369204;
	Tue,  3 Mar 2026 07:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524273; cv=fail; b=XQpzLwTFMUG1IM9L6M2JFLnj3jj5dkMP1Zgojo70SW97ZXNx1qcPcVQL1LY4skJlLjVerdRhhC/P3tMjLfuPfTI8dr5MgP4wm3SkIvewQgCaYZjn9uL16ak/aM+mdpfxzhxAI1R5XaPllkDPwMHoen4tEUkk+NGULKhpgFjZBdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524273; c=relaxed/simple;
	bh=gttoEdU+dQsG21awCmASdKHPuIJj854l3PZCavl9PTM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JhA7JCVoW5iDjVnPYIZID2NnGmcxxhoCTrm0mpiu2JB3N/16FSLBHRDQ8icGu5IqWXdUWI9ohN+9H4aKPu21MkiHOnLp6AuXN4aT8FMOjybqXaU/JbKDgNKGjfwx2JHI9eg1DCxXboBfNlxoW4hP8cqaTlcjGgNkfNVmIakiD2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=McdbybID; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FmwJ8mOr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="McdbybID";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FmwJ8mOr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6236vXK02871268;
	Tue, 3 Mar 2026 07:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R89gW1+NbXQxagvyRliNwZ0G0t3i9WJbz7sQM1Jejz0=; b=
	McdbybIDrVPNhYVH/1ZVUEBTdRjjw8MALd2P0kHblzRK7T+tTE7c2A2KU7xd2d23
	ZZqqnpTGGvcazGLz4t6qZVoJT4FCnPSnhC0uZJPuUdK5lklUKCOHPgAYoyS3GYZE
	P0YlR+29lwOQnT276Mwg6YFYPcensbHmf0rj1KlKef722BQGD/IQgfAP+zKpJE3F
	8NpxlzeNLE0YqVdU6spBXJTBg3asGJ3dpmi3/9mVEpPAbYMxUAhOkmeLCphG42Q6
	oXbn3ALmL6zfzPzt0PTvDKnfeFnxIFSPnHQFLU/isAMrnlug4bqnCoe7Uev9HR7i
	fkNjTzPwHKNJ/2NStfyIew==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cntu0r2bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:50:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62378TeV034716;
	Tue, 3 Mar 2026 07:50:45 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpte0rbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:50:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ieg7HPBBQBDlJZ+oIO9G4aMIbLRxVW29H+ahrvwXp5zLeS2CECiiIKSVnnun+JhFi2qd0W0u0FyVlU0SiQ9ikwVLgZb2acfH4AHgUttjqBVUZXWF38XK+uJi6ZqzYxxGfKQhWgIZ/jE9OdSFsJL1PBvvHKwarFrSzQv2nDc0/BL5H8hSOQQL8Ifl/0dKwad3rZxyqykrYX4zzrKcEFnpQ1p/pZ1wetaMI3ee/AQytwL0bt+iLC64+XOUeCuOmTjHjUPxHY+MWu5X23qM/rKuO1yhYEymUkTsDN0n9GfobunHl3O6Qd7T0XGJ7GvMg+skcqVgj8qTKpD65caZWJyvUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R89gW1+NbXQxagvyRliNwZ0G0t3i9WJbz7sQM1Jejz0=;
 b=Zj8zIKmFQwNpGJfKhFHQhC/7ssOMMeu0sNi+2zlNqG+bKHkGEKInVsi8rRABGxhSLbIlctZiJ7RsHlbjhNp0d8Uo4VQDgE2jofC60mIsYstXFTvfyytOwLgU2yJA516IPMAhKSehpzb0U2zqAd6dtACxmADz2p3iQDZJWqa9eBV8m1nOh6zvh87KnESmAECwrG6JYJ3yTMAWQCOrMB483E5yu4AI59X5z24mmp6PzDB4Vm3cOo63W9V4gCnlXfozddKr19Y8yJmLUEf89Vwa0zq6R6w1Qo18XfpZd+mqscm2DOOTZnIkfAGL5K0REifgylkT61fpFpl0E9WxgBFaGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R89gW1+NbXQxagvyRliNwZ0G0t3i9WJbz7sQM1Jejz0=;
 b=FmwJ8mOr4EJaiXvWs7pEsf+BxLm15CxHPy+wAEsNn0UjlndgY3ThpCFggKU73kq5H2FIkYd59NJndp+IkVWim+n66Ry7+/gwwWkTnpBWGq7Jhn0C0jfkIH9GabcTBdqepw+twvumeIFzW7Iw4bdSH4fC8LMKPwL6TjFyvRxRPSo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4965.namprd10.prod.outlook.com
 (2603:10b6:408:126::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 07:50:42 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 07:50:42 +0000
Message-ID: <79e229f5-703f-47d1-918e-192b4b12958b@oracle.com>
Date: Tue, 3 Mar 2026 07:50:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/24] scsi-multipath: introduce scsi_device head
 structure
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-4-john.g.garry@oracle.com>
 <0809867c-796a-4bf1-a868-7ec64504723d@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0809867c-796a-4bf1-a868-7ec64504723d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0690.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 96ab0b3a-edf1-453e-471f-08de78f991e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	AJdLOHm6ohNenNnAoYtO72qUBwicRUs7wk/OhCmoslJbDZ0VoR4+v2ucpB3DiHKFjRsjZLNEXKI+iURU454/btRWkqkgQxhu2ckK1D4KUUeUf9iLkC0X9RX07LdShe6QrLuz8aUkEDh3Tbyl+z/Q8OCcj7WymvooK6HYQyYxC1QRMdP1HLlhxpKCODzYFxmUnk3XARCdO9ZHeFDbC+iNXsvcEuOmUtlPQwwP68DLEgnmmPnbp7nqWSwBfNad3N+d4WIdObzlugJ8U3d7kvSvpkCU8YiBNUqKvCDuVMPz+V9S8S1LMkboy2WcBd6aBIBlXImhjixUbcrU4ryRsNuI9uLSbdp1kwcmj+1VSiw4xaU2jI9XsgQqezaF6EY6buKnAw3cQrP3Xu79kyi0mm1oF4PgvuJSG3DKOkVgaelkq/RfThBQ2ZPXv4LO0i99q8dxfGJC5yPj2EOVHfhJNCwGX06VJsKrz0mCdLAT6tJCIvn/B1N5kxKcjLo75puD5B/lw52Waf/jZI9tVPEqbcesCcj9jTZlMNgRfdDHmp8nvOeXjwxYm6dqu3e2YV+SxOkbLb4paC21O3zH3LXPXEGsBsFQm+vhpbhNFmUUftPhpK+2aHoWPGMxwpmR3OipGklmcJR9Hrb5VA+DNORyiYfMUGwU6gixH+bt2Ro4BAvdrL1ke7oIPaNu4Bl6TiTM1VLsEEGD7eG/k8IRXtqoONb5cUeeh8RgYmr6+Zbw2F1RG2I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVB0UFVQTlB3MTZseWVzNU94Uk5ibTVyRHNtMVlrYUt4MTk4MHdWbjRzb0JJ?=
 =?utf-8?B?VHArSDFXTlJPZHNOd3BCYzRTSWY0Yk8vQi9uM250aml2UGZydC8yNFBMdCtu?=
 =?utf-8?B?bWNqc1JlazRlR1B3aGdUYVpDK3NqYnNPOWtLaWk2VEdXWEtkUENvRkZHay9r?=
 =?utf-8?B?YU9OT0JRMy84cENObFRNRWxaMlJPc0Zta2VmNGNCa0ZhM3Vic29keWZ5c3hM?=
 =?utf-8?B?aFdxVTh1VUdpVFhVbTE1YUc2dXd6Q0xVbXVYMzNzZE5Fc010SzhvTk51czVr?=
 =?utf-8?B?MG94aFhlQm85M3JKNGtKM0EzN2lBejBRY2tSMUpRVVA4d3UxOU5NYXp6STZL?=
 =?utf-8?B?L3g1dXBtV1o3Q1E3cVM0RVBGaWt0dnJuV2QyUTdUN1dxKzFZemFNczk3d3Nw?=
 =?utf-8?B?Rkd5R3pOTks3R1kycUpoeTJha09LVnIwZFhjRWhGUGFqYW0zZEZMQk1Cc1VC?=
 =?utf-8?B?WkV1V1NYT1oyMUQwNElVS2lZUVNpWHdXdEVHcW9EQTlueXRIeWNDU3VWOUxs?=
 =?utf-8?B?ckI1aGU0enpERGFrYzNxM2RuVHpmMGhwOVY2WWVNT0d0TkYzYmxIL09TUW1U?=
 =?utf-8?B?SzFMVmdKeUpzcFl5dG5JQThza0pLZ2lSRllFWkZmNG9nZ3RZcE5TYWRRT0Vl?=
 =?utf-8?B?YlhqcDYzMkhMWCtYOG9HaXZyKy9kNkJwUkVLMGxWRnZTaEQvOHc1U0ZWZFl5?=
 =?utf-8?B?WldZcFIxek9YSTlybmYrS25ORTFIQzhENXFlL0M4RGZrV2ZZMXZqRWlEcm0w?=
 =?utf-8?B?cWRZa1pjLzhrb2oxZmJ6MG90cnRhN1BBa1hMTjM4MmlsTWJSY3Q1c3hvb0dG?=
 =?utf-8?B?cWVTWW9LQzhoNSt5QjJ0N2dITzA5Wm0zV1pONG11eDYrNFM3YTBlR0JWV2hs?=
 =?utf-8?B?MlBhWTAvLzVwcFVCbDJnaGZjL3VNZ0ZnbEQ2ZXBRc1kyQjdOb2tqdXZGeGw2?=
 =?utf-8?B?OHBKcGI4b2FrS3Y5Sk1RRG9aYWVPRVlIUEk1Z2xiTXYrNm1PWStRaE1DempN?=
 =?utf-8?B?TUNHRDJsZGdkUy84bDF0MGVMbis4eFBWeEVtRWZCZUxGNG02WVJ5bUZlWTFN?=
 =?utf-8?B?M0RUWHR1dVgrYVAzb2tCYlhwZHIyRThNUXcrNWxyMURBSEFZOWw4azAyTkNs?=
 =?utf-8?B?Rk1sMCt0Ty9ZQ1RRcmxLa2sydExiVFMxWTdJRWQvdm50dEJaUExBRjhqWGM0?=
 =?utf-8?B?V0VjVFpyNHQ3VzJhVUhGVjRVRFhDQUNiYURNcVdwam1ma1Bwb09weXF1aXpW?=
 =?utf-8?B?YjJqcDhaNTRBNUhaUVlVNTcvQWhxT0pnU1JLZzZrQ0gzM0JjL29yeGR2S0g1?=
 =?utf-8?B?VkxYRzc0RExqNGtnUGYyazM1ZFpHQmFUVTE5VER5ZWExdWJaZzhYZjFYYm9R?=
 =?utf-8?B?SDhVR1FqMDdOa0tSaVAvWktiVlJYMUJoeTFyTnFmWEhlSGZiSklsdmwyMEkr?=
 =?utf-8?B?K3pVU0xVWk1kNmdJTWlxelA5OFR2YUxid2ZmWjFJbDJURW1rUEMrbmJwN2Ja?=
 =?utf-8?B?UWp1ZVFlajNhcGNUdUJPd1krOXQ5cEZ4MGhDanhReUFNeDAyY0xiQU5hc2hR?=
 =?utf-8?B?dXQvdm5nVW5oU2xzbnErek9JVHhCc1BwSGE0WEhHMkJ2UmV3MFJHOEpSdXRF?=
 =?utf-8?B?Z1d5OEhDMlo4QSszTWtBandRQXJLSjVGL3NQYmVqOFpwck12MWMra3ZnbmlH?=
 =?utf-8?B?NUpZOWxCSVF0RUd5OGUxRWY4aVBRblVVbktkZWlDQW9yOWpuWHpWWVYwZXpr?=
 =?utf-8?B?R0lia1lxdzhYL205OEVzWDRQUDN4alJjeVZpdm1jbGxDZVBiQ2NPWjYySEJo?=
 =?utf-8?B?OGU2dHZBZXQvWDNqMlp2M1MySE45K2dKbnRET0luWHd2SHZYZXFoT1VZdmtQ?=
 =?utf-8?B?VTNjM3lSTUEyYkpjcWtaSmtJaXdLMlprV0FNQS8xUGh1YzhpSjdTQkZvMnov?=
 =?utf-8?B?THBiLzRNc0VzcjNDcnI5YmxFaUN2STViandDSzRveCt4c3J3aVBLN3BFZ2t1?=
 =?utf-8?B?S0xsZ1NidlBDTjdzMEtRSzNjY2Y4WE04V2hXaGNvM0NXQW1MOWZ0bm1OaEhD?=
 =?utf-8?B?V0x6KzBhSG5uNGI4cU4zenFjb2xLc2F6REkrYXJRZnl0Y0cwU0gwSDdPcmVw?=
 =?utf-8?B?NHlzWFpiRllrelRDSDNlWnFPVzUrZEVKOHErZXdmMlVGWFRod0lSQmg2Wm4x?=
 =?utf-8?B?bUhYUXo3TnNuRmpYRW5MUWxBcGJGei9nUTZuMnYzdHk1UWJObXVCbjhYeHg0?=
 =?utf-8?B?d3dPNjFhTmRvS3BSSWllL2FERHJrTEg4OGMvb1dUNms0aVRBT1BHeWl5ZitH?=
 =?utf-8?B?OTlRQUptbVRLcGlRWDVGcDNGdGZ0cWpOZ0huNXZrN2pLVTc4TUhmemxadVgy?=
 =?utf-8?Q?TB5loLv1i1U7pjO8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bretnubO7m0IU/Djc5ja8PTau3aF0VBPPRs0mpuI+Rp846zaFC69waDmGvwBHn1I41iJmOxhietOhh0drXVOelD0Xcqv1e7g2JMBVeOoJ5ucDCcCJVozttjph52ppgDzS0kOfCuge/+41z+UdKF3gRfm4D4h6F3dVWLoFVp2rn8+WvuQOO+jPFPfJUe7esxqJ17UF6P/BwPOU6aYOLHZHDvofk/Jf4k4ibRLwoTtJz5Ded+AbgBp27mV9xnaxTCXl0KRdBbfKVv4BSiX8bYt2qESlYpe6vFxxywE/J5Gxw/Ic9SDrujcHEHRP5Iuw0ks7vTkPDhD3Ps5TQFnrSovcbcxM5tdhNubC4Jgq4Weriz/Ei8xh3dRGJXxSNDz3YkvLV1qcK0dAv7MxaHUsR2FP0ZvpAvtyGXxQ/fukCMMux3K+zmiF6HDLdzmDQ2eAJeX363t8Jt0C11MAcpo3j5HRM2yjbqu1qyw6AL5Qpq8hWIak3pVhx0fe/NPrUgqn7fTTAVFBHMtHx+bDSC2Xp4JHgcI1MuHt0faE3UBUMF8iIhGRKKNwPGWvLjwWZ0TcGzyQzzQEg49f1SRiLNoNuk512TP9udmXotbtl/L2vptXVE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ab0b3a-edf1-453e-471f-08de78f991e4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:50:42.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBZDmnvPEljjKwMYSjhVZ9wkYNMqT4bn+3CKb7v3qS7nWXgwT2YpUALP4mkwPbk8c58T2gnwCCFw267EIMt7AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603030055
X-Proofpoint-GUID: m_EGOZPHMUuNURw8-L5pJZ6QUiE1e-uN
X-Authority-Analysis: v=2.4 cv=Ga8aXAXL c=1 sm=1 tr=0 ts=69a692d6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=qiIkuzhwmfGYmUQR5S4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA1NiBTYWx0ZWRfXzKnIqG8bJP0u
 8L3GTjERdEixnNDsICnOGjJr0AfvfvA4RTHZ2Q+ViYa4eGhtZa7P2N/ND6GX3FsNyV9Ca4TCljD
 8gjnjm3COUft+qPZ/xsS0GIxY0NK1sG9Bpk/cveFQSJwksi9D1iHyILQl7J1zcNzYtHYpPm1R5u
 hlUVktFlvLadsx2/k7Wuwj1BvX+8ssP6WIIvzbVr9B6dJBT50vMmRLB0dziflUqBkUu2yVVT963
 kWStTqbmTcmIzwGT7eOlXRy6BUloiDQ7nVrm0KYhditcxSBuP7seUoLnB/xw2DTkCuJhp/gjrf2
 LEO0ytPwtsoBBLgwB2RkZYj4RxDHLi1sja/jrjBlkzCyu/y/5vjYwTFDIpDig0TM0S/R3mcBMjo
 TLGyBbO259pLWmugWsu1AiJzpp+GZr7EgFR1AzcM/jXflK5/Oe+sGCj1Dsxr62+URYzVLHmcLB4
 5WjE0+r1n9Ltjc5boyOH5FvePy3o0H3nfLxK0Zkc=
X-Proofpoint-ORIG-GUID: m_EGOZPHMUuNURw8-L5pJZ6QUiE1e-uN

>> +    if (!scsi_mpath_head)
>> +        return NULL;
>> +
>> +    ida_init(&scsi_mpath_head->ida);
>> +    mutex_init(&scsi_mpath_head->lock);
>> +
>> +    scsi_mpath_head->mpath_head = mpath_alloc_head();
>> +    if (IS_ERR(scsi_mpath_head->mpath_head))
>> +        goto out_free;
>> +    scsi_mpath_head->mpath_head->mpdt = &smpdt_pr;
> 
> mpdt?
> What's that supposed to mean?

multipath device template, like scsi host template

Please check it in the libmultipath series

> Seems to be like a persistent reservation thing, so why don't
> you introduce it together with PR suppoer?
> 
>> +    scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
>> +
>> +    scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, 
>> GFP_KERNEL);
>> +    if (scsi_mpath_head->index < 0)
>> +        goto out_put_head;
>> +
>> +    device_initialize(&scsi_mpath_head->dev);
>> +    ret = dev_set_name(&scsi_mpath_head->dev, "%d", scsi_mpath_head- 
>> >index);
> 
> Huh? The name is just the number? So we will have a device
> /sys/devices/virtual/1 ?
> 
> The sysfs registration looks decidedly odd.
> I guess we should add a scsi multipath class to sort the devices under.

We do, check the later patches.

I have to admit that I am not a huge fan of the naming, but it's hard to 
find something very good.

There is no common host. Further more, if I wanted to use HCIL SCSI 
naming, then the CIL may not be consistent or unique. I did consider 
using the wwid/vpd id, but that seems so inconsistent.

> 
>> +    if (ret) {
>> +        put_device(&scsi_mpath_head->dev);
>> +        goto out_free_ida;
>> +    }
>> +
>> +    return scsi_mpath_head;
>> +
>> +out_free_ida:
>> +    ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>> +out_put_head:
>> +    mpath_put_head(scsi_mpath_head->mpath_head);
>> +out_free:
>> +    kfree(scsi_mpath_head);
>> +    return NULL;
>> +}
>> +
>> +static struct scsi_mpath_head *scsi_mpath_find_head(
>> +            struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +    struct scsi_mpath_head *scsi_mpath_head;
>> +    int ret;
>> +
>> +    mutex_lock(&scsi_mpath_heads_lock);
>> +    list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, 
>> entry) {
>> +        ret = scsi_mpath_get_head(scsi_mpath_head);
>> +        if (ret)
>> +            continue;
>> +        if (strncmp(scsi_mpath_head->wwid,
>> +            scsi_mpath_dev->device_id_str,
>> +            SCSI_MPATH_DEVICE_ID_LEN) == 0) {
>> +
>> +            mutex_unlock(&scsi_mpath_heads_lock);
>> +            return scsi_mpath_head;
>> +        }
>> +        scsi_mpath_put_head(scsi_mpath_head);
>> +    }
>> +
>> +    return NULL;
>> +}
>> +
>>   static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
>>   {
>>       kfree(sdev->scsi_mpath_dev);
>> @@ -107,6 +178,7 @@ static void scsi_multipath_sdev_uninit(struct 
>> scsi_device *sdev)
>>   int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>>   {
>> +    struct scsi_mpath_head *scsi_mpath_head;
>>       int ret;
>>       if (!scsi_multipath)
>> @@ -127,13 +199,75 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>>           goto out_uninit;
>>       }
>> +    scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
>> +    if (scsi_mpath_head)
>> +        goto found;
>> +    /* scsi_mpath_disks_list lock held */
>> +    scsi_mpath_head = scsi_mpath_alloc_head();
>> +    if (!scsi_mpath_head)
>> +        goto out_uninit;
>> +
>> +    strcpy(scsi_mpath_head->wwid, sdev->scsi_mpath_dev->device_id_str);
>> +
> 
> Do we have a sysfs attribute for this?

yes, it's introduced later

> 
>> +    ret = device_add(&scsi_mpath_head->dev);
>> +    if (ret)
>> +        goto out_put_head;
>> +
>> +    list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
>> +
>> +    mutex_unlock(&scsi_mpath_heads_lock);
>> +    sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
>> +
>> +found:
>> +    sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, 
>> GFP_KERNEL);
>> +    if (sdev->scsi_mpath_dev->index < 0) {
>> +        ret = sdev->scsi_mpath_dev->index;
>> +        goto out_put_head;
>> +    }
>> +
>> +    mutex_lock(&scsi_mpath_head->lock);
>> +    scsi_mpath_head->dev_count++;
>> +    mutex_unlock(&scsi_mpath_head->lock);
>> +
>> +    sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
>>       return 0;
>> +out_put_head:
>> +    scsi_mpath_put_head(scsi_mpath_head);
>>   out_uninit:
>> +    mutex_unlock(&scsi_mpath_heads_lock);
>>       scsi_multipath_sdev_uninit(sdev);
>>       return ret;
>>   }
>> +static void scsi_mpath_remove_head(struct scsi_mpath_device 
>> *scsi_mpath_dev)
>> +{
>> +    struct scsi_mpath_head *scsi_mpath_head =
>> +            scsi_mpath_dev->scsi_mpath_head;
>> +    bool last_path = false;
>> +
>> +    mutex_lock(&scsi_mpath_head->lock);
>> +    scsi_mpath_head->dev_count--;
>> +    if (scsi_mpath_head->dev_count == 0)
>> +        last_path = true;
>> +    mutex_unlock(&scsi_mpath_head->lock);
>> +
>> +    if (last_path)
>> +        device_del(&scsi_mpath_head->dev);
>> +
>> +    scsi_mpath_dev->scsi_mpath_head = NULL;
>> +    scsi_mpath_put_head(scsi_mpath_head);
>> +}
>> +
>> +void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +    struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev- 
>> >scsi_mpath_head;
>> +
>> +    ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
>> +
>> +    scsi_mpath_remove_head(scsi_mpath_dev);
>> +}
>> +
>>   void scsi_mpath_dev_release(struct scsi_device *sdev)
>>   {
>>       struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> @@ -142,8 +276,21 @@ void scsi_mpath_dev_release(struct scsi_device 
>> *sdev)
>>           return;
>>       scsi_multipath_sdev_uninit(sdev);
>> +}
>> +
>> +int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
>> +{
>> +    if (!get_device(&scsi_mpath_head->dev))
>> +        return -ENXIO;
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
>> +void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
>> +{
>> +    put_device(&scsi_mpath_head->dev);
>>   }
>> +EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>>   int __init scsi_multipath_init(void)
>>   {
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 0d69e27600a7a..287a683e89ae5 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1447,6 +1447,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>       } else
>>           put_device(&sdev->sdev_dev);
>> +    if (sdev->scsi_mpath_dev)
>> +        scsi_mpath_remove_device(sdev->scsi_mpath_dev);
>> +
>>       /*
>>        * Stop accepting new requests and wait until all queuecommand() 
>> and
>>        * scsi_run_queue() invocations have finished before tearing 
>> down the
>> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/ 
>> scsi_multipath.h
>> index ca00ea10cd5db..38953b05a44dc 100644
>> --- a/include/scsi/scsi_multipath.h
>> +++ b/include/scsi/scsi_multipath.h
>> @@ -19,9 +19,22 @@
>>   #ifdef CONFIG_SCSI_MULTIPATH
>>   #define SCSI_MPATH_DEVICE_ID_LEN 40
>> +struct scsi_mpath_head {
>> +    char            wwid[SCSI_MPATH_DEVICE_ID_LEN];
> 
> Don't name it WWID. That's an ATA thing. Make it vpd_id.
> 

ok

Thanks!
