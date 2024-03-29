Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF26381B8;
	Fri, 29 Mar 2024 05:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711688490; cv=fail; b=S5641Vjo2RLkfZJ9BTXc9Iz0yRQdnIR3jigEHxhj0R2HC3IO2zLWmntFTZb8aKCqod0neM1VwroI6zmo5NZ5IHdBLst5xXg12IMX/rHHRxSNgjtTaeLL35QvR/ohNR1zdS/nlXUoAStfXRJgDpkJdplUsLutMSr+TIKEy9tOPCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711688490; c=relaxed/simple;
	bh=7m/cDLozr0000qL0E3WG8DMy82LUBFXnBCSvWxoWgk4=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZbyO4MC2BXxt7ExnYmlIfdZ43RPTIJj2oj/fFCoC04NstEL0KSGmaW5Uval75MkWe4/5jfgt1BZ8jnFwC+177Hpb2tabVCKrKidSYM/izV3rhQU0q7epc/e1fJ89ls3kZOMOjr9KupWN0B1Fh0EcyrEQK51JQm0kyRq27NuRJmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TyYkUMl5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GsQKTSZX; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TyYkUMl5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GsQKTSZX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1711688488; x=1743224488;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=7m/cDLozr0000qL0E3WG8DMy82LUBFXnBCSvWxoWgk4=;
  b=TyYkUMl5WcKN+nsToPWtnqFPV3vsLKIkCzxPNWyvymAFq60kJW+FhCGm
   2H8nNGr/+vo+v5DQ5P+VU9EfvjsB2U6dUvUXZhYSdHeD9pS7yW9fd4Yo7
   3pKXuXen0PoQm8hTg8CyTWDyeVR5HxZ/0M33Hyl5w7Qx0TKN0spUht1hL
   P159uU8acmFne4ipYGgCAH4EbdZ3Vv/c0YQpT4uVl20odDCKbUrH4QpOb
   MmmQlg8tHDoI//YAE/PZ1JbQCiXYYCcpMH5XXNei+JLDTqfEjoH6xYFT2
   q2+nuVETJWZAKC/2cEPosxVVUXwkQqnHAFKVd95PhHSyKanCvKI9bzPnK
   A==;
X-CSE-ConnectionGUID: AXFnC9VYSbS6khS51Y0nnQ==
X-CSE-MsgGUID: 9IW12d/BREmgkwXaG3QS9A==
X-IronPort-AV: E=Sophos;i="6.07,162,1708358400"; 
   d="scan'208";a="12768208"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2024 13:01:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XT3VyKumGDgjpdL0fWPRD65bfRzALsTqJXRuOc1GVRr/1zhRU+3pLiNGXywBZE+06m2oyglKOurrwGvtgrV2tpn5vMeLJ3HUX8Uf5WFJn2ipJchH54GzUxb7m3f7JlGULjRdsT+TcknaZ0aZjBwx2cT56d6FRU6VpBYrCgMan5O5PLFQizT90RjVojR7IlnthZjTh03fC1D/wreJSP9EK0Qe/rj/v2+9HBEeMPsRotLLZ6Fu4KHu6REBBZu3I8y9n1Ebku4PzrlRviAnvcLI8z0g+EDcsdNmRiDWKk1eReX2jsG/Lu9FMSumQhUhyOXw0RJ5vsoqxEfsSb/nKZ4uRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aG45nT2ONYbjWQK9bSdI5ATbwTaJWmezyaKoKlxeyDw=;
 b=fucBYiApfR2wS2kTdU6bmvhnbtPDqZITxRY4obm01WCKnYT5xjEi+T53RqfqhpspIrATWUHPEeHrl/OK81K0F7W/sjdqI5r0pyvYTUZRsKxmF2I/c/5rRuYXSrsbgOuqg6eekGWSKlrYRN6dDleKiftlus0Q/uAN/8p3Q5q0lKcn7ULaN00MA9FJyoLGLMMBHDhJXyNTSZtqeQeFk9wLIuaD3AsZ3vxH8h+hzrd4zw9yQ0y+rOBByJyWLXov7sM5iN2lpbhn3ywowoU/qDWFAdM038eQrnBcceTSaLDXasziMwOLyWGznYxMZnPq/3GLUiV7ZqS95/lqNxHirBPVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aG45nT2ONYbjWQK9bSdI5ATbwTaJWmezyaKoKlxeyDw=;
 b=GsQKTSZXLFDmiGrxTPhJ/ZraTRTfh7ghMyOwoZJk6bzJLEXQ8fUtbJ3AVARYwtVZuh2G8TFnhl1m2/x6WTSiUz6VZPmKY8NqN+IKoYSEdG8KRjoS4Gc68fkpUOTexZI/ZCJyEhWat5Pruw9u/A9dOW3Tje6uYOGbVGGqUfMNXMg=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6961.namprd04.prod.outlook.com (2603:10b6:a03:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.38; Fri, 29 Mar
 2024 05:01:16 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f%2]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 05:01:15 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"nbd@other.debian.org" <nbd@other.debian.org>
Subject: blktests failures with v6.9-rc1 kernel
Thread-Topic: blktests failures with v6.9-rc1 kernel
Thread-Index: AQHagZYgqtzOkiKxokW2p8hwnjoFMQ==
Date: Fri, 29 Mar 2024 05:01:15 +0000
Message-ID: <m6a437jvfwzq2jfytvvk62zpgu7e4bjvegr7x73pihhkp5me5c@sh6vs3s7w754>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6961:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 l/Xp01CMbVMXxGkqJWVoL4LHFYaLRnO8sGjfjXePDtXkhp6cjBd7BfCMgzxJgYzb9GReqVX1GA7OZ0lNzWaYC347hyvmJwrIzUkdfHbDTrjK/lTgENhs5vFzmx/M6fpZ6TOms4Getfwwl3q4Hi9l282ewQlYd44U21eV1NtLwd0DP/9+LXWvEts3dAVpvf0mYGV5jQvWXaM68x0V2bDZkMklmABkuhrutBV+6/QEBwo9/cljV1hhPMOPre12BBO+3vLMoJ9MEyRHoOsHIF+xZ+J1lUeWPKWk7WhV93ERChL6I3ungXxJ4g5dHWJQAQSB2MU1K1+sTykJks3HnN9IRybz/cHZC95bXIyyONcW9iwRiWpW1KP/qaTM5eNDYxKcpHr4S5jwTn50ZO8Vvc/HBtgckuQnNkCXooBbnktrk0IHC1kJouomfD+9/immP+vPWI1EMNJIlAnNFo46cg+SeM1UckASMf6jbO43I4wknH3ej9TFlMbwOEKnZZaUq32OdQrF3mgAVKaN0CaGNxvH4b3vaFuqrkBCEc0RIGN/92S89uTqj9wPPAjszG3T9vjeDxZq5k/HRgMC1WLb9kTY5UM1lQxZ8XRMTzXhUfZ+n9/sIREGyBm/NS5rwldcCBzn
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?e8Fvwy9XRweF30MiWy9+ABYfH4K4nczEKmkSVos8t8OD5l8F7kvgK04KRd6f?=
 =?us-ascii?Q?igWUtaNWHt/sBw2FAE9exdyinqQCTsThppcvfqiJUkXoo5Nq5WOLoEBgaHHC?=
 =?us-ascii?Q?AOrVyrKkCSnhesw+dUs+jPzCe9BpYYQX/99Mhnxgdg/yIfsmQ6TtyY0OZ1el?=
 =?us-ascii?Q?elwJkFxk2k1LQ/I963EDj/x6I+8zOu2fGAUM3IoY7cAVU2bAQkkgBG4JPfLb?=
 =?us-ascii?Q?+oXTA5Rf+HZOyWemzA9Osrb9wngXLZeqn6EGCEwj/EZ8v+mFZX6MwNH+9q4t?=
 =?us-ascii?Q?FzdzTVE1VMbHCYG2ft7hlGtS2UxEYVz6Ud/NA1NS1rBW5rC+zES6yGwGMSKY?=
 =?us-ascii?Q?wYZ+Vj7yX4D34fBebtmpaP7kug9jQNN2NJiunlcRVTaRK7ltSL+R8bBGjouL?=
 =?us-ascii?Q?iTUaaoIubXMTkcY4if9PJEZYMXWT5nHzfQwTDasQbEK7khUjz9fP1QWJMkjU?=
 =?us-ascii?Q?JECKiR0tnOE9iWDwkkcSSV//HuwRHJu86m6QpTub8d/gr1hb485xbBt2WvAU?=
 =?us-ascii?Q?a36axlTGU7mAcM8w9E5ouQQTGvZE0PgKNQS2dFSB+2CEH2nkAokB1iO6jy5K?=
 =?us-ascii?Q?ikgI2ccD2Bc7pPSa+9+r0sBaKmXHTjKioftb8sGIHCeSwRPYJY9zfcVYuB8U?=
 =?us-ascii?Q?NiSFtctHDGxcl10Sp07n/9NtDwScRYfr2EqlL2+VvEuf3Unw6P8mJ/WXMo/J?=
 =?us-ascii?Q?HQXCR57oBp0XrrTFz7lGWtVWJu/wr9PilOR9fCSbKhyrT7RIxPZqsiqu0h/7?=
 =?us-ascii?Q?LjJF3XMhqh3T+9QPsMSgLkR/8Xq5UZvgSY1yjb6qcY9a+oZHFhJnzW2u5kgP?=
 =?us-ascii?Q?QfNHfPX/lycEEzvu8mFILP3N3HlWuqZAy591Usq1Qzt4hjcyO0cm6cZp47rf?=
 =?us-ascii?Q?VwE/yyB+xql+mLDwBFmEQf23C2dQeQT5/CoOy2QlLcE19joKUT1ZM0YxqPS0?=
 =?us-ascii?Q?yfuZ0/SuLOMDoItqcSPyH9ht65l8rqA30ETZbmDZXhP/2YnE49oem3SIFWjH?=
 =?us-ascii?Q?K8Oz+rDXymhs3DGkdnVWoetxaOf/WFKJPTK55pjkczxqC9/+lAwoH+g0zDvT?=
 =?us-ascii?Q?qgErLt5StZK9knTP7OqXvYQuEggv4NQf7u+4IOJls3IZ0tcbn2ZL2lU/YWVn?=
 =?us-ascii?Q?dKuOqMr8MAQaoRJJz7n/0WDQ4JyzcdSiHAk2pM6boNVA1Cu9/0yMn+cNz6n+?=
 =?us-ascii?Q?cQR8fyQenYPPLdjJ63s5r/OIyLiw1Xt0afUwU2Pyd/TGiDOXDx87PrCTx2Eg?=
 =?us-ascii?Q?zEVAmL3thIaxtUGFVNsXJIb+Ra+zUJCE1jI3CV5hj6FNVIQUg0HGjGkFsTov?=
 =?us-ascii?Q?sHpv9vbiwKUMhkYkRq6+IfXwJoGFBxWdzI/jH2q2YoX1rPAxB7tP5qUxOIza?=
 =?us-ascii?Q?dJSKGm/WfasU7//TcfwQx+/rNr+p6y2zWnRzWjuW659xu9/kZ6bHy382mnp8?=
 =?us-ascii?Q?+lBAHOkJ8fHnr+GTagxjgwpXQexXxU4C5uCbs9adG/x/5DY6Gpf1F8J8ubQ9?=
 =?us-ascii?Q?QjDoGUSPz27n2xqHPYke3lLZkK/DGe2jbgF69HxHvchLz2Efdrbm49gYzgTk?=
 =?us-ascii?Q?4p/R/YM8DEVYsMdVZeJtPwJK0pxVLKog2NcF0JEG4Xf4VQmnr8U8u+zusrAC?=
 =?us-ascii?Q?08Heze8SEV2HE4zEl5SQink=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <192B09D78754B2418114B51533E76E6A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	76WCiR9y28bi5X973FlM+7pcuTIr6mfUoCtohJg4fN/A7IkTh6WtHEfsS+66MqKHybuJ9LPOVQgDmPEAAsR/foTOEYCHom3L3KQ+zKxJuXso8FP0qYPPAOsS+Y1pmvxcNgcQ9etyswia55ABbSq+OFFgviBaFCEOYAL54rQB63OaFhgjSspI5BRWA52WoNfw0jjkaGtph2GwGHL8mQGd3F6tpnnYKS8PU7vcLL8TfITwgGxo5GbeV3pn8te6L3jkS2nGT1uG5qOFSWj8LA1c9Om2dui5/xtTco3zBItAFiguxtHdl0VG/W86ovyZGkNL+Alnvz2ZDHn0MHKnAX15FP/nZzv+LmwRfzqCHzXpaj54ppNRUZvWtVMq80DmTatgIKkc7YFLc58Trc5e/v0y4RAik3AnE+kRN3Vdr295i9AP3iiXj8Qp0sRsKN36sGWmHcHTXpu6F525Z5DO+adQLAGbI3ZNED7C/4D1BSo1HQojCDoOd81Qc2BMVI3+2KiCoyejzWcy4EwRi3rpcTHY3Ln+lXksiLfcX29uOxOoFFNCi7WCcI/9wqD1XFd2LT0CI47ooHUoGh0bEfEBmBYsTy/7W0YuSt9QDLaGYuErb3q4ha7cFbaVnNazVRxHAgXs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d714e83-9e3d-417f-c16e-08dc4fad4357
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2024 05:01:15.7421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: riLMh/sGYLDCKXI+QjuZVB1LlQj64Xcfs+Q2S/fzSq4ZXwrip5Vl6TOHd7DnjUzQ9u3Jf4Pq7o3uP20zotA2kHkj2MUIgP0uQxGo+71rqh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6961

Hi all,

(I added nbd list to the To list since the nbd test case failure is reporte=
d)

I ran the latest blktests (git hash: 607513e64e48) with the v6.9-rc1 kernel=
, and
four failures were observed. I also checked the CKI project blktests runs w=
ith
the v6.9-rc1 kernel and found one failure. In total, five failure symptoms =
were
observed, as listed below.

One notable difference from the v6.8 kernel [1] is block/011. The test case
failure with NVME devices is no longer observed. However, exactly the same
failure symptom is now observed with the other test case nvme/050. I guess
some of the kernel changes between v6.8 and v6.9-rc1 caused this symptom ch=
ange.

[1] https://lore.kernel.org/linux-block/nnphuvhpwdqjwi3mdisom7iuj2qnxkf4ldz=
zzfzy63bfet6mas@2jcd4jzzzteu/

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: nvme/041,044 (fc transport)
#2: nvme/050
#3: srp/002, 011 (rdma_rxe driver)
#4: nbd/002
#5: zbd/010 (CKI failure)

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: nvme/041,044 (fc transport)

   With the trtype=3Dfc configuration, nvme/041 and 044 fail with similar
   error messages:

  nvme/041 (Create authenticated connections)                  [failed]
      runtime  2.677s  ...  4.823s
      --- tests/nvme/041.out      2023-11-29 12:57:17.206898664 +0900
      +++ /home/shin/Blktests/blktests/results/nodev/nvme/041.out.bad     2=
024-03-19 14:50:56.399101323 +0900
      @@ -2,5 +2,5 @@
       Test unauthenticated connection (should fail)
       disconnected 0 controller(s)
       Test authenticated connection
      -disconnected 1 controller(s)
      +disconnected 0 controller(s)
       Test complete
  nvme/044 (Test bi-directional authentication)                [failed]
      runtime  4.740s  ...  7.482s
      --- tests/nvme/044.out      2023-11-29 12:57:17.212898647 +0900
      +++ /home/shin/Blktests/blktests/results/nodev/nvme/044.out.bad     2=
024-03-19 14:51:08.062067741 +0900
      @@ -4,7 +4,7 @@
       Test invalid ctrl authentication (should fail)
       disconnected 0 controller(s)
       Test valid ctrl authentication
      -disconnected 1 controller(s)
      +disconnected 0 controller(s)
       Test invalid ctrl key (should fail)
       disconnected 0 controller(s)
      ...
      (Run 'diff -u tests/nvme/044.out /home/shin/Blktests/blktests/results=
/nodev/nvme/044.out.bad' to see the entire diff)

   A solution was suggested and discussed in Feb/2024 [2].

   [2] https://lore.kernel.org/linux-nvme/20240221132404.6311-1-dwagner@sus=
e.de/

#2: nvme/050

   The test case fails occasionally with a QEMU NVME device. The failure ca=
use
   is the lockdep WARN among ctrl->namespaces_rwsem, dev->shutdown_lock and
   workqueue work completion [9]. This WARN is the same as it was observed =
with
   block/011 for the kernel versions from v6.0 to v6.8, which was reported =
in
   Sep/2022 [3].

   [3] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@=
shindev/

#3: srp/002, 011 (rdma_rxe driver)

   Test process hang is observed occasionally. Reported to the relevant mai=
ling
   lists in Aug/2023 [4]. Blktests was modified to change the default drive=
r
   from rdma_rxe to siw to avoid impacts on blktests users. The root cause =
is
   not yet understood.

   [4] https://lore.kernel.org/linux-rdma/18a3ae8c-145b-4c7f-a8f5-67840feeb=
98c@acm.org/T/#mee9882c2cfd0cfff33caa04e75418576f4c7a789

#4: nbd/002

   The test case fails occasionally. CKI reported this failure for the v6.8
   kernel also in the past. A blktests patch reduces the failure ratio, but=
 does
   not avoid the failure completely [5]. Needs further investigation.

   nbd/002 (tests on partition handling for an nbd device)      [failed]
       runtime    ...  0.414s
       --- tests/nbd/002.out       2024-02-19 19:25:07.453721466 +0900
       +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/=
nbd/002.out.bad 2024-03-19 14:53:56.320218177 +0900
       @@ -1,4 +1,4 @@
        Running nbd/002
        Testing IOCTL path
        Testing the netlink path
       -Test complete
       +Didn't have partition on the netlink path

   [5] https://lore.kernel.org/linux-block/lecgttcqtjsolotcowjvqwsyrphe7fuc=
llkrzupc5guf2gbq5z@grmwusovo22b/

#5: zbd/010 (CKI failure)

   CKI observed the failure [6], and Yi Zhang reported it to relevant maili=
ng
   lists [7]. Chao Yu provided a fix patch in F2FS [8].

   [6] https://datawarehouse.cki-project.org/issue/2508
   [7] https://lore.kernel.org/linux-f2fs-devel/CAHj4cs-kfojYC9i0G73PRkYzcx=
CTex=3D-vugRFeP40g_URGvnfQ@mail.gmail.com/
   [8] https://lore.kernel.org/linux-f2fs-devel/20240327074223.2216487-1-ch=
ao@kernel.org/


[9]

[ 1907.056570] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 1907.058993] WARNING: possible circular locking dependency detected
[ 1907.061446] 6.9.0-rc1 #158 Not tainted
[ 1907.063639] ------------------------------------------------------
[ 1907.066017] kworker/u16:3/2996 is trying to acquire lock:
[ 1907.068423] ffff888120ab39b8 ((work_completion)(&q->timeout_work)){+.+.}=
-{0:0}, at: __flush_work+0x48f/0xa40
[ 1907.071311]=20
               but task is already holding lock:
[ 1907.075601] ffff8881389f44d8 (&ctrl->namespaces_rwsem){++++}-{3:3}, at: =
nvme_sync_queues+0x26/0x100 [nvme_core]
[ 1907.079089]=20
               which lock already depends on the new lock.

[ 1907.085827]=20
               the existing dependency chain (in reverse order) is:
[ 1907.090475]=20
               -> #2 (&ctrl->namespaces_rwsem){++++}-{3:3}:
[ 1907.094962]        down_read+0x9d/0x480
[ 1907.097356]        nvme_start_freeze+0x3d/0xd0 [nvme_core]
[ 1907.099900]        nvme_dev_disable+0x57c/0x6b0 [nvme]
[ 1907.102365]        nvme_timeout+0x8a9/0x11f0 [nvme]
[ 1907.104854]        blk_mq_handle_expired+0x1a4/0x270
[ 1907.107065]        bt_iter+0x22a/0x310
[ 1907.109108]        blk_mq_queue_tag_busy_iter+0x809/0x1380
[ 1907.111374]        blk_mq_timeout_work+0x3b9/0x550
[ 1907.113582]        process_one_work+0x802/0x1720
[ 1907.115707]        worker_thread+0x720/0x1300
[ 1907.117805]        kthread+0x2ec/0x3d0
[ 1907.119851]        ret_from_fork+0x30/0x70
[ 1907.121981]        ret_from_fork_asm+0x1a/0x30
[ 1907.124167]=20
               -> #1 (&dev->shutdown_lock){+.+.}-{3:3}:
[ 1907.128058]        __mutex_lock+0x18d/0x1480
[ 1907.130117]        nvme_dev_disable+0x9b/0x6b0 [nvme]
[ 1907.132239]        nvme_timeout+0x8a9/0x11f0 [nvme]
[ 1907.134383]        blk_mq_handle_expired+0x1a4/0x270
[ 1907.136500]        bt_iter+0x22a/0x310
[ 1907.138393]        blk_mq_queue_tag_busy_iter+0x809/0x1380
[ 1907.140515]        blk_mq_timeout_work+0x3b9/0x550
[ 1907.142490]        process_one_work+0x802/0x1720
[ 1907.144459]        worker_thread+0x720/0x1300
[ 1907.146355]        kthread+0x2ec/0x3d0
[ 1907.148235]        ret_from_fork+0x30/0x70
[ 1907.150093]        ret_from_fork_asm+0x1a/0x30
[ 1907.151741]=20
               -> #0 ((work_completion)(&q->timeout_work)){+.+.}-{0:0}:
[ 1907.153987]        __lock_acquire+0x2e98/0x5ee0
[ 1907.155190]        lock_acquire+0x1ac/0x520
[ 1907.156396]        __flush_work+0x4ac/0xa40
[ 1907.157483]        __cancel_work_sync+0x2c5/0x3f0
[ 1907.158586]        nvme_sync_queues+0x71/0x100 [nvme_core]
[ 1907.159772]        nvme_reset_work+0xaa/0x4a0 [nvme]
[ 1907.160903]        process_one_work+0x802/0x1720
[ 1907.161994]        worker_thread+0x720/0x1300
[ 1907.163054]        kthread+0x2ec/0x3d0
[ 1907.164175]        ret_from_fork+0x30/0x70
[ 1907.165187]        ret_from_fork_asm+0x1a/0x30
[ 1907.166199]=20
               other info that might help us debug this:

[ 1907.168719] Chain exists of:
                 (work_completion)(&q->timeout_work) --> &dev->shutdown_loc=
k --> &ctrl->namespaces_rwsem

[ 1907.171733]  Possible unsafe locking scenario:

[ 1907.173507]        CPU0                    CPU1
[ 1907.174512]        ----                    ----
[ 1907.175509]   rlock(&ctrl->namespaces_rwsem);
[ 1907.176490]                                lock(&dev->shutdown_lock);
[ 1907.177643]                                lock(&ctrl->namespaces_rwsem)=
;
[ 1907.178784]   lock((work_completion)(&q->timeout_work));
[ 1907.179817]=20
                *** DEADLOCK ***

[ 1907.182067] 4 locks held by kworker/u16:3/2996:
[ 1907.183055]  #0: ffff88811a053148 ((wq_completion)nvme-reset-wq){+.+.}-{=
0:0}, at: process_one_work+0xf57/0x1720
[ 1907.184498]  #1: ffff88810fd97d90 ((work_completion)(&dev->ctrl.reset_wo=
rk)){+.+.}-{0:0}, at: process_one_work+0x77f/0x1720
[ 1907.186027]  #2: ffff8881389f44d8 (&ctrl->namespaces_rwsem){++++}-{3:3},=
 at: nvme_sync_queues+0x26/0x100 [nvme_core]
[ 1907.187564]  #3: ffffffffb8e79a20 (rcu_read_lock){....}-{1:2}, at: __flu=
sh_work+0xf5/0xa40
[ 1907.188948]=20
               stack backtrace:
[ 1907.190707] CPU: 3 PID: 2996 Comm: kworker/u16:3 Not tainted 6.9.0-rc1 #=
158
[ 1907.191954] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.16.3-1.fc39 04/01/2014
[ 1907.193367] Workqueue: nvme-reset-wq nvme_reset_work [nvme]
[ 1907.194546] Call Trace:
[ 1907.195486]  <TASK>
[ 1907.196380]  dump_stack_lvl+0x73/0xb0
[ 1907.197398]  check_noncircular+0x306/0x3f0
[ 1907.198435]  ? __pfx_check_noncircular+0x10/0x10
[ 1907.199516]  ? __pfx_lock_release+0x10/0x10
[ 1907.200576]  ? lockdep_lock+0xca/0x1c0
[ 1907.201592]  ? __pfx_lockdep_lock+0x10/0x10
[ 1907.202643]  ? __lock_acquire+0xcba/0x5ee0
[ 1907.203707]  __lock_acquire+0x2e98/0x5ee0
[ 1907.204768]  ? __pfx___lock_acquire+0x10/0x10
[ 1907.205855]  ? __pfx_mark_lock+0x10/0x10
[ 1907.206883]  lock_acquire+0x1ac/0x520
[ 1907.207940]  ? __flush_work+0x48f/0xa40
[ 1907.209032]  ? __pfx_lock_acquire+0x10/0x10
[ 1907.210139]  ? __pfx_lock_release+0x10/0x10
[ 1907.211193]  ? lockdep_init_map_type+0x169/0x7c0
[ 1907.212324]  ? mark_held_locks+0x96/0xe0
[ 1907.213349]  ? __flush_work+0x48f/0xa40
[ 1907.214361]  __flush_work+0x4ac/0xa40
[ 1907.215351]  ? __flush_work+0x48f/0xa40
[ 1907.216397]  ? __pfx___flush_work+0x10/0x10
[ 1907.217438]  ? __pfx_mark_lock+0x10/0x10
[ 1907.218458]  ? __pfx_wq_barrier_func+0x10/0x10
[ 1907.219544]  ? mark_held_locks+0x96/0xe0
[ 1907.220569]  __cancel_work_sync+0x2c5/0x3f0
[ 1907.221628]  ? __pfx___cancel_work_sync+0x10/0x10
[ 1907.222703]  ? __timer_delete_sync+0x17f/0x2a0
[ 1907.223777]  ? __pfx_lock_acquire+0x10/0x10
[ 1907.224805]  nvme_sync_queues+0x71/0x100 [nvme_core]
[ 1907.225898]  nvme_reset_work+0xaa/0x4a0 [nvme]
[ 1907.226949]  process_one_work+0x802/0x1720
[ 1907.228003]  ? __pfx_lock_acquire+0x10/0x10
[ 1907.229043]  ? __pfx_process_one_work+0x10/0x10
[ 1907.230089]  ? assign_work+0x16c/0x240
[ 1907.231090]  worker_thread+0x720/0x1300
[ 1907.232145]  ? __pfx_worker_thread+0x10/0x10
[ 1907.233183]  kthread+0x2ec/0x3d0
[ 1907.234144]  ? _raw_spin_unlock_irq+0x24/0x50
[ 1907.235199]  ? __pfx_kthread+0x10/0x10
[ 1907.236265]  ret_from_fork+0x30/0x70
[ 1907.237223]  ? __pfx_kthread+0x10/0x10
[ 1907.238177]  ret_from_fork_asm+0x1a/0x30
[ 1907.239126]  </TASK>=
