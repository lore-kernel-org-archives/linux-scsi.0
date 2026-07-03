Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6593BBFD5;
	Fri,  3 Jul 2026 10:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074669; cv=fail; b=CK2EA11sYLAplV7nLxN7Ex/vLcaDNcqY2RI3okfQGOAm7XMuyNdqHLByvKncppTHroDSJgANHbKyQzZ/H1rIE+Gk3eS3TYze8eLNugrd152fqF/nzjSrAm1lb/YBUShZy9jW+TOZ8jVGvLnJhf1Mo17drQL05vQyCUU3wITDYiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074669; c=relaxed/simple;
	bh=CoKMyMP/tluwPiVkQpIfXKaIcDAcmRXHOaItkob7Bkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pSqSlzPzwh3XQ1LHdpHQ5Avp+yz8/xGtAgwkeF3YPk8cNAB3JjTwXxiXjgePjGwtgR0nOkIjIV6piMFzSGkUeMK8/Yf6Z8YMmF5qcUV6ucDl5Pm5R6CYucCO6GBMx3/AXIkIkgRZrGI13ntMcl2ep1Gt6ErtPz81Pr56U+2jFHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WpB5jdNW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DDlOxoQL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WpB5jdNW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DDlOxoQL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uHD33340011;
	Fri, 3 Jul 2026 10:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qSuV3h9DOLRvH9M+Do3qLhBTpYUuw7tsr0IXdfvGn6U=; b=
	WpB5jdNW6vUMrDcL4pumVPM4mn36IKofmEVngHstKTUBjlBd6gH04TBmorOTHXgM
	mIdXFZbEFaxMWE/sLBZsDirN7/BwCXtm3TUD+0U7m9xoG34EK0puCILnVXZTjURq
	Us0twz0/1yDJfcc1vutJFNVlWK/ak7bkHIh92AMNEaK/bLM6quf/x0f+tDICM2a2
	4EIbMQECt/AJ30KWicd2vWQ7KsKqwiRbpxl6J/AS9u/IOCzepPlPyfCnmDXZNIsA
	Tq/ErxmNt0CYPd+N2IAkplqRfLjdK3rBnpz9e73oLWj/nPVhHs0x1BScZZb2mRLH
	HvoUQ3ZpHt4LDVMXBYBGlQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p8tk5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS6X7013032;
	Fri, 3 Jul 2026 10:30:49 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvq9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYBJZ4z0+J/d4dQ0elvpk7v4uGQi865hZsN49Vt3Buj4VZdmWCoWWEZfEthJ/mzFcegn8jaUoEOhTTLuiWd3rYgdazIwLlcU7WoJ/NLpcTgRNGc06Q48b4pobPspHxndqQTF9ll/VdvNdkzVdwkGBOArJvBlzilzzykF7z5cyQjyJmU0JUyB6C9pAZQmNNaJKDZvTkE2SnJdovuFXm7YIyWkIgGqbzzqOu1nlnIMWPCLQzS0Ae2/wczlhdqrQStZzHLPhvvErsWW6CaE7TEooDtvclpFkhr7uexChgQBpxKOHANsYkEO0kW4JGX/TrWrx8yy5Fhi2oVnNUMw5/8Psw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSuV3h9DOLRvH9M+Do3qLhBTpYUuw7tsr0IXdfvGn6U=;
 b=FMl1k1P1SG6DwP7PFzqR+E/gv5iI6TSn8XQKS4gDKkG3SiU919Zf8mXuBGZU8LmEDH1+yyZG8IIuFe/Q0wQxioyofNvgd90TOQD9/q6Yt8gRW7EK5E2QavsgbEU+VZJPVfzdrLrRY7kCVkf9AKEYaZ08yoAC3i+uxsnagUJwxxIDOiGSS8lwEe+0+3INM9DU/KwpUv7QPV2epls9ZssBGHcdRKOosju6I5wJwHsWWHxjniA8WK/B27r8BLQ0tYEBUgIVhxprcavE8/OarjbEi+1RQxpV7FoHZwqCzMy12uPNWJ/IxPnpkYi1xJbA/G06QR3D+w0XlwIlTq95zPsQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSuV3h9DOLRvH9M+Do3qLhBTpYUuw7tsr0IXdfvGn6U=;
 b=DDlOxoQLmrc/DDONcC7BTEOu1IHatCSDdJ8YUF7FjsE3TskO5wgEINe5BRz7J/lXBkgWeTH587DXohInab4cCtpWuVUF02+GR4h8WlgQJjGatqY4vGTDGir6MYFGhzFWBKim7t9tiOfIpvD+PF3y1/p5adNXIN8y+INYkmoYrlA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 01/13] libmultipath: Add initial framework
Date: Fri,  3 Jul 2026 10:29:06 +0000
Message-ID: <20260703102918.3723667-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 78cb1230-c30e-401f-478d-08ded8ee1fa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|18002099003|56012099006|22082099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	6QLhjNVxWAGioINliR+dzWpa78PjWK2kSD0zAcNOQFU93yMoZQK9t5skmKrbqltYRLq+ee71vkyKK1ni6B6mAxpHeO7qNQS/oFo1RgB010qJWaA76Q2b/WXJreZcCDbiMwiqYM9snd36nmQoqPPbQh80ZCJoXjU42IpZ/XcAQzvqYN4t3iXg/xtrxdNGaRFxtWeQFwCiibs6ylsQHZZjMtgFagXFK1hV0cLa7X9Be+lgohQfiUCE1g+pMY6QWYaD+DX96cmzMwxWwe3D4lHa/18+sEhM8al2bliKRDRLJ0YXxI9n8VFbaUDd3i5USGq7apDmNtXimmIW/IUCRbZ4ooD7fY+QgB+nYRXhH41pGaGU9F0oY5Y8RL4pD1fsEGLPBer8wl+4+9b7eBIZ5CU1ATnBFaOQYE5Tjs4PGNxHU6rzKkl5TDv6he545uWOXxCWMW9SHf5+yQwn+8ZsoyC0LFlgl3NuQUlmiXCK4WsH1iCcetyLHpLGmsJU3PGMSiGhIUPDlAVpVnRrGtjCTCBsrhQZHZoTH8KjxyxWE97gDogv4VtNoO6HeWyr5kbDCLrP3u2xxA6E8Z/+ssw3tWtlm7Nk0yc93Y+zlBXWoO8c9bN8oM6+KKuj+hRpM6+qokNHVsgzbMPM1q9mwwb6NHFJJtiC74EgOQHqVwqjm3TKe1I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(18002099003)(56012099006)(22082099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nrO0ZFKwRcTMyJHoWk49n6kwrNNeXtUk4Ensm2GlLzdOCDVY9W4UCNki6gWd?=
 =?us-ascii?Q?mXRV3nL6PSIKr2+2QUS54l5OhGrC0FaHGqL4rQc15cb0RzmGWQnhsLm+KlK7?=
 =?us-ascii?Q?lvOkIbXSYqOv73KHgktX8Bp15wv8eo9ckpcRwh5Y2KN5Yx9+7+2C8Y3Mhhlf?=
 =?us-ascii?Q?hcaC6I9XjTemc2CpOuN1cI8NP4cOdKGqNs8RJnQ+C2gbNt3ylGzcb/55GMOr?=
 =?us-ascii?Q?TlzAkK64Iq/cbGm7uS9NDN3DAHJafaat+EwhcE+Oq6sSwHgxOEK39bqxuJ8p?=
 =?us-ascii?Q?9vlriFYtqw3f9FMsqtIROS+nAquXr6V9UKGr8J5YhsI5QwQ331gIRwPLF7IF?=
 =?us-ascii?Q?ciR8vRJQc6hp/Eg48oPtKx9mJyIefHDzc/cHzZd3ZAt4CKw9ghnVned7diCl?=
 =?us-ascii?Q?/YMrNa/+5QGFb/E/HIVzOek4ZX9wDm9vWOaRdm+3v8yXC0ZNtOSgiGM3Du1Z?=
 =?us-ascii?Q?ZlcPbTQfTIqBtoguFDFzfBTw3lUdzDvtOFbzg4fDwMv+dbfBFNIs6iPCjx8j?=
 =?us-ascii?Q?0qwjAPS+udrCyNUoR60owI1bQY7MuXvdAnjPasLZ6+udj+szZ0ppvp1EqHB0?=
 =?us-ascii?Q?f1QecVnW+dQHCKpXi6EfJ7GSEv+m45teLFA6TscX6BjJXKOB6dNLdNSSo38o?=
 =?us-ascii?Q?2WhVG3wBa5DM25/k7k2iAL4NRjSh1BXFJJzocUpDRqy55mbTgqtSYyt4rXE4?=
 =?us-ascii?Q?oNiqrEurnSNOc7sVcTVE2wtRKnCLzBs24OHHnpYvU8lWR8B/yKkEPWPGh7Xv?=
 =?us-ascii?Q?gPx1f40nSMqQoWBCcybY0zGKuYdTKpj+wgYq0V91IjrDNi+Razg3L8JonaGm?=
 =?us-ascii?Q?qFOrbi3hx8qcn3beL9Q/7T8NfiJ48m6h/3HSf/Q3gALz+2feom3B9QgvfCTI?=
 =?us-ascii?Q?OeuttaPx10xbMb/oWz8rXYCtzXwiG08OFdEhHyYlrb04xbd+zGFouzbH2q8D?=
 =?us-ascii?Q?sQlf70Db9LhC7pEx4UWl255sNcB5S5dE6ZIkuWLXjZ1mV0duX0HLxaQ5qrMR?=
 =?us-ascii?Q?IfPszHNmsUbW4T2L+bRcsYVy2l0YH0VOVVkV6Xpj4mMRJTmAZ+sHGoTEfpko?=
 =?us-ascii?Q?dr5GQOl0tYysqEfyHSPv+GnOO70CUUf6+uFXeZsWbzgNLZIXcqki/+wtJQ7W?=
 =?us-ascii?Q?psqw9/gYINFimWzqI4PSflki9W4Gz1XyS2d1dN98NAMXzaYkBzhkDx5WvsXK?=
 =?us-ascii?Q?HXuoQZkNh9Lk4/soP424anpyVYAUZce9KxWS6dqslwIud5fJjZgCIp8eJ6U5?=
 =?us-ascii?Q?uCcsNwsGQBNY39Ya8J6KwSWFKELJ48PSknkG3FwxDLP9R42IkHptManvx6p6?=
 =?us-ascii?Q?X54ES8UXNM4IIHDZ5VcjLHcKsVzgXC0JWVqed2DCIz0b9294Bu5EtsNKWSb9?=
 =?us-ascii?Q?I0RFS8dEJiphN+DlmcgWikeq02UFTuZh46r6xUVnHHiR1Nf4ThQBJxa04SCp?=
 =?us-ascii?Q?3nnMRuADgBmHw8hYrDGUdOtNEbvGMXgKpmLQdoOTzxC60A8tzcFoBW1n5/ic?=
 =?us-ascii?Q?DUtRM8mxAzP6/qF85KUNYn7AKPBnTHMRajKBQktTHVGcgyzYUl1tzzW/XUhr?=
 =?us-ascii?Q?pmR1EX/65JXxJT1QTCMTiVBC3ghzuIW3QJ7z5IDHpTENpisMpnRN2txpWa/1?=
 =?us-ascii?Q?9DLjGmKBUl+o/+Qm+uzLFDwA9dIAdSdUZzTlVm73aHo+i4gI7ko6EuTFh5aw?=
 =?us-ascii?Q?HrkWUJI2EbMHFCtO2wPxl9YgZ/0HIMUjIzdslKa7lb9sew9TMq/nPYNNeCsv?=
 =?us-ascii?Q?AvU4Jwur6w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Lm2pTYW5GKZR76P6t0n+EaLIL3mYCsyJwG8AoHM9dahKRSuRomHbnymcP3gFLdipnZPQPpddv0AViY3vA50ox4MTRV3FZWI540jUhXoI17y04XAIz6lReECCrbBoBlKRd2a8mFwrEf4BA8R0IZDwvaj0aTYhvLHuXYgWMVxQDCdyq2BRslFKsXkQ/zw0ZFRSypi8zvRkvwdn4tb4NUVYr7Mix8g06GQj3RPzZzx7nQ5PYigfJKJzuxOQpU+Fj78laxlP3MoibDs63krBe3xbgBHqYte+McUIoW09wbTp5j1BXUmu9kXlMoyXznOfNaAOQzfntrd7OMKPl+K8MlSjow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fxTZZ3kUqlgGl7gcPFggt31bhyatBMdWLzFwZ+GcZJb4pDNQyXbIj3EXmhmYPEHQGZLUoAg8e19n6zqPLD1ed0JDQq8H/hi7pOP6aeDukA+nBRW/UKlN+we4Zear1ZCuJjk4lLxIQsdpjARoyYGgr/xJT43Kltaebm9vsCmMZJ62m1/1aVenoFDu/UbN0tThZIvnPO/3G4/eUFUwNxCajBVN6B5PfhX9RyY1jj7NGFAiCRKtrvwgPcPiSeYUOfMgKuiFuKng/+b38pHlJAIa7Vi0oGYzKEQ9zd1pf6dp2+J7CbWFwa8AHEpnsvhWkEBfz5HbtEQQKRy7KAMi1ax/lGRdB0xAK3OzXUQTK5sT72ThCF+qlkN1q/TUFXZAY4rh59o1tCK91UK6J1vYoIt1qTXi3zMeOnMyxOqF+anU2p8D+xpESLUtZYJwyNLLYAFfmRxahCyAGbWv/HMdFCWKO+54gMpQwhcLziGDT0rGRf9QQak/bJLs1EVrlCTfJ+68g/Ki17bbT1wGs+gmsIKGbXkA2dMw2DQx8SuRORE9PNfeo40x0X3z5LG9eyusZ37U3itHOhxIUAbvuKT25WI7/DtUFLyKh6Tjj8jT8GbGC7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cb1230-c30e-401f-478d-08ded8ee1fa2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:43.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0kUPlDAwp9ZnzNWzIFxD3h0GJEfg3l04Yq+U+26FBYrJ61R1SJToGEvU7jiAYOUD+upgYNjFZH0lOcS8xeGlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMSBTYWx0ZWRfXxht4G3PInovb
 Xvsqces6w6YHycdct6coLS9OLixxxABjgOohOXZt+Oh3/EZ/SIn1qwb7dNAKLzPdevE1n58Y0aY
 xnuAKATOPlTIXqIprY4IwoxZqvSc+pPwGCkk0pEmFVj78FLSDHqX
X-Proofpoint-GUID: 47X5eWMD2jRCuhoPjv9QaRanpsQv2nlQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMSBTYWx0ZWRfX2HI5zRBQyISA
 KP4KFmCBfvx6p4TGl6RArGuygk1Cr3JlttZ1sSY8o+yj3eojIopc7+QjD62Sr4ETPNoP/G5a9mU
 g+p6gWDeoiGVbTLmgQk4cB7A9T+RLl64h8c5CCtDWmFCFRmt7FY01JV2FFQMat8zY/OiW9/Cevr
 z+dTy5jGnYMY8RaeZokDvL5FyvaGDw1CQLPejoK7EmMz6PwiQgguuiKB0XuWv1QB19zJAdd1MyZ
 JA2AcOh9FaN1l1VyJFbQaGionvjpBtgm5Dda0ouSgp4Z9dUJAiUjbRCAC0mzdxoHGziorK2GPlD
 1Y5iT7oLcVze0w00h1DxGJLO/YjBOAZ7XpMfuIzmHqREr2RlF863sAqVhBzYE0/1/G/3k4BcnZ4
 CRjsJei4c3mbveBNut54Sx66YtQPIH2lAIs0OOoJlEgO3ZDn69+jNIfrP7cyNEVijzqyWlD6mrf
 882sr4wffZxZ6qLl2Ew==
X-Proofpoint-ORIG-GUID: 47X5eWMD2jRCuhoPjv9QaRanpsQv2nlQ
X-Authority-Analysis: v=2.4 cv=D5N37PRj c=1 sm=1 tr=0 ts=6a478f5a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=IMLwmY2krkRuQTCR-eYA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

Add initial framework for libmultipath. libmultipath is a library for
multipath-capable block drivers, such as NVMe. The main function is to
support path management, path selection, and failover handling.

Basic support to add and remove the head structure - mpath_head - is
included.

This main purpose of this structure is to manage available paths and path
selection. It is quite similar to the multipath functionality in
nvme_ns_head. It also manages the multipath gendisk.

Each path is represented by the mpath_device structure. It should hold a
pointer to the per-path gendisk and also a list element for all siblings
of paths. For NVMe, there would be a mpath_device per nvme_ns.

All the libmultipath code is more or less taken from
drivers/nvme/host/multipath.c, which was originally authored by Christoph
Hellwig <hch@lst.de>.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 28 +++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 74 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
new file mode 100644
index 0000000000000..e98b4b241020a
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+
+#ifndef _LIBMULTIPATH_H
+#define _LIBMULTIPATH_H
+
+#include <linux/blkdev.h>
+#include <linux/srcu.h>
+
+struct mpath_device {
+	struct list_head	siblings;
+	struct gendisk		*disk;
+};
+
+struct mpath_head {
+	struct srcu_struct	srcu;
+	struct list_head	dev_list;	/* list of all mpath_devs */
+	struct mutex		lock;
+
+	refcount_t		refcount;
+
+	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
+};
+
+int mpath_get_head(struct mpath_head *mpath_head);
+void mpath_put_head(struct mpath_head *mpath_head);
+int mpath_head_init(struct mpath_head *mpath_head);
+void mpath_head_uninit(struct mpath_head *mpath_head);
+
+#endif // _LIBMULTIPATH_H
diff --git a/lib/Kconfig b/lib/Kconfig
index 55748b68714e0..d0258bef374a1 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -636,3 +636,9 @@ config UNION_FIND
 
 config MIN_HEAP
 	bool
+
+config LIBMULTIPATH
+	bool "MULTIPATH BLOCK DRIVER LIBRARY"
+	depends on BLOCK
+	help
+	  If you say yes here then you get a multipath lib for block drivers
diff --git a/lib/Makefile b/lib/Makefile
index 7f75cc6edf94a..7ba5e13be4171 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -334,3 +334,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
diff --git a/lib/multipath.c b/lib/multipath.c
new file mode 100644
index 0000000000000..009d4bb875c6f
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ * Copyright (c) 2026 Oracle and/or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+
+static struct workqueue_struct *mpath_wq;
+
+int mpath_get_head(struct mpath_head *mpath_head)
+{
+	if (!refcount_inc_not_zero(&mpath_head->refcount))
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_get_head);
+
+static void mpath_head_cleanup(struct mpath_head *mpath_head)
+{
+	cleanup_srcu_struct(&mpath_head->srcu);
+}
+
+void mpath_put_head(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (refcount_dec_and_test(refcount)) {
+		mpath_head_cleanup(mpath_head);
+		wake_up_var(refcount);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_put_head);
+
+void mpath_head_uninit(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (refcount_dec_and_test(refcount)) {
+		mpath_head_cleanup(mpath_head);
+	} else {
+		wait_var_event(refcount, !refcount_read(refcount));
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_head_uninit);
+
+int mpath_head_init(struct mpath_head *mpath_head)
+{
+	INIT_LIST_HEAD(&mpath_head->dev_list);
+	mutex_init(&mpath_head->lock);
+	refcount_set(&mpath_head->refcount, 1);
+
+	return init_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_init);
+
+static int __init mpath_init(void)
+{
+	mpath_wq = alloc_workqueue("mpath-wq",
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!mpath_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit mpath_exit(void)
+{
+	destroy_workqueue(mpath_wq);
+}
+
+module_init(mpath_init);
+module_exit(mpath_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("libmultipath");
-- 
2.43.7

