Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19B53770B;
	Wed,  1 Oct 2025 10:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313003; cv=fail; b=E46oUteLSJnOOMcGo9QbnQ2wIeGpPUqRYeVQ9dcYq0OulrLmGJHH3942aznkEsRhqNJ/93C8bb28CFXQMrUOTWwEcZ+gs47KKDq0tpk+inSWxmooCgDdhNFrR7IFouGWLdtUxbGxiGPTLnDr0qbcqdaBjQ4JaHczTtfCfN4liOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313003; c=relaxed/simple;
	bh=M0XjSS/ra/y3o1Nz56ufEAip1uQT2hkVLTW4T1XmurY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s3+QhKpKsibFn9QxBaqD2YvNOFVJ5uMVOcUKMbggp9U6lSW4n0JI5/pyf/jD5T0y93mc/hcjk7KXTIBTn5NO4CbvopKxZ6n24blTRb9M9ojB0VIVwsAdtOmcKQxGz/9Uett3aEGm1ICch5eP7LdY81+lPb5f3p9jrnpkXvctdBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=Z0WSvkvt; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="Z0WSvkvt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1759313001; x=1790849001;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M0XjSS/ra/y3o1Nz56ufEAip1uQT2hkVLTW4T1XmurY=;
  b=Z0WSvkvtfPiYzREQWcLcN/dJmd71LmLZN3C7FKrVC3OqKTohuDF0/ssq
   CbDeT0bJhEIAMSBYrwN62Nx17xwKw1ayd0x/R7VvjddFllp01wnyXF2kc
   vZi3dVe5aqmD/Q3f5avHEE42UHH8OnUaIa8QixS+AFmF7vZSa0CAKbEJj
   UxIXpL8Km1WCGRyicbSmTVhLLZlfZAmeTUMM0fX0hVT68ZW3AUGrcJ9r5
   fHi0byLQVY4EwX68HSTYsiVkdVwbLGze9pkaNXVDzMXQ0Wn9i2NDIBPUx
   UTCwv8YLj4nwB/nQOKA/8Y7TyhsPjpLz9ddhp7Cs31HcbnyV7tO9YhRZB
   g==;
X-CSE-ConnectionGUID: ++xoqSYDSmSqoIvhaw63sA==
X-CSE-MsgGUID: S69DqacYTSy6lw4bSekiEA==
Received: from mail-eastusazon11022083.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.83])
  by ob1.hc6817-7.iphmx.com with ESMTP; 01 Oct 2025 03:03:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cxo97R9fqjfgfWR8cXpAfNEQ6MsTyzq4Cet/g1vz/7aoRR/QAXQNXwcBPuSe+9W6Sot7Io34tGkUbvofx6GvM9gFRg2NAinENavCEYREA0Q2Mt0AQuF7QQ23jRLedenEeuVn60TqeYat4UK3OGbAJpWiE6RPO0Yo27P03bzPsAIw7SIK08f7rv3uXUqTsAJYRMdUtq8FzMBv1+8syyBF5uclULTa/OSlwlUO17HN462+PtGHwpYElVMSrYZI/+0sAOlFQO+skyBZVljydPslFsigjmizP9hR+FWuT4A5vcxN7GkW4YrdbK+rmGCcygwsyWrQqDd+MY6LACfDqqTYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yPVAjRjLA9P3Vd8/yvDEMbrzmY8uWij4zOLJb4RBEI=;
 b=P0PTNVL2M0K7qar6Efu6MZKr/zHVIgjr7DjaMZzSnvpYZ/vL4vk8VJiz02oP0idOed0MAQCf3o7HOTqXowkW0jQAbkq02nXHV+eT1C6hyGM7I3e1pFZDKkB4ApYidZUR0yUbmVQ9kxpCHeckknIf5GrP4lkVzD7LmL+XESgv5TeJ+XpTnhEg+ybFBNiQQI0rvH2qwlBqTumwGLjzJQU3kO/hD7U3zP3KHORkGrkMAVLxPdKqmaY8QnwLFdplilLbdG/ZuqMmuJEQcjZjrBx2mLeoN6T1KBj0/HFNlVX9dKDqNCgsC2fznpaiiZQEuZ/uh1c+5n5wXvgNQ4m1MBTp3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BY1PR16MB6506.namprd16.prod.outlook.com (2603:10b6:a03:4a4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 10:03:11 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 10:03:10 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bean Huo <beanhuo@iokpp.de>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] scsi: ufs: core: fix incorrect buffer duplication
 in ufshcd_read_string_desc()
Thread-Topic: [PATCH v2 2/3] scsi: ufs: core: fix incorrect buffer duplication
 in ufshcd_read_string_desc()
Thread-Index: AQHcMpnl9D8Ce3jrOkas4ClK0jYxpbStDptQ
Date: Wed, 1 Oct 2025 10:03:10 +0000
Message-ID:
 <PH7PR16MB6196EB54F847DD32DE097770E5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
 <20251001060805.26462-3-beanhuo@iokpp.de>
In-Reply-To: <20251001060805.26462-3-beanhuo@iokpp.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BY1PR16MB6506:EE_
x-ms-office365-filtering-correlation-id: c4446516-ca9a-47da-704a-08de00d1ba2d
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?g8QYqAwgAZWGRf6uDMwSq9Wq5XKF8XmeD/RYdLMNqJZXixA6sVur1cemmFbp?=
 =?us-ascii?Q?QQb7CTGeFcCx8KlFMrj+5dmzDj/oNqK28B4QM73ZTmN1NLQKVmTfeJ0whp1P?=
 =?us-ascii?Q?ti9dn0DwN402FvRfT8spds24mQT6+MSAjHesj0uee44twA54isek5sJ4xVJC?=
 =?us-ascii?Q?cbeIZd8rdHRjZBXCbTmQlnB+q40ShzDJhsoP2bzv9DjjJ3OZYzV2Wujx4nkS?=
 =?us-ascii?Q?YMLaP0sEmaA9KQrpSMnD3WqwNXmFXaHn/fSa92ngA14xz73MAKHk1usmkppu?=
 =?us-ascii?Q?qQ0rC19w9i4lgvTD07dcFRxREeIz2o8wTYqSB8gtoxmteKP+XhxU30xgLeJk?=
 =?us-ascii?Q?/vtNrZ0hFTHO2ZTeVlnj1a5N7Ru+LV5gDpPNYv2eLX7Yz96H2XpoxCFjxJQw?=
 =?us-ascii?Q?vCG99iXm3xv6USQpjVF1dtUXFLa3XuDp3g5BUSL0DfzIq4N35n1dhBOmrLka?=
 =?us-ascii?Q?ZvngUNJ4CZZjVal/rE/cro3hZkeCX+02/psIhdSWsCKxctkpAuwzLBBkguJo?=
 =?us-ascii?Q?4TEpNYY88/OrDEjOq2H8EVZmPOmlZ6FLG8FQUnWJ+sBebPX5+kuYwqOpury2?=
 =?us-ascii?Q?GbXghseZ4VYA1qsImwpIStreJ7Mi2cEUbra26NaMGR4+1PuecyEtmVP+Hbei?=
 =?us-ascii?Q?wCuhAy5rGM/y90DEbiTihNr+z9Qx8M/N9ShXJPhSnMdcQyDRvU+hkaY41wNG?=
 =?us-ascii?Q?ArforhhlKmotF5ozGskbOULleowhuJbmD7kO7LXbbNlNeTUlG9P+TdvoComa?=
 =?us-ascii?Q?BCFnm8qUpfp2ShUq4a6scThMKRnZynp2odmfRoKZDFkE/nvFi8BsjX4tipeO?=
 =?us-ascii?Q?pzvGCdq8K0desWFs/yGZkI2cjIoB437+SScwlpPij5vRWW/R6Rh3TfSVVaui?=
 =?us-ascii?Q?2IZM4qvcVzGr+iGj1mH2Yq+gGZkzE7wvzXh9hJyeCCJfIgCsW9H1y8YlxC4O?=
 =?us-ascii?Q?q2M2QaEXWIUdOhlCRBFAbNeH2BkMkyANO6E4Ww+WeNjiosMrtyzP8yo9qg3N?=
 =?us-ascii?Q?BnY31jRphXMU14zO23jnZrXMR2ZJ09paWtbNYkkuECtkZUfakI4IvNY6Ol6T?=
 =?us-ascii?Q?AvikRm9JPzjCdxbz4rkUIfzURgMZHRj9PH+O5WUVuwprs1oXHJOTdEVk3mxo?=
 =?us-ascii?Q?va2OD47uo9j/sHGZvFtZBwExo9NNDxP/v4l0CI4XjR/ntAI15LH0WYfr6xZz?=
 =?us-ascii?Q?AdR1jz9TmRdff+oHAeluR6FgwdbbI0K26Ex1su5n4jSM0EjKxHl8Tr8A4oZU?=
 =?us-ascii?Q?qQ1KYcdjAoS/WyO8UM/QfLSK4DJK4eGOCRvp81T9yt0Y3wGoh295Z+NBX8Mg?=
 =?us-ascii?Q?UI4TWmeF0ZKy5sBAythINwTWknRVl0CfzI2TsqRDXiyrzQU6hJrvsXYuKRjt?=
 =?us-ascii?Q?m6/ddNimj9kJ4953h6KPnN/Ov4w3jIxIsLlz+8I+4LwoY4rEniRGUtd24GPU?=
 =?us-ascii?Q?WwxG9MqPz98nRejCSTt94OZ/1hBF15nbaBCjtYG6Jg1SHDwkVTVwlC8z3oe8?=
 =?us-ascii?Q?t2xSVmHK6coRci5LSxTr0ywQNEkkIyqFBE9ivt8RbgBnwJBN/TBZjui69g?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KGeUQ+mh4yTSvYs+r1Nx14s3ptOnvQBDpmzSauP9a9B5lw/nBQvxIir1c51m?=
 =?us-ascii?Q?CFgkSymDLy1w/zq/nMTXlTWwU1YfK4I9OPdwew2MZ3A/x4qM7tINNaEKSdeK?=
 =?us-ascii?Q?92zgcP6L92GzLDP7TtELaPGWjShGXD7tgahpV2V/Tk1hhIwcsLzwE/mmO3U0?=
 =?us-ascii?Q?eo7DECVb/ZA7yQZ8ntQ71kW2phzwFMWhCXvAGbKw7GTvaojOcQQVZvdIgYwC?=
 =?us-ascii?Q?1xHihIn+9weANa08CfgVU/6kN8cD/q70AgTdI7GxUzCeBfxv1LigVxtCMpZu?=
 =?us-ascii?Q?DaOdwENEeqTNMBLMEB2qtGkctGFDA8tVRORoaH1G3X5FFlXh96dMg/tVbcjy?=
 =?us-ascii?Q?4qM0rQKnlYhdpQbiY+InK5MZg0L42iU3+b925gwmp51pVIu6qRRPM6vay5XP?=
 =?us-ascii?Q?jP9+QHGufw6k0GT9BOvPs/QQn0V3HtNouW7JME+EYSP25wAhRnm8Ul8Cghzj?=
 =?us-ascii?Q?Ie8tAgF0ymPXSWzDl3fQzQXngx8d7+E/POOalxU6P+i4Z2lzDHSR5whM/aEc?=
 =?us-ascii?Q?CYKKQWvjNRI6lOrw42Xsx0hNs7XxHaTPHuBxzOmSoRUn7lDXSlubZaPjYp7h?=
 =?us-ascii?Q?atigebMzAPLFQNWtcXNpH0SQuI+VmJXp80RdyLf/fYWtrEeeTcUhVgaDml2E?=
 =?us-ascii?Q?BpxNr1n8hsBpJBMklp72fYxGI952L7HsWwcynnyaP5tSoac97dsMnVjKjY9A?=
 =?us-ascii?Q?4KDxjjqTP/wQ8RAf73GWFux5TBeUg1d72FDio6n6fwjDiXN25EFDTOc2a802?=
 =?us-ascii?Q?08Pt2Ne+FjYGdM3BDyy2GvEMLuF7RZN+Tkq0yNVuD92YYjsKKtdhnMHY/hi7?=
 =?us-ascii?Q?Sc68YKCMQy/Ke7KoQ0bomU5iySB7UXgn0KD7d9o9+tskth5HfXrmvoUfr4a2?=
 =?us-ascii?Q?9LbYnLoslPbC6C6NhXe34Lvzh5I9UMo7oKNmqzkO/Col6ofa+ffyjUUtUw66?=
 =?us-ascii?Q?QdqOy7UsO/gX9uXJJV/YmS4lQY9LRrWWHNUXeK8YdnGADS56FoRws25ALo/h?=
 =?us-ascii?Q?WyNn//xe4urgu4iYaqLsvXW9TrqHXsiJJn4hwHo7biI4P8D/WuIqB3NJLtCw?=
 =?us-ascii?Q?Q0HolRvf1gSGMryFrWn0/3ChNTaO5VeBN8rAtST6VLh03Cc9F7tQuQ0jA8/4?=
 =?us-ascii?Q?LB3xtZTyx5Wp/AJnTtByIK8Ee5az5kNOVudrOhOZjbd/KD4WjGwJaw8GC8Bm?=
 =?us-ascii?Q?/+0/Xw7qcNcWmdMQj4ICkO/Nflt04aTyy1UY/8ce62vASA046Xx18w0OtXwY?=
 =?us-ascii?Q?KZCkWEwQXt/XJMIlrBumGT5g0HR22jLtRDCiWozgnGnuLzvx1FdJqtji4Fku?=
 =?us-ascii?Q?Qb94O/UxNkzKI7kI6qLc6GJ5FJfq0uKmyt9VzkCTm3YtJzbhpDisM3zLxz1T?=
 =?us-ascii?Q?4Ex8v6fhfw3BFDWfM9qsLHoj/T+HZUfOXjlvYiB+KKkJhWBuiyNXBLfK2sBc?=
 =?us-ascii?Q?xfPfQOdA8Jd7pUetx1G0wLh6foQFdtxE78lk1GnF93TMaSmWnlYMsLbMPSO9?=
 =?us-ascii?Q?qpLXGgIsFUk1byS7M7AhsZVUq/lGYpf0RxEp5qfRXDTtzDC9h+81OLkyGu60?=
 =?us-ascii?Q?T1KBWbeLTp7wjykJXS9/U6/jW2UuxTbDfNRc93lH?=
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
	OSUXVmfNa5VOCFkpxWJJRzsTFRSy01vPYLBAZ05KEJ/4fozrrJuM2FRc+I1Gcyl3t/UR2KZRRviNZl3ycVTUCsDytCikd6g8Sc1KmyMdQHStnvasuO/usfLahV2nRWeJmoM1haaGw9SRcPT9I/SN5EVClJKC+taRtRbhNjTS2tRVU7TihGev2dVGodkXapx/0ROO1O7rJMpw8/PZK4zsmLS8BYWbPcBMvjN1oRiAl167dtRXXMgrtqSA+u3T6PGVNXd4NK7yYgg3wJZCXkfi3OEDdScgK3w+zh57V5HkksvlW7IMUHHadqd9BNAPfCUtzHdoWIQClZGThHUyuYpNVVIzC6DJoflHSSxWVzB7wwYjW3DzoVwceTeQuYvuzZAPbioT51xCIhmLygmWZUKMsZ47dJh80SPdXOmE4Krf9/iquZpKIBjIk8XFpD7YIgCVgQvLYolq7VwK8Fh3/0DGN17BMr1EiA/lsTemrniRzFOSJp9PzMYHdhm5aIf1Qirff8hjHoOAimNWQq9ZSg1lowdIBO5utJf7Fd9wCn4QEhAlGRIQbZl/geafwvKudN7M7sMAbFvc09PGmAFO6w/DeaULIYU7GbJEjQrcq9UUWpUpfRIp3zp8fSzpKMmzhlvtK1bRSClByuWTO8sNbSgZtw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4446516-ca9a-47da-704a-08de00d1ba2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 10:03:10.4683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PDFtR3MzmiD8Fmw3cJUab5vf8Ce3poSFzz/htV3r2Ra9Wluwebez9xKl80A0pOHk0bi1wLiNUGJPH3fUVbxiTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR16MB6506

> From: Bean Huo <beanhuo@micron.com>
>=20
> The function ufshcd_read_string_desc() was duplicating memory starting fr=
om
> the beginning of struct uc_string_id, which included the length and type
> fields. As a result, the allocated buffer contained unwanted metadata in
> addition to the string itself.
>=20
> The correct behavior is to duplicate only the Unicode character array in =
the
> structure. Update the code so that only the actual string content is copi=
ed into
> the new buffer.
2 Nits - only If you'll have another spin:
Nit 1: maybe add one more sentence: This does not imply any ABI change as t=
here are no current callers with SD_RAW
Nit 2: you might want to remove the duplicate definitions of SD_ASCII_STD &=
 SD_RAW

>=20
> Fixes: 5f57704dbcfe ("scsi: ufs: Use kmemdup in ufshcd_read_string_desc()=
")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>


> ---
>  drivers/ufs/core/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 2e1fa8cf83f5..79c7588be28a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3823,7 +3823,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba,
> u8 desc_index,
>                 str[ret++] =3D '\0';
>=20
>         } else {
> -               str =3D kmemdup(uc_str, uc_str->len, GFP_KERNEL);
> +               str =3D kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
>                 if (!str) {
>                         ret =3D -ENOMEM;
>                         goto out;
> --
> 2.34.1

