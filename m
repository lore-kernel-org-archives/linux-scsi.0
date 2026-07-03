Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010AA3D47A0;
	Fri,  3 Jul 2026 10:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074817; cv=fail; b=qf3CBByhMsMlm/YvQ39fsuuu3O+0UCAyOYZqiutHgq5krmsOUZMcHv/CHGha2Tx/OXsu/EooaLSEeTWGVnds25KGBINmtjLmON6klhqkMsUa2q7f6t5n7U2Q19G/P7DvZuhxC0D3cqpOiHgKWloMDGfawQnR92hOuFFhnc7Vzuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074817; c=relaxed/simple;
	bh=WzEzxvdorYMGN66SqCXhV983H/BkeuTmgZrdkqdn4T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QzAklGZoAQLnVaSGyu043klQBF1WpkmqRKbbC1VYhPjGXZAAYdEXOFpd4p6RJ5SL8PvBcVw6Wz2qJpH7Ic9KzMze3We87RDUzUE7e7ZK05kxjCDV39pmGEAWW2/faC492gTXcEA9sJ48NPNFTjMAcqa9k5PhUqqJp6s2rQLY6as=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hXb2l2/s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M3tDFeH3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hXb2l2/s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M3tDFeH3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tpro3329559;
	Fri, 3 Jul 2026 10:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dxgRyFUgbpu9jflPaUrnz2YEZapW2WCBUWxZCIidqOY=; b=
	hXb2l2/s+fsKfNYcvYL8IulXRYTnNJJnDhhonxlSAKnV5J1q1u7KvTasv/ZAOS4i
	HFSaSFrxpCS6fuzKCH9j+fRSesB0m4OLRF05VPhF8yw2tk2uXPCf+moCePe/2dc0
	daB2KGa+jlpS6vgTFhnMX+h0GOY2RlBBTQi5VfFbWFpfOIz32H6VnDaso3QMQYox
	5zcU3Ph9Og8yCrHGfr1NvO+07fRjcIgBULOUZh1j771xyf051NAAFsxOYGE3QDXV
	dJeih2lkgHMBOskPZfn65kOmZn32Hs14SKVfn4gAefAdq2nrnnqheZcsTZX34Ob4
	xQ1wOj6wgHmqopF/Lz/KTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkae1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ASXsn035316;
	Fri, 3 Jul 2026 10:33:05 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yugvs9-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVFUzOIQFLDtnmaAYSFhLaRAIqyrOeMyDOiD0oLBjZa18I0n8c7NTK0/m5qQ3tgivQG7nFMZyqqjOKNvnoRlxqjeXg5+qC+Gd6jEDcvdEj2nS7iSpRPifpAwrRuDoY5bJ3XLQP7EEynsvcfXZsHO7jspBe97jYFcRIKR6VtlfMgSOpTBrlRhPvCn0TZOJs862kTiEHdzoYIg5fCU/Gvd38B2qk6al/0lefPiK2dwn0b4V0rVXpRvsJ0O8FbQoutruKvwxOy+A/ABOn5imvNmDIoBvL/yPcfrALPE3iwl7CTnBp2zSd0XZc5HLvFpUVJwik0OiW9qJ4w0wwNp8uDN6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxgRyFUgbpu9jflPaUrnz2YEZapW2WCBUWxZCIidqOY=;
 b=Bg4A9BZee9dt3kQlcRXw8HBJCrxW7rXdF0blQrWuPD7277Gf/VKeRlUiylgeEWGKAqP2XFHpulxA/tL4I01clwgzmvthGLVM8++uL5D6/Hx2Z1Ptf70M7F9nCuRd3aO2n4MrKYjM74ry3FYbF1L/whpvfiZhYjbSmlddYAuuhx03+ppIV0XbfWfgFjJ04IZFWWyzrOBmXS/QcZa28sIK5F0QlLq9RDyqnyQjxdI+4cLZEx5YrnvxFr5Teyuiq6M/+/KUYqRTusRaKWgBh7tFtwLOnMJiD18DDRsCNpNbWa7SE/66IRyOsQBRjQe9XYKiO1td3Y1bbRkyS19I3Ra/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxgRyFUgbpu9jflPaUrnz2YEZapW2WCBUWxZCIidqOY=;
 b=M3tDFeH3y2vucMarzmpJ3YPem4sa4F3LMTghkAN/sEaW9MDYnxFv273pnhoIU0yzKkEVAdTadKqszdp6o94ccZ93jXzY0pharDdDKFeGip9RbE6OUpEG3GT4XuMvvcUYYMuH+2B1+/wpM29WV6iNiXk7VIGVz5Rc0hrZYhZvPA0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:32 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 10/10] nvme-multipath: switch to use libmultipath
Date: Fri,  3 Jul 2026 10:32:04 +0000
Message-ID: <20260703103204.3724406-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:8:44a::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 5903684f-5e93-4f87-d376-08ded8ee6346
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|3023799007|6133799003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	yMkG+1I/qYsjaZXDn5sveUB1XlzlLsqtesWztanv2M1L0gOuRfRQGzOMq8IXQmBghly3zx1/J4NVwSxPz6pWvyiyc7YM1I+vxelg0PFw3vad2OplcUiUIfprl17YDNvl31KW7rhXkcDa3nD4rBQUdO5/5SZndSKHpkUgqhRmR+7julbhHBplQhGsKiNwp8jcK+pIjxBGyWKKBOvw9ny9z35KofF8e67npof+0nQGL3zdiyiEOwGCwE4lSThEALs2EHmbEtaoZQjLqbOR+vrMG4eKCpdz38S9wGPbThXKxsQ9mDZblRRaRjARZ7+F/d2mXOkuz1hcSoZmVxMU9i9YNi/UEe377kgLRLdRfFBNHRlrUu8fv4QJubYggnEFsENbz2pLheM1DwDw3Le7ZzIKYegn7atCBOluk82oI7JdeLC7blCHpbcv7SVuQ2KH8lIzU+sScnjZheOaY8t5CL1Z5UTEPVZArab5a1f32CIf9R+Fknieq3TJ0h8i/ZO4OMRFTScbf5lhosnnYFUY3LC+GT/FgYw/Nm0DUQw3Lyc+qBfkMjBxu6B/tap0gQgq9/xmdGCPMIde/zWYLwT0HHdRIncWygwreHTlpl28msdalJ7Dnouwx7d3/FlJt2d2a/2kMUoOjJHoV9j3hSW1gEseMg476FmYKo6R4I3SmsvucxQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(3023799007)(6133799003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dExbhuKQnhnvbKTn4JOke4PYJGV+Zv2nyl2HdmvDXVjetIWFsCl4SfhPQE3Q?=
 =?us-ascii?Q?86ZvrEFT8a+cbE+sgGyomPMVL8MavGP4XriSmjluHp1ayfbLYWmmNuWN6yKg?=
 =?us-ascii?Q?hDlYD0gPxQSZLAjyl9rQV/dXvT5rMUFItWLR2Vi2JDjE+5iWZtsCES0xO9MB?=
 =?us-ascii?Q?1AELKUWfdR+AQ5N4EVjkhDelKMlK+3gMV/MWxVVoWYeogGxTeL15ynHmPBN7?=
 =?us-ascii?Q?XG10w/jTPcXHgO1ofBv8bjwAvBY2XCSXSMSLL59S6hU2m1a+xB5UNxX7oSHL?=
 =?us-ascii?Q?tm2PpBwx/jsMpwVKhnkM0GPPdlT6RhrRR67gCKPvfp6PrtwDOCzlLUL1chq4?=
 =?us-ascii?Q?grbu+TD0oe6EeenIeN0cmVWtbmDTeVzf5VcZ0OOnZ9/DLomLX9gHD6SqiJ8m?=
 =?us-ascii?Q?r97aTNz/gyjl8DK2Dv3aJFdfKgY6L5CjZ3Ym62HVmIN3nwfKw6814AcUeUMs?=
 =?us-ascii?Q?jj+MgXcIMPaO4Nhhuceu6QdtMZaDnFWby3APo+jR89swlQ1mhl1/oAmEfV6M?=
 =?us-ascii?Q?qRIGWH+63842mC7rhuWe9eG+F2EXH5Sn0FT8AaFiAQFjb6wMHLBsr93s9pBL?=
 =?us-ascii?Q?HQ3o4NSDtaeXl/O97js6VtgvZ4YJD5cYHron+aMLpozuzaSEKhOYZGR1d8v8?=
 =?us-ascii?Q?mOOk2h0H83hJG95JtgzjNAXNUdESC+TzxK6Ieg5iV05eLix8eYEFex6X6iCu?=
 =?us-ascii?Q?HhsY84g4QHXVAVt/xM29iBXJSX/15z00TJdztHDSWwQGbiIH9NYxrm7vRWPZ?=
 =?us-ascii?Q?tjakqXM6nS98FVz30crb75KZbuE9Mh4fIPQHNhdMjmcN/yk91QvnzsfgZQo3?=
 =?us-ascii?Q?N8Ay21p13FxeZ/gAOH8tlBmCs08eft3cwUUZZquo6u++DT+1BcMhi+H442hf?=
 =?us-ascii?Q?ooDodm+CtgCozhKixnWNTzuhD1q3MoPoGQ5cVXk7GYFgOsgBZodLAoX+J/4C?=
 =?us-ascii?Q?+6MkHOwEDXWb0r+mqzW3NVwvQ/SwUcG1iT13tJxab6pLtSrkmOYHGYsDX/TX?=
 =?us-ascii?Q?3HugPyA8VP0E4i2YaPc/8jd78Pe7rvdy6LZP8LhM1PhkC5u6Fu40TOecGjtc?=
 =?us-ascii?Q?hCq/YdmXDcyV4t5o7i3jMQ1fuUxG9noZha9PDuXRKzTfuTaBDYByOilOAyjE?=
 =?us-ascii?Q?Tz00v4nRxQlaHeFEj4zeOZU0R8RFpczQmQQIxbegPR+KzVhHkIF1drC1ZeLy?=
 =?us-ascii?Q?4mePfdgOdt8K0q2xj2xuLktK/eewu4BfnrqwBS9qY0XNqRV53+8Bi+nyc7DD?=
 =?us-ascii?Q?jQxaGfTKkf/6pFSJkpfWh4OTrgAF2AuFBzBtx7zKywnNibecG9VKFGC6od8g?=
 =?us-ascii?Q?576vWgcmiKBI6JtZxMjV81PWBAnU4nAdM9TfTCJ+dhcRiZW7u/FmwF7Xrwy7?=
 =?us-ascii?Q?LfvPaZIDbmUnwznhbKUb9mS/OALqhveYkGSyivvFbl/LIGjFDaVRPJpTDmIf?=
 =?us-ascii?Q?DcmAiRvUhY6RVOGHNzQWmW5HVTRUhzs7XgY0tixdkaJgF4Jl/yCjQG3LX2gK?=
 =?us-ascii?Q?EJ0+o8E+PQWNQ32LN2OKfaSwx4iMWHIP8Q2n4Xm4t+NEk4IQGBTgqHqQvEVF?=
 =?us-ascii?Q?DTOn8T29s/Lxd99UBTKus8N0WLnEvKoQDx0M9duyXpAQJ/lHSsybMmkBBFSz?=
 =?us-ascii?Q?OsSwrSLXmw+bXCO9zusl3LRIO+mX6gcSqk11dm+I5Z9uPnYqH4BB5bQSUGoz?=
 =?us-ascii?Q?x46z2a+jlKy8Fb/m7HiRzaFn1KxHVsD5BSF4OpjQAlgqz/MPGmvyY+Aso0Ql?=
 =?us-ascii?Q?fN6prLHumDbrABNg9CB/nBw9f/Wkx74=3D?=
X-Exchange-RoutingPolicyChecked:
	adYH80M54kC/F9qWtmoRnXNecyeGuTwqmyZXu7pmiYhXx+DeCueTvmU00uQVEhUSQ4xI0arksoyiHHIEH8/qvDPOJCn3DkQ0iytCqgE8K60QUZU2hcTzn7nXglW8b24jXTm8vH2CretETWOkLBbFRQWfeTXdC0YkZEO4XujN2xsWC59uSIyo2DKYBmoursdq0BHVTLRpJCUMUPt7pdUhdG5LyEP/PrvTSPe3UG4E64GKw3kfUn6h+Mhhu7PqoYLurrHzz7gih9KEoQKM2ZSJu+evViu9WRwuFi9ImVl+tETibJvzpu96DD4/aOrSO+rCsII0IYy/4gQ2igO2Wr1JMA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	03s79yAWqQ2ev6CTGWfzhiV7zXg68pk9sJuoAiewqVWX1VLm71hSGJuUw2+DRQj8CZeNfvjKLDRR7m+4Ht2kUkD/Ysoq5hENZeiIyQBiiBLlKkLaM1ZKU1ayDFbGLM5TUeg3zhcqc/+ugvmTnNQkjB5uN1jvseFvKwK+zd2aPLyAZA1S6anJQKIvN7AXSsQLLWJbhC+PquxezYHGfOgiGtwyfwoiU+JQ0PjMTnUVecZQtmqV0ZTiUZ4O4Wybw0HRi+6dlieIgd5RAMeAi0lMRgzUyes7/ZJ4JdJXxTJp2yo+axkOsl+Np6tDuKhr3nKc44wJQ2sd/r5VfrV8C1HuK9FEPuwWbQMqvpDEBrO67PmoMv/zQ6Z2scDLPKfX7uKEAxeD1GCLI3V5k2Ijm8+W2QQ61S6EJGDttjabMUg+f/Ceol99AfeEpSDDlfm+QX249qryWDXaUl6tamTNTL005YuJv68U0DmWi8Y+Y6/4RwYEc7OKhy3AcqMSQRlubLdHcBvAsBHJVkt5wBpFexNWFS1srRRc6dW9Mva88hdgBvif70Rnu0tT8S3M7ADUZizAG4J/Fkc0ou6UAooe8l8f5mB3lQF6YaFD8XetwHbrhrE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5903684f-5e93-4f87-d376-08ded8ee6346
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:32.0493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAuFDiGRzBg19ypjsZKIUheoJtxzY6h/Sdpfvlx1NlDjJR/MiE6HScI1czYPTTNsLnnL2Toho6WIH2DBVJWOOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXwSdv6fg2irB9
 oQOVk9PMTadyYf6AQx1M4eQ/EjKNfJIjqac7kybnI772xyvqr5tT7NbIq8mNzKEKNRCEGLzg98D
 OsEGzVQjomBphMINb9e0VVIbYIJmTYRJSo8vKdM4pP2geWmRKmDz
X-Proofpoint-GUID: K7DY_DpxO1V5W2v02dKZIQtFazN3B3BD
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a478fe3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=8ydvOSFVltsESA4SfdcA:9
 a=8hRSuSPRCByYGjIZ:21 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13723
X-Proofpoint-ORIG-GUID: K7DY_DpxO1V5W2v02dKZIQtFazN3B3BD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX+KwYvX1Twm/Y
 ykxp1BnqCpC22HwmPdMGhGTRP8oTAY8FLJoM3pQcQ2Y7X8kEVtWpIuZzVawghR2P3hymItwddci
 DxNuGSl1zZWtCIMvPKQPTTmfrYnxCKkjXmtyjf7qFnfGsfGswoOMLWqPVfA80q76rqWpLvPbW92
 T7F1M++D3YYpPQ87LOIpoDBCgwqlqWJ7L7PYXS/PU4urb9z5YohE8Z6xsyiB2aeOOj/q18pQNK5
 XBWLw7xKfOFsQOL1ad+t8WBAgOsneasLpGIpuqdDq7SD5nRWPaeP8F2b5eB3k6L57QTItileg6B
 INCmQIIzCd+T+3fDh++mzxzJ0ea6xUJFVF71QnvIoC41Eta6ON17O+4VEoplb8ILJ+9SWYKuIo5
 qoD5eHs/G74bVji5KWZ3h39W+1sV++z6NftYuVyZwb+Tg7N23UyZqbgbObnWrQD5FsnDQyp5a9u
 lMKl4YS7TqNJdtsmatgqEMS0C6o9/CApxtNCIw/w=

Now that much unused libmulipath-based code has been added, do the full
switch over.

The major change is that the multipath management is moved out of the
nvme_ns_head structure and into the mpath_head structure.

The check for ns->head->disk is now replaced with a ns->mpath_head.disk
check, it decide whether we are really in multipath mode.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c      |  89 ++--
 drivers/nvme/host/ioctl.c     |  91 +---
 drivers/nvme/host/multipath.c | 921 +++++-----------------------------
 drivers/nvme/host/nvme.h      | 104 +---
 drivers/nvme/host/pr.c        |  18 -
 drivers/nvme/host/sysfs.c     |  89 +---
 6 files changed, 238 insertions(+), 1074 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 453c1f0b2dd09..476a0cd2452ce 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -413,7 +413,7 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if ((nvme_req(req)->status & NVME_SCT_SC_MASK) == NVME_SC_AUTH_REQUIRED)
 		return AUTHENTICATE;
 
-	if (req->cmd_flags & REQ_NVME_MPATH) {
+	if (is_mpath_request(req)) {
 		if (nvme_is_path_error(nvme_req(req)->status) ||
 		    blk_queue_dying(req->q))
 			return FAILOVER;
@@ -454,7 +454,7 @@ static inline void __nvme_end_req(struct request *req)
 	}
 	nvme_end_req_zoned(req);
 	nvme_trace_bio_complete(req);
-	if (req->cmd_flags & REQ_NVME_MPATH)
+	if (is_mpath_request(req))
 		nvme_mpath_end_request(req);
 }
 
@@ -687,7 +687,7 @@ static void nvme_free_ns_head(struct kref *ref)
 
 	nvme_mpath_put_disk(head);
 	ida_free(&head->subsys->ns_ida, head->instance);
-	cleanup_srcu_struct(&head->srcu);
+	mpath_head_uninit(&head->mpath_head);
 	nvme_put_subsystem(head->subsys);
 	kfree(head->plids);
 	kfree(head);
@@ -778,7 +778,7 @@ blk_status_t nvme_fail_nonready_command(struct nvme_ctrl *ctrl,
 	    state != NVME_CTRL_DELETING &&
 	    state != NVME_CTRL_DEAD &&
 	    !test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
-	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
+	    !blk_noretry_request(rq) && !is_mpath_request(rq))
 		return BLK_STS_RESOURCE;
 
 	if (!(rq->rq_flags & RQF_DONTPREP))
@@ -2557,11 +2557,12 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 
 	if (!ret && nvme_ns_head_multipath(ns->head)) {
 		struct queue_limits *ns_lim = &ns->disk->queue->limits;
+		struct gendisk *disk = ns->head->mpath_head.disk;
 		struct queue_limits lim;
 		unsigned int memflags;
 
-		lim = queue_limits_start_update(ns->head->disk->queue);
-		memflags = blk_mq_freeze_queue(ns->head->disk->queue);
+		lim = queue_limits_start_update(disk->queue);
+		memflags = blk_mq_freeze_queue(disk->queue);
 		/*
 		 * queue_limits mixes values that are the hardware limitations
 		 * for bio splitting with what is the device configuration.
@@ -2582,22 +2583,22 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		lim.io_min = ns_lim->io_min;
 		lim.io_opt = ns_lim->io_opt;
 		queue_limits_stack_bdev(&lim, ns->disk->part0, 0,
-					ns->head->disk->disk_name);
+				disk->disk_name);
 		if (lim.features & BLK_FEAT_ZONED)
 			nvme_stack_zone_resources(&lim, ns_lim);
 		if (unsupported)
-			ns->head->disk->flags |= GENHD_FL_HIDDEN;
+			disk->flags |= GENHD_FL_HIDDEN;
 		else
 			nvme_init_integrity(ns->head, &lim, info);
 		lim.max_write_streams = ns_lim->max_write_streams;
 		lim.write_stream_granularity = ns_lim->write_stream_granularity;
-		ret = queue_limits_commit_update(ns->head->disk->queue, &lim);
+		ret = queue_limits_commit_update(disk->queue, &lim);
 
-		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
-		set_disk_ro(ns->head->disk, nvme_ns_is_readonly(ns, info));
+		set_capacity_and_notify(disk, get_capacity(ns->disk));
+		set_disk_ro(disk, nvme_ns_is_readonly(ns, info));
 		nvme_mpath_revalidate_paths(ns->head);
 
-		blk_mq_unfreeze_queue(ns->head->disk->queue, memflags);
+		blk_mq_unfreeze_queue(disk->queue, memflags);
 	}
 
 	return ret;
@@ -3967,25 +3968,18 @@ static void nvme_add_ns_cdev(struct nvme_ns *ns)
 static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 		struct nvme_ns_info *info)
 {
+	struct nvme_subsystem *subsys = ctrl->subsys;
 	struct nvme_ns_head *head;
-	size_t size = sizeof(*head);
 	int ret = -ENOMEM;
 
-#ifdef CONFIG_NVME_MULTIPATH
-	size += nr_node_ids * sizeof(struct nvme_ns *);
-#endif
-
-	head = kzalloc(size, GFP_KERNEL);
+	head = kzalloc(sizeof(*head), GFP_KERNEL);
 	if (!head)
 		goto out;
 	ret = ida_alloc_min(&ctrl->subsys->ns_ida, 1, GFP_KERNEL);
 	if (ret < 0)
 		goto out_free_head;
 	head->instance = ret;
-	INIT_LIST_HEAD(&head->list);
-	ret = init_srcu_struct(&head->srcu);
-	if (ret)
-		goto out_ida_remove;
+
 	head->subsys = ctrl->subsys;
 	head->ns_id = info->nsid;
 	head->ids = info->ids;
@@ -3998,22 +3992,32 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	if (head->ids.csi) {
 		ret = nvme_get_effects_log(ctrl, head->ids.csi, &head->effects);
 		if (ret)
-			goto out_cleanup_srcu;
+			goto out_ida_free;
 	} else
 		head->effects = ctrl->effects;
 
+	ret = mpath_head_init(&head->mpath_head);
+	if (ret)
+		goto out_ida_free;
+
+	head->mpath_head.drv_module = THIS_MODULE;
+	head->mpath_head.disk_groups = nvme_ns_attr_groups;
+	head->mpath_head.parent = &subsys->dev;
+	head->mpath_head.iopolicy = &head->subsys->mpath_iopolicy;
+
 	ret = nvme_mpath_alloc_disk(ctrl, head);
 	if (ret)
-		goto out_cleanup_srcu;
+		goto out_mpath_head_free;
 
 	list_add_tail(&head->entry, &ctrl->subsys->nsheads);
 
 	kref_get(&ctrl->subsys->ref);
 
 	return head;
-out_cleanup_srcu:
-	cleanup_srcu_struct(&head->srcu);
-out_ida_remove:
+
+out_mpath_head_free:
+	mpath_put_head(&head->mpath_head);
+out_ida_free:
 	ida_free(&ctrl->subsys->ns_ida, head->instance);
 out_free_head:
 	kfree(head);
@@ -4052,7 +4056,7 @@ static int nvme_global_check_duplicate_ids(struct nvme_subsystem *this,
 static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 {
 	struct nvme_ctrl *ctrl = ns->ctrl;
-	struct nvme_ns_head *head = NULL;
+	struct nvme_ns_head *head;
 	int ret;
 
 	ret = nvme_global_check_duplicate_ids(ctrl->subsys, &info->ids);
@@ -4111,7 +4115,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 	} else {
 		ret = -EINVAL;
 		if ((!info->is_shared || !head->shared) &&
-		    !list_empty(&head->list)) {
+		    !mpath_head_devices_empty(&head->mpath_head)) {
 			dev_err(ctrl->device,
 				"Duplicate unshared namespace %d\n",
 				info->nsid);
@@ -4133,14 +4137,10 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 		}
 	}
 
-	list_add_tail_rcu(&ns->siblings, &head->list);
 	ns->head = head;
+	nvme_add_ns(ns);
 	mutex_unlock(&ctrl->subsys->lock);
 
-#ifdef CONFIG_NVME_MULTIPATH
-	if (cancel_delayed_work(&head->remove_work))
-		module_put(THIS_MODULE);
-#endif
 	return 0;
 
 out_put_ns_head:
@@ -4280,18 +4280,18 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 	synchronize_srcu(&ctrl->srcu);
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
-	list_del_rcu(&ns->siblings);
-	if (list_empty(&ns->head->list)) {
+
+	if (nvme_delete_ns(ns)) {
 		list_del_init(&ns->head->entry);
 		/*
 		 * If multipath is not configured, we still create a namespace
-		 * head (nshead), but head->disk is not initialized in that
+		 * head (nshead), but mpath_head->disk is not initialized in that
 		 * case.  As a result, only a single reference to nshead is held
 		 * (via kref_init()) when it is created. Therefore, ensure that
 		 * we do not release the reference to nshead twice if head->disk
 		 * is not present.
 		 */
-		if (ns->head->disk)
+		if (ns->head->mpath_head.disk)
 			last_path = true;
 	}
 	mutex_unlock(&ctrl->subsys->lock);
@@ -4306,6 +4306,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 
 static void nvme_ns_remove(struct nvme_ns *ns)
 {
+	struct nvme_ns_head *head = ns->head;
 	bool last_path = false;
 
 	if (test_and_set_bit(NVME_NS_REMOVING, &ns->flags))
@@ -4319,23 +4320,23 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	 * Ensure that !NVME_NS_READY is seen by other threads to prevent
 	 * this ns going back into current_path.
 	 */
-	synchronize_srcu(&ns->head->srcu);
+	nvme_mpath_synchronize(head);
 
 	/* wait for concurrent submissions */
 	if (nvme_mpath_clear_current_path(ns))
-		synchronize_srcu(&ns->head->srcu);
+		nvme_mpath_synchronize(head);
 
 	mutex_lock(&ns->ctrl->subsys->lock);
-	list_del_rcu(&ns->siblings);
-	if (list_empty(&ns->head->list)) {
-		if (!nvme_mpath_queue_if_no_path(ns->head))
+	if (nvme_delete_ns(ns)) {
+
+		if (!nvme_mpath_head_queue_if_no_path(ns->head))
 			list_del_init(&ns->head->entry);
 		last_path = true;
 	}
 	mutex_unlock(&ns->ctrl->subsys->lock);
 
 	/* guarantee not available in head->list */
-	synchronize_srcu(&ns->head->srcu);
+	nvme_mpath_synchronize(head);
 
 	if (!nvme_ns_head_multipath(ns->head)) {
 		if (test_and_clear_bit(NVME_NS_CDEV_LIVE, &ns->flags))
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d9eee6e685f96..53def0a1b0543 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -111,7 +111,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	 * failover as passthrough requests also append REQ_FAILFAST_DRIVER.
 	 */
 	if (ns && nvme_ns_head_multipath(ns->head))
-		rq_flags |= REQ_NVME_MPATH;
+		rq_flags |= REQ_MPATH;
 
 	req = blk_mq_alloc_request(q, nvme_req_op(cmd) | rq_flags, blk_flags);
 	if (IS_ERR(req))
@@ -726,95 +726,6 @@ int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
 					issue_flags);
 }
 
-static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
-		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
-		bool open_for_write)
-	__releases(&head->srcu)
-{
-	struct nvme_ctrl *ctrl = ns->ctrl;
-	int ret;
-
-	nvme_get_ctrl(ns->ctrl);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
-
-	nvme_put_ctrl(ctrl);
-	return ret;
-}
-
-int nvme_ns_head_ioctl(struct block_device *bdev, blk_mode_t mode,
-		unsigned int cmd, unsigned long arg)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	bool open_for_write = mode & BLK_OPEN_WRITE;
-	void __user *argp = (void __user *)arg;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-	unsigned int flags = 0;
-
-	if (bdev_is_partition(bdev))
-		flags |= NVME_IOCTL_PARTITION;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (!ns)
-		goto out_unlock;
-
-	/*
-	 * Handle ioctls that apply to the controller instead of the namespace
-	 * separately and drop the ns SRCU reference early.  This avoids a
-	 * deadlock when deleting namespaces using the passthrough interface.
-	 */
-	if (is_ctrl_ioctl(cmd))
-		return nvme_ns_head_ctrl_ioctl(ns, cmd, argp, head, srcu_idx,
-					       open_for_write);
-
-	ret = nvme_ns_ioctl(ns, cmd, argp, flags, open_for_write);
-out_unlock:
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
-long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
-		unsigned long arg)
-{
-	bool open_for_write = file->f_mode & FMODE_WRITE;
-	struct cdev *cdev = file_inode(file)->i_cdev;
-	struct nvme_ns_head *head =
-		container_of(cdev, struct nvme_ns_head, cdev);
-	void __user *argp = (void __user *)arg;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (!ns)
-		goto out_unlock;
-
-	if (is_ctrl_ioctl(cmd))
-		return nvme_ns_head_ctrl_ioctl(ns, cmd, argp, head, srcu_idx,
-				open_for_write);
-
-	ret = nvme_ns_ioctl(ns, cmd, argp, 0, open_for_write);
-out_unlock:
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
-int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
-		unsigned int issue_flags)
-{
-	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
-	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EINVAL;
-
-	if (ns)
-		ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index b27b45c59c883..f4cf2dc2c1e43 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -65,43 +65,16 @@ module_param_cb(multipath_always_on, &multipath_always_on_ops,
 MODULE_PARM_DESC(multipath_always_on,
 	"create multipath node always except for private namespace with non-unique nsid; note that this also implicitly enables native multipath support");
 
-static const char *nvme_iopolicy_names[] = {
-	[NVME_IOPOLICY_NUMA]	= "numa",
-	[NVME_IOPOLICY_RR]	= "round-robin",
-	[NVME_IOPOLICY_QD]      = "queue-depth",
-};
-
-static int iopolicy = NVME_IOPOLICY_NUMA;
-
-static int nvme_iopolicy_parse(const char *str)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(nvme_iopolicy_names); i++) {
-		if (sysfs_streq(str, nvme_iopolicy_names[i]))
-			return i;
-	}
-	return -EINVAL;
-}
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
 
 static int nvme_set_iopolicy(const char *val, const struct kernel_param *kp)
 {
-	int policy;
-
-	if (!val)
-		return -EINVAL;
-
-	policy = nvme_iopolicy_parse(val);
-	if (policy < 0)
-		return policy;
-
-	iopolicy = policy;
-	return 0;
+	return mpath_set_iopolicy(val, &iopolicy);
 }
 
 static int nvme_get_iopolicy(char *buf, const struct kernel_param *kp)
 {
-	return sprintf(buf, "%s\n", nvme_iopolicy_names[iopolicy]);
+	return mpath_get_iopolicy(buf, iopolicy);
 }
 
 module_param_call(iopolicy, nvme_set_iopolicy, nvme_get_iopolicy,
@@ -111,7 +84,7 @@ MODULE_PARM_DESC(iopolicy,
 
 void nvme_mpath_default_iopolicy(struct nvme_subsystem *subsys)
 {
-	subsys->iopolicy = iopolicy;
+	subsys->mpath_iopolicy = iopolicy;
 }
 
 void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
@@ -120,8 +93,9 @@ void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
 
 	lockdep_assert_held(&subsys->lock);
 	list_for_each_entry(h, &subsys->nsheads, entry)
-		if (h->disk)
-			blk_mq_unfreeze_queue_nomemrestore(h->disk->queue);
+		if (h->mpath_head.disk)
+			blk_mq_unfreeze_queue_nomemrestore(
+				h->mpath_head.disk->queue);
 }
 
 void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
@@ -130,8 +104,8 @@ void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
 
 	lockdep_assert_held(&subsys->lock);
 	list_for_each_entry(h, &subsys->nsheads, entry)
-		if (h->disk)
-			blk_mq_freeze_queue_wait(h->disk->queue);
+		if (h->mpath_head.disk)
+			blk_mq_freeze_queue_wait(h->mpath_head.disk->queue);
 }
 
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
@@ -140,13 +114,14 @@ void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
 
 	lockdep_assert_held(&subsys->lock);
 	list_for_each_entry(h, &subsys->nsheads, entry)
-		if (h->disk)
-			blk_freeze_queue_start(h->disk->queue);
+		if (h->mpath_head.disk)
+			blk_freeze_queue_start(h->mpath_head.disk->queue);
 }
 
 void nvme_failover_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
+	struct mpath_head *mpath_head = &ns->head->mpath_head;
 	u16 status = nvme_req(req)->status & NVME_SCT_SC_MASK;
 	unsigned long flags;
 	struct bio *bio;
@@ -164,23 +139,24 @@ void nvme_failover_req(struct request *req)
 		queue_work(nvme_wq, &ns->ctrl->ana_work);
 	}
 
-	spin_lock_irqsave(&ns->head->requeue_lock, flags);
+
+	spin_lock_irqsave(&mpath_head->requeue_lock, flags);
 	for (bio = req->bio; bio; bio = bio->bi_next)
-		bio_set_dev(bio, ns->head->disk->part0);
-	blk_steal_bios(&ns->head->requeue_list, req);
-	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
+		bio_set_dev(bio, mpath_head->disk->part0);
+	blk_steal_bios(&mpath_head->requeue_list, req);
+	spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
 
 	nvme_req(req)->status = 0;
 	nvme_end_req(req);
-	kblockd_schedule_work(&ns->head->requeue_work);
+	mpath_schedule_requeue_work(mpath_head);
 }
 
 void nvme_mpath_start_request(struct request *rq)
 {
 	struct nvme_ns *ns = rq->q->queuedata;
-	struct gendisk *disk = ns->head->disk;
+	struct gendisk *disk = ns->head->mpath_head.disk;
 
-	if ((READ_ONCE(ns->head->subsys->iopolicy) == NVME_IOPOLICY_QD) &&
+	if (mpath_qd_iopolicy(&ns->head->subsys->mpath_iopolicy) &&
 	    !(nvme_req(rq)->flags & NVME_MPATH_CNT_ACTIVE)) {
 		atomic_inc(&ns->ctrl->nr_active);
 		nvme_req(rq)->flags |= NVME_MPATH_CNT_ACTIVE;
@@ -208,7 +184,7 @@ void nvme_mpath_end_request(struct request *rq)
 
 	if (!(nvme_req(rq)->flags & NVME_MPATH_IO_STATS))
 		return;
-	bdev_end_io_acct(ns->head->disk->part0, req_op(rq),
+	bdev_end_io_acct(ns->head->mpath_head.disk->part0, req_op(rq),
 			 blk_rq_bytes(rq) >> SECTOR_SHIFT,
 			 nvme_req(rq)->start_time);
 }
@@ -221,11 +197,11 @@ void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
 	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
 				 srcu_read_lock_held(&ctrl->srcu)) {
-		if (!ns->head->disk)
+		if (!ns->head->mpath_head.disk)
 			continue;
-		kblockd_schedule_work(&ns->head->requeue_work);
+		mpath_schedule_requeue_work(&ns->head->mpath_head);
 		if (nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE)
-			disk_uevent(ns->head->disk, KOBJ_CHANGE);
+			disk_uevent(ns->head->mpath_head.disk, KOBJ_CHANGE);
 	}
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -239,21 +215,6 @@ static const char *nvme_ana_state_names[] = {
 	[NVME_ANA_CHANGE]		= "change",
 };
 
-bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
-{
-	struct nvme_ns_head *head = ns->head;
-	bool changed = false;
-	int node;
-
-	for_each_node(node) {
-		if (ns == rcu_access_pointer(head->current_path[node])) {
-			rcu_assign_pointer(head->current_path[node], NULL);
-			changed = true;
-		}
-	}
-	return changed;
-}
-
 void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
@@ -263,29 +224,19 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
 				 srcu_read_lock_held(&ctrl->srcu)) {
 		nvme_mpath_clear_current_path(ns);
-		kblockd_schedule_work(&ns->head->requeue_work);
+		mpath_schedule_requeue_work(&ns->head->mpath_head);
 	}
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
 
-void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
+static void nvme_mpath_revalidate_paths_cb(struct mpath_device *mpath_device)
 {
-	sector_t capacity = get_capacity(head->disk);
-	struct nvme_ns *ns;
-	int node;
-	int srcu_idx;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (capacity != get_capacity(ns->disk))
-			clear_bit(NVME_NS_READY, &ns->flags);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
+	clear_bit(NVME_NS_READY, &nvme_mpath_to_ns(mpath_device)->flags);
+}
 
-	for_each_node(node)
-		rcu_assign_pointer(head->current_path[node], NULL);
-	kblockd_schedule_work(&head->requeue_work);
+void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
+{
+	mpath_revalidate_paths(&head->mpath_head, nvme_mpath_revalidate_paths_cb);
 }
 
 static bool nvme_path_is_disabled(struct nvme_ns *ns)
@@ -310,142 +261,6 @@ static bool nvme_mpath_is_disabled(struct mpath_device *mpath_device)
 	return nvme_path_is_disabled(nvme_mpath_to_ns(mpath_device));
 }
 
-static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
-{
-	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
-	struct nvme_ns *found = NULL, *fallback = NULL, *ns;
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (nvme_path_is_disabled(ns))
-			continue;
-
-		if (ns->ctrl->numa_node != NUMA_NO_NODE &&
-		    READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_NUMA)
-			distance = node_distance(node, ns->ctrl->numa_node);
-		else
-			distance = LOCAL_DISTANCE;
-
-		switch (ns->ana_state) {
-		case NVME_ANA_OPTIMIZED:
-			if (distance < found_distance) {
-				found_distance = distance;
-				found = ns;
-			}
-			break;
-		case NVME_ANA_NONOPTIMIZED:
-			if (distance < fallback_distance) {
-				fallback_distance = distance;
-				fallback = ns;
-			}
-			break;
-		default:
-			break;
-		}
-	}
-
-	if (!found)
-		found = fallback;
-	if (found)
-		rcu_assign_pointer(head->current_path[node], found);
-	return found;
-}
-
-static struct nvme_ns *nvme_next_ns(struct nvme_ns_head *head,
-		struct nvme_ns *ns)
-{
-	ns = list_next_or_null_rcu(&head->list, &ns->siblings, struct nvme_ns,
-			siblings);
-	if (ns)
-		return ns;
-	return list_first_or_null_rcu(&head->list, struct nvme_ns, siblings);
-}
-
-static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
-{
-	struct nvme_ns *ns, *found = NULL;
-	int node = numa_node_id();
-	struct nvme_ns *old = srcu_dereference(head->current_path[node],
-					       &head->srcu);
-
-	if (unlikely(!old))
-		return __nvme_find_path(head, node);
-
-	if (list_is_singular(&head->list)) {
-		if (nvme_path_is_disabled(old))
-			return NULL;
-		return old;
-	}
-
-	for (ns = nvme_next_ns(head, old);
-	     ns && ns != old;
-	     ns = nvme_next_ns(head, ns)) {
-		if (nvme_path_is_disabled(ns))
-			continue;
-
-		if (ns->ana_state == NVME_ANA_OPTIMIZED) {
-			found = ns;
-			goto out;
-		}
-		if (ns->ana_state == NVME_ANA_NONOPTIMIZED)
-			found = ns;
-	}
-
-	/*
-	 * The loop above skips the current path for round-robin semantics.
-	 * Fall back to the current path if either:
-	 *  - no other optimized path found and current is optimized,
-	 *  - no other usable path found and current is usable.
-	 */
-	if (!nvme_path_is_disabled(old) &&
-	    (old->ana_state == NVME_ANA_OPTIMIZED ||
-	     (!found && old->ana_state == NVME_ANA_NONOPTIMIZED)))
-		return old;
-
-	if (!found)
-		return NULL;
-out:
-	rcu_assign_pointer(head->current_path[node], found);
-	return found;
-}
-
-static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
-{
-	struct nvme_ns *best_opt = NULL, *best_nonopt = NULL, *ns;
-	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
-	unsigned int depth;
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (nvme_path_is_disabled(ns))
-			continue;
-
-		depth = atomic_read(&ns->ctrl->nr_active);
-
-		switch (ns->ana_state) {
-		case NVME_ANA_OPTIMIZED:
-			if (depth < min_depth_opt) {
-				min_depth_opt = depth;
-				best_opt = ns;
-			}
-			break;
-		case NVME_ANA_NONOPTIMIZED:
-			if (depth < min_depth_nonopt) {
-				min_depth_nonopt = depth;
-				best_nonopt = ns;
-			}
-			break;
-		default:
-			break;
-		}
-
-		if (min_depth_opt == 0)
-			return best_opt;
-	}
-
-	return best_opt ? best_opt : best_nonopt;
-}
-
 static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 {
 	return nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE &&
@@ -457,64 +272,6 @@ static bool nvme_mpath_is_optimized(struct mpath_device *mpath_device)
 	return nvme_path_is_optimized(nvme_mpath_to_ns(mpath_device));
 }
 
-static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
-{
-	int node = numa_node_id();
-	struct nvme_ns *ns;
-
-	ns = srcu_dereference(head->current_path[node], &head->srcu);
-	if (unlikely(!ns))
-		return __nvme_find_path(head, node);
-	if (unlikely(!nvme_path_is_optimized(ns)))
-		return __nvme_find_path(head, node);
-	return ns;
-}
-
-inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
-{
-	switch (READ_ONCE(head->subsys->iopolicy)) {
-	case NVME_IOPOLICY_QD:
-		return nvme_queue_depth_path(head);
-	case NVME_IOPOLICY_RR:
-		return nvme_round_robin_path(head);
-	default:
-		return nvme_numa_path(head);
-	}
-}
-
-static bool nvme_available_path(struct nvme_ns_head *head)
-{
-	struct nvme_ns *ns;
-
-	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags))
-		return false;
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
-			continue;
-		switch (nvme_ctrl_state(ns->ctrl)) {
-		case NVME_CTRL_LIVE:
-		case NVME_CTRL_RESETTING:
-		case NVME_CTRL_CONNECTING:
-			return true;
-		default:
-			break;
-		}
-	}
-
-	/*
-	 * If "head->delayed_removal_secs" is configured (i.e., non-zero), do
-	 * not immediately fail I/O. Instead, requeue the I/O for the configured
-	 * duration, anticipating that if there's a transient link failure then
-	 * it may recover within this time window. This parameter is exported to
-	 * userspace via sysfs, and its default value is zero. It is internally
-	 * mapped to NVME_NSHEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
-	 * non-zero, this flag is set to true. When zero, the flag is cleared.
-	 */
-	return nvme_mpath_queue_if_no_path(head);
-}
-
 static bool nvme_mpath_available_path(struct mpath_device *mpath_device)
 {
 	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
@@ -534,118 +291,12 @@ static bool nvme_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
-static void nvme_ns_head_submit_bio(struct bio *bio)
-{
-	struct nvme_ns_head *head = bio->bi_bdev->bd_disk->private_data;
-	struct device *dev = disk_to_dev(head->disk);
-	struct nvme_ns *ns;
-	int srcu_idx;
-
-	/*
-	 * The namespace might be going away and the bio might be moved to a
-	 * different queue via blk_steal_bios(), so we need to use the bio_split
-	 * pool from the original queue to allocate the bvecs from.
-	 */
-	bio = bio_split_to_limits(bio);
-	if (!bio)
-		return;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (likely(ns)) {
-		bio_set_dev(bio, ns->disk->part0);
-		/*
-		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
-		 * enters submit_bio_noacct() for the per-path device. The EOD
-		 * check already passed on the multipath head.
-		 */
-		bio_set_flag(bio, BIO_REMAPPED);
-		bio->bi_opf |= REQ_NVME_MPATH;
-		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
-				      bio->bi_iter.bi_sector);
-		submit_bio_noacct(bio);
-	} else if (nvme_available_path(head)) {
-		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
-
-		spin_lock_irq(&head->requeue_lock);
-		bio_list_add(&head->requeue_list, bio);
-		spin_unlock_irq(&head->requeue_lock);
-		atomic_long_inc(&head->io_requeue_no_usable_path_count);
-	} else {
-		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
-
-		bio_io_error(bio);
-		atomic_long_inc(&head->io_fail_no_available_path_count);
-	}
-
-	srcu_read_unlock(&head->srcu, srcu_idx);
-}
-
-static int nvme_ns_head_open(struct gendisk *disk, blk_mode_t mode)
-{
-	if (!nvme_tryget_ns_head(disk->private_data))
-		return -ENXIO;
-	return 0;
-}
-
-static void nvme_ns_head_release(struct gendisk *disk)
-{
-	nvme_put_ns_head(disk->private_data);
-}
-
-static int nvme_ns_head_get_unique_id(struct gendisk *disk, u8 id[16],
-		enum blk_unique_id type)
-{
-	struct nvme_ns_head *head = disk->private_data;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (ns)
-		ret = nvme_ns_get_unique_id(ns, id, type);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
-#ifdef CONFIG_BLK_DEV_ZONED
-static int nvme_ns_head_report_zones(struct gendisk *disk, sector_t sector,
-		unsigned int nr_zones, struct blk_report_zones_args *args)
-{
-	struct nvme_ns_head *head = disk->private_data;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (ns)
-		ret = nvme_ns_report_zones(ns, sector, nr_zones, args);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-#else
-#define nvme_ns_head_report_zones	NULL
-#endif /* CONFIG_BLK_DEV_ZONED */
-
-const struct block_device_operations nvme_ns_head_ops = {
-	.owner		= THIS_MODULE,
-	.submit_bio	= nvme_ns_head_submit_bio,
-	.open		= nvme_ns_head_open,
-	.release	= nvme_ns_head_release,
-	.ioctl		= nvme_ns_head_ioctl,
-	.compat_ioctl	= blkdev_compat_ptr_ioctl,
-	.getgeo		= nvme_getgeo,
-	.get_unique_id	= nvme_ns_head_get_unique_id,
-	.report_zones	= nvme_ns_head_report_zones,
-	.pr_ops		= &nvme_pr_ops,
-};
-
 static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
 {
 	struct nvme_ns_head *head = nvme_mpath_to_ns_head(mpath_head);
 	char name[32];
 
-	head->cdev_device.parent = &head->subsys->dev;
+	mpath_head->cdev_device.parent = &head->subsys->dev;
 	snprintf(name, sizeof(name), "ng%dn%d", head->subsys->instance,
 		 head->instance);
 
@@ -658,215 +309,25 @@ static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
 	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
 }
 
-static inline struct nvme_ns_head *cdev_to_ns_head(struct cdev *cdev)
-{
-	return container_of(cdev, struct nvme_ns_head, cdev);
-}
-
-static int nvme_ns_head_chr_open(struct inode *inode, struct file *file)
-{
-	if (!nvme_tryget_ns_head(cdev_to_ns_head(inode->i_cdev)))
-		return -ENXIO;
-	return 0;
-}
-
-static int nvme_ns_head_chr_release(struct inode *inode, struct file *file)
-{
-	nvme_put_ns_head(cdev_to_ns_head(inode->i_cdev));
-	return 0;
-}
-
-static const struct file_operations nvme_ns_head_chr_fops = {
-	.owner		= THIS_MODULE,
-	.open		= nvme_ns_head_chr_open,
-	.release	= nvme_ns_head_chr_release,
-	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
-	.compat_ioctl	= compat_ptr_ioctl,
-	.uring_cmd	= nvme_ns_head_chr_uring_cmd,
-	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
-};
-
-static void nvme_add_ns_head_cdev(struct nvme_ns_head *head)
-{
-	char name[32];
-
-	head->cdev_device.parent = &head->subsys->dev;
-	snprintf(name, sizeof(name), "ng%dn%d", head->subsys->instance,
-		 head->instance);
-
-	if (nvme_cdev_add(name, &head->cdev, &head->cdev_device,
-			&nvme_ns_head_chr_fops, THIS_MODULE)) {
-		dev_err(disk_to_dev(head->disk),
-			"Unable to create the %s device\n", name);
-		return;
-	}
-	set_bit(NVME_NSHEAD_CDEV_LIVE, &head->flags);
-}
-
-static void nvme_partition_scan_work(struct work_struct *work)
-{
-	struct nvme_ns_head *head =
-		container_of(work, struct nvme_ns_head, partition_scan_work);
-
-	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
-					     &head->disk->state)))
-		return;
-
-	mutex_lock(&head->disk->open_mutex);
-	bdev_disk_changed(head->disk, false);
-	mutex_unlock(&head->disk->open_mutex);
-}
-
-static void nvme_requeue_work(struct work_struct *work)
-{
-	struct nvme_ns_head *head =
-		container_of(work, struct nvme_ns_head, requeue_work);
-	struct bio *bio, *next;
-
-	spin_lock_irq(&head->requeue_lock);
-	next = bio_list_get(&head->requeue_list);
-	spin_unlock_irq(&head->requeue_lock);
-
-	while ((bio = next) != NULL) {
-		next = bio->bi_next;
-		bio->bi_next = NULL;
-
-		submit_bio_noacct(bio);
-	}
-}
-
 static void nvme_remove_head(struct nvme_ns_head *head)
 {
-	if (test_and_clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		/*
-		 * requeue I/O after NVME_NSHEAD_DISK_LIVE has been cleared
-		 * to allow multipath to fail all I/O.
-		 */
-		kblockd_schedule_work(&head->requeue_work);
-
-		if (test_and_clear_bit(NVME_NSHEAD_CDEV_LIVE, &head->flags))
-			nvme_cdev_del(&head->cdev, &head->cdev_device);
-		synchronize_srcu(&head->srcu);
-		del_gendisk(head->disk);
-	}
+	mpath_remove_disk(&head->mpath_head);
 	nvme_put_ns_head(head);
 }
 
-static void nvme_remove_head_work(struct work_struct *work)
+static void nvme_mpath_remove_head(struct mpath_head *mpath_head)
 {
-	struct nvme_ns_head *head = container_of(to_delayed_work(work),
-			struct nvme_ns_head, remove_work);
+	struct nvme_ns_head *head = nvme_mpath_to_ns_head(mpath_head);
 	bool remove = false;
 
 	mutex_lock(&head->subsys->lock);
-	if (list_empty(&head->list)) {
+	if (mpath_head_devices_empty(mpath_head)) {
 		list_del_init(&head->entry);
 		remove = true;
 	}
 	mutex_unlock(&head->subsys->lock);
 	if (remove)
 		nvme_remove_head(head);
-
-	module_put(THIS_MODULE);
-}
-
-int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
-{
-	struct queue_limits lim;
-
-	mutex_init(&head->lock);
-	bio_list_init(&head->requeue_list);
-	spin_lock_init(&head->requeue_lock);
-	INIT_WORK(&head->requeue_work, nvme_requeue_work);
-	INIT_WORK(&head->partition_scan_work, nvme_partition_scan_work);
-	INIT_DELAYED_WORK(&head->remove_work, nvme_remove_head_work);
-	head->delayed_removal_secs = 0;
-
-	/*
-	 * If "multipath_always_on" is enabled, a multipath node is added
-	 * regardless of whether the disk is single/multi ported, and whether
-	 * the namespace is shared or private. If "multipath_always_on" is not
-	 * enabled, a multipath node is added only if the subsystem supports
-	 * multiple controllers and the "multipath" option is configured. In
-	 * either case, for private namespaces, we ensure that the NSID is
-	 * unique.
-	 */
-	if (!multipath_always_on) {
-		if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) ||
-				!multipath)
-			return 0;
-	}
-
-	if (!nvme_is_unique_nsid(ctrl, head))
-		return 0;
-
-	blk_set_stacking_limits(&lim);
-	lim.dma_alignment = 3;
-	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
-		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES | BLK_FEAT_PCI_P2PDMA;
-	if (head->ids.csi == NVME_CSI_ZNS)
-		lim.features |= BLK_FEAT_ZONED;
-
-	head->disk = blk_alloc_disk(&lim, ctrl->numa_node);
-	if (IS_ERR(head->disk))
-		return PTR_ERR(head->disk);
-	head->disk->fops = &nvme_ns_head_ops;
-	head->disk->private_data = head;
-
-	/*
-	 * We need to suppress the partition scan from occuring within the
-	 * controller's scan_work context. If a path error occurs here, the IO
-	 * will wait until a path becomes available or all paths are torn down,
-	 * but that action also occurs within scan_work, so it would deadlock.
-	 * Defer the partition scan to a different context that does not block
-	 * scan_work.
-	 */
-	set_bit(GD_SUPPRESS_PART_SCAN, &head->disk->state);
-	sprintf(head->disk->disk_name, "nvme%dn%d",
-			ctrl->subsys->instance, head->instance);
-	nvme_tryget_ns_head(head);
-	return 0;
-}
-
-static void nvme_mpath_set_live(struct nvme_ns *ns)
-{
-	struct nvme_ns_head *head = ns->head;
-	int rc;
-
-	if (!head->disk)
-		return;
-
-	/*
-	 * test_and_set_bit() is used because it is protecting against two nvme
-	 * paths simultaneously calling device_add_disk() on the same namespace
-	 * head.
-	 */
-	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		rc = device_add_disk(&head->subsys->dev, head->disk,
-				     nvme_ns_attr_groups);
-		if (rc) {
-			clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
-			return;
-		}
-		nvme_add_ns_head_cdev(head);
-		queue_work(nvme_wq, &head->partition_scan_work);
-	}
-
-	nvme_mpath_add_sysfs_link(ns->head);
-
-	mutex_lock(&head->lock);
-	if (nvme_path_is_optimized(ns)) {
-		int node, srcu_idx;
-
-		srcu_idx = srcu_read_lock(&head->srcu);
-		for_each_online_node(node)
-			__nvme_find_path(head, node);
-		srcu_read_unlock(&head->srcu, srcu_idx);
-	}
-	mutex_unlock(&head->lock);
-
-	synchronize_srcu(&head->srcu);
-	kblockd_schedule_work(&head->requeue_work);
 }
 
 static int nvme_parse_ana_log(struct nvme_ctrl *ctrl, void *data,
@@ -918,14 +379,29 @@ static inline bool nvme_state_is_live(enum nvme_ana_state state)
 	return state == NVME_ANA_OPTIMIZED || state == NVME_ANA_NONOPTIMIZED;
 }
 
+static void nvme_mpath_update_ana_state(struct nvme_ns *ns,
+				enum nvme_ana_state ana_state)
+{
+	ns->ana_state = ana_state;
+	if (ana_state == NVME_ANA_OPTIMIZED)
+		ns->mpath_device.access_state = MPATH_STATE_OPTIMIZED;
+	else if (ana_state == NVME_ANA_NONOPTIMIZED)
+		ns->mpath_device.access_state = MPATH_STATE_NONOPTIMIZED;
+	else
+		ns->mpath_device.access_state = MPATH_STATE_OTHER;
+}
+
 static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 		struct nvme_ns *ns)
 {
+	struct mpath_head *mpath_head = &ns->head->mpath_head;
+
 	ns->ana_grpid = le32_to_cpu(desc->grpid);
-	ns->ana_state = desc->state;
+	nvme_mpath_update_ana_state(ns, desc->state);
 	clear_bit(NVME_NS_ANA_PENDING, &ns->flags);
+
 	/*
-	 * nvme_mpath_set_live() will trigger I/O to the multipath path device
+	 * mpath_device_set_live() will trigger I/O to the multipath path device
 	 * and in turn to this path device.  However we cannot accept this I/O
 	 * if the controller is not live.  This may deadlock if called from
 	 * nvme_mpath_init_identify() and the ctrl will never complete
@@ -935,16 +411,16 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 	 */
 	if (nvme_state_is_live(ns->ana_state) &&
 	    nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE)
-		nvme_mpath_set_live(ns);
+		mpath_device_set_live(&ns->mpath_device);
 	else {
 		/*
 		 * Add sysfs link from multipath head gendisk node to path
 		 * device gendisk node.
 		 * If path's ana state is live (i.e. state is either optimized
 		 * or non-optimized) while we alloc the ns then sysfs link would
-		 * be created from nvme_mpath_set_live(). In that case we would
+		 * be created from mpath_device_set_live(). In that case we would
 		 * not fallthrough this code path. However for the path's ana
-		 * state other than live, we call nvme_mpath_set_live() only
+		 * state other than live, we call mpath_device_set_live() only
 		 * after ana state transitioned to the live state. But we still
 		 * want to create the sysfs link from head node to a path device
 		 * irrespctive of the path's ana state.
@@ -952,8 +428,8 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 		 * is not live but still create the sysfs link to this path from
 		 * head node if head node of the path has already come alive.
 		 */
-		if (test_bit(NVME_NSHEAD_DISK_LIVE, &ns->head->flags))
-			nvme_mpath_add_sysfs_link(ns->head);
+		if (test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+			mpath_add_sysfs_link(mpath_head);
 	}
 }
 
@@ -1080,45 +556,22 @@ static ssize_t nvme_subsys_iopolicy_show(struct device *dev,
 	struct nvme_subsystem *subsys =
 		container_of(dev, struct nvme_subsystem, dev);
 
-	return sysfs_emit(buf, "%s\n",
-			  nvme_iopolicy_names[READ_ONCE(subsys->iopolicy)]);
+	return mpath_iopolicy_show(&subsys->mpath_iopolicy, buf);
 }
 
-static void nvme_subsys_iopolicy_update(struct nvme_subsystem *subsys,
-		int iopolicy)
+static ssize_t nvme_subsys_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
 {
+	struct nvme_subsystem *subsys =
+		container_of(dev, struct nvme_subsystem, dev);
 	struct nvme_ctrl *ctrl;
-	int old_iopolicy = READ_ONCE(subsys->iopolicy);
-
-	if (old_iopolicy == iopolicy)
-		return;
 
-	WRITE_ONCE(subsys->iopolicy, iopolicy);
-
-	/* iopolicy changes clear the mpath by design */
+	if (!mpath_iopolicy_store(&subsys->mpath_iopolicy, buf, count))
+		return -EINVAL;
 	mutex_lock(&nvme_subsystems_lock);
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
 		nvme_mpath_clear_ctrl_paths(ctrl);
 	mutex_unlock(&nvme_subsystems_lock);
-
-	pr_notice("subsysnqn %s iopolicy changed from %s to %s\n",
-			subsys->subnqn,
-			nvme_iopolicy_names[old_iopolicy],
-			nvme_iopolicy_names[iopolicy]);
-}
-
-static ssize_t nvme_subsys_iopolicy_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct nvme_subsystem *subsys =
-		container_of(dev, struct nvme_subsystem, dev);
-	int policy;
-
-	policy = nvme_iopolicy_parse(buf);
-	if (policy < 0)
-		return policy;
-
-	nvme_subsys_iopolicy_update(subsys, policy);
 	return count;
 }
 SUBSYS_ATTR_RW(iopolicy, S_IRUGO | S_IWUSR,
@@ -1145,7 +598,7 @@ static ssize_t queue_depth_show(struct device *dev,
 {
 	struct nvme_ns *ns = nvme_get_ns_from_dev(dev);
 
-	if (ns->head->subsys->iopolicy != NVME_IOPOLICY_QD)
+	if (!mpath_qd_iopolicy(&ns->head->subsys->mpath_iopolicy))
 		return 0;
 
 	return sysfs_emit(buf, "%d\n", atomic_read(&ns->ctrl->nr_active));
@@ -1155,69 +608,24 @@ DEVICE_ATTR_RO(queue_depth);
 static ssize_t numa_nodes_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	int node, srcu_idx;
-	nodemask_t numa_nodes;
-	struct nvme_ns *current_ns;
 	struct nvme_ns *ns = nvme_get_ns_from_dev(dev);
-	struct nvme_ns_head *head = ns->head;
-
-	if (head->subsys->iopolicy != NVME_IOPOLICY_NUMA)
-		return 0;
 
-	nodes_clear(numa_nodes);
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	for_each_node(node) {
-		current_ns = srcu_dereference(head->current_path[node],
-				&head->srcu);
-		if (ns == current_ns)
-			node_set(node, numa_nodes);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-
-	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+	return mpath_numa_nodes_show(&ns->mpath_device, buf);
 }
 DEVICE_ATTR_RO(numa_nodes);
 
-static ssize_t delayed_removal_secs_show(struct device *dev,
+static ssize_t delayed_removal_secs_show(struct device *bd_device,
 		struct device_attribute *attr, char *buf)
 {
-	struct gendisk *disk = dev_to_disk(dev);
-	struct nvme_ns_head *head = disk->private_data;
-	int ret;
-
-	mutex_lock(&head->subsys->lock);
-	ret = sysfs_emit(buf, "%u\n", head->delayed_removal_secs);
-	mutex_unlock(&head->subsys->lock);
-	return ret;
+	return mpath_delayed_removal_secs_show(
+		mpath_bd_device_to_head(bd_device), buf);
 }
 
-static ssize_t delayed_removal_secs_store(struct device *dev,
+static ssize_t delayed_removal_secs_store(struct device *bd_device,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct gendisk *disk = dev_to_disk(dev);
-	struct nvme_ns_head *head = disk->private_data;
-	unsigned int sec;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &sec);
-	if (ret < 0)
-		return ret;
-
-	mutex_lock(&head->subsys->lock);
-	head->delayed_removal_secs = sec;
-	if (sec)
-		set_bit(NVME_NSHEAD_QUEUE_IF_NO_PATH, &head->flags);
-	else
-		clear_bit(NVME_NSHEAD_QUEUE_IF_NO_PATH, &head->flags);
-	mutex_unlock(&head->subsys->lock);
-	/*
-	 * Ensure that update to NVME_NSHEAD_QUEUE_IF_NO_PATH is seen
-	 * by its reader.
-	 */
-	synchronize_srcu(&head->srcu);
-
-	return count;
+	return mpath_delayed_removal_secs_store(
+		mpath_bd_device_to_head(bd_device), buf, count);
 }
 
 DEVICE_ATTR_RW(delayed_removal_secs);
@@ -1253,24 +661,26 @@ static ssize_t io_requeue_no_usable_path_count_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct nvme_ns_head *head = disk->private_data;
+	struct mpath_head *mpath_head = &head->mpath_head;
+	unsigned long val =
+		atomic_long_read(&mpath_head->requeue_no_usable_path_cnt);
 
-	return sysfs_emit(buf, "%lu\n",
-		    atomic_long_read(&head->io_requeue_no_usable_path_count));
+	return sysfs_emit(buf, "%lu\n", val);
 }
 
 static ssize_t io_requeue_no_usable_path_count_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int err;
-	unsigned long requeue_cnt;
 	struct gendisk *disk = dev_to_disk(dev);
 	struct nvme_ns_head *head = disk->private_data;
+	unsigned long cnt;
+	int err;
 
-	err = kstrtoul(buf, 0, &requeue_cnt);
+	err = kstrtoul(buf, 0, &cnt);
 	if (err)
 		return -EINVAL;
 
-	atomic_long_set(&head->io_requeue_no_usable_path_count, requeue_cnt);
+	atomic_long_set(&head->mpath_head.requeue_no_usable_path_cnt, cnt);
 
 	return count;
 }
@@ -1282,24 +692,26 @@ static ssize_t io_fail_no_available_path_count_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct nvme_ns_head *head = disk->private_data;
+	struct mpath_head *mpath_head = &head->mpath_head;
+	unsigned long val =
+		atomic_long_read(&mpath_head->fail_no_avail_path_cnt);
 
-	return sysfs_emit(buf, "%lu\n",
-		    atomic_long_read(&head->io_fail_no_available_path_count));
+	return sysfs_emit(buf, "%lu\n", val);
 }
 
 static ssize_t io_fail_no_available_path_count_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int err;
-	unsigned long fail_cnt;
 	struct gendisk *disk = dev_to_disk(dev);
 	struct nvme_ns_head *head = disk->private_data;
+	unsigned long cnt;
+	int err;
 
-	err = kstrtoul(buf, 0, &fail_cnt);
+	err = kstrtoul(buf, 0, &cnt);
 	if (err)
 		return -EINVAL;
 
-	atomic_long_set(&head->io_fail_no_available_path_count, fail_cnt);
+	atomic_long_set(&head->mpath_head.fail_no_avail_path_cnt, cnt);
 
 	return count;
 }
@@ -1318,85 +730,6 @@ static int nvme_lookup_ana_group_desc(struct nvme_ctrl *ctrl,
 	return -ENXIO; /* just break out of the loop */
 }
 
-void nvme_mpath_add_sysfs_link(struct nvme_ns_head *head)
-{
-	struct device *target;
-	int rc, srcu_idx;
-	struct nvme_ns *ns;
-	struct kobject *kobj;
-
-	/*
-	 * Ensure head disk node is already added otherwise we may get invalid
-	 * kobj for head disk node
-	 */
-	if (!test_bit(GD_ADDED, &head->disk->state))
-		return;
-
-	kobj = &disk_to_dev(head->disk)->kobj;
-
-	/*
-	 * loop through each ns chained through the head->list and create the
-	 * sysfs link from head node to the ns path node
-	 */
-	srcu_idx = srcu_read_lock(&head->srcu);
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		/*
-		 * Ensure that ns path disk node is already added otherwise we
-		 * may get invalid kobj name for target
-		 */
-		if (!test_bit(GD_ADDED, &ns->disk->state))
-			continue;
-
-		/*
-		 * Avoid creating link if it already exists for the given path.
-		 * When path ana state transitions from optimized to non-
-		 * optimized or vice-versa, the nvme_mpath_set_live() is
-		 * invoked which in truns call this function. Now if the sysfs
-		 * link already exists for the given path and we attempt to re-
-		 * create the link then sysfs code would warn about it loudly.
-		 * So we evaluate NVME_NS_SYSFS_ATTR_LINK flag here to ensure
-		 * that we're not creating duplicate link.
-		 * The test_and_set_bit() is used because it is protecting
-		 * against multiple nvme paths being simultaneously added.
-		 */
-		if (test_and_set_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags))
-			continue;
-
-		target = disk_to_dev(ns->disk);
-		/*
-		 * Create sysfs link from head gendisk kobject @kobj to the
-		 * ns path gendisk kobject @target->kobj.
-		 */
-		rc = sysfs_add_link_to_group(kobj, nvme_ns_mpath_attr_group.name,
-				&target->kobj, dev_name(target));
-		if (unlikely(rc)) {
-			dev_err(disk_to_dev(ns->head->disk),
-					"failed to create link to %s\n",
-					dev_name(target));
-			clear_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags);
-		}
-	}
-
-	srcu_read_unlock(&head->srcu, srcu_idx);
-}
-
-void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
-{
-	struct device *target;
-	struct kobject *kobj;
-
-	if (!test_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags))
-		return;
-
-	target = disk_to_dev(ns->disk);
-	kobj = &disk_to_dev(ns->head->disk)->kobj;
-	sysfs_remove_link_from_group(kobj, nvme_ns_mpath_attr_group.name,
-			dev_name(target));
-	clear_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags);
-}
-
 void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 {
 	if (nvme_ctrl_use_ana(ns->ctrl)) {
@@ -1418,13 +751,13 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 			queue_work(nvme_wq, &ns->ctrl->ana_work);
 		}
 	} else {
-		ns->ana_state = NVME_ANA_OPTIMIZED;
-		nvme_mpath_set_live(ns);
+		nvme_mpath_update_ana_state(ns, NVME_ANA_OPTIMIZED);
+		mpath_device_set_live(&ns->mpath_device);
 	}
 
 #ifdef CONFIG_BLK_DEV_ZONED
-	if (blk_queue_is_zoned(ns->queue) && ns->head->disk)
-		ns->head->disk->nr_zones = ns->disk->nr_zones;
+	if (blk_queue_is_zoned(ns->queue) && ns->head->mpath_head.disk)
+		ns->head->mpath_head.disk->nr_zones = ns->disk->nr_zones;
 #endif
 }
 
@@ -1432,7 +765,7 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
 	bool remove = false;
 
-	if (!head->disk)
+	if (!head->mpath_head.disk)
 		return;
 
 	mutex_lock(&head->subsys->lock);
@@ -1445,17 +778,10 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	 * head->list here. If it is no longer empty then we skip enqueuing the
 	 * delayed head removal work.
 	 */
-	if (!list_empty(&head->list))
+	if (!mpath_head_devices_empty(&head->mpath_head))
 		goto out;
 
-	/*
-	 * Ensure that no one could remove this module while the head
-	 * remove work is pending.
-	 */
-	if (head->delayed_removal_secs && try_module_get(THIS_MODULE)) {
-		mod_delayed_work(nvme_wq, &head->remove_work,
-				head->delayed_removal_secs * HZ);
-	} else {
+	if (mpath_can_remove_head(&head->mpath_head)) {
 		list_del_init(&head->entry);
 		remove = true;
 	}
@@ -1465,17 +791,6 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 		nvme_remove_head(head);
 }
 
-void nvme_mpath_put_disk(struct nvme_ns_head *head)
-{
-	if (!head->disk)
-		return;
-	/* make sure all pending bios are cleaned up */
-	kblockd_schedule_work(&head->requeue_work);
-	flush_work(&head->requeue_work);
-	flush_work(&head->partition_scan_work);
-	put_disk(head->disk);
-}
-
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
 {
 	mutex_init(&ctrl->ana_lock);
@@ -1544,9 +859,9 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_size = 0;
 }
 
-__maybe_unused
 static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
+	.remove_head = nvme_mpath_remove_head,
 	.add_cdev = nvme_mpath_add_cdev,
 	.del_cdev = nvme_mpath_del_cdev,
 	.is_disabled = nvme_mpath_is_disabled,
@@ -1557,3 +872,45 @@ static const struct mpath_head_template mpdt = {
 	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
 	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
+
+int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
+{
+	struct queue_limits lim;
+	int ret;
+
+	head->mpath_head.mpdt = &mpdt;
+
+	/*
+	 * If "multipath_always_on" is enabled, a multipath node is added
+	 * regardless of whether the disk is single/multi ported, and whether
+	 * the namespace is shared or private. If "multipath_always_on" is not
+	 * enabled, a multipath node is added only if the subsystem supports
+	 * multiple controllers and the "multipath" option is configured. In
+	 * either case, for private namespaces, we ensure that the NSID is
+	 * unique.
+	 */
+	if (!multipath_always_on) {
+		if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) ||
+				!multipath)
+			return 0;
+	}
+
+	if (!nvme_is_unique_nsid(ctrl, head))
+		return 0;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+	if (head->ids.csi == NVME_CSI_ZNS)
+		lim.features |= BLK_FEAT_ZONED;
+
+	ret = mpath_alloc_head_disk(&head->mpath_head, &lim, ctrl->numa_node);
+	if (ret)
+		return ret;
+
+	sprintf(head->mpath_head.disk->disk_name, "nvme%dn%d",
+			ctrl->subsys->instance, head->instance);
+	nvme_tryget_ns_head(head);
+	return 0;
+}
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 354f77dea4870..f3e801105f9c3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -252,11 +252,6 @@ struct nvme_request {
 	struct nvme_ctrl	*ctrl;
 };
 
-/*
- * Mark a bio as coming in through the mpath node.
- */
-#define REQ_NVME_MPATH		REQ_DRV
-
 enum {
 	NVME_REQ_CANCELLED		= (1 << 0),
 	NVME_REQ_USERCMD		= (1 << 1),
@@ -480,11 +475,6 @@ static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
 	return READ_ONCE(ctrl->state);
 }
 
-enum nvme_iopolicy {
-	NVME_IOPOLICY_NUMA,
-	NVME_IOPOLICY_RR,
-	NVME_IOPOLICY_QD,
-};
 
 struct nvme_subsystem {
 	int			instance;
@@ -507,7 +497,7 @@ struct nvme_subsystem {
 	u16			vendor_id;
 	struct ida		ns_ida;
 #ifdef CONFIG_NVME_MULTIPATH
-	enum nvme_iopolicy	iopolicy;
+	enum mpath_iopolicy_e	mpath_iopolicy;
 #endif
 };
 
@@ -529,8 +519,6 @@ struct nvme_ns_ids {
  * only ever has a single entry for private namespaces.
  */
 struct nvme_ns_head {
-	struct list_head	list;
-	struct srcu_struct      srcu;
 	struct nvme_subsystem	*subsys;
 	struct nvme_ns_ids	ids;
 	u8			lba_shift;
@@ -554,36 +542,14 @@ struct nvme_ns_head {
 
 	struct ratelimit_state	rs_nuse;
 
-	struct cdev		cdev;
-	struct device		cdev_device;
-
-	struct gendisk		*disk;
-
 	u16			nr_plids;
 	u16			*plids;
-
 	struct mpath_head	mpath_head;
-#ifdef CONFIG_NVME_MULTIPATH
-	struct bio_list		requeue_list;
-	spinlock_t		requeue_lock;
-	struct work_struct	requeue_work;
-	struct work_struct	partition_scan_work;
-	struct mutex		lock;
-	unsigned long		flags;
-	struct delayed_work	remove_work;
-	unsigned int		delayed_removal_secs;
-	atomic_long_t		io_requeue_no_usable_path_count;
-	atomic_long_t		io_fail_no_available_path_count;
-#define NVME_NSHEAD_DISK_LIVE		0
-#define NVME_NSHEAD_QUEUE_IF_NO_PATH	1
-#define NVME_NSHEAD_CDEV_LIVE		2
-	struct nvme_ns __rcu	*current_path[];
-#endif
 };
 
 static inline bool nvme_ns_head_multipath(struct nvme_ns_head *head)
 {
-	return IS_ENABLED(CONFIG_NVME_MULTIPATH) && head->disk;
+	return IS_ENABLED(CONFIG_NVME_MULTIPATH) && head->mpath_head.disk;
 }
 
 enum nvme_ns_features {
@@ -606,7 +572,6 @@ struct nvme_ns {
 #endif
 	atomic_long_t retries;
 	atomic_long_t errors;
-	struct list_head siblings;
 	struct kref kref;
 	struct nvme_ns_head *head;
 
@@ -1012,27 +977,22 @@ void nvme_cdev_del(struct cdev *cdev, struct device *cdev_device);
 int nvme_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-int nvme_ns_head_ioctl(struct block_device *bdev, blk_mode_t mode,
-		unsigned int cmd, unsigned long arg);
-long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
-		unsigned long arg);
+
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
 		struct io_comp_batch *iob, unsigned int poll_flags);
 int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
-int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
-		unsigned int issue_flags);
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		struct nvme_id_ns **id);
 int nvme_getgeo(struct gendisk *disk, struct hd_geometry *geo);
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 
 extern const struct attribute_group *nvme_ns_attr_groups[];
-extern const struct attribute_group nvme_ns_mpath_attr_group;
 extern const struct pr_ops nvme_pr_ops;
-extern const struct block_device_operations nvme_ns_head_ops;
 extern const struct attribute_group nvme_dev_attrs_group;
 extern const struct attribute_group nvme_dev_diag_attrs_group;
 extern const struct attribute_group *nvme_subsys_attrs_groups[];
@@ -1040,7 +1000,6 @@ extern const struct attribute_group *nvme_dev_attr_groups[];
 extern const struct block_device_operations nvme_bdev_ops;
 
 void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl);
-struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 
 static inline void nvme_add_ns(struct nvme_ns *ns)
 {
@@ -1066,35 +1025,43 @@ void nvme_mpath_default_iopolicy(struct nvme_subsystem *subsys);
 void nvme_failover_req(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
-void nvme_mpath_add_sysfs_link(struct nvme_ns_head *ns);
-void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns);
 void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid);
-void nvme_mpath_put_disk(struct nvme_ns_head *head);
 int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl);
 void nvme_mpath_update(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
-bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
 void nvme_mpath_revalidate_paths(struct nvme_ns_head *head);
 void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
-int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
-		struct io_uring_cmd *ioucmd, unsigned int issue_flags);
-
 long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
 			unsigned long arg, bool open_for_write);
 void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
 			unsigned int cmd, void **opaque);
 void nvme_mpath_ioctl_finish(void *opaque);
 
+static inline void nvme_mpath_put_disk(struct nvme_ns_head *head)
+{
+	mpath_put_disk(&head->mpath_head);
+}
+
+static inline void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
+{
+	mpath_remove_sysfs_link(&ns->mpath_device);
+}
+
 static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
 {
 	mpath_synchronize(&head->mpath_head);
 }
 
+static inline bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
+{
+	return mpath_clear_current_path(&ns->mpath_device);
+}
+
 static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
 {
 	return mpath_head_queue_if_no_path(&head->mpath_head);
@@ -1104,8 +1071,9 @@ static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 
-	if ((req->cmd_flags & REQ_NVME_MPATH) && req->bio)
-		trace_block_bio_complete(ns->head->disk->queue, req->bio);
+	if (is_mpath_request(req) && req->bio)
+		trace_block_bio_complete(ns->head->mpath_head.disk->queue,
+					req->bio);
 }
 
 extern bool multipath;
@@ -1119,16 +1087,6 @@ extern struct device_attribute dev_attr_io_requeue_no_usable_path_count;
 extern struct device_attribute dev_attr_io_fail_no_available_path_count;
 extern struct device_attribute subsys_attr_iopolicy;
 
-static inline bool nvme_disk_is_ns_head(struct gendisk *disk)
-{
-	return disk->fops == &nvme_ns_head_ops;
-}
-static inline bool nvme_mpath_queue_if_no_path(struct nvme_ns_head *head)
-{
-	if (test_bit(NVME_NSHEAD_QUEUE_IF_NO_PATH, &head->flags))
-		return true;
-	return false;
-}
 #else
 #define multipath false
 static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
@@ -1155,9 +1113,7 @@ static inline void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 static inline void nvme_mpath_put_disk(struct nvme_ns_head *head)
 {
 }
-static inline void nvme_mpath_add_sysfs_link(struct nvme_ns *ns)
-{
-}
+
 static inline void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
 {
 }
@@ -1215,14 +1171,6 @@ static inline void nvme_mpath_start_request(struct request *rq)
 static inline void nvme_mpath_end_request(struct request *rq)
 {
 }
-static inline bool nvme_disk_is_ns_head(struct gendisk *disk)
-{
-	return false;
-}
-static inline bool nvme_mpath_queue_if_no_path(struct nvme_ns_head *head)
-{
-	return false;
-}
 static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
 {
 	return false;
@@ -1261,7 +1209,7 @@ static inline struct nvme_ns *nvme_get_ns_from_dev(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	WARN_ON(nvme_disk_is_ns_head(disk));
+	WARN_ON(is_mpath_disk(disk));
 	return disk->private_data;
 }
 
@@ -1281,7 +1229,7 @@ static inline void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
 
 static inline void nvme_start_request(struct request *rq)
 {
-	if (rq->cmd_flags & REQ_NVME_MPATH)
+	if (is_mpath_request(rq))
 		nvme_mpath_start_request(rq);
 	blk_mq_start_request(rq);
 }
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index fe7dbe2648158..65e4dc74833e9 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -49,22 +49,6 @@ static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
 	return 0;
 }
 
-static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, void *data, unsigned int data_len)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EWOULDBLOCK;
-
-	if (ns) {
-		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 		void *data, unsigned int data_len)
 {
@@ -101,8 +85,6 @@ static int __nvme_send_pr_command(struct block_device *bdev, u32 cdw10,
 	c.common.cdw10 = cpu_to_le32(cdw10);
 	c.common.cdw11 = cpu_to_le32(cdw11);
 
-	if (nvme_disk_is_ns_head(bdev->bd_disk))
-		return nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
 	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
 				data, data_len);
 }
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 75b2d69b59578..3837bcd843054 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -65,8 +65,8 @@ static inline struct nvme_ns_head *dev_to_ns_head(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	if (nvme_disk_is_ns_head(disk))
-		return disk->private_data;
+	if (is_mpath_disk(disk))
+		return nvme_mpath_to_ns_head(mpath_bd_device_to_head(dev));
 	return nvme_get_ns_from_dev(dev)->head;
 }
 
@@ -184,31 +184,28 @@ static ssize_t metadata_bytes_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(metadata_bytes);
 
-static int ns_head_update_nuse(struct nvme_ns_head *head)
+static int ns_head_update_nuse_cb(struct mpath_device *mpath_device)
 {
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
 	struct nvme_id_ns *id;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	/* Avoid issuing commands too often by rate limiting the update */
-	if (!__ratelimit(&head->rs_nuse))
-		return 0;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (!ns)
-		goto out_unlock;
+	int ret;
 
-	ret = nvme_identify_ns(ns->ctrl, head->ns_id, &id);
+	ret = nvme_identify_ns(ns->ctrl, ns->head->ns_id, &id);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
-	head->nuse = le64_to_cpu(id->nuse);
+	ns->head->nuse = le64_to_cpu(id->nuse);
 	kfree(id);
+	return 0;
+}
 
-out_unlock:
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
+static int ns_head_update_nuse(struct nvme_ns_head *head)
+{
+	/* Avoid issuing commands too often by rate limiting the update */
+	if (!__ratelimit(&head->rs_nuse))
+		return 0;
+
+	return mpath_call_for_device(&head->mpath_head, ns_head_update_nuse_cb);
 }
 
 static int ns_update_nuse(struct nvme_ns *ns)
@@ -236,7 +233,7 @@ static ssize_t nuse_show(struct device *dev, struct device_attribute *attr,
 	struct gendisk *disk = dev_to_disk(dev);
 	int ret;
 
-	if (nvme_disk_is_ns_head(disk))
+	if (is_mpath_disk(disk))
 		ret = ns_head_update_nuse(head);
 	else
 		ret = ns_update_nuse(disk->private_data);
@@ -289,19 +286,19 @@ static umode_t nvme_ns_attrs_are_visible(struct kobject *kobj,
 #ifdef CONFIG_NVME_MULTIPATH
 	if (a == &dev_attr_ana_grpid.attr || a == &dev_attr_ana_state.attr) {
 		/* per-path attr */
-		if (nvme_disk_is_ns_head(dev_to_disk(dev)))
+		if (is_mpath_disk(dev_to_disk(dev)))
 			return 0;
 		if (!nvme_ctrl_use_ana(nvme_get_ns_from_dev(dev)->ctrl))
 			return 0;
 	}
 	if (a == &dev_attr_queue_depth.attr || a == &dev_attr_numa_nodes.attr) {
-		if (nvme_disk_is_ns_head(dev_to_disk(dev)))
+		if (is_mpath_disk(dev_to_disk(dev)))
 			return 0;
 	}
 	if (a == &dev_attr_delayed_removal_secs.attr) {
 		struct gendisk *disk = dev_to_disk(dev);
 
-		if (!nvme_disk_is_ns_head(disk))
+		if (!is_mpath_disk(disk))
 			return 0;
 	}
 #endif
@@ -313,38 +310,6 @@ static const struct attribute_group nvme_ns_attr_group = {
 	.is_visible	= nvme_ns_attrs_are_visible,
 };
 
-#ifdef CONFIG_NVME_MULTIPATH
-/*
- * NOTE: The dummy attribute does not appear in sysfs. It exists solely to allow
- * control over the visibility of the multipath sysfs node. Without at least one
- * attribute defined in nvme_ns_mpath_attrs[], the sysfs implementation does not
- * invoke the multipath_sysfs_group_visible() method. As a result, we would not
- * be able to control the visibility of the multipath sysfs node.
- */
-static struct attribute dummy_attr = {
-	.name = "dummy",
-};
-
-static struct attribute *nvme_ns_mpath_attrs[] = {
-	&dummy_attr,
-	NULL,
-};
-
-static bool multipath_sysfs_group_visible(struct kobject *kobj)
-{
-	struct device *dev = container_of(kobj, struct device, kobj);
-
-	return nvme_disk_is_ns_head(dev_to_disk(dev));
-}
-DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
-
-const struct attribute_group nvme_ns_mpath_attr_group = {
-	.name           = "multipath",
-	.attrs		= nvme_ns_mpath_attrs,
-	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
-};
-#endif
-
 static ssize_t command_retries_count_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -415,26 +380,26 @@ static umode_t nvme_ns_diag_attrs_are_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 
 	if (a == &dev_attr_command_retries_count.attr) {
-		if (nvme_disk_is_ns_head(dev_to_disk(dev)))
+		if (is_mpath_disk(dev_to_disk(dev)))
 			return 0;
 	}
 	if (a == &dev_attr_io_errors.attr) {
 		struct gendisk *disk = dev_to_disk(dev);
 
-		if (nvme_disk_is_ns_head(disk))
+		if (is_mpath_disk(disk))
 			return 0;
 	}
 #ifdef CONFIG_NVME_MULTIPATH
 	if (a == &dev_attr_multipath_failover_count.attr) {
-		if (nvme_disk_is_ns_head(dev_to_disk(dev)))
+		if (is_mpath_disk(dev_to_disk(dev)))
 			return 0;
 	}
 	if (a == &dev_attr_io_requeue_no_usable_path_count.attr) {
-		if (!nvme_disk_is_ns_head(dev_to_disk(dev)))
+		if (!is_mpath_disk(dev_to_disk(dev)))
 			return 0;
 	}
 	if (a == &dev_attr_io_fail_no_available_path_count.attr) {
-		if (!nvme_disk_is_ns_head(dev_to_disk(dev)))
+		if (!is_mpath_disk(dev_to_disk(dev)))
 			return 0;
 	}
 #endif
@@ -450,7 +415,7 @@ static const struct attribute_group nvme_ns_diag_attr_group = {
 const struct attribute_group *nvme_ns_attr_groups[] = {
 	&nvme_ns_attr_group,
 #ifdef CONFIG_NVME_MULTIPATH
-	&nvme_ns_mpath_attr_group,
+	&mpath_attr_group,
 #endif
 	&nvme_ns_diag_attr_group,
 	NULL,
-- 
2.43.7

