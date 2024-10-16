Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF281206063;
	Wed, 16 Oct 2024 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729073126; cv=fail; b=j8vRUV70Xsn+Q9TjqBWbu4lJ4JW+z35d+auGB/fv0CB4l2z5Ai6+5krjSfpVYgdigt4ZDXQMX+89oS2v+/kvmAjiBRp1lSCVdj7IWe0wlSmKY1s+KlMVRYz2SamGTX9NUsa7NX2/u9IF9TzfOtzp2pyvw/5cA6FhDXar5jW32wY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729073126; c=relaxed/simple;
	bh=YtFMm+pelBfxGzkEb7x1v1j9q5ugzmiPEPBuisuY/Ww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LBgh25MLnZsdYa7RDh2UTyJgGnJxlWnGYP5ENnZoSw53mYdHdrLDcBsi3dOcPjJ/+AZMMtwjXa9U1o6i1Dztfsq+RukVrqJt0LGYNf5pjPeU75D6dJtjSZmXwWmeX6EJSqi8I+J6CKcXsDC3g3hLaanIuEgpUpcu3uRI2cZy3+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F3MlgKfK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IwYeL9N/; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F3MlgKfK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IwYeL9N/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729073124; x=1760609124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YtFMm+pelBfxGzkEb7x1v1j9q5ugzmiPEPBuisuY/Ww=;
  b=F3MlgKfK+zRFzjpFntMPsF/lLj1uVoJDVdtuSfYRp4eg8d5kETkiAd05
   QZJhpvzCMLoXhU2jDQ7e35sNtWvqclo7a0857dSr6tN91iw4muQYh19g5
   U+dexIN46KjdRthNMKBqI5Bh5X3M1NWOaHPhAojQ2P0c5g3l3FUh/CjPd
   y+Vs8Tjhv+VJaaEZHrYb1RhHBYBd3tWMMGmDzU3FTxu0biO4Va38bH26h
   LdTr54oXUeDKZkgx23VM67XXUOt3OE5RO9lNbhSow8RjqWm4AKfKnW+hX
   xJI8ZjrPWBTuxsVr6pzieBPe4KxR/RsJornaPc0/bRutmjV88FtheG/Xa
   w==;
X-CSE-ConnectionGUID: raDxPHUkQGiMDAiu3WCyxg==
X-CSE-MsgGUID: D4zHxIAOQ+yj1wsvyLhB8Q==
X-IronPort-AV: E=Sophos;i="6.11,207,1725292800"; 
   d="scan'208";a="29535063"
Received: from mail-westcentralusazlp17011028.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.28])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2024 18:05:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oW+Si3Y01jlkG8pY+KcHBu7J/HDJZ954r2h+lAqaBu3fHpAHVa7Z748E8tH/CBpReAMxR8HMew59DfON2yB+KqZ+hPY/5SUPca1ndTSeJnweiAWr5zmCvY2g0H76nw3FrrriHyk99hIR0e3Z8FsDbK7F6KY/PpancFk7mkLc4oWZ7SmXu2p8pHFYpfSljPjX0Iolhc0UynlUzCA7zaqFnsLKppnBtNoaozcgln/A5qCDn9gSPsbRHEqgp/PhVcuN9lWoeU4vXn4WGUQT4e9WzFIcxdLGhIMLRTcdqJykvGo6BjUOvislQNit9zn6+2SdVleQLls1e2XPRuiLu3bC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtFMm+pelBfxGzkEb7x1v1j9q5ugzmiPEPBuisuY/Ww=;
 b=M2Chqua65MFaYdzQ2vAbAb9Rla1cDr6dj8Dqb2c2CHNy2UlUPUyxhgEQ6RFTHETLf3M0LHkuUJLPMt27DwlAU3CJX/ZFXps9ZR539o9HztmIfU5wnxFooO/rsm9a2mfcEvz0leZta4Wi6Z+StvSye11DlPhcfmrNwzKrBbuyejHe2WFTtSsoGDclsMk5fE+yIOFDgLUMWRwna7iNDwpytywTTIqo2ywkUCrd+hE9SkS4WBVc2w8BXWF0cZNupRm/0TsFY866RrFpE6Q7sD98BjY+fuqTc6mNXJOoRMG+j9q7NHkwaP8+awbMEPTy9RzLks65b310wTF6UcjokpEbsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtFMm+pelBfxGzkEb7x1v1j9q5ugzmiPEPBuisuY/Ww=;
 b=IwYeL9N/428dfGflymg+x9LYiCdD/Yw3+Mn6Cylwp2DOHs0Bm1Zpz18vC78qpW24A+cGWlIBH/W2q5rHeQ+UOtcjvhNkMbQRcBr8Et+5ZxGC6nTje7pJmMf1jw2uO/RryenmTEDWOyTL5D5DkS2x+rUoTHhc4yZ/N7VWEW8cGfo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB7829.namprd04.prod.outlook.com (2603:10b6:8:3b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.19; Wed, 16 Oct 2024 10:05:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 10:05:21 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Avri Altman <Avri.Altman@wdc.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>
Subject: RE: [PATCH v2] scsi: ufs: Use wait-for-reg in HCE init
Thread-Topic: [PATCH v2] scsi: ufs: Use wait-for-reg in HCE init
Thread-Index: AQHbH5aKHDEJWDbK0kCQP7Hfq0mA+LKJJnWQ
Date: Wed, 16 Oct 2024 10:05:21 +0000
Message-ID:
 <DM6PR04MB657532E184397A331B4250A9FC462@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016063950.436190-1-avri.altman@wdc.com>
In-Reply-To: <20241016063950.436190-1-avri.altman@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM8PR04MB7829:EE_
x-ms-office365-filtering-correlation-id: 91cd12e3-3c00-48be-b2ac-08dcedca0bee
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?D1AZZQfL1B4529vt36yPHR6lxc2BAYDkjPkfA5yFGFiL6GlaFGacVWIJ36sm?=
 =?us-ascii?Q?36tr/vWw465hNRpvbLv3IXb+mTJXWczue3uEb9PcjVXHNZYhwyhpW1qAAE+K?=
 =?us-ascii?Q?yXSNeUGZbrfxkQhGk9C9nXrLwt3oTObVolgvVlCUAEMgQY3i5R9VF+/+UMTI?=
 =?us-ascii?Q?Moqrr4wottjBIApprRBp4KkJOAI8erIJFhyE3kgu+p/JOvpvddpKKwDGhI9i?=
 =?us-ascii?Q?pGnjJERQW8MhHY7Um3HTRb0Dw1emU34vCAEMfnLNCwSbWaZvCDcZGEKHBWT6?=
 =?us-ascii?Q?1zMSzh1ivQIXFoJa1j8ZZCwEjDmNBE0mk91L/UL4BMt5c/5U0pFATTx6v6ci?=
 =?us-ascii?Q?N8UGMTeKWV5melj/Mjy+Tu34LA1lp4eNL6LzaTleqZU4T08q+zAr1zJTDavS?=
 =?us-ascii?Q?K9SYSGZvrcasgJIPTR9vzYj6b0Igr7YyPx+JVw93081SuTaQ3QhbJKY4K6Gn?=
 =?us-ascii?Q?cJoEoAAT98/kSegO8pfFly/tz6gbaWOpd6Nc5dzL9/pgq857C3yYprALMOma?=
 =?us-ascii?Q?4V76TEEc71cLywiwW+Mr+BKhEN+b2lJ8aNHcb+LuPrNAUp6SM5txRfdPoNJp?=
 =?us-ascii?Q?Jo1ypXXZa4GqSIUE1ZjNHItp6uTER/Whb/kYCQkZB0XkYSIxEV9eoVZMVjBY?=
 =?us-ascii?Q?41EVCiLYPutNEHBNAIgedvk7WT8DW2v0rVPTxkisD8iPgPq50UWviCZLhuCg?=
 =?us-ascii?Q?5fW+1Xbtq8KRbarHbprB0TMhoBQ/vltUbN0GTK5nT+v3hm0EOfG0r0pcuxWN?=
 =?us-ascii?Q?6lT2eyL7yCbl03iK88UcYj2tmJmS28MMKU776xd2396u//ysvfxtmGrPMm8j?=
 =?us-ascii?Q?t87/VoRY9FCzB8dugdtY2bGfsyizvpApnUbdJbb6M1PGIoI5AdwXwdd1LZWw?=
 =?us-ascii?Q?1zhJQgPQq62Wm4/KZqCPDL8aPyn0Rn66ZYA2YtBXZUsR7+eAavmpuYbgE+OX?=
 =?us-ascii?Q?R6XH59E30jqRZ9V0I4qCUsZT0c7NwrgbIjVSXBojlzmjof7jRO1qWHdleFnE?=
 =?us-ascii?Q?m0kGZ7qPrSz7wEN//IVCzc6KxtlSFjkvWNqyrm9SVQTYgth2DjXDIkLv/2oa?=
 =?us-ascii?Q?40LyRYfp2ZdBLh/7ovAoQj1piOeSzyGjfI0fwxK3zDpx1lJdcOlT/eJLjjRW?=
 =?us-ascii?Q?1ehsOcZf6WvIhOGhpjNPCoHUQ/9ZWf7za7dy6bqm+nKrwvhEllsjhGHtZx5O?=
 =?us-ascii?Q?nPxlpyQFJNndgxBvfhYJE1Ko4siG/hMILZ9EQ5EDM+AGHtBlBhzjS9KgPNAW?=
 =?us-ascii?Q?yPZ01GwradVuKGuzOA52J3oFKdeNpa/sUUiUnY1tvbCq1FUeOkFVpLV82ljQ?=
 =?us-ascii?Q?Kt0SZ4EXD1rqdLt7TthV9TWjb8ZD5CndxgTJONs+3tYAMQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?tuqyvrOxuKBagtpSh95+JJq8CKUElggE6PMz/u896KHYJ28ApDVJXg96AFDq?=
 =?us-ascii?Q?pn3i4fYCOxTpytftQd1QRAU+7Jrt9k4lelBPOUhZuztKly4GeC+cngi8iMTu?=
 =?us-ascii?Q?h/EOSLoLwe2EpUZXZEebJ7aNVd3gfA2ijT3xWOsmdr7IeszaTePoTaRhr6bS?=
 =?us-ascii?Q?8nFIuBhdACLSCSUhrJr7vTIm4W4oYme1y1WIlMv1vbLc7YJALbp+xyaWso7D?=
 =?us-ascii?Q?cBHrFinnLYqq915/WeOOVLcQRg2lPK9nU4VtTHICIuKLW0MlN/wE7wMwzsgJ?=
 =?us-ascii?Q?Xthn2F+h80BMiTZgi8tTS60wyDK9WEsy/BCchwiqvMugrM/T/e/eNj/2/ulx?=
 =?us-ascii?Q?LVR1bY+17UisrAbRhFL5VczULW+yY0HTIjOGh+JxOqgREJ/GyXGLobbZNyZx?=
 =?us-ascii?Q?NWiRbaayqKCibuJt7tae4yHUh9GFzizb1gaNIVEhAcgEpczy1xqAFGpumE/9?=
 =?us-ascii?Q?YPFfHU/pblOJD6yBCYEQHR0UdAC1QVoaOuDwZen+9Dzwpofo++KTvN3c4QRg?=
 =?us-ascii?Q?BVsmqLTtapWXE0v/oHzfj05L7sFZXQdE9jg7X+ZA3BFhV4280wORAb7wQZ2+?=
 =?us-ascii?Q?RFem3EliCG1MMjgvnG4fMRB64cCfIn6Yi9IC9FanKBheE0FrszJwDy90gLDw?=
 =?us-ascii?Q?77oN6lRKzDm2I8HjYagh5/Erson503vZJT5xbSR6uZTsuDNVjYW953mPlHlQ?=
 =?us-ascii?Q?XzQMPJ3Ly/FKtsBQlabTDSTSF+ii0KdZvOTQCB8iuf0MssOJ5o+qka0sFd6W?=
 =?us-ascii?Q?1E6apOf80dsXk773ybr6od2f7yuLTjmH9gyRermwPkBT834rRtMYM0vucL0i?=
 =?us-ascii?Q?swFFW6ggXoA1FnVxhL3MabHT3votUQILVJJF9+D0RBWTKRt57glW5t2k53Tt?=
 =?us-ascii?Q?GMy0djMSC2XlwO/TQhOgVX6PCbR7tej3KsdIPiJAnrWwsJjFuFR3CD9j2ojz?=
 =?us-ascii?Q?XEIACUl9ZdMma4HLBgVzbgn97lZHWJtlV4mnTLEHtJF3mEQ84Mg2Gi/nHyi/?=
 =?us-ascii?Q?Z6YAuI3W77K6K4I89kWzNDATHwlb96QgLbwMJF3A+givuqdv4Szy9PYGSiXB?=
 =?us-ascii?Q?Ygn1XqGbSxL5Erg0ASAJddNDm7hw+1f9GpsQ7fa7+76/+Kpvv8LSgi72fdV9?=
 =?us-ascii?Q?RC2QJ9XlqWG/NndksE2H6ikIJiaDiYkPsYpDDkuUx3L0M1Q12EOJXiOBQjAx?=
 =?us-ascii?Q?v0z6L8DaAUOJEkn7dzV/0HRBHDBA00NfIEIAQiQ4CA0i1p11ordFAdQyeYim?=
 =?us-ascii?Q?Ur6do3DwW7SI0N0Pn5aHpABam+CFwpdIOCmhGqkD/z0ENXFDXWX1TZNBLYYX?=
 =?us-ascii?Q?sHfnSSIlzdkTuq2Huk1jNNcq9n/60GMKmJaNBPubV+8ImQ4DJ7NeV1c9emR9?=
 =?us-ascii?Q?mdsVN3qrxmXYeVOxRZmCec7ojjaV9Fr5m7wD6FnvwFGZWxe0z+BTaUZ9Hmom?=
 =?us-ascii?Q?NYN+d8zaBZYRLiqLYNZYdV8J6ngQYM9EtKECkiaRUc5ph/62BUoc9kLbPWi4?=
 =?us-ascii?Q?pATDVnfgzizybEu8Zrycld5VR8uHTHj76/oj47AD5uC6sOU+wAWHb1zezzps?=
 =?us-ascii?Q?SWD16Nfi2sppxixxlZTF0uiBUk55YyhD792ZCbWiYt9XoZtO0J6K89KphyUy?=
 =?us-ascii?Q?g1RNENmDPAQEMRoMDtjNrsrHPwbgw5uMjL+DBY55YAVE?=
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
	ua+rj3TdA2Lw96uFbrKQDr/CudDJladBsnCHN5zYC1F7CP9efSOtsfuGd0VRGsQs4LGRwM2H+EAyjlJ+OVHHMYoJLqKrp5/aps/7SgEtyQBOjWao266TsKlP25HVqyTpXoGlzJcO8IsmQPzeMBqFX3Hw1ExQvzobst/QgerMIPH87NTKSng+GwEw+hDqSsFCo5C1+zG0It25Eujp29dnoh0Zzr8/xh9J2zU1ErDovS63UpOZPXs0zDuV/aZUL8rUJ1YK+acGnYKfyE49NaxFmMMcGQJQQVWVOD3fTPyJG2gL8NY8G9laRY4Pbe5FRKWuA63cyfXD6cVwIaw+9JQddSiPUU7U9FX9lW9kJRkRhOVJK/DMdNK5Kd/rBCeqBjbF/R+dK53ClhLjs5Sc2zVgAeiXgIOrKjb7ZUOt1biROAuP/w9Ro7KTfMd8ZqQ9oK/PuB9CbnhKYZntBeXXexerYH+ZCE7iHOJP24KLtUx6zyYxLu3uuhv9z5YH3h9CqCH1uwEJGUW96auAcmghU8FqS0uajLqDh4bIGA5hPw3jvqArkES5yjgegCaU6/o7wan6nXj+zt/5wLNizb0olF2yqr4lY+VTBb59cSGSwu9cw0Il9KSk4oOJhV7Ktqs1afjY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cd12e3-3c00-48be-b2ac-08dcedca0bee
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 10:05:21.9027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfOnB6mdSa3ZYmHl+U0zEv8PkvoAn+8h8W8dFx7raTsNP3U7nn9WnmF0jK0PzOtw+AXSa+lxnr7ww/kyGUOKvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7829

> The current so called "inner loop" in ufshcd_hba_execute_hce() is open
> coding ufshcd_wait_for_register. Replace it by ufshcd_wait_for_register.
> This is a code simplification - no functional change.
>=20
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
Please ignore this version - will resend soon.

Thanks,
Avri
