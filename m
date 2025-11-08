Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606A1448E0;
	Sat,  8 Nov 2025 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762623763; cv=fail; b=c4uocHrJdBRaclJBGLij21OQq74g0ZHzo9DMTIZTFvG5/iq+D1fHmz9nhn8KWhVKjNSPFsYzwyRNQnw5FvAd3E0g/Wl58FFZIWvhv1b1uDiFdYFCE4KfDfpzpLB6uP2HRL/VCyDZSM1C5Qde+1hVKPsS3dGN+nGeKbLkArKA0ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762623763; c=relaxed/simple;
	bh=7X54LKknjPJuemji/2RUfL/s37s8uqBEHhEBBFURqyA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KTrajX6xESC2Z1PFMDECavBbnPMtO50+W+W1Po+29lOjrdXVnbfcMnlsjeyBHg0vHHZoMYNCaMOdzvGpEKsCYYbkn7Qmk3fGNYZNTnmEdrDVL+5ecjstOZoHGPMhVsVKVmcGwi+b1XHJXK1zMUmQbh7mhNvTaHn2q75W3joBhyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hh+dA2pR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yNpSHzkK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hh+dA2pR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yNpSHzkK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8Fs9s9008477;
	Sat, 8 Nov 2025 17:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XjliyfJ0ZNFVdV+kLQ
	esPUmbowgsMEfat2ZHNzOiaQE=; b=hh+dA2pRvPZKCgPCzVMyQ3rPGNvOlVZlwb
	A8KpIfOANJhfxofvfXa7jq+IOiSM/L3+M/klaeGFzV2q4MgZCDRPI9AlzgJVphpH
	oP8cH8ZrBi54DCa0tuQ9VH+kVILnaf5/z790H28jOXJIHTD1uXkGAn6nigu1bEjE
	rPXuTtUrrxEZhkShqgZjGjlKfwBpZR/DKR0wtpCvvILQ0E8WtIiQ4r4OCOTTognQ
	q/656uasDvmFWqd88JNZqdxgio4Zqp9TBeFOQgEEpO7WxQnf++/7Jld1Xrnfsw9y
	pjHQ8FG2gc2oSjyjUiqVh/A7+RyO3TQBhfKCZnKlBKTK82i+CPzQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9vs8gpmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:42:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GjnQt007578;
	Sat, 8 Nov 2025 17:42:29 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va771yq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:42:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q/UdDiES9h+T8yxUcCr8PozR9P7QXUT9u8bP+iZYmbLO8UgxLw+UgIoEbkjOmEVvYl55BlytGPfSPx9iHw475FD5lxph1G/xUWfQ6UodizT4jGw2T7pAknvwUDNhdnF7SZ4XD8kMFkgSo+QkLWe8mrD4miqXVPXjQa4sFKJYkjiN9XPNa+b8IE3HshjbRsFqD79l+t6WijwxDiKl8KkN7mBsB9t3qBimoRsicJNK7yM8EEL5KBp1a5JNULUp6lJXiHHeclfQaBttrymcJ1IeqJXHdzKfyzUnmV0c1ovxFhg6X1hrddUj1nRFzhccNoDAcJc70X04ZEWoBANY+2VEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjliyfJ0ZNFVdV+kLQesPUmbowgsMEfat2ZHNzOiaQE=;
 b=tHoRFm/dnJmSVIO8AyZoTER3v6uNyQg8g4hqjfE9cH7abALrW4s5QVlJMdurbCyPkMQbRHUEuXunTvCyhFozzkhp+ZB5gIVYaLPiRyovwU/hTNcNDXWr4Pzv19KnxnSXt//aMy6BJE+xT6WSnNIxiVBjVC/d744JI7Hgk8mZ6KLOgG7un2nFA/zv+Yab+QBzAXqPyMH5NSgMY2u7fElLWz1biHyrjrYQOFifIFhfOMT5fr4kYCm43E4aWu2KnDsypaVVhRJcii0wkUDieahMFgK3FUxP++/XIPwfJJ6w57gISNB5w7Qv32zY5+yuA7ys9ubrqC5ZNyIRN5IF790g2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjliyfJ0ZNFVdV+kLQesPUmbowgsMEfat2ZHNzOiaQE=;
 b=yNpSHzkKOdzdqdNerRsgof1hSP7gHsgx70zdfFsS5N6At7VBy2kUtRdnCXrW3LXPJVb6II8D9ydbRKzZ0Cfim3xDrXXMn0ufFy9b98JvO/D/K6m1qRoMhNin0wW9qFptxcCfn0S9xTQN70jVrTaJ+zIQk6SP6VkLLkWnF1Mo8XY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.10; Sat, 8 Nov
 2025 17:42:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:42:25 +0000
To: Bo Liu <liubo03@inspur.com>
Cc: <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: Fix double word in comments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251029072037.17862-1-liubo03@inspur.com> (Bo Liu's message of
	"Wed, 29 Oct 2025 15:20:37 +0800")
Organization: Oracle Corporation
Message-ID: <yq1o6pcifzu.fsf@ca-mkp.ca.oracle.com>
References: <20251029072037.17862-1-liubo03@inspur.com>
Date: Sat, 08 Nov 2025 12:42:23 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0349.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: b33acfb5-abbc-48e8-5d1d-08de1eee2e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9Rmad0p30PRDV9hnXHg18mvXvSS2nwat18WzAPNUfrYwwOccfiU8zLGojKV3?=
 =?us-ascii?Q?CRGX9IRkEL/4KNJPPoBJLLes+nHv0ZarmzPHD9zgEWzVnpBe00tta7PMC++f?=
 =?us-ascii?Q?hwKt84vjmj+eBvMaW3eMZZHdm0v2VbzBYuF4s6iY+EOO0J1hj0/Rm9GsrhjU?=
 =?us-ascii?Q?V/t7xTFcDN0JxfRlCBzcUroMpKmER5rE93BnyM5004YBmSTWzmFzmy5LPR7a?=
 =?us-ascii?Q?40qgoBhcQkM/JHLgksLXRq23JjmWc9HjrsIfAcytyfSEkH+/scJQiHyqtRAC?=
 =?us-ascii?Q?AWjlqH+Z+MD2c0Mz1aMrq8rChzEtm4L0ClmxDXQgfyWP7MppgZ4+DtYEvncS?=
 =?us-ascii?Q?Glmqh4J0q6ZcVLbboxINuTuGxawt0kz/jRnDa/OB+WekmtOyTta4aIJvcob0?=
 =?us-ascii?Q?hTi7fJjrlNA5dYZJVrn2dBFtlYKrM/WUtPmiRhFnd8zNQuI/XwvMq2ed9oUX?=
 =?us-ascii?Q?Q+I/izXZj0XTilQFbJiZq+Fq+znNGe/u/FfbbwK1dM2rQbdg7nDs2zx+zCNO?=
 =?us-ascii?Q?GAVVHEcJIJx+MAMIvjELLKVISJaCX0yE/tFVPxR4EvBbRjAlQSBOYw06teqJ?=
 =?us-ascii?Q?sdSu5niL62tH7s4fphyIiIuoDLX0qpRV1emAJaZwYm/d1VZOkjxo37PABwcs?=
 =?us-ascii?Q?gwvn2tLZO6WTJ+n4nQyCWIJuUeHi6KuB1EdphOZtxCeHU4cl3FXzPhvzJxxP?=
 =?us-ascii?Q?dFsPdYPMEUoDuo8uoZ8WPPoDnjZg2ngIeuGySKPTJdOevHk0E/TTSstHoFio?=
 =?us-ascii?Q?KOolC4wUy4Ou/ucuLL7wzKNLY/GXt689y3lFpgsFxLw1z60mxOE+qJPp+Qe5?=
 =?us-ascii?Q?xBvnxASc8SpM4Gbbr2nhDN7Q1V0il0tUxnzstb7kHE2YXWssjm04Aj0Hn2iw?=
 =?us-ascii?Q?mOT+F2L0WjfYs5BJ92SqmqbMspg40vpAnzEqtxVSCrES6G3DdsgEAXFTsqEJ?=
 =?us-ascii?Q?yuaBDeFja63SN+YVCxB5YKjuJOI9Fbaud5MavjkDulTHdbVso22mbb6D3/zA?=
 =?us-ascii?Q?gMa+t7Uwyz4WzDIy39MMEnwO0vBUJO2mIinQWXBcP7yH6yoUOt/NlnDeOaKr?=
 =?us-ascii?Q?8VhTwTRzlWIVwVDLcZZXse7PWoojOGo03H+HbVdjyXIUBxK1alDXBZFXUNe8?=
 =?us-ascii?Q?58I08XHitWdEKovZ+X9jQLmCbS8tJPHF0MhEIp6ziSui62qngLiXgyMtr+96?=
 =?us-ascii?Q?S73f9HGnJUrcYDoWUE1uj6TQxr3rPwn61lkDoFe1N1fgV3vdcXMEIBJqzpdj?=
 =?us-ascii?Q?dE/msPN4Zua71gtR6UATj1qULlXi9d0drPDiWc+LrVm0i+C6CBBUPmBwogPe?=
 =?us-ascii?Q?aso9p5yusnYDCvvpKrgCi3jqWGvfP9TT9Q57X1OJobDix0Xz1M9ZLMLsBqzC?=
 =?us-ascii?Q?nEXMCRSRyikoCuBT2fXDUGSQTtNZ38nRky60TNnDEehOH6x9AKsYkE+6ft7W?=
 =?us-ascii?Q?JsUjusON+jFbV9jz4Ik490yf8uDgdopb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2cpqyAwn5rQXuo/Q1tIV8uNkaoMqn9AgHpLa8WJb+G0Io1cZ2CJByG4Eczot?=
 =?us-ascii?Q?93kuLqefj0panIjcwBZq3+26BamRPt3Kh87LZd7BVVwC4RNDL9xvBTWmHe6K?=
 =?us-ascii?Q?J/M5QrOaoaV24X9TbVxiRfZURfV6uTVhXKf2wh74/DduyRr1m1+srG/O2gL+?=
 =?us-ascii?Q?vArA2tdgdrUcgDnc+LAvenmGhG5wjxpzuI4M99IfyHeVVxQVQWdR9LYsnsQ1?=
 =?us-ascii?Q?aKjOr2R1T8SlU3wwmeRsaUsyqXyjQa1O22ZR2E0kGGnRc5PXg2NWyBTNSzsq?=
 =?us-ascii?Q?gl1xLgYWDt1+bVk7Ce5WPzdNCj7DMdAej3y28kU2Y56CtIXNRl52Wa/coMYT?=
 =?us-ascii?Q?KC0VxvA1Lshsx79oywACtNK+O44gYCnO6pDicZgnV7zkUxgLqDD2FoeHtnr3?=
 =?us-ascii?Q?Vgi1vL0ask/MuVkxs66Zq5EQ//mU8mnjRqveEjYYZBjea2+FKDiAlg0id/i6?=
 =?us-ascii?Q?PuZF4jWK1/r+qY7GaWCxTAFl7FkidYJSl/RYyIO2NGafqHTe3UIQY9wzF2mQ?=
 =?us-ascii?Q?A/zUmEagXlUGrUTMK8m6wGZVk3cIN2aqOBFHaWBrg9knqcLWXg8VNAivef/m?=
 =?us-ascii?Q?eUqlUK+5PIdG9zExom1gsU2KHOXqvAuEXONEY6cqGKy3ym8bwFD5XvAMb+Iu?=
 =?us-ascii?Q?qoAOVsqYYOYLTwbz3imFakpY45ULTIA9tr9TsNJ6yx2OcKcfbDEivHaux1r4?=
 =?us-ascii?Q?2Ac2DHQTpRxDyIfsaBbF59m0oPEql8hZH90t9opfAOeSM8rMM3zC6qE3YUtt?=
 =?us-ascii?Q?MVqhdhvipIUPza5J3lh2aqLbTEhfqs+yhrdOWg8Xf/98QNKO5UcX44jy2Qqj?=
 =?us-ascii?Q?qHKdu617Ur0u9sgLnpQPWz7S/H2AsKXaSXzsg4T0ubjCTXd0/X9NG51b9Bcj?=
 =?us-ascii?Q?5q/C0zy5THZD4VX0SKNUs8gknUwniOZbJbUhZzleXRdozoyRQC7RavFYb+Sv?=
 =?us-ascii?Q?2/BZaNyJ+xB0TZXkb5wFSK48etAjcUv01qtdO7VmFaOY6/g3tZyvzN5ZuEpq?=
 =?us-ascii?Q?6aEKsbe6cGWTvEY8LPxHx9oDryDagmPwDSSGpxA+B5tmVcDnpOkSM3bjisqC?=
 =?us-ascii?Q?mGbIvpSd0E0dSdm0bAaEX7YoM/WGY9SusvB7s1pqZMmYQXma1yG60ujn8oRg?=
 =?us-ascii?Q?JulQw3lS3DanO9FnNLo2pWPijIZiX8PQPce6m/MoS+8VMl0Rtmy/++DSosyq?=
 =?us-ascii?Q?1iWB5By2iVxg2eVqIND8xTtMBTN4DrLmHSIxE15gO1cR9puGnvd8iSV6xQ8o?=
 =?us-ascii?Q?O3UPb8b+jbm+iEztiDPahzTQ0pPvE7vdZE4betO4HDY3eNwDk2m5gaGYESpK?=
 =?us-ascii?Q?TpuSeV/wi3ZedvaBs9URf6Cv4+5ufNua7SUnKCHpwnt8E0pA+cGhGNaVEPQB?=
 =?us-ascii?Q?Af7WgT88hv/RYsGz2FjQiMZYgpHk/PAELrYzBCUgXu1gNP8Dz8OEig3guhlP?=
 =?us-ascii?Q?36gGJaORtLqJUYzpPeXwgcPjawj1Qr2Ez3TixFuCuOqtQ90Tx8BwGELtLC6p?=
 =?us-ascii?Q?vP3W1Qdnr9fmYbxDn8zOba+7Ck8+HoFKi8Quj07gKxSVClDDVlCtG28trpAj?=
 =?us-ascii?Q?OGJvjRcaVjxZ9aPmo/Dy3CpptenJwTz6SRgqE/UjLTHMgoNwxY4v5Z7YvgT7?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W/qpi00KOiYmVAbiQFijtvemZvbDhBWY+Cl+uyR9fEeWdx17pnb4krD/1uBg2HhAGqI/yjW7HQMkVumzF+LzlkVn1pH6TF+NI/HA5QC4kE72u/akK/NR9j4XEN1mjXhfxdWqSGGRzCVeKiR6L51CQR7jB5PupvjffMLr20pfPm89bweUrTLRCbCW0X/H/zi64iaT7B7pWPFcHT3pbhr1JuA2iYWtO2/PX7ebDPY2rQYvoeSNxt94MR9gZu6AXgpvUpr7Ye/lYKGSLK0sronpqLmQwkJfwwugAMJZtw8oTFnGKEJrFE4SLFfdtBpCaTasYxoKVBuTHdZ9qJfiildbXiyj86ngu/yfWZ2BxKwRMe0VbIXtTuDHC6MWA6K7w2TVXuRD2L37GR45zBe46sAmghiG5ZzW/mO0XQcpswNY+HM8HdJguWegBEdb3UmhkUjqOFu2LbI7nL3uR0WwJEII7AIE1r5Yvixx07nVcLtS71zcKRBtL7bl2wiBZxACLin4Je3p/mZ4Fm8LzZ6HqPqlOShp1/iRVIBTP64RhFyeJ7UlPHw1GXWSX64se2riSNm9ObKdzotNpmDhBNzQnymze/cpqWG+6/n6RpR0QnPCZVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33acfb5-abbc-48e8-5d1d-08de1eee2e07
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:42:25.8346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1Nvm9gC3WDGZ0m/YWxSZOGMnfWcF9zzMGPq6O0T2xDxrihCepr4YfygCi2HPz2bE1uBpIh0m/zattQBlQHfzkwszA1QgXXsOHEkV2EB/oA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=576 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxNiBTYWx0ZWRfX652LJqKCpVZ+
 xU5PCcrhn3nkORZblFpOpTSscHnasXV9LKkiLfS6lXKuryfpYapIT8kwwC2hoE5eIzgyH8371uw
 XdjXHizJsap3TrBjiBUFPwivNztAYYJ1T23xFzYXUOJzTj9lflcQ2u8YgWAkJ83Yd0jZu3dvRMO
 72z5hs08MeBJfH/O6zqNVpEaUwC0Rk0WocL/VPpNCAlvCZUjTe7loFmgmy6je0zpSsJX3co9Yt/
 Bs/zy7olTPQ70z9Racv0vdy3EsaM/jvnj69XKcfx/MUu8CYAgwnkPPgumHC0spMzoJP1nxrkjBj
 oOyd/9kz+XHw2bzltb7XnYlm6ZJBrbYfjL8SWUGhnzbg/2FydBHXGWt3eHNdc2AxbNRZoIK9N86
 lg+pjmuyklq43DxXlfHghvZOs8o4hw==
X-Proofpoint-ORIG-GUID: Gb3ruqfHzdZjPfNZN9KZ_kE2h8g6mKfi
X-Proofpoint-GUID: Gb3ruqfHzdZjPfNZN9KZ_kE2h8g6mKfi
X-Authority-Analysis: v=2.4 cv=eYgwvrEH c=1 sm=1 tr=0 ts=690f8106 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=F_93P0QhAAAA:8
 a=b1vsr8rPoyLlMrEdYZ8A:9 a=v2fne3mUlQEKA94IZ0Od:22 a=cPQSjfK2_nFv0Q5t_7PE:22


Bo,

> Remove the repeated word "the" in comments.
>
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/scsi/bfa/bfa_fcs_rport.c        | 2 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c           | 2 +-
>  drivers/scsi/isci/host.h                | 2 +-
>  drivers/scsi/isci/remote_device.h       | 2 +-
>  drivers/scsi/isci/remote_node_context.h | 2 +-
>  drivers/scsi/isci/task.c                | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)

One patch per driver, please.

However, in general we only aim to fix user-visible text (i.e. printk()
messages). Comment typos and coding style patches are only merged if the
driver maintainer explicitly acks them.

-- 
Martin K. Petersen
