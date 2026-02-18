Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B00C1E1DE9;
	Wed, 18 Feb 2026 02:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771382366; cv=fail; b=q+jd1tUXK4cOsuQv+9fLDkcEGJTl9RBoTeB3gSjkvwvysLZcGlDR+GWBIq9H+clu2ahy+sXezVuFosb6UbFIZVR0AlRvSBgrDxPvZQ5/W5Be2lQM2PKyZqVyFHc9VHLJlTk7Lg4Pyt6xW0LSAluiiHD5iRj6TZaF9UYtC6+muTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771382366; c=relaxed/simple;
	bh=Dd7CLu+9fev2IJanINbSHgVVPZpdtyGPbKD1tBG242o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=STcqgDfGK0wUZNQa+IquTN5QIebta/gTfreoag7Y+QZ6JJ1MaoajPn9OPPlcRji15Lz5qq6WatZDxodRvJd1Sw+p2YtmtQSoGTfqp4pSwdDOWreTsiEAbr8AsqXdEQF3C8Dxh/mhhMSIzvD+n61xGU3KbJe2jzfUSSWECwtn2Uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XCBah0k6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z9TsmnJD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XCBah0k6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z9TsmnJD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNMoL3675560;
	Wed, 18 Feb 2026 02:39:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=P4Qn1OQ73kp9F5IyJL
	PB2m2qj8hXPpxL8WUsnctgep0=; b=XCBah0k6AFwOceM93SUPZ+NjsORBPBFDoC
	n80A+Ic9axmL18QipqIVD8aEQCoiARRgUJwnBA2lO05E3ivZfXsowbOsRRkzKXYC
	rcMppr663U1Ij1HJO3H4lIxjiIbXRDnMnWNaCkt6xraIvYkqrCH0f7gdds5jrJJC
	fi1H0jo8iVgzVWsdBnP/zjEKzxBwZChddPJfZTLAKDxFmmYIi/98LlGz3ILjcElF
	KHWQjiNOZm35bJRJDb0orfxxjB7ysYct97HQY3Q2LC1WV9A9VIgYjdIl2fReKA3d
	ADhyJqj2tlQOefuy+JhIuwykP8xgJIv7VQiYB8hqTZRX+ODkCJww==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0avstx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:39:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I2Dqva037114;
	Wed, 18 Feb 2026 02:39:14 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb281kcm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:39:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlj6Y2e09cKDWIpGJ2OpxN/n+2cHNCt7fSo7fU0HpSHaEMFKDXJ1Ap4ab2R/nsOPwl/lufnastH/zxhVTCS0eXvAjTkSciuqfqmaNMXU1LWqfepo5u1ygizuUBD6GZr+ulmJIq1I2KbT6SrYPp0WqJ2jXLWe2E1u9yP5jEtKNckvT2l5CjUBEly/AMdXAG3SSeojoj30SyjUXbRvwgLznFk2TXEKvTduh3Gyox1wyz+LAIm/FEA28gR1VzGnwpZ5uSte8H2lK5nJnDpuY7O7H/5ChZIKGBRTMB7NPfwhtu6DcfdlUYcv7lfwH26SVfRauQJ0Sw0TJ0gTd/4ZwYlXFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4Qn1OQ73kp9F5IyJLPB2m2qj8hXPpxL8WUsnctgep0=;
 b=e9OahfgBRZWAyzqVDAVjEKV2Ylw+Of42T5GE5QGV4GeBoEkwPV+62A0ptd4mcLZtVpbPTVOHoJMSV03UbojHOrPF+ti+RXWWsqYvXqAzVYachHsRL4bmtgNb96/7zTTtTn0/V1/XJXcsCwfkylKyUjE6ISALapvDAQGZBtT9unAANoMAi9m2hFZ1uJocYfpcRcUgCl4aHBXwBm2pgnRp3FDv2QBUhuwNlivgd9Yqq4/y7ywephKDAeTb3rYWIvRKtrCWJUz6U7lC5a6UN4qvrwLgJ9vxtdrQBWOYv+c+UzgvNpjyNJQQD/39cH3M5pzWMkMVcPL+mlVI/xza/DuGyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4Qn1OQ73kp9F5IyJLPB2m2qj8hXPpxL8WUsnctgep0=;
 b=Z9TsmnJDH8zuHCz9A9DzFcOTfCiOu2aKCQQaVMZRRHm38bQYmXxrJ8c6mXtM/HTVZ8x+fp95hML597m9dDsLYlXVW0DzlJl/sIFL2g8MDh5K6mhTEQEkDMFHYAn3BoG/xfv43atXOVkNIybnKacU9QfeKCd8f2Epg1T++wUFEKM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB7492.namprd10.prod.outlook.com (2603:10b6:208:471::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 02:39:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:39:12 +0000
To: Keith Busch via Lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Keith Busch <kbusch@kernel.org>,
        John Garry <john.g.garry@oracle.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Native SCSI multipath support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aZTL8srSowTU81Rz@kbusch-mbp> (Keith Busch via Lsf-pc's message
	of "Tue, 17 Feb 2026 13:13:38 -0700")
Organization: Oracle Corporation
Message-ID: <yq1seaydbee.fsf@ca-mkp.ca.oracle.com>
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
	<049a177d-85d6-4c9d-9a9a-f07391046101@acm.org>
	<aZTL8srSowTU81Rz@kbusch-mbp>
Date: Tue, 17 Feb 2026 21:39:10 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0240.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: db88c634-bc26-470e-3389-08de6e96e649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TgYBczk79ZU9AXcN2KMPYMrEPWL8IfJ4y5jIddvauecEUYOJyVc1V0bP0AJ0?=
 =?us-ascii?Q?4FiWgTrighcmSpEWf1W9ThJHJ9xxe/sUIso0c9kPAkQLnP5sa770uYcokECm?=
 =?us-ascii?Q?Jf7d1NNZM+dF6qYXXmSRokxLvNTxj2R/AGvZ2JVz3xQfMpLANhWwPO0csSMe?=
 =?us-ascii?Q?hoQMXFAgoNY4WwqnjZd6W/4+gp0LG6GtNlpnlKraJTjYtHMB7LIFi8U2JcIS?=
 =?us-ascii?Q?uPLPqH1oixVBqNx6pzfRvyxAcicxaaQRzMkAQ8LewOlW9vttqm0nV2RyhNrt?=
 =?us-ascii?Q?mMZ9UV3LCvR5JMCXroHI7Flw3ZpzNE9l0idabX8K9nlv35exNS76qLT8Ni7e?=
 =?us-ascii?Q?4s9Q103f/6guI8wPNZ4TBQ86l9oOGHQTOiAcRvWtgWFgN7RPhmh0YfCoIZrV?=
 =?us-ascii?Q?dKIV+snD9SI7L3nyrBR0fOjJ0kUvlVdBEfAn3ccvA7F9wIqU7xHYwI73rYKh?=
 =?us-ascii?Q?Z6IzFdpG5Q+LD0eYHK+63+WFx+7wxiH+7hPutIh43OT9l8pA6fziiXIVjfWp?=
 =?us-ascii?Q?rpRwCfKAOzNP1jV58otlzHxVyXP6R3zZGwh6jCUSZjREGFymp50+0/ga0/Jd?=
 =?us-ascii?Q?uxOE0DNxrrI5weK1ue+HQxdAZ1e+Z+EHRKJaCDwvfnWZsX1qLETdlg3tN9v2?=
 =?us-ascii?Q?82/530pVUpVYNTvWh5l+048V8K8z33cPzBwW94Tala4ok4qUaXO+fJPcdYfx?=
 =?us-ascii?Q?k1uWhjFt/rAK8fPCTV0pqcnlZ/DeeWgKIqJCqFLXJJ8Rge/5WSNbYf8YD/oK?=
 =?us-ascii?Q?7zwQ+UkeBHQ2xb5PmWbqlxxRB0otq59rWSPRPAcek+v3RqylrQgWSr+ooqtS?=
 =?us-ascii?Q?FYQQJ3p99yXj/jFO0NeLAKhg3nbRDc+y02VXdA/sv/U6mMmRYCa58ClfscO0?=
 =?us-ascii?Q?pyRx9CnwOmyTZir/koLm074laxU1Wcp9uFRYaNkND4TsXo8VQQIQv1BVv1hS?=
 =?us-ascii?Q?/pj5ZWces6t+l9rXxBpcp/+0CteeGXqp3A1zoKbVskFZyTTcDvmJ3O86r2Ac?=
 =?us-ascii?Q?wnQvpC0e2DOlA7tBC4G9VT89JnTJrMlMj1rMc/gMfd+cOeoq3CVCJ9HsAtVV?=
 =?us-ascii?Q?utCURP6L82jhQCnezBQxRrlmDD5elaq5r0cSJ6HkPHyLAtjylavDgnQqcOGN?=
 =?us-ascii?Q?NdRwWfikJeqevxBVnzC9vfufwOPjssvR+TIOnHx/4n7ABDeWmII4TzXRfPZC?=
 =?us-ascii?Q?hwXu9xazEFYELwx606smYGBzyzX1ahnaki6QJ2hdmpqQsAH+gbbP5hpzDkMg?=
 =?us-ascii?Q?BwLxrOJAMqOD0apqM0NZ6aTCukAJLCRZYQ9wsmqD3Mvs9p4ZTdW2GhUSFnXl?=
 =?us-ascii?Q?AHOhaoPgOBx22JPzJQQ2fZVTLLE871Kd0l3QKCB+6UZ2OwbxaLQnpWSxpvss?=
 =?us-ascii?Q?L7vgComjbZp1yEwPyGEA8fC6DjkPSb4ffcxSMikbcuxez2SYQ/XxmWA1x0sW?=
 =?us-ascii?Q?YyvzwKwLZ40uMhoXoVmnW2ZzJCXF6F9arMRVMO9Q7/qxZAZIRe5Bl72s89VP?=
 =?us-ascii?Q?2lthUpJ6Njh8NPyTplQvvGRPd63sY/X4yeA2/ekxx/MYaWXbChm3+wrT8m0L?=
 =?us-ascii?Q?oVpXmWDCQOqTvbjoxjw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HPvYJXs7M4lCWPNBEy+uWMK+l+UUBDE7CS0MsMEmTk9KKdm9WWul6U/qvbSj?=
 =?us-ascii?Q?1eL4gwY86BW01J9flb7q9mnGD2oxZzBc1U3WULe0yPW3YqthK2EzHBWoCuZ0?=
 =?us-ascii?Q?F9Nyw/xEZsIURM+dDfV+tAKLDqwIVIAYjnIpn8dgpjcudRLa4PkalWb7dwJD?=
 =?us-ascii?Q?4lHdcttCXXbUADO5YSdqUyIuzy6/8c+bSmTzSr0L/s7g2B2AtNQl2snCqEtA?=
 =?us-ascii?Q?aMiV0ewLFZwg0WyNBBBS30SyHvbHcZ0So6nNBXElzWeUKw6x/be2x2+dRBKy?=
 =?us-ascii?Q?KubMKIaBOHrHav83XSuhGOJROcGAmJdbGpEbnYsPt3Cs2n51SaTTsbvawEqs?=
 =?us-ascii?Q?of/gyPihAJykJVab0s4ODTaK2Amaj6sYouEMeCndSaG0QIsXKzI8rrITnimK?=
 =?us-ascii?Q?dsKMKY72wIfde1Qxyt3pANWLFnDVA8j0qj8tDcgfDM2z+pV1yFkljwOTRt6N?=
 =?us-ascii?Q?apaAe3K+yeimKuf85UU71BdQ1Ss+j4O7p5rbX5JNzaxbYxlnFJSlPYwUZdvC?=
 =?us-ascii?Q?uqK5sGiie5bla+XSN9FaY+iEx47+ylt659JYHhUVMFulcCkg+L/KCXW5Hxnq?=
 =?us-ascii?Q?t6KN83Et3K+1F2ydWZm9BkYx5YFjR8Dkvuhu4HDYNOk/273R/XRqRHqpfwuE?=
 =?us-ascii?Q?ZXmHaLw34gfmNt1NyLAeop8Xar21nX/VHZ51MJuFjjZBBhEj7qGFnneI92tG?=
 =?us-ascii?Q?u2+miaAvqXa5LMPKFdBgg1aNy2TwOi4lxRaP3yDISbT8CBxir4yGtbJVC2cM?=
 =?us-ascii?Q?LN71MRzJWIfLMkSuge3NIH0BLdMWJfMS/GCdAfdeoxgDXap/chEDsyWd2Fbx?=
 =?us-ascii?Q?l/jkVfuMCq89dBZgz6hok5ordCW5ArnR/svK2Sjdkkvf2tfgMWwib745CrnZ?=
 =?us-ascii?Q?YTM0+W3nihKMIyC8iDCUY5b3r/+NJiAgixhVhDmAvDHSB27xyBmteicttT7y?=
 =?us-ascii?Q?GbknLcKQR+MnbsLsArbaUW2pva7MNiyW7Q9t1h0Ib8qFojN/qaJl7IjsOSQ3?=
 =?us-ascii?Q?PubwrNCtShVUbf305r8gpYmCO8e9SaDvmsjAwyIyS/VrrftV8pMVZ0ua9IJT?=
 =?us-ascii?Q?HnsngO4RM0uF+eJIf2CU0w/J9NwqvuVZp/iwG+iH7qHgrDQyAx5XCuBcrQ3f?=
 =?us-ascii?Q?JKQwxDUYl652+/y/WY5myRiZUlGzLlLmVvnkrDpFN0qsrV9qVn6O8t6beOu6?=
 =?us-ascii?Q?R+WTKw4GWxC7nTD0xq5oqpnu6jF9c2bsfpZ+QPoodyrP/DV/wIfpI5ZW7Lfk?=
 =?us-ascii?Q?qN9QKDxr5BcCLAS+JDEpSVWrC4V4Esb+GD/6Gy1cl8XJUg7ZMuYgKFQoNEfD?=
 =?us-ascii?Q?X6ywQG9xMG5CCUh3DbR7sn810J+d8WzjplHyUsBTmfPi9HEUGiB9WJrQdrA+?=
 =?us-ascii?Q?sKvn+a2V4GjArKBKhvGyjH+sAVXiVoEiZd0ThcyxDsHjaL+PXpqQa8aRcEie?=
 =?us-ascii?Q?OI2r5T51PJ5QXKpAQa5KGnx9MDjYkCyQD8aWGlOdNoSDOjXbJR7rQTti2R4k?=
 =?us-ascii?Q?Z+yukf9m7PWuHeTN5CLsTA7zJjpX6eUK6jCrKnB9ICCGnlanXf/Kf92Cda1C?=
 =?us-ascii?Q?GGsiSV3g9P4FMZUtzFanfepRt8vGqdv00GLnpsWwW1wNSAdnTUg/PN7hemWd?=
 =?us-ascii?Q?pPnWsuQGRh3ufDxi0xGB7vrBJgoTNyEAtwiQja/TJZUHs9X9b3hnDLIi7gTU?=
 =?us-ascii?Q?aSMUDT91EWqggQEHWBXVRFhAjt5jwO/4vUU92xfw3akN4qvi4fjPSePiKHFA?=
 =?us-ascii?Q?ekH0f1T748FQ2oKbHZ7T3oKGl1jVBaQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	loTDb+uZuX7wsoeMwmH6DFm2iarPqCPoJ2TvkSr40usQ20foNaLe7AAqafQaaVoL1Cn/wAp9s7l2tK88yWL6lf4J2fnaeQ2t4YddZrNIjr39UWEGsoam7VWDjS+bcoksZbL7iyeOLf8Cv0J2+t0zz9DxvjdEJc1gixxQv7n4HHScayILGdipt35MZytSfVLZacgVW0thLBZ034HnZ8/oOKSlDO4b3HOyWtKNth3JJXHYp+yF9rtLai0VVioyc6dEw6S5UaqYTQLcwzGPBQbFarSRMjhdcGVn67WURh5lQerodyUIxxvjDkRPneQSxycompo+CnJPMqggaqcTyjuQX7kIfHiONLNlA1Z03h6S4p3AoOCR9jV3uhbt0VsvPAO5W+tWTmnTtmiOfBizPdgyB1MW1SJUcnsyTyKosPK8CaxBqVoCQpi3bFnnFLKCoJltA8ooe0h1I3KjtAMzV9q6EKfT4SArG5Y/OutKAuws8FKoH2HtX81ZW2QbVafSkVcbYVByLvqnpNhg1cMFIX2xfYHo+VNUNWRvFUM6BXuGPt1u8QSEmsLV1Yugh6n9buKpvIuYuCHW6nEDPDavv5ixTI6byd+iB6NwfcJPFb/o/UU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db88c634-bc26-470e-3389-08de6e96e649
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:39:12.2469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihRncLRXNd7vPm8Dyvjs/ddq/RD6ap/ChrFNNrn6yoAdJmcYP/+J2ma6zZ3QQZpWEOet05eZoY7S6jT2JYDxGHMHHmmdMShRn1dlycpZj1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=766 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180021
X-Proofpoint-GUID: 7y6V4udbV0-3CMEeuFe7yrQFDYBaZfoW
X-Proofpoint-ORIG-GUID: 7y6V4udbV0-3CMEeuFe7yrQFDYBaZfoW
X-Authority-Analysis: v=2.4 cv=UsVu9uwB c=1 sm=1 tr=0 ts=69952654 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=weTNXte9K7PlxK308q4A:9 cc=ntf awl=host:12253
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAyMSBTYWx0ZWRfX+205SQfBoxFF
 oGFBL9218guankaC08sXoS7VXbAkjgN0ShzdRp/e2g7ltmHKjGf+1fsEvZPLwLUpopilE3DeC4I
 CbgcNbMwYT14PxLPJlpci5owrNpVc8Xu/NKx5XRHjdFMj74aV52w/DMHGrRJ0/bir//+suigPEP
 P9uxcBnsOM4w8o3jU3aQal2mBfcA42bEU7ztQYSfJMTnSMOQZMqPrldO++rICnd043JF/M68h8f
 XJM5QgJ72oxZ2+0tS7JzRGuPY55AWbJmaeYCS3j6zQxH/3GgsAMeSZ/hAQ5b04lgSo4OuqL+OeF
 02lf2HxKP9hmh9HCbCFqsDpEMrqVEG2QMPxuVFuuQhQCo9+4bQysOIjXvEf8lsVfjbuKuu9+Sk5
 XQfE+SX/gvPz7OtZsOQFZP2A20tHbeV4R23LRd1OWBBdLK21cbSBUDRi3hnNRrpKjcZDl1PBkMC
 6I8ZaCXb061OhUi2nfmPVKWLXHFU9vegRtZWiviM=


Keith,

> For nvme, we can detect if a device is multipath capable.

Yep. Same with SCSI...

-- 
Martin K. Petersen
