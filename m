Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA96D3207;
	Wed,  3 Dec 2025 06:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764744243; cv=fail; b=CokqYWoeGiRz7TnglUGKRJA5ayjieZcjCYaLohjgs2qfbVQWQBaw9f3MJUnq0tyvcN0uN1rXDZw/cPdsszsHMvmHQtTaiLUHoVZokgNWpeiv+ve0N1TioduHkB4/FRMLV/lo9vmpbMgL4jL1CJcat+bUyt/hZHFFSoviUg+9CyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764744243; c=relaxed/simple;
	bh=VmpMlnJKRB99Qb+kD6NIq0etGeBzAMyxIasD+ZuLVFE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QlOvkgjcCXzzeJeAKR1ZDhnWSPTDn+XjhzR6aESGzuckHOZQeu7aWJwWw/BvodPx5R7kSXamjRVXlTjGtjKz5kGe1MjPXMtbkDaMnR/xmNljCKfpszV8CjRIEu9V7EgcY+eU/NpCF/h4ENU9QRgXEf7sGDZa3CAIqRr/ZSeAgJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rerazMFj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lqevQCLc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rerazMFj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lqevQCLc"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B32ueoj1669931;
	Wed, 3 Dec 2025 06:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NNEQn6/IFNobY0wibM
	qnCph8pBwBG/++SYsUf51LLEM=; b=rerazMFjwfvg48n1l80L41JFiJOtShnmlU
	lFVCKCftCBv/GqD+jOdAWBIiC9N7lTGnpt0gjRTREVJKRdoZkzkq1kB8MgsUtEmk
	QXO1hBrG79V2zUR/fs0oXr7K2wSM0XJ2dVPqf/g3eKtg+/fitpejCkonmXEG/rbK
	QvZk4mIqe8SiL7azZ/6HF0LAxg1I7b6Bytq5aPE1pxe2c23WqhdBWgyUyg0B5rhC
	vtWXHn+v/UhB9ctcDGZtC/SV7OfxoyuGX7DS8IUyTobMiV9YKNMdh5MIwi3ZtyJE
	fZjDYgOMJoByy2dkRo/hepd2vUK6ZpLfbViBCjJoR87uykBxiV3Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as86ycjjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 06:43:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B3407w0016444;
	Wed, 3 Dec 2025 06:43:27 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9a2xmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 06:43:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brWqvmd1gWVEXW0gfTZBwBZocPCrt/8x+oXS4EUQEyfnWYUhxXctoWaZW9jhjeX9+JPUaX5wBOMrEyrMm+4dSck4yCo/YA9iyQO5gNMGnrkWc4SywYlY+g93iQSJqu+4C7q16mIed01K6cHXD41+LV4P1Xz/JIoqCa8luK3yXADMTD8EiWJprmyOy6LewpFfzXnB2iwde4sX6F6vorjcRXCrxT/BELB2GUBhlQpIU8qvvbQbVcaJUMSW9e/yiZAfQtoKHh47sp40R5VxYtNla0XM5mWukSkt91Eqh02Mg/ne44MafVRHtyHESykcN27XqZqvD3BfJ/40KbTycmE+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNEQn6/IFNobY0wibMqnCph8pBwBG/++SYsUf51LLEM=;
 b=NczW32SLhHwJ+sIzm1eGq5Pp3I/ZXTDJ+/Q0swsRdJElF27Z1l+22I4Mgf9JxFBfpi+c1wV7guSE6hqL/iZ/qWzYVbPC2oXvcjIlgiyQeGWXhmf7N2Q9cRkNedbstmLwllqSmpsJe6BhKljiOHv3hppUi5Cz2uoQ8Jv3j3FwrjE37A8/2TeB8s05OzzLKk+vGEVxdzJSC5YmNnVHsEJjcEXvtBLEPHSHRYsDpZKIXws86WK6MY8AGMDHZ4S3g49dH3vO/D6Mf9gA4SdJ9N9Xx8XmKUq8uLcFM2Hdf2QxaPeTiwp9kJD10Zt2UCvIOA2mRAitEkyYd1CJE3QU/Med9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNEQn6/IFNobY0wibMqnCph8pBwBG/++SYsUf51LLEM=;
 b=lqevQCLcfr6nkFPp4yN6E0LXR1O2Qs0YcZ3hGzU25BsD6bOBVKVAK6UhMpfOqp9bt2p4gFbxR/H/YPeSc/IgUbhbbWHjnmqCC4sE90lunZI/Kg2x/nCQBgHSSBopBQs+3zIiuN098hqNX9ekdZyajbuExfr1poRe3wuU05Pngh8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB5736.namprd10.prod.outlook.com (2603:10b6:806:232::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 06:43:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 06:43:02 +0000
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Keith Busch <kbusch@kernel.org>, Jens
 Axboe <axboe@kernel.dk>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Christie
 <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v3 0/4] block: add IOC_PR_READ_KEYS and
 IOC_PR_READ_RESERVATION ioctls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251201214329.933945-1-stefanha@redhat.com> (Stefan Hajnoczi's
	message of "Mon, 1 Dec 2025 16:43:25 -0500")
Organization: Oracle Corporation
Message-ID: <yq1cy4wt6ao.fsf@ca-mkp.ca.oracle.com>
References: <20251201214329.933945-1-stefanha@redhat.com>
Date: Wed, 03 Dec 2025 01:42:59 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 67c987d9-e898-4875-2803-08de32373479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uZhDQozA3OrWV59VP3glqO+9TmI6HQG62wYy8aDAX8RsvIhke0XaYw2h/x5o?=
 =?us-ascii?Q?vPWisKgl1lO5VTenu5nslhP8G4AwsimPVqHlwgrWajughUiwbxnBOAa7uHQz?=
 =?us-ascii?Q?MwKjN5ogB/48FnDynfAkWLiwKDe2J7Y4XGe/Thn8gYbk4zeC39rMqrp6er/H?=
 =?us-ascii?Q?AlOKzjormwrJJhV3U722R7I2tluFZagScmFPjFEpAvi9moO4kx0AW+u5QHTm?=
 =?us-ascii?Q?zjm0lYU1h2SdbQj/XldnzcoLti9Xr0sZvJBjzuKy4R6e4en4ik1zZVlLUmM8?=
 =?us-ascii?Q?4S4ClD7e0gtH0T7qSZb69nt+wPEixu/z+MEoE5QuVBlO4GUbcITNddEW4bw9?=
 =?us-ascii?Q?RWVvgEEVv51tir27htcAbjHZ3P/XCsmIGISMrdkgpH5wtjMvf1+RtblhnowO?=
 =?us-ascii?Q?fLEUH1o/gQaMQs8JkwghyIXW7sgf++8iWTSAj8tqmAlxEzgeHJ/E9wrBFFeR?=
 =?us-ascii?Q?k/r3/cx8R+/rIE+VgQycpHG5lvNjKFk01UNyQG3txYAJP1mXy8OukVkgScHy?=
 =?us-ascii?Q?AyJEI5baxzPH7opx+KkNQpxraqxXQakTkmACz2TJ3TURMEkFvwfdAclKZv00?=
 =?us-ascii?Q?UB50VQIjnuTMXoA2guss2X+MFoAuhA6Fj3jI2WDEaS+gexBq+9fCnLcWQ/s2?=
 =?us-ascii?Q?EdSxG7BTlEDNz5177qS0/t6/pmpaSPgEIZohe6AJioFRaTrvskzteD9s2drP?=
 =?us-ascii?Q?axf6n4uH8kF0kJUDcPdKPAgyFr1MN4hcHoPax6ZR47pYOjH7C/culjECmKpX?=
 =?us-ascii?Q?HOJRzo6R/Kxef9lNWNp52YDBiwwqzpUWpYJ6rvtQWO6EWOdVBejSOM5TIexI?=
 =?us-ascii?Q?CEuiD5KwMrIfqX0FsrJ5HyxvbQ4o9o0Kbr84cN79O8gfLGTJzcjY2bBIq2nx?=
 =?us-ascii?Q?nE7ArXJDzcelu8MVsjEu1Os6SFyF0VcYbKDUyb9TfMpVXiXwx8r6f16D20uY?=
 =?us-ascii?Q?6WnWABMebRrK4pH6jvB76cYZir5gvbm8E2oZIobZCB9GgwBroRgKpE+NDXv5?=
 =?us-ascii?Q?MR6Rv8wdiQiBJaqsAmmo9U2/e7rFd29pI6QyoNxB4CAeRN78zYNeVLVpO0Or?=
 =?us-ascii?Q?itpkLbaNe++BvjSfGl5nYgpwbSpsLGW+TRbxcxJmXupDUqEilVUzZRGWAq0H?=
 =?us-ascii?Q?7hPRZlwMhl4QSTTXA65Ykav5C6nY8ewMJQ9p1649cl0zZFzVgfRhTzwvuEes?=
 =?us-ascii?Q?fG+DoBz4tuyBgetJuL3r9mfDQiYmkS9UPYQSha17S1Azcc0GTtCZuAixwq6B?=
 =?us-ascii?Q?HyVJbSzfFDkRc/v5SwZOsNUfuAq/NSoOkDzmayhh/in6GGjGno6VSGdYCy07?=
 =?us-ascii?Q?FjaA8XMe95kDGj7WOlJtlY+PH8WJVDavq347Lidubsp2UdDtOumzIeo5pqht?=
 =?us-ascii?Q?LrSiqOXexwU4K9bNRx8ylHrRiVBKxn3gqJNWbXyeJKPxJENxp+jyJCglsJst?=
 =?us-ascii?Q?FG/RdNpRV3Ju+hJ6Q4omjx6AHToHzzeU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OafGs/eXbVcO7KoE4RVgOci0yQMMs+ttsNYCbT/xZM8T5NocYh3t3LlCIXJZ?=
 =?us-ascii?Q?gtjIve5+qY7j9esXMLm6DLLF+uUj68MWUiO4iDBzlNuxBPRlGU6l6UHYZSao?=
 =?us-ascii?Q?93lv6sM6asvoea9SRjg+LhZT4pHoFeX7XRXNQkYmtKjlOa/yZ38yM1b1WkQk?=
 =?us-ascii?Q?s/xpClsWM1YuD5hzF3PEdXarX9Yn+juHnZmZ58R/84HjujJA3xq0abhlAVrC?=
 =?us-ascii?Q?sg4Ezr671JzKl454PW8VvRr3umKkmqbRe8k7/Glf57AvRAkvrgYOLP5Hyk0r?=
 =?us-ascii?Q?iXdrybhNGak4eXnNcfGJLToCqJPkVd/5To8N7Leok68/rj5Jfc1PPJVOyxS1?=
 =?us-ascii?Q?kQpTwP0PBXj6fBlSK69ZFfjsYAmpghSzwQwe2J9klnlyOephWHePJXUwmS1T?=
 =?us-ascii?Q?cW+3SOkIkxY1apDV0Vd80lr0cuDZ2L7/JgV/GFPceVSRf4A61lynPQXe/reB?=
 =?us-ascii?Q?X28kbllLasKzAv9b3DaYGl2+xz5sg76jtnbh/ftMslb1kk6RGsPqv2PQRRy1?=
 =?us-ascii?Q?9BxT9GQQpkAyVZlZFQYDQqqGx1yH5Bw+nxRjA8T2NF8mznwLE3zIowVzCFHN?=
 =?us-ascii?Q?EQhuTumYa6Nu6oaeerEv6MkqFhLtVRKHvFeK5OyruoEvk3I6lKpg+4YBARbF?=
 =?us-ascii?Q?27/1un1oRDvClbNKtpDi3GXgkkfdmhmZNUVrx0Ke5yvuVN0yDPzO4W8+Be1w?=
 =?us-ascii?Q?jZRbZCv5dv+jSe4z3rRKSv1neH38ya2eVqkWsjwpVnFGUehvc2Q2Pjtj121C?=
 =?us-ascii?Q?K+zAVAuyT7mldxgHPDJUZ4jIBL1st6rGyyUD1B1VpLkWCKoaUA1+13DcKENb?=
 =?us-ascii?Q?ix//BRyrfXcFZSvujI01yDSARFptoQF67xCdFvc85dIJkM9XcKPBe/RpT5Fn?=
 =?us-ascii?Q?LW8IuQBcWvqFYK9qDuXkZybVhGnRBhPiA2oODtbi/6JqGlGy7HBfUDf1Z/Uh?=
 =?us-ascii?Q?/b05Rn0na+Yw9+DYq4sj6nN01xsWzc3KJnKRwr6SgNk4yCMOHwxNAgX/Dtqj?=
 =?us-ascii?Q?63faEtOAZP012A7d6dw3tgJAq2L0kL9LFYF86nPYlGJ5m212JOZHzzfwYOXA?=
 =?us-ascii?Q?scg+ndcDpYKTS8efxsvJK1j000rnCHAUrK5xK9fjnzjZOQxJCTWn1+pqgRZh?=
 =?us-ascii?Q?DsFuqVg+PSTwOihna7oGxEDI4I1cio668ki4qmWMbJnAMVLzkNYhSQGA3JU5?=
 =?us-ascii?Q?NVT3q3xq413NbdOBEwOMP2gHYoWJpeaKO3yG2ZmkppH2+MzPIKhNDURbvm4N?=
 =?us-ascii?Q?GdZt4ns4vwey7xJszLwyuAra3EhV91NI3bDywHdcejXqgK/R41AJKxSbQ4/w?=
 =?us-ascii?Q?nkuN4hwr54JZJTxheAW9KQNreJa6dwmp3Q9PQl6tEshKCUie0o1J9Bmift4p?=
 =?us-ascii?Q?Ad+lfovQJZrnprTCaq3+GPGhBMMozX3Sqt0k+iImaIEGD3y90DebRZU1ZbmA?=
 =?us-ascii?Q?ld7jU363xcyKp/lVjVA3cwAF58Jgj856uAHIpCQgw8SzOAX7SFVW0dFtxDD3?=
 =?us-ascii?Q?m7qIZdFmLH+4/n5Xzey6z1WkTBrjVjqNjXZ6esnAmKEAbvzqgjR87PplX5HL?=
 =?us-ascii?Q?BSEBsLLbULQB2r0caRIlOvNsi0xz3IJIgDMbhi++DhlbWilJUiuW8v/mUifR?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zyIZnUY67zZX5DWVX7+j/VIXATacJw3Nur6QjyBxFz4TGfuN0YQkLG6hnAlXktaTgyb6XnO6BaTYVfMOF9STnIUqb5huTiygplZ3OsqPK73pKqZMm3scseL0d0RJMhI7yUjxRGxS2dyM27aVGeOqqmvkZcEdH1jRYAB/wxnaIj8+gvROpijmSzv6cN26FaLL1+5uJPHHY3IlX0/Ib+MqxF6hJgvr2r0uHvoFLLk6Cyz5dP7bDfdDgz8/S3K0dmnVGvmcyIKzBWo9zsG8LRVNHNY8jtdl6poCayE+3MAxzxz3Hv0uazobd+Um3HjjNvnmu0Ds5yHeTOMKNA5j3iqoljSedDaD/Ms0h7GE2UYYGVQbENYM9UqtflpNLyqPRFIOL9bMTYsP1/5IxkISKpkcqXeAb6luoxMGkwbi+u20LHB5qNG6sIX+hpjUdCQzs4exTAS/P/owKH1IM+jDVetUD3kZDj8ATMi0IPxeShy9YY8Gkq3P27B46mb1VjmjwzgkID2a/DF40APPp9N8VEr+a+FEdTXafJtaOl9v3TiOUyny8kHh0v60/2Ammz599TsI2vSRS1cNEtoOgLSVCoDXcMzYkaHl93I/EHksAJP3DB0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c987d9-e898-4875-2803-08de32373479
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 06:43:02.0040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eme25BcyjhJtRe+WKShcO4qGg/KVB2RiYVfSY6mjQn34kIL1YdYlMwbMGWoGxQML5iGsbugWR7mh9d3P/mVeluh2ptcd+tlBaJgKHb/EkoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512030051
X-Proofpoint-GUID: UFg-f7yyBlqLyMzcMRJZlzKAxxCETMh3
X-Authority-Analysis: v=2.4 cv=AaW83nXG c=1 sm=1 tr=0 ts=692fdc11 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=kOD5xOVBVMNgHCKJDjsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDA1MSBTYWx0ZWRfX1swVJHvoL2xC
 COfJcYPBBt0PEd4il0tmBECVPkIHpSMT8SakBomdfPq4qkgr4WDn18hjOF9zJpDp0f905cLtiMH
 welME9EtQx7hD6C6XSQyE6m3o0kasiZpuxxm3SEgmidw1xw7KHm4mGlQcoGxFr28CmuyBg5HFIO
 IzJRE7e+Dm0ynNiPokgLFhojqM2QwV5OB3CwEVCMknpb7abFILhuQvMuKZcJBQ/lNmjylHQbCfK
 MYoyqSTcmEqPkC9wQygaYvPkvtNEAkdFLSVLTOioO4jHViNqxtc7WxzYaP59dCKGwrUo+1eFa9L
 DTgJoiqGORPnnG+Z/dZJfL4uw0s2MGM6j6Py3143WpEziejxUiBJUMqPORDVaE0WjqSZ5273MP5
 cpTGtA2wQXaPr2OgF/iZvEHFhDQZIA==
X-Proofpoint-ORIG-GUID: UFg-f7yyBlqLyMzcMRJZlzKAxxCETMh3


Stefan,

> This series exposes struct pr_ops pr_read_keys() and
> pr_read_reservations() to userspace as ioctls, making it possible to
> list registered reservation keys and report the current reservation on
> a block device.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
