Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F17296BA8;
	Wed, 17 Dec 2025 21:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005594; cv=fail; b=NzjLQyoC2l7aEnMYSgCkrFC0p4JruEMt5jRYtV/NjbQuOizEwkcXOy4LYyzsOR7INBHhyNlYVpJL2ArtYrJI3UMIKA0ReJj+XpcXPupVA6u7zG1L17FCXfJvdXG6CumB9uvhrm9OiCuismiKCUZhttHZ0GnwnTtKANJYctx2MiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005594; c=relaxed/simple;
	bh=EyhVEIMPIDCWL9O+j6ibOYk7Qd9OF7h/AzZzxLxKC7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nOHlFBimH1F/Qt5Few8agil4zA9nhuybI592TtfHohqrkDk2VWC6aijlM5ofJIRA1ZtYXjA2Y44NGRVKjB/MTAucPbl53mPIgOi9Y7PM/KFb60XhYBIg7fFHQn/UhATG82ln25VmN9w6S+eEj8dQ2Q/tnTLJK0KcAtPw78Zhwjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ld9CVwIW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qysd3HZv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ld9CVwIW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qysd3HZv"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHJQfio3447813;
	Wed, 17 Dec 2025 21:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EyhVEIMPIDCWL9O+j6ibOYk7Qd9OF7h/AzZzxLxKC7o=; b=
	ld9CVwIW4UTOLRPbQhfn39kq+Uiec5B8JQPcl/6Hoq/M/yKxCeL6/lHTOv1WNx/N
	a1AoRJaeJka+ZL1Vv26bJZAsi1VK6DMSVe0kw6Ru1B+g4v3vnAjrgLCJkzdxF8G6
	d7Hx+r8+5MXX/JNkzt5Lb01Pn/TwkqU1AElxQJtQkY3yBV5lepSL1xr0RnGhUSxB
	rtMPnd9ZmAEheUKmywf73BXA0BRK4Jp4buzK0QdgCr/1E5/sp/8gsHDc6fCXtxJT
	eOYgdSnslsDZsCD1cICSs6bKTOnIhCzXcSNFpcmRr0WGgo0Sp1aIQRDG090PyLuz
	nZq8YNyJqEC6856I+NfEWQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28eq20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 21:06:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHJCtY4016421;
	Wed, 17 Dec 2025 21:06:28 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xknjpsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 21:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EYIH21DdBOpbOXOKlZ36zbi8Tf+CrMp+qw9J9NL5khrBS93c+S/3bW1xUJx3UbKzBy8MijjKdhRUoCGZ7lrYs/a4s6lb/uXm4pfIpCP1zuJO27Y7lHTTAZeccoXPKevA4WDiuKCELwtehqARmhfdH6RFKFuJ89a+pMwdR65jGju6KsndnBSo0bAmbzNmvvd7Qc8WVUg4F8O9lZ46LkhaEKX22kdGmZe+6z8lZ2OImtbOOfmUBLPDG5N7B78DxSVn1+C8cw3H16scvS+4A0dfzz9tj8jo4BO79B+EOouhZwnky2cpJ311auucZ3XWgDssRwD1t7WC74uXN9LlB1siFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyhVEIMPIDCWL9O+j6ibOYk7Qd9OF7h/AzZzxLxKC7o=;
 b=dTXzuNmDKDhdhlOy6PeJkz8pCEgOVIw1KbtxeR1TzU72xoaXtovKXe6io44nEN/pwpPQQRzrRDnMfVKAeOHUkMROlTodXG2oWvUdGvtDdNz6/f5ljPcps0WPTZ4eVGzMRe3bxK0MkbMfahB6cRG67udEO4AHtFdYHGPT0N4Fak2NVPo5M+N8A1y7pCSSKb4LlJlDh9UBMPrimqKqJOw63rhtCAZzqAOaZhOpgVVhekIKJTZSYr3TtC3MKK3f3Z4LrSl3Pupqay2nMd+0ABP9PCo4DAoYK4wj/e2RY5wfBjyMs+XzLrayqv5HEzVvhn6KDkgNOsF47niPgEWVbbRANw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyhVEIMPIDCWL9O+j6ibOYk7Qd9OF7h/AzZzxLxKC7o=;
 b=qysd3HZvvJFgXpU+AcTuHKHtVYBCzlINEz+bSlNqoasH1zCZMkU2YzRSBojgrJVdDk+6tOiURimuiglcKJS618xGe3zFM5Wu+r23iz3gcfZMNc4z3ij7//14n55RQht9sYzSGqaB3lJmOpGm/8Khpku+m/KmVqrtBGPFFWMkwIo=
Received: from IA1PR10MB7240.namprd10.prod.outlook.com (2603:10b6:208:3f5::9)
 by IA1PR10MB6878.namprd10.prod.outlook.com (2603:10b6:208:422::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 21:06:25 +0000
Received: from IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364]) by IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364%3]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 21:06:25 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: Martin Petersen <martin.petersen@oracle.com>
CC: John Garry <john.g.garry@oracle.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>
Subject: RE: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFYING_INFORMATION
Thread-Topic: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFYING_INFORMATION
Thread-Index: AQHcYrKqOKwl4ayFpkqvfpZLHQwbebUlLq7ygAE9m4A=
Date: Wed, 17 Dec 2025 21:06:25 +0000
Message-ID:
 <IA1PR10MB724030F8B37448DACC1A2C9998ABA@IA1PR10MB7240.namprd10.prod.outlook.com>
References: <20251201110716.227588-1-gulam.mohamed@oracle.com>
 <yq1zf7h6ety.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1zf7h6ety.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_ActionId=edd7f48e-4c37-4fff-9be5-e6cb700ce02b;MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_ContentBits=0;MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_Enabled=true;MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_Method=Privileged;MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_Name=Public;MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_SetDate=2025-12-17T21:06:16Z;MSIP_Label_3c76ce46-357f-46de-88d6-77b9bbb83c46_SiteId=4e2c6054-71cb-48f1-bd6c-3a9705aca71b;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB7240:EE_|IA1PR10MB6878:EE_
x-ms-office365-filtering-correlation-id: edbc946c-6680-4da6-0f1c-08de3db023d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?webmuNzBomstiBIkvq06/vpbygXC9HgFCDhF+KsHyTq4VTVUlcZEd0nryV3E?=
 =?us-ascii?Q?+PPY039mNl4IRsyDBVb8wTeKQBrx4JohkuGCvVJFUAcb/ZYlSfbY4fN6Jo+j?=
 =?us-ascii?Q?rsbRIvEfdHw85XorutE9luuJt3Rl4Q8xamYygJM5HmiJXurJTqnFPviog1tR?=
 =?us-ascii?Q?CKsXnI6bOjst1/e52VbNRv/WSGslbkv3qvdyE3c5EKbyIBsc3V3vMMeQTOp9?=
 =?us-ascii?Q?76eHLo2QIhe1sqvfJ8u0WVhVeKXp0EpE6GzBXlUQGuSeryxAKJMR0GwSy8hb?=
 =?us-ascii?Q?7iXQjVzkpM1epNt1JNN+eOWIGj+9opx+cWTc8HRkzmxnBU7P45mywzkypFLg?=
 =?us-ascii?Q?UPM/Ss4cAkFsPVxxGu+DRC6pcZQjDb+eNPpVPRfkj5IIi5PnHCPLvth6r1x1?=
 =?us-ascii?Q?9tlkt0VZdTQ7Wht5LrsMfCK77J7ubniymqDJTJaZGbT68D9eJb+Mnanxb9TE?=
 =?us-ascii?Q?TILGJLQwAuEnHTV6juri2oBXZwlpyBpwhYLTeVttb1dzZob3xIYexXtlF8j1?=
 =?us-ascii?Q?rtZiDz9fD0Auf9q/49z3D/U+21UOfm5RW8piwNWSLjrnNPDw5wg5l41V+0dl?=
 =?us-ascii?Q?1f92SG8aA+hl+1/yOJNs6Fdbbnq6pkUiPDVj/aRD8i7yJGZFzUsBwaV9nj04?=
 =?us-ascii?Q?mWGzB+MagDG0MN/NOVfa7Rz2FHSHmgMRmjmP0cmJ74zsdBLj8aHb5Xtl9Kqu?=
 =?us-ascii?Q?SLriB/jvO8Wm4hVp/rnJodepbcBD+793qhPrFdevoMrzyNEzMrgEkAHPSxdK?=
 =?us-ascii?Q?XggG97S4gGHkNdzQKStm/o6OXTizh3PV2nNsKBzj0dyXVL/uATiKRDxZ/KSf?=
 =?us-ascii?Q?8qCF+z6DpnH0qwNUeQED1Ec9JmcFATcOZNTTZHTitwJHnYPUu7nTpft20ocq?=
 =?us-ascii?Q?FNDjL51V5Bmx41PTqfrGiMNKzW4/jM5fGsXMpfwfcTMeshewyj3Mo5witmp3?=
 =?us-ascii?Q?xFrkJj+mAsP6JXg7ZdCrPQ6Ldl9XvtxM9mIIicf8FS16jhWfK73HmpN5Y5Zc?=
 =?us-ascii?Q?cpTlHbM7QCROjXNAlBKaxJ0AVsx3aGsWD4SfvPh4DqknomIh9epeoLnrewcC?=
 =?us-ascii?Q?5UU00XU649ug3jNkgs6ujpAHanJultSBEWoy3Vif8Aic3fgq5FTsG+tLlQki?=
 =?us-ascii?Q?BF6ww7VOxZG4/1VwZYrqPV6qTR2RvdjK0ThFIhYLMhAOhgU5KXMHE5e36BDp?=
 =?us-ascii?Q?SLk1IYmgupcTkQONrId/84IDF+Tl+uqA5QkkoYNFAFkS7hDcUHBZF6oOrRl6?=
 =?us-ascii?Q?PYoPlJ8TB5nYz5qwRPuVt0KOBpkD/0fJnSJG6PGwX/vYX57w5P+WkTrqaF0m?=
 =?us-ascii?Q?NcbkEjNC+126azKuh1VFeYiQWTHBDsscAqY5KAVE+5KElfc3SNoLJJYivlIU?=
 =?us-ascii?Q?FiaN5EFO5NH4BxGNPxLtjtjUpsxjngeFAVC03UVszaOtLyoQMZ5F779+CjX9?=
 =?us-ascii?Q?wfRzPeKIaES7k+hMMNT/MUJMVkb0ydrMgpNOnhmeLAl4b4xy6rWFlpmeNNq3?=
 =?us-ascii?Q?HsWtJCGStDhLS9lT2gNslPZYeWASlD6b/OYj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mSqnfYwO8HXDiHKjqZizAxnJwwKqJl7XUDsBo+DbjRhNSk2tHaX5idbRyc6n?=
 =?us-ascii?Q?Vh+C7+rbKzGq3LuDcEqRfRuO5pw9xeakAqL16vGCqJUL4u2/K12xx6U+uCyA?=
 =?us-ascii?Q?c8WQkP71C71WvIZiCojTjQP7irjkcrdlLZYTR8YmNvIAaklZETAtpd5QuEkj?=
 =?us-ascii?Q?zXR3ehtke/24ExGRevLgKqoCAjtVoQ0/EY0F+1QVyHi+yTWY6WcjrRkBXlBl?=
 =?us-ascii?Q?98IOT7LIucSNAM+tLWcpEclwmzkWVveNvLfamkdAvGLNkXDtBiM2BBNekyvl?=
 =?us-ascii?Q?EyjFkgbNZvUML5+rRHls4cuweXXQgz6GH152vkUfs521LnZa4e5yGOIOx5I/?=
 =?us-ascii?Q?ef1acH4LKhVTrxb5eAEhJC36qDGY3B6Qvvpf9W3XD5pGg7DTR0OEJvT1ceny?=
 =?us-ascii?Q?PkbQ5VZtcGZU4gFBdIE0c/9MoaSEhsjPI+6YE33/Hq6cK+2U1fRmTuaeqE0J?=
 =?us-ascii?Q?civoI0pT5Bg7vQ+quw4K5tbwvQXy4+YRIbzJfTHA53d+3HVfOv7FFSWEesfG?=
 =?us-ascii?Q?OlHVPeNbDL1oTBJwdb7Baiu3rHZeiotPH2L5FiNSFkbLygKamRxDFWNvK2Oy?=
 =?us-ascii?Q?F+wTP5kNq6iCyM8+OOJ7WvKzkt84JId+Crb8RYIFM1zaS2DWCSbOerFpR8Gv?=
 =?us-ascii?Q?A2dU7DdGwSA+vfhN37P6lVHlgHS+wt+CHgp57L1SmMHS4MquSlQwtUE9Gnoi?=
 =?us-ascii?Q?+xEEoNIifsIZB+5/eGqeuCLxu3hTFxNathg9NKosXqKFXSTHG4G3Lrg0JiPV?=
 =?us-ascii?Q?7ufNFKcZvWMSOgFRPSZzW7Lqmcqtua3mnd3qQxCcjN7YwLSAj16MjJNJVvZV?=
 =?us-ascii?Q?1dc+r03Noz84+lxGzVk7/J5aO7GJJaReEytFkGUvuWQtJp52sroGO6J0pazm?=
 =?us-ascii?Q?mj5kqZ/8Gr2FD4MKh+ilzKgwnAFjxfnXmLP5nNmCK4b1BF7GYwhc9A5d7Rsw?=
 =?us-ascii?Q?AWcmDZh+Ed/FCoH2/Lt8RR3GW6Yf7Ury1w8pPHjPyrudDVbQhyWzERGChWsD?=
 =?us-ascii?Q?OAz1fb2YA15smbEjKyXyMkFio3Flo7/65JIhdISULSUU1MsqCoSBjjD8/HMe?=
 =?us-ascii?Q?qU/dHN+9sz0VUe07yfc40HsTY0DyypRHillWDRntmZOZXqs0rxXuaYe2QlP4?=
 =?us-ascii?Q?bgPcfIOp7FXBOpjgiyAIQO1lmfExGuZYkZ7qEYwb4BwQVmWanngm4cyW6twL?=
 =?us-ascii?Q?HebZ6bLJzqi1UbIEx+OlstSlbsn5vm6MeO5wBBDhXkgw+hM5muj+4Zefq4rd?=
 =?us-ascii?Q?FTLQnD/CIuwz2erO4iaXmJ1CIPqMRtr0PZq6EeWVRzem3dz6hag8coa4Dx7A?=
 =?us-ascii?Q?hTJROH5KlA/slsWAATUnOSiH/sGYRSzxQc2drrK0lDulQ4hGFsvEm+H1hfBY?=
 =?us-ascii?Q?A9BjGR8lDW27zlXHrQTtUrdPtD5U6TvRdkAx2sBQd3wKTiPqYuO5lDdNHVTH?=
 =?us-ascii?Q?6YwXf60S/9ZWuVy5ArhqZy/W91L4NEkxlETvWXO7jQhoFdfolv3sP8UFQHSE?=
 =?us-ascii?Q?96dA+rHFlASDozOIcavv60J2Hs/OK7PuRKVNf22+bUbaNfwDjvhlflL4NxRV?=
 =?us-ascii?Q?mLOMzC4lb3n+xgaM2jg4Alt5hPJKVdk320udVoAu?=
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
	90svjfvDBl+tagUOeYa1wYXWyTGxeWEJ2LzMLp2IgeVgjnurt0NSm6pMp5h/YHi33mGKqESKKPge6Vd2Er6A3k3wzNtmH7iYR31eCObPKudyxCb3CVAMOV36sauR2P8BUbil6jQ2WAiXRnIimq4mFVshe5VaO2+UlnJdNgBcM1CMw/Q8hC+xduetcSiWwRBDl/EWAmaH4E1lMjMD4/QUS2j8aPhB40JbhAeiFWwfbsEe6d2llJgYDAMKOjsQJ/XBdK758eCnXUsuyQp16mOcotK+vjwtlTl9TrLG3wTQNRi32wd/QUYNlRxsvkjt2Q2IXBThoIHWwV1oEuqZa6Dps8Ceo7+FAeHNOV5cCx/nWhTvr9KM4QRsrfqvJr0sKMDVMMdpJXyd/fYF26uCEat1ouDqVQSOGLz2R7NqNpk6j/AcaZ3vAKpB86RzZFzXVJNo9QrwayB8i3yzNG/q2hXMxjptA6M8dJK3DyIIpRPoR1obvR5XHmm0/rQr2GXlkTWHhkG1qfnmIaf8z/2VYoLiQQcjeB2AVmtGxH63TQIM8hjL6SyaYlPNJJp3/glsg6XBF3Iw7QUk7WRIPoIyOY2jCMHwivkAVyBGamZkrXU0Ayo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbc946c-6680-4da6-0f1c-08de3db023d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 21:06:25.7767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FYl+EyfiYPNKC1wJIYDiSZJ21+/i6JenAodao2ROjmXTAVLDcbmeXLZTEAjYjQOE+xPmdqF2tYDbdtjeUJOaY+NCWkHOOeIXDVezEtl2jq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6878
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170168
X-Proofpoint-GUID: hbUysWyYc-eKHha1DxW7qbFU7eoEcv1u
X-Proofpoint-ORIG-GUID: hbUysWyYc-eKHha1DxW7qbFU7eoEcv1u
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=69431b56 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=y-Py7Dv0Uf3m_nGsNIgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDE2OCBTYWx0ZWRfXxDAAjnTGLZyD
 iiOUbGHzxU1+Yb3iOUmAqMNttMQtG+nuxzhbwnx7SdSvG7Lucd5T2IEPwwoPhbeMcERRzWGTXQ0
 8OBU6op5FCYKyT9l54wPxPVEfcfEKAKK24yNlP9be4lx7x/CfV3ckqwIMq6XeHLeFqRIql66fYv
 KrDCmWEPQNGlu58SYkTkTDBV4c0GucqNmDHCKJn30Bb9qoVT8OhAgOAbO4h5+adbSYmxDxno6DI
 rUXvsLCm/gSciPv7m5v9aYy+7gK9ZYy7d9ciQ8eY/4TNpeKgxxGb6s9jajn5gHeECbt3khcjXa3
 V9ZZEKDpoWrGC1Eoox7p0RnhWIPrmJ9UUS2eRvDUcMlCJwESK1E8dVW6YqFf5qVD7bswFAoAHFi
 H2gTQT3sIR/6C7a2n5r4HNuUr1HenVRLx0qG6E7K/CMdmiCEUME=



> -----Original Message-----
> From: Martin Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, December 17, 2025 5:08 AM
> To: Gulam Mohamed <gulam.mohamed@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>; Martin Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; target-
> devel@vger.kernel.org
> Subject: Re: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation=
 for
> REPORT_IDENTIFYING_INFORMATION
>=20
>=20
> Gulam,
>=20
> > Add the emulation for REPORT_IDENTIFYING_INFORMATION command
> using the
> > configfs file pd_text_id_info in target core module. The configfs file =
is
> > created in /sys/kernel/config/target/core/<backend type>/
> > <backing_store_name>/wwn/. The user can set the peripheral device text
> > identification string to the file pd_text_id_info. An emulation functio=
n
> > "spc_emulate_report_id_info()" is defined in target_core_spc.c which
> > returns the device text id whenever the user requests the same.
>=20
> Applied to 6.20/scsi-staging, thanks!

Thanks Martin.

Regards,
Gulam Mohamed.
>=20
> --
> Martin K. Petersen
