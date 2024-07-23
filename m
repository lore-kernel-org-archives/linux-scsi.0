Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881774AECB;
	Tue, 23 Jul 2024 00:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721694786; cv=fail; b=bj14hXDU7vQ7Sd3DQB+kGaScEBt8xCOYFgttY9R2Zd9KU4PzAQD17NeISqmR2nnpWvq6XjsjhB856g4iCAyMHx0FXB7T4Etn3UlO+6I/xeRQaBDupWguHbGnBBuhztOyQT7z8LzDJ+Tp/rED5Ve9LDq8Rb7JHmvKjnKP1DxGXho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721694786; c=relaxed/simple;
	bh=qH+QqhPEOSE8CWrbhrIFVf/f/0vKTh7LjY1S53D99qk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ooZZOaDZO34cgA3c0aonEXUi1H+mMuJbYXD0UBpGNJCCxyWJJHtIqEgc6xxarWQYh6vqnZ5ym/XnjfypCJdeZLrr91eMIabYegQj5HcGpCfqhSZU77AwMII5P/4Lr+ZH1PKI2+uiZaVNTuED+r0/tYSViANX/o20l4SaXofSvEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gj3+4dCM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CixXhwBH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gj3+4dCM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CixXhwBH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtVAp023812;
	Tue, 23 Jul 2024 00:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=lKp4gkqfTHHViz
	23gpXCO/cJ1WalISSyUNcRMS8qROk=; b=gj3+4dCMWlsykO49GFQAeOxPH5HD05
	l30qZrSUIQVanyHUb//kI+vvkRylJ4Nwulvs/MEtTKSfbrUWARZrCa5oc/ArrBRr
	S6Y4gEOIEyvJxSAaLyFFx9IgMn2egglRy7cLiaAxCZzSf9vzZ8FYe6SyS4wUBpH4
	WXD3zhUahFeFwxSr5F/hbxFtVH6t4Vw+ZByJTRjiqkxEKnTUARF5aq0P8qir9/z/
	3lHJ4RQ5z7hjYBmSRLWpNlCb95GuLW9OtkGgigkGLgeJKcbi6wKQ1beLvTxz1wBq
	yMh6iTu9ikS/hg7/Bztx8rI5jwTAV+ZUxAow+TEF1OSgrY8gqDRNXpJw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfxpcbgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:32:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46N0FJUN033611;
	Tue, 23 Jul 2024 00:32:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h268q5fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:32:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xxBNstJq332mSU3DfvKR3d27GiVxfOnqxsKM+GL3jgZuRRrKXEH3Ls6O/sm1GjGeNTVOJq8rwcDXziyV35RuRC9bQiPUrm7JTpXPp5yiGEtxhsjTzKnMpKRaNvA/LiPyUWf7QvRK4hLyTQakyv78+0A6Yx/Q0WrSvR5w4DodvcY30kDbewvyyfRw7gazxooAufsYQC/DrfpE1uXTswDCn0pSJ2SfuW2mI8feQnOAn8RZpeBg1fFwmgaIBVVoPLKuzqxGGloQ+2mRSNzU6r/Kn58evtJitjIjo5WOT0xPjzPGd8T7JV1wVuXhcop4MuT62I8xb/4VTjs7TjAdBLHQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKp4gkqfTHHViz23gpXCO/cJ1WalISSyUNcRMS8qROk=;
 b=Phr47SOWdlHg9zQXSxMPmgHBeaQ1hcH9+fHSn8zadn6IkTUa6LHGBhu/8Fh0IhvLkdGfrJbA9ydfMOUEQlh7RIaXHxv8r5XmNJtT0HPcqvZlWSdjCWQ0mHzPYZkW4S+i4iKrWSnKn1VgCD9VcKfDLMAmpbDiQDB3TjFrJShISnLr2LH8Z3HCVLBOMiwnrV99MNgGaNKmMROBPGnFat3UAVwykIWOJ8ZAAdgC6WIIl/cyem6900+KOBtv7b9vBNc6yfdaE8cwuhJNep7UnkeoWGGRBZ0HcQZUfQbyLYi8rr9f4zw0LDm7pSzZ02jgc7eCJobXUZPBvaD1e9F1g/esPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKp4gkqfTHHViz23gpXCO/cJ1WalISSyUNcRMS8qROk=;
 b=CixXhwBH22L8NVTnzOcvZih9O/3utvpclz8CvjmbYFHvjyxk2A9EuZMBPZqI1j5M/6Rruxe3t24QfEGqafGDAe3QN/qyKGis0OLq0Muih30fD4HTvlkrSE4GnSN+9iyszgFA4NH7MIY5Fx3CdsCoBTqYxkUJnqYMe0wMEOWR1lM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6145.namprd10.prod.outlook.com (2603:10b6:208:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Tue, 23 Jul
 2024 00:32:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 00:32:53 +0000
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anjana Hari
 <quic_ahari@quicinc.com>, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Do not set link to OFF state while
 waking up from hibernation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240718170659.201647-1-manivannan.sadhasivam@linaro.org>
	(Manivannan Sadhasivam's message of "Thu, 18 Jul 2024 22:36:59 +0530")
Organization: Oracle Corporation
Message-ID: <yq17cdddk2g.fsf@ca-mkp.ca.oracle.com>
References: <20240718170659.201647-1-manivannan.sadhasivam@linaro.org>
Date: Mon, 22 Jul 2024 20:32:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0475.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b6108db-917c-4ca2-246c-08dcaaaefda8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZxucIQT/BbCZMuaa4SeNFYo6eg3xKjJ/K4MgKVrTLuHJaAFzyxAvk0xsesUg?=
 =?us-ascii?Q?guD7NqV+9nFp7PyZCGT/gp9A2CTYf4HkgmI5iBBybMUMVFdbg1cg+ShpqGiQ?=
 =?us-ascii?Q?8Q9bm1f8URTj3P1L8q8GaU/IT+P9xB0s8m4IWrnPC0jc+wVTGIkkbbYpisKW?=
 =?us-ascii?Q?Ek1uI2WuK1PtQNm6BCTne78yMgs9F49zYKZV1t5T0ggsggz39MB1sC7nbU68?=
 =?us-ascii?Q?va9U4ncHHpDIdQKxJKeZVyYx7ZPH7KP6tuRl+BBM2BxNISGidOyOXDXrP/q0?=
 =?us-ascii?Q?T9h+MINBlRzwwF0n9C8Cs72gGp8nbub98OmNSgS11efe4OSGIM3vQ9sMpIDK?=
 =?us-ascii?Q?OVNgYZHz7wM0rUUNAnhwmS30MXQm+c5eDHsowgAWcu6KmqIX7/54a59vW9l0?=
 =?us-ascii?Q?+Pexi/oeRF+58fPzdCERB9iJwBtnweTDmAyKnyIUkMWeDKf5bYPkEXpAO45F?=
 =?us-ascii?Q?zbSz+hc7AQmlFLUIO/FqWtsPUNg67UZi/fq2Bdvf6wngKeIkX5GHFCwsn/Q/?=
 =?us-ascii?Q?dd7YnpAS1lp3pe1LoP66/H3b2SbrEC9adSfmpe4N1CZrqD4CksAGa45yxmnO?=
 =?us-ascii?Q?wE3ZV273v7KhYEWhtBL3TLZB5gnI0fE3aetBrtusH/0RH1nKpYy19kK4HDJE?=
 =?us-ascii?Q?zLIba5kSPWVrjan/XhEc2b/HavlxEaLw5B6rxqduhonhipcYE5A9bPedXg34?=
 =?us-ascii?Q?itguiVRGbJ6rYRmoVYMmfH7Lv1x+9XSm4E0tDwKxsAO+DxLDYV5MLylgjQll?=
 =?us-ascii?Q?OzJzbXUFRmWdMG58za0Laes77SkXDBCUR6+MijnejYEKgMJECIjyFPJeqqDn?=
 =?us-ascii?Q?wtv0+zNX2Lho+N2rjV5GFiH4QfjAIY2TtL+XelRUTp593gwqLbbclmX782+B?=
 =?us-ascii?Q?hmRerxlQgp1Wrx630fqx1O0gZ67f3CY7CglvTgVQ+kcKrgqqmlLzYaHvmtHO?=
 =?us-ascii?Q?uNHwYzycQeYdIPSklB0QRMtGc2n5z3BW1+wLurDaevul3K2nluKD2RcR33Bg?=
 =?us-ascii?Q?6MB/PVd8xjozvWYIsNofFLHyDdoa7I4sUDsHG4iIrS3H6wjR0HU3QxTuoPRD?=
 =?us-ascii?Q?lyoNDysdW5Kyyw4soeCybCsoJ3nUcG9vJ7GrKmI9XXiI7pv5dFIMCtHp0Zl/?=
 =?us-ascii?Q?/dqW7DWnALWZf+VQxWchYTvltWNUnxKJZEfIa3PMv10G6VuC9amKsHMRWXSY?=
 =?us-ascii?Q?fXz2u9STiowhUSPWMBgZ/0oF/W3x2x+yW4Pols6Aw32Ts+QOZglcFWMeyiu+?=
 =?us-ascii?Q?4xrtd0gZdPccE5D1uanCxxuNySKlymGGowjt9bxD6Eh9pJ1vr/jVJafHT6kO?=
 =?us-ascii?Q?/Rbtto7QjOP/wkGjmATcyxt7XlVGsGoYgI6NvKllvsWxhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4PN5ff+cZyhLPUHozzoH/GIOhGerYZlLzVvSlZ87RLdbIlVJTVRePq54DSbK?=
 =?us-ascii?Q?iLND/WvkggD0d3w1y6+JsV1bLwN+LkVgExIC3X1vBSP3yt4YYRFvwum6qf3W?=
 =?us-ascii?Q?XB3NiwrQ8QpkCYma93g/IDyTeaME5SrqpNk8I0Km2eyCgDKO5YtjEXx+Q/xe?=
 =?us-ascii?Q?Qhu+21BFAqnGdbFFjqzFIDv2p1JZ1M7MihnnH1VJM2vOB7CFrtl8fuUfuHwJ?=
 =?us-ascii?Q?C/RIxOH9CHOnRdkZVcTkekXgSwf59crk+vjLT4W8Y3Ns/N17uVANNdpe/EKP?=
 =?us-ascii?Q?P5jOwF0GiB9/aDErbuL52EIEwbWnRODdXMf3Qwz0UWhpZUIDtJ8XpLowS856?=
 =?us-ascii?Q?RS+lotTeTw0pY7i9DJplZ22G8BQZsnInAmNRHCRpsvWdehrJ4bsoFqpMHZdo?=
 =?us-ascii?Q?1WvWyE3lmtcIrR5UsyyD04ndjhxtm7VtutKjxana1aaep1vQ4fNL4x9l5qLv?=
 =?us-ascii?Q?3u5i7MxHsBFF9UnZOVKO+yEsXLJGHSjSHOcqwQpwEbQdUvPB6SK3IU5y6aCE?=
 =?us-ascii?Q?TTvV/LIyrdblBKJCBJHAYw7me1LY4k22IGctpMsir1/n/GqJWxzJCi614ykB?=
 =?us-ascii?Q?RRZBRUc//aOEurpon5Iqlh+8s1RFTU1FLhivDtdSjdsPpbi2nzb/4B3FAqmL?=
 =?us-ascii?Q?J6gAdZ8QQi3vQlOcbyTjfMkS6Q+9elc4UCQAfv1FWcPs8LautSEOhG4cuncn?=
 =?us-ascii?Q?wKKFy8ef6iOSIrwKQ34wTxwubtxZoUxnpQJ6k/2KQC2tQx3GJSsY+MGjf9lB?=
 =?us-ascii?Q?ZvjKWO7Nf+y9qz+sQcJws3sllK6SMCozQk5v6/tmuJ+yh+mY6KgHc1j/0xdQ?=
 =?us-ascii?Q?GNJWjtoPCebngKqAGr5qkTludS+BaRrLBZ4Pl7oejSbSU0q1H2J+jK+b5H7U?=
 =?us-ascii?Q?Ay3duBjzaZgetkGKuL/7scOodfxkP/KX/LmQHRBda4AMTLyXFPBITY/FYR8l?=
 =?us-ascii?Q?tHegR3AdDyNcEMbHqMCVzUvRzZIz1KbVAMiGdKaJSx6OAvbaw7/gWFHH/BC0?=
 =?us-ascii?Q?jBB5LxfJ6qE6RErYZrCgnkNYU9GrpZ2c3KnsnbLhHjHe4nGsHOESlvfJjOmt?=
 =?us-ascii?Q?5iwCv4Qi7TBtaP6F0wDrrPrJfygJtJLaaiuT0M9KkX9hJLzDiQJ3Ilqxe7gm?=
 =?us-ascii?Q?1Gtd/A3X586wOfjzBrcNRVstN56/FK5CTcOsQwkkfYiQmmtgcm2fqL/rVcDo?=
 =?us-ascii?Q?5wzviyEfTuGjQuqQ8QmOVg8yNeOybXFMlRSm6bxI+y9XONoCDWkXIkEtHSO8?=
 =?us-ascii?Q?Es95teHnz2Bz3K7exPsqpbDRETg9nZ0xudnPTv+FdYOZlihgNcidoP+fmj4L?=
 =?us-ascii?Q?qZYTIi+hV6ocjDtulxM9rwTUB0g76JnbMesQISDGg6UhiY2pFSOd7lHFzC7z?=
 =?us-ascii?Q?DwcB7BJ2U+l4T6eB7qsOS5lWtytsTZFuY4r0UtAb6TdQ4bh3SdZhgcDk+soQ?=
 =?us-ascii?Q?dv0sqlhJz4M2Xz/hRMn7+auAKdfBcryqxkrqKj3E6Ga8bCHRHpcP4oUuZs/D?=
 =?us-ascii?Q?mpwKyjSDO94ZSHXUDlKLXUyp9PuvhN69j3DU1LiazqgWAWmzMrGvtmqUOTEa?=
 =?us-ascii?Q?n7YLV5S1ZVG7w4eRoGQiO1Rgsilbawoe7iJkuOdWYWLP+q8y0GsttoMmpGJF?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qjv+HqpZ+VhaDMwNnY9xvSKXgqtoEtreV1b6Avoq26AqB5HmDmbcaM0ttjhqi9IRxp3v1LBSyDIRTol6hM+IFBPhA6kVBtk/5BnUy9YAeir8jlV5mliNyr6CuU/SxKbZhEcdX8ayazAxxYzl0o8WBz80yfGrcY08M6RXCVEkA6+2RCLvbbnwl4UpjKuH2cja3JGtJSG/o4oX2sBk16OUCoreSh/3QhCbVHlK5G9kb3m+N+uf4yCU3EwqpNyJd9xU/dLtIUU1R+Pg/aCgCl00G+UDDOK4/X/PymIdsRV564UskSSwSF26ZPAUhLCe4Nt9VtoaCpzJc49peUndl/tA8IA9Ct/9DFhVM7r7dpm4UtthpbgXVeycoOLwpBtdKGnxlJEyAGopoQUkvg/uG2Adl2GdPEYK3jLyvBXCFkC4/B9Zd/MVh1USjpFIotgZOyYI7G0y0Rbhak0IV4ao6BJrk81YTiF4oEyVgtnTZ7C+uupMErhwu7U9kuLJnF4Je3xjDURePCIvZKKevC7MZ/0vZMqB0xLy9BeOplNOOQtLZEPlfFnCUPll4NhE94cOuYw8kb2BkbikmaeDLGNVh27Ny0hzgHO7EqWwJJnrh9DQbdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6108db-917c-4ca2-246c-08dcaaaefda8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 00:32:53.7276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HxJKeyBpW9LsoeAMn1i7RGALXaG+5cktwmWg2pZQafHO8oWDlH+FB56bOrjIB72X8ml3s+pS3juLXC/da5tYCvEZ4Fki9eXOZdMCgN/fSzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=760
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407230001
X-Proofpoint-GUID: V0ltFX6pl-cNLxhPMSTbbfBbWktUumiu
X-Proofpoint-ORIG-GUID: V0ltFX6pl-cNLxhPMSTbbfBbWktUumiu


Manivannan,

> UFS link is just put into hibern8 state during the 'freeze' process of
> the hibernation. Afterwards, the system may get powered down. But that
> doesn't matter during wakeup. Because during wakeup from hibernation,
> UFS link is again put into hibern8 state by the restore kernel and
> then the control is handed over to the to image kernel.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
