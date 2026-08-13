Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D553590C3;
	Thu, 13 Aug 2026 06:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600880; cv=fail; b=CxwKWGQtTGMmP6IDY1tAQzMWHE18c1ctH3ayTPWH1KpDFSxmtOEmjtVGvATKs5WZh5CGj0BsFvJNIZQ8RZUMMFVp8nYoZjfNOrVfj3pgVq6nB7GhfIedYKFrSUKglmuk0NZC+q5E0e0A9YJoayVZCizWsKt/fBVE0C7+S4RbEQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600880; c=relaxed/simple;
	bh=9wS1rpTZHtaSjxyNe02y+NWoOX9/ISh+j9PgdUBxhGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u3DktrtPx0CY7038gD0NGv7Kvu+aHZCKgJ8BgmbOX4/8N++RzNx0tfW5M1vcOO+T1hib+D9cVLkAoLZ3Bn3cN0owEHY5ezhmgX6czubA3/osmFHturfZ777K7RSo2FSHvHbeC62Wla+CF3khAm1Z2CeXG18O6++jjsEtw0p1KwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=s9mAYbqu; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="s9mAYbqu"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D5gQpk263810;
	Wed, 12 Aug 2026 22:42:26 -0700
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022137.outbound.protection.outlook.com [40.107.209.137])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4g0dehd09p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 12 Aug 2026 22:42:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPe5mCo6yvTOVQtzgfOSKlXyS/+kUMzOnn1WgWjOborH5V2/SiVZ4Lr4ibbOz1qevJZvmmBtig9r9y8AbkBlMjUchsDlbEVK14jDQ799Qz8BFX2vs/p1G9Anu8o1sbH5D1ubiD0/+uqTmewntgghJdt4gswFFaW8rEh4E4NdEMobXYs/Uz5P1mBDxQlo/i87C4JVsh1w8fjiLBMJWkInkyzlBmap1Iy34USw68s53CV8M6ypfgJG62ex+xyD+O/xCFH8gSDjHio3YdBM7n8ICSycZamxDIxPsNMVUB3K/S07A64Pgw9/jB5F9AIW4Za2DhPOewm+CQM9e0ooh7Yewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wS1rpTZHtaSjxyNe02y+NWoOX9/ISh+j9PgdUBxhGY=;
 b=qf3dzmrbYiR0WSaDGzild/uyW+zKqGcbg9UjVHWytdwiQUHVuV7P1R/9HoYYYLtvrdAMCnC6EATvokMPZnXHlHx3Yvhau/yUMIgpD0lG5Y+KPVmqn3yg6L2Vz1+4NDZEr7csHQSSBzLbmj6IkGCdUSm+W3WuHfSaFzxEd7km+3uwc96B3N9Dr5pVuhSALc0os/S2W+K3K+VEeScW4LG9Y98LIn3l9f2jm724n+GXhda+7sANdfJWzMabEA1l3bC9GvwH8xUVMEN6/2fwtgduqYyp9NqCo01LCKf8Pb7bMTEa5dLJ8BAcR6HUbw4eUEJ1CtlW6Q/3bV7yGmjNKQzwAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wS1rpTZHtaSjxyNe02y+NWoOX9/ISh+j9PgdUBxhGY=;
 b=s9mAYbquer9gukqRwCUXaL6XAX5Yw1peRQN35h0GtgLS2vU2js9o4sILlJMQUUr9lZFmpDheTh1QUMGWJmx504y8yv5fszqGdnAU+mwp9Z3djBVVhleIFnKKT5bjWOPs95p6BJnlof7kxUcvPPw97kLdagv5+gU2Xjg7h8MpQqY=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by LV1PR18MB988708.namprd18.prod.outlook.com (2603:10b6:408:3f7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 05:41:56 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%2]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 05:41:55 +0000
From: Nilesh Javali <njavali@marvell.com>
To: "Nimal Prabudoss [C]" <nprabudoss@marvell.com>,
        "linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        "mschmidt@redhat.com"
	<mschmidt@redhat.com>,
        "Sharad Padol [C]" <spadol@marvell.com>,
        Rasesh Mody
	<rmody@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: RE: [PATCH] MAINTAINERS: Update QLogic maintainer entries
Thread-Topic: [PATCH] MAINTAINERS: Update QLogic maintainer entries
Thread-Index: Ad0k3Z1psTDJVk1ZQLyuB7vz1d9s7wGCLfgQ
Date: Thu, 13 Aug 2026 05:41:55 +0000
Message-ID:
 <CO6PR18MB45006230C89A6863CA4BEE27AFDB2@CO6PR18MB4500.namprd18.prod.outlook.com>
References:
 <DM4SPRMB009376AFD15ADAAD33C4ABC9C9D32@DM4SPRMB0093.namprd18.prod.outlook.com>
In-Reply-To:
 <DM4SPRMB009376AFD15ADAAD33C4ABC9C9D32@DM4SPRMB0093.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|LV1PR18MB988708:EE_
x-ms-office365-filtering-correlation-id: ba13c322-9836-4b74-f0f9-08def8fd95e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 B7EapTW9VVLvWY9cjLfwOszwYkQhG4IAE1kUGMBD1qDhpri6xvEjTKOKTKdJPxvimzO0BUyNyJdh8pSESHCinfggsGMz3UuiQ0As7pceWv0BLZez/nXKYig4EASy5Tt30sS7Hhu3RV0yxoEIxz7haOJdyzgtvCXZNakcrBEnCQq4j5Bg6QtrtAbrKzIfc+PUeGwgh29lgc6CInKQjbN3K8Juog6L1PuY8PKOfi3LuAEQ+xSj/HpvJ0uOIb+QBaWO8v0du94UC5Ilc6k/HlDzsAH3d33mnyPjbD58A7E+1BXpk/Ou2noJkXYOThY2+IUzNJrze+bXQ3ojD6FilIOF0jHsopU5Lb93hLM7ZB4FfKk4dVaDPVeAmHLreE50IYNc1Nfpx5ulQPFDK52rghbWun+O2X2sIaSkFdGT+s2E+X58U26q90ImK54aoSRl2SXOP86KNEimoxXGXlDFxor91JlylqxVYyRH+Jrep3VVdXrSS4nFI6rxFe3uLjX61FyKxAvH+oTabGBzvZC9C28tniw2xfsjtZVwVbG0s5AQwvcmLI+PaEsFbovUE2xK0gkKEmVZ6L9zVyj0+vc3srgs6nR6EWL4zvu/PktjBt8N7YmpS825SWAEaibwShvWZtlhYyqgBAA+rt4KSzpSzEAElbHdmSnTTzA22lcFEtw8OY48i1IWIgRsd45WbrRU3/hVfc/9XoGHaJUCmBPCLGYZya4Mvs8z9g1BqN47ESKcQSs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?NfMm0rWWhIvXiG+JpNEm6zOs9N443SzNwvL/Km/cn8cI+R3tsSo1AUEyLq?=
 =?iso-8859-1?Q?ZDcLigUaK/aBm0F6FkKSVyRBgfWsI68l/7Z+jSAMMpYxbKeMvdRMxr/e+L?=
 =?iso-8859-1?Q?9mXCe0q55ea2/7p3oFOfI4W49biVtNLCM3QZpp41ep0G04f+cgj2O06KVk?=
 =?iso-8859-1?Q?jdOlJ6J1VQWJF4vkTxWsmDYQSsB2jwATsNDXyizh47UvichgTV26686rgb?=
 =?iso-8859-1?Q?n/IY+m+SFUPPDK9qU/H3OlYDZRnJqfBPwiZC7nGrpCai432tK88hRhYj5a?=
 =?iso-8859-1?Q?xIGfR3gIxBY8AdSZR1FnL2Z5Fw8FO53Uf7G8+Tt3m2cVXrOcFXFzeaaSVA?=
 =?iso-8859-1?Q?42r9GHEUTDBJ2DMEkyKNXFbxK2Wfftia8oT1xNarCHCFWejayQlHqBMhrW?=
 =?iso-8859-1?Q?bZScMLT4CFRxroqYWSicrm4N8J4o4nXCK979ax5M38xuhX2AYlRKBI9fiF?=
 =?iso-8859-1?Q?aQtz+eNrk6fugcxCb16D24SYxSGnBn9q3yAYphtA4my8gKJ6eo3aeyQm9r?=
 =?iso-8859-1?Q?GBk6uAGKnagboiPPHaDcsYdwprjDYs2Ny/gBcInxASRoY+BSgyPxVF5gVy?=
 =?iso-8859-1?Q?vOLU1mH2XkOHQGEb1kIO34n8S0+5jetSSHNKo1fv3CAM9ORyBnhkDx7y9q?=
 =?iso-8859-1?Q?YBwcFLTAyviu6dwqauA13uIn8+DaTsjlgxucKyOlBcTVc98nCLGo4Jg40e?=
 =?iso-8859-1?Q?V4qt5cq6lSfBMSKQ2V38Lutwi0bPlLxT1aas2ntOOycWYvg8RxVyHVggid?=
 =?iso-8859-1?Q?Mt7UUd6ncjYY2KxwLWBA65dIxJ1N5u2vLEtOJ9WydOmSULXcVndXt6hXPw?=
 =?iso-8859-1?Q?Hcj8GKSfoFsoeJZ9/7zF0IcRRAAfBrQRdAsIRO3RfPQ5sJRP4j6Mi6yJrA?=
 =?iso-8859-1?Q?5LGFxzLbOvd5wsx0z32s6RqCgbsVQvefQHbJ+gGDwUfCggYZSWrN1UHfz1?=
 =?iso-8859-1?Q?VloxZXSUMMxdHKadsLpk1PrdPCm9JOb/smW611Z3wvGEEeRhFrND1lMFv8?=
 =?iso-8859-1?Q?NhuDT9B0a7glIwO6wpwdZ35jSi1pT4vEBshJPDHSrHwpSEs1EgnNIYFCZE?=
 =?iso-8859-1?Q?JI7Ep/gjNE5DuYUW9osAy4UgenHBy16P0NIyWt6Eot1hTIm2eKWRhouPGb?=
 =?iso-8859-1?Q?6qK4naiPtaAirDAbYxC3HFsZDhC3SUM39CA3mQ04baiqsrf6b3cF72/cF0?=
 =?iso-8859-1?Q?V/gOPQb1AE/gOUV5qC8qZSMRN3BOgaNYi/GgKdRv+3MRvWHB6VeQyIhE/Y?=
 =?iso-8859-1?Q?rQVOHp0UUJLaTgzrJzrFcIBddufwUq+HzmCTEFOOZeniCHS0sP4EkB7GVD?=
 =?iso-8859-1?Q?Tf1mXwEjaodTswWsr+Mr07tWuZ2y+qnU+iOovIgsW+fX5Znndg9pu7C0R5?=
 =?iso-8859-1?Q?SWF7hfmtweZ837xKENMWT9rdLv0jk2DQ6KPOk0ZBPc0+jtLvQOS1HYZPEl?=
 =?iso-8859-1?Q?AzCLBI/xL3Mp2LayImGoaCqK8J29HXJebcabVQ14wFJvZlg+6aTIsEX7C0?=
 =?iso-8859-1?Q?w8zJb7adDK/+zVajjdvBYfOWG/+M8cE9QnDmx/UNsiRdsk4rLUz9Wifyp2?=
 =?iso-8859-1?Q?5Sllv9+nlMw3sT5UUUBbP6BgesffAPECQrY/cp/jXRbKAIuYqGjfVb+Suu?=
 =?iso-8859-1?Q?XsveEXu+tOCUN1BnD7r8ZMc+k6aGoCS3s5UQ2zmlX6jt9XAFlZPMMPtzrD?=
 =?iso-8859-1?Q?l+NsGlLxeMMTo1o1qK3Xe1hoGzLkFImCjfPQX5n4QtlC0QmO7MXzIQA+ar?=
 =?iso-8859-1?Q?/YyIMKsat0ZttzX0+MkbDuwRIClGumVGVpBKBvWGMbfmDS?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	lKWQtIzl7dvtem0oLrzZcRvcftgw/QqAgp6KcziXIffVxQifsIVQwDtxfrEjNOtU/9IJZcguw5LujQ3lnr/LPrVAMsglalrb8Cm2MO5iJ4c87G/zFC/dTBUCfz4uDExDVNRS7nrEK1xcyDDcDQ/oasaDAQzm8ciedj4AyPaLWzV+/eh1pZgCUZeTkMI2NW4xw2Rx29LFq7deXPLRbUNEN2kJ/ZR1xUGv4XZ6blmmV60Aul737w85CKOPSRhZauGxh17F7azS8CDPj83Kn3Ncf9Dde7J7LCveCtU1zgZoKp9MioV7djzCBBu2XhJnL8IHs4ZRXzInmFT+zzLhmk9ZOA==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba13c322-9836-4b74-f0f9-08def8fd95e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 05:41:55.7528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gKO9VGFO5tA3Rr3Tsh3EUjPvMGCgZqaaVUL/fVCGUMRHJyLd64qei3E/zm6WeR+fJ+iF2s5mDfWxYg9hmFMxlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR18MB988708
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDAzNyBTYWx0ZWRfXwhwpcoHs5xKY
 lWlE73Pu6ucCi7FGlwEpTzsaU/tLhJJKmMZkqqREHYvDEOrJ1G2t8MN4nSeox6pl99WyOlGFVv8
 YoylinsTGRqMUaAoEwKnLhDu4JXfH9U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDAzNyBTYWx0ZWRfX+CApVDackCuZ
 Xjtb4LXjkyr2K6tSkBrcYzBawV5/FLWp7bsg40lUsmLAnnIRXiTWkWCdGd8jtQvWk62qSEnxluH
 C2m2FckTcCRoUniZ9BOYhx38A4CXJU7A4PkjWl1NO3PKlZqzxuhpD6uuyoTGhbSlW/eq48XMWOK
 bPCaw7cK0tGGibG70RLfV452AfeVfWezdH+b98UkYi/GB/68grNOFhQVqPIu1fA7mDXUHR5NbQ+
 6DWuCvrYsebWuNSTk9pZ1ehxz5/6F6DFYo9sj3E2LeCMtzdo9OaGcj++BLPD21HEZDT3onq7FV5
 BMNd0tIS5yzWViRG1Bgcvr0MSd8Tkk1QcJMW/1BZX39ys8Rb7DQf/tOtAn5rHrBq11p6M8J8yiP
 ICBMqDG2ubQGSFQAbwJPZUKgJgoBZlIX+X5t9namITuLWuryfVDqFuTHy/FO7G//+Ez/KdR7IUZ
 7p9s4xYOBuR+mYHWmrw==
X-Authority-Analysis: v=2.4 cv=crirVV4i c=1 sm=1 tr=0 ts=6a7d5942 cx=c_pps
 a=wX8BO1TzPc5cEc2XX+F04Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=Sv0fKeRqtYgA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=-JobIAYWZmJfhqfiVk4A:9 a=lqcHg5cX4UMA:10
 a=wPNLvfGTeEIA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 7OYynOg7n4krr6_Ofl8mcT76Lfo2R09K
X-Proofpoint-GUID: 7OYynOg7n4krr6_Ofl8mcT76Lfo2R09K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_02,2026-08-12_01,2025-10-01_01

NACK.
Remove GR-QLogic-Storage-Upstream@marvell.com as it's no longer in use.
Create a new one and use it across all the drivers instead of individual em=
ail IDs.

Thanks,
Nilesh

From: Nimal Prabudoss [C] <nprabudoss@marvell.com>=20
Sent: Wednesday, August 5, 2026 6:57 PM
To: linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.ker=
nel.org, linux-kernel@vger.kernel.org <linux-scsi@vger.kernel.org>; netdev@=
vger.kernel.org; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: jmeneghi@redhat.com; mschmidt@redhat.com; Sharad Padol [C] <spadol@marv=
ell.com>; Nilesh Javali <njavali@marvell.com>; Rasesh Mody <rmody@marvell.c=
om>; Manish Rangankar <mrangankar@marvell.com>; Nilesh Javali <njavali@marv=
ell.com>
Subject: [PATCH] MAINTAINERS: Update QLogic maintainer entries

From f9df938de4f92d010e88423aff3fea4bd3978a99 Mon Sep 17 00:00:00 2001
From: Nimal Prabudoss mailto:nprabudoss@marvell.com
Date: Wed, 5 Aug 2026 07:56:07 -0400
Subject: [PATCH v2] MAINTAINERS: Update QLogic maintainer entries

Signed-off-by: Nimal Prabudoss mailto:nprabudoss@marvell.com
---
MAINTAINERS | 9 +++------
1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 510d5f5311c5..7c68f09b10d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5183,7 +5183,6 @@ F: include/linux/bcm963xx_tag.h
BROADCOM BNX2 GIGABIT ETHERNET DRIVER
M:=A0=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 Rasesh Mody mailto:rmody@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-Linux-NIC-Dev@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:netdev@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Maintained
@@ -5191,8 +5190,6 @@ F:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 drivers/net=
/ethernet/broadcom/bnx2.*
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/net/ethernet/broadcom/bnx2_*

=A0BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Saurav Kashyap mailto:skashyap@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 Javed Hasan mailto:jhasan@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-QLogic-Storage-Upstream@marvell.com
@@ -5201,10 +5198,10 @@ S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/scsi/bnx2fc/

=A0BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Nilesh Javali mailto:njavali@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 Manish Rangankar mailto:mrangankar@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nilesh Javali mailto:njavali@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Manish Rangankar mailto:mrangankar@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-QLogic-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-scsi@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
@@ -21660,9 +21657,9 @@ F:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 drivers/n=
et/ethernet/qlogic/qede/
F:=A0=A0=A0=A0=A0=A0=A0=A0 include/linux/qed/

=A0QLOGIC QL4xxx RDMA DRIVER
+M:=A0=A0=A0=A0=A0=A0 Michal Kalderon mailto:mkalderon@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 Michal Kalderon mailto:mkalderon@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-rdma@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/infiniband/hw/qedr/
--=20
2.55.0

