Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288A114F9E8;
	Fri,  7 Jun 2024 06:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741782; cv=fail; b=SjwIwHeWNt8/3iVRwuoQMl/te8xY4nyJxfdsR+iAnLoFF0GObnO//Q9vzWwkEuyKpyUSRNGR0DcWdbVOwiSUqU4w9KKQ3V2gULhasZzWlNJyJRN8pisBkcQqdt/TI5ko62nBpaclFU6JyXeaTZDX/7gBskgU7byl7a5ni+YdFgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741782; c=relaxed/simple;
	bh=FosrIny2xOI7mYNfCGHP3+zQcefGd5RHSM06LAOs4cQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uyBS/Y2WnRIgOygnJDYSnHC+XICuW2AlZZHqX49sfd3s5e++v7nFSLuSm4N7jJm4OSmuwVnJdRq/LJhEPd+gMa5DfSR3JDANw4a06EBYiAb6k3R7vBinTnY6p6ip0TBKftQpGm+y1ccxseGGn2SO9N8FDChP9GO3Lsm+EasEk/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=X0C76ot9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vB8Z5tB6; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="X0C76ot9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vB8Z5tB6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717741780; x=1749277780;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FosrIny2xOI7mYNfCGHP3+zQcefGd5RHSM06LAOs4cQ=;
  b=X0C76ot9gXPHOTvSDbt2bWPi3fnalB0aOFRP7iSZccQX5dVK2rWHdbOT
   oT0zeRckFDP8xVD1NKBIc2kdRRpZffwzY7H2mhz1UEfejILXzK22SNFuN
   q5ZkkJVUWh7/idz+W4U8sh+Cc8cdDmWuSSi1ynQrl72loCEKFpE+gkpWE
   zRr9Rw6jMGGMqSGNeq6e+Be9GKm1uWmQr29PCXX8pFgv6S4ImonvuP6E3
   miP+JeAZNHA+7Pvyc02msAuGqvg6Rhi3oX7XcTOJ8zr4/lUY/kivrnuiH
   WEB/OFAPH587OD9gRXXzOvmNzJpBlHYI5uvtjW8wM+ojMdJ3/91A9qMkH
   g==;
X-CSE-ConnectionGUID: uPRHB2MDR0ywktgA/r0ukA==
X-CSE-MsgGUID: awjVZT3gRVe5T+pE/ajCHg==
X-IronPort-AV: E=Sophos;i="6.08,220,1712592000"; 
   d="scan'208";a="18460685"
Received: from mail-bn7nam10lp2047.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.47])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2024 14:29:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQ/hv1gBu3A4E9fIEriTRloTjA0R2+7EzyQy6rR8yuUSqSj4G1t4DJGlGwqXKT4oMMwxHekZLYB+YrxYj8Dz2bBKZg8g0nlRTvlUXil+D09iO6kBUeCTAvZCKd8tLgsyttrr0xUHbgy6vLUURg3CEgOqj5NldS/2qfBAGhHbSgppKyFTPjZtlJQgdcZA0gR5LWsAXagIu71QyKhUALaPnxJcxgD8cpknqBKC8Ng7L0wFFBnzO7lKjIEXyu+NECb4RfIc6qH2Clfqv0hQzho8xCRYmvqp2SWGeqhA9Ya/fueOUE4QBeTdgqJfU5otkNrgmrLkC78S08dE+0Ni0D18bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBItTST1XgTM7Z3PxwLnLzopFm4EcyHz55QcY7cjfR0=;
 b=L9Qyh60CpQ2w08tNb5dgRItSgkgDU7Sy+usQiWgM7Mtom2bqxKZwmZiYW7doqGeTsBFMEFKu2Qr9upLeJN0AcMbdOFk5FnrhwS3Wkv3F4d8r6jSxGOjq1ywIdDmXg1qBO5RTbLlmJZhPrFije6e5l6vNWmrzICzMW+OWEjGM4QHTPZFdluIxMHoe12AcGQPVZni35Dm3Q88bGptNtRCGlOV4R+yNnfV3YCtgo7Vr/lrDAjOuHGCUM4+YYH9Xu8ou89ndhRYvdzMmbeWkxQuATdjQQTS8K2dnUS/gjVqu4VO4gO6ZBkq7K0RIrzsmwMKn/sk0tuoTE3ZiXhHc3KdhcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBItTST1XgTM7Z3PxwLnLzopFm4EcyHz55QcY7cjfR0=;
 b=vB8Z5tB6NBgSIzyHeXwZFcXRF256HtXXTmWexVrKM1QguePlE34dqC2e37jdNPR+DTmPnZT40faMvIfWD4gjSpzIgEkXpe72yXPmF0fhQ5+/5ryC2TNO74DK0ZJ/y6TEH3XtkU9aEikuJG8lLflWtzdhVdOMKNJYYMKXgDhe2ww=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH4PR04MB9263.namprd04.prod.outlook.com (2603:10b6:610:223::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.34; Fri, 7 Jun 2024 06:29:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 06:29:31 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joao Machado
	<jocrismachado@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] scsi: core: Do not query the IO hints for a particular
 USB device
Thread-Topic: [PATCH] scsi: core: Do not query the IO hints for a particular
 USB device
Thread-Index: AQHauHiFRmcsU22PKUqAApuOmNEu5rG71mpQ
Date: Fri, 7 Jun 2024 06:29:31 +0000
Message-ID:
 <DM6PR04MB6575388630C92A1AD4591C6CFCFB2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240607011651.1618706-1-bvanassche@acm.org>
In-Reply-To: <20240607011651.1618706-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH4PR04MB9263:EE_
x-ms-office365-filtering-correlation-id: 825dd364-56bf-4b72-9278-08dc86bb3082
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Tlu9/C6NSZIBtFB7v6psKv4zRIN3JWSVjltIZmW/9I7ijIe/CYW66osVQ41f?=
 =?us-ascii?Q?MknUnCdhxA3QahhvAHmN23v0lIu0wqBFNWgugYSnWBHQNsKDV9dXTr3oJplb?=
 =?us-ascii?Q?E3R9eYY+RiiXSJYiodPj+bL3EHMcwL0fEPOKa1seGjiGIUZ50ipisgkuOMhC?=
 =?us-ascii?Q?w98t/d/7V6niaDLn5X50ynieBLXf35ilI1CfP1GMipYEojnZByHFSpf1VZcU?=
 =?us-ascii?Q?e6iFKtbIO8+tjS0T1wzIpUogVssRxeIu8g6h59tHAmkitBc929GRAI3sBA+Q?=
 =?us-ascii?Q?Ln7t26aPWIgmfq6UYl45PQN3vgvIktutsdRzlFPZupWbFD85ZSTn4XBFdCdL?=
 =?us-ascii?Q?aCVI+BwgxH1201cwioIHONhkoQv9m6Jr4XmUtfmJyZgYZ5qabCv+MYd9UKgk?=
 =?us-ascii?Q?zsZSDy1J8HdcZWJ4Id2SvGGQSM1twBLd5R3y2WMRGxTk3yeN8GYsYtp12A1Y?=
 =?us-ascii?Q?UqsI2iJFipZ55JVhvRZRoNV9O/TKWTjXUido271E00Rqz2evhCx3ntQp4ljr?=
 =?us-ascii?Q?uTnt7gA4c6lSIChJFpLTVcucorbpTFj1ipwLyxn0P0rUjW3YtUV4Cgi5Rahm?=
 =?us-ascii?Q?hQNhes2rN3gx4XzyuB0vWEjZSZDAX8qsR7N0qL/QsGvkzFcjgfy71dHpHqKE?=
 =?us-ascii?Q?zT/UbjUXVn5JnpXcTXnPd1Y8YzetXMDxvjtx2yJ+LrEAgJcHfNWFfhooDtpP?=
 =?us-ascii?Q?+PVLnoVjHpRwHTp3z2JLSIwxYYD1ql+hmNX9scIolFMlVHnQqrnsn4sWzdrX?=
 =?us-ascii?Q?SJ/x/m4GSpZ0NAFlvcvbPLL/+pduRhRYtR0PX4/pR2XSwnXK8xBEdvga8AK1?=
 =?us-ascii?Q?OxpKdyLSfxjTlxgDL0PbQIDaBkveoHc+z32sEJgNCAoi9fy9OqPjpT/yIw8e?=
 =?us-ascii?Q?pMdHSwRScKWz8SC1QAMX7kzgxD7PHrWDbxJvEfJPVZQPqtFGLzlKX3fvPvDY?=
 =?us-ascii?Q?UX6mfd43vS6IpfUN8Z0YM9TYnOfh8F4kNVjMxNnD3mSAwjEc9PgnU5+zTYlf?=
 =?us-ascii?Q?FQGMq88gCLaIeGTaJP+/ljbHZ1jod+z+0GgAwp9yPYN1KLpJnGYt7FREZlCW?=
 =?us-ascii?Q?xd09BmteDB7c75K7KrlJVzyyJgiejUUL8xqTH/6LszXFoKo0Qo30mlxCE35L?=
 =?us-ascii?Q?9dAznu6iO2zLW3pYwAEmtwhFhgA9UmlgPdefX467+kBAoh/IZSQsnFJLOg3d?=
 =?us-ascii?Q?lQpPuKfEPjOsr97Chp2bUbL46Wz14raS4PvcvjGlGzPlu5IpH/XyLaPa3KL2?=
 =?us-ascii?Q?4bWy2xDS78fvTxpk/jTIjNaEpEdQMODkzKe3yEndx4t2tQdnMoN/VHkuHfKm?=
 =?us-ascii?Q?z5bB3YaeiTbqKnJG/KgnEHnrgTFOth3peKh9Z9DWUDtaJq3iNWP3bfA4FwaD?=
 =?us-ascii?Q?5azawck=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?IqikLPsyr7BEabuO1ltmHeT8dqvXIGpqURYgZmrTgTUlSk6jwybVCGbwhQqU?=
 =?us-ascii?Q?UMgGDSBO0gpHdYKNYOIjzCR+9kkthIJ8HIBwTZ/L9gT9DulwKtd8clLzCchh?=
 =?us-ascii?Q?zdfLCb6RmbolByTjWpRxnekLbNOcTXLVsmoVkLvk6nR6kaAysI2/0K75/kMz?=
 =?us-ascii?Q?COtAJRiUjsX2h5TwbsmtT3SKholjdQ5ofmO7PgReOJmvv7+Z4u+7f0v+mO+6?=
 =?us-ascii?Q?Cy4LQwEUv5LM13dlbX6GaXY/8h2B+zOhsMoElbFiu7G2fEO03VLU6crQMQiN?=
 =?us-ascii?Q?htxGc9uLZPEnlkschZmZu0LCRqxYIQpASlr27YPZ5JEjA8UI8oufyHSMsr9r?=
 =?us-ascii?Q?Xac6LhZlFYq9oNKL+8wta3U5IatnRHIbdbTbUHheUDN6ah4kgEGr3u1Tb7Zo?=
 =?us-ascii?Q?gwtlOqWzy4P0E+i/2SxBOY0SsUsE6HVfXcSbJWr4Zf3KPBtHkniHw3sptqq8?=
 =?us-ascii?Q?h0KD5BcMsvaqse3iYLevQwIOyJpuKvotC2f9VEdXrPcZHpNlUlouCFHKBGVm?=
 =?us-ascii?Q?z7JC42CkeRfbnab8f7DOK3dY80Emg9P+kr8qKUlskjcbacvhRv39F+brAn4P?=
 =?us-ascii?Q?fMyWQ3V1yI3ZlkJSg0zineQBTq8hgoGxVXU1yp4hLDwV7Yk12/OrMLo6CTrO?=
 =?us-ascii?Q?XpyzwIOvvecDht508KxuQ7tYsF7VjAPT0Y0J8etCAx6z1kcnCd8nvUXrsC9u?=
 =?us-ascii?Q?ecnmUBA5XBVV40MUaoBQizz4iInXpJp3g2Mlfu6Sf0lWYxtMvtW3ezdSRaqL?=
 =?us-ascii?Q?VXD+YNKckXSXNLRC8cq5RC+X/CrbYutNE0wd9q5TXtFwt5AhFhwApynIxACK?=
 =?us-ascii?Q?rEoCA5jkL2K8yB15WPnRhZeZ2Oz7E/HQP//xC9zOdeY99THaeLoZ7OxGBQNc?=
 =?us-ascii?Q?fNGrcBEDVeRMV1aa8TGa5ROFt5ZbYzuXJ8Am1EM3fSE2y4H/XpkqaQA03vXc?=
 =?us-ascii?Q?DbBc1rLpYSev+Yp6Z3ttIstUr/HorB6tbDhKM3Y/G0P/YkKwAU+N3iZmzELP?=
 =?us-ascii?Q?bUqepPwlaxmBNgn0CodjPousmZ8hCSCZF4N8Na9aIqL5ytskZzVvFylLzvet?=
 =?us-ascii?Q?ahqxMEl0NE8cppq4WEkEvLpilqiJYZduAxwSv5oASJMWcFtND9gA4z4ZJHO9?=
 =?us-ascii?Q?7Y6DlJtcrKhEDzDf9RXlJOpyrSOuLH9K/NF295tc4lDp582GGvnbFnIl64gI?=
 =?us-ascii?Q?lPkvT6qqAENJbBi21S8YKUVlrnwpnZ6Z7zYEXfQBE5TpgetJss91DBKOuZnx?=
 =?us-ascii?Q?H7I8F2xFiDiu63KuNda71RzbxFfqsMlxfXG4bFvaciQkCVIUSrFZ51BUWrG2?=
 =?us-ascii?Q?M56VSBVDj4/AQ/pskZI6EHqTi1tn9HZHBHD2ANjN7sl9sX5ox3CCH+4i7+Cm?=
 =?us-ascii?Q?a8bg5EJrKMLIdzKxdvgpf3heUR2DqV7xNpb0JqiDf5qPUWC6aXNfwkWPlQsV?=
 =?us-ascii?Q?OBMTmyGCqJ7vjbpbb1vh16hruayYu/Es/5qwlO9HxKLmcYk8diBwt/y18Aq/?=
 =?us-ascii?Q?Rf4XcqtkgjdpwYpyY/rijiRY5wZRx6NvgF4u7nMDJf1CZPdo08hm4P+JQCk6?=
 =?us-ascii?Q?dI/uxDjORXUF3efKDKeKnyFBdMOCm1/Pmv1a+WvJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NeYrrWADk+esoYV/YivBWg+ucHnaiC2c9lmtkXQi465Ic8XpIyJfVV/zrrx5F2v5OACrLtRSkpLgK+5T8pBLmpYtkzmEAiIHcbyPDfQosj+Xz9DBVRBh8VaDQG5NpgDGUKalgkjhmjRpoDzXnoi2ZnVtNohBn35l1JvwPTmMYLLhfZzg4q4JBUpIUp7l9jAwtEAWsMR3ts7X5iyRyEFGE05BSWx6kj7Do/rp/bCYXEQYg8HZs3Psb0KMgivmNcWFyoKi6rtbzzv4RCAlUvaLDWSUSuWTcs1RtmvL0fsnunkg3Wago1tJUx3iPIK5q4gRqeduc05wLglX6P8rM7/6+Jb4gMTfZQCdl5W1CbBmweUIgujJBrEhWZwDg7vRbwsTzP5Ny3yjvMdGxPtkKFCu3EGAEEFCihSt+ITIrUDaCIuE+3pZHnY0AGlX+cD46udaNfS6Bm4aK9ieKPaXHAEMQ9Z+RJxq8Lv2iGoRZJQfV/TfUWF3nfR9E8eSVRIbY3UYUsick0b3+L57XWt6gB5QaOcJP4zLbYjpNpiMwsp5hP18VqyyeWWKPFt3F237ZlwNElT50Ueg4BQqNBtI02jOLivRmJ2TfnisIN0k2aNFcsDJ1tCu/Ml4mVHXJUE6U9mJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825dd364-56bf-4b72-9278-08dc86bb3082
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 06:29:31.0609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nrMoKARQuPRCXAoJzIBP54Nzbn+QcB9vhs3WoVfcQIbOnXL5FbgMHcIAL8zi6ynUAKX4oBChAny9S4QjMBtOGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9263

> Recently it was reported that Kingston DataTraveler G2 USB devices are un=
usable
> with 6.9.x kernels. Hence this patch that skips reading the IO hints VPD =
page for
> these USB devices.
>=20
> Cc: Joao Machado <jocrismachado@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
> Reported-by: Joao Machado <jocrismachado@gmail.com>
> Closes: https://lore.kernel.org/linux-
> scsi/CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmai
> l.com/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_devinfo.c | 1 +
>  drivers/scsi/sd.c           | 4 ++++
>  include/scsi/scsi_devinfo.h | 4 +++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c in=
dex
> a7071e71389e..85111e14c53b 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -197,6 +197,7 @@ static struct {
>         {"INSITE", "I325VM", NULL, BLIST_KEY},
>         {"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
>         {"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE |
> BLIST_INQUIRY_36},
> +       {"Kingston", "DataTraveler G2", NULL, BLIST_SKIP_IO_HINTS},
>         {"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
>         {"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
>         {"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES}, diff --=
git
The comment above __initdata say:
"...
* Do not add to this list, use the command line or proc interface to add
 * to the scsi_dev_info_list. This table will eventually go away.
..."

Thanks,
Avri

> a/drivers/scsi/sd.c b/drivers/scsi/sd.c index 3a43e2209751..fcf3d7730466
> 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -63,6 +63,7 @@
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_device.h>
> +#include <scsi/scsi_devinfo.h>
>  #include <scsi/scsi_driver.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_host.h>
> @@ -3117,6 +3118,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp=
,
> unsigned char *buffer)
>         struct scsi_mode_data data;
>         int res;
>=20
> +       if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
> +               return;
> +
>         res =3D scsi_mode_sense(sdp, /*dbd=3D*/0x8, /*modepage=3D*/0x0a,
>                               /*subpage=3D*/0x05, buffer, SD_BUF_SIZE, SD=
_TIMEOUT,
>                               sdkp->max_retries, &data, &sshdr); diff --g=
it
> a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h index
> 6b548dc2c496..fa8721e49dec 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -69,8 +69,10 @@
>  #define BLIST_RETRY_ITF                ((__force blist_flags_t)(1ULL << =
32))
>  /* Always retry ABORTED_COMMAND with ASC 0xc1 */
>  #define BLIST_RETRY_ASC_C1     ((__force blist_flags_t)(1ULL << 33))
> +/* Do not read the I/O hints mode page */
> +#define BLIST_SKIP_IO_HINTS    ((__force blist_flags_t)(1ULL << 34))
>=20
> -#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
> +#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS
>=20
>  #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
>                                (__force blist_flags_t) \

