Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E57808;
	Fri, 12 Jan 2024 00:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fLjDP/FI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ylRx7YXV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1705019462; x=1736555462;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=oBiwGGCia9OSrVG7juonWphN0XR/AIq+qSJtsM85/iI=;
  b=fLjDP/FILrtlwMnqUrPIcuDIGRHstTY90yUefQygh8OM1zCvu/0T7nZN
   BGBlDdR/631YrtpBReJ4gB+dWokq4ddf5JEMKmfxyu0kzo6WAM19P6aTi
   4f5GbTZrpS1JNGcBk54QuoEy2PkNDHaPJ8cpWpDmqnPXHI+Q9SW95zeY0
   M30yoDMQi8aebBe78ClQB3uim++26ZzsrRcIrGtfmtVbbwZ0H9e1F7Tnl
   7Z2RgEsHIp13fWFzJp+qlwI7reYvI4jEcPJt7g/mIoDsXlM0eBK6kp5ha
   TYzWMOPv0CNQPzDjIAd0d0CieMOQXVYf84OsynCGb2u6ETDQooFzYggQ1
   A==;
X-CSE-ConnectionGUID: Bv7LalFNQV6mJU4xfbo+/w==
X-CSE-MsgGUID: 4TDAbzJJTvuN6nZ9ejgKtQ==
X-IronPort-AV: E=Sophos;i="6.04,187,1695657600"; 
   d="scan'208";a="6680484"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2024 08:31:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mg/P9An5SdMiRG01I7U9Sdjbvq9v2p2JEwyEsoanwd3JwH4gRRmTSl5bJ1e34b2rJkkBykBX/y8Qs7mx3yRXFBcBHPEcMpIEp+Q5Ekrfc4A6bgWkiaRMAZeNnF+EOn05YHcLQUBSxnaOFxr5kDTeGByKBnEBfKeZznrEhH8aFF4rnaabZsR+K92pkOAJw4T4sxgMSA8+hirYT1PDME9Lz0R08POCsqkZMIMIIZn8JvrgHwhFNCHYqhJkgUJQJlreL4qoxoapWssLtdcMmBI95JjX879Mx/3kaf3KmQLCFguK9sU1hc8Vx8rK4DWmKPemTKz2KENzG8ZOKqVsKvwaVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5gycIWzAebqq8uN+ZwyD7BkDoZmLkXQErD2fTITU6Y=;
 b=PUkXDcz6TPUZ14XbCiKE5IF3sggKIJPxxuVBABhGZQkKfVjuTVfu6JGO5RvTxl67zSY6vNrARTyvBEW0SgL/FJt6VmRW8lLrjC6VsXBVNLBqExdSzneZVzHW7fnU+nPxhIH1tNIX9/iutU/Hw5ZY9Lw+i2SomxMqaYyopUj5tpX0GZjTg7nk3Ux790LFyxXJehSxgxn/BdIkMqAJlYL+IRvHQAlPMC6sciIA22S0Ca8JyllAZkyjULS3zjy7s6nRtNS0HINtVqd4+Nc25FFxtDwhn9vXmWIlV7U5IsgW79oc5DInb4P3ubZQg8Zc7s+OBHlRdUqCNrgDfRdVNcW/LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5gycIWzAebqq8uN+ZwyD7BkDoZmLkXQErD2fTITU6Y=;
 b=ylRx7YXV8OYIp4WmZ82akkfRs3SUoRrpN1pYfuMd0IThfgt/RJ0kWQIY0caBjtDZ+462CPcXMHgmu85leFSzPCA0ZLIIFogdALsCv/qvhf5hw7vkbYnTTGNjbSSGF/+8oGs8tXuZxULscB+J7oNj+tzMevYaNZHKGElb9Bck39Q=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6700.namprd04.prod.outlook.com (2603:10b6:5:245::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7181.17; Fri, 12 Jan 2024 00:30:55 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7181.018; Fri, 12 Jan 2024
 00:30:55 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.7 kernel
Thread-Topic: blktests failures with v6.7 kernel
Thread-Index: AQHaRO6an8Qqk/X6fUO2EtrEhMR7Sw==
Date: Fri, 12 Jan 2024 00:30:54 +0000
Message-ID: <74ytefsd7byav2bs5q3lr4yj7v3yfmbe4bvwo233bri7ufl7xe@btts3u37s4op>
References: <gaz42xjzjsf2w4zj5sory23wpoym4wuz7y4lz2wxwx2eum5jl4@4s64tt635abf>
In-Reply-To: <gaz42xjzjsf2w4zj5sory23wpoym4wuz7y4lz2wxwx2eum5jl4@4s64tt635abf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6700:EE_
x-ms-office365-filtering-correlation-id: c6c34cbf-c1b7-4386-34aa-08dc1305bd40
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +9UOEfBsavcZsxzUxslYWc3+Esl5HcxkiX9Me3FZk5yebI+LSbN7Ged7MLsvrDhSjgerp/b2wVMNUwckUoMSYGmrOOxJLbkaunfXZQKwcIU/TjNxPIrjdKjOSaA9Z3JBFiFpNt1HTyOBYIMoZbYXjeUrSzssXs2ppr7PpfSxSvr4Q8g3GLLeyqg2PwPbLUfjUyF+wORrHXmM5UrvZzk06SkbXdee/37m40d+krZU/fyr/tA+bdiOgV/2kPYD4LxkuK/StQNEk044x4RuC2MgH7FV+UvbZ8Xt/kWjhyIes7QGjCbQTx6IboykStkfVaaYj+qXdRXukAC7AHYBWrlVbXyt6gn2D+JJeOyqCTqnNMU8Is+6bfFSsEEZwQZtoJRylrm5M/P6cOreizdNx1dTYL1bOCCLc4VyUYj1nq9KN5iqeUplz80uyLYEt61v5ME+VVGeBUr3TiAdvyGwN5p7EuPvWPM300ZXhBXm/jDgdXFZLO/nNQxLCMn/gosH8LwXMjkbDriTJYo522i5lIxchbz1vPNV16MWIUQDPmeH5bfjqpO0XdAC5IZqr0J3F5L4eLNCUsDVifmXU7N2c/mdxbB5rNlF0/d7PAvZ2ZU2G32+7eCNpmN3OZRHzi9jJ8GHAyH54poBY/9gicbB0Augfd99GYVr7DeHu6DMBvHZxQSObs4bc+t4MEzjf3Ys1q1E
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(39860400002)(376002)(136003)(346002)(366004)(230273577357003)(230173577357003)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(6486002)(38100700002)(478600001)(122000001)(83380400001)(71200400001)(966005)(8936002)(8676002)(44832011)(66556008)(66476007)(66446008)(64756008)(110136005)(91956017)(316002)(76116006)(66946007)(26005)(6506007)(82960400001)(9686003)(6512007)(86362001)(5660300002)(2906002)(41300700001)(33716001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zWgrjEVfQX6QbB6jJqBHT4fxBC13q7oqFtwtnD2pH/MlYN4CFPhjQ9v+o1ix?=
 =?us-ascii?Q?qJS3ZwaOp0qelsPMhQ6grIEL1tPrfmopuNfSeVqLcFKBjDNH4wFlwEHuFTWM?=
 =?us-ascii?Q?DFrwzP+2/Cz++QOlmAmTmOwT4JX1pk6Nb3Z7M+go6cPDB4wPPeq/iNAnJxyb?=
 =?us-ascii?Q?a2FJ7Tt6M1/pSWPjWclI8DuJBAgM3iK2N+ERky+2yc6tuyuqwcZ4smQuIEL5?=
 =?us-ascii?Q?UBjwTDZxoKWD3FBZHLIyeZ6mlOdpdbQTmMhg3mlL2y6wXtuBOy/dtD8EfAJT?=
 =?us-ascii?Q?Vhf7DlJLgmWW6+gcgPGnWWn6s4sTNIAdqMptA0PewHWTAycMvWieX+EY7/G5?=
 =?us-ascii?Q?WifB7VkPvDbROygud9Bja9q4TX7uQVz2fgGgl10LG/FbaGtSwMRr9tzF+zJq?=
 =?us-ascii?Q?zcgubKWps2qMzp43b43OFYTgHlWJ5TMN1WdFHPbLSGbYoqqlEtMkKjSEBqiW?=
 =?us-ascii?Q?waAYnZTY+lLsDqIB1x2URNv5FmLVVKAkWBn67jeE49ac7hz53RECjAn7oGbX?=
 =?us-ascii?Q?OPATEi6TuOHSXygeukCWofv6sR/+YEau3L7D6tfc+vBB9o8rYO5S5FNqMFyW?=
 =?us-ascii?Q?N87COK+5qLIbCpe/b9cE3WO4UK1S3jBxGjjB7sJ62ssLbGY8ey3cPVxqSIyH?=
 =?us-ascii?Q?8B6pu9ayMfb+3nQJLh95mGyk4AeXkBCJd4t5pDMLjN5r/mgkOvgFF0tbI7sy?=
 =?us-ascii?Q?LRJQu2+LiG6nwLqvjIBiV1eUHxgR9kHnYXqws8WlOQOrXF+UGBzFPYONfxuE?=
 =?us-ascii?Q?24KHsDcaoe5Nd6X1dcMGR7zkhnLFqbr6u4xCzFkvrjFqDrzcrMyYOITfzGLJ?=
 =?us-ascii?Q?qFBmpZsB1Qycjo8vUt7teEd60SPHpz0R2nMbjt//XxkHjQAMu8xRELInWBo7?=
 =?us-ascii?Q?dA9WbWtP2eHGGdVLT+cTpkAifP4Du4KECYl4Z8dlI8SdmRa0JY8H3CyKwbu7?=
 =?us-ascii?Q?AIay9qQ8ye7YOFITVrdSPQN1DBse22Cg+pTDwB9l6tn3Anzpbf/xKts5pKJH?=
 =?us-ascii?Q?Wk5ttDu/AzQOBtY26fsNkQXQ3CBaJUWIizKGlusdwjF3KDfycEFN6sZo3OQt?=
 =?us-ascii?Q?16IGkNtgztbF1AVCZgcxsvEkD3j+NcqI7EuGYf27RaLAUddivbpCppe5N+ly?=
 =?us-ascii?Q?PXGNblfb3aWbaIoId6UPms0Gh2sELTwYgQ5kgZ2XCjboGFEFB9I4yFPm0t0I?=
 =?us-ascii?Q?cCvBdezB1Hw3+/ND8bWnPzYYzXYcLUxj8mj+cZPRmGDcRkZK5weq2BmFPEMm?=
 =?us-ascii?Q?cdaWKnMZlaMI0bLF37PGG10AWq3KI5UVh1wlaIqJ2/th17OkJ0h71q+QykM1?=
 =?us-ascii?Q?cpkvsAC7yLpA2EDWuZx9xAG0dmTZ5OePreNUgbe3j8nSQ0swnjB8h7mtycbt?=
 =?us-ascii?Q?y9N7qZ8ZAK5VGkjrvAX1PJ6gQ8JBUFLLjXaljKPso1UuVjDHrjetX8CL8fAH?=
 =?us-ascii?Q?UEUaWNyKqhXgdF9a7yBAMh5dTsnlhASr++gWCHz8LjMBStL95glX59x6Nr1U?=
 =?us-ascii?Q?uqZHUmwOmUEYBL/y1itCOPo9SgaCbShlFH63H4XlcbbhQuwcSQIs6mFhP8nq?=
 =?us-ascii?Q?oQxn27I4oPChbbCC1ACfTKbDB18dx7ue4f59wNw7oQE8Naw7UXDkKXUwB5CI?=
 =?us-ascii?Q?j6QOhjZg8XBcmgSd2SPVHNE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25872DEAB889284591916FA74406A5E6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iQYvvBIW/CZcqfVv95rcXK/C80lyY0dW7A/zJ9Jdqa7LlSrBVbE+kfyoEx4qAKLQFzOBoxLprmIaDNlLrUDMrVQ7KcHj2PwNMzqh9mbQX4+TSLAvK+rW+CiFM0PtB1KWGDk2SptKqFehh5uDBixBXxUf3Zw8ap89rLwlvtEHoOvgEe+U74AW1OO0DCeWcR06qwIcGiwNrm2svUS3W1Kj96XnoldiFRrSzARm9kbVNr+LlnFMllaHBUrwaVE8RrfphZNHsWjq/Heq4p9f43lVEFoLCeyOTE78ex5BXB9FrWGrLtOshkUkXdHCKVzltoh5O7XE9Y2q2/2TrEt5DMO36gwixh9jjEF+UOmjE0Sf+kMYLycgudcXg99GyTXMMb723E+WYi4GI6N/rsKWRND9gYLCWZLS32sdT7XJszEJTfuf50w9c8GlR/Rd8d1Jjzqc//Cg242w/RBwPcA86C3BE4QBAO2R5YMRBJ8F4zMuIfZZh7p/T8qwuP2jeU9OqttFiyDJpUVmBkapIw9otx7iZzW7+GPIDmHfc+QCBsEFSQxgHOcQpCFmNhuEDggDJZFxZtHaPGjxD8q21hqlWoikmU8E2G8cRTGGnTC6Gw19c780u7mlHq/L7JGvYlDDSMy5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c34cbf-c1b7-4386-34aa-08dc1305bd40
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2024 00:30:55.0191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUWAeP0VdaXlcKFn63JbZzThyCFw0u6cojwdggCC4ap1st9a4mivQFkqBIM+xTSd1xhMhjk7iaYp5voS7xEdsbFi2hFW2/oIQknpkORGo0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6700

I resend this note since the subject was wrong. This is the report not for =
the
kernel v6.7-rc1, but for v6.7. Sorry for the noise.

---------------------------------------------------------------------------=
-----

Hi all,

I ran the latest blktests (git hash: a20c4de2306e) with the v6.7 kernel.
I observed four failures below, which have been known for months.

As for the two other failures observed with the v6.7-rc1 kernel [1], they a=
re no
longer observed with the v6.7 kernel and the latest blktests. Good.

[1] https://lore.kernel.org/linux-block/ytcn437kppvuj6pwokthrh45asmupbbmbp5=
ybf56yipo4tukv2@g3qau7lqoooj/


List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: nvme/003 (fabrics transport)
#3: nvme/* (fc transport)
#4: srp/002, 011 (rdma_rxe driver)

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   The test case fails with NVME devices due to lockdep WARNING "possible
   circular locking dependency detected". Reported in Sep/2022 [2]. In LSF
   2023, it was noted that this failure should be fixed. A RFC fix patch wa=
s
   posted recently [3]. It still needs more discussion to be fixed.

   [2] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@=
shindev/
   [3] https://lore.kernel.org/linux-nvme/20231213051704.783490-1-shinichir=
o.kawasaki@wdc.com/

   This test case caused the following test cases to fail occasionally. A r=
ecent
   blktests commit 1e6721b87d5e ("block/011: recover test target devices to
   online or live status") fixed it.

#2: nvme/003 (fabrics transport)

   When the nvme test group is run with trtype=3Drdma or tcp, the test case=
 fails
   due to lockdep WARNING "possible circular locking dependency detected".
   Reported in May/2023. Hannes provided a kernel fix patch [4] (thanks!). =
It is
   expected to be upstreamed with kernel v6.8-rc1.

   [4] https://lore.kernel.org/linux-nvme/20231208125321.165819-1-hare@kern=
el.org/

#3: nvme/* (fc transport)

   With the trtype=3Dfc configuration, tests run on the nvme test group han=
g.
   Daniel is driving fix work.

#4: srp/002, 011 (rdma_rxe driver)

   Test process hang is observed occasionally. Reported to the relevant mai=
ling
   lists in Aug/2023 [5]. Blktests was modified to change the default drive=
r
   from rdma_rxe to siw to avoid impacts on blktests users. The root cause =
is
   not yet understood.

   [5] https://lore.kernel.org/linux-rdma/18a3ae8c-145b-4c7f-a8f5-67840feeb=
98c@acm.org/T/#mee9882c2cfd0cfff33caa04e75418576f4c7a789=
