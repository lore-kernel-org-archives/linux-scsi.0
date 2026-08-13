Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96AE2E88A4;
	Thu, 13 Aug 2026 04:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786596866; cv=fail; b=sj8iePbJUHaTqhGnrzGmeF7YKl4KKQRp3X+g01ZS71eggXz7spxGFsI/AJ7ST0QiHeQSyC0AozWqHIyCWMeONSCcOa2Md1HerwDR9ArVMGjphZX4+Qo6Y/W0jClrn1UY8WauUP3k6G4TtzTbUg3Uehh3gcPWotSC0Sb53dLy0lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786596866; c=relaxed/simple;
	bh=ftELuavy0dsdnV5LBPL8RauxEy61gTFb9EgIfVda+1E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E02fnEXiZyAHgTGYWy3JaGOnxi6vWRI3/7xz97x7ovCzTer2WHF+Vq7ezgOUjdRM+LMvekoHV1qXxdHSrqa+TfSHUd0510rAVY5WSWDB1e5wd2gQIG6bTOlrDd5BM5NK5AKl1BZ+JDfpOkyXIaXA+aoGWw1QGPWnjzPkXkigAkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=HNhs92AK; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="HNhs92AK"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D2KORh4004277;
	Wed, 12 Aug 2026 21:53:21 -0700
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021130.outbound.protection.outlook.com [52.101.62.130])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4g0v4xa6gn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 12 Aug 2026 21:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtCKe26ZsjFkKhGeOyjSkhGpeu/yGrE4eF3gPNZHpBBLai64a7UV9qKgaVsMvSwaUl+VZ8rU6xzStgvGEtx6/+6Mh15wzBpmQt2jxEoPQx7Lqd8J9x4mett2xmbKDv93EY3HCiwwWkdifN87wAhoNk39XW5gBxoMhIV3VW+6kyDkCKaahZUqPRMB28Vc3MR2YlzO56TqdSwPTW1n9zKYsrwAUZ9VkBybfudxstwmD5fauRtLK5Utav1/VX5gShbDGhniuxyW6XEm7SoDExapEa5vv2zfdeZzambisQ0zEDQT2DmHbiv41ucy6eZ+0IACW9uK9UY0a0WR7o9swu0EoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meJHJ7L9HtGthrDdv5wA9A2lv31U2l6JA9UyGXSuZs8=;
 b=EzlBGC8/b4jDd16sCt/b6da4vnIcNvFFoy+BpBue7qiBiyoFlW+TgNEgsdVptoACZ4ot+Lizjw8pRuaqGu22myDMD0GWCpfyt5TZXNwiORdLznN7gY/5Ls5PhXeKSCochelzFf24/yqBeJcvlxJ2BoV4mMiDCp7OL4a2xHQWmo2z9evYL/E6abAk0J/NWDCTY5kvczZnNvTaa/kQ4jWUqvfaR/DAYKY13Za1l3Rg4wNGWJYKSj+1H0LNI8byXgPNn+AqvnDqCTIoQSwH98rtxH7DC95snVEe9DTZAd5YjoTvdM+KlyPO9GbC/MYFqiGHPBAsUVVAzoFpb6zPBRblxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meJHJ7L9HtGthrDdv5wA9A2lv31U2l6JA9UyGXSuZs8=;
 b=HNhs92AKha6ZKLq1qpsHh7TuUh6yc4w1vOLdU9SIwuUTZQKikOH3q8+PYtXKkNvjXUWVo1CtmZ03B6QPxycPqkN7UoOvL8FZggZrJwx/oClXLdLFNDFGnlfLzwNv1wrHuV/RK/m03+X7+aQAraywis1vom61FR67eeep4HtH2nM=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by MN2PR18MB3685.namprd18.prod.outlook.com (2603:10b6:208:26b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 04:53:18 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%2]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 04:53:17 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Jesse Taube <jtaubepe@redhat.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph
 Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Justin Tee
	<justin.tee@broadcom.com>,
        Naresh Gottumukkala
	<nareshgottumukkala83@gmail.com>,
        Paul Ely <paul.ely@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>,
        "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        John Meneghini
	<jmeneghi@redhat.com>,
        Bryan Gurney <bgurney@redhat.com>, Chris Leech
	<cleech@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH 00/13] nvme-fc: FPIN link integrity handling
Thread-Topic: [EXTERNAL] [PATCH 00/13] nvme-fc: FPIN link integrity handling
Thread-Index: AQHdKoZLm6HyzhVxaEma4tXQxpXv6babZ7Bw
Date: Thu, 13 Aug 2026 04:53:17 +0000
Message-ID:
 <CO6PR18MB450084465A542D9DF1E46C51AFDB2@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|MN2PR18MB3685:EE_
x-ms-office365-filtering-correlation-id: 7ef62a9f-121e-4538-84fb-08def8f6ca9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|38070700021|10067099003|6133799003|11063799006|56012099006|18002099003|22082099003|4133799003;
x-microsoft-antispam-message-info:
 VIl6w+WEt9fnTv76msr6h0d27hvrPl+uvAg0gEtLQn5aaBz6t+ZNFqN3jpx6sboCB2igfc5ys3vZwI50dFb8PI1S8hRkaxv+rB5cU7H8YDHWUxuAgPplDI+Hoe1kM0CR1pGiFe+WFio1ymLpWk8Kg6sgUtjIkccc5o7lvPRGHnh0xuZjh6fgwDPliGyejpVwkcG2dWELWG9jFTbUo/uyCSf2k1h9kSk+6qRuslFIeYlri4DMjpVgf+ULm7quVxGo1mhjZfoJyd9b+AIzACrtc0qHiheqYd6/xUofH3ZM+GcC78WedlsZNM/PGyqx7U2/6zB0K9WLdDCLwGd77NnaU3XvkhjPyaIupFgnsfafC2oJ0ikZ+0IkUwqzRgoKvCWdpOmZV6Hbm3I1S66kPhmoSc/RCtXXNOMHPqEntj6kO1yTFiK3m9HN5z88mcScKZIC2MNfjdaYuQm3JZos8Rvfp7HHFmBMQgBE8yw50Z2zRkpTeq+FBt6eD27LT7jnYQMzlceSjiCNnmooqnjdxKcgKYYP50oNKIBNZ1FFvOSs8wG5mrg4+5c729H9qGh3GJxIV12UJP0oFEjpMgxxUAuot7hT6eHRpBsh8c4u4Kgk97okZ3DD0lF7B+9pWRUvhCBVdpmjfYYN38euIZjmi6Y3nuzqtr+RCzJyxRUdjfiCfg3unE4RSV+xG1KMVE42wa3MxFhtSaHIcTIK5hSWFgiRS80fGzyNampfR9Tqpn4OhFA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(38070700021)(10067099003)(6133799003)(11063799006)(56012099006)(18002099003)(22082099003)(4133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?windows-1256?Q?aPvczPgAboz93KbskNS72hB4bOHLdTFnS2FXb25fiae6+gmSYYIPwFja?=
 =?windows-1256?Q?Cdl729ORLUFOKiwreCXwHG+Yg+GbfftxdygaJ7rmC2zwjmel5znrjLeD?=
 =?windows-1256?Q?NCUulNoqxUWHGhjNMLK43AqfURLbFkc2nCmtOYuegyaDMY1OaYVPGm/o?=
 =?windows-1256?Q?0u9RfZsI/epDUatN3RfcmD3YCvAwa4/BPjkI3U8pf99/+fc8xJBbgj/L?=
 =?windows-1256?Q?ziKHywmOn3tRghpfeW3OqFBNBS7XYA9UVid55JpERGL9FHI0FLS/pQmx?=
 =?windows-1256?Q?2VGecIh3dFrO90C/iGO8M3pTyAo7rHG/jmbpxwsI+DpV/aQSvGiajxif?=
 =?windows-1256?Q?EADl2MbchP47nE24q9orEV9HuajLje4c0QpAcplynIDBGQ1sj9D/X5BV?=
 =?windows-1256?Q?zKJGT4iRFGp/UBl6Wqw5a5y85G8b059U5FN+K8zRA79BiByj/7YozMan?=
 =?windows-1256?Q?19bQxWsc/PBHyqBh7oOC63SdSZtn1BEzQT9r6bPLtCcaIwdDGAtYGDJu?=
 =?windows-1256?Q?6IJm/8oW5sWECKWPOA48yIILmaIiQxiLohhmcbASHuYyt/siO5Y8+URF?=
 =?windows-1256?Q?Elti376qKOwUkEFpKvqKxUWmqmMu4Gov0rSZQAO7P5CmLbMEsvUjdKbK?=
 =?windows-1256?Q?7/Iv4LbRSBeaayGkRzsNk/GusQ9ddIiCXCivXtOlFDERHJCTbuDgqJ+V?=
 =?windows-1256?Q?XNJymo013PuXnQSkot/qMgIp8e8b6gvBQoA0IHjkDa+fXhGq+8mRTcCU?=
 =?windows-1256?Q?WyD4Fsvj0MlcSMQi98VH28GdDTjLrV1h/7I+QilSWowxnwzOO+5jnM+A?=
 =?windows-1256?Q?jVNPEE3rzocf86c59Ark2cZfkUjWhvVK7p0E71Ocq6zlv5LvQq0h2x7a?=
 =?windows-1256?Q?x3YWpIvB5LdyDMp38rir3Cbe/q7G5UVH/7s9iXVcM3EJsL8RplpkZEAi?=
 =?windows-1256?Q?bds0wbsvME6QeGDDd7Q0E02hefB/FetxV2KmfhkCmiIw/hRrj5KIIA63?=
 =?windows-1256?Q?4KPt19ng9OtYszsVGvKfIFw3S5oQqNRmakNoiNDWigKpsCPY8gxrTKcl?=
 =?windows-1256?Q?uPleU+ibj5CZ0tN2NaWyAv6+ZnFiMbqcNi0UTzvM1u2znhejasoX64Ox?=
 =?windows-1256?Q?0glXUYXhJa4cbUPWYxJp5TA1DaKRCkcQtg+k2zUQFF2OH00Pwa/syf3U?=
 =?windows-1256?Q?1+AMHY9h9vbcnyiGzgpN5MKW/wuUoD8R+CGHB6QKJ+jM7mlv9fZ8kd1e?=
 =?windows-1256?Q?PZCTlFwG9vxlUYlvohb9qy4382r5b7nuRYl5hdTpav+5aR7PZ1mCN+z7?=
 =?windows-1256?Q?++jp9uHwYsOy0699KbzbAglPiwKgXkfYry0b6FfoXszJQumFF5al+PR4?=
 =?windows-1256?Q?+5jlZlCNyPLq3xjoKeJeE/KZkVBdXUKal2d+h5lyNUv7BUnmtKkb6++n?=
 =?windows-1256?Q?MnkMYQcrH4Sy4bwK4ZdXOaagxX4T/BkGlpKECtt37GQadYlWrcqwb16V?=
 =?windows-1256?Q?UrQEN1loy0C8kSv7o5lF28XKQzp3khgoKSQrP+aOA1s25nOjeNuxQ79I?=
 =?windows-1256?Q?bvkuKzKlbYxYvsojgxYsR/+5D4FyCyOXMwdOoFt/WglPAJruaK+rQl5Y?=
 =?windows-1256?Q?Tp+ozbrYRZ6a2/8JiaCjLZvgdFqkZgEPmU4TUKaKdItqeQmLVFAth5WH?=
 =?windows-1256?Q?FNuyaiZKeTTGixjMlxta5x/3NUm+jlf7t108RpNUZjb+Uy77zBm25PEC?=
 =?windows-1256?Q?NPoQvo+9PpGPWLYw+DGJmS+dWvwY/o3Y1e2eH8C5wzOweSTR7Wi4Y+xx?=
 =?windows-1256?Q?73bUKz61AiM5E6ohOYRATTaGNC7HBDsHOLROdL4GuQmc4jLz?=
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	hpX9JiTzFBVO7b7OcM32v4H/1rkFEPJ1S3YsffZYKemr2jjZ0qQgx8LxKW5cRa+9MmPX1qeIqjS9e0Z9Ytc1a6xRIaQLUZJH/Qc4eNlhceEl610jejNBAHC+zJ92yrwaMuvHAT5PlLyItUCbuq2T9g/3sr5MVXYoL4Hb6A+sP/qHmJir2/QiWKXNXDVaJHvzlLIzyWWU+Dji4xnAfLtJR+hjwXI+ow84006xMduJNsXogQKlbYREeJgRzbNgjQwehXQbWEWo77k5Sxx9aqzr52DTXS2Q12QMGvuevW/TD3tvKyh5/omU60WgccxQVfUqLcoxA//mLfwwDNsxPUjVUg==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef62a9f-121e-4538-84fb-08def8f6ca9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 04:53:17.7350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cRYj2oFHllsBjeQsloDz1sYXrHz7VXerJOielWK++pKPCry/5tJnVfyjvEU8OMQBcX0D3R3N2eAZNqxuvV6Srg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3685
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDAzMSBTYWx0ZWRfX4xmIpMG1XGVK
 k1uWwLWK5O/aC1uQOn481Uq8Gv0iBCy+cz/zaNtlTW/nWFRHUNErCsiAMsah4Xzj4iTEcn8WtzS
 t20zxo0IM/I5l6wwhXnX6E9YZXgvo97hx1+Z8BzsiMtU10Poeg5E60IsITEiivP9m6M1EqaDblK
 CZAicykX5DAkJZ/E19QTClbYAtvA4nS7EOBd86EHv8u6dBnMNWkXQbGRnRnUOjPr6hgbm18MWq9
 D5tlUSmRZUZPWA4Z7XV1MhdzF84PZ85KDzKbtKidtAqTNPSvsykwolT03601jYlzzdjSiJYr/SC
 frPtifAokhfYovfWfdNgV7pDhOU/fMPd2euocddhMyqHVhFQnXNELVyp6PU/s97zJlpJXUXuBvw
 rBUGMTLQxEoObSDcYYflUSDcCe0T+rx+a6KKubtez1K/Z24Lza4dVVQPY3FYQ6nxLA+etdEQw3k
 wh+ID06AwklJPLBcVsQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDAzMSBTYWx0ZWRfX6DxGf/ePbHR5
 2tjgi9jwN19atg53l7sJKPkZ9jAp+N/88FpqdRiZOWWc+ferMNbYjg6GTFCTD8GoKEI6ERZYj5F
 pgrKuvhlhxGbAhvAth4TXgF3MzZ2EKw=
X-Proofpoint-ORIG-GUID: mIcEyRLkbLlFE8QnEsrgRkDEUqER_F9b
X-Authority-Analysis: v=2.4 cv=B/yJFutM c=1 sm=1 tr=0 ts=6a7d4dc1 cx=c_pps
 a=7kgNGXaSmB15KJ6u7rEBag==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=eoNxP8pz9j0A:10
 a=Sv0fKeRqtYgA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=RpNjiQI2AAAA:8
 a=20KFwNOVAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=_Wotqz80AAAA:8
 a=07d9gI8wAAAA:8 a=ag1SF4gXAAAA:8 a=Q-fNiiVtAAAA:8 a=pGLkceISAAAA:8
 a=Ikd4Dj_1AAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8 a=M5GUcnROAAAA:8
 a=JF9118EUAAAA:8 a=JfrnYn6hAAAA:8 a=xvHX0tUy_BGRiQz1GnAA:9 a=PRpDppDLrCsA:10
 a=RFXaeJp-pwgA:10 a=buJP51TR1BpY-zbLSsyS:22 a=e2CUPOnPG4QKp8I52DXD:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=zSyb8xVVt2t83sZkrLMb:22 a=OBjm3rFKGHvpk9ecZwUJ:22
 a=xVlTc564ipvMDusKsbsT:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: BW5nthy5p4FYG0EnKi2zOQANFSxG2dyR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_01,2026-08-12_01,2025-10-01_01


From: Jesse Taube <jtaubepe@redhat.com>=20
Sent: Wednesday, August 12, 2026 11:43 PM
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>; Shuah Khan <skhan@linuxfoundation.org=
>; Keith Busch <kbusch@kernel.org>; Jens Axboe <axboe@kernel.dk>; Christoph=
 Hellwig <hch@lst.de>; Sagi Grimberg <sagi@grimberg.me>; Justin Tee <justin=
.tee@broadcom.com>; Naresh Gottumukkala <nareshgottumukkala83@gmail.com>; P=
aul Ely <paul.ely@broadcom.com>; Chaitanya Kulkarni <kch@nvidia.com>; James=
 E.J. Bottomley <James.Bottomley@HansenPartnership.com>; Martin K. Petersen=
 <martin.petersen@oracle.com>; Nilesh Javali <njavali@marvell.com>; GR-QLog=
ic-Storage-Upstream@marvell.com; Hannes Reinecke <hare@suse.de>; Jesse Taub=
e <jtaubepe@redhat.com>; Gustavo A. R. Silva <gustavoars@kernel.org>; John =
Meneghini <jmeneghi@redhat.com>; Bryan Gurney <bgurney@redhat.com>; Chris L=
eech <cleech@redhat.com>; Ewan D . Milne <emilne@redhat.com>; shinichiro.ka=
wasaki@wdc.com; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; li=
nux-nvme@lists.infradead.org; linux-block@vger.kernel.org
Subject: [EXTERNAL] [PATCH 00/13] nvme-fc: FPIN link integrity handling

FPIN LI (link integrity) messages are received when the attached fabric det=
ects hardware errors. In response to these messages I/O should be directed =
away from the affected ports, and only used as a last resort. This patch ad=
ds a new controller
ZjQcmQRYFpfptBannerStart
Prioritize security for external emails:=20
Confirm sender and content safety before clicking links or opening attachme=
nts=20
=A0=A0https://us-phishalarm-ewt.proofpoint.com/EWT/v1/CRVmXkqW!te3Z1f8UYnTa=
1E-duf06bvZlnS-1FrR2Jkcx8WQcjCWqN2c_NKqyKXnJoJcD4hWMKkUnua_-glfm3m67hWRah9K=
f0UTKp-APm3w$=A0=A0=9D=20


ZjQcmQRYFpfptBannerEnd
FPIN LI (link integrity) messages are received when the attached fabric
detects hardware errors. In response to these messages I/O should be
directed away from the affected ports, and only used as a last resort.
This patch adds a new controller flag 'NVME_CTRL_MARGINAL' which will be
checked during multipath path selection, causing the path to be skipped
when checking for paths. If no other paths are available the 'marginal'
paths are considered for path selection.

The testing for this patch set was performed by Bryan Gurney, using the
process outlined by John Meneghini's presentation at LSFMM 2024, where
the fibre channel switch sends an FPIN notification on a specific switch
port, and the following is checked on the initiator:

1. The controllers corresponding to the paths on the port that has
received the notification are showing a set NVME_CTRL_MARGINAL flag.

   \
    +- nvme4 fc traddr=3Dc,host_traddr=3De live optimized
    +- nvme5 fc traddr=3D8,host_traddr=3De live non-optimized
    +- nvme8 fc traddr=3De,host_traddr=3Df marginal optimized
    +- nvme9 fc traddr=3Da,host_traddr=3Df marginal non-optimized

2. The I/O statistics of the test namespace show no I/O activity on the
controllers with NVME_CTRL_MARGINAL set.

   Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
   nvme4c4n1         0.00         0.00         0.00         0.00
   nvme4c5n1     25001.00         0.00        97.66         0.00
   nvme4c9n1     25000.00         0.00        97.66         0.00
   nvme4n1       50011.00         0.00       195.36         0.00


   Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
   nvme4c4n1         0.00         0.00         0.00         0.00
   nvme4c5n1     48360.00         0.00       188.91         0.00
   nvme4c9n1      1642.00         0.00         6.41         0.00
   nvme4n1       49981.00         0.00       195.24         0.00


   Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
   nvme4c4n1         0.00         0.00         0.00         0.00
   nvme4c5n1     50001.00         0.00       195.32         0.00
   nvme4c9n1         0.00         0.00         0.00         0.00
   nvme4n1       50016.00         0.00       195.38         0.00

Link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__people.redhat.=
com_jmeneghi_LSFMM-5F2024_LSFMM-5F2024-5FNVMe-5FCancel-5Fand-5FFPIN.pdf&d=
=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sfPbDDcMFJyBD6G2keJbhsQZV7WIf=
8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA24wKzPP99uuwXoNoSYqcE55NQRq=
t6_&s=3D0jhQeJW2swbeXGSnNtXSHqXkNX1eVjXmU7QSm6m2IpU&e=3D

Testing has been performed by sending all FPIN LI ELS messages from the
switch to the Host and verifying the proper nvme multi-pathing behavior
is effected with each of the eight different FPIN link integrity events.
Results were verified with iostat and with the nvme list-subsys command.

These tests were run with all scenarios including where there were only
non-optimized paths available, and where all paths were
marginal/degraded. All multi-path io-policies were tested including:
numa, round-robin and queue-depth. When all paths on the host are
marginal/degraded, I/O continues on the optimized path that was most
recently non-marginal.  If both of the optimized paths are down, I/O
properly continues on one of the marginal/degraded non-optimized paths.

Testing has been complete with both Broadcom (lpfc) and Marvell (qla2xx)
32GB HBAs.  Both HBAs successfully complete all tests.

For a complete description of the tests that were run, please see
bugzilla 220329.

To test the path handeling use:
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_linux-2Db=
lktests_blktests_pull_264&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sf=
PbDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA=
24wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DXKJyyaOO9_UGG6uH5fv88U7bAke7X9H5Xz0qa39q=
ubs&e=3D
or
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.org_linu=
x-2Dnvme_20260812174503.3705830-2D1-2Djtaubepe-40redhat.com_&d=3DDwIDAg&c=
=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sfPbDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=
=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA24wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DqPf=
emamvpsdH9yAG-9CRAILRyvMrzEaa_xjIaJTo1Ds&e=3D

To test the full set including FPIN decoding use:
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_johnmeneg=
hini_fpin-5Fli-5Ftests&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sfPbD=
DcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA24w=
KzPP99uuwXoNoSYqcE55NQRqt6_&s=3DSzJUICtyPkmr7xYyCu6_gZb5itPn8MZRQm4z0Zoewak=
&e=3D

Closes: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.ker=
nel.org_show-5Fbug.cgi-3Fid-3D220329&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&=
r=3D7My57sfPbDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe=
2JBe94gTGHA24wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DYbu1spaO4qBWAVWu7hq8KHIP73xHR=
mGPfJCrZVoqacY&e=3D

New refactored implementation enables administrators to manually control
port marginal states via sysfs. For example:

# Set remote port to marginal state
echo "Marginal" > /sys/class/fc_remote_ports/rport-4:0-1/port_state

# Clear marginal state (set to online)
echo "Online" > /sys/class/fc_remote_ports/rport-4:0-1/port_state

Changes to the original submission:
- Changed flag name to 'marginal'
- Do not block marginal path; influence path selection instead
  to de-prioritize marginal paths

Changes to v2:
- Split off driver-specific modifications
- Introduce 'union fc_tlv_desc' to avoid casts

Changes to v3:
- Include reviews from Justin Tee
- Split marginal path handling patch

Changes to v4:
- Change 'u8' to '__u8' on fc_tlv_desc to fix a failure to build
- Print 'marginal' instead of 'live' in the state of controllers
  when they are marginal

Changes to v5:
- Minor spelling corrections to patch descriptions

Changes to v6:
- No code changes; added note about additional testing

Changes to v7:
- Split nvme core marginal flag addition into its own patch
- Add patch for queue_depth marginal path support

Changes to v8:
- Rebased patch series to nvme-6.17.
- Added patch from Gustavo Silva, "scsi: qla2xxx: Fix memcpy field-spanning
  write issue", which resolves the field-spanning write issue
- We decided to leave the "marginal" state as is, because the transport
  driver uses the term "marginal".

Changes to v9:
- Rebased patch series to nvme-6.18.
- Refactor and fix a patch from Gustavo Silva, "scsi: qla2xxx: Fix 2 memcpy
  field-spanning write issue", which resolves the field-spanning write
  issue.
  This new version of Gustavo's patch fixes a bug found in testing.

[NJ:] I could not find this qla2xxx fix in this series. Am I missing someth=
ing.
This fix is certainly required to avoid few call traces reported, as discus=
sed here,
https://lore.kernel.org/linux-nvme/97526d45-ec7d-48a0-bdc6-659f75839f53@emb=
eddedor.com/#t

Thanks,
Nilesh
