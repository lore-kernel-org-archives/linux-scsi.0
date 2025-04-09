Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA2E1DC9A3
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 06:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744179906; cv=fail; b=QAjfM0PINCEBT6eWlgjVvUT/ix0O2iy5U/ETgI6G9meuiQhMmGbLXhy2JoBfjy9gMhMVw6zebmYjV38g2wln9iFHjlb+HdPTis2OUmVwXStOxb7C5kJ8RhgW7MiSw/IOum+oEF/uB6vrT1nHGKOrRa+2zMSdJhQdLOmUXCn9Of4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744179906; c=relaxed/simple;
	bh=3kMq9jDjDlYz0fQZUJRbAFSNUYvHQKByOhTaFhv9vw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IgzYT7okIOyvk/EFcLk6aHHsNNAG2lDlOvumeRWi0zlke2hkWHAJ52xirYp9WHav7Il9HVFiVovsrcKxpEovPVJdpfJXQsvsjXGC171xQ4yZeIQku+xi4KBtKLGhq/dap/WkhHA4l2dsTYTHzV7gPeEz1uNpw7t5iPFU9EmCPHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=czJVbPsL; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="czJVbPsL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744179904; x=1775715904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3kMq9jDjDlYz0fQZUJRbAFSNUYvHQKByOhTaFhv9vw8=;
  b=czJVbPsLk30n+P8oSrzZJtiefVIMtE2OZNjBGc5Im4bwoIDqZzptPGbv
   5xpOyrmFgjG5depfrQyiFOAX8QApnq0sKNkTS3xNq8IYuSkaIACIBAvwk
   kfTg2Pq6kj9I+PfQxOijPAsCHXp9ZEU8IBF/aLSgEZBg6bJcbSPuYVyM6
   I+5NfZpYzDAPitOc86Fk8suYQ8KsigVtV4SW9k4i4DVur5uoUXend0d5v
   8MFqc1cECEuD3dsqwjLSwu7TqOtRqaj6LtO4Xv3/1DhnmVYyBPQRtihux
   0OHU/iIBPkLnW5mG+XbfAOB92mf/fJBD9Oeh05xTj2SVjYTfHQ9VHLoC8
   A==;
X-CSE-ConnectionGUID: VaykGgz3QnWaKXyFzncybw==
X-CSE-MsgGUID: ESzKdJbrSPGZqYazawWa6w==
X-IronPort-AV: E=Sophos;i="6.15,199,1739808000"; 
   d="scan'208";a="80362658"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 14:24:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KlKOq5RNMnOkdFw/T/FoV6nLrWI9OwXVTAxCetXSYVBad5djk2K0uWOVOCMOcdlCOvTJ6MiPgFj3rcOl06hz0gYIazCmmHzNDoGD749Wzd5NPwSbIWZPn0lDOtf5K+FjuY8R+CD/g82SjOnfwmmxH7J2kfcY3LY1SCGMR0+cC/S28HeVq4hU+FNaKKk0KZnMs0G0m/iOPec/neO4gdxXD1vryjNw1FTFpMb8DCWTy3IFRFDPCSJDn0WZMi3I0fh2Q+TybUquCEHZ1MtIqWPbvSNkk10ohsvxn+jDFJ1iYtPSqr3P7vU/qQ0Oyju9iBDBCj1k8gIx/7v9ETYFkEXZOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fK2mnNTNnvpCVnkgBReRPwuUyRMFTdZlDA+7OfZnuvw=;
 b=PTBE+ORrl/S+od9eDAwTd+0NeczyX0qKD+ptJtuxjX/6zBmteyi+DIxMNQv5mqY5hTuvM5YAlbddf05MoC8KtVllRRhQxOAq7U3uA6OLw/b08Ll1lqHXqST2nbO4H8hLyzyqqBgAqIbw3+g+b0yGjGkT5SmOrBSEyVFR99Zjl9AoBRDSXRRzLP7Qgo89EOZuwmUsP+eXbqNeh/mDGtlWPM+UqGoBmQKBhwpm+y/clPNtRh09C+pSXCMvWCQbMdMH8quDA3B4HOV8pznUf8pY45cf9L6DAR4dkTKgbNtZhEWoe4kWLi04Cz/PWgbVLcKNd6LT4Akd+KccayrLkHzESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA1PR16MB5152.namprd16.prod.outlook.com (2603:10b6:806:330::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 06:24:55 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 06:24:54 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH 07/24] scsi: ufs: core: Only call
 ufshcd_add_command_trace() for SCSI commands
Thread-Topic: [PATCH 07/24] scsi: ufs: core: Only call
 ufshcd_add_command_trace() for SCSI commands
Thread-Index: AQHbpN5LC/svWhWEP0OR6Ok+EVzXhLOa5lWA
Date: Wed, 9 Apr 2025 06:24:54 +0000
Message-ID:
 <PH7PR16MB6196FE7F1FD8B1217300F7BFE5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-8-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA1PR16MB5152:EE_
x-ms-office365-filtering-correlation-id: a1429ffd-08d3-45d8-88ca-08dd772f3e26
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ECCgnWFo92pSSIpyjUxiyK3slaOufiH/vSlYcy4NFzLmnIP7KuBFJbV5fvFs?=
 =?us-ascii?Q?qJPW3//1j6zNQUSbr+6NseGPcTXvgnmfaoPo/yJZ0+qa0326g8onM3UJgHaM?=
 =?us-ascii?Q?fPvI5VhEtv6H0FLmbebdLSqZfLPxVZCVu7IhFXt3M4VNZ1vByzbcftz8kal4?=
 =?us-ascii?Q?B3386ogf1p1KSDpNMqT8pLppGMpU0axxQRyPQbAUJVEzt6fhw7jkocZSMI+F?=
 =?us-ascii?Q?OGZzBy7gim1zhYuYoFxaUEO+Dx63BNJ/+GMtJFWJGeY7SReONTnxnQKv+vNK?=
 =?us-ascii?Q?GpAG5PKWeDzAfaD3emaSFLnGzHI22e2jX6J60nX317lDJ3+iukoDWf90Us3u?=
 =?us-ascii?Q?DGXeHorsChsJRLWQXbum6G8diSOdfApu6gmkPAKcN+dnspBfWBArgDD3HEiq?=
 =?us-ascii?Q?M1sWLm95/Us6iJlcyFXF4oQQV5IekUj2S6TAIvf9dT24kwhJcgNBhfMAM7H+?=
 =?us-ascii?Q?M3rZ6TdVb+ChJRzGT7zWLYgbVtV7WXxkCpavJdBcsSGy6ulSu8Y6vD2q7Sxm?=
 =?us-ascii?Q?1w9cr/Txeh7uROo5s1vkBylFM5YGbLCc2X7XupXl2MSMMx0BcxXZWQs4S1ZD?=
 =?us-ascii?Q?jKf7FLwhVMT2Ne9OWXjy+b/P6o1bqOErLnY/ZvfSjvTj8QbAcKuysOIDivVI?=
 =?us-ascii?Q?+EtdsoOvXUI61ZhE+yZal8AOWcQAdDbClI1PkhyExKX6xjOMqqL0Zzndvt7C?=
 =?us-ascii?Q?fuy/Yzj0DfEcX/OG9Xk4ILX019TPMNAG0dmwbWLVgSF/tAD57QJGY2Mvv3Sc?=
 =?us-ascii?Q?vYNBZLqP42pMaMjOkzoMqCU2K9aBUplzrWqPoNSHWGtwdIpzR7uO+14aML9y?=
 =?us-ascii?Q?fghPN9AFq5y6wlMBx/bFNx5iEWgn3j2GcbuXAGBzDpws0pSGfey6rqQ4GpEO?=
 =?us-ascii?Q?2mnYsMow6UJOdeWKiuFV8Bvh9lJIMZY3w7TGAihkOTJXwA5jBN3EObT+0nJq?=
 =?us-ascii?Q?tUPOiqSZG2S8VkhU1Nffh0NtR6ZquihyW26XVXlA/8kCUAU5dDCx9B3v8xsA?=
 =?us-ascii?Q?KMwe31ZFxN1VBhG8QYSfg7rQPklnXztzVxx3r2tlttAX0pp2nXddiLr+qKEx?=
 =?us-ascii?Q?CL8DbAshrHJjJ7YjBmYsIU3kMo/+bWQkJEmWYn94FUk0oemrmovAe8W747Sw?=
 =?us-ascii?Q?8myczPjg+gVT8aOPOUxBh9zYiA1ZP+M4XeH0wD/va29JWaEx4VCSjxsRfdKx?=
 =?us-ascii?Q?8lCykId4kOBfpbt1CjzA2KU4B3R94eclImByEmRt2mrJJOdSmhL4S3HXxZlt?=
 =?us-ascii?Q?znE93P2Q8oOi8uqeWoS6fXrqFOyslMCAHAcvzbIwi4oqOOuuPR63YorDuSCq?=
 =?us-ascii?Q?2sALY29+Egcz3XryFE7XVLve3cVIG+6olY4AnKynAZQe7mZHbkS1VLrLoGOz?=
 =?us-ascii?Q?AbcPCengriiAAu+kcpCbOv80EC4guZvsru/jqG4YSVIPJKOTKsGm5l00W6CH?=
 =?us-ascii?Q?LwWiKBKmQz0gM5Utd6S/EuzDTP9vi8dJ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?G2PEuRd2Y3Bc90pLu848kR9mHfEkOcIAl5XuR8q5VqYTjuk3LexO3w2tOwcW?=
 =?us-ascii?Q?JhttZlhMBdLtpkrp1g76lAfMySi2qUBLco9SW3aqkzCFtgMnvy81B2A8Bp1J?=
 =?us-ascii?Q?KlzQ+t+g2lBQj+Xb5+YU2I3DH+yf5Hae3XL+cqUl5Q4CMvTsGAnjy5pqZZ18?=
 =?us-ascii?Q?TsqzgTkNuqioTsXkEIyP8oqmBFxPcj0dnbsGgKZ9bJVsqWx08Z3i9b4LJo4r?=
 =?us-ascii?Q?0uv45q/7mfsgdOUnBb6ZC31njBj4CIJCHMGolzgocOp20JYO+mt76q3PJzCO?=
 =?us-ascii?Q?Z+jirAKTFeP6CoCk47NH0UZMTmf8ZHZAWztIRCqurvahpuiksOVpuQ++N17Z?=
 =?us-ascii?Q?OYjUTJQ5qytvkFXc+0aeBd2lXAU1ZFwp2CJD8mqJm5dFbfFMpTPKYln+u1a5?=
 =?us-ascii?Q?DZ3MeIqIL/Mg2VFMVVV9qaZUe+FaK/cv+lTGC5P7zVT7dokanElHmIJtvDkF?=
 =?us-ascii?Q?1ias3/fZmjs8C3/zsv66f8IE/YKXUW1qo4wYciwWqSAzM0dFucQ+fvZ+MxY7?=
 =?us-ascii?Q?cD5gxV1SISKoL0pMjmnmJ6RKbTz6ceMLKKVlt2ncCoacXl2N7gsrg7671CcE?=
 =?us-ascii?Q?svpVdPwqEyoq5DD0B92EaCPo5REOdrXoGaX136u3IJbPLkaf+ICVOAKG1P1X?=
 =?us-ascii?Q?zdPJin9Iu3HIa4pV7ozWuCJ9/nn8V+YO5cLFvzSnNGcngA3CsV+piFwI9a9m?=
 =?us-ascii?Q?G1yMUiVZ25t8eaNk5NjQr6bvzficmhUXhvwrGAfjrOsaNcdccADyJkP5OQNM?=
 =?us-ascii?Q?v7P5gFVy7rHyNT3nVvtGcnuabmpcT80Z+OKc/bt1CTUtGBV0cCfk3hPzs9P8?=
 =?us-ascii?Q?+BAkCto2cNHzv96ikHWELwFYgrCG/pSUR0NyHw5tlujSF93JAqsRqCNgXuqC?=
 =?us-ascii?Q?b9/+/tbMmmAQpkjzqXHeE+A0G/W62hRFDBZCA5aZQ5yqpyveyxkx8ExWALyb?=
 =?us-ascii?Q?5dDM5FD4yQRF0Gs5A24b9LtEl2fjSBPjpzZlLGgbunHP4d3uIPM9sXWDd04i?=
 =?us-ascii?Q?64f5LMEDz2ckDoSK+aw3uWVtwYuiT+5Mopkh7fB/+dkPPSyGbUo5tkZUqLr4?=
 =?us-ascii?Q?82LCHm/r80K0/Y39OQ3iakJM/jH2PwAdNTX42mataVuk7oxiHI647QqIb+7T?=
 =?us-ascii?Q?ZtPJcZ+HWN1uxHS5cxvSYFpT8gRW67e25PES/PofauYXAl+DyJTQWn9BTfdV?=
 =?us-ascii?Q?upx2VhSUTYHw2RYrnKbrJkxalH9A1WbWtEqQdvsCE/NZzhBpx0VNa2wRe8Fj?=
 =?us-ascii?Q?MVQjkCbdCTY3uV7mG5GheNw+nh0eojTSq8jJklS7+wEVPPLD0tI9WVAZIKGM?=
 =?us-ascii?Q?OCJ2OiWY3i67Z87ri2827hhQpfRUYS1H9QRlBugcvl+Xfk65OlhrRSOy5IO4?=
 =?us-ascii?Q?ijNKN/mHuvH9B1HPs4L9aDB5m2tYi8w7BfR4U5Uv7AnvtK4N0QTry1BBUF9t?=
 =?us-ascii?Q?9xNAQ6kHPEj0WDOJ/feg55e2lldk38ZJuFDo5y2h3qwqbu/0zWen7DzZwde7?=
 =?us-ascii?Q?3JdIqyHr1urStYqp1/TCvnSJbSg/Hc+KR+oZ7Rs2z+qkMZV3kQdopuARSMB9?=
 =?us-ascii?Q?0YUuifMYuOZudfBfIcpxlCzArNfy58zAdQ7BLKAy?=
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
	vXopq9S15cQOzPrvNCOZQ5faPl7ahbRXcX0dOB93tVCzCcvKGj9+DQtlzR5hBfkoNv3PufCxyD0F0lFike9fxvEgwItb1u+25DGK5Z139fB3aLmAe4dd4+mbvJTO5HsPPfNw3GtNnFj+0wWJWfOSD8cUzrvNO6bCTgITWKpVTpGRQjjWWKp2HNFk5i3q2RNiYAYF0FTm1QHwcjjfV58+vX+bX/W5PRsHcIgRmdum2yMpDV5SoFK0cdV0W/IoEo8Wg+uD5FLckl5V82zvxr+klSHHH+a58/l6F1NhyRXZsSzJOMSlHmTp/H88twNmZLG9PwHvxWcg9WLxbtz5ybgDHjFjh8HIdsdXVYITnJxNEvY7TOxnGLonmQDFjuuna/KkpP/GRiD5ENxXM3/vxBolczHeBbxVWHvEK7jw9JzaquFJsLuQHb3qWY5mLyKhILsCd25+YfcoEXMGrENzSh7o4YzK1YXx4lvhEjZ9UsxhOiiot8Wbv2E2urpwVXYWBC6dpjtE/eGJHdCDeNpKKk70Uzls4VlF6DzdYoYGwo3GGjNmFs4ziM36/RDMCaUx8yfD3/m2NTY4DrGD7z5pqle90NEJrat0Kqix29oqLkw0lKq8droMWu8UicPdxX9Og5xm
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1429ffd-08d3-45d8-88ca-08dd772f3e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 06:24:54.6095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uHecGtFec/Sf5gyYJbj7OIdFjFr14s76NCE7veMSnKA3OaTBc1GGSSIfBJp60EWoQbr++TCC4GOsU7JCMBh3EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR16MB5152

> Instead of checking inside ufshcd_add_command_trace() whether 'cmd' point=
s at
> a SCSI command, let the caller perform that check. This patch prepares fo=
r
> removing the lrbp->cmd pointer.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 3b470f564313..94cf864ac62b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -438,9 +438,6 @@ static void ufshcd_add_command_trace(struct ufs_hba
> *hba, unsigned int tag,
>  	struct request *rq =3D scsi_cmd_to_rq(cmd);
>  	int transfer_len =3D -1;
>=20
> -	if (!cmd)
> -		return;
> -
>  	/* trace UPIU also */
>  	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
>  	if (!trace_ufshcd_command_enabled())
> @@ -2309,9 +2306,10 @@ void ufshcd_send_command(struct ufs_hba *hba,
> unsigned int task_tag,
>  	lrbp->issue_time_stamp_local_clock =3D local_clock();
>  	lrbp->compl_time_stamp =3D ktime_set(0, 0);
>  	lrbp->compl_time_stamp_local_clock =3D 0;
> -	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
> -	if (lrbp->cmd)
> +	if (lrbp->cmd) {
> +		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
>  		ufshcd_clk_scaling_start_busy(hba);
> +	}
>  	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>  		ufshcd_start_monitor(hba, lrbp);
>=20
