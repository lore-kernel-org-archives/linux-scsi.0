Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544622248B9;
	Tue, 29 Jul 2025 03:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753761255; cv=fail; b=N4V/n/0x9WrhBqHcJqyPQAckDfWrSqUkfWhyyXAlqL+U5N71GLTt7Iv4puBj70QRXfy9Gs9IvOTVvwJuxLADoj6UtG3ig4EfKlopEq1zVn4wlhaGgvT1QcrpULAZRc/0COyaEeNMRVsi1rxV8XOW0/EXgAUbXO8LeD0r6gDA5uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753761255; c=relaxed/simple;
	bh=J8m7isfx1ar4GUQV2mqplAGPmj0CXULVpKf7Ycln+mA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=K4VCNWK7Bj7WQOTpHavL3hCP5cpzmz/vtjL5o/YaxEXFpdleRWUiB15d0/8LMrYSoFyQtbEvkqorbtqhxkDC1ScZ3v86U46DLM0OC/7jPKwz92NIq8pWdiGw0ZBMhA87PyDlPUy6ydun8WuECVkHfFCIxmH3fBcCJsj4hl4+0E8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LzK8o4pu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NipdyuIp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LzK8o4pu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NipdyuIp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfrOs012587;
	Tue, 29 Jul 2025 03:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Gh1bCXLVz3wH/J8/Dn
	K/nhwwPkeE9mzleh4S67nf7bI=; b=LzK8o4puzkNdWtgS0Lz0IcTA57hslBVL+V
	KQx6dQ5YxH3tcCZMQaXAhsB/AVUnfp0bq/3IeqBNETjpCPvsxxTmc9ku/sz3BYhM
	H17mhyjgYWAuCSSRRbeQIay2VVLKupzoHbyuNH6R+jekeBqhe/AKbyUN3giEQmm/
	bww8Q9QcK/T65s9G7cvPSLBTWGx5wNW8g/VJNzvmoai8nRxBz1qCwSxyhjQ0lhBE
	2Sn9OuxoL+ysn8w98wWKUiJTRmeUxtN/MfwViUI/UYYxWzfixCa+1iepdirejqyy
	PmbQdawajlgAvKJJMAkE4VzxdjG1jJeAIWXaqho62RaOHFHjpbdQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2dxxf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 03:53:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T3ni3E016838;
	Tue, 29 Jul 2025 03:53:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nffp3j0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 03:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tu9JW2JAoXS3nn6OdprzDQSXSe5r/9pqlAvE6+/u+RpTGpTGmZu8PEKJ5lZNmn35gYHCLjhFF9s5WAatm/D7X0wa5DZX19G4lRgdq+bbRrgZOk1yHsXNLbqH4dfdaaGVAsYbpwoLYqvIJpLnrSx6QKC5YpGPO5+PiAnwqAMM2vbwl6bakQ/mv83aU04tvRI6hHShxIXadsow5yMGzWaU9QdT05wtV6tO3ujP1CykgW5YNGcM/bToVgbf3hL2HxilaI02cr9FIB8YTWVFW4s6h44SgSDHMWkaHRGQdhLwDsaCO38DW9OE2Qs1TNwdAwnnVill6/N/jiXdg7q/I/ZqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gh1bCXLVz3wH/J8/DnK/nhwwPkeE9mzleh4S67nf7bI=;
 b=ZKGY9+IaFGe1JFhgM/vGUsuvJNhBKHVLa8Pu1lw5sBoFDYo8mqU8+gb3jWc4wB2ggc4XKXQ4/YN0CwDGIoKc3XpqSpvSvq+aGo1H0hn4n8HP6g22LaFrn4J4prTngzbArrstcoSFQ/Nz1z9kKbX+onrUBRkV4Eb7YYQOY9cnI48L0NDKavGehB1sIrMS73pucObTfryaNpOxho8kFt3TkJrrApAAtbaiwZz3ZIh6s7kUeqhsov+ipdYEtvv4LQL6/lDAj+Z/BKUZn7MzLW48GPTDpIP6nx8YDvTvpjfraYW6zgBDC6MHF27d3HwFrTMRDW2Ioe1LY1PxP5Aq41FyoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh1bCXLVz3wH/J8/DnK/nhwwPkeE9mzleh4S67nf7bI=;
 b=NipdyuIpLzwyiUiJoA3XZcYOGbrjNIENLMUCltDev6TTH5MZSyA9P5Ev9Qyqszcy78TmHQM13bIuMk6EEEV2sGpXf3CQpDsrzOlblLHz/TClp4g0ALc/5ZLgFNUkijoW2wnKfmoPs41dk4SvexNk/n2hdY8HO/0b7PMxhUpmCxQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7461.namprd10.prod.outlook.com (2603:10b6:610:18d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Tue, 29 Jul
 2025 03:53:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 03:53:48 +0000
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
        =?utf-8?Q?Csord=C3=A1s?= Hunor
 <csordas.hunor@gmail.com>,
        Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: Improper io_opt setting for md raid5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com> (Yu Kuai's
	message of "Mon, 28 Jul 2025 15:14:20 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjp3mz6v.fsf@ca-mkp.ca.oracle.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
	<bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
	<2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
	<6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
	<655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
	<4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
	<a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
	<9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
Date: Mon, 28 Jul 2025 23:53:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0054.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7461:EE_
X-MS-Office365-Filtering-Correlation-Id: c33eca6a-ee2a-4743-1393-08ddce5385f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L2HKuldbEzrGFl3qdZT8lvq2BrvoEWEDjUPcViWNWYl+VnOf6eP+3jpBqvyJ?=
 =?us-ascii?Q?wxY8yvE5iKLD9L9XwF4JXjuhX19JBVg85Q9nsUxA0F+EKPhvZH8XM5xKUFFz?=
 =?us-ascii?Q?S5LcZPt76LmPfztxxNN6kMxckWGXCQfahs5NwhHjXN7sKOEiav/Kql5DmX0k?=
 =?us-ascii?Q?GHW758ubPcy9WdCrWs9o7uhSxlxyp9E9U46J0hSHoMRPFViSMU2Gm67xSu/B?=
 =?us-ascii?Q?7DNFWHc9k9VVMHjWl5YmgVSj4scbkPcK4VhKaMvd6lB1nZyHdfLrAm0O9E1n?=
 =?us-ascii?Q?3344L5VEu7JqtYTe7+8XEZGgBC9wlcDrLqTaFvgAEn6VxDxwLMI/8HcgpXN1?=
 =?us-ascii?Q?TPSkOu4Vdnl76klT9exsO539G/8Gyi0cZNlfJSw3Zm1ZOi7LIVAfqxU03Hy2?=
 =?us-ascii?Q?P34E7P4BAvQNITQPzRGBPcFPhgBfdoRui5IWNUZG5xiRZ56bmTXH6jUSl226?=
 =?us-ascii?Q?4GI60Vvf8K9k8gYNbvVCRLcqkzwWDPd7tPZBK0Gfqvm4pMfqNWT56J9NFUBX?=
 =?us-ascii?Q?lFr7hgSDn14aNBNAB8qSarAP27jcc5VYBM2SV8+NyeslnW10VKBNy+/bMoec?=
 =?us-ascii?Q?eFlZTIL55yhkL14EWY7DatZMJYOB9DKnsgnN/MGaYTd5kMm3bWx/fc1tQg0t?=
 =?us-ascii?Q?y9trMxJ1V2CMX3mSV7Lzl4aIDP7FsxTTmKQJ5/OrEJCefyr9+z/perqAZBpG?=
 =?us-ascii?Q?/e4J5q63RuKzJZpLq686/fNq0KWdTtfW6RKznxOv0mRpZh+5PXP+30NYBPQO?=
 =?us-ascii?Q?X3e2EuAKe2K0vbevF+vhDS82h3vTUCLSA42WPs+ba5dEfIvbb5rhTDNDoYiY?=
 =?us-ascii?Q?5cDA/wsOwXiZltIqrFa0XqJTjAcabz5G05kjp6Tue+YazZntZtFWgnF7pUnA?=
 =?us-ascii?Q?jmH/QTrogIYmkH8WDvDhUbopdR60X6ghHHFE4l/RiGYHzms/2fuv7T2CQz56?=
 =?us-ascii?Q?wrNs8DIU7qYocCCpoP0mIpNOXG99PHHfbDeI7cXAU9SrTNvRQVRnHgstft5M?=
 =?us-ascii?Q?QHZIl+0WD8kw/4g+vMP4lD9M1xTT2EjXG4EBP03T74BpZoJjmPZSj+dNs2AG?=
 =?us-ascii?Q?kmt68Ui6bnAwsr1Uoo/YXSo75rxtIev7qjqw5Atv3oFkYREN6MrxKKXy14Ve?=
 =?us-ascii?Q?pqL/oAPCDXn9aR+s5lYa2V59AxjLyKGTuCknTJbVe8F8zCIX/oMl5K10VTM1?=
 =?us-ascii?Q?F8TigK/FZfRimG4pI0lBgZS0zMyAxgy3ztbdZA3NZFVNd0KMAUHl6Ao0UXa6?=
 =?us-ascii?Q?hnMh5sUxTCSTMK2fD6Clyf1sBfpc/xK+b5vUE5BXkYsh2Fsil61NEbsqsYhV?=
 =?us-ascii?Q?cpBDUp3Acy0PdEXJ1wn2DbKISdGEc2K0IlbNeld/CaYKDGPo51FZugsCSyLT?=
 =?us-ascii?Q?dtEzRbRtBqGOu+amuyK4ZQsx10nE5+G0ZbLbd7YT3zVZUwrAoA2xU9w18Aye?=
 =?us-ascii?Q?KpX43JO6yHc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1zDH5T0sKtrb9kPAG+KcE77Rhu8a4l08v/evm8oKtrJrOhI45x0unUUNOKQm?=
 =?us-ascii?Q?4Y3Ua+c0lpgv0MW30SYPt40IBOvKK6Qz41ukVW8b9+r86ctYAe8TBFoJrXtc?=
 =?us-ascii?Q?8X7vAxOH57Z41IU0veCAiIwt5JnYRdQnFmh4OXXBaTGxAQbWEjSvbExGyg7l?=
 =?us-ascii?Q?sA/FPqgHrewZ0PrrzjHot40Q2s5rnKoFoOwmA9hDjjPHzgtFWAOiva+unpVg?=
 =?us-ascii?Q?PdeRZMvrGXnAc608JnwTH3lKeWzu9LDKIB4cPpHkH5sYWZcKZqJNDOxUqu8U?=
 =?us-ascii?Q?hdWLzsl17mDX5Drs0SB4hy0+4DSVLnk19LNpyoXs1KtpKN6W4dIY/8vPz7P7?=
 =?us-ascii?Q?/UtJ2UFq2sisq8CweuBwgjVgM89yf0a2GScAfr/44TKMEqFom6y9RX++6JVJ?=
 =?us-ascii?Q?pxVb2Sy+2D+mPhDfhPuv6rJ46rWs97otx4K4E5seizFgOTQLhaEZJwKaWc56?=
 =?us-ascii?Q?jTNkGr5tx7LifgeLGiHlTzTUyUVfIJhP+hIY7WCx6HMiNadBwZuih+M3A71x?=
 =?us-ascii?Q?O0+/Ql3t3lTAXaNDuaBycwkR/N6ttEvbVAbYYR4vSRqbCHsKiGxaLmeql4e/?=
 =?us-ascii?Q?ioAnlbtlKQNsQ5qTyJQp5ZWHSZD18J95X9YIB0aCjfGN4eI8TtFsD9wpTuuu?=
 =?us-ascii?Q?6RwvlwLRUKqxNTsX5vxACflKAjscmUXrdyS+2Zv/RJc/QBPNY+aX6OT76ify?=
 =?us-ascii?Q?s97tsofi2lWx0NfORbWArZkdM2+uz5RHwReXFBIS7dde2Twb0piaAiiBHkch?=
 =?us-ascii?Q?Ky6HDMHnv9NdEc8xEA79OqhvojGGix7LWX5QP+GcIRjS9i0viI5yiK7dgy7V?=
 =?us-ascii?Q?otK+pYpbxflJYVHgcc0+6KjMG7+w/660V3btFZ71UQNCA1mxm+GG1Y9lZy/O?=
 =?us-ascii?Q?mm/7HiIr1aFH+VOyajNraugVRCyp4W/LG6nM4cRuB4FWI7JxRRSzkt63sAdN?=
 =?us-ascii?Q?bs7rWMu+x6ZytxHE/0i8+4/RxxcqkJCgj2EjdB8/gtP0UeSpom4vqcNRB76u?=
 =?us-ascii?Q?xtvPcgdjGIb+FGHmPEFzGs2/zdznx1wMrnFu9wzRCHv4iPmh40/Nbkg5dnH2?=
 =?us-ascii?Q?IGF5LlFvlLIclUJzgNOuSaeUTTtX9qMOVx3fHnWarTrnl0vxqFX+oPyHUIjX?=
 =?us-ascii?Q?ZU30a9fVWDVYUIC5zNJ6oSIWt5kSKSjFI/ejAH+4ajvhe3Twbha67J4X62jB?=
 =?us-ascii?Q?/IOzvGpY4dFjtt71kBNVVRcSOHH/bSamyQTOcRv8Bh23wuFXbE+F4DmtALUT?=
 =?us-ascii?Q?eiQao3HRFq6MB7IjwNtldAkFqlCnEmpJ6ka74TGgRLPdw2Wrq7rdghti3jf6?=
 =?us-ascii?Q?lkndHK3o0/rGToV836ek+ZsFA6fdm7r40WN1bNoCrbQRIDydI6BM8eXexPpT?=
 =?us-ascii?Q?6f7DWezsehCNWLF/0a7efKyeIOtjnGFxpUYk6sNuEE7/t1DZ/zhT5RNQU6FI?=
 =?us-ascii?Q?5Z2TlmZn2R9MIiI8dEjZZu/m1nBp6J1PspUz4Y55G6yMQD7YnKURV4Y26x+P?=
 =?us-ascii?Q?GOTmeLsH9xXDPsFvPwM/pGEQ931rj0X4zcE32+81NexJ8a1Ubdfo9lQhm66v?=
 =?us-ascii?Q?/twoYGGa4kuQuCk+pz7pzzysTUOnsTl4z4clKJ8Of5MwRXWvGzoeo+AAJgFY?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f5HF0aljazWXCJ52zw/5pqbp8Bp9Ylq2xY7KxJMI8iY4V2EFoe00xarRzUwRxrVE0xwTtmXKuEaeNcqkrWK6apXYog0i9dzlupWsOADTBJsRubd8v0cp5ES3JBWNQ2vTKt30XCKSJtAtgyg0Dx3Dc/7vP54mOC8PaBkoK0OBM9X01UeZ3QHclCIJ0nRbApo6b/l9ruOJkdw7qk/nlECHb5yAW2+C7nNQBUwxJNMRUvXzbVBhAOR+Q39YTsDX4md5mTVCPxzJ4xK4G2vqualifRc/oQQl7qAWAAcH7i2VNszUUPOeiDbm16cSd3nVGwdlMKxrWRMRvmaBSxmSrY2gEvkn6JBt0fkY8c7ZNFU1bYgWrltE/bwyev7U8q/TAdcd99m449nOcWl05lYkzQvFJMRx0J4sKKYYnlv/7Sx3W1sCityx72NIM7fR8TyGxKsxM5X+ld6sW9HP39um1cQqgkRIegtvMBpanOMORbDoK+SxRrG6V/NfHA0giJ1JdmKJe1g7PHQqIONRby9e+qQJo/AhIA/ocLZ7bMpv28rE53Uj91GVwcp00XQq22Yll5JspQh1kt/76qGtq3gBvFefNLaHyEMaeK8mgAKv9ChCqqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33eca6a-ee2a-4743-1393-08ddce5385f8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 03:53:48.3069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QppVp8Ndz3QncYlW6w4leRETqKrxVLGoh/YST2CsYmksXEVjzUmePtsXo9vna9D2UVp/gSnajbl300IWgL055ZWXNgksfI5WJUCodRAHzCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7461
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=714 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507290027
X-Proofpoint-GUID: YS3TafAZSz1VIyfx0k2-P3sL7NPJnx60
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAyNyBTYWx0ZWRfX/uIStFY/eRZH
 RrXh3EmjYdDQz53s7p/sVfE0lnHNIw+xgyjJenlhN7FJFOw9NZIGKA8az5DzvwZBafW0T1Zblk8
 /RBa5aDLlRQPtcSgbyXsRMsJxoIX7x94HYjWmhb9uI9veyv/UjQgvMHa3HuiXjD+NA6ERFSFkvP
 Y/G4K4U8bqWdEMxoqL7WjgDnr0lEIi6LcrvKivYLZ+j4Vm4xcb4o/wtKp5oFjnGhlsDePuImy5f
 6lDxenh7NWxmAui5CJYSGrV3YDU81mrxt6iwVVkDaYk8SvTp2FqTEvVXrocPmdgvR3cUxI7Xy4J
 v+8AZ2gq/tWe/Yo2VlQjftFAwndU7DSL0MplH/0rIrCjmm9QaGONkHkdRzacMyRj6tdhXCKBZ1A
 iZFZMtGlGtvKIh+EUoxZFDi00tPAdu6I29DJ/F4gWLuSDeYR2AlEU0AEMS3/sKTq6Aoi52vk
X-Proofpoint-ORIG-GUID: YS3TafAZSz1VIyfx0k2-P3sL7NPJnx60
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=688845cf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=WJg7Gr3XNeRVGIc5TZ8A:9 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12070


> The orginal problem is that scsi disks report unusual io_opt 32767,

We should fix that. We already ignore a bunch of other oddball clues.

-- 
Martin K. Petersen
