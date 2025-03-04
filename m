Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE80511CAF;
	Tue,  4 Mar 2025 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053682; cv=fail; b=l8f7FGFsvkT9kmgQ1RJFiGk3lFqmiLtnurOLYVQEsAOa0r0zfBsP4nTsR00wTC1W1GPOquEOwRFgde5oYvN+tp0VhxdV23A/x5nBZPHNQ0VTfjEoh8mBfriZqfYc9rS6LD6Q11iHNRn3SbRgkMimT8b3TrQnpcdzB+tMYxNlBJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053682; c=relaxed/simple;
	bh=3eudBpKkfXS+tF86kKPOJpQAdsxn2Z0iwPWgMt6VSZ0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=t3veHqRpKvoumoqmCJZHr2dSPMbirOeREudxyehDYob/9ZslYUCkEa+Io1tKaWQaYpbB/xqqClzr617p8IJVyBuwWaG3HmZJo6XDKpQgZEKqDSxpD6W1r+Uy5LsNzRV2NLqOosHt+WTDNB2Tdm94Bs2W/uSm7ioiMXH7q7CJfHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N2dGyT7J; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h/5Ckqsg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N2dGyT7J";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h/5Ckqsg"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NH8D025797;
	Tue, 4 Mar 2025 02:01:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=8DEeDAGmQ/Zsge6qCH
	RA+AdxgwmMopuW1F7FOAtoJN4=; b=N2dGyT7JhqGp+IQ8VuuPxcvGdGhr57J944
	uQs2SvDp2pX1wUoVrQHztId0pduuMw4AyCkXzbf4Tpq3BKV1wetJ3RfckdY0H25q
	SxdBNkpHV/69Dscuy2V41TTUn+6x2Ikgh6ddJnjSR9NSxr5MS7uV/3QtdAWXbBER
	CRzoQCHONhWniHv+rTHoddi6u4CWBAHhpXCh1jvIzufbDSnUh7o9kP+ymz9Wd9Rc
	0ik4rAtPhX0OUreBkez1lsNdn6C5PX7xlMvCTD7MEUsmalYMLGyjlTuzshs6ZnKl
	r/YiBwfTo5nbIMOLjuwjD/zG+Rfu7YTMuPUzCozavJdlgzSO4ySg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wky0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:01:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523NJvEM011033;
	Tue, 4 Mar 2025 02:01:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9u0v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:01:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfYBzFAK61sWiXbzkSyxKXnIvbMVz9x0JEMEEE/O/TcAx1UXRU39rm+ZMOeAmG093oGNcjNw/cHCG1FGKt3deKF6nN+T9mxprLL9foyuWRgZloIsXzDJF3o6zWwNJihP37wmwUzCx0KqD3Ne/19pCAqwXtabqnkmcKKOtXuIhClxiMtNHWEtwn8yxrqgU3yVISbVbPRw/kwR9XEGsU2zrsha20R/ddU+VqGCmTyL5ihB34YpD2OXO8JWvethcdmuyq4iS6j4TTRpsjF9OVD9uUxtMryqzGJ0T1nPn/P7opgpDcI7FrsHDdrimOVCX+b+5SkRbvn/65M1K6db/woRNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DEeDAGmQ/Zsge6qCHRA+AdxgwmMopuW1F7FOAtoJN4=;
 b=kwERQzgfXlp+iyU4GvXqVSjsxobj+BKFo7UODAHGAftO3Oa6/lxYat+3wVV2V1zY79ZcpQeKJgHk8fykGEpArqVpznZjFhq/lSO+yVF12+1WZ7XI+w20Oe8UDaqfr0VuUoP8klk1+Jj46yI1rOUrptD4FtcvWlEc/faT1HhxaiJr0IC+XPFgm3gET7BuMXEew2MgZQu0FtN4Z7o3xP/2sbZAaCAUEmwe/wdhBWUMIFJqAzZTFuAhEm+t42FpVSI9iPj4wZQvnp3M2BkOlYYaWv+WNyfhZ6Yg6yqw/Ljt13dLKbZzd8iWy7mbXL9/xXq+e88+uOrEW9eMSkFx7BD7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DEeDAGmQ/Zsge6qCHRA+AdxgwmMopuW1F7FOAtoJN4=;
 b=h/5Ckqsga/ip+ta7xMewKPoSwyBuLSsZ4krG1Wlvg/SpGNtvXEfl3MtEj9vzu1QY/DjJYy5Jok30K+mc6HmIKR1RLwPevpHevajAkx1vByA5BS41AYpZru/ZVOeRWrzIejWKlGfxBZTXgVsse+Flcr+u6bX5pFkLKIsVleTyPkE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4220.namprd10.prod.outlook.com (2603:10b6:5:221::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Tue, 4 Mar
 2025 02:01:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:01:00 +0000
To: Chaohai Chen <wdhh66@163.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Subject: Re: [PATCH v2] scsi: fix missing lock protection
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250221030755.219277-1-wdhh66@163.com> (Chaohai Chen's message
	of "Fri, 21 Feb 2025 11:07:55 +0800")
Organization: Oracle Corporation
Message-ID: <yq1cyexwo4s.fsf@ca-mkp.ca.oracle.com>
References: <20250221030755.219277-1-wdhh66@163.com>
Date: Mon, 03 Mar 2025 21:00:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0967.namprd03.prod.outlook.com
 (2603:10b6:408:109::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: aa602fe9-7988-4bf2-e5ef-08dd5ac06908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?200MOCPkqReO6JAyB9RqTh4p4RNFiXoMMBdvACrYl89JkaSEY8OmWFvUMxW+?=
 =?us-ascii?Q?fktFaSdS0PCeNpOLUj8cB9TRytQ/OhJlsIb3ca62fooiO52r1vf2CRmmTAIa?=
 =?us-ascii?Q?/4l5N9za/6mHB5xBGCSYf58o0SfWjaNAr3B5193Q2mSrvwsPFDb6N9z97E7Z?=
 =?us-ascii?Q?UUswP1KKk1b1bMoZbXkT9N0Yec3NeckZ1pBDXRGJwYeFeariLEFshFZtXGtV?=
 =?us-ascii?Q?VHGgeL/7t1BVtGD83ewkw0a28Ht/rNfprTth2wOdJYSdwq9oRnmvVl8FBAj7?=
 =?us-ascii?Q?2+YibOwDSzxQ5fMLAJbGUQMTefEFfWvHsIq+o/tcQCiyhrhQ0ydI4XBhtdSr?=
 =?us-ascii?Q?ZfyG7IL5HzzAcHCfRvkN8jkfiaHiNtrmU2p6jxOx3yKkPsL651k+1pNUYsOb?=
 =?us-ascii?Q?LAF/2P8r2glhpNknXJIyzLpelSXhWGgJ+irxXIXTTZyXEZwcut04M5G5W0YN?=
 =?us-ascii?Q?jfnrbEdJll++mUGHmFiVRLv6gqdMCjbbBkYTVwSbNlxqqcwBt4nnT8LFVL/8?=
 =?us-ascii?Q?TRA+0zE5sJGtypbsWlRzardyzxOYpFt0jPWjppWrXwsikw58zDJ9j6j3sswA?=
 =?us-ascii?Q?T8GZKwVCzq2r5rC3yJwN8aZPfaRIF46DYEBTSUt6Suy7LG2Vlo3SpiG4uw8m?=
 =?us-ascii?Q?Oes5X74Dk6clUsQjOLi5g8RBJaKjST7g8btv0iFIcV4fLvcy6P/cA8LHsIpK?=
 =?us-ascii?Q?wHfvlnCvws2k7dLL+uyVOi2Fc8CI0HxMOcswBtTtfKBrenUkmydnBxut0Yi7?=
 =?us-ascii?Q?rBca6Th+1fUqq6xlsHO0zbr3zxuuDTJE79QDtauxvAgwZYUI3Tp9QFBe1YJF?=
 =?us-ascii?Q?OGyEQ5U1mqUGuuv32kDfnSes6xq3TF84eDh+Sa0DJvivLNyPLeFMt016sODP?=
 =?us-ascii?Q?EfvlpqrLEaFLwO05HDo2604f5YHDRH2RJRrhbTQoecEifsxu+wdU/QcP9hsy?=
 =?us-ascii?Q?VnUuR4mvowhCaDghZX/1iVXiTOdHNK5qYmThaV/Qg2cAO2Ik/CsNcvF/CtUA?=
 =?us-ascii?Q?KqUeweijCMqmniku4PMF8IwjjUW144BDkUz7vRj82xG/KCvEczcyZw6MwOQf?=
 =?us-ascii?Q?8XZhfPW2Nx7qysc0iKv1f0L1Ap7qk0vr+L4doOh0S9GeqfFkhc0rceuVe4Fw?=
 =?us-ascii?Q?5WC41beNoYB2TL2xOS1b0jN3vGgk5xThSr+BJ74XQEhvZrT92MM28Som5BKK?=
 =?us-ascii?Q?ZABZC9te23n5U740bKTUHTQaUDaWPHPoBZgSsnQb9z4g4K/w7HfNuyJogy8M?=
 =?us-ascii?Q?G6ei6YAPZpNFPXytgXval0h3Kz4CGWbjY+Uc+U5lCOUutZ05qgzEkDkoH2Tc?=
 =?us-ascii?Q?dxIKLRi+eSWqhTAsRRpJ6b7bagYSNULZwUpgyqlBFASAbNtd6789qfP0uFS2?=
 =?us-ascii?Q?NMhu/1GL+qXdKOzn/UkDweDphsId?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qT8ijwcs0640DEyvo/FkcLrLFhfeHHdlIrZHna65OA8+EFx877o52L8cN1X3?=
 =?us-ascii?Q?mFPTGnu3qacrfSwS0SMieP/sSEzNckSHG6FtDLMD8H2F3SK9VDcqFFkwzcax?=
 =?us-ascii?Q?1xDPyR5UX4veEbRe5JTCXd4LYwftlvW5AAsfqzG1Tk5set6W4FIz0h/fE/UD?=
 =?us-ascii?Q?WUcZg1bMdXxdmYh/xFOrtdvQYzIwQxOf98jqoS8HuwfhAPFiQgyQVzw+UpMl?=
 =?us-ascii?Q?7eyEN6TNHkHNc7ZfcMpGkC5MwJuxyw08LD6+jzB/r5yPbESjIB376IvdlfNf?=
 =?us-ascii?Q?P/7Ku5lbdnEsDufDMvf+8b3QvE+33QIdcBnmpQCcLaWM5PqHzymMYyJm8pui?=
 =?us-ascii?Q?i3Z4wJMiFeOUeQa7IPO2urRUJwS1RW+C0akEgofqGDU+f3EAJ+8n3uZBH9WU?=
 =?us-ascii?Q?k4Z0Mv9EtTMhU3cmNlueqgQ0kEKmb/jB194/XGLCLM6HdEcruEVsiKEeG416?=
 =?us-ascii?Q?tIw51l/cqyLz6K5KTHthNZ6mulI9e0i8j+VkzKXfB/fxbfSdLnXGzyI3MdKw?=
 =?us-ascii?Q?YOv6igmzX6QQ/f3axyHvN9hvv7sQZP9Vobs8CHC4vXQryZqs4pLsP34B7Tkn?=
 =?us-ascii?Q?IDiS7RUGCuXC+Q93tJq/WfekHP3fQuGqC7mEunDDRnHBTwBDTkuKINeNi9+S?=
 =?us-ascii?Q?5rq2U0mYVL8fvef0nryd/kS7JXuWuH51c/4D83tO9ddO5+xxXLlVb8rL/5TT?=
 =?us-ascii?Q?dD9TGUgm9KQg4UkzTHO32SzyiEtID9eJupK6XIBVdI+cnhtxdbwI6EJRH7Bf?=
 =?us-ascii?Q?X5z2cs46HRVaIV+HLYUytQuU01cUVj7D5OtCExMabtXHkPiK7JreKNsmYuA+?=
 =?us-ascii?Q?9U6BFIZskc93ndIybh/+9T/O46fvWYKEJ6Z7+Td31VFv1cSxzEUd9XCZYcCU?=
 =?us-ascii?Q?2VqdgjWmi9G+8BfOV7hvsPOsG/RbZUFXuMQD0JrYJdoYKcdpDPSKE3jQkMzJ?=
 =?us-ascii?Q?1ka9BRDmnCEab3jh8GzQwyprAsvS1CDQvtpTwRcz2LvNzkedpcbyCBT+h8Ix?=
 =?us-ascii?Q?hBSUKiA2kX9/4Bfpe3miXCXFIxROEn7TZp+wzQn8anT9IXZCwx7F73DYfSbo?=
 =?us-ascii?Q?ceIDp3UCYbIyKuu2QuxCAPTs5FwCS2c3dgCgbcyWEfEI5tptcHX4lUAuew+h?=
 =?us-ascii?Q?wNXUBam98eTuhqDAENfFqggMOCOrPT65szEhveZdudVENYHNegZcuQ7HeaBm?=
 =?us-ascii?Q?Q0OdgmCmFT5+qIyl8X4i/oeSXAHIxbieYwoDFhpOLjf8WzSZ2Hn/O1HP4KRy?=
 =?us-ascii?Q?CthUtYIlxb5V5/zjh9p8UQ6Ac+LTZ2Qg5AJxSaCn1RFOY3cBSQDQisy5Oz8+?=
 =?us-ascii?Q?SVmzItkuO71caWjJh3ZJG3cH6geTCoWih5aDyD3pCS96fmZJ8cTXtcG2zAv0?=
 =?us-ascii?Q?4KN9myUNBbhVFzxjqp8guf90J5+gM1IIYrjs8Mn3+FC/cTxuX/eYir/82eC3?=
 =?us-ascii?Q?BKc0nNnatT/s3mZqNlLVFF508D1db7euY4fHD1rnt52I9HG8PiFLSzfdflo5?=
 =?us-ascii?Q?3wooPXRn0KNz4RYU0bPeyKKyn9JRyfzYxA58ReZbp2QWBJnxnEfJpnfs1XlH?=
 =?us-ascii?Q?8aWMtxzySGPbHgNdTTxgZjIGknyTyEYCj7XLDu/qY4wBEs/O+x1wl1Wu0ljW?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Iv0Chpgv8YPEU2MIkq4dXPB3FC7AiBwY2yXpT2L6ptvTHR2h3k7XgsdJTljfGw/8OrKMo9dj7JVyREGbo/pd1k0xb1f9kJL48H07YAEd6RdQaVo3vMqqlFkE5RiDZtXXd90gVxclfXlYu6HFY5Tk2/Y8vqU1jORneRwDjW8tLSEl14UGNlniHAU7VtTJJyMdSPfCC/uM22O2TBWqsDvDQ44uDR1xhKU1Ei6a6ODcJwI9jBSr7CvjtXQZmiWYYQ9kCaXTcOPKEl85godl1z6tG/K44SDINRhROfTGE4WQGt8wYPR8FV9tremhDuft08lIFK306PV7zC7QJqLqHeE3UwntQQYn3Bj/fDCV9PTC84HD1ooceNx/C8cyJ/ZvBQsjrRSta08itN+q+JvqtwvAJRRL70o9f8nKbLMM9M5IXdhbr37+OkAS0Ci9nsO4JrNg2LuieZBcfH78YNauHso1oM2puF6uFf7wPkIwFU5o51tbboRerGcKmAdLbF6FOL5naLeMUcTVCxEl12SjhxKgE4GbcRxnnkiQ2/UpQVo0yqq46Dz7HGcj42dHIgEf0/sMVcA2qtqvUbzsJ75jy58BvDZccSr46pIO066OJ5NuqjU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa602fe9-7988-4bf2-e5ef-08dd5ac06908
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:01:00.0024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPRWtVTRrcKuEijpbwZw1iq4vSQeNk1treSB+ONlAzhN9NSu/f1zsNdUZ1Nv4Yr6rn3zqwuI/KEl33toBZkoRwY0DrckJ3gO4k8z6q6vEgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4220
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=889 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040015
X-Proofpoint-ORIG-GUID: oGGS83A-KsTB1hs6Xh4hucCRJ-H5OIB_
X-Proofpoint-GUID: oGGS83A-KsTB1hs6Xh4hucCRJ-H5OIB_


Chaohai,

> async_scan_lock is designed to protect the scanning_hosts list,
> but there is no protection here.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
