Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A16021CC5B;
	Wed,  3 Dec 2025 06:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764743757; cv=fail; b=dWmMzhGwY8mVdGYW95KsmLb/M8equGmYqnyCkmAju/F1750aJKse+Q8hSqBZwT0OtXjnO0IXO8EZGNir66p7swtzmLyxWuI+DngtecI19MwP7twNAci7q+OpX71CH10pHF+fWB/jFPcgN2DcQycF+dUBNAmN10hZZMA+hWLKh9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764743757; c=relaxed/simple;
	bh=B3URmUfOtKB/oXxKzUXyMIeL3F2bg0Lu82byTx6PX4Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=l7RuaIIS0HkkQR1chETQH3Enx0Q/i22QLOyFfBab1HZZRb21/9/4GsqwISlf55ta7QqUP/M1BM1lSX77uhb32u0UhlBVE58bD8MBzjUA8I0KI7GM6fkVqT066ElU/2GWcZmhOazRra2KRNF0ioCvdYoOTSGON+QSVKMKLSzvgog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aseJF04z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fhksFJW+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aseJF04z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fhksFJW+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B32uE311729938;
	Wed, 3 Dec 2025 06:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bQGtiypw1HwHus6RjK
	gSVIZD6SQk6wXFS537x59uG6A=; b=aseJF04zdyCGV8J9nwk9yeyYDB88PufnYI
	+tl7yqaRDWvAo0jqEtXx8MPZxmsyLCdoEwAERwk9Xpr7gp0YM+8k1j9lwaeg2pAL
	uVhRZn7HghpmtT/RYqKny7yogA5Fb26LIUrSdl4nY12G1MahHoLtvcT1FvPUUH4t
	jzfgQbxJMznZDL6aLbrD9jf6NkLIfU2/+Stq1KpfGthk1ExDzEsPt0g7jJqk4bqp
	rKvn7gJ05fYh3F5ZndkVfHX7d0Q9zZcfoIAXkSM1TCSI7hGVH9gs98cy3KeMRqaf
	pIdT1pWBimTG7NjSovgf/A+f6JGKLto7kmC5kIOG0TLB2eBHqY4A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as845vjuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 06:35:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B33gLTb016630;
	Wed, 3 Dec 2025 06:35:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010059.outbound.protection.outlook.com [52.101.61.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9a2e3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 06:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ml0kdWCV4GcNmW2/QMMXCVT4H3q/IKbWCtaih3VWJ9egzjCBXEBb18byeJ3xX44uYIoPdFWt4q8778FdDsiUAW+Ift5WEr6Ci63HAxF4pseDxPm0deWrdBujvIE96mHkgxih13zC2NBWC80pXdJ3p2JbV67E+1dqC9I9azem6W+FturRt11Ga1CHD8VHloFGvLwDCj5VOw6INH1Qo1yVB3mmMEjWi7VcPeVYGXJksIrX9gmPSToF4PbJOCDD0KtrF59ZfQ13/w6joUcmpjeC2gLCVsbRNetgjNp7s8OJXvZp1l1VMP62BnBp8miD02xtz+63p4c1Oe1KXHUHGk1sDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQGtiypw1HwHus6RjKgSVIZD6SQk6wXFS537x59uG6A=;
 b=TdTlgKrO9n4CTHdn6XFCV6pOnGxvNdp12xfkCyJCvbSh2PnMiqnxih3NnyFRoCO9CLL+NMBqJzoaGApGqTbhVgHYhuQ8Ur/BkfyUhzj2+iBCshLLSz/SU6mev+kKGOIZPZlqxzXeMJGsBtAZrR3wUuRdMRCeFz5UbmZGxZNJ7hgHRGl99Ooiz1PiIG0GSSQ5vcM6XuNn/BnbuujmxFLOCPyVDL0BjsQ02gq/Gp0LZ1bNmM3pToDPp6gzVSmwCCdeKDnZ8jCyyGl1g13/ssGdjjsHQd8WVg1fnq4uiv6ALG8LHUx0VQ9Q7lS96ksIO9oOoAFRlTuYk6bXx0WLmtE0Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQGtiypw1HwHus6RjKgSVIZD6SQk6wXFS537x59uG6A=;
 b=fhksFJW+Sc2cYoWLzcF0ZY8E28vSoubeGqy4+Mg6zUqEKM1D6bJSg2rOWZxL6apDm60flXaUz5JZ7d7Tw07YQqiRchc1xj3AsmrLRL8TcXhA3QLU5QmeVmi5JNAOJ1CgLwf5ghfSqVCuTOt4un1vJtUlgPk9rQazNRjs46VVCME=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 06:35:29 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 06:35:29 +0000
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
        ulf.hansson@linaro.org, beanhuo@micron.com, jens.wiklander@linaro.org,
        arnd@arndb.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v1] scsi: ufs: Fix RPMB link error by reversing Kconfig
 dependencies
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251202155138.2607210-1-beanhuo@iokpp.de> (Bean Huo's message
	of "Tue, 2 Dec 2025 16:51:38 +0100")
Organization: Oracle Corporation
Message-ID: <yq1o6ogt6n4.fsf@ca-mkp.ca.oracle.com>
References: <20251202155138.2607210-1-beanhuo@iokpp.de>
Date: Wed, 03 Dec 2025 01:35:27 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0226.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b198844-c1b5-4482-b7de-08de323626ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SOVUeaz1PUePG7fp6unSJfbWlbzRy6N1P6gOZRCgKkis/Fvl+cfYW2yZ82yM?=
 =?us-ascii?Q?t6d1Sk+Mkl8vpshXukHBYGlaCwNub6rjkKxieg7Hv3BPWIsfgfKl4tAebEPL?=
 =?us-ascii?Q?9sPJrYJSI10inShKI+B7QhPCNRpdq25IpmxV2ZsHIbjwSFVt4L/P1POD+mk2?=
 =?us-ascii?Q?EeDGyMcfYnLNxZoGfVbVQgVP0DwzZjLiEwvRGdi+q/cpgP6fFkMnNecbvmPI?=
 =?us-ascii?Q?Evy94OiNP9z/Vd2Vulz2UK6FiSVVWSrD3JIoYK6NFwihgRWicmY2FRLl1LIo?=
 =?us-ascii?Q?iOaTydb1+JZZr+yG4OtNlG4GkAUZ8Ri1PRNfPxS1JLfjtUFLl5hiTzJGvODe?=
 =?us-ascii?Q?vz1JHuUTkYkOAmDxCHLkGS8BcFpQxm7NhQC4vYk0fOK0IsQzAshX5QEtgDWj?=
 =?us-ascii?Q?xZNyQbT1oRTAt027jhrilL7dXFYtSQILaYngvkawAU3hZGp63sRIV+8YF1AL?=
 =?us-ascii?Q?l1USEU3wRuXLeqKsRs62reduTBLqa86e24lzhdRB2dqVpzf+ny07dGDbvlRS?=
 =?us-ascii?Q?BEGWjQVwNPgM8crsWLsnyX0Cu8iXFaeiKekb8OaFcTaAb06h2Dr5EaEAUjSE?=
 =?us-ascii?Q?eC5pDzp++oNXYcgH8J/34ypUTmBA4HGzbooeozEJKF/k8V0y1UxznFtGcQLV?=
 =?us-ascii?Q?w9CGpHDyVLJ6foL5T7P7grD4SzvStl8B/M26kSy0JB2QE+W0GFAksBjdDmUn?=
 =?us-ascii?Q?HPR5STvYZB5Zo7FebEU5CibzMjorrdf/2dCOwepfRd2vhSI6Ef4ym90/P7/R?=
 =?us-ascii?Q?Ou0O0twxmJCNztfO4zEdGUjin9mfMU/56g9ndW6uwIlKmbB7YbltKci6Yaah?=
 =?us-ascii?Q?lMEyzbsD9q3u2sGUPU2ZWs9RgyvTOO9u3pq7yHI+fCgDy2k2FXuIFqCFs6JV?=
 =?us-ascii?Q?Sa8Te0uCWqUFRzoj8Vyzy/2LXcpt8qJ8q6M+p2oV7H4XedGc+0lNPkAGqK+U?=
 =?us-ascii?Q?6+de66TUsW2dqCXuY/LJ3MlO167Nrf2A34eo6yy5eGk4+Y/cNIqU0eK916h/?=
 =?us-ascii?Q?dMjZEhLGVfoiPlwNyUnUE+xqPuyBNKxXJuYoEFwa1G6pFt3CHwo3PPxzJjYl?=
 =?us-ascii?Q?gC+OSP+hgMmt7V8B61H9pXkEJIC0VxDVCLIEVJBtP6zVaz80PoXi/rErIyuY?=
 =?us-ascii?Q?h9Pvd5V9hZje90g4MwnX8LKTFgh3ZiYnoG9Hlkczsqyb3a1XqJzgzxcXa6/V?=
 =?us-ascii?Q?WMZXM4S396raqcHAlUL/ysGiuZLcC7ZgnUrcXqvuLTpaa4tQHc77Bs1ho3Fw?=
 =?us-ascii?Q?NhpbYUpM7O8vsGSdcenm2Tg4HQOGAXXCBAwg9+B35+yOYD06VcT+mZ1GZGBa?=
 =?us-ascii?Q?mjtbpAL3kBOhCNTI3QPudNhc+ELCwXTS1dNd+RA4kOEpYREY60NcV15dEru8?=
 =?us-ascii?Q?dB3GT+0eTbGJR2ZOO3N0sqs9W+CdTMWA50vOu7cmG7+GAxJuF0K3QDFXN8eC?=
 =?us-ascii?Q?TsZi2Q/y1MNPMyMfxm/xfYwfDAW7hNZI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gzWTRVE/pZro34hccWysHsXU9ZVQTKhSmNWX0FdS3hEkMFEymGbS8hLdGNXs?=
 =?us-ascii?Q?t5Z1KTSiqE5lnGE+MCJ7WqKekCiKqbt4aO3Xctbzsa2OTvTwKTYP1h+g7cW/?=
 =?us-ascii?Q?XWd3BTASNc71p8WN6yFMdERO05B5qrxyHJ20xpt7mJ2kUbW46oZiokpXahsD?=
 =?us-ascii?Q?SH1lE4Uf6OBvX2Cq8dc8xZni8JFLyXYemakuA3AbTmLet5o0KeGLbHk/mrqe?=
 =?us-ascii?Q?Nue7E1AZnqY19j0ULRnbkP1fk57RILGIYUWWypPUlMjF4GQJPMMim0DexkX2?=
 =?us-ascii?Q?gSJPTTyP7KdChH4CHkNgoKrUUZImh2IjuXGEARd3P2E+DZ9FwTKIgOK4VMC7?=
 =?us-ascii?Q?zc42ycZCzLlFeo/3A3DpOwy2tRzSr37PWumiVZET2OKzS6EswkvtGOVabzii?=
 =?us-ascii?Q?V+g+1Jt3gEw/x3jOU742kZJA14h/2EsqXulswR1s1Er3kRXKbf2z+dE1x5Wx?=
 =?us-ascii?Q?Z55LuWPbKquULBaMLDcKNrmqof4AqEiYPvEXxWhdCt5tyFH//QrykIcSodaL?=
 =?us-ascii?Q?CXQhdoDFpua4ovUOq6uirInoIJ1yCSPPG5rdwRj1pwjfs6cagJOziR+6QRsJ?=
 =?us-ascii?Q?zbZdsntnz3n9z2cKEueE1MQVH3PQHmYdFaAOm/WSO5vqdwtYPjVs10IZv9/z?=
 =?us-ascii?Q?M0WhnAgN8JKA9fP5hb7K1w+QzHfeOYtmBZ9dgreWBtHsh/CwCgy2wNoT0ky8?=
 =?us-ascii?Q?H5MmV2/eHl1tWw/pRNxRkw/rHQv0rVdRpQ5qe7gzd38xytlLd6YeD+7OXC1n?=
 =?us-ascii?Q?fjbbki/f6jRyNKBlLEyPD/e2vD82rvOPqefQ3mKuCyU2ZozGHLwzdUT4qqep?=
 =?us-ascii?Q?SpTsKL/kwOAZgWvJ3KAw8pqVyQGGjpguA4Im9M5NYtorHccjk1a9HtWkam5Q?=
 =?us-ascii?Q?hEN9NY3UyIsi66vWpgA2crNqSPhv2tjYdxU65NB+D5QVbaHXrsQposnHobv1?=
 =?us-ascii?Q?H8l21jOebyPQohsRyRlhbEVRtD126Gg4dTEsCEdaGtgEwgW4loXav+ONAzDd?=
 =?us-ascii?Q?ie4HbgutcdkmffAv1bDZd3AtQZxUiaf/6dHRdwaMtYMNDIdMRAbGA+/rPjqX?=
 =?us-ascii?Q?Xh7jm3asSieHMW0zUtl6vnPDqKPbS+GGq55WLO4UX2so5JJbViw+GVal/5Vs?=
 =?us-ascii?Q?wsDecRr1Ac7iZWxhbcWDqUhCDer2+/8+WvrBco0Xkx2j0tarropBjLqYgsmC?=
 =?us-ascii?Q?z8+bQ5HdXk1Lm91z2C/70izGnGkdi4aSkY+uK5vY1Pk7+73yqmIxWLikknFE?=
 =?us-ascii?Q?pHFXB0hjOUrrI1Jay9VfwlUt/qI9eHHCgmIYspBpVyS4fl+fJY11TJ+yg2RA?=
 =?us-ascii?Q?nVVO5O1uZ7P9UaTDmLf348YJnWayperwbfyV1TiJMmUEX+aVbNgmKefGTKV8?=
 =?us-ascii?Q?m3Nsa2XFuzrcx2gQ+VOVO2/jibr3+vrYfq4fapfGvNVqWVNOQ8Rmr/9+Dipd?=
 =?us-ascii?Q?JMTj2feUM/w0nBSxUgyjumP+yEcjHOQtMfAY+MhA0dGcw4etY8ZV6v7yC1v6?=
 =?us-ascii?Q?Cl4Go6RRl9qaH0s1nhuhZlwm8g1lmbCAqv1qqEztZtLcCVTNCST0BtKxcqqb?=
 =?us-ascii?Q?GG0BIU2QU2gNqWFEr+uFBj7oGI1eDELHjpA7nrvszFyA40hNVq+cCjegvqzm?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IlL01ucrQPJVNB1XL+MSBes7GH7Ai6RXAI6BdL7O4DxvF7WGLHinbOed2pVU0SuBlOrucacs1vD2xQLT6K+9HEvGPpLdBCPxiYvOr73RlXe9tD/mHG//LjMlcGSLLOnZ8luNqHT7SDkelPPSpvt2j8kUoGW25PYqvu2IQhiJehh4HAKwPopoQdtXcD6TJKG9qbZ8FieSedao2n1zJtPeLzgYwR6KN4x11v4WJwIWulFd7EDTN8ajW1czm7DOMR4r8tKRNRlVzlWd/PRemdxbFX2A+9sMYyM1YNDL1dSx4zkFVgvd7nQPgCo8B+zwKtG76NG7KOsH397c0K91Y9HgmBAVAR/S7YwLulJRBtdcZdexaV6H3L4c7WTxBOKNECMazs1jmaFejqYcangSYhwzTZagXVM5GCUk7AjcD7eSVpGUIy9AI3YWp+JQOLmwXvb0VJ7hmX859uUl5T3IA8iezIhvS3XY/jSl/VdQ+4ymYtWVUj9cTlFw98b3brhUp4Aaz+vpWK91JhG17L4DxAIEfd71agWDkhC8JVbC4ialkGxsHGCNs/VwR4jlFz55hZsasw4iiLxlTosluKySaaYHL/ctKgY7vMHS9GnuinS1cyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b198844-c1b5-4482-b7de-08de323626ae
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 06:35:29.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cax8sDKWaKV71SbM9KLHQkl6QMa4llFRTF61s5o9si0Aa7foNtfh9SltFrcoXMSmDOFBVl85P+0kV5IAH3SlusCSTin5QYivvyLzIIOcdh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=910
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512030050
X-Proofpoint-ORIG-GUID: zFK7Y-flSwX8NdkyHHlNGhNr4CpPJLnp
X-Proofpoint-GUID: zFK7Y-flSwX8NdkyHHlNGhNr4CpPJLnp
X-Authority-Analysis: v=2.4 cv=W8w1lBWk c=1 sm=1 tr=0 ts=692fda38 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=ZqE8iiNBColObR7-44oA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDA1MCBTYWx0ZWRfX6mro5hCXRliy
 nRoQH//ISY29hUtm55//oKW2qnR1d333hiL4riv49HFeVCSfXuF67Aa6lQP9XWxYFm3ml//YuDD
 yBqLtO6OAGisCh2I7IVMOhpxUioWZ3twWj+aJQN2M0VSNlq4TeXEH9Q9RHdEwHleygmpwsdc0s+
 asb/njSWI9SvmpvKvZstd96WP4OgQ5/+TE1MxBBP6Uh+ksqFPRNnMaJAkSIpGSXxOJzqzS0rK+z
 Vm3qgvvj48EOcZpayyyRw4Eu+cfTDWoyhyRpAqF2XfF259evDaX2LECb2AKbjb7c6LXYmWdNQsL
 X4ei/2aRoBgg7T4tqnvLuMH39kClwRcALZADjmcMMcf2fvII9GGicqYGceErdPKNYpJWKEe2ot+
 7TTAejXklelpOSWJY/B3t//eNUoejA==


Bean,

> When CONFIG_SCSI_UFSHCD=y and CONFIG_RPMB=m, the kernel fails to link
> with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
