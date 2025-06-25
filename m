Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F275D28E0F;
	Wed, 25 Jun 2025 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814270; cv=fail; b=IWCyuXfuJmL7BNrsmQ5RtDsGic5Fq5P3/JlqExnDLvvlkKM7bsjT8aC/7IbNO+lNgL7OSBuHGffT3gy23uzcjH0KQINcN+6htMHzf4h8yus1nB+6RupZ4gprzsMcpnP3yMnZR49C+I9LuUbYHPcD/XiJtL4RNrLtG+54uXfUT70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814270; c=relaxed/simple;
	bh=Mhg3L9TqPOr0mDrQTyVZPWBkTimredd1QtkURhccRNc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IkeDjY7t4Yw+kzE0Z8Mv29uutHfOJtIEKvwbvHH4DZVMsdUBRN0/sAWNUTi9CSkOJiLTNl2ELx2CCtSQZD5IUD1MpU6ipJncLGNHqmh3yCRvxRIuYsUrsqXmt+XukzXmz/mWcf5YOiE8ONc3hsePIEpKVqo7acx7eQoU+aMsYKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F5w9XUa/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mh3PrmjS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F5w9XUa/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mh3PrmjS"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMipXE012891;
	Wed, 25 Jun 2025 01:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sh2zoEgH06YtKlNybe
	3uMxPJCllBOHtvNiHZQUXx6Xw=; b=F5w9XUa/GvRAuaasm+Za1pLHhj3Bib653C
	XCH/Gzy2hLatTolGGwX6wQiskzFuELE2KCYHnxv9c/UJ4JqTgjtoWQq/dN1hNEMe
	IdzNAUfFEzMVZ+CZjeIOLQv4CV/QQqtJt0U/2JP6sLVkSrexhe+cqPwkJCTvhTWK
	URqT3ETGGVlD8tku1Lntid//bIdMA+h9ZZFdr2BKmP7OmcQbuCByXIXz2i11yf15
	zTTLTxZuBJNMvieN0ZG71TPFH+6A7fIU6g1FZ2px7Idrqp7FW6swghkzzEe6zjfM
	MGP5OQr2Fi2HT3e7IxApp/CUk+0YalgYddxYPrMGbnB0QjuQtl7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egumnb3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:17:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55ON72eO026087;
	Wed, 25 Jun 2025 01:17:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehvww4ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:17:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cx0PxV43ePMmzbYTWfHnUze5xE97KV1vuhkERBTNpsF9zi41z6/1lLLtoSm4D24vjLUmTWWos+GAjh7cJXBZiPLms9M1spDoM8CS2dYSwYjNnGWJRiOvwKr6/A0DNOWyrFqHATogm3AwVfdhrUKrXv0PfPbLPFRlqxMDU3WA5Nfs0CCURukp5IX59QiZb9203fBeiMgEnraG+I4WfDjRsVe4XHbhCesm6x0rORu054dSDZlycgzgIJkVyKCHrYZtjWQlUNmjHKMpQNoZeQIg2ZPMjBOu2Rs/QeDjjPF6jBhXS15aLE4tYUblxC0K21YVfhs3OmEmbI9E0p88A5DCVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh2zoEgH06YtKlNybe3uMxPJCllBOHtvNiHZQUXx6Xw=;
 b=Vvor6At73fnHMsrG8oQxpwPbl7l6ycgr8h7rdDOmtm/YVxrsrbbAdkJrFtAUcIWidTnlTg/RZ+Is9cuxq1fjlWv/pHWL7ezuzQ6lUdizeK0BsuF5tQRZevLoEaf7kaBEmN4lzNjcD+CBXnG7xjX2W/HNNNne/2/m3+CyW9mn5TWBT2EdvKP30OSgjKtJ97uG2XeSDQ8MU797fdbrwaZGYDnwK3EDnOOi0y3icK0hBK1XOOED0JzKDVD7iIglTfDEM+XOxDKneHYSb9Nijudvz8sZypiGs5iAL1BZdZ3bxxKE/CC0nchzvuhjxE7Nk1xmKsC2IwTJ85WRDZqZh9YJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh2zoEgH06YtKlNybe3uMxPJCllBOHtvNiHZQUXx6Xw=;
 b=mh3PrmjSRvn1d/2K29qU+JfI22gpUQbYOTy1dzaitBwkzoJ9eh2NFZdroYE/LdBpQBakCIfn+pQJnwMi6FVBXH4vB1IB7ZnP5e+mYuwqgUZJHQPCs61VufozLMB+49+G8z04+VTBudfiGuuG3x01VFmSQm/AUPD6WoUEGZES4s0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4746.namprd10.prod.outlook.com (2603:10b6:806:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 01:17:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 01:17:44 +0000
To: mrigendrachaubey <mrigendra.chaubey@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: scsi_devinfo: remove redundant 'found'
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250622055709.7893-1-mrigendra.chaubey@gmail.com>
	(mrigendrachaubey's message of "Sun, 22 Jun 2025 11:27:09 +0530")
Organization: Oracle Corporation
Message-ID: <yq1h604oc0n.fsf@ca-mkp.ca.oracle.com>
References: <20250622055709.7893-1-mrigendra.chaubey@gmail.com>
Date: Tue, 24 Jun 2025 21:17:41 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:217::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: cbbd80c6-fc83-4bd4-9ea6-08ddb3861674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NohtQBOJMqFhhAoSBl6lv0rybwWYmme8ncTy69X8jw7yNZJUhOoyyiLxlW9i?=
 =?us-ascii?Q?hF4WGNh/tAWtpADjYnd2MkN/YZOXdPFKWPI8A4yguBqcc0IFBqb6vZWOKtaR?=
 =?us-ascii?Q?vztGzNlqCe9012+599jlGzfiZxEtsh2XPn6//eRlx+tCqgD8b7cErMU7D41A?=
 =?us-ascii?Q?mzqzYHRl5wFYBmLZDMDDGAL6DOAtRYAhcfis2JKUrLdY5tSlfpKWZh0m37R9?=
 =?us-ascii?Q?yseWMeWIOUKgD8u7DfT8/wH49duw4+wTDKdFEF6GZTqXMLTxqKLa07BTLPgd?=
 =?us-ascii?Q?zn0AeLfIwETm8+r2h7kVKmBsoYXov3rNDlRqcKq5jM8gJSOy76ML626zIrdq?=
 =?us-ascii?Q?wVBdkPtP8G7XGhkSlcvaZNOK9O5uhXI8kcQ8HA9Ng25Q5c1CEIO7zlC5McAu?=
 =?us-ascii?Q?dqM+6SX8vyPBr0lgyRypXGrbZKnNsd/7+8N8ustIpHpwaGjanHt2W/qVHKGG?=
 =?us-ascii?Q?bJfpT1rHtuaGLE1o2aT5Gy5/bwHHomeS+1GanSsBwiOyt46ccvuQpQlS+Iqg?=
 =?us-ascii?Q?0nsi30ErCuJSkQxJ0goYxEjnoQwMU+hlnYOE3ON3zFR8pV5i1jjbDNITYr4z?=
 =?us-ascii?Q?r6dqXCHNa6PMC1U75zc0EnfSSvRwJQsouJKT4mk6/6PlX4cbweHTlC8ZzMgJ?=
 =?us-ascii?Q?tcZ/VMSYR1dw/rtt0DkLSZczAB7XcOo7EAC0FqMsboSws7HQtsUkgwJx01RP?=
 =?us-ascii?Q?CD9kwmaj1PYpY/nvvR1HmclvbR+TZ5STrCXODysgNA13W6S0vj1R/41sR+w1?=
 =?us-ascii?Q?esORpF/752cqfoqmTGgeGPshej1iyxYa82gh8oWjCeWczMfJD/pr4ICqCwqt?=
 =?us-ascii?Q?FstmHNu78uX4HREIeQTZUoiTY7BSHtLF4Hl8Tf78vqiSToKWPu65vewtXa1Z?=
 =?us-ascii?Q?M07QxztiVE+lvhMFDj3G3pswUIUK+S/DgVdsIJMbihvZG5p0uxF9U3u4roBH?=
 =?us-ascii?Q?weBzAFNdc3enF/d8eK1QBiEg6CZz1qpyD+aIosLYWPgMVy2pWX3lQHGLPnlv?=
 =?us-ascii?Q?/UdBaX68VMeyQSwLqcPHdBG8mxNFnETciffVl60KS8g/fz85AoexoObc0EUS?=
 =?us-ascii?Q?lBqoab+XCWc7xPAwG6Oxdu2B3mNUvFCqgKFt5TVllQg+3Z2slvlPS8mRWkzO?=
 =?us-ascii?Q?yftIq7FG1vSNwePWtlj3fXt0bBFpQ4m6yoTlmSfUctVAfnbyWVPYlbUXjawY?=
 =?us-ascii?Q?skpRyw5BUVjkt7wuRvrQO/K6RGGtYCYn17wAvZEHhAYOoPUw5dmS860DfTOu?=
 =?us-ascii?Q?RxLBd0dEkARJk19xwvB/bGE+dk2vQhZWCyP8DZmZq358q+RRlRAudz8qEBNj?=
 =?us-ascii?Q?LS03j0rZt4W/RzBUzFjyheVL0miP6VIIWY9NPOObcmnnuNdP1dudESWLwAWi?=
 =?us-ascii?Q?/wlPnP/iCiqrCVX+awcezuZfe8KTMsKFvuP6QocBQgrKJ62b9eX8ThXl3/Ww?=
 =?us-ascii?Q?AAOmiGEc1KE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ALXrhSNKD4jvBmp7HUAzkewrhNKIuztt0B56o7lyh80Dr/+FVNgtAdlxJJAQ?=
 =?us-ascii?Q?cwgnjYauI4uzbRHQXXr7trTVojENrPerELsfmUMjAiUY5WZrGbi6wIHUvpqq?=
 =?us-ascii?Q?Ibo+9t0CBqevhILPDdvYILZ/KrT+fuVBqn7JPTcYgClyl/AhSqRfx0MtrCqk?=
 =?us-ascii?Q?Cm/Rto4ChKsxuMtKAWMjkO03RJAfc8OpyvqxGSDM2ECmcuhZmJ/bMQZTSmfQ?=
 =?us-ascii?Q?m1495lPJd8h/q2DJ2ngINp89V6AHru2rIXsdbUbHs8Xgge/I/3K+Qais/ixg?=
 =?us-ascii?Q?sGz9URjl5Ti0RgIoyzQpQfVcZezCyVbZOH/yOj5KRtxVwZ3CuYqMKoneJmrW?=
 =?us-ascii?Q?FKV8GOJDPu3GdPE6BdMbTfwx3Z5NfionTIw0oFUgeSvwzb1GZre3U/F1F/AY?=
 =?us-ascii?Q?PCO8R46hXk4w4PBC3zcripfu4j+9sGvLR2kNRd8XHUoIAbn/Ab437D79YTMF?=
 =?us-ascii?Q?6vG2m4mbEuEFYUc9kJxzoTCLmzq///PzDFsTVl0Q2ZlYJ0o41gDzcyrUFf6+?=
 =?us-ascii?Q?bZBTi1QugZfyvFFxCRlkKfzzYq+4MXZKTly+GanJDNWVbMZm7h8T1cVIRT/7?=
 =?us-ascii?Q?oJGbnhSqO1MsvoWsfiNmvD2JjUPo7a+3G0oSH2eMQK4o4FCnqwiVe0aEce+w?=
 =?us-ascii?Q?g6K5BF74NtV4JvGRYlHTE66RU8MrUkdqn4fexTnAvLEi/bG/EelB+oX0LcDf?=
 =?us-ascii?Q?cs+Ijj9TFDy42WYFvULA1WfmhBcZeHEPjrIo55smHNWEVe9Uu7uACfJXG3vw?=
 =?us-ascii?Q?INQz6Ok27NXEVBrqzRVpQ6H2Zy6BgQzge+ydklRsBNR++WDw2WC0sOgSD+2c?=
 =?us-ascii?Q?RU8q0uHYKtpccfhld6ibaCqDE+w0A7vpZzMH1+wHg9XHT33vAhrR5RZKWXTL?=
 =?us-ascii?Q?2tsfP1lbk0NyAedsfoYW5VciYt/0DbpOL39/PYZiSkDDFBNdyy1yAF2md5cf?=
 =?us-ascii?Q?qt2TduwsHjdaEGmmS5OK38Kv12Mw7HGIPQBRFDtEQ5c5TSNwBPAGzJFk1jbE?=
 =?us-ascii?Q?UHDOrPmc33bHEGvvGySZvazmPt2LNqvTdm+ImMU1mwAPnWiQUxrvxWqzLMJP?=
 =?us-ascii?Q?llMxCRBYq8QfA7aXB2IVQt9W4ifG3z68wA5tnpnX88Ndl6pEnZm1qVyBouJ+?=
 =?us-ascii?Q?3xfuNkhbL/YZMpFGX5gWENBjyhDGpqArnmyzyUpWWytohEpR+68R1EgL3V6i?=
 =?us-ascii?Q?nQUv5VHMb+pKxLjHouRxki6rgPjGnoHE6cpAL97EKB+EGzV7WGHj+qkQfuSY?=
 =?us-ascii?Q?EMn45fYkmEOQPc2PKlIgWC6pUfNGTa6Siw1rcPaP8gICmZzVzh/L8VhWxAFb?=
 =?us-ascii?Q?Tp3JLCWKJdtrkDGWlqoNzGCtjBA+45MUOJzZnZk8p+gJeTzrfVA2IIb+GKWM?=
 =?us-ascii?Q?rPfMWmJFfeWvoE7ChEBm0FC6/4BRUe7y8FIAFNCGL8UTg8omQ9vKJMz/1EBs?=
 =?us-ascii?Q?eBoa5k7Iz//XEMMXWngpx+NinmcyH5eJIMDE2Yjd4y0TBCkU0v85eUCke0j+?=
 =?us-ascii?Q?GwxzZbOU84KD/NDGWO0ejGUI8TimWP7lGHxFLZPKecZtFUGFo0Dw+lprXH4P?=
 =?us-ascii?Q?D50iVRa9lpAnB+JThLoP1gx1Xn4Qv8mtr/RvOc2jhfzz1h3KYaAOD1vb+pQH?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bjKLDjgp1XkO20KdyiCGqiN+H4oKwrsMdafI8T8FvzHRy7A9BwusgrnqnZX3DB5xj1j66wJ3i9e6X9IUIRQkWEq1WaBMjUFRej6iZOQpFnQJbFCAT5DJpu7Fmv3GgPvgz0pXzIGPhJhelrBOqNjn2S+2qxXOFz0nYCglVVeqNR+nBkFLr0/abQ5MJdkEKiwQbmEJOofbzsl6IzTAzw4STxqTtxNweqPTRWzx92LY954y+YbpPWFGSeXxM6Z4U/jcEjC5uf+UaR6DlTqtz+V3huRIh+uwebaK9hvUrxFQ6HNeSNyXjN4DcltMN8iO3dTykTC1vcO/lruI7q6jhG//MB9eydemOke5XMmJotPxXhl1mWR94bZz1vBFCyohges4hH3DX98A3GKEQeFzlCRoCQT2mhUY2gkeUcWsIIsdx7ewtoqVRJIudIAaqITtOZiMfWPXtugMxDDzE7y6KYRX2vptWFOtScCqK9EZNq2tPXSs/ABNYHvbaVMQQodY94X8KgJPiAQlMa05IWipPYFaiRwzQZlTmUcqsYsGxA+DXKzFn4fhgzF8KRoTAdJmm+AiaLbBvcIPv3oZogD2zbFsxP5HiGetzIZoGFtngodelGQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbbd80c6-fc83-4bd4-9ea6-08ddb3861674
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:17:44.3751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5qcj/sHCZQo3921x0NegTYYs8l7/ePWjTpOXCbHLf53QE46eJfVk0DIsGvRUtjk9xVPT/thNw+enUFZIpcz3lb+I/TnbZbw1rsb6lhlKdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=815
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506250008
X-Proofpoint-ORIG-GUID: FuyezOgs08lQ6JCUHpOeWWxA-UkgJrdJ
X-Proofpoint-GUID: FuyezOgs08lQ6JCUHpOeWWxA-UkgJrdJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAwOCBTYWx0ZWRfXwW3nYRh0VrLL rL0h3aVGW0S0RKgGEWGL2x6iB7YgrJVzeQb36o1pB7XxrPyocZYtsiFTOzoc1KhUqqsm9/Ik+Pg 0ZQkrwYMJjQPrS+Pd9XO9EhbUq5mTsN6Yy+U7vXTuUW/PzLH3Xzs44qifEapPSHBB4tgQMxeOEi
 Xa/rkilsRbywJQuDwmdIXDMvptxRvseV+o+Wjyhdk6q1SvF2Md4VZTAV1rDy9mh/m+fyOWDHPzO vAabrD7IrOqgWyFm10U5q+c7aWXy18CTpUq+2dWtWlk8dxg+IPg+s1+4XusZHNwzv2taJBbP5py BORhugD+mfRTYwpDaWEUqeHA4lBJ2GUX3LAsFBPaNi6mZyzeLIUP3J41pl7b6uPKqD1/yBrQujU
 ij/cmb6XF8dj3L4OLCwXpiQihIkqlr7juDU9nCY375tc5ruFlVS3VBE3SZGv9n2qm0UkCCUw
X-Authority-Analysis: v=2.4 cv=S5rZwJsP c=1 sm=1 tr=0 ts=685b4e3b b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:14714


> Remove the unnecessary 'found' flag in scsi_devinfo_lookup_by_key().
> The loop can return the matching entry directly when found, and fall
> through to return ERR_PTR(-EINVAL) otherwise.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
