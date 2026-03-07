Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525371917F1;
	Sat,  7 Mar 2026 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772906522; cv=fail; b=Wn8sy926DmWAFrPLn1Fp5rkYaTtPe7HEzgMZK87HTZLST+IX5IvBT5BibmotmHOQHnL6KS4FoBx7KqKEpm63WEIa98xyFOX2goV4R1eHTErjL6Z4jd6Gnl1dZynFXjJacy0z+7nGvVr8sB4+tpw0SsIuHcXOmfzyfF3am0t0MeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772906522; c=relaxed/simple;
	bh=zHOVWej3smznJ1E0fEe9A8xHiYh9/wN1nS/9v05thD8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=P9JKgyhUEhATqbjqlRJapkB2nd283ccldzX9YQDCt0MkhsJQcz88rvXpu8nQZMakbLKL3pp9FDQIurJt0mlJpCuc5z5Qx6L0lHg33j75gpIXSLW4orNeYruwzVd86r6EWbMBDriRTWu6OXHfjnTjZ8PuevZoSsvoxYrsfWTNkOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bFk0TZ3C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=soDi83fV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bFk0TZ3C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="soDi83fV"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627I1TgB3804501;
	Sat, 7 Mar 2026 18:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qO5EF5QzSDbMuBjjeR
	lpfRn1O0QKLY2MN1L5/v+5ByI=; b=bFk0TZ3C7SXRtRP7uLjcScqS/BcJjl5aZ6
	lKtt/zFtffIPAvF58ZsC/fwuDW5KY3hiHcnoAhHRQiQToG0h7u7KNiarbq4e8Ny4
	TUj3oes4AeackOiG3qUTfBOBNJdsF7OiUZSuFtnEoLZKaN9bZX6dkEkKEEczOGV/
	LavfLJP1Kk+cRu5L1HEPe4Y6BiR6Mifv6ENjm3uxdu4hSDoQ74wSxtA5OF0oMcQx
	p3vR7SxJayRx//bzNfJQfyse13dysT2wrqhH1LGDfn0j6GWYLjSIYF6+Zs/vY0im
	T5KMm0QFf4cHL81cN/SHHq349Q5ZGWRrzJE4TfDGSY9Kf/ohOY5Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crrx6g007-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 18:01:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627HufcR012887;
	Sat, 7 Mar 2026 18:01:28 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013032.outbound.protection.outlook.com [40.107.201.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbrqur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 18:01:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QcMDX8RGz1050FpyGzdJd1RGNl1pXMju/EH9E/iTbgjPyJrXDlPwhvzAtTVYgVqy8sNDlu/wZ/XjCKxcFIWgdAV/Sny/WJxXoTmTdXgoyhkdHA9Lwn/lyFQeO0yL8xdfWRfTQdRDhUY2F4iOIcxGvCXS3CUeAUYjLLD3+DrC1Bj2Q4gD62HjyV6AWQH9FjA9QVZJnG5X0Zl+9KvmqCwpH2YOTFw31wixMnBN0yNH2x5dywWafsJPp5husalBW57fGYBXTOVM92Rn6EY2viUk7YfX4FcAg7YeCTOdfo6wycJoAiqrXy7wyBgSaOuaYYcEewJ/ORyAx9YAGPbdJw/hwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qO5EF5QzSDbMuBjjeRlpfRn1O0QKLY2MN1L5/v+5ByI=;
 b=iiyy+gigoVY63ni6SOblo3Cv00+layeCmix4PeNx0P6qe9+XQdTvX5ly+lE2oa17zkL1s/KTFl6OLit38xXvFTN7vdejX/tIA6myoCaeSBKdnX9DxpKvuwzZpeIj5Ipp/kAYsqLMSEDJ1xBGlH8rGLoLblq3ZTD4ge55IeQxQ8GEnv8uGGV+v1zkOy7lJALj3Y+MSTYk53nYAEQSifcLK43lLFrNEtJRFP6mytNh5Wc5cPqYY4hHFJGb58dbrjT/xyILHxnLKbG9sYEeB7ZAwTDw2QIYiGVmImWgu+HDQ1meVxlPnneOQj0fJ8bCmGwOzQLp+CtEmHmkwTk3E34svw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qO5EF5QzSDbMuBjjeRlpfRn1O0QKLY2MN1L5/v+5ByI=;
 b=soDi83fV/a8WTqADDl76ISEjbe2k43zf7kBcNJFw/36mRRQZ7YAHs0Sd8273VKUBy1POX3mV0tio6m8D/m1y1cQS6JZvyOmA+FTOikLyOzgOJJbxt6ffeytdYp3WzJLKR+9a49t2Q8l6Jp0qBO93vTRlCpV/H+x6nFC4vYoP7/g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7037.namprd10.prod.outlook.com (2603:10b6:a03:4c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Sat, 7 Mar
 2026 18:01:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 18:01:19 +0000
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Rob Herring <robh@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James
 E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        Philipp Zabel
 <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark
 Brown <broonie@kernel.org>,
        Chaotian Jing <Chaotian.Jing@mediatek.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Louis-Alexis Eyraud
 <louisalexis.eyraud@collabora.com>,
        kernel@collabora.com, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
        Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v9 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <4089450.ElGaqSPkdT@workhorse> (Nicolas Frattaroli's message of
	"Fri, 06 Mar 2026 19:37:02 +0100")
Organization: Oracle Corporation
Message-ID: <yq14imrwp3z.fsf@ca-mkp.ca.oracle.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
	<20260306-mt8196-ufs-v9-3-55b073f7a830@collabora.com>
	<20260306163305.GA2680515-robh@kernel.org>
	<4089450.ElGaqSPkdT@workhorse>
Date: Sat, 07 Mar 2026 13:01:17 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0059.namprd14.prod.outlook.com
 (2603:10b6:610:56::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7037:EE_
X-MS-Office365-Filtering-Correlation-Id: fb565a3d-f2a9-4928-136f-08de7c73887b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	ZyPtggGVgx8HUD1t8+wzmPJHwW0d49NzDpGyvC6CEV3DM213bB731FLk5hHQPKaRQ2vmb3O4vytq23xuDfak9xbo33Z53E0xLIY0XoG04KF7VjU8pqukwu5Fj0idkF9HIoDaajrULsZwi89P6bgAPq9XpzHOdoOggzYy2US9wSQtdduJEQr6bQ6ODzULUaDezLqaH7WxN7OLH/P0Tcph3Ew+FDhd6+sDqyoZ0YN+W6MMM7FI0pTkKo+hPO13YubnW+McNCh0/yafJDRpWQeAiYdqcXupKllirRhA7TeM8H+d0KX6cAiQllRGqoX4nqpf0HcRIhlPjbDwXXF7aJ94Tv18qFICA4RtCCR+3QiVnyn6ACrpQbytbQasVeV0ehdGNdONqLrOQhNSy7TSMNcAXLsZ1CpqMq+VYngiruNIMmoYu+YZAFQdJvkkgBhjhLuTvKNTyIHWTYZXMmoT/u1Qs7jMev0htNnnCxxaFeY11vpl+Sfaz4O6SIw5CA6aZ7JaPrJrjPArwvX5Pqmzmabh03+6weTFR2UMuuMaDBXLet6nQMsowX2ca3fnwOh7TcF4ijL/3LfTUc6XRQ3Phze+UTSt8bCUkRUB3pUiGlPcIru/MwcoKO62hOlUFo2hQDQaQVDFhjVyFpdwK+vkxFvhXZ1UtvQxAkWLguknL5vEiL9SpFaqnYkO1ZGZ02rSntO+IkWbi7FzjUZNFSygi1mQehd/hldk/k0xkm65o548XxQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KWG43+Pf2dvrJ4CvzrkqpEyrmdeKNnqqeWgelwTddXIWJDfz6KFDohkTGGjc?=
 =?us-ascii?Q?vPzwDwqMJUUch3dmS73QYvdXSCYtNiQlWgb6rHkThrVdQ4Ibqi1OI3jePi5d?=
 =?us-ascii?Q?s7yRa7a7rrxvN1tf0LihvkFX7u2lbzemMt7MIpToCdjFiUzFrbYY3eJwh/fQ?=
 =?us-ascii?Q?iG1WRo0iLWVN2C5z/9KwoDZ6lll6B6nBfd1dUeiuJb0KuwneCKHBHUlmZ/PG?=
 =?us-ascii?Q?KKEiq042BgBNB8coaljvod2lBZWIk45O75u9fMkhly3SFRm+ItGJcHeFQR+m?=
 =?us-ascii?Q?np1SZcJvR8Yic0e0PLNVC1V20t8wjIGWJJ+2WNn+nqSTCiX4+UAxNUa2Jn0h?=
 =?us-ascii?Q?ODDUrSQ3lwPyX9PDx8vJRXkpmjSlRdE1XYekBj+fOdNXzLOQr0h+XgvI1QOq?=
 =?us-ascii?Q?k2n9/4yU6doV9FFFUWq4Iw3BtLVIt7NRPRm7VCKqUvu5W21c43Jjr+dPHjZj?=
 =?us-ascii?Q?DmwtiTV4cCLwYCZqecypu1U4c9YGaUk7aeXJ3wAfA47SCUzS2qUJBwBfyy0Y?=
 =?us-ascii?Q?5LI3Q1J4rQ+AsLsxm+y5UUKPb2s2RqGZ5OzAhvnjVn3etwW0NyUEe4w44tMy?=
 =?us-ascii?Q?V2RNcUxZPCQyP+GEWfXdmzh4jVzcfpecy7WnlS8QceagyOQFINGyy6B8mqSk?=
 =?us-ascii?Q?a2GBwvtsQWXb8+VlDlY6mCKc43VJsT8SC5BFDeFdWvMdKpK+Zv6TdE5K0Ehe?=
 =?us-ascii?Q?JYdwKTOzbvW+Q8RbURVzyjIBddQo4VWKkmm7QILR7ckojBK20e6zE2XyV1iR?=
 =?us-ascii?Q?dewYWdUyQcEygHWj80QJ5jYO35VSsSmEi7WwBLbp64Gv02AChEYynCYr3l7U?=
 =?us-ascii?Q?fL4nuETjRh5sSiLfhajr2ENbtinroWKrVsCaFqKHz3l4AtjFVASgBc+Fwc8S?=
 =?us-ascii?Q?kNXmR/ySDB5T/NgsgAi1Shg4h1FFSJf7ID4wPEcjGgFp1vvDvJHelTxhNpmF?=
 =?us-ascii?Q?ScNpYo5fCxXVoffJUOyaVBUzFH+iREmPSuf3SqRMkviZuy8N2/zpHdhVmWvW?=
 =?us-ascii?Q?3pYvd2XX19civeRG4faMvg1Rxpv3pT+8mQQeKMFr203E4R+FO/m5SDhsMQgW?=
 =?us-ascii?Q?kyOfJxysCh6PZi17UFkURHbb34AlMEZAjPNGgbdRumU+rynS592Cgn0hYVzd?=
 =?us-ascii?Q?DbuZ1QRUbhwSUnPfr/xF51PsqyqiT0PqM2yXEUe/FWUBdz7TAcroE78y6x+r?=
 =?us-ascii?Q?6GbZeiV908xAVMOVY1O3a5OJT9m3kcdhn6fMBrCcEEL6OJAoDbTzbfmvGIQt?=
 =?us-ascii?Q?b6/NQNDjE1ozQL1B1vBuUVYK/QxiBHMykP61De1IBvCECTJHLEjmrYchPh2J?=
 =?us-ascii?Q?+77vtmkaSfgNnROxreWKhH1TMemEN0Dwd1TmVlhi6OhpFx2PJ6+mwKVKRkpN?=
 =?us-ascii?Q?Wm4wRMbfI0/Rygz5KzSiPvWLwziA9flA/MaCjjhG50CIlOcJfH2pFNZfbqKU?=
 =?us-ascii?Q?t6xcvZzRqfYlH2hsaD+vADv3i93+tpbzH/3y8jttgPKRnT+5SxSNbFe699Db?=
 =?us-ascii?Q?TnTT/z8R3rwGNC0uSTmjNgvs6PLYQyNhEjcAsGPCuobprEEt0rjSc3TKQJ+J?=
 =?us-ascii?Q?jnOjTLBcLiqY9E28RIzgQuLOHMn7oHlSdiG/FjluicioB3waWLSkkb2nKEh1?=
 =?us-ascii?Q?jDUCgBSO0eUzZqEMVGtY4rkOcijuyq0QFhPAgGylu4YO9gpAmOmzp3OWGjP7?=
 =?us-ascii?Q?Jbg6RO+Gqua8KHnFotrl5REbPmbi41uIlQCQU9fzyI/jz+8L8xqJWp9DHRGl?=
 =?us-ascii?Q?15mwAZP6wacwRmz7FBL/AAPdUWZW7CE=3D?=
X-Exchange-RoutingPolicyChecked:
	r2Bh8Ge+0H6/1fNkeZsovptyFI0hzcFLhZ21GF6icb9P/RpmEskO2QWjlShzMicYBbYOGuh+v68OfA0GozfJxIm/memkeKSykx4yV3RwFpAqzLG5S/sleTXtACzHPL4myay7tAd9TwvmjipIEsSYysEO2m2bnHc7tPleFcJ1va05wpiYCYzCe8baZP7/aJNAdX3SAjEhb8psVsLFLIN4wcwu3Kg9nBss+OYnXns33llwcU4NDNOvyDsqTzxlSli6Of2x7oQDfXHQXVfmUw54LhdPFfVOGzrroJ6zcQ/0IHvPRioY0GSd/o6IKD+1F4ZYbJ8xrUvyy/9Fxx1jWl6SiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	efkepFJeg95Owt8u+XlpQ49cywgnEDpB0RFUXGcZgY7RvosLY9xDFaUJm8DEw7Y/F0ipCRCLXP1e3mXT+niuzmqE8kYkMixN3iVJTwLLgIoHplUOPrWggynkaF2FxYGO/wPUovzX20Do4b0IgefylnjwL22YC+2n5o0YkW96obMLjmohs4XF++3/TIv0EwwfaDcBVxChTt7VgqlKi3or29b+Dmxi53dmR9ltBIJZaWdox9hC/i2jwGcONqWFrh0ozVmEv20Yl5WsjWOIBjn9f6S8v8VCC3aHqu+7L8GxN3sQRqxSx0zWMWc3cbAOuxCLF+vOlaFFosb8/n8olxGNvgj04kN6/pMMRX4lzR3wkXpTBzDklSqnbMywbWMhXSRf08dsL2bxL9nx//Jyq4PArt15zu1vbynBJu4Xw8MWDN7vTlB25Q0dp3G67JzSgnjj3+KFjVUt4RRRsGxxbL9p2P896C1STAs8mPwnoLUXE7d4op3AcpiYyGlPnm/EKAqhaMAdoccCUyhZSibXzpSNnlYWJuVYu8/9J8aGs7IgmoRdjWlMyTzhFtNrIqbaj5L9X7Kg37TpA/9VYaDSv5ThPJGQGGN1PDLe2DJ/p2zDd9A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb565a3d-f2a9-4928-136f-08de7c73887b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 18:01:18.8176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxPA/7iym1eGHkueANR5JOq2mHywY8n4FJmHaxAGUwBqml+kurJOgNu5HTdkf8R6vD4Vmo6uBitJZHtSTnoW8kkdyhmKc9ELGgwehD4jU5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_06,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=574 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070170
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE3MCBTYWx0ZWRfXyZxUOIc4Zhny
 xb5Pj2xdanHxoiDISCJlDbjaZqPOaXv66EV6vzgn3fvPoSZVrOnrXDBq1k6LsjE8H5OEi+NnRms
 Vw2SwsdUOazpwZ6TDXFrgdM9713WjRVAg7ZwiUg/Q0PT9FvI7b51wQCkHY/I4Nir6htUvnkX/ky
 1kQtjWSKP5tNzNFnHrFs527TRI3z/kmDgcJCexfXXbOg8cBwyRcZjp9tL9WqePhfj0BmUui6ZTC
 proXkqzx89qX/XUjkBxcK/coGpmMWGFRlEBm7Zs1WIXz2PiFU2B6gt2i0nhGkrUwW7X6/AXHJ5C
 6hGj/sFWBqJEIsWaDI20rmWpYNP6tBtYxPJm0J1z+dQMc4Evm5CZ1PrL5m9XaZoX2ATvEvbBbMd
 cz7+TJuK0fSbYOV5hoX8k0iLRZzo3OxHGw5DTMPtAW6QtC82VMPzdw8TUGv8qd13E7nQJyfDPr4
 dpBTExoiej6U4rsBS3hmPXlsw6S5ET33aGLpl/aM=
X-Proofpoint-GUID: 8sMbPKye09k7zMknwpWkKbl365H1o6JP
X-Proofpoint-ORIG-GUID: 8sMbPKye09k7zMknwpWkKbl365H1o6JP
X-Authority-Analysis: v=2.4 cv=BqmQAIX5 c=1 sm=1 tr=0 ts=69ac67f9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=CslV5lx4VL2Be9-TwssA:9 cc=ntf awl=host:13812


Nicolas,

>> "ufs" is redundant as all the clocks are for UFS. Same comment on prior 
>> patch.
>
> Is this naming a big enough concern to block this series with two
> explicit acks on this patch that fixes a wholly broken and useless
> binding?

It is if it comes from one of the DT maintainers.

> I am trying to put out this dumpster fire of a downstream turd that
> made its way into mainline as the review process has been completely
> subverted, and is only getting worse with each passing month

This has to stop. Please read Documentation/process/code-of-conduct.rst.

-- 
Martin K. Petersen
