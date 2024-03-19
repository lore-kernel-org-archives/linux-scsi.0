Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4AF2628C;
	Tue, 19 Mar 2024 06:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710830721; cv=fail; b=ORVdVnVkkIxYzV1BRJwJvc6evEllYWKfHk0nQukU6/UgtBSlivNsKd25rjBt8I85nJuEqJ6GSHfVuN2fLHngX+NzGK38qRxS6CsTvuBLsn9qnyhtrhItRgR/znsbg+ziYZ02xabVliAYtnta+SbUfquvKGuJJzrOHObZBQ/9LYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710830721; c=relaxed/simple;
	bh=g0T0F7ynGuWPtVPja+tM5PzKMnj+OqLs1yf8tlbBeUA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nZy1+Q1pg75aB9xoq16E1d0ddAK3uAQKU5FDTEFY5TuroBLA7MlEhuypblKy89ZBLYNnPkno+v1HQXlqAh+Re9wZBuAEhdijO8ND87MPK8SlCpizcCooD/f6fXzAO3f7MktQUhuE3RK4xyKAzme2kwCsJiKnzHh2exJBHvewojk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GW9tWgD7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Quag0lKQ; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GW9tWgD7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Quag0lKQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710830719; x=1742366719;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=g0T0F7ynGuWPtVPja+tM5PzKMnj+OqLs1yf8tlbBeUA=;
  b=GW9tWgD7vf/cFmX6vQ0hmRsRcUQMxPIHPSfMesHLHTdpCP6YSsEwvftU
   PVvLMP+I2apwxoDqHRTrVjZt/G66u8i/AX4Bdv0ro+obqszBMWcLqcVN3
   4p1IChdATr+cFmEbai7N6I7ddMVNEUa7u127EsO3q1vIexQHE8KkrKoYz
   tgbdrZ+8dymdmdd3I6qpPCuvaxPhuEESZXhVuz+LGSxvdPZ5kqJylOYta
   bbak5OTicG9izU+6AnHdjeRYhnGtQpNcAnagoRWIp2MaVLp/J2/l088D0
   tAKOeyp+heRDnmFdtiSTHbHmsgX8Z8uA25q/qPgCXwMBMKH0h2A4Y20IX
   Q==;
X-CSE-ConnectionGUID: rmuDsxqjTaq1VDTmuzHO+w==
X-CSE-MsgGUID: DoMhDWJmQeSsjS5gz7INzg==
X-IronPort-AV: E=Sophos;i="6.07,136,1708358400"; 
   d="scan'208";a="11924382"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 19 Mar 2024 14:45:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF0ZDnGONWox1X4ae4o8cc0v4Gyv+PpdmeI57XIN5NNALGCxSJbM48UvewUeu8FHTdUgVnhlBHwT65/Tdaj2Sj51vGwN8J8PflNaJg42MF5f8WES/huSmyp7xkkqYDgHKnnh0gpVxRv81/K8h4uZqYhy+8MglboMXHIELSXRXjyGfm2d/jqC1LGU8jydFKwbTA2saNVTi5sIrgmGtVCkbZzVFEHW4t057DbPLZdzpLzTGdFYrWMz6FFiH0HdCIRNFl1xmM6Ij5vglTvaXbOLplg/1eltnl1nHjba4csZ8Jmtpxxwtg5PREee0VViGYPvLBJjG43+PJLCPBbjP+jAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uv4qlsnA1DrwDIx0AQ1W+q2z7m44kmCstLWTG/9vz2o=;
 b=WvFKYl6EeGnunK9V3f27tx7ZeYyrnRNKRtHBdXJv67CGp6P6Z8IEAPAFDPT6dAbovYv33FtzM7ng9iA+WVTF+2fxPI2u0i50DoNkcxXbo4TFk7ozmYwFAUG0Lvig9WhDu6qNO+/L7XuGcDjYAhl+VK36WQd++6q86Ml/DwVLPGB0vdvzadOQVw/MdAh9pmUPoSlZCq6YzyblMqkB4dCERNcRvfwrBTnCdZ7aEyiw8OnK20LmNlWBIjKIdD/UXyOsb49vSlQJHDbaHsTgKeAQFWYhBQWU2iRx/wt7g4M+h6wZvanKNFdbwlfUoHPTXnxkQYZ6v8ONhbFgv8pODW6kIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uv4qlsnA1DrwDIx0AQ1W+q2z7m44kmCstLWTG/9vz2o=;
 b=Quag0lKQ/tPcvNHTL26hRwJJZQO3sXvYRijJzTmgrMKVgVk551tOOxYxPdzVDxL5yIrf/m7exMsAdwRD6htpQRjgR0wk3odzu4h0J/ujN+2sfNeTip2mdAWuCsce/+I7Qjv/uhW6oueROiQjRapgKTVr2xFjV4lDTsUdxnl1ptI=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MW6PR04MB9028.namprd04.prod.outlook.com (2603:10b6:303:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Tue, 19 Mar
 2024 06:45:15 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c9e3:b196:e5ea:909b]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c9e3:b196:e5ea:909b%4]) with mapi id 15.20.7386.025; Tue, 19 Mar 2024
 06:45:14 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.8 kernel
Thread-Topic: blktests failures with v6.8 kernel
Thread-Index: AQHaecj/zvuVB3EoB0uUdtDSGjORsA==
Date: Tue, 19 Mar 2024 06:45:14 +0000
Message-ID: <nnphuvhpwdqjwi3mdisom7iuj2qnxkf4ldzzzfzy63bfet6mas@2jcd4jzzzteu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MW6PR04MB9028:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 /0nygOA833VPirf3bKlUSlw6YhnP+DPxA0XICJAC4KyI51NNuYUNqsWboMaqaL4p9ua3aoS5lomqIKAftWuRCVVdDbNO1XsQp4K5d0KxfzdNQRSoQ44sacmuY81FjiiUXyAZ4zXXBrSozcIWUdGQQoJZOc+Mn8/DRoV0SSWf2VwF+bNn3SMe1Ju96DsHLF44rKdsgc/NWX/f+RZeccLbeb5D/CoqjG15qMQCarbg0QXNIMYe3XrTvrfETLdK3ws4Of2yyG4ketVrRilLItTmU8HuKq2ij8uiTwEqS4cezgyNAzfMEOBVr0+JHFDj2Kt6HlwIM07+I5iK5oKnoV2KZlAy5h+RzWoe5g9/1vItX+tDxbp7iQRAr1ZI6QM8Cw+bhdrF6y0E62HJ4qNbGkp4sGxfL/vDYkVIhYrynEYJDfLl/Xfr931v9cRBCx85pfIi2z3wKgSrdpIXPrvWe15l3wEQMDcOon6+eTe3K7OQ6JNlwExjn4te8G/YZr6jNaU03CdTHY/4rdTl/34TsPXdrS1R/YepzgFM58Ec3iQnDWwXeSL4Q9LF2eOhqwuY+cPX9Ss34fliM7nfZNO2OTc0ooYo34csRuHnQIQngdkDiJc1JxuCwQlvqy2i3JhL3x2s
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ilkk4DTBKdIYrheC3nNwlxVTX4ajG1FzvQITBQzyrD4ChCRKBXaJi5SgHlfx?=
 =?us-ascii?Q?1uUcMXIaZUv7504xmxZ83B+vvi3/GWv0U8Rggtb2u0LGcUgn49W2gZqrUIIM?=
 =?us-ascii?Q?cFk7SGTbAmk+U6tYTVSHoRegGIKaKYJtJdtQG3G/DuxD5Hp62H6obqjlNPiL?=
 =?us-ascii?Q?wTY9z0KhcS7n2uGIl0qGAJfPMWRqtAarjTLOG4FSXLkFMohwCN30Zr4rPx4m?=
 =?us-ascii?Q?yOpvblAB7sFftQXUd9N1FrX1OkUKWqwj8MeCeN8zLxoRB49sYdW3vTq79kOj?=
 =?us-ascii?Q?NjnOa7XA1thRJKc6SR0KVHKRvnB0ZuyWdw6HvQQEgIYp6X6xkE7fAU9Y9tY8?=
 =?us-ascii?Q?0lCudvzmlOSULYLLP2NWX64biGlJeNmr4VWJfPlY81rKalR6ZTP/2Mo0Ecnq?=
 =?us-ascii?Q?aGusccn++ZkjQJNEicOCj0KiXzH4s52lQUz6AlApQYXoJNwdwRkDMi0ufG4P?=
 =?us-ascii?Q?6vrojKVtVeFBVOD0US2SPk/gPTGuhWKUrXS0dWp13P6lCpRVHx+Zh4wmbGRr?=
 =?us-ascii?Q?Uzwj/WYc/Gsd0IdkzlhohaMWHuL7pR7UF+7RbjOebHdLAqluA5XVNhWe83SW?=
 =?us-ascii?Q?NFD1Hzxo1wnn5AcF9cKBGdve3bLcraHwrVJkku/F+NUpbN8h/8dmiODqv0Xn?=
 =?us-ascii?Q?joCPE+7SkrKGsaWt3pe/5pLHEGALwyuXzUtTfIAX+iOzex6Ytfbd5aIujlxi?=
 =?us-ascii?Q?L9Hzcowkq/EeW6T6OSEzGNw4QyoFbOWzAgDjKTqE+Zen3GPxu4eqAb1Wd3yh?=
 =?us-ascii?Q?MLvx5pZAVaZt9gSYJ6gYW7vHrVZzCI2765nSmL80pMVbAExlBJ3KUZsnILrV?=
 =?us-ascii?Q?EynQ6MivIghm7cAGE9gzWXGNS4ISGBqIt6IWfWI4xQyOGGWtQOIa4SZzWE/3?=
 =?us-ascii?Q?ICbenQm7UdXwhXkhYay1ZKiREs16ia/qN5wZ4S3VMMnMzvRdikpZM61LUjh+?=
 =?us-ascii?Q?YVlw/1keSk+hzmBvHyc8BAnmhxo8J+NuDdOSNgHrW8NxlrZNS+83LZsf8yb9?=
 =?us-ascii?Q?oh9VJSrP2Ob27t6j3V/UIw/ejif5Lr1zVkJcxdyywCTf0jGzymw/JBlf7XxU?=
 =?us-ascii?Q?Qly6dJGLhpiOYoRL9M6u0kKp89/o7Vw5M9fDpHIUwcgcB3ZaH5eHeEGsCAYz?=
 =?us-ascii?Q?oflIw4qIK5P8nYHCCCrAGL5uAiLH3OlwsEHkxOVQ/DWPUR3abVGboxhMnJE2?=
 =?us-ascii?Q?AQNrwwnLntpYiD4TWkwO5f7gToqP4RjUZ7At7zZBsFedBVbPD9zg8e4Q7jcT?=
 =?us-ascii?Q?SrXichC1Q12rYhJIm9ybJP6aQNJ/NobQZ14cNW7IJq5+NeL1G63upe/Kn3Jg?=
 =?us-ascii?Q?Fi/Joft9NBDbuQ2v98jHA9J6ICLKQlIwliNO0Csb9YAkApLAfzTU4eg5kmh2?=
 =?us-ascii?Q?q9CIieG1a6OttIOdzv1pIox33yUeNUgXR8H2oePWl9MzBuhc4N4vJlLNDY0y?=
 =?us-ascii?Q?aTkT1P0o0xVShIe8fgLagz9H7SRKLrd9zUVYC3CEMGGdZz37kM66stJF/DD8?=
 =?us-ascii?Q?QSVjP1Fyh9sljk3R0pNOPO4hwfvKDssEljQepUusO56MUmrCEvhpF/K2wIxX?=
 =?us-ascii?Q?I99SRplKu6OAdZmqnYSVTkfqstAFvB9Ws1HsrftaSmwKB6se4+vW5iHbBI4/?=
 =?us-ascii?Q?w8qwURgnyGj8F2gEaDvvzWc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7D35ED0C216C546A0607CF63DE0C0AA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sMUprbjTyCdKylI4zZbSZz50bmcguSHTuf/ug2FitSZqpGwmw+elVCdkHNvuItS9Y3f4PAOM5orvKfBRNxmo66p/xX5utM/yae0T2o5K59Cggs20atsu/CCGxh3MNTSGGGmgA3ch5RGAl3ulX8ZBUOgTBbviUhLAoasR1qowAoiwviVckL4laMNBJABrDHlv2bi8KYswQ29MUpTVWbnEm+HOyUTg7/5OVNHg/2OoQdbM8nwv+Q/mrLGXyOTUSII3BmogVS/kTaBOCI8fDANe8HoYMqhFBDhdLIPBNc6KjNFGjAf1obBSs89PCsnVp4oPpum51ukptGovnW5bWhSjHx9xqbJDwXG5mDrEP/2F+zkKqp+vgzq4C1QsNv3Ounk0ql7LD6j1e/JkgtVyalkbgMqga/OdqWT7HLatb8xWXhiltkIqlx7t5NK7C9gYns4dzF0l3bs59LQgJyZVk7hnHlRN0n0nsTmSseoAmM+jejXI0lccwE3ZKzJizB+JYkhsji5J7RgUbCJAu7GdStm2JnjPDBJ8K0/yLyXAxotLH/OAhGDaziHd15jCYh3tWc8ur7JhsACbO05oAZJauUPegbcqNGTJQDbLpcjaQ0vnLHm/hp5831wJU8DnKVptmKZ4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435bdf15-a788-4b5c-61f2-08dc47e021f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2024 06:45:14.7255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qeQp6YQn6SBcKQGa5XiTaU0HKOfgbJFIzi8CPjE6N6u40dRgO3rlIIyrdcspapzi0lC9kn48Gdzn3lFwqUbAjf+wSyw4pbwML4t3q5sNbq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR04MB9028

Hi all,

I ran the latest blktests (git hash: 607513e64e48) with the v6.8 kernel, an=
d I
observed three failures. I also checked CKI project blktests runs with the =
v6.8
kernel, and found two failures. In total, five failure symptoms are observe=
d as
listed below.

Compared with the v6.8-rc1 kernel [1], nvme test group has greatly improved=
 for
fc transport (Thanks go to Daniel). Now test runs do not hang. A few test c=
ases
still fail, but it is a great improvement :)

[1] https://lore.kernel.org/linux-block/44i4y3fyqcz6k2pmum6toqylc2lvveb7x37=
ngskzfof52hoi2r@vxdxdnmggbj5/

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: nvme/041,044 (fc transport)
#3: srp/002, 011 (rdma_rxe driver)
#4: nbd/002 (CKI failure)
#5: zbd/010 (CKI failure)

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

#2: nvme/041,044 (fc transport)

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

#4: nbd/002 (CKI failure)

   CKI reported the failure [5]. I confirmed the test case fail occasionall=
y on
   my test machine. I think blktests script can be improved to avoid the
   failure. I plan to post a fix candidate patch.

  nbd/002 (tests on partition handling for an nbd device)      [failed]
      runtime    ...  0.414s
      --- tests/nbd/002.out       2024-02-19 19:25:07.453721466 +0900
      +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/n=
bd/002.out.bad 2024-03-19 14:53:56.320218177 +0900
      @@ -1,4 +1,4 @@
       Running nbd/002
       Testing IOCTL path
       Testing the netlink path
      -Test complete
      +Didn't have partition on the netlink path

   [5] https://datawarehouse.cki-project.org/kcidb/tests/11634679

#5: zbd/010 (CKI failure)

   CKI observed the failure [6], and Yi Zhang reported it to relevant maili=
ng
   lists [7]. Though the WARN was observed with the test case zbd/010 for z=
oned
   block devices, it can be recreated with non-zoned regular block devices,=
 when
   f2fs is set up with multiple block devices. A fix in F2FS is expected.

   [6] https://datawarehouse.cki-project.org/issue/2508
   [7] https://lore.kernel.org/linux-f2fs-devel/CAHj4cs-kfojYC9i0G73PRkYzcx=
CTex=3D-vugRFeP40g_URGvnfQ@mail.gmail.com/=
