Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113858BF8;
	Thu, 23 Jan 2025 20:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737662741; cv=fail; b=ZBkri9LpEhDFFcnUXPOTFsgXeK8ggtTBiBp/I0dFKhkdKq8iv44xuj9pKcv+b52ktlMEvbxeml0ep4Idl2gw43/0E2bP4tqWWuMpJhJPDtxxIIGUjCYQQY3lR3LbQEFulXOtBu98+6NLwyw7tzlySQIFm/eAkuL6KzMlDMYrw6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737662741; c=relaxed/simple;
	bh=T8L3KxYBHL4tU4l74L75FzLnxllK6l5xLei/yNEMXBU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YK0FhPsaKaF0Et/HlFZ28Bj+anuWdCllBPv2VvbzUnWnPW9i2vHDsXZ4CqZJsh+XLENu/5p7iUSWMmkUydxYVIYdu9AHj4N5Pl3uh/FG6dTm6ayBKDp3bD8yDlj7bbh7WzYbHLPa5BgJCacib0FPjV3pltMu1wgLfE/k4qzJ9pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nVwrai5q; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AxZx3hN4; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nVwrai5q";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AxZx3hN4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737662739; x=1769198739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T8L3KxYBHL4tU4l74L75FzLnxllK6l5xLei/yNEMXBU=;
  b=nVwrai5qHnSSZh5r2qzMOp3DaNV95tYEAcL/EYbD0IdMoloznKMpCYdA
   /VFv9Lu8APJEZ7oQPfdH1djfB2/dBJBeY/e+/6+QfcDwj8yvXI1B0Qwh9
   gG44U6KXPscZeeDZ6Jg8R4XxU+eBAVe6zBJ+erfBhYgXqxKdCo296ZY0Y
   wt8A7utlBKKSqE8GWYntDkz4y8vsS1IaGqYMLNnbDE3VTX9Qbk3SiJdcT
   vQd7QUXYFy5oq9sC3cNgDVRVcBKU2UCQkHTrYrCppGaJrHtd5uE0s0xIZ
   uRTOxqkSChnU82u3xzzaD12EBEVYJTzFTQnmXBQj2pgHUedHYxg/UEWV9
   A==;
X-CSE-ConnectionGUID: sYJrXH7tR3yn1xkBKEpe+A==
X-CSE-MsgGUID: pg6/+61aRCeXgbnuDx5oFA==
X-IronPort-AV: E=Sophos;i="6.13,229,1732550400"; 
   d="scan'208";a="36046092"
Received: from mail-northcentralusazlp17012055.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.93.20.55])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jan 2025 04:05:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h93uwXFuCdc8TAx0YbJjW+4BuSwTsGXOibqpeWlwMkAR3sn2SFGkTfLG5xbXoe4hd/NNl+fA55wTtgyHsyJMvybuRNesGrZFJFvreIfFk5LAH5/LMWgV8czvyg0xOHX7emYfq8913DJEkC7ELLtarL9Q5aJVlfT9RtdcjXGFkvMM8sn25esHtmFqjALMWKXXa7RRP1neOrDSYqipm7k7BXCCyBPrKwiG7y4+NWeWpLU0Smk0XBiRo5/N7sTaG+TYM6XJ7LQMjWnn2cDZ7lnAsKeO7fF3GTphcdDB0sqbfyBxmV1rdfgyXZxFet2a2iqCKi8dcrgSQaQsUQnRqYOIKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbOekc7it8A2K9T5uabQiGxGm4fEjKgeiGjYHAL9YTc=;
 b=NxsXtY0Id9hx9OtJjuxRUFE4b5l3jIGNWNf3wVEMKdYbbbWI1HD7WOzM9FEWzQd5SMiQU3oT1iG2GDpZULiTyy/OMkSu/9eXNSMB3smcLLenJc9l/IXFuGxuYFBxPUL7/BSgrxEzt5ETPQ80XLkCnz6VqojAYzc0Qbqq6QCF5dndUx3wpAyhQlUE0p/docPfDYay/tgC0nYfHZ32fbRoZYO8YtGJnPns+6n2FNGVpK2uNp+qyRxZXZTBK5T2JXtfVpwRGrGnS3ADpAiG1Vcr8aCBofyEw2iIT0LFfCtk+EBUptNBNoYvmBSswvp5IBj4CeudcbJM2JyBtlawBf9SAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbOekc7it8A2K9T5uabQiGxGm4fEjKgeiGjYHAL9YTc=;
 b=AxZx3hN4c3rKqIeA27xLWoQGg2UANYbe1iYawksiNk+pYODXsCTdtZvuJFEkEPNJxsRN9xJOvo+wXXRi1Lts4Mqa2U9X+/6yCQsOs1i8HgrHggKg3mpTdONK8ROMYxjvKt761SU9EAvBOft6LlbrUF5DGc89YPA0E92+Dp8nRFs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB8102.namprd04.prod.outlook.com (2603:10b6:5:317::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.17; Thu, 23 Jan 2025 20:05:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.009; Thu, 23 Jan 2025
 20:05:28 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Avri Altman <Avri.Altman@wdc.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Bart Van Assche
	<bvanassche@acm.org>, Can Guo <cang@qti.qualcomm.com>
Subject: RE: [PATCH v2] scsi: ufs: Move clock gating sysfs entries to
 ufs-sysfs.c
Thread-Topic: [PATCH v2] scsi: ufs: Move clock gating sysfs entries to
 ufs-sysfs.c
Thread-Index: AQHbbWmQabQZhCVjDECnLCly6HK4AbMkySOA
Date: Thu, 23 Jan 2025 20:05:28 +0000
Message-ID:
 <DM6PR04MB6575F7A24AB09B91A4DC5A37FCE02@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250123073359.3809072-1-avri.altman@wdc.com>
In-Reply-To: <20250123073359.3809072-1-avri.altman@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM8PR04MB8102:EE_
x-ms-office365-filtering-correlation-id: 57ca5676-92b1-497f-550f-08dd3be94898
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?fh1vHIIMZ8T76f24kJY0MgYA9YpcN/Jf4Ikh8RvdtamPHEQyqHto4MRm1LM7?=
 =?us-ascii?Q?ZSfbq+wyDTSQU7WV3kMIVoonBvmRKmwop1q0t3NsV5JesxP7WcZETPBRsjXM?=
 =?us-ascii?Q?alcfiO5I5rJakLxvoCm6N0wEgAeT564FljY54zysfu8ISZS3y847vHfmI8g/?=
 =?us-ascii?Q?A0ZUwV9hMp/5SiJkgPRE62QPLnCXkv1MMz6DmlIc3iYYdNIq3KUxbrnFPrUj?=
 =?us-ascii?Q?3XXZqWE0JnBTQw8l6D09rzA6/NjvK62fX76hww7Ap0V8wKhSKH0p8PSZq72V?=
 =?us-ascii?Q?fKEszlZzg/Ej7YNvXHU904ntV15J7MRhPd6FmRonCpOD3Y21EMU7qyNgP4M8?=
 =?us-ascii?Q?IkcvcNVgCI36gEBDnklgash8uqT+PntzdXRNQeGv7xtux3IyKxTnTuEMcn0s?=
 =?us-ascii?Q?S75tbKpq8PlPM0HuEDb1nll6OIejQ/aJ4UP2AJHMJycbZ+Yf6H0E48qAHVvD?=
 =?us-ascii?Q?7fjK7eGdGPynB8Lq2vRwjQ29utFK+nTqFYdvBjShYs2l/UwiMf2SSXZogzhh?=
 =?us-ascii?Q?u7aL/ZGcpm4L8cIt+u7BHhJ+aJ4L3wlpdvg5En2dvqezjWvaESojpea9xCs6?=
 =?us-ascii?Q?k7kQ84QyosQQpACvr0djzDnNRNW0zbgAhwmGCWsI70g7SoMoglYPeD29kzP5?=
 =?us-ascii?Q?zUryzvumfmONyooOioBDj93AhBOLoiE+67Mlhqbw8+CazR9LVpvh8P5tm1Uz?=
 =?us-ascii?Q?Oe3gwZR3tbHH48b3GFtdxA/SzByU3aUD+6Ye6Wg9sdiO5Hf9HBjrLucxWPRt?=
 =?us-ascii?Q?1B3s5L3i9aFtb3ZhqLO8yE3m/NaMwwYDwdk2FNvRD5VbGChMJG0O1lG7pg1c?=
 =?us-ascii?Q?2VhW3wfyMeZxfZRRNXKCRveJBJGb7hOClNYc7PuDTOHNQ13TzABGymZJa6uL?=
 =?us-ascii?Q?Yhk7/VkfB8QgKJrfBjkotVcrrQDIcvHSbRUgDFdEVt8lKGHB2JkUN4j7IQEB?=
 =?us-ascii?Q?WAfzrZ2GJV2oDpaxv4efcC3hGIJlCO5Nm7K0I9+bKD2l2yzgmGdV9x2FXxHm?=
 =?us-ascii?Q?E4KYQ3ZM9GKBtYFKJ4DNc3iduFanI/uTkk0uf9vNKD6fE2o7cy7aBK0LqdIT?=
 =?us-ascii?Q?FZGydwo/yGcCvsD8+HrWCpxijkaiI2Cki5iTzH2QVJka1esr//5XXbjPGeW5?=
 =?us-ascii?Q?c+kFa1vXvZgd6K0Tr96QVhewAM/JMfxYnNeI6PKyVEyqCZH9QLSFMrKTxGCQ?=
 =?us-ascii?Q?hDTTzYZtUCPakMhWEAQ/cx5jvlToGJLQJyupNdDvR5zmQD6IYSHZTIhvRlpL?=
 =?us-ascii?Q?XnJ+Z2X/MVVwRWQEuUykBPXDrlV6WKfUC2ZkJ+qneQkkBVtxlS7Gsb8Xix9P?=
 =?us-ascii?Q?ciReEZchC7DqI7sbUQ11WTWjd+2KuvnCINfa6nZiLocGH1A6b5AGK15xGTiT?=
 =?us-ascii?Q?Ii5602cZ8LGhBfWjLL2Kd7aRcLl0YWj118QlVE5KEAOZCVQsW+uYJLo9yLCM?=
 =?us-ascii?Q?hputJs/JXUw20UmibMbP6FXXuUZPDC2B?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oPxtZucxKQ0SPO37oX8qo9+45SfTFCg7VrdgaaXBaQe74rMO/CXCr0CBXiKx?=
 =?us-ascii?Q?7rAWgx9+WgJliFi0U57nf+Ju+2E/hHSww4JL6DoB0VE4uOKDdXO4bkaubckx?=
 =?us-ascii?Q?z1HrwEIWQYSj81lrCGGp+hfKO7pBeQ01fb+AyRI8zFgEV1cwEUZ21/1CGRV4?=
 =?us-ascii?Q?7NfKTGCu2cqFBmKnoXHPIjnAxmYwIiGHi3PyWpXfNHeTEBs1ad3n+WoSZH4M?=
 =?us-ascii?Q?2e4di7+/ejqKS/mS9ljCyfL7gsOoyu96LRnfNwnoK4FOms+ZCztLTR0XMd2M?=
 =?us-ascii?Q?aPq0oKSBfiUHX5pGrdXhlAm+E9/NFkerJtW8VTg4MSWjwiH3P1wfNFI5fKgW?=
 =?us-ascii?Q?/cNE9xDAe6gawsCdKuVakwd/+YbD7xK+mR5v7hFcVJXCNG9sMNwcT4RIOFqY?=
 =?us-ascii?Q?7DUyvij38mzJzuC2vKKafEsUhN45vlOZFB5pYCnrWmAaoeNei2oA7G5ZCNwR?=
 =?us-ascii?Q?JQbwR15Qz0I2ZP4LZ3Dm4YgY4sI1JwrPae2Ee+gzed+X4MZgK1pjaVX6/Bkb?=
 =?us-ascii?Q?UOqT7Od1HnFmzzVlhkF/PW8Kz/nPhisxN5E4AgNkP0CV8PAsYGogLBGnJ7Hk?=
 =?us-ascii?Q?xzz7H8jZRUXyHPOd4Vbp2dVjIFNx9ejFQ5ucBawEVWzpOY5HPJwFVVW5Ex6N?=
 =?us-ascii?Q?8IJ31Cj3M2qlriBDTQQ/+lfYluOCNh+4svCkyJ5e6VPd8jyIXHG2P82IJtW0?=
 =?us-ascii?Q?S7doS8L07Rx/16pZ4Y5Wj6B3gA0O7NUH4rAKMwtB9SydZXvhlnBYAkFq8Xmy?=
 =?us-ascii?Q?cFcVdx8qB88O8XVJSHOXZAcPXyP75Istj4/vwEGHRmZI97UIgVbRrgOfMRj6?=
 =?us-ascii?Q?gV1HQO1GzCEezORbbiffZKRtVNkNObc3kOx2W/EUwOr8PDWvPJIisMMwEEJ9?=
 =?us-ascii?Q?otMqn7Hy254SNWeuVEn12pV5tec9lsrot5kBhG5GMRCcwu96Av+G8Fo5bzAu?=
 =?us-ascii?Q?N4DCCEy7k11E12E9jlOqmVNxCe8wOPqGepZjLtLZybE0/dVydkbRT2FfEo1n?=
 =?us-ascii?Q?7g6YsAKRJgMFJuQQejSINBcyZSvfhkJ+CHdjk5Q801sUD13tve8fMzvEzEks?=
 =?us-ascii?Q?ND2aN/Ig9c/CcVhoi7xWANfH9CrXIeDb8fTX6Pn/PSNb/kbsTmbYdJkOstud?=
 =?us-ascii?Q?fxKntvLgCiGgSNxQwgW/QGig+SwOH3aT3LZy/5+rpJdS3pl36XrR/lhPhNgY?=
 =?us-ascii?Q?cO3+cAy2PlrlOQ0SRwOAaha2u2ameRtxWBzRaOwdtdm8hVIwVZunm3sy7blT?=
 =?us-ascii?Q?66pnPZGgbUr0Cg1jseJleHuLBwhziQsOwTodAJ7cN15ux4UriOSoKFjDeZA0?=
 =?us-ascii?Q?89eIJLkOhmsl9J6vOpHlZAKag0Ax/EeLUr7G27fH+8pABlwSLupR8yDt6E4W?=
 =?us-ascii?Q?rURNWUZMBvqX7C7ZEYLXKlJZUJFT5RU4tCglZU4PGWk+iJU8gfhFRrZO5YoZ?=
 =?us-ascii?Q?+ywYOrSgUvBdxo33L66QOIKNUXR5ESRi7wzaPXMAv/1M87wQAN4QprOu3yQu?=
 =?us-ascii?Q?mwH/AupmtQfkyqPq99WGOHw0vaTTHODqgYQW63dAjN3m/jfGRi4M1HplHUyn?=
 =?us-ascii?Q?X76IBzS7ItYZfxhfE4VEeZmAYB7A0UihZF3M6uhv0czvZtLLdZNjGiXNg3Qq?=
 =?us-ascii?Q?VxEkaWrpq0k3IvZcTKpwoJS8Il9fHt5+vb6MQVfXlYxv?=
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
	kJoF0GVVGgvNSNfRyDMlUW51BZa3eaYTWSVZd0ShQMgZ/YJZ+I1UUA9tIgq454NC0oaUlChpKYKyBkIj3XG3CDvWq0xhzfYG4VLZ6RbSgdui53amnPHbmjjjvrsJPKWwcnq87W1s2OOpPpZKUSqxcQJoHuIoppuSn1qX2T+2HF+vIz6Sf/hi8PbIYwAvijmYvY/YUmYFpib+rwfZe/Uuxu3kRoKVIiebSFRKuEtwCae0FDAM3D8e9tyRpwNwXUmTUECNwXh5seWDXSSsmqYFnzy8uzPNXNA/12RwVGWY4lYepoIpmobw8EgG73aFIWm+aYdtWrvYZ3TLu/XAJuNtm3cXlxBKpDZaHxCQG6AqaXugRLJJ3daCabkwT91DTqmtdRXJU6Qac1k2JgkTxjc8ovd774hdpB12a392vEIy2hPuzRyAO4GTLgWkx1ZIZ0gIEDN4kO79wKmGWOxa+OlkM6j5MJalrXca6tsAz01RmXUkPoO3PMCsCou/wkYTiyklhCB02TlmzJfDwiqOs1zxKCpVIMY6GAZAK1UE/Wm8czYZM8Wz3/BCvaWujkd1brJ/ZNsPZWJNRGuxD7dHZZPIUtvq5PqVqunrk+RT2TezyWfxR6HhY3i5mqsqlnGqkO9J
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ca5676-92b1-497f-550f-08dd3be94898
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 20:05:28.7411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nOgx9xNul8haVDnGoVaxAzhVLbUioKzfsh42pFs8VWUDHqxmSRD7harXfmkt7QRPxisp0NS+vQVzrLH0cvldig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8102

Martin,
Please ignore this.
I want to bundle it with another clock_gating fix.

Thanks,
Avri


> This commit moves the clock gating sysfs entries from `ufshcd.c` to
> `ufs-sysfs.c` where it belongs. This change improves the organization of
> the code by consolidating all sysfs-related code into a single file.
>=20
> The `clkgate_enable` and `clkgate_delay_ms` attributes are now defined
> and managed in `ufs-sysfs.c`, and the corresponding initialization and
> removal functions in `ufshcd.c` are removed.
>=20
> No functional change.
>=20
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
>=20
> ---
> Changes compared to v1:
>  - Use clang-format instead of checkpatch to fix coding style (Bart)
>  - Use kstrbool instead of kstrtou32 (Bart)
> ---
>  drivers/ufs/core/ufs-sysfs.c | 58 ++++++++++++++++++++++++
>  drivers/ufs/core/ufshcd.c    | 85 ------------------------------------
>  2 files changed, 58 insertions(+), 85 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 796e37a1d859..7183709603ae 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -458,6 +458,60 @@ static ssize_t pm_qos_enable_store(struct device
> *dev,
>  	return count;
>  }
>=20
> +static ssize_t clkgate_enable_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
> +}
> +
> +static ssize_t clkgate_enable_store(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	bool value;
> +
> +	if (kstrtobool(buf, &value))
> +		return -EINVAL;
> +
> +	guard(spinlock_irqsave)(&hba->clk_gating.lock);
> +
> +	if (value =3D=3D hba->clk_gating.is_enabled)
> +		return count;
> +
> +	if (value)
> +		ufshcd_release(hba);
> +	else
> +		hba->clk_gating.active_reqs++;
> +
> +	hba->clk_gating.is_enabled =3D value;
> +
> +	return count;
> +}
> +
> +static ssize_t clkgate_delay_ms_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
> +}
> +
> +static ssize_t clkgate_delay_ms_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0, &value))
> +		return -EINVAL;
> +
> +	ufshcd_clkgate_delay_set(dev, value);
> +	return count;
> +}
> +
>  static DEVICE_ATTR_RW(rpm_lvl);
>  static DEVICE_ATTR_RO(rpm_target_dev_state);
>  static DEVICE_ATTR_RO(rpm_target_link_state);
> @@ -470,6 +524,8 @@ static DEVICE_ATTR_RW(enable_wb_buf_flush);
>  static DEVICE_ATTR_RW(wb_flush_threshold);
>  static DEVICE_ATTR_RW(rtc_update_ms);
>  static DEVICE_ATTR_RW(pm_qos_enable);
> +static DEVICE_ATTR_RW(clkgate_delay_ms);
> +static DEVICE_ATTR_RW(clkgate_enable);
>=20
>  static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
>  	&dev_attr_rpm_lvl.attr,
> @@ -484,6 +540,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D=
 {
>  	&dev_attr_wb_flush_threshold.attr,
>  	&dev_attr_rtc_update_ms.attr,
>  	&dev_attr_pm_qos_enable.attr,
> +	&dev_attr_clkgate_delay_ms.attr,
> +	&dev_attr_clkgate_enable.attr,
>  	NULL
>  };
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f6c38cf10382..901aef52a452 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2019,14 +2019,6 @@ void ufshcd_release(struct ufs_hba *hba)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_release);
>=20
> -static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -
> -	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
> -}
> -
>  void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> @@ -2036,79 +2028,6 @@ void ufshcd_clkgate_delay_set(struct device *dev,
> unsigned long value)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
>=20
> -static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> -{
> -	unsigned long value;
> -
> -	if (kstrtoul(buf, 0, &value))
> -		return -EINVAL;
> -
> -	ufshcd_clkgate_delay_set(dev, value);
> -	return count;
> -}
> -
> -static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -
> -	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
> -}
> -
> -static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> -{
> -	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	u32 value;
> -
> -	if (kstrtou32(buf, 0, &value))
> -		return -EINVAL;
> -
> -	value =3D !!value;
> -
> -	guard(spinlock_irqsave)(&hba->clk_gating.lock);
> -
> -	if (value =3D=3D hba->clk_gating.is_enabled)
> -		return count;
> -
> -	if (value)
> -		__ufshcd_release(hba);
> -	else
> -		hba->clk_gating.active_reqs++;
> -
> -	hba->clk_gating.is_enabled =3D value;
> -
> -	return count;
> -}
> -
> -static void ufshcd_init_clk_gating_sysfs(struct ufs_hba *hba)
> -{
> -	hba->clk_gating.delay_attr.show =3D ufshcd_clkgate_delay_show;
> -	hba->clk_gating.delay_attr.store =3D ufshcd_clkgate_delay_store;
> -	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
> -	hba->clk_gating.delay_attr.attr.name =3D "clkgate_delay_ms";
> -	hba->clk_gating.delay_attr.attr.mode =3D 0644;
> -	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
> -		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
> -
> -	hba->clk_gating.enable_attr.show =3D ufshcd_clkgate_enable_show;
> -	hba->clk_gating.enable_attr.store =3D ufshcd_clkgate_enable_store;
> -	sysfs_attr_init(&hba->clk_gating.enable_attr.attr);
> -	hba->clk_gating.enable_attr.attr.name =3D "clkgate_enable";
> -	hba->clk_gating.enable_attr.attr.mode =3D 0644;
> -	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
> -		dev_err(hba->dev, "Failed to create sysfs for
> clkgate_enable\n");
> -}
> -
> -static void ufshcd_remove_clk_gating_sysfs(struct ufs_hba *hba)
> -{
> -	if (hba->clk_gating.delay_attr.attr.name)
> -		device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
> -	if (hba->clk_gating.enable_attr.attr.name)
> -		device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
> -}
> -
>  static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>  {
>  	if (!ufshcd_is_clkgating_allowed(hba))
> @@ -2126,8 +2045,6 @@ static void ufshcd_init_clk_gating(struct ufs_hba
> *hba)
>  		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
>  		hba->host->host_no);
>=20
> -	ufshcd_init_clk_gating_sysfs(hba);
> -
>  	hba->clk_gating.is_enabled =3D true;
>  	hba->clk_gating.is_initialized =3D true;
>  }
> @@ -2137,8 +2054,6 @@ static void ufshcd_exit_clk_gating(struct ufs_hba
> *hba)
>  	if (!hba->clk_gating.is_initialized)
>  		return;
>=20
> -	ufshcd_remove_clk_gating_sysfs(hba);
> -
>  	/* Ungate the clock if necessary. */
>  	ufshcd_hold(hba);
>  	hba->clk_gating.is_initialized =3D false;
> --
> 2.25.1

