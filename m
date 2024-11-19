Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44BC2563;
	Tue, 19 Nov 2024 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996149; cv=fail; b=aXwarF0qD65fhnfXym1m3rWBWR4XG6i/zbGjgUe5E6TIUInoDlyFNiok+UHtPqwLDR4bbacYlEdjWqluqx95CVUR8ntkmOUcWJr8YdN5Fy4VHBAPXSlPeFGMwUxeuzbPsXALyqKQQCbc1XtBmdrquy6Qb7ydU81joBqkr1nepHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996149; c=relaxed/simple;
	bh=0jI++aTSMdd/Y93WbhVRpU29cnMNzbsaAo9kihwLzNc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=stl3a0diaHc03si4jXGYnVa4X/G73Ef6xRqEuoQ4aPqsQWyl+7gWjgAFUjAO4ofm0T0uxB19Pl8rmRLqjfsFw9xFYNeU9XkXdqHi6uG9Q7mAzQ9h731NhJ86xEmkopK73BLVVRok2vV+vk4UNTByvZNV3e9VDzpkfisn3ScsTtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DDlHIzJ4; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Is0GfsO0; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DDlHIzJ4";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Is0GfsO0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731996147; x=1763532147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0jI++aTSMdd/Y93WbhVRpU29cnMNzbsaAo9kihwLzNc=;
  b=DDlHIzJ4OWAigMtT/s5C7M4STIqSmMQBbJ1i8rtKjcLXr/9QocC/zLp3
   6GFh8CJL1TlTwEjr3l57FRGuLo8yD6PwDV1qLbwbvtQr5Lvlzw+/Be6Xe
   Tm3hTgzebOpPnQCbaCZDf8ciQwpZCVt40jHdpQPmCX/+tzOCC8KBib/px
   ZGWCrGPiRCNfVP/WKII91msWuR0QM680LHyFbW2+T3qCjQ18+220yBkTa
   IXH99hlkTR3IXW7m0fwOtbTjQ1FeHvgKl3gdizp44Zdxg47q9B8KQzy2b
   CfGZPjJreVuoyf4cPT37KH0HY4bOcHXntSLCbtW5p1nN67jBaZm571ZW0
   w==;
X-CSE-ConnectionGUID: +DsKYHrLRhiQiKldZHqrBw==
X-CSE-MsgGUID: TS/N+Pn+SLGyHzM7XIWgTA==
X-IronPort-AV: E=Sophos;i="6.12,165,1728921600"; 
   d="scan'208";a="31732154"
Received: from mail-eastusazlp17010005.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.5])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2024 14:02:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7ttGeATzu5vHLt75i6FKtBmrInXbBS5l9QLaJvj9t8fUX1uTscdF2+8j2NOI0qOZKLjCmhHznuZWhxEx60rjqXEz639p0zjlyL/eq21a9N/moozzaOBtvjKU5mVqkTEr88UB3H56+alYx34LoS/xJ6Z4iWozWpNSdp6FgZIOcBuidgM+RR+zy7LSgj3nfZW23D7osPwK5I9Wy1PR0pflgI3WHe52zFYKPFo6RIeGuebSvlR90Lat8+wj5bSAWsGpGD2Pc1w7ZhMQRlOm5PTd909j+DXwma0EgreECO5u4KMfq5zjAbcGa3vSjQdAYm7j5sP1+OLdsmLODZvVaETkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Y2cQzRYWRZplh63o93uvKtGMSH16AgUzG8WpcV5g0w=;
 b=K1Tuhe9tE/UdEk/s51Up6SMj9FOWTDRPzeB51XClb7G4l/kj0w3YwUPdS/1hVEtfAvnhJEv6pcnibY9BUz9mHFJgRxO5/i64LmE/xCg9X6VkT4DmRtuYOWfSRvQfoOwU3sWxmkC0TLrLeit6EAHDnSDpVjLmIwqAzAdxeUKzpiPh0bi1xLE4HxWmfv8FUXglUS8VPc2GUfcBUNE9id+FkEY9e1OfeRiVTteOX2hng4RJ4B8ISQQ8YVRR/gTzRBke5eNlZoadtZ3omiUjb3gZWdR6E0DQaAMTww3EYNwz0SHKLFCO1Yt8DCtzKCMR1/z6o4d+sPs5mOjjlkp2SfOCAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Y2cQzRYWRZplh63o93uvKtGMSH16AgUzG8WpcV5g0w=;
 b=Is0GfsO0FXNppu4kc46pfMJMMHuMrlR+cRCTMMoJybLV3cblMg4NDsQtmEn/fsJO1Wv2K1OOySEjIVmFvo0jEOlI+s82iNBYEUBF0k02LVjs1A4yx9Tw1pgR+rEUYg4EKLmvyqXtSz9SIDwKIRutd+LoSx53VxyfYetn9nhaIRE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7232.namprd04.prod.outlook.com (2603:10b6:a03:294::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Tue, 19 Nov
 2024 06:02:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 06:02:15 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Ziqi Chen <quic_ziqichen@quicinc.com>, "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "mani@kernel.org"
	<mani@kernel.org>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>, Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Andrew Halaney
	<ahalaney@redhat.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS
 BSG
Thread-Topic: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for
 UFS BSG
Thread-Index: AQHbNb1CzHfNE+2qhEeT/dsTj7mLqLK+Iv5A
Date: Tue, 19 Nov 2024 06:02:15 +0000
Message-ID:
 <DM6PR04MB65753A23120240123B090585FC202@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
In-Reply-To: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7232:EE_
x-ms-office365-filtering-correlation-id: 5cf4186e-a072-48cc-406d-08dd085fb80b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?NeHJaMiXJ4JjAOb8lIjV1A4o9xI7jexrTxQFNcKq32QWh3BCUT4h5WCG+UG3?=
 =?us-ascii?Q?QTqLrtS8hZE/RO4cekPCgsJqJaG6121y952dRV+oKf1J49soD4gOgfdkAzpB?=
 =?us-ascii?Q?C3jn/wBQAHbhkmazPzoRLJ3nmlR3BnE6LtLcX/6nqMucIvWJdLPSWjG2wWKu?=
 =?us-ascii?Q?aLY+yLjdc/4jeE6iWW3iXcvYILbGTotFqoGKRb8MZck4DwbOoeXVrzZICzte?=
 =?us-ascii?Q?lyhYz9HYqpBSnYb3asKNx1nRBBGLPYgbk2CEahBFPsuR2YCD0TSDrCM+/OaZ?=
 =?us-ascii?Q?k6ND+O8HqjM5hgHR0tXuFpuUnblcLFk8CpJOBOrrp3gZNgVpC6Ywlp84R9tY?=
 =?us-ascii?Q?OoURdvBYEK5W2vaFD/IjjbAlMJai1UjzGD6DIgagbtPlS01kqXLVsuvLVyCq?=
 =?us-ascii?Q?/aWOXh677eoMhq81h3eSVRiVrC5TwEw94647qiaXmAl57k6MhG95yY/LzEjx?=
 =?us-ascii?Q?Po8QsmMGoJQfcebYzXL0BWx3dyqL8V03yUfPd4yyJnEin2E3bfrXYljtpjrj?=
 =?us-ascii?Q?HzenmjK1oBhiY4UMq5BnwqI2NCfDzMKWKBoFjnobWofdsxdBSmuRpriPHb2H?=
 =?us-ascii?Q?TY6zVC7X9hlXAEqFb8KTSJIQRfNtZ5bC1sFHT5z1ekOFONs+HnS8A+yGBnfv?=
 =?us-ascii?Q?sk0G90+4omSYJ4nSr799zJqMCAHqgA6S0QQFjVTGfp2KE2SeVK3ZWKjOeFAM?=
 =?us-ascii?Q?xnp9btzbfF5QuoEkGrzwxKA14EUnz/3yPqNlGHJyJECClm1RiM8rSGuNJBQA?=
 =?us-ascii?Q?EJHC9QZ80VDNrRxD+Dp1rM7X3FtPx9xHmorMB+MwF7pXkj36t/d9ogDGb1/y?=
 =?us-ascii?Q?BTZ724p/Fvu9qw2nEmrHEOQdcwsGFKa+pPg+wtX+KgSzALsTD4qHrYyl8Hu1?=
 =?us-ascii?Q?06ScpcSHIaLoWYGjdSN27B2ieTx9qIf3LMS388qtOlSoWRkuKvNP1GlBmI2i?=
 =?us-ascii?Q?ahYJ2X81hZgINKXeRd/UJ/X/P6hgd0oFKT4qwyqN1jyYvw749Db1wS64uiJQ?=
 =?us-ascii?Q?AmA+7aJDmUjpX0IsTGi7XuftpWxcyTXioBSKnAqeODu52DC12PsyBILLyMa9?=
 =?us-ascii?Q?fZBCKbxG2942Fvgdg3hNKq3EggXinJ3trY1VD/1xH6GCMEe6r32h2el9ROdl?=
 =?us-ascii?Q?qHIMLCqdUw2amWgcz2h7lBeB6ZxRQBO0v3savKYuNCU6oebQqFmOLNiXV6fY?=
 =?us-ascii?Q?c1asekUS0F0WFFNIgohB3W4Hc5tPgx49RafcsJRezxslP95L7V3JYFFBjwSf?=
 =?us-ascii?Q?T40lgkYJLa92+cNmQV3TvZIXyDjN4TQZtHRmuNzOVt79wHXRxDtI8QxLHKmq?=
 =?us-ascii?Q?fLcJMtux/ANzIRsAAXiWGUt8uQIXQess184X3oV81m18ytSm5c36nt5YkJjy?=
 =?us-ascii?Q?2T7XbtxRkupLfCfw7vX8HKJEqAJ/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?It90zSNhxOhHP954SDa3Zkv3N/fYRjl1EK6qMOfQmOMhSbhNXjmsJmQTxL2P?=
 =?us-ascii?Q?leIIvquDJFdtZsDYroH5GiC7VLDYF3Ax09YwoqY5HBP2+JTynsFF9vhB/4WL?=
 =?us-ascii?Q?Kw1pwmsbqmiv4ym1aBE+/TyaD/wnv54QN2mKxxbPIiBurHrIeC2WACB3nfws?=
 =?us-ascii?Q?cu7ylE6+/+K+U1z+SdI21xVg33c1Lw60xZ8pu3A+RS9eacrrRfpW45uju4ht?=
 =?us-ascii?Q?7N4DNVMYDskAcOI0PBQ++QoL/drltbAqpaMv/7QoyBE0OGMT85QbA4jqHPbL?=
 =?us-ascii?Q?45CKUctGpx90nrm33CjU2DuYsnQZyq0zW5mj82WWehUrVQkDAwdJsbXh7Hv+?=
 =?us-ascii?Q?lD0gsTMpUP2AOzToM2fAkAcGSPkIj5Oop4wv3N/NHCI5u94v01bafPdoqkqy?=
 =?us-ascii?Q?23YHHUtm2VZEjfGAIgbxo7dJlvnNaSOzqEkzVCSn++bYdlNN/HYIyeJqB0Ab?=
 =?us-ascii?Q?dR2f4TnOxubGkbd8Zg1S5RfRoGEK2QrhPust36qdu0x0aC3Z7Mk5Pey5sU5V?=
 =?us-ascii?Q?2PIL31NrzjXeUuxetMjw2UZndI8441jUqdzfazgP9G8BrE4nVu8oHXeTrZKA?=
 =?us-ascii?Q?89kcp0S4z8kBl+l1U9HSFGZgWHRknPMUhAom6vdGPAjRoB7FYVmuLdyUU1rD?=
 =?us-ascii?Q?sj5/x0EgzimGoplMZEKZlNYAlpHs4ySAsO155rEijs5bTs9f3Zc9zaV5aMGV?=
 =?us-ascii?Q?U02NpIdP+NzUn3gGnld1Re32DO2PZvoTodhEmjw69C1UExnRhsaIe3qicusD?=
 =?us-ascii?Q?wXfpuliSD4T/MoAx+sccI2guGCRr1HuxOaQ8kkMtK4tGXmSP4MMgGwNeQ24N?=
 =?us-ascii?Q?iKHA8O4NxF5Fijig0ucFfV3XMhC9bsZUSqkU14aOFUcIjsiAWfx+Dpg0F2Qm?=
 =?us-ascii?Q?70kbx6AccbP42s7JGX2jVSDGKkrWRj1LlN8EbJ4aGLciipMxMjJcZikvFgpJ?=
 =?us-ascii?Q?twAGojK3cq2fVBCkDkxH6agDtzIRqcPkQPSL5xGTaBoN/NadgtHigrBWoYGX?=
 =?us-ascii?Q?gYWGbpJBiVlR7HmFUFSYQ/vjO+z6mlRRGL+h2mtB882yd9Uazt310OBKleMf?=
 =?us-ascii?Q?QxaJ5MyBkkXYyhlVRUw1NI/fvCPi0W1HHuA65/bUmWYM5Vif+Lo513k0OTDQ?=
 =?us-ascii?Q?me5SMcW84/IVqswRlHMrfSPitL0gLepgUnzKL8adkZFvVrtoqJ0zfLOD28Bc?=
 =?us-ascii?Q?1y5CBvpFxAlxMa4HH5kNiWPGWbq1dj/jCre50enrn7jPn9gSEB/u9a/sCSfF?=
 =?us-ascii?Q?N+CF3LBBfnGZQsXo7gnzK+SSQNkDitlplELe4p+ITxOTftjlPme14sJIIkuk?=
 =?us-ascii?Q?IM3IeQO9DPNLL7pYOeLFmvj1UKiDKIK57H1BhNqoJ7V9R5XG7psGM8p9VuCb?=
 =?us-ascii?Q?mU5D//c6zsEYW0qDVGNTMtM6REHtf3I+r5q9G6EC9LN2GS7faR+jdRnoXZQf?=
 =?us-ascii?Q?7tPDKdhzqREQ57NldRj/oXeIUpFEVhqUm8Hoa6rP+gmQlqG25JcFLEweZ2y8?=
 =?us-ascii?Q?+SkLek8VpDu4Foyj5cz+t0DnX/iWNU2XFQQsPMb4fdLpL8luETedgPVUe76H?=
 =?us-ascii?Q?RcuyDPtSNGr0JCT7lhqa5RhM/6Iro6MY0BWb24AE?=
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
	CZJCuj/7irTNEeUTskSC+8r5g00ErQ4Aj5g67jImn1IsGTSlUuiYQAaE8t/sVH8eLEeF44BNebGwiMw3uUrlnsV0Ae+28MzGEedFeC/GpjDr5U+A5EQyNQksaBtFp0cWnUKqah4hsrs7vmbubQgkcNQtAJmU6j9EqtBw+yv4zxf2sBQcAnSkTydpNj1Hi5S5CspMsjHOdG+fNY+jyc8MA9OO9aBqlfxFz78mhW/YFWeLGMkh22QUrfQq3QwzfhMJtGtbTZP/KAUW5Qtbih/EGg4fHP0uzcChUZlQcHdO+c4LDvLEIi0AzD7IOmHYPO3G7ybkxPQ0DSA8hglMYG5nTXpQ2UbcBPraRByVGrV3v6fhlKkv0adse138FGtxt9o/yR93ScQ05q5PzGcGouysOeesWPzQEOkuDVdrMwMFKf8X8YRj+5IDlcpVqI4L+bCr15LdmBF10QMcQInSc511jtI8R7+15yw5ptKim0uhJFuzxpLEoSYfco1ehbCIvLHLTmjPzPBGnGHtUHu1QnLwCaN2DgU7I3BU3PWtXGZUf2o1RjHuAUMra+UEK3rDFe8p/Jo7fiCMSGW3aAwNsZcLJDTGmYZ2PV8ZuyC+nUXRn0CRP7+RccNYiF6AqNzE/E6P
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf4186e-a072-48cc-406d-08dd085fb80b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2024 06:02:15.8690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wa68HHiOcQNNXKexCpkV5a+RNnSClQi8OSaa7uS6eUFpkpBthWJqn28R/4HM+DLTqJO2/owVCVX9M2F2bB2fmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7232

> User layer applications can send UIC GET/SET commands via the BSG
> framework, and if the user layer application sends a UIC SET command to t=
he
> PA_PWRMODE attribute, a power mode change shall be initiated in UniPro
> and two interrupts shall be triggered if the power mode is successfully
> changed, i.e., UIC Command Completion interrupt and UIC Power Mode
> interrupt.
>=20
> The current UFS BSG code calls ufshcd_send_uic_cmd() directly, with which
> the second interrupt, i.e., UIC Power Mode interrupt, shall be treated as
> unhandled interrupt. In addition, after the UIC command is completed, use=
r
> layer application has to poll UniPro and/or M-PHY state machine to confir=
m
> the power mode change is finished.
>=20
> Add a new wrapper function ufshcd_send_bsg_uic_cmd() and call it from
> ufs_bsg_request() so that if a UIC SET command is targeting the
> PA_PWRMODE attribute it can be redirected to ufshcd_uic_pwr_ctrl().
>=20

Fixes tag?
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
With that fixed:
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
> V1 -> V2: Rebased on Linux 6.13
> ---
>  drivers/ufs/core/ufs_bsg.c     |  2 +-
>  drivers/ufs/core/ufshcd-priv.h |  1 +
>  drivers/ufs/core/ufshcd.c      | 36 ++++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c inde=
x
> 433d0480391e..6c09d97ae006 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -170,7 +170,7 @@ static int ufs_bsg_request(struct bsg_job *job)
>                 break;
>         case UPIU_TRANSACTION_UIC_CMD:
>                 memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
> -               ret =3D ufshcd_send_uic_cmd(hba, &uc);
> +               ret =3D ufshcd_send_bsg_uic_cmd(hba, &uc);
>                 if (ret)
>                         dev_err(hba->dev, "send uic cmd: error code %d\n"=
, ret);
>=20
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index 7aea8fbaeee8..9ffd94ddf8c7 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -84,6 +84,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8
> desc_index,
>                             u8 **buf, bool ascii);
>=20
>  int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command
> *uic_cmd);
> +int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command
> +*uic_cmd);
>=20
>  int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>                              struct utp_upiu_req *req_upiu, diff --git
> a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> e338867bc96c..c01f4b0c1b4f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4319,6 +4319,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>         return ret;
>  }
>=20
> +/**
> + * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer
> +and retrieve the result
> + * @hba: per adapter instance
> + * @uic_cmd: UIC command
> + *
> + * Return: 0 only if success.
> + */
> +int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command
> +*uic_cmd) {
> +       int ret;
> +
> +       if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
> +               return 0;
> +
> +       ufshcd_hold(hba);
> +
> +       if (uic_cmd->argument1 =3D=3D UIC_ARG_MIB(PA_PWRMODE) &&
> +           uic_cmd->command =3D=3D UIC_CMD_DME_SET) {
> +               ret =3D ufshcd_uic_pwr_ctrl(hba, uic_cmd);
> +               goto out;
> +       }
> +
> +       mutex_lock(&hba->uic_cmd_mutex);
> +       ufshcd_add_delay_before_dme_cmd(hba);
> +
> +       ret =3D __ufshcd_send_uic_cmd(hba, uic_cmd);
> +       if (!ret)
> +               ret =3D ufshcd_wait_for_uic_cmd(hba, uic_cmd);
> +
> +       mutex_unlock(&hba->uic_cmd_mutex);
> +
> +out:
> +       ufshcd_release(hba);
> +       return ret;
> +}
> +
>  /**
>   * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
>   *                             using DME_SET primitives.
> --
> 2.34.1

