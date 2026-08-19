Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022118.outbound.protection.outlook.com [52.101.53.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E67375AB1;
	Wed, 19 Aug 2026 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787158941; cv=fail; b=poBOsEPLVduALh2692CaISYa/CkJHwzulbPesdPUlUfudZP5TSiOyZeO8F4hVGa6Ov8/MRZ2pIz3YqtsIo4JGJyL5y7sM6VS4hOsVw7z+D6IV45SdbqSnCae3OEUsaLMQWZEo39Yw1G0ws8ldLYVrXA1Y+GB6aWlyCjnjQj655c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787158941; c=relaxed/simple;
	bh=G4DwSA6Tfj6B8QfARodv/nU23wRbObDIpjX0MfoWw/A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y/5Sf7jgWJkGsWBlGxcEvjVyvRfpUXb7UqL/QhBB7JQPTyVEioVb4yowRvwf7kUTnk2WFfz76RX1rdtwHQhAsq/+voOKf8Y24nWbEwGudpA4DakuxO59bMpM8V5WDDb0TCbcMqZndbhAkvsSKVgagCHvCvWvlAOwRMQhdLpLvGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com; spf=pass smtp.mailfrom=chelsio.com; dkim=pass (1024-bit key) header.d=chelsio.com header.i=@chelsio.com header.b=e9UgejjW; arc=fail smtp.client-ip=52.101.53.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chelsio.com header.i=@chelsio.com header.b="e9UgejjW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oAsAu0K3XZm1KbILZqggen3LFh1tyuohU0A8XaXTmaik52sB1Ps5ti5r1FYMD30AzCplou5FLwYgPTumU+rr/2xMQNJBQD9MfqZoLABUANrfLJMbRkNUDzwxeB5nxIJPwfUWJzXnaX/gst0i/gRUNz2y3KUszX6m3qundinFenghaoLFBsAE+H12dqzyEMlTunJvXpKbdUZWEZcAp0P0NDHhyFnXmkuCvJFc8FL+5CRQdMj8rw0g8Ltwex4eJNCIjUXcyuK+gtAFIIH/kCFbbyxcaL9k3NoaZZOz4+olr/I8E1TIepTyHgUtSPJHusKnZiX/W+dfMckg7Q29tZcejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4DwSA6Tfj6B8QfARodv/nU23wRbObDIpjX0MfoWw/A=;
 b=Ks0OBlDWLAPXfki3sEBwb696HcJ2CyZCMk4mWcVaMDHuzx/hACLDWA0XmrlhFEA4l25xyRn36S5yoGnOioUwGg1ewkIC2I+JmMv09F2u8jZabBqB4LCKqVvY1KeZ/nRL9imNJHghnUvxbLerEor7T98GEMxICcx2cpJkZtAa+3dAUq4GvpSShV0GSiD6cRY6ZlbtY0KpAEjVHjruI9p4yDMrVRrGSx4Ey9VvquuSES7gZ/C6HcPZbGMkpedey4NZGWByPzxXW1VVHqTZPlcRvVC7c6TUdVKFW+rqFRNDDbzNmtIPeNJyIyh6acR2vNzZQI9Ll1mu08K2ZNYL1yJh+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=chelsio.com; dmarc=pass action=none header.from=chelsio.com;
 dkim=pass header.d=chelsio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chelsio.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4DwSA6Tfj6B8QfARodv/nU23wRbObDIpjX0MfoWw/A=;
 b=e9UgejjWzoihSjPIuIcxDK2k0Zw8b+EgBkUddFRB9rpG3eR2SDqIw7zVXApCMbuTjdEobMbczjamZTzUBdhIpvDeMouUPTni+tHkX95MwyTfOhnbFKTFmPsnsBQI1sXPcmozQcbyo2nmSg1eyooXv/X86R8aDtouUqn8K8HhX6A=
Received: from IA0PPF73BED5E32.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bd2) by SJ2PR12MB9190.namprd12.prod.outlook.com
 (2603:10b6:a03:554::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 17:02:16 +0000
Received: from IA0PPF73BED5E32.namprd12.prod.outlook.com
 ([fe80::92cf:1858:5560:593]) by IA0PPF73BED5E32.namprd12.prod.outlook.com
 ([fe80::92cf:1858:5560:593%7]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 17:02:16 +0000
From: Varun Prakash <varun@chelsio.com>
To: Fan Wu <fanwu01@zju.edu.cn>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: cxgbi: fix retry_timer use-after-free on adapter
 detach
Thread-Topic: [PATCH v2] scsi: cxgbi: fix retry_timer use-after-free on
 adapter detach
Thread-Index: AQHdK5IwpbYmD1bH0k+Cj+X3YGka17aloXmg
Date: Wed, 19 Aug 2026 17:02:16 +0000
Message-ID:
 <IA0PPF73BED5E3239E194B4F9B40502B84ABCA52@IA0PPF73BED5E32.namprd12.prod.outlook.com>
References: <20260814020948.197655-1-fanwu01@zju.edu.cn>
In-Reply-To: <20260814020948.197655-1-fanwu01@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-vipre-scanned: 0041BA9901B67A0041BBE6
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=chelsio.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PPF73BED5E32:EE_|SJ2PR12MB9190:EE_
x-ms-office365-filtering-correlation-id: c93cae8d-338b-4e03-4edb-08defe139f3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|38070700021|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 psAxbbWJAFg5WpD6vfwXna1FIXVPTygODO2dEW1jFGltlKg6gW3wa3F+LjZZhjoHFDNxchtRtV06HJggMGtDfd1hUpR2UwczELE2l0I0zKPYUgsDCbhhBmRdkQl3LmExBB/bQ1iw4wh7oDUoRhVi2agts2WxG2b5q3iDpqaLzinMXM3eT6BUZtOoWNxO7qj5m+t4YBt4m27qKOJbD0OAEne5mMWfifD0Wro8ThNsEMVSs/8aJgGjJ17D2DVvZ8Q30GW3Use7E45xw45NBhdrOifbMUJ9DVtBLg5rOVj/r2WR28gp2hAvQQWrNt+9Zmr1szbqbmAk33jP/YBhlUtc/zTucFj9i6T85XUx9Dbornh8o7fpV5caeuhx6SCyVGPqau96DlZlf5JpgpWhknzj4TokItV3nxv6IHczH+Un0hicBTAzuSW/rqKCEB1+0xyLAS8g8F1WrVEMRKVKElYPUVYt3Mv5hFO1ccz80BKSN9mRWCTE1XWhjK9X3UwM4/KIu6DKWjH6Nd113GRTj3stWBJIwGBAB2rgL3NOjFiltkrT2YdysK3I4tDi7p1Hch4pP590aVUtedXPd+2cBsyWlqlay174meglv3041bB5VvIbDPDJaqVcpnfeeC62gQsOxh7hHNGHIyK30eiPAnfGsUKNr/Bc9Y1mf139PUgPb2uC21PaU8iBebcdhjoM6WYgYI9Dv+15/cQVWj6Kwu39pQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF73BED5E32.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(38070700021)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4m+jVHezpxvaBDH6w6R9fvHiclbrxYyQ07ekDEh3+L9lbzlBS7pIWXdoV4Fc?=
 =?us-ascii?Q?mJ1Z3sQVmbpYsvHr3jqHSnU5IBgnmYcjGqboRUZ/cGFonaToplRM5sIrlqQ8?=
 =?us-ascii?Q?taeAT3zrPRHB1L22/s1wkk74aST/i0M6hq5Lev1TEwpvxU4bteJa3hsAorjO?=
 =?us-ascii?Q?0w2/vkn9fnOjfORiMPdW3A3f26GdDJfmVho0Fi/FECJ7xzpqpwMRtgjU5ZBx?=
 =?us-ascii?Q?Zq6zN7IQlo48uQvwv39RH6RqqcXMqrz+V48eKqBclYYX0ZCgffC4WE8MEhJr?=
 =?us-ascii?Q?K9B30noIS4nMFsMWfnUA3YOqSL8kQMx3D3GfDe4w5+X6CTVwB3Lp5sZIjGxl?=
 =?us-ascii?Q?FlAvQgWYddVM1ilYMP9DpUITtowD2gd5PiXIG+x/CU/G3PvpnIFuGXS5pkKs?=
 =?us-ascii?Q?IrTa8zXxAIp2Q+5qN+VY8TTzGkdmDld687EJSsRT51v63uotbu9MwWdwwD83?=
 =?us-ascii?Q?f7J/YXHCGanoxA/y3AUpAukJxuKqqh1+pHb+T/dld0pua36r9gJXj09mQQ0a?=
 =?us-ascii?Q?jaWls+0rPvgM7TDy4O25rnD75ockt/sYOSI+hdzu3uwpKsMm++DCnX1M2aSe?=
 =?us-ascii?Q?CTavNdoVnc/pXzkpQOuElfWuCpyL87KxTm2DzXlFib4ReVKQbdECHwlTkPvM?=
 =?us-ascii?Q?axN2N6ZUzRSl6YuBLf84nIcAKmCyWVi8OhlSBWvlKapscX4vuSL73fPpKt5S?=
 =?us-ascii?Q?igKD3ca3e/KWdMRDOdLIiGN1xIARSCJSLsZMGyorpxtVfQawq7fdvH92XscY?=
 =?us-ascii?Q?j2/k2uNTmF1ViOzJ+Vf3Q1qYJwOGzILEkG9nX/sSc+fHIkV44lcsDNlUh1h4?=
 =?us-ascii?Q?OgY9Z6jpqERZETFOqLDDiTtQKHvO7+pCP7FrGauQpbgJXVlaHbA+/rxxQ6qv?=
 =?us-ascii?Q?+gNy6LEF7gSua07iRgyfS89qxPt/MBNW+Mues/FoA7ia9OLCM7t+okgAxBiH?=
 =?us-ascii?Q?EJaH2CGTsrPtOAUsSvKdaJDYL0peXEchYloyiu1SmJaCawaKiHmBXzYNoSLo?=
 =?us-ascii?Q?+lPKE7gBrGeP8JW6Ax5tRgPLFc4J0ZgYs7ExqNN7bgRTt2qDCxArOeRGQrhn?=
 =?us-ascii?Q?4vBrfmV1r0dCbOuQ3+4GWKnRkxsKTpvpp0u57Fq1QZB1M4Ud52fuxhFRXYh7?=
 =?us-ascii?Q?dqRRiWI+1FPPKsDtkqsaOGeO61I8scgn7CptHfA3BtggpIzyI1DALlpr1VJC?=
 =?us-ascii?Q?abRCPzodv4uK3osN+6FiSYXHYZU3pIO2r8zaZhz/tQbl6xn13wmQ1j0xhy+Q?=
 =?us-ascii?Q?Ig6u4MytL/X3rbsNa1XTW5T+Hwyd5+r6CkwcEcDoIoSG91uFdfkzY0JGiW++?=
 =?us-ascii?Q?64jn/pRrjxKHgzXZpVn00VvZW1/2h4zbyW0bJeSlNqqa4thNruu1/OtpIWan?=
 =?us-ascii?Q?Hvkb9vxtyvHz88YiJf0Xy9Ak04AuT/LJGOsdh62QCoQqi3hjv8rGKS5xOVAW?=
 =?us-ascii?Q?jGU1+qz5SJ44IcsyrdlBzOS0bmnrMEqWpJu3BGSHgXV1uIqwD8TYdPABTErH?=
 =?us-ascii?Q?IAHvdeq6FTA7kDNKUK+7sg8BE+6vpGNDDCTbTfJm1V0MN/1pAT2WC73K91y/?=
 =?us-ascii?Q?3TbU5HHAIXItkgBfONCvx9iy0sD3kT30HDvDs5MCxzN3K9PGlDK4pq62IrO0?=
 =?us-ascii?Q?eo2jJ8T3u/e9TQoo2LbRIEVWRy+m9+uU2INzVZ6oSx31PKojh/7aGJkZfSRK?=
 =?us-ascii?Q?rv+04mBNc1ffyhsG6mDoljGhBgm7YJqMddgUEVnK6Qq7UxURrJcAZJTWQxmY?=
 =?us-ascii?Q?fCrpFdzOoQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: chelsio.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF73BED5E32.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c93cae8d-338b-4e03-4edb-08defe139f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2026 17:02:16.2361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 065db76d-a7ae-4c60-b78a-501e8fc17095
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EL9q/AoGovI7eOssxCdkF3V93QzbKo7lEaMwO/BOe/02LP3EiV44Rots+7/SxGspZ2rww2qke/1jhfanwqT6Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9190

Acked-by: Varun Prakash <varun@chelsio.com>
