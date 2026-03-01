Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F572E3AF1;
	Sun,  1 Mar 2026 12:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772366915; cv=fail; b=R788c8HtoVSdc8qF0ErW3/vVLwujMmf6RCk+aczjx7GIy337UirQGHuBqGsNJiOUCc0ucfSTM07dDJUFNbA7FNxulAXTtPtfbmhH6X/4GcqkZ/ByKiXZoa1ggungCZIH11mFFZgDFDETxo3OP9j0/V9tVV9dgUiXdr4BtABm0cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772366915; c=relaxed/simple;
	bh=HWRyVxmpZNvzEjW0UBhxqeYp+au3tqOEeDUdNKeJwGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qyuGn5Oa77wc19K4mlBwpuFn83yzor7cgZUMwv9rFgLXwx1o3nQi9MbeRay5Hu3i5BPaQCFQvAnMAmHPZOj+auhnCdxTSVManWJu1InYVHrGi3sjXHPzIJ7LQs7Teuce2POTnU1LhhX4mYg+CJ3npo55+T4R9B+aotnuzuisk/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=l0lLz4ax; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="l0lLz4ax"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621C83A73350722;
	Sun, 1 Mar 2026 04:08:32 -0800
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022084.outbound.protection.outlook.com [52.101.48.84])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4cmj0b85r2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 01 Mar 2026 04:08:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbyR0DdBKVEdYFmFb+tuG+QOtRYTLHD8Q0QJvvTT5+grNglMOhSjDwdkrgs1qqorRRaprgGl+FJuq8MrKZ7t4Gsu32vCe+KiYq1Z33TfriALfTgn7LeWRbINWhtwXYZIu4Z6cQBTOhDFJkeKZbxOUfSc92RSpXu1xEyY0R+C39zPrjuObMICTpUaHTTd+csTiP0kdPq/dHTdR1vFJs8Lyd+uLmlr2D2NPqCFLu4EOB/CU60RfDMmXGxGw1GViBcX7ZdfVKJItoWKZWCe4tC6c7h1BLqz/am/60miLDNmlfUsJDc9+KrW08FHT1j07Y+aHkCTM6B2gK/1rqKP2xgJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8BiICj+hGt6FIutd7guWGAT4HC8dg5mwznu11lUxYk=;
 b=uI1w2vYhgKpIJOphNwar/mQbu0AYNbBFnW76DKsarIzN1cPFdBKjS1lW7GNjZ3cDhF2fi+qMPoBt16oYie18AczKTW79NUb/6FbaxDXsLxHyKIT3ZAYcVwCbUHeKbnZhBghRUOa772uu6cE6s3wtTsxAIPGea+xqkD+vqDEluJx5frqE4x/rWRrRhgx5MXHD0rr90XaxQ5wHfzbmQFMaV0eqmFdjLpACK4lXY3SNdZT1Ff+auaY60aIwLj4MLRHCgRQVZ4un7NNnaiZN6iiQIIPoTjNlc0dMcunyFXbX1KRrCcL8OSVQpLtpvXWZxu1euxPxNIJVjE6kc4V4pOEz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8BiICj+hGt6FIutd7guWGAT4HC8dg5mwznu11lUxYk=;
 b=l0lLz4ax+cmyevRfY/0j+aXO9roXpQlI42tlnumEWNgKWbXa8gvaCqJ4l1RTAP4DbX1hLmQzVjkRszfxnHSqUmsziQKtn0r/Z/j+ASHV862gPAw6Gy+6dwOzSnbjgOt9U/EsXNJo7VTcf23Rji7y76duhd5j9SmK9FP+nRFymw0=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by SA1PR18MB927496.namprd18.prod.outlook.com (2603:10b6:806:4b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.10; Sun, 1 Mar
 2026 12:08:28 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%5]) with mapi id 15.20.9678.010; Sun, 1 Mar 2026
 12:08:28 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Vladimir Riabchun <ferr.lambarginio@gmail.com>
CC: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "himanshu.madhani@oracle.com" <himanshu.madhani@oracle.com>,
        Quinn Tran
	<qutran@marvell.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH] scsi: qla2xxx: Completely fix fcport double
 free
Thread-Topic: [EXTERNAL] [PATCH] scsi: qla2xxx: Completely fix fcport double
 free
Thread-Index: AQHcmnU3/Ig45YrlaU+8IZQs+SHxB7WZsuvA
Date: Sun, 1 Mar 2026 12:08:28 +0000
Message-ID:
 <CO6PR18MB45004369C0B522E7BBC258CFAF71A@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <aYsDln9NFQQsPDgg@vova-pc>
In-Reply-To: <aYsDln9NFQQsPDgg@vova-pc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|SA1PR18MB927496:EE_
x-ms-office365-filtering-correlation-id: 8668263e-2f68-411f-b999-08de778b3f73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 tQofGLPUfjgAYVj3NStNegWg+JFOVMxv8umLgD+tje/gNxU023UxUX7QbaLHJWOwP4vuxAcc9WtSRnFKmUfrJ/Q9AMGhpGl0QMe2LEgN77lFf/iSL16RwuTzotBFutxy+fZ2cW5KWwzKKl4cq0xKyT1/eTqTPHSbDWhJVlapRCI+NmiZSkqaigAVF+n2vVUy/L0zNKCiOJdUcEmpdE1eatE6sBBpfjOnVlTpbmvuf2z+WU6Uba9xT+A1o1u+z4PJT8mmMdDyNojGRaRWTh0VMMqKDqSMeq5xb2WFk1MLZwIsqpUFBWyCrhEpRqMfdrt+JIkcMWo6/QGqBJ9OqY0TfC9QLdHLcTEzIG3Y1FZLXftgYg3kUdbtPco2XRiO8VTmO1G/Fxs9jWeqAyYcXLtDgsn0EKW2NACtKsWSwDKTG6grpQdhK9oKv7hxetxCXXTr3VnIvzNcZjdDRs4MjxI/Rp2R/lnjnnXu0XuY1S8w6gGs79JI4dKS15e/9Y4bCDMB+hrFrmfikEHwB+LI9ygtji5FUKgtHhiFriUV0+VHHj+FeudOyf/Vw8HlaJOfsJCFkZ2ePiAxvax9ccWP3NuDjIdlXvO7KeOiT5ptCuT8BAVIKGfZj5uZU7w4w1JsJhQdxcUe8mEiigKmtLW3INv+HjudUOiaRznqA/fNlAYf4ynjX6L+TiRftAhLjcOEXe5WfaSC1fKj3hc66FvsdzrYmVU9IAxI/o1ii/G74MFSIVfiyFjS4LMEDQJmxnwYscdsTXkM5glIKqdytLJ3QTwIY2s8T1i7TvHh5doFBHsMy1w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?windows-1256?Q?w28b9oKDL6Puk9uRGZSW+Oct8Q3Zq5y2MkKbkNDgx6wQXUd999fD6Zog?=
 =?windows-1256?Q?oXZLJguhbMqsZ74L769c5nL6UZdbutRqU7W5PndPY4t3X0OFDXwXZ8S5?=
 =?windows-1256?Q?oMrc9jwrHt3JjFkl7jVkq+pyaal332bp+J8z/ApuWxyfMwWPR+MUkOn+?=
 =?windows-1256?Q?3igswb0Cw0Av2ANPBbZWYNXPa2UTweqz0I5rUZfY+7R1sVbS2zoEEKe1?=
 =?windows-1256?Q?cftEC2PiP41cIyloTUSsSMhF5ME+Z/nzcmN63Mh3DfXo5AHkmmif00tL?=
 =?windows-1256?Q?UKz37G8ueH4oyDSfUNyix237hKzwxmnYpNNkpEb+ZDZ/9rkzl96bPNK3?=
 =?windows-1256?Q?t7WocsEDA7Lm0mvWqTCPDc/TGihM7e766N+c9wNZk7i3EkazsnDW3KnT?=
 =?windows-1256?Q?YsSN0pAnnasFwxz91aZAK2IuJiI+3oKcv8dS3iHdQ5cHxsuRKOucv1e9?=
 =?windows-1256?Q?nqa7lcpqSsTBaZvwo2kIoiuJ60airsdgUjmGkBRtulFBaTpCNgeBcBTx?=
 =?windows-1256?Q?/WfzkHpOigs0yidnaUC2g5q7Jw42zMt/imvN97V/SyC9v2vSqJjUa+8c?=
 =?windows-1256?Q?CKbtNYgnfEKjiD+kM5cmCUEOfJxVunV6ErLSDl04WfcD42zyK9zK2sx7?=
 =?windows-1256?Q?tj+OjNhaSnmmtbq8IhuvHD3eWVejMM7H0pavjm+WxIkxg1RSKkBuni3C?=
 =?windows-1256?Q?irl3sCfpQJIF1AK+yoZ3fWF3n4VxUjYJwWOe/AFSubb1qJSuLM31DmpW?=
 =?windows-1256?Q?iONyebe2xhUPY4mUNWuQWK9QuBB3C+Ve4ZL0Jt+yB6AIMA9oK+FAPd5E?=
 =?windows-1256?Q?8+/KeUlNMs07FgkjuAhrGb0r9eUjIFOI9qM4FCKNQm+yWhBs9OxIp/Nh?=
 =?windows-1256?Q?b+j3DVjzycWRHFevoFIRg/XC1IYxlhSTnGbJjF4obkmNjPy4L0kK/g5n?=
 =?windows-1256?Q?oAs0jDw9gNMJmCga4mOpPImLMRaSrJIr6PAsL1cxCRO/gDq9veApFo50?=
 =?windows-1256?Q?ll2xfVisIgaWRuh6Dx6Aj7Rw6o8gccminJvP5Es8dkxRiN+uRp51mgV+?=
 =?windows-1256?Q?kpn8EIg/jSkcz6bVxL4546bT3qAMAokYsZMSB+8qCweG2ccX5jSh72MF?=
 =?windows-1256?Q?0oowZzmvnSx4r7lPVWAuQWiuoTWBIer2dfqhXFtL75721Mqk5csQYdU9?=
 =?windows-1256?Q?d2YxH7Nq3fnP60ceocHTGdUYU1CiJXlEcK+UlddgyWN7IY28uAmoQak+?=
 =?windows-1256?Q?QpUjW/Y1M9dKySuL1WczsyVltVYXfYnP6WsDnp+whD9osU6skmh5Nyo8?=
 =?windows-1256?Q?aouCnPzmwdVzRKDYhUFzDGCyObm/Pe0Jrunb1m3gMBkvQV/Zus6I71P7?=
 =?windows-1256?Q?ADoAIANwbpEHkC0xSoR+ZUsuj3A4m/EvSbupEmpHRjQ5VjmA1C/foEq6?=
 =?windows-1256?Q?fI5aJZ+B+mkhR53CtmsNgM/fY2zpNz1wybBeqYR0MLPxFq3k8x7n6uEI?=
 =?windows-1256?Q?EjPa/AvHSlVxHOt8FqAOOkXyNAbYbGTiLC3U3KY8BNrt2dozxbhtGEgr?=
 =?windows-1256?Q?fI38Mna/wiTyi9UHxbn4r6rYbqOkQcrsxX034r/JUneAQnxK3AXQe89b?=
 =?windows-1256?Q?2sOuzCpRCmZTNHNOVXnX0PnhOyFhiEs64s4W1EjSDAT2AG1MbZYXlFG6?=
 =?windows-1256?Q?H0T6/N0KBdKZEODCi9sqBqvemhIkHcFiyfaTJw/1KOWMDVYYTClYSivt?=
 =?windows-1256?Q?Sgrqn8Hvr3gfuw328xr+MZU+xlF8hTWq/MR3ZFgQAzLys1Pgi5aB3AyU?=
 =?windows-1256?Q?A1Ft3NRuP5Vrs0Ve0IJciYNnbiingL4Wm1/Cly0W6RyCNz+VFHCVASBQ?=
 =?windows-1256?Q?3kmW+ixUKSQBfA=3D=3D?=
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8668263e-2f68-411f-b999-08de778b3f73
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2026 12:08:28.1710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NlH5sG5L3Hny0B9vpZ9zhHD28eZCbVuxeox9/UgNGHP9hk67YBypZxuc349jq1g3FInaqhFoTX9jJosgUj317Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB927496
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDEwOSBTYWx0ZWRfX21tPKc8ymcGn
 LnMCaj8abTFhO+OsK7y6NBtOGWor98x6UMzG2HGYAcdGejDUvieh0buKkJpe5SX+Y64A66giINK
 KtAc7GQzbBINRT9Qo/zKC0SKnyxQ+Fy8SDR5JoYz+Vepf1nvuo8ANEZOLAG5yBi3ssI/zW4pEcT
 lQoM2E0YdXMy3Yaindc27bmL32RWVgFza/l/SmSq4p5yJxgo3I1YzN2L23ixyYemLKNdbox/vss
 Ur6L1ozw8Fu1sBDtCwdbeTdbCnvZ0fIS4tOJaCcUMDwBMWFrBIFJY4r50PfjXVbUa+/uIHCnNZE
 bYygY7GknbLiDhbXaUHYBBpUl1z50XKclZXgfRbvbNosbTpkOh47DU2tFhSbteoX23brqkyPxMv
 g8Nds4IB26wyz2RAgpjcmX04F0kzTbgT8gENi955x0SFkhOBfEFBREtYFFjR/8aIb3oBu7ZQDyV
 6Vtfx2J27H195MaE97A==
X-Proofpoint-ORIG-GUID: 90oRK4mRhrqq2sJpyx6LLk4Yb6voqlvM
X-Authority-Analysis: v=2.4 cv=TtrrRTXh c=1 sm=1 tr=0 ts=69a42c40 cx=c_pps
 a=fn/DPt3lPG6OhtMeQbTPHg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=eoNxP8pz9j0A:10
 a=Yq5XynenixoA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=qit2iCtTFQkLgVSMPQTB:22 a=RpNjiQI2AAAA:8
 a=pGLkceISAAAA:8 a=tZtTPsglAAAA:8 a=M5GUcnROAAAA:8 a=bLk-5xynAAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=dnWkpfBXLDa12dVJGjQA:9 a=lqcHg5cX4UMA:10
 a=PRpDppDLrCsA:10 a=RFXaeJp-pwgA:10 a=kvF4l7fDfTDN5qX_wnNv:22
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=zSyb8xVVt2t83sZkrLMb:22
X-Proofpoint-GUID: LjD7SXt1fjHqX5lN0GJT4U5pl3ZWDPfI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_01,2026-02-27_03,2025-10-01_01

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>=20
Sent: Tuesday, February 10, 2026 3:38 PM
To: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>; Ja=
mes.Bottomley@hansenpartnership.com; martin.petersen@oracle.com; Saurav Kas=
hyap <skashyap@marvell.com>; himanshu.madhani@oracle.com; Quinn Tran <qutra=
n@marvell.com>; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [EXTERNAL] [PATCH] scsi: qla2xxx: Completely fix fcport double fre=
e

In qla24xx_els_dcmd_iocb sp->free is set to qla2x00_els_dcmd_sp_free. When =
an error happens, this function is called by qla2x00_sp_release, when kref_=
put releases the first and the last reference. qla2x00_els_dcmd_sp_free fre=
es fcport by
ZjQcmQRYFpfptBannerStart
Prioritize security for external emails:=20
Confirm sender and content safety before clicking links or opening attachme=
nts=20
=A0=A0https://us-phishalarm-ewt.proofpoint.com/EWT/v1/CRVmXkqW!s23TuNc6Kf4b=
28FwlfU2YPVqCLYs7V92y9zVWZhLT6LLyCdQdVjtn_gEpzNAiNXoB4Y$=A0=A0=9D=20


ZjQcmQRYFpfptBannerEnd
In qla24xx_els_dcmd_iocb sp->free is set to qla2x00_els_dcmd_sp_free.
When an error happens, this function is called by qla2x00_sp_release,
when kref_put releases the first and the last reference.

qla2x00_els_dcmd_sp_free frees fcport by calling qla2x00_free_fcport.
Doing it one more time after kref_put is a bad idea.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Fixes: 4895009c4bb7 ("scsi: qla2xxx: Prevent command send on chip reset")
Signed-off-by: Vladimir Riabchun <mailto:ferr.lambarginio@gmail.com>
Signed-off-by: Farhat Abbas <mailto:fabbas@cloudlinux.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_ioc=
b.c
index 3224044f1775..0de015de7eb5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_o=
pcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
=20
@@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_o=
pcode,
 	if (rval !=3D QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
=20
--=20
2.43.0

Reviewed-by: Nilesh Javali <njavali@marvell.com>
