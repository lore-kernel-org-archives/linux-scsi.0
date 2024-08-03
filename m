Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0FA929;
	Sat,  3 Aug 2024 01:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648312; cv=fail; b=E+fL/LByDUFg3y2WwZv4BI/GOw7Y+7ljHsPHYPM179nA9RbduAWFhzn/C29oJe/djX6Ou9VgaheUs58OEGkPJgs6Cd33q25nTI9Kmz8YyxSn3ASXICSdi7ia1wT0maukz+uYs4gEwSa2jV+cCP2T/KFaGz+PcgeMcpaG8d1sI4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648312; c=relaxed/simple;
	bh=4M9aroNQJnTcerpLhs8Zl28WEq/PYDu/TB72L6YM6pY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uz/ONOG+vvjRy30qBgjHHrZ9TAOXh8u8GSg52EUDtNnk5WydCBWXbwURjgJove+/e3XtYCjmdV4Lvimh+QtMPOyU5d0RQO28UI9mpRDRMkXTUdRY0YgAhqjZ57AKvAeIv4Y7zn8mO6cSRs6cysNEh2Vku8ux22tuY274y4aVKeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nfEPRmxU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OLvs8Q3i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nfEPRmxU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OLvs8Q3i"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472JOUGE013942;
	Sat, 3 Aug 2024 01:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=2O3iTrt6vftw1D
	iJQUHKINMCMIDXHlckQcvvCVWaxQs=; b=nfEPRmxURSMC/RjYfGqeUWcUZ5/2Fh
	kCFS9dtIlZLEfuIZEb8xoC1cBV/dLH9IBXNDSXxpqrD3E76R3v+R/IF4bHcorToC
	5jB1Lin9hmWqywDUzRdzrx6KJAnQifZ6tS7Tg/m5KNSYgip9sNv4mIQ/9GUA7qu8
	urBdT9eUJ9+TDPpq14RwXxGkr8FUyWv4GoUMDjgZdEewiLCCkeD7Ymy+iMIJiCCD
	1nvzhE03jwUAb/sQuDIxmvFnSvnNEorsEkCaFiPT3IGBdqTlVWMdPHxMti/b/0ZK
	EE9XRbT0wtBJ4dze81pKCyn0mfctiPg1GOJ7m/b5e99TeTiOmJQkxdNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjg32fpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:24:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4730Ics2039747;
	Sat, 3 Aug 2024 01:24:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40nehxwpsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:24:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGy8RbQLra001EOY2AEp6k7XzMyERXPtmXwTe9dKiwUgHMvTqqqcXV0kqyv6kFcFJNmrxVo9aKajedAOCq25IrvsmeXwMj0+TKSEOranhrVbR8VaXtDMthpof/k46OQZSMx3RhxI1GIIKmQ1gh+G11hZ3qcuznfu3yGMlOmnjJhlA6CHunvFBwkIZlQyq6eZ+dBWkDFxht/W4TaZf2iCi80yMR797y/pxqBoreG82yUKcXTp2JFwr1mzrZA9RNerTRmdG6C/W60zKUwfh5qUA4eFyovtC7QcxN+rtsyXcRr569ni98ZDZAAKGCZuL1WWtueBu32Xt46tXLGz+Tajhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2O3iTrt6vftw1DiJQUHKINMCMIDXHlckQcvvCVWaxQs=;
 b=nLnPris19rtJMLkHh4V8CEKSQ+P+Qj43C7BJFnitrlTTITmxwc9nw5hnCoWF+BXFHKebc+ex6ZIyCs9LZWAWA+cdqVNGA5EueOfD631nObeiFTRY/eyeZCo+Y760GnQ1DZt3uXcgXnbQu1BmNWcObmglpxYdH1M29WFw5gFS/UYJPhYf0MaxQuTbCp5BsXVeSxGDncGZ5n7Ro1nKZ4FOV9bnQxTloZhun/GvVOOx1TiM/c4Uxx8PSiylcO0WiFCW49e+FBRFUlLOW2jYZXyKnjOgl1SlFGmwRWSGlo4BDRzQAYmDijTACqkucExPBbfeUJw4jv1tub+qNfQz+biktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2O3iTrt6vftw1DiJQUHKINMCMIDXHlckQcvvCVWaxQs=;
 b=OLvs8Q3iK5KxjffwxNf0xzbE7PbxVp1AJvwLnZe7AsbkCmvqFOu7he+qXA/iKsNnSRnDisN1g7SozWvEsw+coX8Zy9HZ6UaKtQe0xd6uuFjS58YlQWp9+7EWqZksU6pmQLeJxpcG4Ohg83JemhPNzDID4esRFU1SsvpzxDRcaFE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:24:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:24:50 +0000
To: Kees Cook <kees@kernel.org>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva"
 <gustavoars@kernel.org>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] scsi: mpi3mr: Replace 1-element arrays with
 flexible arrays
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711155446.work.681-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 08:56:32 -0700")
Organization: Oracle Corporation
Message-ID: <yq17ccy8kkn.fsf@ca-mkp.ca.oracle.com>
References: <20240711155446.work.681-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:24:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 687c8486-7c89-40a1-fe73-08dcb35b11bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qGtaGilGwcTSpP+mwGgObd3f75wayY1GB4Q+4w04t5Rd5QAA+i7sUNgKPHXF?=
 =?us-ascii?Q?0i6WhgfiJ5cAdn3XdFIw5TEMBI3EUASrrjCg5jF9yW+FaPH4Gqb/1rvGs/ka?=
 =?us-ascii?Q?9q4QoUq7RSuZaloPNr2Y2ESautFxXHf/r3tzPCdVgvRHsPWNeVELRToci5n4?=
 =?us-ascii?Q?NB0S0Ryj8E362q5BKQXE5PJHzyezZdhBXWSBn1qnSyU4pRtu62S0QN66yUTv?=
 =?us-ascii?Q?Nge0Jms5OOYy2cdCFr4HGVX0b8eNWxIxcM7K4G0aLDGNmgyx/neTJjjmgki+?=
 =?us-ascii?Q?HL85fBcYHMvr9IZKPeDaWZiYaO0I4tc38pX/jez4Eo1amugivPytR3AlQXKO?=
 =?us-ascii?Q?vGdbStZSky4OLqdIiaoD5w8KrH/5pjVoSb0uVyb0B/r8zGO4Vwz6Ifx7uF+Q?=
 =?us-ascii?Q?bpRxBthZbF76jnjdSxkLD9lbfHVzv+CIQFfyGVoNfa7HLYBu3TxDy4TiN5Mt?=
 =?us-ascii?Q?M/RA00TQINAMhvzozmiiyQ+Kwlnh6iLPmjsQKX2diGKLZuIQtN6ThbhNZkN7?=
 =?us-ascii?Q?MnpBaSqjWLNgOAEQa2Yw0Lorxm0vnF//W53ctxdmjXlXvBEQhPaSRcu+ibI5?=
 =?us-ascii?Q?A1Tytv2J0rFVgU1AMoxFtGUcCQpFjDtGHpdvVEfBBH52H0AKcTO9EgrGnEaY?=
 =?us-ascii?Q?v6D4kEm85UhG1kD4i20jj1tGoQu9sR4GI2cxEA2INAHgPyIDB18IRIOQr8ts?=
 =?us-ascii?Q?nh2sHfyIN/dgtY18acE+ThcpLz4caz94ZBQKz3JE12OlSOmzuh7SKGugmIIS?=
 =?us-ascii?Q?ldUCgOfhOVYit/RE/7FbQooNZDU2XnORCFBSYhI4EGm3mp1X81rC+xAOr3mp?=
 =?us-ascii?Q?/db+REKT5EJADXivVWD4kXEB4gF7CMXVj2ZaSORah1tHk/vgTeA44uTcFd70?=
 =?us-ascii?Q?ZsWb4tiBNzMqjJeYijcdj/pZB3TqWw2XanDGuX5oOOOCBGochld9o+Qfgzxl?=
 =?us-ascii?Q?Be6mRjcdgUzEBfUHjIi+IX6XJhaGjX4tQhsG7/dc+V0SKGTSn6woavBOg0R9?=
 =?us-ascii?Q?jKBO9pcE7++U+TSn7u2DxlvvTuqOTnY5R5i7a/oZUu5VaU0QHhokKntXtNSl?=
 =?us-ascii?Q?5oEF/6R3vqgVzJanfTbmwN8FdQNLstopDM8wIlmdlyxr9fLvbphh9gwRxeWz?=
 =?us-ascii?Q?l6ozrWbLpT0jmY2zTrvL6SlalSt6VyVH1eN0z1Xga3Mw9YF5xwGPfFBSbSNr?=
 =?us-ascii?Q?x7yhtYd+9h7LGa3kPt3kRuSWq41plk7tMApzDVEeGTsdHgyw1nQF43J5G95t?=
 =?us-ascii?Q?ICe/Ud7rtY95vvKLfeET5VpDauMLVC+hSn6oi0Nf5vRk6MatlXGgFN5sTS/U?=
 =?us-ascii?Q?gVvipl9Sn6FTb5CjqGsRFSQkamGKZpJ6ac/LZYE7cSEPEw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?05gx5qY+U7pxeMI8aDH6zeTUMw/REMRc8nLccCMHihFA9T6oFN3DTxpmOou4?=
 =?us-ascii?Q?eqmtVAqTV5clqKvcLf8B72e9DXp9nf8bB3UVmQE9rRcKcRPCqfjKsEQd89WD?=
 =?us-ascii?Q?izA65c3KaKAGZzGC/FRdhRhlaoY5V6z7EqHeToaGWPz4JNu8kG+eGB6/4n20?=
 =?us-ascii?Q?IdKd9e61164RPt0Wd/+CaDbihzcx34vq42qRmKeon4HFkJmkz170M1nmmhUS?=
 =?us-ascii?Q?NYagiCw1GwWbvaCRFJnDHKXCNRRcAvr+v2qQTItT5QuncJOVgI+e54mpL7z9?=
 =?us-ascii?Q?z3+RKgAkc17WtC4Zi7Cqtka/THyWZjeSGB3c7Z8xE8WTN7CvWiW0z4XNCRyk?=
 =?us-ascii?Q?OpHhTCYBphnqrz55VPWOymDqlZHnhcvx0my0PLWA8RYYOx36NgNG3/qyDQZs?=
 =?us-ascii?Q?d9VVWPqQ0sJ5diTfZNtctxoCJoupg2XbERA5sS1I6Ch9RhNSe1C+SiAgzRLj?=
 =?us-ascii?Q?i27FQfzAUixx/hfOJf6c5ZHyf2jHoouB0ndH6AlnJ7/tYxh8Xe0DpLFpQJLq?=
 =?us-ascii?Q?m+xFfo0g2C+p0HrBDETikNzef/6XfTD1LCfO14/EB26kd6CDgQ8+Rdj5TDgY?=
 =?us-ascii?Q?DtGElSO0yyRzN1tJyLpAkrpZfaZ7lIX9TrHk4p9iQPWiHRM2DKgzoUPl7p3V?=
 =?us-ascii?Q?8vOQ+ul3Of3FJcQ8l9dKLNXgaU7mhyeJO6LcWRtFDFeS0p0ABPeue91ScxVg?=
 =?us-ascii?Q?sJ86xEYjpnzUYV4ZIugQ49LgX6sQUGINDW5+qZJXyCRKGRnKyF70AkUVoBqi?=
 =?us-ascii?Q?3HzdN2sfJGuRsTdka0+Q3cb87Xk6zUqEKkpty2QGam75KJ53xCHIH+0pJD8R?=
 =?us-ascii?Q?vxlaSszVJxdkGosO3v9x9I9IsV8jjw9HK0Hvo2bglnpT1sOXNWQt5e+1um54?=
 =?us-ascii?Q?N36hEfY/96dBL6C4kHxXQjRhiVRhVjaDYXlr4qacXAwp0/FXYnXDquTByoGU?=
 =?us-ascii?Q?2G/kp2631MXXA7eSOTMYxIT58X/urnEQzu8NbGgojnMsp0MMkelh8jY+ivPR?=
 =?us-ascii?Q?vx63OjVXExGhdXAvW8TKEMuUXioiv3oXPEq3LcXDfRCwBIQ7OxlhgoAa8Hnt?=
 =?us-ascii?Q?pFzKe+V5u8nzc+cQ/4TFRJViBzrAFBpQQmowQgTEPDZhtLmIX6WbVVTwfOxT?=
 =?us-ascii?Q?l2K8znjQMGVgBTAt71shBbJ7uZiZqtrN8HtAfMF++Qldd2Djea3pjfOWFdHf?=
 =?us-ascii?Q?9MTtyhAIVuEsvaX0C9SQ+JLgKap7FHDG43jLFYHiOYJFmT/BAALosKqs929n?=
 =?us-ascii?Q?ruRfU6mdZbIhVIzt3zdpAeErEMejTa24ohc3v/Bbi5TtucZPFpPiHR+m4oRr?=
 =?us-ascii?Q?54cpitPXrnxnENDQVLcII/mJox774GMdqebHFTnOsOFT1IswRNGXX1xsm66w?=
 =?us-ascii?Q?OswNFy82gV2/R7GOrzZJODn6I4Hw1RCDnWZohstkx3mKJYv313oUdbBhYu6V?=
 =?us-ascii?Q?gZc+6gFpsWdGUOS6qTpLynAFYCN0e5tH2wIskZfRWxosywGTMcj3aOEzrBVQ?=
 =?us-ascii?Q?DIs9vgbAzQnBSn3oeX6vwHTSUcDdD4rNS5lCIt8PjFLsF2MyToGW6N6x48zF?=
 =?us-ascii?Q?iSKohEjVSY+cuTd5v7kMaRAZFRjycNFx/0J47XupJpgn85lCng8KOoWiEzSy?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/ipX9qxv/xFeEYfgjRsa9jgePk8X2UhpcPF5R1l/UcIFJKbHEz+E0RLHV8gTZqyBog6qgGsHymghaI2+kex65vpysYVVbsEZxD1BbvfOt75dPpbPguf+5EreicGH62K4E1nLhrMw+OMc5DO9JyibHpf4PXEjW9XaX27Xl402Y0TzKLhVxitO/MjM3ihCp2scxbSYqNaNo/TU4cxn57nSVlS9XUKXlW6w7OTHeH8IUisPtAUmQYJulLkVUvWjn+A/ZYfdQ1lX9RDnlzkxw446AYCxKdrmZeKort/JXgmoFGa2x6Hn2f52UBIIU/zs5mDMXtCFQv7ESus4Lb6UWaqE6sgyPOzUvnsdqtj9k8BwvxogWuE8/8XpcrO9FM+lXbogtdb+RVIVWzS2jx2B6puLypnBa3hc/JkfSkIAfexaj6sbwbdDAA3JOeuiqTFbKywZW6wTwFe29g9GTTAA7Gk7xmmpTiFbINFbg+QeHCW/BrUxyz6IdnWhsLKpjkdn7gbeNkqwk9hM5EaEJ8Qw1L1aljLyUnyz9Zztlb2pA8FFy94Qt6EgLgrOMyCyNteytc6IN75R2f8ST5yl5bI4dQlwNdu0E7TLcT2XMzHmp3gPGo0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 687c8486-7c89-40a1-fe73-08dcb35b11bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:24:50.1879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEWv+QC9UZuCFGPPIBFbLt8B5+myDG5uZ9xn6GdGV8eHctIve0OjWS7sjoeQXPXscF39lNpRxYpiEZs0/YE4WyZZo680gs1r2XgXbrEBI4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=765 suspectscore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030007
X-Proofpoint-GUID: _x3k3ePI_nmcjgP9622_FNWW5z3nRD1j
X-Proofpoint-ORIG-GUID: _x3k3ePI_nmcjgP9622_FNWW5z3nRD1j


Kees,

> Replace all the uses of deprecated 1-element "fake" flexible arrays
> with modern C99 flexible arrays.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
