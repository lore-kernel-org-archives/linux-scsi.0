Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61548F4ED;
	Sat, 12 Apr 2025 01:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744421506; cv=fail; b=BvN/kH6NKVeo5QjbocVRwg3FylZip4zryXaRodE5/QFhRlTKytIHfdGGZJVmV/BgpWSxSeJ6TieTczsSNM+PT6sPjBvx5NmmC525wXzD2aNWrgUtP3lJNr4EJZGRgzV5nZuGinY4YSZ1srdQCtBe9cmQdAW5YTI0/ikjJ7HyyuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744421506; c=relaxed/simple;
	bh=5ftuTJpKd2GlbemhS9bl35e8w1K0FXPm76pO3emkS0k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=J0+vh3Gg7FkpZdNr8A+5DncZYAr9RqIP3pBz24XqkVMNGDk83qT9e1NFXV+JENqVMs0FE6KRdUeiDw3v2S2tAjmDZhBXt/iv3cLeCWkDiV5QEl2t5Z2yiwvMy/dCCb0YwssPuF9RkXYB8Dd7qYL9iH8pMSBk55v3uMxpRqLAOG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DNaKDQTS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uoPplKh0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DNaKDQTS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uoPplKh0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53C1TEhL007166;
	Sat, 12 Apr 2025 01:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=j4l8k2Ss4FBBOdH63c
	UN+uILCbZ7CnedYVgPK3+GE1E=; b=DNaKDQTS6gHRy7884RweC/tTMxu660J2It
	E5Yc+XkMbbAsGU0VCcBAjptl0xUaosPLX//yZ/s4jbEZAYE7R4t7sRfZ0TVmHj3y
	i9C2B9ihFXjfAI2UL9m/ASaBJWLb4lsk1/bz5Civz+TVDuxAfEuc4N7vpk4n19w6
	0gYm8BTmlKRyEqz5ZbG32CorEM9lbLizgVJAGY/DJwb5GGkVV1b7qxEggrmFRHKw
	xLrxyuGQ0LJGk0fYaV6EZOJ1vDAmudJoqxJV1URoNQ/uyU5uINHnAzvQ7yWdYLct
	w3W+VKwOm0i8hf1ye/v11WTHJNHlzaQ28jMSNplFiIU++1u1WejA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45yd6v01v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:31:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53C1R5rX013848;
	Sat, 12 Apr 2025 01:31:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttymrkj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:31:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wk9bwV3bonr83EPkbq7UllIaqkWQY/8b/mP2Vn22DC6BXMJamswAoohPpqWY3LjT0qud419nN6yhDNJx4YbSUb0OKYcs0khdILyIkNnfkBGVDbt1nr0msY/kZ6Dmr7U6AiH/jj/v7X9RD/mTFGtkPtxDhQq4AEAbmPGSZ1wT6D8LohYddkVnxS2uNHnWkSEV1x20vsqrTZmWX7LRmX9G4SzRU2GFJ4N14tDqdZ6G2dtr+kGo7q8bFpdF3pAYJNO05xcjtS2JYJI9eHGx8i8QvGZtwW2//ZPiL7bJnNPdkYkwt6JWE64jXbus4A0J5AcbbVtg0RO0vYVzkuS3XXws+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4l8k2Ss4FBBOdH63cUN+uILCbZ7CnedYVgPK3+GE1E=;
 b=GRFhNr57Smdbqw/cN6/OPzpB5QG4TWKjO8zvkzkAjTU+oVoCngRUSHVOzdaqNPFsO98Z9HEOkZzsb2IKBboKKT9EAJMn5KD6mHlbYUs+YJqlo6vpIN8NmCNVbI8V4BQk+95I3a4k0d+JCnyDJ0Hyj5UozqCTy/Oz8Z9NCbfL0aEKBPlpw31KXq77mWbkdNVd/jgIkXT0eY8KZ77IlsIRmHYg/GahkfzZv2y9fegXx1k9N9QdHQdjNqpm3WjLZH5wTytxRSNKAVlTFzXp+MSiybji2E8iVCzJQfoN2YRxnKbsYRtoRdsrX3bteiU8Ja4AXbbQySBP/kW9b9ihHBGvRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4l8k2Ss4FBBOdH63cUN+uILCbZ7CnedYVgPK3+GE1E=;
 b=uoPplKh0/t2VjGCTaauLwfG3Ppkw4oq1EmNoozYwbDuzFALin3jvbBExqwEodcfG78VrPVLrMHBAJ/T7Em2RtIyAUNxpNIp+keHSh1yPwm6gLLC0V4HjvP63PwyZ30BUcyvGYWwcJChKZ81wnMgVFdwx4bQWTOU5S/uvTfDvCLU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB4992.namprd10.prod.outlook.com (2603:10b6:5:3a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Sat, 12 Apr
 2025 01:31:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Sat, 12 Apr 2025
 01:31:35 +0000
To: Daniel Wagner <wagi@kernel.org>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lpfc: use memcpy for bios version
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org> (Daniel
	Wagner's message of "Wed, 09 Apr 2025 13:34:22 +0200")
Organization: Oracle Corporation
Message-ID: <yq1wmbqi2s2.fsf@ca-mkp.ca.oracle.com>
References: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
Date: Fri, 11 Apr 2025 21:31:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0207.namprd05.prod.outlook.com
 (2603:10b6:a03:330::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: c068d7f8-986f-4fb9-f296-08dd7961c385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?md1aP64PwsqrFUSRRnG7oSqcCaBOa7yvCnw44BOS3MQzSlcwig+7mEbGLu6T?=
 =?us-ascii?Q?fMj2xIrdaCfeuNTTGpC/lW8kx7G4s0xDfDV+fposAPGJ05Lofdq8bzN6QF4Z?=
 =?us-ascii?Q?RflbCsGLB+REo58a/IdXZE/yVswa56nTAqu/K6Pn8ybjdAbCSvFkSfmvnE9Q?=
 =?us-ascii?Q?mXFT2mJXh8RY63qo0friPlmOBqlocK5z3I5uTapO3rkYP0sBA3xY0KZH2J6I?=
 =?us-ascii?Q?5+WXcGxpHiaH86XWZG8RuKr3jZ1dbGSfBMoShmfdKsMUn3AxwS4rs5FYsVUx?=
 =?us-ascii?Q?8EadXapUuc+nSqSssg+0oJFUn6zFYaE783yIs/KwobbruLMtWLDoJayr6B/L?=
 =?us-ascii?Q?P0O6/Si2BUin+8m+Kxoix6mHiFfiCH7oyimYdweHkIihLijNMSr8qnxIHjOU?=
 =?us-ascii?Q?yoX/MCghxXYBBuiK0WZ03HX+jjNlmvuwxM6iUDkoIVe9G6EAjwLQ9ZuPyAtp?=
 =?us-ascii?Q?aCc8KB2oENBp5ugzUz4/mXZEJJ5R85nxN7ob74anEoofdlxJg99CI6ltztB0?=
 =?us-ascii?Q?XrNixytSaVR/00lBm1+cyLKrJMIqD9Mqj0Y7EeevD098Ae9wzUvur+pHMB8j?=
 =?us-ascii?Q?axa+Vx1W42Wd9P5QWL/shuMQFL8yn4Kq52KcVjfqqTP+SS2dO7B4WIe52W+1?=
 =?us-ascii?Q?ennUaTb7xKz2X6iRJ+PlD3gOh97F6wzlFF/Hvmoh+SG8CbGZVykWgaQXam+t?=
 =?us-ascii?Q?rY3aKK8UV1xwKPckUfr6QduFNli91lKlaPKvaJEc2TAUolbjQ3DR74pbF3p+?=
 =?us-ascii?Q?5Jsqwa3q2P2TFbXksaTLL+XfXXUgmrfD5rovHJiUqW+FChktU9P3FQIv5k88?=
 =?us-ascii?Q?vzvX7MkxeqN1UTE/uUOwW/NN7oz7fircKaHAV1TdVNXPZeVGMVYpmzJGpLBA?=
 =?us-ascii?Q?7z6xCx9fQEvNyECZMxLZiq8y8MC9Lf+vl80JC9TxrH/sTnb1A+B3YY2UuGF/?=
 =?us-ascii?Q?8c61TqA7Dewi8HiYVTAvXPMYYKM2IxOAt0IdGBZaJI5H50TeOy9oU6k7P2gR?=
 =?us-ascii?Q?fandr5HGyth00oEbJP4Y7Zkj7WOYi9eRBpMF+CWh8YcqtmiCZtgH6T/0uV9J?=
 =?us-ascii?Q?6A6cpvOo659Dkx6f3n5YcKxSzLJ9zxUgeg3Ji5gm6ubleRGS7oaFgGH84jDn?=
 =?us-ascii?Q?poH30DuOnacTKi6tqP83F/05XiPOs1vCYHYWiQQJtYD7Hekmf/4NG+q2/2xm?=
 =?us-ascii?Q?mYSJMTbecWqoqIm7bcuKgfbEmo9u8YsNh0Gt2Zu/9GVhlBmb6y6zmjP04U9P?=
 =?us-ascii?Q?Eh6Bt+z+dG+8m9067lGpFnEK5TvXQOzwEQuTJP3bijmnAMEZskeW8y5TySfE?=
 =?us-ascii?Q?UINFXZ5Q1M2V96b0pqEGHCxUgCU+I2QDlKSJ025+EeD4J8rFScx3e6lSLrcq?=
 =?us-ascii?Q?905UyRWs0ozIefY3/OJ6gy2Q5nBc/Mj0rcIz0rWTKlHk95ovdowpxLKO3Nvp?=
 =?us-ascii?Q?8btkjt0xHNg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qp4+7XZQCHMpPslWAKJq1AT1BaJv9w3G6AlcvkeiBOhtId3Jq0BxMH834iEo?=
 =?us-ascii?Q?bmv4jkyngBcJBBJMXSIY1swTItReJxsgAPWjvLHa3D19wDtPs3n7bk+wybY8?=
 =?us-ascii?Q?kSHoDjACRpdYLnjl9ZFS52y4HEWt7fnZmjZqQ3VKrOU+knAJ1Rv6A+uwhALw?=
 =?us-ascii?Q?Xzm0NuvQc2ChicdAMTJnPxqirs2YfiAKEdglxng0mKBMOoWq6u+CybC98N3N?=
 =?us-ascii?Q?Ov5qShZ0vSQlesvy0WVvwSmIoxmmJn0lzmC5TEwdtCdKF4GxDGYxM6/gO5Ky?=
 =?us-ascii?Q?ygJpIOGYvGkYU8KJMHZzFeK3/mBd3/J5F3s+MTxyaRGFnB/vieuGE/lacCi8?=
 =?us-ascii?Q?AkVsh3UVV0IFdMKRrAgzwa7OiUFmBn9ZJk/ErXhswD1Y3YeEAzJez4T8NE2P?=
 =?us-ascii?Q?B+OrHRwvkeoURhW7NR/39uE5oNKseBvfnJZrUlRlvnNIUrr/r1dY/Pla6ZLz?=
 =?us-ascii?Q?4a1gsVl9KlCao4WLMi1PAhTN9yJSe1gpb3xQ1QuzV3B17fs1Sj9dn4Yh7mgk?=
 =?us-ascii?Q?GTfvcxRaVrNdvlDbM4Zi0iSGNu7Sx1jDHjoYf5zfMLC0eEvlxHq1/a+lA5iu?=
 =?us-ascii?Q?ifsieUfJPs/7CC2mxVyZsjhAbs+eKKuBos25qKHyFbZXy/AOjLdAIVg4Iq/9?=
 =?us-ascii?Q?i60w1e5PtMB47bTO2Po3bccfrHmtHDykDuF5ofUFi/Ngw6fYpt93nZ5MdnbD?=
 =?us-ascii?Q?IwCaimPBdlNb/7DHm3PPUId7QGlTWOAPkJ2MbtePPRlcQYp5Owr0Pn+NWrtW?=
 =?us-ascii?Q?/Y3iNIc/nG5fzMux/SpsyX3h10PrShYao+6TyI2zdo8NH+PjwQdxUEj8qxAP?=
 =?us-ascii?Q?nQ1O3KRJE4Mw4lugpxWhECCrfreMt484x7yaf4Km8EdB7TwsvAhBN+7JDzsS?=
 =?us-ascii?Q?QXhnItszNhcDJKVvfxSbaoUWo0363RFqlqnbXIZyW/t9tsD9sMhEFNyYA/cK?=
 =?us-ascii?Q?5cJIEPMzkP210gp/PlXrbNVzRtrHnc/wsCZUnO4A9kMu2Kaed/wijte6AiSR?=
 =?us-ascii?Q?mTWLCXlJPxz+vX+lrLiSzurtfo33qW8yNuOk9uq3VYe0uWjQ86CvmYLTdrsC?=
 =?us-ascii?Q?nZn34huVAKVb2c2wzaDj1/QeeyUd0HqKtUEmyE//LU78QiuBogr4LFx2mjdu?=
 =?us-ascii?Q?bLjuGOHgcuw/tWD6RAg88aFQuBduh3S+QkTXXsJkouXpkaPPHqgpmBUiXZYz?=
 =?us-ascii?Q?i4wTdQ1mdiyoKU2qCQN3miij2qeBMHrZDzys8ss+Ruydpib/El35PqBMg0dw?=
 =?us-ascii?Q?D3KqMV6vcrXqPd5bEq6nZfT6zZW/wWBSL1Pl55/jKtwqQPdQHGlaYBHyJP2T?=
 =?us-ascii?Q?FSZhZNA4oN9XJ0eKpyWMM1Y7yLL+L3SX+hlq+9caomyS6bn0y8f1987Jhltm?=
 =?us-ascii?Q?QQwRzFMwkpRaYE+5/vtML5Bz5nRVZ6y8Tp7+lt3k67gBpyem9YoN9vnFwjJn?=
 =?us-ascii?Q?JKXE6BuFPZv0WR/WWizzN5oIYf7nrUZ2uJ0gyr6uSP2cmF6Y/7KtkI2bB8wR?=
 =?us-ascii?Q?EU9nqfttCJ62QCCr4OvJd8f2PKlmDr3VHvx/ByIJ+hq61vtl/2C4rWxjRk7/?=
 =?us-ascii?Q?OWqFTtX37niVqSO/hQs3nc1/MjyTypOrPAD/b1wFZuDST4vQh8g0CZkw3Y/y?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v365rdXSEPpi2a2ULCgYBZNfe4rCmANODq5HxQHZwYQcL+j0C6EqpiM9wVYeutACvWL8WjArR+WxXAx5lwr6jjdVgEAL291B8Zfzw1By5Cr1Hi4FTsrY6H/7UEdbH+SjS6BxKhsnCSBTwzp/vsXOPzNjtXBNP9N4zMnvkf/gvqZmsyAfdT6GG91r8BNFvofQFKGG6eH/CxvN4A9lSRc5O1bYgVl9ZeOKb68cHvLIhhwNRH49AYw0WCEqi/BzUieaekUsmlB8MijhnFdSoTjA1aeYNaR6K4Dl0zKukxxMm/B8bQB6gLBSGU0IjkyTL/SNFIWrrowViaInzzWLuiP+r/yz8QjcSW/kz+pLNV2KqwbQ52WV/Ud9JoJLNQs/BsTCCqoC/wrQbiDLFsJcAh9J/wHey/CHbieu92nyGL3wYl858LsYqCr4nvNlxL4P+BcDwpPs+m6zjW7mxomHyxeyHflX3rot5wfCXd19gXS3YZL5L9j8uV7QQquyPdbz7v4axJRahP/XIByoyG68Bn4nlANzjBnt4NALgQh2N3gPSp3GkVpZ+qdTkNwQpXItEMgJsE1iD2Ucb/hFirC99tkLo67VULtt++vU/4Ws5znL7pA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c068d7f8-986f-4fb9-f296-08dd7961c385
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2025 01:31:35.6869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjRZ54tJlwhfLp7alRpVRhWcPWkKu+HY145qz650T5VBX2svP5xLRvymSWVcgF7vsq4cmNqjcH9mriIkLFn+rSntPKg20rzAxIGuygDyedc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=723 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504120009
X-Proofpoint-ORIG-GUID: bKKBYjUBhVE1Y6NoJtD5mAmbfD0LZewg
X-Proofpoint-GUID: bKKBYjUBhVE1Y6NoJtD5mAmbfD0LZewg


Daniel,

> The strlcat with FORTIFY support is triggering a panic because it
> thinks the target buffer will overflow although the correct target
> buffer size is passed in.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
