Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6039E1448D5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764137144; cv=fail; b=q49aeiYLwaZqqgb0dmabLkLK5E43hEkL4vOy95mea0jevIABM1WgtHQipPXCEtO6MVoT2sVcBm9DA7CAh6i/ea9PG/DZnGgQlXKhLJBBvi4Ktvn8nZnxzMxyRvgJmmk7SDdoHw0ozUCpVdn7NDzW2thXstOvBUhbuNaQQbPZIng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764137144; c=relaxed/simple;
	bh=8Afd13sYZ7Z2Mbp2adKxUT+YgH0OLNe4TIwoai7rjfY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XODLuMUBnJsTLNwyrct8ygatGqODhjuJwedzdxFZ9bdqKCrcuoslw6iQ50unF/36OZosMP2m+o7xlvEUrr8lEgWX1ToeXyevZ5x3gLlPQTfuwUz65bneZU6FdgzkLPt4mYYI/RLcZV2xqPMEOj5PtyXNozO55ZKzHw/QaIXQU+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=VAOU8ocr; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="VAOU8ocr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1764137142; x=1795673142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Afd13sYZ7Z2Mbp2adKxUT+YgH0OLNe4TIwoai7rjfY=;
  b=VAOU8ocrAircOWflYccGIPeJtQsX+Lnu8aL8KCjSOdIlP5CsiIcmW2QO
   VkHPMZKt/vkCzcgFEMKS+SofrF1THFV5hpfltBqbcAqwtrkVv1wiz+gQ7
   5LiT4n5uT22HrY8f7yytlLzeSTH/bMokI+FXsJRmzBtgsld5U687mHJ0f
   8fiQDmyBCvwCrsNBfbVlxpOz1hYisGEcvyyXzSCpKbP083SRIJx8D9omI
   XBlclvbTbd39f4+qjwOg+xVbXdeYIofaZYy0yX7VlCE4Np75polfuayx1
   pwACLIzHqlFjQMaEtIE5Em6tghki8C/2GrEtybryQjlPvwNHTGM9h2Olz
   Q==;
X-CSE-ConnectionGUID: j4plCfq4SCeOWPiZQr87mg==
X-CSE-MsgGUID: CKRo5tS7QwWw61p+2unAKA==
Received: from mail-southcentralusazon11021077.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.77])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Nov 2025 22:05:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIhdowylIhBLwiEA1zLNmYu9o/120/0UjEfjNgqHHWg5pdWFohMZDBd9Nx4PnfS6Q00Ml0wGp4pl0qdzUewzPeA7Ug1cfNhyjWUxJDJsmOp3Ch3hiSzPEkDxXhygTzDMryELHlS+5yZjxdeg5uebzcm9U0IrHOSRhVl9GADXrWh2MHCoZ14xNrbVxjTs12qk0v2Hqws6iBv+GrULCiIKCbkxLJiCoFZpHbCJrQVAnCNIu0x3XslveRwW7sm8rMEXQAj9+Z/8PsMEQITvS9/P9vEliz71Urow/72VVM5rfoY316Avnn+Jh7MQHwOGefrcqQldyYg6S1Ql6u55mIwUkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clYjVHapMIcDgARcX9CimTM8GTryCDcl/RdlpWdalDY=;
 b=YIb+EbUql1UQ/IgSWaoarwZgH54iS4I8r9z34/GA/i8JXPAadiU0JNtNMDrW6RAdWboUIA7dw8ibPpbgEQyXAh9nOqT8i7fdli283MHCBJfbo4wAPSG2myJpiMkmUJsnIfeKpTIOFtDNtOjfWHzk/TBjuTXmirRE3ZC1N+tN/z/KgtX0Wb16bI/0IV1TOSMbckyjTXpR6v3l9r30hzKmaL1uCwku5Qu2rQVn9f0aZnXJ1I4HH3k42B3tAb2tiIq9il2AFY0v0jh5AKnuwl7FjCAjyY64754wXj98Ys9ZTk4aW9PZ2W27cX1Kzz44r5lOje6lExKlJeDDCIf6cFF43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from DS1PR16MB6753.namprd16.prod.outlook.com (2603:10b6:8:1ec::5) by
 CH3PR16MB5428.namprd16.prod.outlook.com (2603:10b6:610:166::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 06:05:38 +0000
Received: from DS1PR16MB6753.namprd16.prod.outlook.com
 ([fe80::72d7:97b5:4539:a90]) by DS1PR16MB6753.namprd16.prod.outlook.com
 ([fe80::72d7:97b5:4539:a90%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 06:05:38 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Shawn Lin <shawn.lin@rock-chips.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: core: Remove the alignment check in
 ufshcd_memory_alloc()
Thread-Topic: [PATCH] scsi: ufs: core: Remove the alignment check in
 ufshcd_memory_alloc()
Thread-Index: AQHcXnme0sef4pCdsUKDwInIR/pzSbUEdpqw
Date: Wed, 26 Nov 2025 06:05:38 +0000
Message-ID:
 <DS1PR16MB675374C98979E25FF23177E9E5DEA@DS1PR16MB6753.namprd16.prod.outlook.com>
References: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
In-Reply-To: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS1PR16MB6753:EE_|CH3PR16MB5428:EE_
x-ms-office365-filtering-correlation-id: f7224dd7-4f3d-40da-5003-08de2cb1d28d
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ojaR6pbIDGquJGzrwG+vvhZPH33x6kyj/nH5mLgkTJW3d9WphXS9C3a+nmvX?=
 =?us-ascii?Q?6carfuO+tXDPu3XPlxd4i97y75lFQFQyA1Qy4kR2fhsbHCXclJbInYLCAkfE?=
 =?us-ascii?Q?l3tJssFNCXvesU2eFjTzu2JgkN8c5A5mBVK3GHU4S8zmhM3YJItJ6LDJZceK?=
 =?us-ascii?Q?iemkeleu5Sn2n2xxRi51m11ZRTunUsBNrl5EsGf3O4zMmcjuadkB07x7sBT7?=
 =?us-ascii?Q?QQUuW2druN86gRsCP2ZmsCbhIvKXBi+c8eTRx0/BIAmUQbh36TVrd6wiM/Rv?=
 =?us-ascii?Q?lar+1DQruecbq7sL1o1m7n0hJiazG6Mdd45k8eTCu24hpzTLs5uUBS1IMhoK?=
 =?us-ascii?Q?Hz30aC9+vbhj/KBHA8I+0DoVfjfVg137Ip0eMyGWpJ0qcQMfg9H0ILqADoWt?=
 =?us-ascii?Q?QWQs5qL642/fl/1uyRs0BNPJVuFZnDZ4WDzZWJh4eFfiD+7Ne4a2KDJoiodX?=
 =?us-ascii?Q?NAI2nLVXRqRrYR3L/JtadGVpEN2tc8l93rX8b8GwI3vez+K7UxE/gK8+0faH?=
 =?us-ascii?Q?fxTkJo7PxMV2jXEjO9ltXsdK2o5l/LCQGY3hkKw65K301b8Lc6hAbQbToLM/?=
 =?us-ascii?Q?d1EyWHoriO69/WT07pBRvxbDi7FeziPy8CUHU+p80uwwjpBH8YZsEIyfiTXp?=
 =?us-ascii?Q?F1YP7p8XpoX50aKEQg97SIpXN5FjINT3NfVKokf/fU7d2bUcj31P+opShJfp?=
 =?us-ascii?Q?ruj0D6MLgj7SUoZpD7DZ5zEM0TaiZh14YhT5oQNbxrHjtt8Z5rkaT4Q/RiHk?=
 =?us-ascii?Q?TGnIMaYbgO+Zp9tEHcU7AUT71PQf86HgHUew1OUrJRLQTGIvGKMcKnyeiyk9?=
 =?us-ascii?Q?Sl0HLy66Je4lg71eQFnslLzFJ/6/B851Swf8k94lo+zQ9U9Ta3X1X0qfvIOP?=
 =?us-ascii?Q?8erb0WE3097SCZ6CL14NwbYFVwjIIBlg3+bDx8z3rLkiJTke12Fu9VY/hY8T?=
 =?us-ascii?Q?6HEzj/DgBiv839RuGsuw+7h7lXc40u4U8b1jsmSlDAaXWi/HUpGLfRE1LU3c?=
 =?us-ascii?Q?cYxV4GMOH5nuZeuAV0WDzMWbl3VSAWUQ9IZStSiAcM+7O850RClUQnHH8tuF?=
 =?us-ascii?Q?iByQvqGsROIvVt/vudha2aK/Ip98D68A4FkBMwDagz8x30k3Y1I7oU67SXt9?=
 =?us-ascii?Q?XBBmlDtlc8XTmR614X9bt5HNhVBJ1X8xVFTtIy52QzpqwWuMCECqsMoCHlVt?=
 =?us-ascii?Q?x72eI6rd5/Z1xQQo6ADA5dcRHDpGBmH6P3suGWEhMmNil31EltCwLIt5PVes?=
 =?us-ascii?Q?EHVsFE0VpZ0d2v/isdA6p8ulDyvnZ1zlkxBb4ZmtICVRwFWBMUQUno2HlQSk?=
 =?us-ascii?Q?ZYAkuPm1uJBmn0oEilg2eTn/9aulp0QG8lTFqyUWlTin8D2UqH23WMjCwnJL?=
 =?us-ascii?Q?qpxqBnw6hLccbLLANMbdHnULzxe0l3sHB3cAbxBqYQCx7LNnwpV8vmwbUbGA?=
 =?us-ascii?Q?5ovYjdr7R0i2dYuRi0umUwKGrjzJALHtF+NkdIS6s/qXPuQRJtpL9Qm2RHt1?=
 =?us-ascii?Q?u3yN/j2PPZyIC3kuzudate9FEBpbW2aQRG8P?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1PR16MB6753.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?13l2ldWvBOk6oiw3kl/YWv+BXmFPX3/ae0Wll5asmaqG92FxLXIEt0JPpErN?=
 =?us-ascii?Q?1n5xZyOqiRrGTfyKi+0I7RY7onr1UwVdXR84AWRvBUx5ewXltd8mKAM8ZvFm?=
 =?us-ascii?Q?IcKLKpy+Wq5XliftosEP2IPWaDRwtTl4aIrvqZs1luOvslXrDnhmpVPTOeAb?=
 =?us-ascii?Q?l9zuTHUeWwBk4cRVZrPW2fKmz1OhDRnNV54CqC6wnBavbdBDAKzRM8lI1KSu?=
 =?us-ascii?Q?ukbpFq0mVbDinnE6Ues56w5oHkwaANZ4roNN3elZqRwUdFOxdSPzZ7dlaCIs?=
 =?us-ascii?Q?ZGCZ6KvqeEDKwHG35I60Cmo6+k7CfC1DaqCQgW0Mt9T7z63dd08k/aFkkXxI?=
 =?us-ascii?Q?mlxHUeWb2YvYmeC928a8PXI72N1wNrqnPTDkFiMNZbBHyG+sdZlvMkoZwXj6?=
 =?us-ascii?Q?JPJ4o+UC/qZZ9c7OiOnUydCnZcAOcRQZIV6JCLI1M3YhCZVYUdTUYZvbSgcZ?=
 =?us-ascii?Q?Y8h09PFHCkaSkA/wFCleb1awE0WqD27iJnPk4C11hmfrdCKkogy9q2iZEe/A?=
 =?us-ascii?Q?zut+qjrTUNxDKeqn6sOARsgn8bmyQiOPZKFEdQXzuWs1mbw16dE1l+lKWvFC?=
 =?us-ascii?Q?pa6O13Xaa2Fl+SYf5Bu9G0W2AV/w+zxp89heYH2LS4xBusZaVIIpv25l9ZRg?=
 =?us-ascii?Q?gFIc7hQF3NkUzrWalkqYZ1z8nF/N9tViKwp4f+xEOTnKvxuDgslTzx34WTwZ?=
 =?us-ascii?Q?7zUwpYkjg9qKM/PXT4TMRuDDoACEPUNeHAN+bwCKjhawhPnBzeymaZPMcJX3?=
 =?us-ascii?Q?3E0HGWhyfegx5S8JOEujXXo3BGNEGUkShRV9h0kelaT0U4UUYO/ldRVqmYOS?=
 =?us-ascii?Q?9BdHxPTWxFMHLCyvY/YHlw1LsHL8MJWVl+Eg3kxkk/PnujUuCYFnK4oIVv2s?=
 =?us-ascii?Q?3rvWk9+i+de75ICvVU47+X1Vaxj8J/+8qkbHtuouL1MY3TYWwiIaj4Zdy2wU?=
 =?us-ascii?Q?+3YhIZrQz33rLXDwq5pw7l/IXUNV7TrZbUJ2xUHVvu+vR/9c9w3qb7PpjTOs?=
 =?us-ascii?Q?pJSxs8dNaIfE7GdVa7DefXQ8GS8JOz8wrDggtaU0lAh0lzm+ybyEf3uwvNQV?=
 =?us-ascii?Q?J8hB5ZIIARRHhjxnbqtamk09pn4A2gjQrTg6AgL1JMoPsts1695QF/k/6oST?=
 =?us-ascii?Q?Fs/IGM+SBQCgAIXYf94aTUzJrtauuYmWl8hZ/QGsl9SyASdnNggsT5vGIPar?=
 =?us-ascii?Q?qxVDnpmOKi11FBf1hw/ecOqdEGzjpitRzU6KpMkyC3JmzZT6qATIyYHWcfiz?=
 =?us-ascii?Q?ogFr+XQmDatlRHA1Kpvv3mipJV1WOC05qqn5pvLbCQQrFgUnkC6oVjaPBBU5?=
 =?us-ascii?Q?lSnpc1wXG7nXpUCufunUb8j1lyjJDsUGr3wohBg48OHu4zmRIknTjpQlvxZf?=
 =?us-ascii?Q?/mUgyx1sSNihT95eD5vqOIqPQ9EbHjKgPydEtz8VdyA1vMvMDBeyUF56KpaS?=
 =?us-ascii?Q?/ZLAZMKlNmjU3h9y8fMW/GhfKcu4myBnCoKRyvoBZYchEK0Lc0xZUkBnfzt1?=
 =?us-ascii?Q?hlh6YjPpuXJBG92nmfOJM9fDXrgImqvRlvjpkK9DGlyZXTdefCcULtJry8mb?=
 =?us-ascii?Q?znbGikXCwY9QtsoO6YNxoU/isZeFkYLI2MRtCsTL?=
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
	aOO0KQJP5mlvPPuVlvmdqPfBN5m7vj4dNkSi7S+fx5tentYjPYVfKG7uE9c3TpNeaVDim4GFlpzgQrOVkqTC1rgSgdFGam/dU5GD6J7XbN1C5K9SNzV9gyLlepAgATxjazZWkObRevUYL+NzbmqMCRxF8WPSzmJ8XdrxaFb/Wz+X9JlqhGTFhPMBM/fjXUa8CSihANm2zfCUlYp72spxKxwx3z770AcD6jR6up9S5xPw987d8HUHsNTPtLCRElJt/vw7F16FTpw+OZ+Yd6QKiC13WkykqB/WuRVvLYTJJDeYiWbav3Uo4fx9TSltw4y8GDn3Zg4Z9gzIZyB83Ebm3zN9BiseUmdWQQYn+S01EWPKl6FOFYrQvwwub/TAfd0NQduU+cDPKTRFwAMBxD0dlNnXmuWoXQJsH5q9afbXaBB519zOrcos37MhOyGsUmOM4LGicXIvjagPztpgcQ/DFmRcQqgXG0va236ZmbIhaRCKi34hrIeePqX0lSw/ecoZ23n/OsJU+CeLkNu58jKbEZzRV/ZgRnli5/R4QJKktfdbXeuO/WJuo/6pyZrABbKP8fdQTPwgTuPzfg8kraECbwo5ckalmBgQT0r4czZMSWoEfuzrRpjLX+vtoMm0RjY3pGguOAyKthte0jiM1Z/zwA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS1PR16MB6753.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7224dd7-4f3d-40da-5003-08de2cb1d28d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 06:05:38.6048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gJ0ECkYFdXno/2mZk1BGskPwgcycM1vJcXVTjVstRE9hCehbb6AHTAX/TV9cnANyyEglE8lqr8/FKwPSeXuQZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR16MB5428

> The dmam_alloc_coherent() function guarantees page-aligned memory on
> successful allocation. The current alignment checks using WARN_ON() for b=
uffers
> smaller than PAGE_SIZE are therefore redundant and can be safely removed =
to
> simplify the code.
The commit that introduced those checks (339aa1221872) for sizes !=3D PAGE_=
SIZE explained:
"...
    In the case where these allocations are serviced by e.g. the Arm SMMU, =
the
    size and alignment will be determined by its supported page sizes. In m=
ost
    cases SZ_4K and a few larger sizes are available.

    In the typical configuration this does not cause problems, but in the e=
vent
    that the system PAGE_SIZE is increased beyond 4k, it's no longer reason=
able
    to expect that the allocation will be PAGE_SIZE aligned.
..."

Thanks,
Avri
>=20
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
>  drivers/ufs/core/ufshcd.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 8f68e305e83c..89737f0c299c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3916,18 +3916,16 @@ static int ufshcd_memory_alloc(struct ufs_hba
> *hba)  {
>         size_t utmrdl_size, utrdl_size, ucdl_size;
>=20
> -       /* Allocate memory for UTP command descriptors */
> +       /*
> +        * Allocate memory for UTP command descriptors
> +        * UFSHCI requires 128 byte alignment of UCDL
> +        */
>         ucdl_size =3D ufshcd_get_ucd_size(hba) * hba->nutrs;
>         hba->ucdl_base_addr =3D dmam_alloc_coherent(hba->dev,
>                                                   ucdl_size,
>                                                   &hba->ucdl_dma_addr,
>                                                   GFP_KERNEL);
> -
> -       /*
> -        * UFSHCI requires UTP command descriptor to be 128 byte aligned.
> -        */
> -       if (!hba->ucdl_base_addr ||
> -           WARN_ON(hba->ucdl_dma_addr & (128 - 1))) {
> +       if (!hba->ucdl_base_addr) {
>                 dev_err(hba->dev,
>                         "Command Descriptor Memory allocation failed\n");
>                 goto out;
> @@ -3942,8 +3940,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>                                                    utrdl_size,
>                                                    &hba->utrdl_dma_addr,
>                                                    GFP_KERNEL);
> -       if (!hba->utrdl_base_addr ||
> -           WARN_ON(hba->utrdl_dma_addr & (SZ_1K - 1))) {
> +       if (!hba->utrdl_base_addr) {
>                 dev_err(hba->dev,
>                         "Transfer Descriptor Memory allocation failed\n")=
;
>                 goto out;
> @@ -3966,8 +3963,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>                                                     utmrdl_size,
>                                                     &hba->utmrdl_dma_addr=
,
>                                                     GFP_KERNEL);
> -       if (!hba->utmrdl_base_addr ||
> -           WARN_ON(hba->utmrdl_dma_addr & (SZ_1K - 1))) {
> +       if (!hba->utmrdl_base_addr) {
>                 dev_err(hba->dev,
>                 "Task Management Descriptor Memory allocation failed\n");
>                 goto out;
> --
> 2.43.0
>=20

