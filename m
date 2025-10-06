Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012033.outbound.protection.outlook.com [40.93.195.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F83128151E;
	Mon,  6 Oct 2025 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759754727; cv=fail; b=DZ1yCxV8GVVhPBpGMgRda3okzpP76elDuoKfuhITZqOE/JDZufMVfIBBAZNP5GktpbyyFPaU0CNluG5GeNopiOiXiGSPpwv41aMjX3LK0EyQb3G7oX08mzxg08a6Exz6pxm7gQG7+oeRIVSuUgrwIfPEzp0J+cf+158VFZS0/Ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759754727; c=relaxed/simple;
	bh=7/My7vamDiBr3F5s4B0jtgeYyPz8UwEkKVPkzr+z3G4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fGCtoejsFN4HnQ4xR+RkQ/8thOqH3cl5LoMJp0ssBYlJaep7snRfbpgGiQxaw7aHQqugWU3hutdhDe8YQv8e9D7gwB4vTHXzbtjJNK7vZMbeQhaXYgmcmVOgAsJIHBtUuVAnRJMfOBFVi5cXF5L5cO+O5ukIRba7+jYzZ151Prg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Bu+TQ+o1; arc=fail smtp.client-ip=40.93.195.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Bu+TQ+o1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xsTvQlgaU9z92ggb0+MkYtjXk0oyeUeeoupGOntYCIBqDfEkpfq5KNBjPhwa5HU1WPzcVu7yEJr90aSIwkiOaQIoRRrX954OK4t8skhQapaq9GeE58y+ghOboPAqwtJYUuGXYNKgodtMu2UqhRps3KXrR2XiJkHnL435uDBRWxmLoRExzrN63bOVvtHuST+H9lJadWsqfFWKdul0Fk9bjLLOeTYc3AGQel+VTgZlOWtvEXMK3+0WTWgrDKZfLtJh89erkToXIQlycX2LflnAtWQ2B+NK8u1Y8AAKcIoSP7g7FpVFCiC5ICuSWNJmzAuwQAJstfOMsThymVBa79+t8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXwYiPRUPYYI8Lqu9sk5FLVIQINDS5hYG1IlDAD/GUM=;
 b=pE0c7K7sxPI8FLyUFvYy1rV2E7erAPz3vUSV78huxnbxMj123vX6V3hKf1ST4VRmRI7ryOMbsPmL2VoCaeY4wWytcjUD3HgBdH42f7otYU7sIxgPAmxetywPxswslcrqrMWXStBovFy7s6OGS5qFinSPtS+WT/rkY6Q2JVCxib266S/WtBgEVtYaF9iKBHXrE4WcEnAV3y+ZVNSJNb9s+A7SwLUzPqs8R+PWs/w/uTa55YdYx4wMAao1+LHt/1UpzSbz2vvUdyV/+2HqtoiYxRK+vsgZir9ivKcngzI9F4BU/OdPnSP6GqJsnQuXRvrgI6bAX3bR0TRTE+uPe+0vYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXwYiPRUPYYI8Lqu9sk5FLVIQINDS5hYG1IlDAD/GUM=;
 b=Bu+TQ+o1dBohfR1JR8ileVSvBxvrUssZjwFrFdh3z6MIiSoMb1pFjN709hfzQ1SjAZsjMDbMzHSKKGobKQLKr6XEhh6uSeVXvM+LTbclTYxpmLh4Z+dxAVflaFaYZ3FWdEiHye7QFFT7IxceqFA7ntjpaDp0HSzEsC098/RSh1g=
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7204.namprd12.prod.outlook.com (2603:10b6:806:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 12:45:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b5c5:3390:35bc:eb9f]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b5c5:3390:35bc:eb9f%6]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 12:45:13 +0000
From: "Neeli, Ajay" <Ajay.Neeli@amd.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "git (AMD-Xilinx)" <git@amd.com>, "Simek,
 Michal" <michal.simek@amd.com>, "Goud, Srinivas" <srinivas.goud@amd.com>,
	"Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>, "Potthuri, Sai Krishna"
	<sai.krishna.potthuri@amd.com>, "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "robh@kernel.org" <robh@kernel.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>
Subject: RE: [PATCH 5/5] ufs: amd-versal2: Add AMD Versal Gen 2 UFS support
Thread-Topic: [PATCH 5/5] ufs: amd-versal2: Add AMD Versal Gen 2 UFS support
Thread-Index: AQHcKWKCuDUMeQekFkqjRSjml59V6bSax2UAgAjU5/A=
Date: Mon, 6 Oct 2025 12:45:00 +0000
Deferred-Delivery: Mon, 6 Oct 2025 12:30:00 +0000
Message-ID:
 <LV2PR12MB5869753B10DD898CD38BDCCE8BE3A@LV2PR12MB5869.namprd12.prod.outlook.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
 <20250919123835.17899-6-ajay.neeli@amd.com>
 <911ac2e9-2f3d-41d2-8a2f-74d2aebef21d@acm.org>
In-Reply-To: <911ac2e9-2f3d-41d2-8a2f-74d2aebef21d@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-09-25T08:37:24.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5869:EE_|SN7PR12MB7204:EE_
x-ms-office365-filtering-correlation-id: 81431ad1-56fa-498f-9c31-08de04d6316c
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?q2ZghWuv/9cjH+lPnISO6ILcpiG57Zrb4vCdhI4FKZP2F6CQhIfe7l9AF8vh?=
 =?us-ascii?Q?qJ4pEb8h40gmLxAhcKCnysXfsHJU3Uwl47Nim7VRnLARkbRIKJ2XYCj6S5x4?=
 =?us-ascii?Q?GiYGMXm6KRE3vKgKgkieqxcwhh6Gry2baS3XFAyO85CTgidQdR30b6ymetN/?=
 =?us-ascii?Q?g6HnEOTRrYplDDcoQ5ByQqa3PPs3a1zwlWx1EUPQJCvBAkRbFqEhOwKdOxUR?=
 =?us-ascii?Q?kaQGB7LaCidzhWwgPVcRm0LnMuLoU5lIC0BT9Y2BxRBP4rHMzwr9WUPLc+vX?=
 =?us-ascii?Q?ZwDNJpwulVIlIJLQSF6YRNX4bEWVhV61kJKvKZxCxD3AIMgBg+eehMbdGSOn?=
 =?us-ascii?Q?HTrx8YKDJ8yLcIuC60DWiezZo0f9pnHuJDwPbs5FlM8nN3dkgiaJ/8iakHHe?=
 =?us-ascii?Q?wkVHzv9oKY5cJXJ2/KqV8WYbwaShWOfQPmCBrze7yeKe80PNaSUd59TyZwic?=
 =?us-ascii?Q?wMr47hyJBnxELD52w1zKrcJmDe+rIdD4SPEyuPAUUnsX5tWo8dUpuvBuck6o?=
 =?us-ascii?Q?MRhR83/GgF8rGWC2Huj1vwbSuycBVQbB7kZGmj+z9Jh++FOXOwsI7/leCHMC?=
 =?us-ascii?Q?YxhNc549XT/o5aen3EqGPz85VyxsOlQEtZy0dhUA0q1RoJfRY9P0JhUGvRAq?=
 =?us-ascii?Q?xa4l+oeCglheEaATwtLP9EA2rCTjQ9v7cFCwDZfhHcerZXjdMqLNq+IFinlL?=
 =?us-ascii?Q?NypYrIkGhB34Q5Mw6FQ2s29sRK+9kFWkiywxqYYyoOEXHi1AT6w+exMdAkTn?=
 =?us-ascii?Q?YXYUaFL8beaTFu9D9F02+FKO0sfIyFApiCLhfG1evZ3KAV6fyyP+B5k7PHbD?=
 =?us-ascii?Q?HJmJJu7MKusjp9rcDjnYHs9s1kxmY4z9M6giXX6lutS+rsLZIfjizIXk9Xa4?=
 =?us-ascii?Q?QL1oqMzLykaBLH2OXmSqeyosPecb/5Sxq2QZExHhu+Wz/J8puXYVkDwyrSR1?=
 =?us-ascii?Q?KcLI2zO6qKchI8EMlSsAA6bq82UUtUTi05bvBKCVHY/SuzkZqJ3CSsObRciH?=
 =?us-ascii?Q?K8JLiQC+TBhoXclq3RLtsxhIMMLp9+H/l1BJMNI8KdJrWjE05oUEq5RFfFFa?=
 =?us-ascii?Q?Jccv4xmrLqBzho4gMI/VWEu7IWyAeFSuG/xADAChbSQbRvmWabMmBj0gaszR?=
 =?us-ascii?Q?HQpgbPS0j/KrxFbomlNXl5UOWq3LoD3SnWvDQ7lzkX8HqoYEKxKK1QI2O0qs?=
 =?us-ascii?Q?2jowPQ9sQSL7X10Aj1NmOZLmcwn32VeW+2bLHjdO2yYFpSvcxqghERQQQQMY?=
 =?us-ascii?Q?kuVpzTFL6TBl3BBIcRfZdFHOXjNbiTiZRGfQ+RGzM3WxaEqWGkWxUe4tI/v2?=
 =?us-ascii?Q?nStS3FKvtikDUr0ShEav1qubpFlN9WYX7B7XEfD6WkzUTFgsqhXl3EVc83cg?=
 =?us-ascii?Q?qsyIbURaUJh7vUZx4CGPHeqrVoazffAoyo9p/1rr6WSw0XtIUBChP9r+4PI6?=
 =?us-ascii?Q?YOkDzkmqbA+U03tkdZRMIJ4XCnpMWj0BjE0DhsV4xplRiffOpigP8S/W8wn3?=
 =?us-ascii?Q?Pe4FhlSypuU+kl/4x/iqWaOb1LSu6uXQ9Pvk?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?7XR96E5mE7hhLF6TXm6wxvdLykPZiDilguEzWWy35mUbWvybcKDcHm0tZ3KB?=
 =?us-ascii?Q?CFhi8Ua87P9XMJqrdo6htnkmi1G/bsu19PmwjmDKFG72Mgpiq4O3wMjAkdCM?=
 =?us-ascii?Q?8R1MuvbEhY/EE698cf6Hvit5jhiJFYGXl6WGv1Jnk88lKieSZfX+zkk4YWK1?=
 =?us-ascii?Q?+W/VZGFgveM0RBUwHYcZisAfE8rsSw4LKRiHozruJHvTrD8D2yI6FAuzcqLL?=
 =?us-ascii?Q?u/PY3togvihE505vLn+pi+TPQH9gMXsNHwVuiY4sFXk57xE4MLM/rD4pk13Y?=
 =?us-ascii?Q?f5UF8x/L1oa+LfIqV/lSygnjA2erW6buORwA+gwIvjhbP0h707KUOTpUQM8l?=
 =?us-ascii?Q?8ZFoIQ3+IcbFGtisHnOUs82z5buigEpYK6D8KufBseaXZUxvlgUXqmSo9M1N?=
 =?us-ascii?Q?UBBc33y8a2t1IkLI/AF2ayoIzkR2ngLqOOo1G5Feou4+axPiEGIPrlhipBE/?=
 =?us-ascii?Q?7DEkXQUinCnTWPFTsQ6GnecIy6gDuNQoLdSS7nFdt0B/tXpIKBVdE2FfjDP6?=
 =?us-ascii?Q?rWxBDThrwvA9FNwrHfQvJf1oLF3KbIdCI7/wScIRig4Aqm7CItsuWFHKHDr+?=
 =?us-ascii?Q?TLp3WQGUI0+FdA0tdgyGsl3EjNMyDCdBMM7cY23af4JGV0vPsKOg9UuGQIcK?=
 =?us-ascii?Q?IRJFHpozRLuGm3a+Bh8+SmDrWB+QIXOYcO/rhQSmGpbJNvVIkj1KXpVLdSSZ?=
 =?us-ascii?Q?Z3J8cvTKmaXqxXHTgUDjsNoa/T1LPssH6s17DCgYpnaNzMMDNPv1unsBFfcJ?=
 =?us-ascii?Q?GnaWmcnCzQJUctVWm7aEJq3TJt5eUTziNAEMD7jFU6nkdNv6k/mrCkXXEoj5?=
 =?us-ascii?Q?gdFyhC8y9ShCyPlGqkE5zQW7L/uh/SrcZw+5z+e2HPYtz2l9YtjRVNBbU6Qg?=
 =?us-ascii?Q?FwD6PDX2rjIr3yf5uPBmcN9+bVGQo4PWqkLBsb+BZ4PgJmNthjoF6IPGaEvb?=
 =?us-ascii?Q?ibaofN0uDvT7OGNbiY/JDncmZuGuKY4HJQ75VTsH1DvnxzkNzLkvghYnJEt1?=
 =?us-ascii?Q?NX9g0QyhBcS3siXh/JY4rgtUTVjOhLOK6cWfoCnqi+xfJSiQ/K0wRdXh79Mj?=
 =?us-ascii?Q?+tj2M2olOsfA3Bp0Schzq41fXhruL7q8CXa5VtY1ol7k/7+6PbxXdAmD+0TB?=
 =?us-ascii?Q?76lbdGOTqKWPNn1IIcIAs056xgbX17qnEHZdeU5CfxYcW2HM9a3/AH+azufD?=
 =?us-ascii?Q?tisCvyoFjxbNRG5nHVQKk0gN1Rf6tkpEFygcFqEDVI5ZshvNx1Wx42RbAVYU?=
 =?us-ascii?Q?MvPe0RKz2gahKUWGrtLcAQhf3BJxDeWQEAsaaVGNQ2e/+gxseaVce9ShP+rJ?=
 =?us-ascii?Q?A2x0SRADs4TTdClBhYVZsJIFqLjCi19w5ScTrhlmXRQy14rZxvICZnHX3Xg/?=
 =?us-ascii?Q?qyJs4cFm3KIc+6cmflnotczW14QkZoR7tzilZBynY3sQ+ejVG1LzJZKcBUtK?=
 =?us-ascii?Q?pTnYZY0AfWOS9QyJb6v4tHi4hB15CH2x3z0h81N0q213qiYdDU9HsmIanIqB?=
 =?us-ascii?Q?uvBArVa8nQfLClyYjkTxop4d5rmcxUQ8LiB6JdbeOVtZVyWTGw83GesFpT0i?=
 =?us-ascii?Q?z9y49XvjrwR+/cGiaconLeAAgfq2i3wvrxDnLoMc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81431ad1-56fa-498f-9c31-08de04d6316c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2025 12:45:13.1270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iVJ5FFahz0zoMsC9hxZ0HTRKXqHDnjfYLMmiZ69DOHiOPqv9IBG+I/ynf9nQ+frGDw6K4I/tkH4ewiO/a0GE8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7204

[Public]

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Friday, September 19, 2025 11:15 PM
> To: Neeli, Ajay <Ajay.Neeli@amd.com>; martin.petersen@oracle.com; James.B=
ottomley@HansenPartnership.com;
> robh@kernel.org; krzk+dt@kernel.org; conor+dt@kernel.org; pedrom.sousa@sy=
nopsys.com
> Cc: alim.akhtar@samsung.com; avri.altman@wdc.com; linux-scsi@vger.kernel.=
org; devicetree@vger.kernel.org; git (AMD-
> Xilinx) <git@amd.com>; Simek, Michal <michal.simek@amd.com>; Goud, Sriniv=
as <srinivas.goud@amd.com>; Pandey,
> Radhey Shyam <radhey.shyam.pandey@amd.com>; Potthuri, Sai Krishna <sai.kr=
ishna.potthuri@amd.com>
> Subject: Re: [PATCH 5/5] ufs: amd-versal2: Add AMD Versal Gen 2 UFS suppo=
rt
>
> Caution: This message originated from an External Source. Use proper caut=
ion when opening attachments, clicking links, or
> responding.
>
>
> On 9/19/25 5:38 AM, Ajay Neeli wrote:
> > +#include "ufshcd-dwc.h"
> > +#include "ufshcd-pltfrm.h"
> > +#include "ufshci-dwc.h"
>
> The *-dwc.h header files are for Synopsys Designware UFS host
> controllers only and hence should not be included in the implementation
> of the AMD Versal UFS host controller.

AMD Versal Gen2 UFS Host controller is built on top of DWC Synopsys UFS hos=
t controller,
which is why included those header files in the implementation.

>
> > diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dw=
c.h
> > index ad91ea5..379f3cf 100644
> > --- a/drivers/ufs/host/ufshcd-dwc.h
> > +++ b/drivers/ufs/host/ufshcd-dwc.h
> > @@ -12,6 +12,55 @@
> >
> >   #include <ufs/ufshcd.h>
> >
> > +/* PHY modes */
> > +#define UFSHCD_DWC_PHY_MODE_ROM         0
>
> Please do not modify header files from other controller vendors.

Sure, will add the macro to the driver source file instead

Regards,
Ajay.


