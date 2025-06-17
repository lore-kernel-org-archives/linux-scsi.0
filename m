Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A6A2BEFF3;
	Tue, 17 Jun 2025 06:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143574; cv=fail; b=DmHLWKVROZ9m+hp9bFsQBl9w8wQSF9tc3/I9w+bqEg+niXY2NcfXvNcXYnZwaUSeD3cKFQcntlVzFzKccgoAzgp6UnurNeklAFDOQAwY1pHA8zaIbg4UFPReFTjsKkOy6niye0UyDEG8yyl+EdbJtpSGH5cZ7Yca1u8fTMC++yE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143574; c=relaxed/simple;
	bh=ZN0pUalO3LrbJUZ/FzyMoO4pqJlXwcLIWkN8xKhqy7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BhzJYXH5YDD/e91gmAIH9fo19/Dim5nRRmm8gse3aIFn2961MZP+zZgFX2275Olu/Lt1Ats8uzuOuFAOPzmDxXfkWYUMURInN+SbAFF73iaK+imL82/tFTEojxYU89NyUdCi71kJTsjeViuDDyaEwNHfOnSowg0qsoJaCQJ9zLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=wrJVnbQw; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="wrJVnbQw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1750143572; x=1781679572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZN0pUalO3LrbJUZ/FzyMoO4pqJlXwcLIWkN8xKhqy7s=;
  b=wrJVnbQwzzdsMl85bB+70nnp2R4WXpKHmAYsELFt0srovJ8TBBmmS0N7
   1YLVR/HfiDMfDBbzlQVDQtC3TrW7BRwVVEbUFuq8frCFUES7+7zq5OV2K
   NbxiVSTcYl6gJ2/BOq4qZyXiueRgoM/CpzliCpSu59H/Upa7xmIZtm/e8
   liF6jey/Elx8R6XsbfbsbmeIhDoOxs9DG+RbrTBBq5a5nktgVdUt4ezSA
   dUwmiUXLOpE7gtpJhiqY6pj+QHTkdPu8gFG92B1gSpJAYxO7iS4N0gMfT
   qBAHLrPPzKAzWe3t9OG+XxUD9wtwAhnsGmzJ6Pqo27CzI3Cf73Elgf8X7
   g==;
X-CSE-ConnectionGUID: dK9X7s+YShezrs21nJiY7w==
X-CSE-MsgGUID: hROoXC3PSkKUDZfwsUPYmQ==
Received: from mail-bn8nam12on2129.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([40.107.237.129])
  by ob1.hc6817-7.iphmx.com with ESMTP; 16 Jun 2025 23:58:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eA19J9N4vz/DSYm5j9Ffp7oruyKmWQ9v1zE9N0O9XgTtAFJlG4G6yZA4xfRqcRml+d1IsO9YzoUFEn/HXHnw33PJF9tK9heHXSPcHeEJGeU8h8OS4/B5lIINepARMli8CybUoZ8T4ztczudkBGBGTFg5hoEi8717ukYsj7rEqA4Xs7IGZPYM+AQhKHkxxuilT047Tg7zysS20qfksmxB0JQCLLSXD4mKkcb0uSUYMPtSWkI8J97LzReuJBnB57emF+h6wN3RtrIb7aZxyvL/NnQrw71mrokr3w5vM9mXJiF7g/AkFbtFBxNzbRTctGRp3nZp9V6PbzXFeh0BBo4EbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/q1xW689UhddudPD5D5qCfL2LYQquwQEX6NNr0B4U8=;
 b=mag2SFRPP5MEsWfz0hj6iYr4ioPuknYzXCXwGaL678ZZXi3JEQGZVR4Bw5APnV+8cgFa34LlsMRqFBgc8H/TtqN2fSbazF/ILi/0Z+g/rK1RATjTKYx2klLbQWYvWwBCMG5IKemCnGcd/PJueC+Lw7o3gP/TTSCy5roVqYnxNV7Yabj1mVLy3fSi+IwH3WUXX1NuStUjT4wwfcx0NGHFoLv4oq1B6FQJTJ5BmThg4bjpKgLQk3Pm18Erb84x6rcayxlyrQ3T7KLERxbzusKdxefPXyI/6MsCfvZVWnYVL0ridLrfjH7PqGnAT0q9CtZxQgWL7O3Zx4J/sP2bpBSugQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ0PR16MB4221.namprd16.prod.outlook.com (2603:10b6:a03:31a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 06:58:18 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 06:58:18 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig
	<hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Can Guo <quic_cang@quicinc.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Avri Altman <avri.altman@wdc.com>
Subject: RE: [PATCH v18 12/12] scsi: ufs: Inform the block layer about write
 ordering
Thread-Topic: [PATCH v18 12/12] scsi: ufs: Inform the block layer about write
 ordering
Thread-Index: AQHb3w7yd4pD+Um7FEOhSRxYraX+l7QG7A/w
Date: Tue, 17 Jun 2025 06:58:18 +0000
Message-ID:
 <PH7PR16MB61969759518A891174BC74FCE573A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-13-bvanassche@acm.org>
In-Reply-To: <20250616223312.1607638-13-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ0PR16MB4221:EE_
x-ms-office365-filtering-correlation-id: ba0f7965-41cf-4320-7576-08ddad6c56f5
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?+2PWDmOwL3o2SUOXJp2ROX8/t9zdrkCc4ccBY62gC0JYZkqr+WDZ3/Se5zaz?=
 =?us-ascii?Q?D87/ULljVEbrX/9ZP4wCOBBb7Q1PSjRCiCw5XFQ+ogwMC29VkNzRXxAGORy1?=
 =?us-ascii?Q?1/9VU4XQbZGLgK/dsmvtcAeuSrvvBDwor1tFe3Xe6S3y8esqHtrC4BUorGID?=
 =?us-ascii?Q?NG8jg9abvITUjNBYm/az75nfB8/y05BXklDjzWTjVdQO+JktDMmofU0A+tEj?=
 =?us-ascii?Q?KDYfvyTcbmLStNlu/p+CIV+VbLa0LpilHKjxEHeKLCONT4yqiFZNECUZQWX+?=
 =?us-ascii?Q?BmLnZBAHZgLiBUYp3O9QZLTYHZNDI8P8OXlpHsXvE1DH8EHXioTe3jX+6x6q?=
 =?us-ascii?Q?426BYQxW0hZ9CVJzuz6M5W1I13TAP1MGk2D+gGuOH1WFcbr2U3AunnqvjzTN?=
 =?us-ascii?Q?6lPYigR7KmpMJdE4KLm7wXviWKi1o8xmxr8DKnRVfAs62ha9npLAN8SYHhzN?=
 =?us-ascii?Q?T2Z2YzoV402X2RaO3dBGHk8Gpw5B6Bo3j4m3+zGnJXaJwZ69lzWzZ5ks/YIn?=
 =?us-ascii?Q?6+0H6buj+V7NqeoQptYIyl8buQPfFLEKeir26I8SaHjs0OWpgRmmHejoIO9e?=
 =?us-ascii?Q?C/Ad6bNRe8pbh4i9Qf1Z44P85aFcOAoDX9/P6kiPR0sHreyhKz72Ql73gNI/?=
 =?us-ascii?Q?gy/wAofdREzBIJwTVInA2aVPV/VKC/Fgfih5ZbGPpbBfGm84qtyQ97TJXq9t?=
 =?us-ascii?Q?5OjrqbtJQqw9XcW9yhWglN93vD5A/caHS5KFT4B+n+ChKEI505MgPH+rvHWQ?=
 =?us-ascii?Q?K86g4RBCzo9BgezCoGLwHb7fdAldNuXp5Vihf18/RrFM7+MP5f6j2kdb3di+?=
 =?us-ascii?Q?RT76NB42HBbhZ7jQ2CrfqdoKJTUhfUhXEQpNRagJQ3kxYz+JsDSe5FA3+3YT?=
 =?us-ascii?Q?hn81rf4TICB6vyOmjqC97usaoXaBxFb9za2FpIxgnSxOH+0Me0K8otHtqg8i?=
 =?us-ascii?Q?GO+gs07MERJUgif28tLVQwm4ZKeRpyKjPhW7322rDdCiLQnumHLdXqxCvuS5?=
 =?us-ascii?Q?3SZlabXaLW0gI5xgjClzFLrFDECyjERtMrTZno5OrgcVlECKxzOPH3PwbMl9?=
 =?us-ascii?Q?tDqTFdllft+7FkwY9d1ZJWU+26oxB+46XJkuACtvCACZa64AHRsWiEVNQjnp?=
 =?us-ascii?Q?KOi9wNyczdMjTIHV1B373voFTAoaUToho23TR0SSBE2R4lC3daLnZikVJYHJ?=
 =?us-ascii?Q?dz0E4IaFG9rUDCppy6y/Akkwl2zmc16tDXD8v21dctWEUO9PuCq1qyw8GqbL?=
 =?us-ascii?Q?LcPyzQh2dnRkXXMlg3Kx/hj6KQAEOOEzo/D52ClsNAavck2hbiI2A9+SCkCz?=
 =?us-ascii?Q?6v935aFywVCGyWH1dgx8rhCTgGBpq127wrcfieRyBqCAVEVCAtSZMi/9iNYP?=
 =?us-ascii?Q?NoaRn2F/BaoSW2YIzHvhBKIPpsBiRk7yv4ImGaqRcYYscevCRRxX74dbQIA7?=
 =?us-ascii?Q?k4hL8d8xGAYGtg+YfgksMoAfior76BkZcuWY8ArjQkBTPGlizrAk+w=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vtRGfK4Nclo7vYGVIVds3Hry/BzPUpoyt7BiGNeIbggOhb20O8uC2yfMS8FW?=
 =?us-ascii?Q?ZC0V7qdoFKp50Guy2ufYEHZ8x2sdWur7p8BKYMxpFOzuVhPovFDYkty1R0cd?=
 =?us-ascii?Q?cb3RyJpqJyfqu6Fp7ZRmaQZFXv/MCD4G2RGhoNX3NhS4CmTqa8qVKjheAgSA?=
 =?us-ascii?Q?w426PgvQysOKk5gy+byDL9CbWQWlgWG7wrzLrIziTZaddEtlhj+Td736stXi?=
 =?us-ascii?Q?0Rozqzv3tXKqd+IC9g3DbjJ1ZbiLdhrkxoXrFIYJrHzSRF81xAkRBocY0974?=
 =?us-ascii?Q?WGFZjftVd6r5EBiBsMLns3HjQGN7WfXxZ5teE0X2lAXUs+vrbyu0QIwCVN8a?=
 =?us-ascii?Q?5rNGPsnRIIo+L589IGUl5+BKj70I8fYJsof+R0QbLZOM2anIJJTFoYRtKqnJ?=
 =?us-ascii?Q?vmujKZA4q//rDo0xhWR9IqqvBPkB+a2/H5dJ6fRBJL1Ojw51JT1Ui1U7R1Ba?=
 =?us-ascii?Q?zjJHDXrEoi7D828vqgnJq+zxvSqYJaLGpIfuJ4rSlPB0c2c9JP0wtL9mS8f5?=
 =?us-ascii?Q?h7rDuUfkBA941542vff0DO4DTY5K8t33BRDTfp81NfP12VCrGHHyJFwoIsjJ?=
 =?us-ascii?Q?U58W3ui6QZCwWnXxk1vTiU+c+FmtQQWIadW8OtI/6L3ZkBar1UQRN0zOyN+8?=
 =?us-ascii?Q?a43f8Rj/mgbtiKH0tuJbQVe2ZpwNd98oI8TufYHXA/Qebh58Ob0Z7qni4Xcv?=
 =?us-ascii?Q?BPmkz90kLAFvJcjDkKUoQ57v9EXw6en0VU2B+F/b9NAd9YRuh83ddJfg9AbG?=
 =?us-ascii?Q?JjT3hEBmpFCrqOxEV1CCdnd5Gv3uOIRP+QAkdeAtHkHtk4Zzl1+9AevoUsW6?=
 =?us-ascii?Q?MHUZYkGxliP+tHB5zczV1tiyn/AbkW7nlWIfYzj3z5hJrof79rCT4whA6WZJ?=
 =?us-ascii?Q?sTI93xrHfICaGOG27mNuBypzd3HWtfu6Mshf+3RQXjNbOy2VQlZmKxCsDFuv?=
 =?us-ascii?Q?zPlwcCEOb+jIWmJjBrHA+pjWK5s/RmsCw+HQW6peuVvhi6RrQCBu1/V5Qq3Y?=
 =?us-ascii?Q?q3/YZLB6Jh5rh3Mcvg2ACvYlXg2uFBCYHUmoVnSjK2CS/Feex5RRjTC42AZt?=
 =?us-ascii?Q?rk9mQEtcw0EMOlbIvVWfq2cZj29ZMjkqD+89eAZJPQfaO+BeJfD1rv9ajrkK?=
 =?us-ascii?Q?s85qPEpXLxQLPOKWnBZUWlgg65Cif4oKxAkQlMbdPSPBgQcfV7CruEiiSMX1?=
 =?us-ascii?Q?F+PvITBgCmPUdX/GmkMDnnf/APtgNqYXo1oFKKHtpwMBdOc0ZuBEBzDae//8?=
 =?us-ascii?Q?EpoiAwzb3Mntb/3cpt7JxK2N28+5UOIVSa6J5Hg0+35G7zAGJCuA0oqjqOQl?=
 =?us-ascii?Q?sRQhLF3z7FgYbpurvkK43TB5bXusObCQ1q6F/WjucD9newFHI0YVccIXCPk7?=
 =?us-ascii?Q?aqBXmtVKcFJ7eLWhh5f895Fl70IFagmRkR15zovVMMKOukJk5FUnZP4EmC5j?=
 =?us-ascii?Q?wjeb6bS24zOLCEBsBO7hqdWTq65PzXjzwC6zQsFyy17YxJS5qAnbrVrNMzFU?=
 =?us-ascii?Q?WNT9Au+nVM2bchZdgETduluewsqH1kVfn09cUXfc0LfSyXySjy43HlSMiGlU?=
 =?us-ascii?Q?8pEL7FQW2aw8Q3M9wAYFxekizCpMH7LpU1G9aE/S?=
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
	J/UphYfaO5Pvvd9xcbbROc/cx8VL2kR8PRyBd2FcuByfZWHmtq/VrWjQLGMioLdHGt+tgucPqi28LGt/D4EwU+UwgLVYUapG7JpFSdD8qw9+UyO5PS8/o/Ls48dHFhP7jHQQTfjUan6Q/dT6m0SPs5yqf16xnxE1tvog9fLjiJJlyCqt8O0lG/CGhQHJKHOi4a31h7axL+attNCN5Ao6b60GXGDsFgJI4gCGu+5vK0J5Kp3/Wz33stmTelYKU0AHb6hB92f/bFOsuPBmwWNXQH5djI3qJ8b2tfmyzDErj44CJl8k/OHjGk8JTZJPs6u8gxKkEwIBioNsR4KBSb9aIWCjTIRwvAhSGJQrOFaBSRqpIRadf/xN7JXjKZsRCeiCaDmctVNnHs7P12skR53e7xZF8SstFOT8HxGCUP0bDsCVb/NMO1IZbJC2wTZ9n/E466F3rgLxPzeCigrZxA+M9Isig0eML/KwzJeo3rRpEVdN/DGo9H+rDrn7E3R2rDT26C/p1TVLbiTIwyU3HLXlrX9HISadFX33vOw9SzAhi9JWTVOaCf/uCWC7qoueQamTipOYCcJuGDioT1P0NDSDsU2GhvWz4654UPdfCGrjNDZtAWf4VEzv9yy5rpr/qVoMLyzfPNqtL8aYRTpXe+Ff0g==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0f7965-41cf-4320-7576-08ddad6c56f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 06:58:18.2873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xg5E9TBFwZZGQhNe/N08pDsBvFSHOPdm+sEQToGkXYuf7dDthFbApTTnn8RD/4UomB4SC7QkI8H5mmD0mHWxFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR16MB4221

> From the UFSHCI 4.0 specification, about the MCQ mode:
> "Command Submission
> 1. Host SW writes an Entry to SQ
> 2. Host SW updates SQ doorbell tail pointer
>=20
> Command Processing
> 3. After fetching the Entry, Host Controller updates SQ doorbell head
>    pointer
> 4. Host controller sends COMMAND UPIU to UFS device"
>=20
> In other words, in MCQ mode, UFS controllers are required to forward
> commands to the UFS device in the order these commands have been
> received from the host.
>=20
> This patch improves performance as follows on a test setup with UFSHCI
> 4.0 controller:
> - With the mq-deadline scheduler: 2.0x more IOPS for small writes.
> - When not using an I/O scheduler compared to using mq-deadline with
>   zone locking: 2.3x more IOPS for small writes.
>=20
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4410e7d93b7d..340db59b7675 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5281,6 +5281,12 @@ static int ufshcd_sdev_configure(struct
> scsi_device *sdev,
>         struct ufs_hba *hba =3D shost_priv(sdev->host);
>         struct request_queue *q =3D sdev->request_queue;
>=20
> +       /*
> +        * The write order is preserved per MCQ. Without MCQ, auto-hibern=
ation
> +        * may cause write reordering that results in unaligned write err=
ors.
> +        */
> +       lim->driver_preserves_write_order =3D hba->mcq_enabled;
> +
>         lim->dma_pad_mask =3D PRDT_DATA_BYTE_COUNT_PAD - 1;
>=20
>         /*

