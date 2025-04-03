Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCCC2E3386;
	Thu,  3 Apr 2025 14:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743689201; cv=fail; b=idl+forQTcD+Q4R/wQe6kl/AnOUs/0qXqw47mpa3LzK87bMTNM1yeg0l5XKUpW7lC6lR+CPXVAYnXmzZvLgqLCJnRyerly8gPHXwTBVHddQheUGOaNwhQlUBLMMA0XUMDNHRzeAS7a0MQsHY0aM/RpQ+luFlK8CN8un+bfnrytk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743689201; c=relaxed/simple;
	bh=xq2UHjPaw0YBfpYNtj8McypWualEea+9Hsmd9DlUn70=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iUG68zt+5TSP3gtaRJDWApUwFCkM09b4p3DbMy+Jt7dZHpissR2wwTVKWW23mSFhAWDuddPhbtJlee9l7k7xOBL9zQ3MpFoo0lrxYybYQR+lvZtJklbpg9kMYL7wlcg+2c0mUh6gz56IGSeWaxayZ4J0cgZQLS5PSKkz23OguB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eX1J3Rgi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZBwBx5PH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eX1J3Rgi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZBwBx5PH"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHlqb022363;
	Thu, 3 Apr 2025 14:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ckwJQoRbymQPxxAe+u
	Ymcr19TdsYJo6rcVjLC6YlI9g=; b=eX1J3Rgik9eXl63SRhxoTgrY+cOY/9pp2e
	IXM47rzs4eeGv7ktHyhwJcHqVducQ55B6tn57zs74xUdj5GLpjEjQBDtLWphMJr1
	HqM4SsOs7yepwiW6G9EnMrDWk3tyFSp/+XkrK+id6x4La2uXeRqhKEMfYCXA2j0f
	1kJCaOrZzSjyCRQDExbUBJp8lPfAb8Uaalf/sQDzmcpnuc07qBSzKGBWrqHym/s6
	PQmYx5vrYUhei4gAsqB/r6i7MCuk1ZozS2lvd4iIx4kmD7iQ4P1dIWThNd5r7oYg
	1Fna5OLf6tHwq6LWx79v8n5jSH9R2oPIxyRzqBfADMET7oOI6zQw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8wcnd8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:06:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533DIaiQ010864;
	Thu, 3 Apr 2025 14:06:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ajecn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:06:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RypmcFnlj6xm57p00AWgA6dvj0qbpg6vXVYiftAkBC9a7RYLM4di22mmmJDMjxX/fi4RvPLTusas4BLcKnoV25CHdZK6yzTp/UEqIjFoCxCop2Sg9zjHVL/Zak+FGPeusUPFMGT87lc3Jjbws7dWS0UI9Uezv3ERHm4z4xS2NnER8GM1GhLTtGPlkWpVBcS1SyxcOiulxrXmC3AvIDDRhOO+eVBUJOsR+Cm8NKM14LYa20kVEh4vq0T3jwSwO7MS/lICekn0oVhW6e45WDr15JQIwEdKfcQbARNeZJXhs+UNs6SfOIBCcJ5QXqY3zcAev6wJvCZ/WETl/LLX5ygLrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckwJQoRbymQPxxAe+uYmcr19TdsYJo6rcVjLC6YlI9g=;
 b=SuSOReR4HfT/mAAJJ61KNKTRO6+iNQ/c3DGE0EoHVIJeGfzB8O03DO5P8sGCXlD2M70XKNFmQCfAzW+zZYqEGdR7zloJfwfYjN/ldn3L/wjo1A6qMH7iUBFnR1ZVyQdea5zvbVK9RFhQPCmbXSYkBtkBrDHUb0RuXyv9nJ3iYFRuPrjAWQR7Q+go+2Ux64bGtmpZlNKTkSlV3xroWsu2C05Ns9jAH3DI9qQY86caAm22Aa8vqjexD0zUcQ3EXD8TpYKuy6P2IKS2UINFp7PCa3uqvQrwA2YuFYQT/eE3wQdR7PzF+4HG0qMCpN3VRReuc1GFtzgTNqPt9hMo8SRnCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckwJQoRbymQPxxAe+uYmcr19TdsYJo6rcVjLC6YlI9g=;
 b=ZBwBx5PHeIgGhJx8EH3anFyeMScRed5cZC1QQmBj5uSPNHX+Mhte2Fv+Y60LhHKgYWCVWlxNQWhxL6t6jChBhIa4zN2rd9SnYJ7m95IT9hc3GmnL5SqhR4z+cJ5a6BQlvpc8lH8hV2R0Bz+N/v17Ju8P5ytFK3aAAnpOlkC0V8I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8082.namprd10.prod.outlook.com (2603:10b6:408:27f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.39; Thu, 3 Apr
 2025 14:06:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 14:06:31 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Set phy_attached to zero when device is gone
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250319230305.3172920-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Wed, 19 Mar 2025 23:03:05 +0000")
Organization: Oracle Corporation
Message-ID: <yq1r029uyox.fsf@ca-mkp.ca.oracle.com>
References: <20250319230305.3172920-1-salomondush@google.com>
Date: Thu, 03 Apr 2025 10:06:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0014.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8082:EE_
X-MS-Office365-Filtering-Correlation-Id: bea7ade1-ae43-481c-cc1a-08dd72b8bc79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p1zW3/blnOnz2lPAwZAEnju0ysVeBVq3iZ4eXQnDhoifUmv9H+D8ykWCgrko?=
 =?us-ascii?Q?YjJtKSCLGrgUvnaMD93pQH+fbQyk5GGMi9ci7Al1DOgniuHa33ZO83EG0BEF?=
 =?us-ascii?Q?V5d7NwcsUMZmiwLoiKNrCgK1bxsITRBHulzIatkF8iDxmyEuGLThBUfHTYF2?=
 =?us-ascii?Q?pHIQS372WsVm81SWqVrtgNtvBYgkkZtMWdL+WL52YnQSMXBPWO8xETnrxL9x?=
 =?us-ascii?Q?/LoE1YnQb+ZhYPgRtqOV5XPW5XwuTaHSGmC4KRPVxuEPtOrNkUpLx5/yWCJC?=
 =?us-ascii?Q?8ZTw98G89Os9yaBeIJoZw+Zc4CcLtlQnEOBNwSO3sA/UwJNm5GeUEVQD0gnp?=
 =?us-ascii?Q?PpJQwP1BW75ocNLwrB4y7ltGbR3T5RO9qn2531T7Ajb9mT0y3K7a3fI7dEUk?=
 =?us-ascii?Q?0wj6/5+vv4O0PFVdqEQc1abJlf/jkcpZQHTdR/pnzSi6YCOZqWa0iU31z6KK?=
 =?us-ascii?Q?OfYozRXzpz6cNDQQZJU0Vxl+q76U/mFmgH7KQjAtZ39euh+R4nngHOKwLk2O?=
 =?us-ascii?Q?Y1hnJmot0RHvub3hPACDIaaGQ0bSy68D1FbqkEi7LYfqw/5o7rvCNHCjc/Sh?=
 =?us-ascii?Q?ugqNOYB4xJ7TggGqbH/I7miNRBcqHvGWtsOw3e40Ys3g7sbDY0Q4nf+X4NJ2?=
 =?us-ascii?Q?3fExBmqj8H7KKt86oHR6F+/nv+Sh49911nB3w22sfjdFfh/BaRXMLsRt9PcQ?=
 =?us-ascii?Q?Ky/hNKtAyd7uIMggJd4buy65bO9v0PECd54m9dahA4GJENtTlGgHYewsJQtn?=
 =?us-ascii?Q?TxspwcDIviMotTUH2LsACLyZWz1vDCO+RTFewaq+ke584bUTNhDSpaK/Mjxd?=
 =?us-ascii?Q?dYMx0js5nuSGnPyjEkpDHpua05QYlA24m7q4izjYQ8DmXhE3D3LxPZySxbf9?=
 =?us-ascii?Q?OjGtsYeMothDyw2vNozarE4vl8rSwhW2wSafxLdKoSDKlJaW4lnwH0DiI6Nn?=
 =?us-ascii?Q?3hx4SdO658ucvsaxedTuebu/6CS0xEVnzOhkQ9H5raQCzWo1/W5cN4nv8GAN?=
 =?us-ascii?Q?3xw/5YKEJ8HmiPIVXl/m2SbKA2eDxKeIGdaAtEnK+8pdapTO4Tu5CvhJh0eR?=
 =?us-ascii?Q?K1VmOKxdewERFkWehcwYR3OSekxu4pNnbcvt9OqaOuZOvzhelPB/bN8iKP6u?=
 =?us-ascii?Q?wKNNd11mU0G20cm20XHDsdDN0DcB6VQbjPzLgGfIcyWJBvpwr5f5RHGE8Zc9?=
 =?us-ascii?Q?vCkfLTdiauFf0I8uAYH2RqOSNkeXlbJXeW4DOU5RnUtVeMUjBOU4C9h3y78M?=
 =?us-ascii?Q?bSGjUtA7AMRtocZyihy0SKttqkUaI4mw9M2mAg/ozWEIWjljTi9ofg2+Vb6m?=
 =?us-ascii?Q?EInWCXnj32gn/tlJI9JFyi0XDfTgrsQheu5JzO59ge/5EykKWh7Mn9mGTPHu?=
 =?us-ascii?Q?AV4g7nDFpmTOKj/fyf4r/WSQH/29?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SPHlfd0s5xwg0zyd1v4M9JFwH+GmqMdGxXyouJtNWJLrWpVYktEULDwuDduB?=
 =?us-ascii?Q?ySXp9AHBhJwqPZr2cTEuhrFQfcgBcIdOgL4D7LXM2f45cE/kzOw7nFKyuCaN?=
 =?us-ascii?Q?ss7VJqjeRjeFkM+Gj74smBI3wTe+0ZPte+WB+NMVbBi0QVVHegGA+DMriHJ9?=
 =?us-ascii?Q?3SS6ujAZZMQ4/4h2UW7TsKSQF50HvvDWTX+1TVTasSRp+ejAQprIoPLZn5u2?=
 =?us-ascii?Q?I2V2zD3VBNTxsbIT1mP9iZtofMXQT47TJ6u28M+PI4SQfJuse3fvs/ofMrd+?=
 =?us-ascii?Q?UDIiJ53nncL3P88WHH3x1BnJIDh4vF/f4Wd0ZoA66c0+tAMZROI5XS0Uhfkr?=
 =?us-ascii?Q?7CQ6Dj2+qh+72MU0ZK4FNgcqXgrp8TOpyyF9ADnPNWIVmC8CX6Fgy5aZuHiY?=
 =?us-ascii?Q?pP/E3LnDpk6Fxn3ngTaU31tiuIXbXTS481GqKNj0ZEMRGKhgDZgQMk6Gl8U7?=
 =?us-ascii?Q?m/tQwbYzh67eh0Y2Y9xUcc9w1cdtSbZnh2y0sSnsq7aHleG40nKTk0cM3JiS?=
 =?us-ascii?Q?qZCyStYIX0xQ/VnPNRtz1untRSKWuI/dfpzgZEhRok1r0wyrOJrMD0Gq8GOl?=
 =?us-ascii?Q?3aqvSvHfA07VvdRdq5F/UX/Az2m/OKwD5lQo79EoGYIyCEwbs5gnZvNj9gaf?=
 =?us-ascii?Q?dp3S09RYuxOUYC0Elw4yVnrBxWToOug/Ph5BsxdPgiBdWuXZ3uw8ueJZkYVL?=
 =?us-ascii?Q?S63mLBdGsSC/wcwgRmdDSZl1yMb4O+2c9eZT6BjSkW5T+itJuPCgdYte0UTA?=
 =?us-ascii?Q?VlndHjzjmanP7P0hhR6GZQkzsdvULtYMym7v3do0QgoxYSQh8aApkVgB3A4Q?=
 =?us-ascii?Q?RdvjQn3Qex/v+VsevrC53iJNRAJLoYsl0Ui+pNd8FHNm7RVJLJ5y9AXhTqXl?=
 =?us-ascii?Q?WyaEsT2Pb7Egdzl6c501zQ3mA3PRVwkL2wznVjN9SgxAERnkFZ1LQYk2zu+i?=
 =?us-ascii?Q?gI2lg/FV/Ozr0yU1nEijotoDH+cW4Wa9X6SeWIYxT+4nyX92j5ES9IpjhbNj?=
 =?us-ascii?Q?18HfnfmdgJzZuNzttbMPkjPksTnCTWv8DitOsCNgjg1efWuJy5sd6XpU7QXc?=
 =?us-ascii?Q?cwPmlVfuv7d3/q8ThLrw5s+IrRGn+V8yhJgapPMtQfEbNLUdJugmnWQH83Dl?=
 =?us-ascii?Q?nVfrYXk4m2bDgA+/mFuAsoankl8pSmY0llH23Pdytkx56A15rH3Ak8wE/GlC?=
 =?us-ascii?Q?ZtWVH+FryVZhGXrUrF0QBzbvzo3/YPHUFaM/TPeC5rcgpQ7ntOBpzpX3B2mO?=
 =?us-ascii?Q?mnGYrmtS5mze8ppKpnHBTNbXiGps5A1rGbFYHP6XsNd5gThyqtjlsC1bM/x4?=
 =?us-ascii?Q?hG86iSlVDrPkQo+cMoXOwi6rA203nXjQw4DAfs0KXWzwnhP2nApD2gaM2Yto?=
 =?us-ascii?Q?RRDivkLm52jZ/8tCwDSSmyWtWzd8lqz2gOzBGrpNP0WJP9LrARoZErhBpyRA?=
 =?us-ascii?Q?bKMExJQKRdWjyQau1YFHZZC++0C2OyEbPOQkK05qYyhalwbXivpgXUye4bOn?=
 =?us-ascii?Q?9S33mH9CF7zep7A2kVnDMZpsrc8Cu56UpnVfbWqNxfVBu8jSDnO0JTtRw1On?=
 =?us-ascii?Q?g+jEpSsLN0Z95i8smTZCcKQ18+7w7t0z/a9o05hRGWihQW9mUjcsS0cXa8iZ?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	joubvDNUuDgtVAqh3Y6ZqzHxoxjlz6CzObEPCNxW0QGVw0pCIhhbz6sAlSe1oQgp15V5Ds+OyEBEjlqxgkuB4pyuL2moCYkovRPXjJmkNOz7U8JQOLbYYSGYQU/FCbUTCLGbmK2K0sCFTYOTVy+0SdIFW764SfWpg71JNhSU02Gr3uGYk1r+Et6m61XNZvKYNMJuivb/CXamGFxE0dnFyGIe00N6osEcxAY4TOcSiH0ctOjFPr2/BEBbmJWUYr9DHBqFnI9CYEKaqTlV+bwlkwQ63Isuq7FM+uHwcyPhekiyn+ixdBX+nVFGpteMoBDrLUV2uKQxsPpakY+upj1fl18jMIZFECqGvjFLbQh3keHAiVaGO9UjMnxn8qQAXdADW2q1kgKYRKZxaSNJGNzEvb2pvusciaTWk+9BciaCgAOh5sSrYVzyYtG25FbBrf184Vrx+FZ9NJceDpqXCnj8elTygK8GX4kd416/+ga9JMnunEF2zy0WKVNts2l9oo665I5+2fiIA7VWTEiV+ohGXVug5Zdm2Iy71EZDdfSlJg4op4pynDXcXCc3iVLU4uXiGaxe592a9rN2xaT1tx7jn21uc2WTA/vgKY+YMWpsdOk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea7ade1-ae43-481c-cc1a-08dd72b8bc79
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 14:06:31.9260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sf85JK5FEdbBSl0rgNnU+49CLahXdnxeNbvaItwpAzfZ/lHRBhR249P5g5FN2WtM+Ky3QJEpR3dHnVp74o1pKBvif0CIgiqIkAhq/V60Ra8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=701
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030065
X-Proofpoint-GUID: Gfwq0cFXGJYxI-QcKJ4xBeJ8027zUsg3
X-Proofpoint-ORIG-GUID: Gfwq0cFXGJYxI-QcKJ4xBeJ8027zUsg3


Salomon,

> When a fatal error occurs, a phy down event may not be received to set
> phy->phy_attached to zero.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
