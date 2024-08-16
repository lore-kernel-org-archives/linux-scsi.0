Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C283C76056;
	Fri, 16 Aug 2024 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723795200; cv=fail; b=iGbgPtFHhVP2jFjO3I4dzCrGNXgI5TH54/SZ/86yAK7WV273s3ch5YeMKuxUGTVSIPL5o9hcgzvFF3gkLP6iO9cSctMAjDrb1aLeIU/X3fDrAVHDIW70qobSvp9GSOCz+0jNXZkFxFrnXe47lcmQd4Whc60CxU4hti2bsXvjcYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723795200; c=relaxed/simple;
	bh=0HHBdgqqXiypQT08+4MACd/HLsn4hX4fQOO3SAtUcNc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WNEitYHJtoHlDOOVMsE/yHxFBeF6oS8EogTMtwemcHW7ggsd8YyH911m+G4OXm5ZW8P3UzLEaEaqSxxegpK4dJ7HZMBDHAFIsrlRN3IaGOg+FUA52H4LUYJVY5qZyKxtWVqXYn7P/+d4EI7rU/vJf2ZaFLFNUfkbSiJWmIgJ0kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FCWZzY1o; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dyHmQHH0; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FCWZzY1o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dyHmQHH0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723795199; x=1755331199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0HHBdgqqXiypQT08+4MACd/HLsn4hX4fQOO3SAtUcNc=;
  b=FCWZzY1ocPoIWpx1p5A5lq1DDSQBlfnJvk45CYu+qFLVpucobMhIZhl/
   j7B9oGd/q76usFHo4jUsQOcxsJqbsMY7M/08G0qMSfnlIx0UYFF/zXx2n
   N+7OyWq+UEsBWP+wAc8b740hfbBbsgaURHm4mDw/ZOREi/DT6qLnK204a
   T7SuLDevdZpZyhraah2aBMbETJcKs7zbmthIeQ1Se/2EiajN8/7Z3I8Kq
   YJ3QmQfP6FvIdjhHPP9fN2ktsfEOg+rhEMqEcauC6EonBn+FNXKEKxxi+
   m3yhpN+wBLHr7ilnCmyWgzqKnYNBY5wJqxtRkc172JjWGM4CxPwsP68Ph
   A==;
X-CSE-ConnectionGUID: zip7UUe5TieiwEWnl2Kogw==
X-CSE-MsgGUID: VxSKsP7ER06G7xP8LvVbrg==
X-IronPort-AV: E=Sophos;i="6.10,151,1719849600"; 
   d="scan'208";a="23805261"
Received: from mail-centralusazlp17011024.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([40.93.13.24])
  by ob1.hgst.iphmx.com with ESMTP; 16 Aug 2024 15:59:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJp0cJEd1XHDh9H8faoOkyF3vwLI9ULV0BeAFOWYm7ZFjc2DjG/KcetICOi9E8/gYNYESKNz78AI/K+sTMYPYwdmJAjPcKizH4mpnrkjnYbh4vghO0O9Y/hYz5R/9ONTjPmulFrPGr6ZRSIg14cs7N65o1+WwPTceL1lLqboBXYpSbqtdQWsaeZo/ckGrHg5Ynsfc9tEfJi2nfh5doFaCl3y518xRR8DoRLw3UIOdOM3iDNE4c2DfXnsmCaz4WxRJVImth5nVo4D9Y3OuCuxGUECf0y9WSD4T34b1OOaZVQNeqFOd/x20vHGPuaaKKQa6P2Xt3pYoDVffj5JXcoTXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cs4s9Amv0VSmZGLEXvM7DJ2e7oVLt5PlaRDrV5ndYSA=;
 b=XysSw+d6ZFO0IEBkPiMDGIsVR0oplLqpxcf+YPU5pLmwLnF4lxtTl11dieIVmJL7P2C53knpGbaUUxrhP4/MDIYJjFOLCbnZGNMVNkFbU0xRWPE4LTB8AdUkAC0ykBwtDsZRzoMe+taISKzT7v65bwDZ/SHc1uWT1wAKpLdA3ct7CK/U86NkryZu0hx3NbdTJfq1goHyJ9v7W8w1F/kqZxaUXBWVaU99IsdSocrFw7FbzKWuzOm3B0kH1IbnCVGizbIakfaigBXNMxrigc2NOGX/mU4jZVXCZv3BpBG10pkTt1EII7oNI8qX9Kbi5PKWYWbpcnzNqK/BEyAREwi2Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cs4s9Amv0VSmZGLEXvM7DJ2e7oVLt5PlaRDrV5ndYSA=;
 b=dyHmQHH0uMKalMeW4xsFcwV9xt7a4yAlokwydeX54Q0ZS+radc5Fo7VQ31Q8gUN/JFNwSfDInEHAPfkFSb+cBqlAMqmEqp3hL+Pk+VGsBVRgt3vZlPi5z3O4NAGo+m+YXzgopfE8TCbojRZdmUQJALFfxs0Bb7xTLJAuORsupEU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6360.namprd04.prod.outlook.com (2603:10b6:a03:1ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 07:59:53 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7875.018; Fri, 16 Aug 2024
 07:59:52 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Chris Bainbridge <chris.bainbridge@gmail.com>, "fengli@smartx.com"
	<fengli@smartx.com>, hch <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] critical target error, bisected
Thread-Topic: [REGRESSION] critical target error, bisected
Thread-Index: AQHa77JGPKw4giBhfEOqqIP2hh1M6w==
Date: Fri, 16 Aug 2024 07:59:52 +0000
Message-ID: <whnt3t5fqae5pujt6fkg5xu6mqxc2x5llbmq6q2lclfuuafbqx@tzj3dzgb7ury>
References: <Zrog4DYXrirhJE7P@debian.local>
 <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6360:EE_
x-ms-office365-filtering-correlation-id: b174b176-e22f-4724-a638-08dcbdc96914
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?wp86qhetcrHqQZIZRWsJ34hMS76JZmicrUcEuooqyS7vYlo1AqLLejtrJnce?=
 =?us-ascii?Q?zr2m+RxuKlso3/jIfMSKIDy7uiYESvIJ+gVfJ4ItXPiMRai/0dKnNP0o+qcF?=
 =?us-ascii?Q?Q+/CPVlq46bcdPYNYzd6lXWyKa92Xej2LP1ujbf/CfnHp1nnWkQwp0+Auahw?=
 =?us-ascii?Q?gR7VqYiXbwKc74GDAnObj9RjOKmTyflk3xbrgY5xBPV6O88p+erWTImF77Co?=
 =?us-ascii?Q?GtHkuHvDL2QadiloYRx/2fOOH2GxHLRS7QjDEzklMWi8//toR7dzlRjJxXBg?=
 =?us-ascii?Q?1vv2z5crjDnS5hBubiQ/2MtdwMG5dVW/XFdZgCHntl+/yIo00PfXK1F+hKyJ?=
 =?us-ascii?Q?MwTgUWTCWLzHwPbNteuYsi4uXsp/aEhANgM9rSV86ul8MN+cxN/tfu0dMy3X?=
 =?us-ascii?Q?8eQyMWfqFKnkSrTHNkK+xA2QKr6qF+HroXPdFN96fjDc3tPRNMX0RYqslWir?=
 =?us-ascii?Q?Uz4+4NGCYQeisFTSZAAQyqjSeIQc9jV5R7u+rPAHrNCUa1dP0X3AbIqtf1yH?=
 =?us-ascii?Q?rWHmpewoKOBckV3G2sGia0Q/hVCo+dvlogmgT1dGH0iVR8U35FKfy6N3ltfb?=
 =?us-ascii?Q?wE3o3Z4r1+5qjhk/r3KhLfzdLqh46Mx189DdEOFEw72lfksio+S9t25bCKxz?=
 =?us-ascii?Q?aAA+yw7hhMyskMpH7lX8CSVN5AiR9ZVJGOQXmalybAROewdoa5+lcXFJWN83?=
 =?us-ascii?Q?TqDGrWxYabUFl8PxTSwkWUVeP8DT0sGMi5dbJjSMacWoS5cgoIeuMmjEqPh4?=
 =?us-ascii?Q?Ji3+59iN0cOZErFlzcEElvixFbBDqnET7TYGJyaj/WsXDr58qGySRzzS97ox?=
 =?us-ascii?Q?/o5XXuwS8uXZQu9iG1uGkoPNtqLdKcEv3/B/VFuHI2fWBX8Jgs5v7Cs0sKmZ?=
 =?us-ascii?Q?tWkMmAqAwcByz4sJc1cJaj4120Zii367FCQ/LrzO2o2bO8QyvC1Mq/NkWsw5?=
 =?us-ascii?Q?/fyrXQX50T01PSW0uv7jDB0DKP6IsVtjm2xj4prDj0aPOWUTLtQRc7JK5N3w?=
 =?us-ascii?Q?La49QEC/D6qqyrKbCZqk0d1UNyivrsGAyL5l/Y+zxo8OlPfJGXD4s/CFCK3K?=
 =?us-ascii?Q?jcSjjhK27LGvxM9NbCJOELoRV/cwg6jLLNm7OIY2hKICcO6OERqUDHzCeAs+?=
 =?us-ascii?Q?INzbd5GQFuNlEI6B2GVz27PMpNYbgbOdWfXzKTN3AsxmcbVPVrBS2PqBQQQv?=
 =?us-ascii?Q?59U+VSN1KJgWEE1WE9RIsISVTidDsIPxxHLdwdaGpSflrPLtr2B1ogmmlrkl?=
 =?us-ascii?Q?zLt9RzDmP+U5rHYGNFglMrPdsQNJ8mmq9RIA5t6dt0VNQ+DW7E5UFKAfmJfh?=
 =?us-ascii?Q?3R5PDSy4uJ3TwpC5VvtgQbkxTiqUhPv/H8ZhzbXQcfh6Qfxdn1B8jtT0/Qbu?=
 =?us-ascii?Q?iWy1jhCzZO8DQ04HMtLORz/WXEA7WnmLNZVzindUY3XZbsqQvg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?5RSfATog+VGiRcLlQelBHzS2RQJfHX80jCWPsi8cV0VlMsl2gpq5fzli8l9X?=
 =?us-ascii?Q?wwB03bDrNxHnG326ABp1K6lrHDKqATT2CuDrhFdWHFvN2Wl/3fk8VuvwkR16?=
 =?us-ascii?Q?Mur/5ThnT/uk3j8at8OwIY2CEBuaIvceImAHXAA+u6W2PiqZethqvo+i1W4C?=
 =?us-ascii?Q?y/dS7M2rstaomSUZac2piOMYLu74KOkGipTX63Lo0C9ZBrzYN0Qrng1jK9I+?=
 =?us-ascii?Q?rf3dkV1pAuKPPfRVt0Ou2UnsBMMZQFbcZefu3n6nfSFQopFSgAKzbZ1r5Hy7?=
 =?us-ascii?Q?lnDVIhQke0UJ3ypvRPQNG8ELmbv/tKqcxXTA8Kvh7QSbwiiYAZwuQOcEkQkT?=
 =?us-ascii?Q?fn12HIV0q84EZd5TATwtppnPzk1RDHLfcx8+MvUMrLLnN/Mdm6yAwFVi7L92?=
 =?us-ascii?Q?stlP2nfHuFXEgrV8rKEaV6HP0M+e5ZAbsJgXbFbGDrl4f5b5E0UL8woDroQ2?=
 =?us-ascii?Q?iV0VaepIZcL4k42Ny8GkcghH+S+2YsWNNoyFHZEQuoqufRKvkb8R+hCH5YO1?=
 =?us-ascii?Q?5f3BJEdNL7sridxDhdq6xpjLAQjP1bvdFWsy3xNVfOpSoXEaiJ/ZwYcVhUcK?=
 =?us-ascii?Q?bjfFdSQn/CE/r/V/hJrp99kRcizJpDpzJJgs7ZcLnPyhLW8eKaAHjJ1sCdkC?=
 =?us-ascii?Q?HmpR8pf759mchnPi6aVcz8b7ObSmYryrpM5hCub8HG2exRRNlaPLJjwZBgzU?=
 =?us-ascii?Q?RF6XdQ+ozU2yOkH8fL5e8U1zDULNAqDX8iZhwGO7QULhALIR9z50Y8umExgf?=
 =?us-ascii?Q?cX3qPmC3475uMoE4m1+zyy1jtXFTs10TvrQTOSY//I8oR/nGT9zcqGc9Ni2U?=
 =?us-ascii?Q?uwknAfaw393zrVlhl9O+gC0IPmU8Yb954NKq7Dl03fqYlWOufDkKxEooOrd6?=
 =?us-ascii?Q?/Vs05pvMYIYM8r9MNd4/5f2iVYJRRPKdD08Nei6RrByvcFRth/0dXwAjLYyL?=
 =?us-ascii?Q?N7+R/UjRVrDel5EfKr3wcoUlSccKMio/99Grfz0zgdx8eMJ7epSGsrd4QJCb?=
 =?us-ascii?Q?ttZCKvblc6N9NnxORiqGCzYmZ4p/8XXcfRCc9QUBrcp3AtMEgbR0s4cnkpiK?=
 =?us-ascii?Q?xnR3PbQ/qkwKs4uRbGaOKKXZ8f1/bf/EcjWLzRiZKKQ5RXJ/N74u6wpqaDAo?=
 =?us-ascii?Q?6PouAeN8DdC2T6wy2hrkizKCPP10Zte4AIhWUQtL3Vedl2ZfYwJK5g/ZmYXp?=
 =?us-ascii?Q?lnOCxMP3wd5Qxs8Q4FDtGiQi+bIOBKhH/BO8y3MxTAZIOdIR5QWJAfJCcUgE?=
 =?us-ascii?Q?Z/mtFJ2MY4fM0qez0/hfUuixc4UCfKxr/8faJENktFJZtsEb7yimRw8uslgR?=
 =?us-ascii?Q?TVXkqO5g7Ooqwl2JcpA0om+yTH8ACUKnl2/E63uNiFNWKVBqjBUL+uH17+x+?=
 =?us-ascii?Q?zJJm1eAmT2WhrPa1JHw5SJ4/hhGOG27eZWLrpzTOn4iszfMXdtTcqOaRQRtw?=
 =?us-ascii?Q?cv7WFe8kyeD4KIVhXHxyV/ofojAfPtE/xcnoSbQmYV6P7oJ9fR97woA7+PDA?=
 =?us-ascii?Q?HNlViP/dmx5pGn4N2fxQ1YILHOEqNsF+vYXqRoq2xIIFbNAYQtsQQ9YvQMzX?=
 =?us-ascii?Q?gxBawj13BJnksnmVqOGp4a5oI6gqqxykJOQPpCccgw17LaKidSlOd0PWnhih?=
 =?us-ascii?Q?+BoC0LYYokhRbWoAjR/LJ4k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <497EEA31FA2B1C4695B58F714E32F0B8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J2ptJYyIze2DGKwvEySQak8Vf16oVUpKZQzmNBFkILVM6ppbIq+E77HpjVj/tFkdUzK14tlKKJN5JEvHG3RSbcMUK5S0HM26Z369uLUjz/K2xEA6Bg/sJwhQFrlweWu5d2SyE0gwKaqksPybMfRq2d3r+MVDYQg1lKgyvvVCwiZeXcgnHWlXqQ4ELv7fNFr/af7sas0Q/o/Xo5hbpirAJmpbHgTkxUHYU7p5Lr2RQrAljRhYaKQuQeaTCLuVEUlluOh9n0LtMux7wlUWJNznoi8wrWFSrJt/RsDBcxEbnRSv6C1J3TKus6pDDk8m0i26+jFQBF71nff+DAp/g6/WQQ5H9MvWf77mjxFgIh1C+D2vJ81eiBJWKv0g9swQrMhP5UWsx2si7sscFJCNX+rqnMUqN7AjRl+aUTIsoXOVD8x3dcXgSgfgKoKfwvtWRMjSdG4mb7owuIvBh4pWvDMmpjC4iW+1M7IkeDUzcBC4OIeC909ybXMAx0XkgBPrjCsMeA8yyQeLr9uu3I9woRMG97qWhAEJbcYpWtq5ojLqqbt02BVLC5rOUQ/idJnYPAEmdfgcG6Gql4VddaTJdPVebORG1edKA8aMRHn7jBn9kQre/hZxPgkKOwDHDCt5SuM8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b174b176-e22f-4724-a638-08dcbdc96914
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2024 07:59:52.8425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tYSGNpKd84+y2OYv0yoa6Z0wqN4pLUkq3tZP2tp0VcJxf1MbOZ7TZcxMn0KaTM2G1FcNo/vnb2z42GKyxEfp85E+CO7MZBMMP1LJNXNtUsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6360

On Aug 15, 2024 / 23:56, Martin K. Petersen wrote:
>=20
> Chris,
>=20
> > [  195.647081] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=3DDID_OK=
 driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [  195.647093] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [cur=
rent]
> > [  195.647096] sd 0:0:0:0: [sda] tag#0 Add. Sense: Invalid command oper=
ation code
> > [  195.647099] sd 0:0:0:0: [sda] tag#0 CDB: Write same(16) 93 08 00 00 =
00 00 04 dd 42 f8 00 00 2d 48 00 00
> > [  195.647101] critical target error, dev sda, sector 81609464 op 0x3:(=
DISCARD) flags 0x800 phys_seg 1 prio class 0

Hello Chris, Martin,

I also observed a different but similar failure symptom when I ran f2fs wor=
kload
using a zoned TCMU device. I found that the trigger is the commit f874d7210=
d88
("scsi: sd: Keep the discard mode stable") that Chris found. After the comm=
it,
the device has unexpected non-zero values for the sysfs attributes
queue/discard_max_bytes and queue/discard_max_hw_bytes. I found that Martin=
's
fix avoids my failure symptom also. With the fix, the failure disappeared a=
nd
the sysfs attribute have the expected value 0. Thanks!

> From dcbe0126551fedef94fd8334288e5b2bb6059475 Mon Sep 17 00:00:00 2001
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> Date: Tue, 13 Aug 2024 03:58:27 -0400
> Subject: [PATCH] scsi: sd: Do not attempt to configure discard unless LBP=
ME is
>  set
>=20
> Commit f874d7210d88 ("scsi: sd: Keep the discard mode stable")
> attempted to address an issue where one mode of discard operation got
> configured prior to the device completing full discovery.
> Unfortunately this change assumed discard was always enabled on the
> device.
>=20
> Do not attempt to configure discard unless LBPME is set.
>=20
> Fixes: f874d7210d88 ("scsi: sd: Keep the discard mode stable")
> Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 699f4f9674d9..966fc717d235 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3308,6 +3308,9 @@ static void sd_read_app_tag_own(struct scsi_disk *s=
dkp, unsigned char *buffer)
> =20
>  static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
>  {
> +	if (!sdkp->lbpme)
> +		return SD_LBP_DISABLE;

I guess SD_LBP_FULL would be more appropriate than SD_LBP_DISABLE, because =
the
comment in drivers/scsi/sd.h says that SD_LBP_DISABLE indicates that "Disca=
rd
disabled due to failed cmd".

$ git grep SD_LBP_DISABLE
drivers/scsi/sd.c:      [SD_LBP_DISABLE]        =3D "disabled",
drivers/scsi/sd.c:      sdkp->provisioning_mode =3D SD_LBP_DISABLE;
drivers/scsi/sd.c:      case SD_LBP_DISABLE:
drivers/scsi/sd.c:      return SD_LBP_DISABLE;
drivers/scsi/sd.h:      SD_LBP_DISABLE,         /* Discard disabled due to =
failed cmd */

I confirmed that the fix patch avoids my failure both with SD_LBP_DISABLE
and SD_LBP_FULL.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

> +
>  	if (!sdkp->lbpvpd) {
>  		/* LBP VPD page not provided */
>  		if (sdkp->max_unmap_blocks)
